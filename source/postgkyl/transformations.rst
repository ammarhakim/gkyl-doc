Data Transformations: subselections
+++++++++++++++++++++++++++++++++++



Select method
-------------

The ``select`` method is very similar to the partial loading of the
``GData`` but has a few extra features which are unavailable before
the data are loaded.

Parameters
^^^^^^^^^^

.. list-table:: Parameters for the ``select`` method
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - data (GData)
     - Data to subselect.
     - 
   * - coord0 (int, float, or slice)
     - Index corresponding to the first coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - coord1 (int, float, or slice)
     - Index corresponding to the second coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - coord2 (int, float, or slice)
     - Index corresponding to the third coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - coord3 (int, float, or slice)
     - Index corresponding to the fourth coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - coord4 (int, float, or slice)
     - Index corresponding to the fifth coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - coord5 (int, float, or slice)
     - Index corresponding to the sixth coordinate for the partial
       load. Either integer, float, or Python slice (e.g., '2:5').
     - None
   * - comp (int, slice, or multiple)
     - Index corresponding to the component for the partial
       load. Either integer, Python slice (e.g., '2:5'), or
       multiple.
     - None

Unlike for the partial load parameters, float point numbers can be
specified instead of just integers.  In that case, *Postgkyl* treats
it as a grid value and automatically finds and index of a grid point
with the closest value.  This works both for the single index and for
specifying a slice.

The specification by a value (float point number) is meaningless for
the component index.  On the other hand, ``select`` allows for the
selection of multiple coma separated components.
