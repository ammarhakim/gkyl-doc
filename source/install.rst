.. _install:

Installing :math:`\texttt{Gkeyll}`
==================================

:math:`\texttt{Gkeyll}` features a variety of machine files and installation scripts,
which are intended to facilitate the process of building and installing all of the
requisite dependencies, as well as the code itself, on various different operating
systems and supercomputer clusters. The entire process is designed to be as automated as
possible. Below, we shall describe the typical process of building
:math:`\texttt{Gkeyll}` on a personal computer (for both macOS and Linux), as well as on
a supercomputer cluster.

This page is somewhat lengthy, but fear not: the process itself
is quick and straightforward! The length is testament to the fact that
:math:`\texttt{Gkeyll}` is highly customizable, with many possible configurations and
options for building on a single CPU (without MPI), on multiple CPUs (with MPI), on a
single GPU (with CUDA), on multiple GPUs (with CUDA *and* NCCL), etc. We also detail
various ways to test whether a particular installation of :math:`\texttt{Gkeyll}` is
configured and working correctly, as well as how to install the
:math:`\texttt{postgkyl}` visualization and post-processing pipeline in Python. The
instructions below assume that you have a working C compiler (such as ``gcc`` or
``clang`` when building for CPUs on macOS or Linux, or ``nvcc`` when building for GPUs)
installed on your machine.

The first step in any :math:`\texttt{Gkeyll}` installation is to clone the repository
from GitHub:

.. code-block:: bash

  git clone https://github.com/ammarhakim/gkylzero.git

and then, once it has been cloned, to navigate into the ``gkylzero`` directory:

.. code-block:: bash

  cd gkylzero

macOS Setup Instructions
------------------------

Building :math:`\texttt{Gkeyll}` on macOS is in many respects easier than on many other
platforms, since the existence of the macOS Developer Tools eliminates the need to
build and install ``OpenBLAS``, so the only dependencies that must be built and installed
are ``SuperLU`` and ``LuaJIT``. Installing ``SuperLU`` requires ``cmake``, which can be
installed straightforwardly using ``brew``:

.. code-block:: bash

  brew install cmake

Then, to download, build and install the ``SuperLU`` and ``LuaJIT`` dependencies on
macOS, simply run:

.. code-block:: bash

  ./machines/mkdeps.macos.sh

To generate the default :math:`\texttt{Gkeyll}` configuration on macOS (i.e. using Lua,
but not using CUDA, MPI, NCCL, ADAS, etc.), now run:

.. code-block:: bash

  ./machines/configure.macos.sh

which will generate the default ``config.mak`` configuration file for macOS.

Linux Setup Instructions
------------------------

The build process for :math:`\texttt{Gkeyll}` on Linux is very similar to the process
on macOS, except that ``OpenBLAS`` needs to be built and installed (in addition to
``SuperLU`` and ``LuaJIT``). Once again, the ``SuperLU`` installation requires
``cmake``, which can be installed using the ``apt`` package manager on distributions
such as Debian and Ubuntu:

.. code-block:: bash

  sudo apt update
  sudo apt install cmake

or the ``dnf`` package manager on distributions such as Fedora and CentOS:

.. code-block:: bash

  sudo dnf install cmake

Then, to download, build and install the ``OpenBLAS``, ``SuperLU``, ``LuaJIT`` and
``OpenMPI`` dependencies in Linux, simply run:

.. code-block:: bash

  ./machines/mkdeps.linux.sh

To generate the default :math:`\texttt{Gkeyll}` configuration on Linux for CPUs only
(i.e. using Lua, but not using CUDA, MPI, NCCL, ADAS, etc.), now run:

.. code-block:: bash

  ./machines/configure.linux-cpu.sh

which will generate the default ``config.mak`` configuration file for Linux on CPUs.

Building and Testing :math:`\texttt{Gkeyll}`
--------------------------------------------

Once the operating system-specific (or machine-specific) setup has been completed, as
described above, all that remains is to build :math:`\texttt{Gkeyll}` itself. To build
the entire :math:`\texttt{Gkeyll}` code (with the ``-j`` argument to enable maximal
parallel threading, if available), just run:

.. code-block:: bash

  make install -j

