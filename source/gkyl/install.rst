.. _gkyl_install:

gkyl install
============

There are two options for installing gkyl. 
One can install directly from the source code, or via the `Conda <https://conda.io/miniconda.html>`_ package.
**Installing directly from the source is the preferred option**, as this method gives users more control over the installation process.
For many users who will wish to run gkyl on a cluster, which will have cluster-built versions of the Message Passing Interface (MPI) for parallel simulations, 
and potentially other gkyl depedencies, the source build will allow users to set the appropriate paths to the cluster installations of these dependencies.

Installing from source (preferred)
----------------------------------

To install gkyl from source, first clone the `GitHub <https://github.com/ammarhakim/gkyl>`_ repository using::

     git clone https://github.com/ammarhakim/gkyl

Navigate into the ``gkyl`` directory to begin.

In many cases, an installation of gkyl will involve building most of gkyl's dependencies only require a modern C/C++ compiler and Python 3.
The full list of dependencies is:

* C/C++ compiler with C++17 support (**But NOT Clang >= 12.0 provided by Xcode 12**)
* Python 3 (**But NOT >=Python 3.8**)
* MPI compiler with MPI3 support (>=openmpi 3.0 or >=mpich 3.0)
* LuaJIT 2.1.0
* ADIOS 1.13.1 (**But NOT >=ADIOS 2.0**)
* Eigen 3.3.7
* CUDA Toolkit >=10.2 (**if building with GPU support**)

The following instructions assume that at minimum the user has both a C/C++ compiler with C++17 support and Python 3.

.. _gkyl_install_machines:

