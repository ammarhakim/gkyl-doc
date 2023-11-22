.. _gkyl_install:

gkyl install
============

To install gkyl from source, first clone the `GitHub
<https://github.com/ammarhakim/gkyl>`_ repository using::

     git clone https://github.com/ammarhakim/gkyl.git

Navigate into the ``gkyl`` directory to begin.

In many cases, an installation of gkyl will involve building most of gkyl's
dependencies only require a modern C compiler and Python 3.11.

The build is in two stages. In stage 1, ``gkyl`` builds the library ``gkylzero``.
``gkylzero`` has the following dependencies:

* C compiler (C99 standard)
* OpenBLAS >= 0.3.23 (**On Mac OSX, users can just use -framework Accelerate**)
* SuperLU >= 5.2.2
* CUDA Toolkit >=12.0 (**if building with GPU support**)

When ``gkylzero`` has completed its installation, the rest of ``gkyl`` will build. 
``gkyl`` has the following dependencies in addition to depending upon the ``gkylzero``
library: 

* C compiler (C99 standard)
* Python 3.11
* MPI compiler with MPI3 support (>=openmpi 3.0 or >=mpich 3.0)
* LuaJIT 2.1.0
* ADIOS 2.0 (**requires CMake to be installed**)
* CUDA Toolkit >=12.0 (**if building with GPU support**)
* Nvidia Collective Communication Library (NCCL) >=2.18.3 (**if building with GPU support**)

The following instructions assume that at minimum the user has both a C compiler (C99 standard) and Python 3.11.

.. _gkyl_install_machines:

