.. _pg_install:

Postgkyl install
================

There are two options for getting Postgkyl.  The first option is to
get the `Conda <https://conda.io/miniconda.html>`_ package and the
second is to clone the source code repository. **Installing via Conda
is preferred** for the majority of users as it requires literally a
single Conda command. What is more, Conda is already the suggested way
of installing all the dependencies. On the other hand, the later option
has an advantage of always having the most up-to-date version and is
generally required for users that want to contribute to the code.


Installing with Conda (preferred for non-developers)
---------------------------------

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

Installing from source (preferred for developers)
----------------------
  
Postgkyl source code is hosted in a `GitHub
<https://github.com/ammarhakim/postgkyl>`_ repository. To get Postgkyl
running, one first needs to clone the repository and install dependencies.

First, clone the repository using:

.. code-block:: bash

  git clone https://github.com/ammarhakim/postgkyl


Postgkyl has these dependencies, which are readily available thru Conda:

* `Click <https://click.palletsprojects.com/en/7.x/>`_
* `Matplotlib <https://matplotlib.org/>`_ >= 3.0
* `NumPy <https://numpy.org/>`_ >=1.13
* `PyTables <https://www.pytables.org/>`_
* `SciPy <https://www.scipy.org/>`_
* `SymPy <https://www.sympy.org/en/index.html>`_
* `Bokeh <https://docs.bokeh.org/en/latest/index.html>`_
* `Adios <https://www.olcf.ornl.gov/center-projects/adios/>`_ 
* `MessagePack for python (msgpack-python) <https://github.com/msgpack/msgpack-python>`_

All these dependencies can be easily obtained from the Gkeyll Conda channel, via

.. code-block:: bash

  conda install -c gkyl postgkyl --only-deps

Once the dependencies are installed, postgkyl can be installed by navigating into
the ``postgkyl`` repository and running

.. code-block:: bash
                
  python setup.py install
  python setup.py develop

Note that these commands only ever need to be run once (even if one is modifying source code). 
Changes to the source code will be automatically included because we have installed in 
`development mode <https://setuptools.readthedocs.io/en/latest/userguide/development_mode.html>`_.
  
.. raw:: html
         
   <details>
   <summary><a>Building adiospy from source</a></summary>

Adios can also be built manually from the source code. Note that for the manual
build, Adios needs to be already installed and its ``bin`` directory
added to the ``PATH`` (the default Gkeyll location is
``~/gkylsoft/adios/bin/``). The standard location for the
wrapper in the Gkeyll installation is
``gkyl/install-deps/adios-x.x.x/wrappers/numpy/``. After navigating to that directory,
build and install adiospy via

.. code-block:: bash
                
  make python
  python setup.py install
  
This currently does not work out of the box with the ``clang``
compiler because of a deprecated library. This can be overcome
removing the ``-lrt`` flag from the line 33 of the ``Makefile``. The
edited lines 32 and 33 should look like this:

.. code-block:: bash
                
  adios.so:
          python setup.py build_ext

This will allow to complete the adiospy build successfully and it has no know
consequences for Postgkyl.
          

Switching from Conda version to repository
------------------------------------------

While the Conda build of Postgkyl is the suggested version for the
majority of users, the source code repository is required for any code
contributions.  We should stress that when switching between the
different version, it is strongly advised to remove the other
version. Having both may lead to an unforeseen behavior based on the
relative order of components in the ``PATH`` and ``PYTHONPATH``.

The Conda version can be uninstalled with:

.. code-block:: bash

  conda uninstall postgkyl

