Comp
++++

The "comp" command allows selecting components of a multi-component
field. Individual components, or a specific sets of components, or a
range can be selected.

To pick a specific component from a five-moment simulation, for
example, do::

  pgkyl -f tf_q_10.h5 comp 0

This will pick the 0th component (electron density) from the field.

A list of components to select is separated by commas. To pick the
electron and ion density do::

  pgkyl -f tf_q_10.h5 comp 0,5

A range of components is specified using the colon operator. The last
index is not inclusive. To select a range of components, for example,
the electromagnetic field do::

  pgkyl -f tf_q_10.h5 comp 10:16

This will select 6 components starting from 10 and including 15. 
