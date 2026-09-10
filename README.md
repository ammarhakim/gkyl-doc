# Gkeyll documentation

This repository hosts the Gkeyll website, including documentation generated
from [Postgkyl main](https://github.com/gkeyllorg/postgkyl/tree/main).

Use **Python 3.12**, Git, Make, and a C compiler. From this repository:

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install -r source/requirements.txt
make html SPHINXOPTS="-W --keep-going"
```

Open `build/html/index.html`. `make html` fetches Postgkyl **main** into
`external/postgkyl`, installs it with its documentation dependencies and native
Gkeyll bridge, executes its examples, and stages its documentation in
`source/postgkyl/`. The first build needs network access and can take several
minutes. Both directories are ignored build inputs/outputs; edit Postgkyl
content in its own repository. A later build fetches main again. A dirty
managed checkout is refused rather than overwritten.

For a local Postgkyl change before it reaches main:

```bash
make html POSTGKYL_PREPARE_ARGS="--checkout /path/to/postgkyl" SPHINXOPTS="-W --keep-going"
```

Add `--no-install` only when that exact checkout is already installed with
`pip install --no-build-isolation -e '.[docs]'` in the active environment.
The generator checks the imported package location and requires its native
bridge. Its documentation, examples, and test data all come from the same
checkout. The resulting pages record the source commit for traceability;
that record does not pin subsequent builds.

Read the Docs runs the same preparation script after installing host
requirements. `.readthedocs.yaml` selects Python 3.12 and treats Sphinx warnings
as errors. Merge the Postgkyl documentation implementation into its main branch
before enabling this host change, since the host requires its build script.

GitHub Actions tests pull requests, pushes, and a daily checkout of Postgkyl
main. It runs Postgkyl's documentation and example tests, validates the
standalone build and downloaded examples, then builds the complete website
with warnings as errors and uploads an HTML preview artifact.

For automatic hosted refreshes after successful daily checks, configure the
GitHub Actions repository secret `READTHEDOCS_TOKEN` with a token authorized to
trigger builds of the `gkeyll` Read the Docs project. Without it the scheduled
checks and preview artifacts still run; hosting updates on normal Read the
Docs builds. The manual Actions workflow also requests a hosted refresh when
the secret is configured. Tokens are never used on pull requests.

The gallery now runs both the Python scripts and their paired CLI pipelines,
checks raster pixels/GIF timings or Plotly trace data/layout, and publishes
both results. The Python API is generated as one page per callable/property.
Interactive Plotly HTML is copied beside the referring pages by Postgkyl's
shared Sphinx extension.

PyVista screenshots require OpenGL. CI and Read the Docs install `libegl1`
and `libgl1-mesa-dri` and select `VTK_DEFAULT_OPENGL_WINDOW=vtkEGLRenderWindow`
with `LIBGL_ALWAYS_SOFTWARE=1` for headless Linux. Local machines with a working
OpenGL display can use their usual renderer.