Installing using "machine files" (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For systems on which gkyl has been built before, the code can be
built in three steps using scripts found in the ``machines/`` directory.

1. Install dependencies using a ``mkdeps`` script from the ``machines/`` directory::

   ./machines/mkdeps.[SYSTEM].sh

where ``[SYSTEM]`` should be replaced by the name of the system you are building
on, such as ``linux``, ``macosx``, or ``perlmutter``. By default, installations will
be made in ``$HOME/gkylsoft/``. **Even on systems which have installations of gkyl
dependencies such as MPI, the mkdeps script must be run first to build the gkylzero 
library and other gkyl dependencies such as LuaJIT.**

.. warning::
  :title: Installing in non-default directory
  :collapsible:

  If you wish to install Gkeyll somewhere other than `$HOME/gkylsoft/` please
  change the variable `GKYLSOFT` near the top of both machine files (i.e.
  `mkdeps.[SYSTEM].sh` and `configure.[SYSTEM].sh`) to point to the desired
  installation location before running them.

2. Configure ``waf`` using a ``configure`` script from the ``machines/`` directory::

   ./machines/configure.[SYSTEM].sh

**NOTE**: Steps 1 and 2 should only need to be done on the first build, unless
one wishes to change the dependencies. A successful ``waf`` configure, on a
system without GPU support (in this case a Mac OSX system), will look like:

.. code-block:: bash

  bash$ ./waf CC=clang CXX=clang++ MPICC=/Users/junoravin/gkylsoft/openmpi/bin/mpicc MPICXX=/Users/junoravin/gkylsoft/openmpi/bin/mpicxx --out=build -p /Users/junoravin/gkylsoft --prefix=/Users/junoravin/gkylsoft/gkyl --cxxflags=-O3,-std=c++17 --luajit-inc-dir=/Users/junoravin/gkylsoft/luajit/include/luajit-2.1 --luajit-lib-dir=/Users/junoravin/gkylsoft/luajit/lib --luajit-share-dir=/Users/junoravin/gkylsoft/luajit/share/luajit-2.1.0-beta3 --enable-mpi --mpi-inc-dir=/Users/junoravin/gkylsoft/openmpi/include --mpi-lib-dir=/Users/junoravin/gkylsoft/openmpi/lib --mpi-link-libs=mpi --enable-adios --adios-inc-dir=/Users/junoravin/gkylsoft/adios/include --adios-lib-dir=/Users/junoravin/gkylsoft/adios/lib --enable-gkylzero --gkylzero-inc-dir=/Users/junoravin/gkylsoft/gkylzero/include --gkylzero-lib-dir=/Users/junoravin/gkylsoft/gkylzero/lib --enable-superlu --superlu-inc-dir=/Users/junoravin/gkylsoft/superlu/include --superlu-lib-dir=/Users/junoravin/gkylsoft/superlu/lib --enable-openblas --openblas-inc-dir=/Users/junoravin/gkylsoft/OpenBLAS/include --openblas-lib-dir=/Users/junoravin/gkylsoft/OpenBLAS/lib configure
  Setting top to                           : /Users/junoravin/branches-gkyl/g0-merge-build-improve/gkyl
  Setting out to                           : /Users/junoravin/branches-gkyl/g0-merge-build-improve/gkyl/build
  Checking for 'clang' (C compiler)        : clang
  Checking for 'clang++' (C++ compiler)    : clang++
  Setting dependency path:                 : /Users/junoravin/gkylsoft
  Setting prefix:                          : /Users/junoravin/gkylsoft/gkyl
  Checking for LUAJIT                      : Found LuaJIT
  Checking for MPI                         : Found MPI
  Checking for ADIOS                       : Found ADIOS
  Checking for Sqlite3                     : Using Sqlite3
  Checking for SUPERLU                     : Found SUPERLU
  Checking for OPENBLAS                    : Found OPENBLAS
  Checking for gkylzero                    : Found gkylzero
  'configure' finished successfully (3.529s)

3. Manually load the modules at the top of the `./machines/configure.[SYSTEM].sh` file, and build the code using::

   ./waf build install

The final result will be a ``gkyl`` executable located in the
``$HOME/gkylsoft/gkyl/bin/`` directory.  Feel free to add this directory
to your ``PATH`` environment variable or `create an alias
<https://linuxize.com/post/how-to-create-bash-aliases/>`_ so you can
simply call ``gkyl``.

Note that if MPI was built as well as the part of the installation,
``$HOME/gkylsoft/openmpi/bin/`` needs to be added to the ``PATH`` as
well. Finally, on some distributions, it is required to add
``$HOME/gkylsoft/openmpi/lib/`` to the ``LD_LIBRARY_PATH`` environmental
variable::

  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/gkylsoft/openmpi/lib

.. _gkyl_install_machines_readme:

Creating machine files for new systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For systems that do not already have corresponding files in the
``machines/`` directory, we encourage you to create machine files
for your machine (and add it to the repository). Instructions
can be found in ``machines/README.md``, and you can use other machine
files as examples.

If you are building ``gkyl`` for the first time on a new machine, 
you **must** independently build the ``gkylzero`` library following 
the instructions in :ref:`installing from source manually <gkyl_install_from_source>`.

An alternative to building gkylzero manually, especially desirable for systems
other users will employ, is to:

1. Create gkylzero machine files.
2. Commit them to the gkylzero repository.
3. Create gkyl machine files (as mentioned above).
4. Add corresponding lines in `install-deps/build-gkylzero.sh` that call the gkylzero machine files for your system.
5. Proceed with the installation (running gkyl machine files).

.. warning::
  :title: Gkeyll on Power9
  :collapsible:

  Using Gkeyll on IBM Power9 systems (like `Summit
  <https://www.olcf.ornl.gov/olcf-resources/compute-systems/summit/>`_ or
  `Traverse <https://researchcomputing.princeton.edu/systems/traverse>`_) is not
  recommended. This is due to incomplete support for the LuaJIT compiler on
  Power9.

.. _gkyl_install_from_source:

Installing from source manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If machine files are not available, the dependencies, configuration, and build
can be done manually.

The first step is to build the dependencies. Depending on your system, building
dependencies can be complicated. You will need to install the ``gkylzero`` library yourself. 
The installation of the ``gkylzero`` library can be done anywhere, either in your home directory 
or in the install-deps directory of ``gkyl`` which can be navigated to::

  cd gkyl/install-deps

Clone the `GitHub
<https://github.com/ammarhakim/gkylzero>`_ repository using::

     git clone https://github.com/ammarhakim/gkylzero.git

The installation of the ``gkylzero`` dependencies follows a similar procedure to ``gkyl``. 
For example, on a Mac or Linux machine you can simply run
the mkdeps.sh script in the install-deps directory. To build dependencies cd
to::

  cd gkylzero/install-deps

First, please check details by running::

  ./mkdeps.sh -h

On most supercomputers you will likely need to use the system recommended
compilers. In this case, you should pass the appropriate
compilers to mkdeps.sh as follows::

  ./mkdeps.sh CC=cc CXX=cxx ....

After the dependencies are built, navigate up to the ``gkylzero/`` directory 
and run the configure script::

  ./configure

Many supercomputers have their own builds of OpenBLAS and SuperLU. If 
that is the case, one can configure ``gkylzero`` to use these installations 
instead of installing them yourself::

  ./configure --lapack-inc=/PATH/TO/LAPACK/include --lapack-lib/PATH/TO/LAPACK/lib ....

and similarly for SuperLU. **If you would like to configure with GPU support** 
make sure to configure with::

  ./configure CC=nvcc CUDA_ARCH=#

where # is the CUDA architecture you are compiling for. For example, the Nvidia A100 uses
``CUDA_ARCH=80``. You can also edit the ``configure`` script directly to pass these input
parameters.

Once the configure is complete, install ``gkylzero`` using the Makefile provided::

  make install -j#

Where # is some number of cores you would like to compile with. It is **strongly** recommended you
build with some number of cores to reduce the build times, especially on GPUs, but we caution against
using all the cores available to you on supercomputing systems where login nodes are shared. Some 
clusters allow you to build on compute nodes. In this instance, it can reduce build times by asking 
for a single node job and compiling with as much parallelism as possible. 

You can check that ``gkylzero`` has successfully installed on your system by building the unit tests::

  make unit -j#
  make check

If the unit tests pass, ``gkylzero`` has successfully installed and you can proceed to the installation of 
``gkyl``. Again, on most supercomputers you will likely need and want to use the system recommended
compilers and MPI libraries. In this case, you should pass the appropriate
compilers to mkdeps.sh as follows::

  ./mkdeps.sh CC=cc CXX=cxx MPICC=mpicc MPICXX=mpicxx ....

You should only build libraries *not* provided by the system. In practice, this
likely means LuaJIT and ADIOS2. (Many supercomputer centers at
DOE already offer ADIOS2 builds and should be preferred instead of your own
builds). A typical command will be::

  ./mkdeps.sh --build-adios=yes --build-luajit=yes 

(in addition, you may need to specify compilers also).

By default, the mkdeps.sh script will install dependencies in $HOME/gkylsoft
directory. If you install it elsewhere, you will need to modify the instructions
below accordingly. **Make sure to adjust the installation location for both gkylzero 
and gkyl consistently so the build system can find the gkylzero library**.

Once you have all dependencies installed, you can build gkyl itself by cd-ing to
the top-directory in the source. gkyl uses the Waf build system. You do NOT need
to install waf as it is included with the distribution. However, waf depends on
Python (included on most systems). Waf takes a number of options. To get a list
do ::

   ./waf --help

There are two build scenarios: first, all dependencies are installed in
$HOME/gkylsoft directory, and second, you are using some libraries supplied by
your system.

If you have installed all dependencies in the gkylsoft directory you can simply
run::

    ./waf configure CC=mpicc CXX=mpicxx

where CC and CXX are names of the MPI compilers to use. Note that in some cases
the full path to the compiler may need to be specified. If the compilers are
already in your path, then you can omit all flags.

If you need to use system supplied builds, you need to specify more complex set
of paths. Although you can do this by passing options to the waf build script,
it is easiest to follow these steps:

-  Copy the configure-par.sh-in script to configure-par.sh

-  Modify this script to reflect the locations of various libraries on
   your machine. In particular, if you are using pre-built libraries you
   will likely need to change the information about MPI and ADIOS.

-  Run the configure-par.sh script

Once the configuration is complete, run the following command to build and
install (note: if you are working on a cluster and using environment modules,
you may need to load them at this point)::

    ./waf build install

The builds are created in the 'build' directory and the executable is installed
in ``$HOME/gkylsoft/gkyl/bin``, unless you specified a different install prefix. The
executable can *only* be run from the install directory [#why]_.

If you need to clean up a build do:

::

    ./waf clean

If you need to uninstall do:

::

    ./waf uninstall

Note on building LuaJIT
***********************

LuaJIT builds easily on most machines with standard GCC compiler. Often, you may
run into problems on older gcc as they do not include the ``log2`` and ``exp2``
functions unless c99 standard is enabled. To get around this, modify the
``src/Makefile`` in LuaJIT. To do this, change the line:

::

    CC= $(DEFAULT_CC)

to:

::

    CC= $(DEFAULT_CC) -std=gnu99


Note on building on Mac OS X
****************************

On some Mac OSX systems, **especially older systems such as Mojave**, you may need to set the following env flag::

  export MACOSX_DEPLOYMENT_TARGET=10.YY

where ``YY`` is the version number of the OSX operating system.
For example, to build on OS X Mojave the env flag is::

  export MACOSX_DEPLOYMENT_TARGET=10.14

and to build on OS X Catalina the env flag is::

  export MACOSX_DEPLOYMENT_TARGET=10.15


Troubleshooting
---------------

Having trouble building? We will try to compile a list of
suggestions and common error messages in
:ref:`this troubleshooting site <gkyl_trouble>`.

.. rubric:: Footnotes

.. [#why] The reason for this is that gkyl is in reality a LuaJIT compiler
    extended with MPI. Hence, for the compiler to find Lua modules (i.e. gkyl
    specific code) certain paths need to be set which is done relative to the
    install location.

