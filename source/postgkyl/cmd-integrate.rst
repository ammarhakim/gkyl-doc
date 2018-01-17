Integrate
+++++++++

The integrate command is used to integrate a field along a specified
direction (axis). The resulting field has one lower dimension (i.e. a
2D field integrated along :math:`Y` will produce a 1D field). The
command takes no options, but only the direction to integrate as a
parameter.

Example::

  pgkyl -f tf_q_10.h5 comp 0:5 euler -v pressure integrate 1 plot

will plot the pressure integrated along the :math:`Y` axis (as a
function of :math:`X`).
