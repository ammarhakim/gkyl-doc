# About

This is the documentation and tutorials for the
[gkyl](https://github.com/ammarhakim/gkyl) project


In order to build the docs locally, one needs
[sphinx](https://www.sphinx-doc.org/en/master/) and the
[immaterial](https://jbms.github.io/sphinx-immaterial/) theme.

We recommend creating a virtual environment and installing the dependencies
through [conda](https://conda.io/miniconda.html):
```bash
conda env create -f environment.yml
```

The environment is then activated with
```bash
conda activate gkyl-doc
```

However, one can also attempt to install the dependencies directly to current
`conda` environment using:
```bash
conda install --file source/requirements.txt
```

With the dependencies installed, the documentation is simply built with `make
html` from the `gkyl-doc` directory. The desired HTML file is than in the
`build` directory.
