Interpolate
+++++++++++

The "interpolate" command allows interpolating data from a
discontinuous Galerkin simulation onto a finer mesh. By default, for
basis functions with polynomial order :math:`p` the command will
interpolate the solution in each cell onto :math:`p+1` sub-cells in
each direction. The command takes the following options:

.. list-table::
   :widths: 10, 80, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - -b
     - Basis functions. One of  "ms" for modal serendipity, "ns" for nodal serendipity, "mo" for maximal-order
     -
   * - -p
     - Polynomial order of basis
     -
   * - -i
     -  Int. Interpolate on a finer mesh with specified sub-cells in each direction
     -
   * - -r
     - Read interpolation matrix from a file named "interpMatrix.h5"
     -

Notes: when using the `-r` option, the HDF5 file must contain the
interpolation matrix that has shape :math:`N_b \times N_i`, where
:math:`N_b` is the number of basis functions and :math:`N_i` is the
total number of sub-cells. Generating this matrix can be tricky, and
so should only be used in special cases.

Example::

  pgkyl -f vm_distf_10.h5 interpolate -b ns -p plot


This will read a distribution function computes by a nodal serendipity
polynomial order 2 scheme and pass the interpolated data to the *plot*
command.
