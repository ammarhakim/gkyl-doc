.. _valgrind:

How to run Valgrind on Gkeyll
==========================================================

Valgrind has an issue where it does not support AVX512 instruction sets. If your CPU supports AVX512, you will need to disable it when compiling Gkeyll. Valgrind does not work with a GPU build and you need a CPU build.

A few modifications must be made. 

First, in install-deps/build-openblas.sh change these lines

.. code-block:: bash

	make USE_OPENMP=0 NUM_THREADS=1 NO_FORTRAN=1 NO_AVX512=1 -j 32
	make USE_OPENMP=0 NUM_THREADS=1 NO_FORTRAN=1 NO_AVX512=1 install PREFIX=$PREFIX -j 32

Now re-run mkdeps.sh to rebuild OpenBLAS

Second, within config.mak, set the march to "skylake", which disables AVX512

Third, inside the makefile, make sure that the march is skylake and add the following options

.. code-block:: make

	CFLAGS ?= -mno-avx -mno-avx2 -mno-avx512f