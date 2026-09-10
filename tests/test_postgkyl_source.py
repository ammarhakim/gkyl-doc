"""Check main tracking against a local Git remote, without network or pip."""

import os
from pathlib import Path
import runpy
import subprocess
import tempfile
import unittest
from unittest.mock import patch


prepare = runpy.run_path(str(
    Path(__file__).resolve().parents[1] / "scripts/prepare_postgkyl.py"))["prepare"]


class MainTrackingTests(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory()
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.remote = self.root / "remote"
        self.site = self.root / "site"
        self.site.mkdir()
        subprocess.run(["git", "init", "-b", "main", str(self.remote)],
                       check=True, capture_output=True)
        (self.remote / "scripts").mkdir()
        (self.remote / "scripts/build_docs.py").write_text('''
import argparse
from pathlib import Path
import subprocess
parser = argparse.ArgumentParser()
parser.add_argument("--output", type=Path)
output = parser.parse_args().output
output.mkdir(parents=True, exist_ok=True)
(output / "revision").write_text(subprocess.check_output(
    ["git", "rev-parse", "HEAD"], text=True))
''')
        self.commit("initial")
        self.environment = patch.dict(os.environ, {
            "GIT_CONFIG_COUNT": "1",
            "GIT_CONFIG_KEY_0": f"url.{self.remote.as_uri()}.insteadOf",
            "GIT_CONFIG_VALUE_0": "https://github.com/gkeyllorg/postgkyl.git",
            "GIT_ALLOW_PROTOCOL": "file",
        })
        self.environment.start()
        self.addCleanup(self.environment.stop)

    def commit(self, message):
        subprocess.run(["git", "-C", str(self.remote), "add", "."],
                       check=True, capture_output=True)
        subprocess.run(["git", "-C", str(self.remote), "-c", "user.name=Docs",
                        "-c", "user.email=docs@example.invalid", "commit", "-m", message],
                       check=True, capture_output=True)
        return subprocess.check_output(
            ["git", "-C", str(self.remote), "rev-parse", "HEAD"], text=True)

    def test_second_build_fetches_new_main_commit(self):
        prepare(self.site, None, True)
        result = self.site / "source/postgkyl/revision"
        first = result.read_text()
        (self.remote / "new-guide.rst").write_text("New guide")
        second = self.commit("new guide on main")
        prepare(self.site, None, True)
        self.assertNotEqual(first, second)
        self.assertEqual(result.read_text(), second)

    def test_dirty_managed_checkout_is_preserved(self):
        prepare(self.site, None, True)
        edited = self.site / "external/postgkyl/scripts/build_docs.py"
        edited.write_text("Local work")
        with self.assertRaisesRegex(RuntimeError, "dirty checkout"):
            prepare(self.site, None, True)
        self.assertEqual(edited.read_text(), "Local work")

    def test_explicit_checkout_builds_without_fetching(self):
        prepare(self.site, self.remote, True)
        self.assertFalse((self.site / "external").exists())
        self.assertTrue((self.site / "source/postgkyl/revision").is_file())