On the other hand, to build a specific app only (e.g. just :math:`\texttt{moments}`),
run:

.. code-block:: bash

  make moments-install -j

(where ``moments`` in the above can be replaced with ``core``, ``vlasov``,
``gyrokinetic`` or ``pkpm``, as appropriate) instead. If the ``make`` command runs
without errors, then congratulations: you're done! To confirm that the entire
:math:`\texttt{Gkeyll}` system has been built correctly, try building the complete
suite of C regression tests:

.. code-block:: bash

  make regression -j

and then running a simple ``pkpm`` C regression test (since the ``pkpm`` app exists at
the highest level of the :math:`\texttt{Gkeyll}` hierarchy, so this is a quick way to
confirm that the entire hierarchy has been built correctly):

.. code-block:: bash

  ./build/pkpm/creg/rt_pkpm_wall_p1

Likewise, to confirm that the :math:`\texttt{Gkeyll}` executable itself has been built
correctly (which includes the in-built Lua interpreter, thus allowing
:math:`\texttt{Gkeyll}` to run Lua input files), first run:

.. code-block:: bash

  make gkeyll -j

and then run the corresponding ``pkpm`` regression test from Lua using:

.. code-block:: bash

  ./build/gkeyll/gkeyll ./pkpm/luareg/rt_pkpm_wall_p1.lua

On the other hand, to confirm that only a specific app has been built correctly (e.g.
:math:`\texttt{moments}`, continuing the example from above), try building the suite of
C regression tests for that app only:

.. code-block:: bash

  make moments-regression -j

and then running a simple ``moments`` C regression test:

.. code-block:: bash

  ./build/moments/creg/rt_5m_gem

and likewise for any of ``core``, ``vlasov``, ``gyrokinetic`` and ``pkpm``. As a final
check to confirm that all components of the :math:`\texttt{Gkeyll}` system been built
correctly, try building and running the complete suite of unit tests:

.. code-block:: bash

  make check -j

and confirming that they all pass. Likewise, the suite of unit tests for only a specific
app (such as :math:`\texttt{moments}`) can be built and run using:

.. code-block:: bash

  make moments-check -j

and likewise for any of ``core``, ``vlasov``, ``gyrokinetic`` and ``pkpm``.

Installing :math:`\texttt{postgkyl}`
------------------------------------

:math:`\texttt{postgkyl}` is :math:`\texttt{Gkeyll}`'s custom-built Python
post-processing and visualization pipeline, capable of performing many advanced analysis
and plotting tasks on :math:`\texttt{Gkeyll}` simulation output. To build
:math:`\texttt{postgkyl}` from source, one must first clone the repository from GitHub:

.. code-block:: bash

  git clone https://github.com/ammarhakim/postgkyl.git

and then, once it has been cloned, navigate into the ``postgkyl`` directory:

.. code-block:: bash

  cd postgkyl

At this point, we recommend using ``venv`` to create a Python virtual environment
specifically for :math:`\texttt{postgkyl}`, for instance by running:

.. code-block:: bash

  python -m venv /pgkyl

where ``/pgkyl`` in the above can be replaced with any file path, corresponding to where
the :math:`\texttt{postgkyl}` virtual environment should be stored. How this environment
should be activated depends upon which shell you are using (which you can determine by
running ``echo $0`` or ``echo $SHELL``). For ``bash`` or ``zsh``, you should run:

.. code-block:: bash

  source pgkyl/bin/activate

while for ``fish``, you should run:

.. code-block:: bash

  source pgkyl/bin/activate.fish

and finally for ``csh`` or ``tcsh``, you should run:

.. code-block:: bash

  source pgkyl/bin/activate.csh

where, in each of the above, ``pgkyl`` can be replaced by whichever alternative file
path the virtual environment was stored within, as applicable. Once the virtual
environment has been activated, :math:`\texttt{postgkyl}` itself can be installed
using ``pip``:

.. code-block:: bash

  pip install -e .

which will also automatically install each of :math:`\texttt{postgkyl}`'s dependencies,
i.e. ``click``, ``matplotlib``, ``msgpack``, ``numpy``, ``scipy``, ``sympy``, and
``tables``, as needed. Once the ``pip`` installation has been completed, 

.. toctree::
  :maxdepth: 2

  install