.. _gkyl_trouble:

Troubleshooting gkyl install
++++++++++++++++++++++++++++

As you build or run Gkeyll you may encounter some difficulties. 
This is natural when pushing the code in new directions, or using
it in new machines. In such cases you may find it helpful to
consider some of the following suggestions and lessons from past
experiences.


Build troubleshooting
---------------------

- The ``./waf build install`` command fails on some systems
  due to a combination of the size of certain kernels, and the
  default parallel compilation.
  **Suggestion:** try building with ``waf build install -j 1``.
  If this causes compilation to take too long, you can use ``waf -h``
  to see the default number of threads used, and then try something
  smaller than that but larger than 1.
- There seems to be a bug in ``clang`` version 12. When the build
  fails on a Mac machine, it is good to double-check the ``clang``
  version and potentially downgrade it to the version 11.

Configuring gkyl with configure.[SYSTEM].sh script not finding dependency
-------------------------------------------------------------------------

- When running the ``configure.[SYSTEM].sh``, the ``waf`` build system
  is looking for the installations of ``gkyl``'s dependencies in the
  ``gkylsoft`` folder, wherever that may be (usually ``~/gkylsoft`` or
  ``$HOME/gkylsoft``).  If ``waf`` cannot find a dependency, the user
  will get the following error message

.. code-block:: bash

  bash$ ./machines/configure.macosx.sh
  ./waf CC=clang CXX=clang++ MPICC=/Users/junoravin/gkylsoft/openmpi/bin/mpicc MPICXX=/Users/junoravin/gkylsoft/openmpi/bin/mpicxx --out=build --prefix=/Users/junoravin/gkylsoft/gkyl --cxxflags=-O3,-std=c++17 --luajit-inc-dir=/Users/junoravin/gkylsoft/luajit/include/luajit-2.1 --luajit-lib-dir=/Users/junoravin/gkylsoft/luajit/lib --luajit-share-dir=/Users/junoravin/gkylsoft/luajit/share/luajit-2.1.0-beta3 --enable-mpi --mpi-inc-dir=/Users/junoravin/gkylsoft/openmpi/include --mpi-lib-dir=/Users/junoravin/gkylsoft/openmpi/lib --mpi-link-libs=mpi --enable-adios --adios-inc-dir=/Users/junoravin/gkylsoft/adios/include --adios-lib-dir=/Users/junoravin/gkylsoft/adios/lib configure
  Setting top to                           : /Users/junoravin/gkyl
  Setting out to                           : /Users/junoravin/gkyl/build
  Checking for 'clang' (C compiler)        : clang
  Checking for 'clang++' (C++ compiler)    : clang++
  Setting dependency path:                 : /Users/junoravin/gkylsoft
  Setting prefix:                          : /Users/junoravin/gkylsoft/gkyl
  Checking for LUAJIT                      : The configuration failed

This error indicates that ``waf`` cannot find LuaJIT. Possible reasons for this:
  
- LuaJIT (or another dependency) did not successfully install. 
  Check in the ``gkylsoft`` directory to see if all the required dependencies are present.
  After a successful build, inside in the ``gkylsoft`` direction one should see

.. code-block:: bash

  bash$ ls -lh
  total 0
  lrwxr-xr-x  1 junoravin  staff    38B Sep 16 00:51 adios -> /Users/junoravin/gkylsoft/adios-1.13.1
  drwxr-xr-x  7 junoravin  staff   224B Sep 17 14:30 adios-1.13.1
  drwxr-xr-x  4 junoravin  staff   128B Sep 17 14:30 eigen-3.3.7
  lrwxr-xr-x  1 junoravin  staff    37B Sep 16 00:51 eigen3 -> /Users/junoravin/gkylsoft/eigen-3.3.7
  drwxr-xr-x  4 junoravin  staff   128B Sep 16 01:26 gkyl
  lrwxr-xr-x  1 junoravin  staff    54B Sep 16 01:03 luajit -> /Users/junoravin/gkylsoft/luajit-2.1.0-beta3-openresty
  drwxr-xr-x  7 junoravin  staff   224B Sep 17 14:29 luajit-2.1.0-beta3-openresty
  lrwxr-xr-x  1 junoravin  staff    39B Sep 16 00:50 openmpi -> /Users/junoravin/gkylsoft/openmpi-3.1.2
  drwxr-xr-x  8 junoravin  staff   256B Sep 17 14:29 openmpi-3.1.2

- If a dependency is **NOT** present, including the symbolic link, return to the ``gkyl/machines`` directory.
  Open the previously run mkdeps.[SYSTEM].sh script and modify the script to only try building the missing dependency.
  To do so, see for example the ``mkdeps.macosx.sh`` script

.. code-block:: bash

  # if we are in machines directory, go up a directory
  if [ `dirname "$0"` == "." ] 
    then
      cd ..
  fi
  export GKYLSOFT='~/gkylsoft'
  cd install-deps
  # first build OpenMPI
  ./mkdeps.sh CC=clang CXX=clang++ --build-openmpi=no
  # now build rest of packages
  ./mkdeps.sh CC=clang CXX=clang++ MPICC=$GKYLSOFT/openmpi-3.1.2/bin/mpicc MPICXX=$GKYLSOFT/openmpi-3.1.2/bin/mpicxx --build-luajit=yes --build-adios=no --build-eigen=no

where we have specified to the system **NOT** to build openmpi, adios, and eigen by simply setting the ``--build-XX=no`` flag.

Build failure: perl: warning: Setting locale failed.
----------------------------------------------------

- When building ``gkyl`` on a cluster that the user has remotely logged into (for example, with ``ssh``),
  the user may get the following warning upon logging in:

.. code-block:: bash

  perl: warning: Setting locale failed.
  perl: warning: Please check that your locale settings:
  LANGUAGE = (unset),
  LC_ALL = (unset),
  LANG = "C.UTF-8"
  are supported and installed on your system.
  perl: warning: Falling back to the standard locale ("C").

This warning can prevent successful builds by leading to errors in parsing input strings.

- To fix this issue, on your *local* machine (in other words, the **host** machine) modify your ``.bashrc`` 
  (or other source such as ``.zshrc``) to include the following lines:

.. code:: bash

  export LANGUAGE=en_US.UTF-8
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8

then source this script and try logging into the cluster again. The perl warning should go away, and issues related to 
parsing input strings as part of the configure and build process should be solved.