Installing using "machine files" (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For systems on which gkyl has been built before, the code can be
built in three steps using scripts found in the ``machines/`` directory.

1. Install dependencies using a ``mkdeps`` script from the ``machines/`` directory::

     ./machines/mkdeps.[SYSTEM].sh

where ``[SYSTEM]`` should be replaced by the name of the system you are
building on, such as ``macosx`` or ``eddy``. By default, installations
will be made in ``~/gkylsoft/``.
**Even on systems which have installations of gkyl dependencies such as MPI, the mkdeps script must be run first to build other gkyl dependencies such as LuaJIT.**

2. Configure ``waf`` using a ``configure`` script from the ``machines/`` directory::
     

     ./machines/configure.[SYSTEM].sh

**NOTE**: Steps 1 and 2 should only need to be done on the first
build, unless one wishes to change the dependencies.
A successful ``waf`` configure, on a system without GPU support, will look like:

.. code-block:: bash

  bash$ ./machines/configure.macosx.sh
  ./waf CC=clang CXX=clang++ MPICC=/Users/junoravin/gkylsoft/openmpi/bin/mpicc MPICXX=/Users/junoravin/gkylsoft/openmpi/bin/mpicxx --out=build --prefix=/Users/junoravin/gkylsoft/gkyl --cxxflags=-O3,-std=c++17 --luajit-inc-dir=/Users/junoravin/gkylsoft/luajit/include/luajit-2.1 --luajit-lib-dir=/Users/junoravin/gkylsoft/luajit/lib --luajit-share-dir=/Users/junoravin/gkylsoft/luajit/share/luajit-2.1.0-beta3 --enable-mpi --mpi-inc-dir=/Users/junoravin/gkylsoft/openmpi/include --mpi-lib-dir=/Users/junoravin/gkylsoft/openmpi/lib --mpi-link-libs=mpi --enable-adios --adios-inc-dir=/Users/junoravin/gkylsoft/adios/include --adios-lib-dir=/Users/junoravin/gkylsoft/adios/lib configure
  Setting top to                           : /Users/junoravin/gkyl
  Setting out to                           : /Users/junoravin/gkyl/build
  Checking for 'clang' (C compiler)        : clang
  Checking for 'clang++' (C++ compiler)    : clang++
  Setting dependency path:                 : /Users/junoravin/gkylsoft
  Setting prefix:                          : /Users/junoravin/gkylsoft/gkyl
  Checking for LUAJIT                      : Found LuaJIT
  Checking for MPI                         : Found MPI
  Checking for ADIOS                       : Found ADIOS
  Checking for EIGEN                       : Found EIGEN
  Checking for Sqlite3                     : Using Sqlite3
  Checking for NVCC compiler               : Not found NVCC
  'configure' finished successfully (0.843s)

3. Build the code using::

     ./waf build install

The final result will be a ``gkyl`` executable located in the ``~/gkylsoft/gkyl/bin/`` directory.
Feel free to add this directory to your ``PATH`` environment variable or `create an alias <https://linuxize.com/post/how-to-create-bash-aliases/>`_ so you can simply call ``gkyl``.

.. _gkyl_install_machines_readme:

Machine files for non-native systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For systems that do not already have corresponding files in the
``machines/`` directory, we encourage you to add files for your
machine. Instructions can be found in ``machines/README.md``.

  
Installing from source manually 
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If machine files are not available, the dependencies, configuration, and build
can be done manually. 

The first step is to build the
dependencies. Depending on your system, building dependencies can be
complicated. On a Mac or Linux machine you can simply run the
mkdeps.sh script in the install-deps directory. To build dependencies
cd to::

  cd gkyl/install-deps

First, please check details by running::

  ./mkdeps.sh -h

On most supercomputers you will likely need to use the system
recommended compilers and MPI libraries. In this case, you should pass
the appropriate compilers to mkdeps.sh as follows::

  ./mkdeps.sh CC=cc CXX=cxx MPICC=mpicc MPICXX=mpicxx ....

You should only build libraries *not* provided by the system. In
practice, this likely means LuaJIT, ADIOS and, perhaps Eigen. (Many
supercomputer centers at DOE already offer ADIOS builds and should be
preferred instead of your own builds). A typical command will be::

  ./mkdeps.sh --build-adios=yes --build-luajit=yes --build-eigen=yes

(in addition, you may need to specify compilers also).

By default, the mkdeps.sh script will install dependencies in
$HOME/gkylsoft directory. If you install it elsewhere, you will need
to modify the instructions below accordingly.

Once you have all dependencies installed, you can build gkyl itself
by cd-ing to the top-directory in the source::

  cd gkyl

gkyl uses the Waf build system. You do NOT need to install waf as it
is included with the distribution. However, waf depends on Python
(included on most systems). Waf takes a number of options. To get a
list do ::

   ./waf --help

There are two build scenarios: first, all dependencies are installed
in $HOME/gkylsoft directory, and second, you are using some libraries
supplied by your system.

If you have installed all dependencies in the gkylsoft directory you
can simply run::

    ./waf configure CC=mpicc CXX=mpicxx

where CC and CXX are names of the MPI compilers to use. Note that in
some cases the full path to the compiler may need to be specified. If
the compilers are already in your path, then you can omit all flags.

If you need to use system supplied builds, you need to specify more
complex set of paths. Although you can do this by passing options to
the waf build script, it is easiest to follow these steps:

-  Copy the configure-par.sh-in script to configure-par.sh

-  Modify this script to reflect the locations of various libraries on
   your machine. In particular, if you are using pre-built libraries you
   will likely need to change the information about MPI and ADIOS.

-  Run the configure-par.sh script

Once the configuration is complete, run the following command to build
and install (note: if you are working on a cluster and using environment
modules, you may need to load them at this point)::

    ./waf build install

The builds are created in the 'build' directory and the executable is
installed in $HOME/gkylsoft/gkyl/bin, unless you specified a different
install prefix. The executable can *only* be run from the install
directory [#why]_.

If you need to clean up a build do:

::

    ./waf clean

If you need to uninstall do:

::

    ./waf uninstall

Note on building LuaJIT
***********************

LuaJIT builds easily on most machines with standard GCC compiler. Often,
you may run into problems on older gcc as they do not include the log2
and exp2 functions unless c99 standard is enabled. To get around this,
modify the src/Makefile in LuaJIT. To do this, change the line:

::

    CC= $(DEFAULT_CC)

to:

::

    CC= $(DEFAULT_CC) -std=gnu99


Note on building on Mac OS X
****************************

To build on Mac OS X Mojave and beyond you must set the following env flag::

  export MACOSX_DEPLOYMENT_TARGET=10.YY  

where ``YY`` is the version number of the OSX operating system. 
For example, to build on OS X Mojave the env flag is::

  export MACOSX_DEPLOYMENT_TARGET=10.14  

and to build on OS X Catalina the env flag is::

  export MACOSX_DEPLOYMENT_TARGET=10.15  

Installing with Conda
---------------------------------

The gkyl package is also available to be installed via Conda, although
this gives less flexibility for keeping the code up-to-date as gkyl development continues.
Once `Conda <https://conda.io/miniconda.html>`_ is installed and added
to the ``PATH``, gkyl can be obtained with::

  conda install -c gkyl gkeyll

Note, that this will also install all dependencies into the Conda
install directory. Often this may lead to some conflicts, particularly
for the MPI installation, specially if there is another version of MPI
already located in the system. gkyl should be run using the MPI
provided by Conda.

In general, having Conda and source-built gkyl on the same machine
can cause confusion. In that case please use explicit paths to the
mpiexec and gkyl executable you wish to use when running
simulations.


Troubleshooting
---------------

Having trouble building? We will try to compile a list of
suggestions and common error messages in
:ref:`this troubleshooting site <gkyl_trouble>`.

.. rubric:: Footnotes

.. [#why] The reason for this is that gkyl is in reality a LuaJIT
    compiler extended with MPI. Hence, for the compiler to find Lua
    modules (i.e. gkyl specific code) certain paths need to be set
    which is done relative to the install location.

