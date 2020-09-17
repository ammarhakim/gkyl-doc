.. _pg_installing:

Installing Postgkyl
+++++++++++++++++++

There are two options for getting Postgkyl.  The first option is to
clone the source code and the second is to get the `Conda
<https://conda.io/miniconda.html>`_ package. The first option has an
advantage of always having the most up-to-date version and is
generally required for people that want to contribute to the code.  On
the other hand, the later option literally requires a single ``conda``
command.

Note that it is not advisable to have both versions present on a
single machine as it may lead to unexpected behavior.

.. contents::

Installing from source
----------------------
  
Postgkyl source code is hosted in a `GitHub
<https://github.com/ammarhakim/postgkyl>`_ repository. To get Postgkyl
running, one needs to clone the repository, install dependencies, and
modify the ``PATH`` and ``PYTHONPATH`` environmental variables.

Postgkyl has these dependencies, which are readilly available thru Conda:

* `Click <https://click.palletsprojects.com/en/7.x/>`_
* `Matplotlib <https://matplotlib.org/>`_ >= 3.0
* `NumPy <https://numpy.org/>`_ >=1.13
* `PyTables <https://www.pytables.org/>`_
* `SciPy <https://www.scipy.org/>`_
* `SymPy <https://www.sympy.org/en/index.html>`_

Additionally, to read the Gkeyll 2 output files, the Python wrapper of
`Adios <https://www.olcf.ornl.gov/center-projects/adios/>`_ is
required. It can be either obtaine from the Gkeyll Conda channel,

.. code-block:: bash
                
  conda install -c gkyl adiospy

or build manually from the source code. The standard location for the
wrapper in the Gkeyll installation is
``gkyl/install-deps/adios-x.x.x/wrappers/numpy/``. Then to build and
install:

.. code-block:: bash
                
  make python
  python setup.py install

Finally, the ``postgkyl`` repository must be added to the
``PYTHONPATH`` and, if one wants to use Postgkyl directly from a
terminal, to the ``PATH``.

Alternativelly, all the dependencies can be installed from Conda:

.. code-block:: bash

  conda install -c gkyl postgkyl --only-deps


Installing with Conda
---------------------

Postgkyl can be installed with Conda with literally a single command:

.. code-block:: bash

  conda install -c gkyl postgkyl 

Note that the flag for the Gkeyll channel, ``-c gkyl``, is required
even for updating. However, it can be permanently added.

.. code-block:: bash

  conda config --add channels gkyl
  conda install postgkyl

Updates can be downloaded with:

.. code-block:: bash

  conda update -c gkyl postgkyl

Note that to install a new package, users need the write permission
for the Anaconda directory. If this is not the case, one can either
create a Conda `environment
<https://conda.io/docs/user-guide/tasks/manage-environments.html>`_ or
install Conda into the ``$HOME`` directory.

