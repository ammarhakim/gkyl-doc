This is the documentation and tutorials for the
[gkyl](https://github.com/ammarhakim/gkyl) project


In order to build the docs locally, one needs
[sphinx](https://www.sphinx-doc.org/en/master/) and the
[immaterial](https://jbms.github.io/sphinx-immaterial/) theme.

We recommend creating a virtual environment[^1] and installing the dependencies
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

[^1]: Note that `conda` needs to be initialized before environments can be used.
    This is the last step of the `conda` installation, but the current default
    behavior is _not_ to perform the initialization. It can be done afterwards
    using `conda init [shell name]`, e.g., `conda init fish` with the fantastic
    [fish](https://fishshell.com/) shell.