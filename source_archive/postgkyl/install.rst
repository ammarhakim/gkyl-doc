.. _pg_install:

Postgkyl install
================

.. important::
  :title: Shortcut
  :collapsible:

  .. code-block:: bash

    git clone https://github.com/ammarhakim/postgkyl.git
    cd postgkyl
    conda env create -f environment.yml
    conda activate pgkyl
    pip install -e .

Postgkyl installation can be split to two steps:

1. Setting up Python environment
2. Installing Postgkyl from its repository

The following Python packages are required:

* adios2 [#adios]_
* click
* matplotlib
* msgpack-python
* numpy
* pytest
* scipy
* sympy
* pytables

For installation and management of these dependencies we recommend the `Conda
<https://conda.io/miniconda.html>`_ package manager (more precisely the
lightweight miniconda version).

.. important::
  :title: Postgkyl requires Python 3.11 or higher
  :collapsible:

  The python version of one of the dependencies, ADIOS 2, requires Python 3.11
  or higher. Therefore, Postgkyl Conda packages are currently available only for
  these versions.

  Users that installed Posgkyl prior to 2023/08/30 are advised to either create
  a fresh Python 3.11 `environment
  <https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html>`_
  or reinstall their Conda.

The packages can then be either installed manually or use the prepared ``environment.yml`` in the Postgkyl repository. One needs to first clone the repository

.. code-block:: bash

  git clone https://github.com/ammarhakim/postgkyl.git

navigate to the directory and create a new conda environment

.. code-block:: bash

  conda env create -f environment.yml

The Postgkyl environment can then be activated using

.. code-block:: bash

  conda activate pgkyl

and deactivate with

.. code-block:: bash

  conda deactivate

.. note::
  :title: Using Postgkyl with conda environments
  :collapsible:

  Managing a significant number of dependencies can easily become very
  complicated and conflicts may arise. Therefore, we generally recommend using
  separate ``conda`` environments for individual projects.

  Note that in order to use environments, ``conda`` needs to be initialized.
  This is the last step of the `conda` installation, but the current default
  behavior is _not_ to perform the initialization. It can be done afterwards
  using ``conda init [shell name]``, e.g., ``conda init fish`` with the
  fantastic `fish <https://fishshell.com/>`_ shell.

  When creating a new environment for Postgkyl, one can easily rename it

  .. code-block:: bash

    conda env create -f environment.yml -n custom_name

  Or, alternatively, simply try to update the current active environment

  .. code-block:: bash

    conda env update -f environment.yml

  Finally, ``conda`` can be used to install dependencies `without` the use of
  environments

  .. code-block:: bash

    conda install --file requirements.txt

With the dependencies set up and the repository cloned, both the Postgkyl Python
module and the command line tool are installed using ``pip``

.. code-block:: bash

  pip install -e .

.. note::
  :title: Note on using the ``PYTHOPATH``
  :collapsible:

  Assuming the Conda has been set properly, the ``pip`` command above will
  install both the Python module and the command line tool; no modification of
  the ``PYTHOPATH`` is required! In case Postgkyl was previously used with
  ``PYTHONPATH``, we strongly recommend removing all entries from there.

.. [#adios] Adios 2 is only needed for the production version of Gkeyll.
    Developers strictly using only the GkeyllZero layer do not need this
    package.