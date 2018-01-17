Fix
+++

The fix command is used to take slices of the data by "fixing"
specified set of coordinates. The fix command takes the following
options:

.. list-table::
   :widths: 30, 60, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - --index
     - Fix coordinates based on indices
     -
   * - --value
     - Fix coordinates based on values
     - Default
   * - --c0
     - Fix 1st coordinate
     -
   * - --c1
     - Fix 2nd coordinate
     -
   * - --c2
     - Fix 3rd coordinate
     -
   * - --c3
     - Fix 4th coordinate
     -
   * - --c4
     - Fix 5th coordinate
     -
   * - --c5
     - Fix 6th coordinate
     -     

Note that one can fix as many coordinates as needed, for example, to
take a line-out from 3D data.

By default, the `--c0` etc options take the coordinate *value* to
fix. However, one can also specify the *index* to fix by first using
the `--index` option.

For example, in a simulation run on :math:`[0,0]\times[1,1]` domain
with :math:`10\times 10` mesh, one can take a line-out along the
mid-plane by doing::

  pgkyl -f tf_q_10.h5 fix --c1 0.5

This will "fix" :math:`y=0.5` and push the sliced data on the data
stack. Instead of specifying the value, if one wants to take the slice
along the 5th Y index, one would do::
  
  pgkyl -f tf_q_10.h5 fix --index --c1 5

