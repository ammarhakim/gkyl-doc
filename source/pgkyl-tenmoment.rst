Tenmoment
+++++++++

The "tenmoment" command takes a 10 component field and extracts
density, velocity, scalar pressure and components of pressure
tensor. It takes the following options:

.. list-table::
   :widths: 10, 80, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - -v
     - Variable name. One of xvel, yvel, zvel, vel, pxx, pxy, pxz, pyy, pyz, pzz or pressure
     -

Note that the "vel" variable produces a velocity vector field, i.e. a
field with 3 components. The "pressure" variable produces a 6
component field with the pressure tensor arranged as :math:`P_{xx},
P_{xy}, P_{xz}, P_{yy}, P_{yz}, P_{zz}`.

For example, to extract the electron :math:`P_{xy}` from a ten-moment
simulation do::

  pgkyl -f tm_q_10.h5 comp 0:10 tenmoment -v pxy plot
