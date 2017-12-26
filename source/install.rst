Installing Gkyl
+++++++++++++++

Depending on your system, building Gkyl can be easy (Linux, Mac latops
and small clusters) or hard (supercomputing centers). The instructions
below will help you build the code, but some amount of experimentation
may be required to get a build.

You must build and install the dependencies yourself, or use existing
builds for your system. Most supercomputer centers have optimized,
pre-built libraries for most dependencies. On these systems, you will
probably only need to install LuaJIT.

Build instructions for dependencies are provided in the build sections
below. Gkyl depends on the following tools and packages:

-  A modern C/C++ compiler; Python (for use in waf build system and
   post-processing)
-  LuaJIT
-  MPI
-  ADIOS IO library

Optionally, you will need

-  Petsc for linear and non-linear solvers.

Building dependencies
---------------------

Depending on your system, building dependencies can be complicated.
On a Mac or Linux machine you can simply run the mkdeps.sh script in
the install-deps directory. First, please check details by running::

  ./mkdeps.sh -h

On most supercomputers you will likely need to use the system
recommended compilers and MPI libraries. In this case, you should pass
the appropriate compilers to mkdeps.sh as follows::

  ./mkdeps.sh CC=cc CXX=cxx MPICC=mpicc MPICXX=mpicxx  

You should only build libraries *not* provided by the system. In
practice, this likely means LuaJIT, ADIOS and, perhaps Petsc. (Many
supercomputer centers at DOE already offer ADIOS and Petsc builds and
should be prefered instead of your own builds).

By default, the mkdeps.sh script will install dependencies in
$HOME/gkylsoft directory. If you install it elsewhere, you will need
to modify the instructions below accordingly.

Building Gkyl
-------------

Once you have all dependencies installed, you can build Gkyl itself.
Gkyl uses the Waf build system. You do NOT need to install waf as it
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
some cases the full path to the compiler may need to be specified.

If you need to use system supplied builds, you need to specify more
complex set of paths. Although you can do this by passing options to
the waf build script, it is easiest to follow these steps:

-  Copy the configure-par.sh-in script to configure-par.sh

-  Modify this script to reflect the locations of various libraries on
   your machine. In particular, if you are using pre-built libraries you
   will likely need to change the information about MPI and ADIOS.

-  Run the configure-par.sh script

Once the configuration is complete, run the following command to build
and install::

    ./waf build install

The builds are created in the 'build' directory and the executable is
installed in $HOME/gkylsoft/gkyl/bin, unless you specified a differnt
install prefix. The executable can *only* be run from the install
directory.

If you need to clean up a build do:

::

    ./waf clean

If you need to uninstall do:

::

    ./waf uninstall

Note on building LuaJIT
-----------------------

LuaJIT builds easily on most machines with standard GCC compiler. Often,
you may run into problems on older gcc as they do not include the log2
and exp2 functions unless c99 standard is enabled. To get around this,
modify the src/Makefile in LuaJIT. To do this, change the line:

::

    CC= $(DEFAULT_CC)

to:

::

    CC= $(DEFAULT_CC) -std=gnu99
