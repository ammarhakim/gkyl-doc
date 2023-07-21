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
----------------------------------------------------

.. warning::

   The python version of one of the dependencies, ADIOS 1, is **not**
   compatible with Python 3.9. Therefore, Postgkyl Conda packages are
   available only for Python 3.6, 3.7, and 3.8.

   
Postgkyl can be installed with Conda with literally a single command:

.. code-block:: bash

  conda install -c gkyl -c conda-forge postgkyl 

Note that the flags for channels, ``-c gkyl`` and ``-c conda-forge``,
is required even for updating. However, it can be permanently added.

.. code-block:: bash

  conda config --add channels gkyl
  conda config --add channels conda-forge
  conda install postgkyl

Updates can be downloaded with:

.. code-block:: bash

  conda update -c gkyl postgkyl

.. warning::

  Users that installed postgkyl prior to 2022/10/07 who wish to update
  need to use

  .. code-block:: bash

    conda uninstall adiospy
    conda install -c gkyl -c conda-forge postgkyl

  in order to re-install adiospy from conda-forge which is needed
  to avoid issues with the deprecation of ``asscalar`` in numpy. This is
  only needed once; afterwards you can proceed to update normally as
  described above.

.. warning::

  After installing postgkyl you may still get errors about numpy's
  ``asscalar`` being deprecated. 

  One solution is to downgrade numpy with:

  .. code-block:: bash

    conda install numpy=1.21.5 
  
.. note::

  To install a new package, users need the write permission for the
  Anaconda directory. If this is not the case (e.g. on a computing
  cluster), one can either create a Conda `environment
  <https://conda.io/docs/user-guide/tasks/manage-environments.html>`_
  (see tip below) or install Conda into the ``$HOME`` directory.

  To create a Conda environment for postgkyl called ``pgkylenv``, use
  
  .. code-block:: bash
  
    conda create -n pgkylenv python=3
  
  Then activate the environment with
  
  .. code-block:: bash
  
    conda activate pgkylenv
  
  and install postgkyl using the commands above (or the ones below to
  install from source).

  After install, one must have the ``pgkylenv`` environment activated
  in order to use postgkyl.
  

Installing from source (preferred for developers)
----------------------
  
Postgkyl source code is hosted in a `GitHub
<https://github.com/ammarhakim/postgkyl>`_ repository. To get Postgkyl
running, one first needs to clone the repository and install dependencies.

First, clone the repository using:

.. code-block:: bash

  git clone https://github.com/ammarhakim/postgkyl


Postgkyl has these dependencies, which are readily available thru Conda:

* `click <https://click.palletsprojects.com/en/7.x/>`_
* `matplotlib <https://matplotlib.org/>`_ >= 3.0
* `numpy <https://numpy.org/>`_ >=1.13
* `pytables <https://www.pytables.org/>`_
* `scipy <https://www.scipy.org/>`_
* `sympy <https://www.sympy.org/en/index.html>`_
* `adios-python <https://www.olcf.ornl.gov/center-projects/adios/>`_ (on the
  ``conda-forge`` channel)
* `msgpack-python <https://github.com/msgpack/msgpack-python>`_

All these dependencies can be easily obtained from the Gkeyll Conda
channel, via

.. code-block:: bash

  conda install -c gkyl -c conda-forge postgkyl --only-deps

Once the dependencies are installed, postgkyl can be installed by
navigating into the ``postgkyl`` repository and running

.. code-block:: bash
                
  python setup.py install
  python setup.py develop

Note that these commands only ever need to be run once (even if one is
modifying source code).  Changes to the source code will be
automatically included because we have installed in `development mode
<https://setuptools.readthedocs.io/en/latest/userguide/development_mode.html>`_.

          

Switching from Conda version to repository
------------------------------------------

While the Conda build of Postgkyl is the suggested version for the
majority of users, the source code repository is required for any code
contributions.  We should stress that when switching between the
different version, it is strongly advised to remove the other
version. Having both may lead to an unforeseen behavior based on the
relative order of components in the ``PATH``.

The Conda version can be uninstalled with:

.. code-block:: bash

  conda uninstall postgkyl

