.. _pg_cmd-select:

select: data subsets and slices
-------------------------------

.. list-table:: Parameters for ``select``
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

Unlike for the partial load parameters (see :ref:), float point numbers can be
specified instead of just integers.  In that case, Postgkyl treats
it as a grid value and automatically finds and index of a grid point
with the closest value.  This works both for the single index and for
specifying a slice.

Gkyl data have often one extra dimension.  This last dimension,
commonly referred to as *component*, can have many meanings like
vector components or DG expansion coefficients inside a cell. The
specification by a value (float point number) is meaningless for the
component index.  On the other hand, ``select`` allows for the
selection of multiple coma separated components.

Postgkyl is strictly retaining the number of dimensions and the
component index. This means that, for example, fixing the second
coordinate and selecting one component from originally 16 x 16 wit 8
components will produce data with a shape (16, 1, 1).  Note that
Postgkyl treats such data as 1D for the plotting purposes.
