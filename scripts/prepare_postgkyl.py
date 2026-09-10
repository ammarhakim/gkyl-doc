"""Fetch Postgkyl main, install it, and generate this website's Postgkyl section.

An explicit --checkout uses a local working tree for cross-repository previews.
Normal builds always fetch main; they never reuse a pinned source revision.
"""

from __future__ import annotations

import argparse
from pathlib import Path
import subprocess
import sys


def prepare(site: Path, checkout: Path | None, no_install: bool) -> None:
    if checkout is None:
        checkout = site / "external/postgkyl"
        if not checkout.exists():
            checkout.parent.mkdir(parents=True, exist_ok=True)
            subprocess.run([
                "git", "clone", "--depth", "1", "--branch", "main",
                "https://github.com/gkeyllorg/postgkyl.git", str(checkout),
            ], check=True)
        else:
            dirty = subprocess.check_output([
                "git", "-C", str(checkout), "status", "--porcelain",
            ], text=True)
            if dirty.strip():
                raise RuntimeError(f"Refusing to change dirty checkout: {checkout}")
            subprocess.run([
                "git", "-C", str(checkout), "fetch", "--depth", "1",
                "origin", "main",
            ], check=True)
            subprocess.run([
                "git", "-C", str(checkout), "checkout", "--detach", "FETCH_HEAD",
            ], check=True)
    checkout = checkout.resolve()
    generator = checkout / "scripts/build_docs.py"
    if not generator.is_file():
        raise RuntimeError(
            "Postgkyl main must contain scripts/build_docs.py. Merge the "
            "Postgkyl documentation implementation before deploying this host.")
    if not no_install:
        subprocess.run([
            sys.executable, "-m", "pip", "install", "numpy>=2.2.6",
            "setuptools", "wheel",
        ], check=True)
        subprocess.run([
            sys.executable, "-m", "pip", "install", "--no-build-isolation",
            "-e", f"{checkout}[docs]",
        ], check=True)
    subprocess.run([
        sys.executable, str(generator), "--output", str(site / "source/postgkyl"),
    ], cwd=checkout, check=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--checkout", type=Path, help="Use a local Postgkyl checkout")
    parser.add_argument("--no-install", action="store_true",
                        help="Use dependencies already installed in this environment")
    args = parser.parse_args()
    prepare(Path(__file__).resolve().parents[1], args.checkout, args.no_install)
