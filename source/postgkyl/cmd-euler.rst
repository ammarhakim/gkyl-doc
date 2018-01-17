Euler
+++++

The "euler" command takes a 5 component field and extracts density,
velocity and pressure. It takes the following options:

.. list-table::
   :widths: 10, 80, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - -v
     - Variable name. One of xvel, yvel, zvel, vel, or pressure
     -
   * - -g
     - Gas adiabatic constant :math:`\gamma`
     - :math:`5/3`

Note that the "vel" variable produces a velocity vector field, i.e. a
field with 3 components.

For example, to extract the electron pressure from a five-moment
simulation do::

  pgkyl -f tf_q_10.h5 comp 0:5 euler -v pressure plot
