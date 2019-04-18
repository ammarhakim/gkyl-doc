Installing Gkeyll with Conda
+++++++++++++++++++++++++++++

Once `Conda <https://conda.io/miniconda.html>`_ is installed and added
to the ``PATH``, Gkeyll can be obtained with::

  conda install -c gkyl gkeyll

Note, that this will also install all dependencies into the Conda
install directory. Often this may lead to some conflicts, particularly
for the MPI installation, specially if there is another version of MPI
already located in the system. Gkeyll should be run using the MPI
provided by Conda.

In general, having Conda and source-built Gkeyll on the same machine
can cause confusion. In that case please use explicit paths to the
mpiexec and Gkeyll executable you wish to use when running
simulations.
