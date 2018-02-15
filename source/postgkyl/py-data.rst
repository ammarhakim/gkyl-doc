Data submodule
++++++++++++++

The ``data`` submodule provides the baseline class ``GData`` for data
loading and manipulation, but it also includes tools for handling of
discontinuous Galerkin (DG) data and for data slicing and subselection.

.. contents::

GData class
-----------

``GData`` is a single unified class used for manipulation with all
*Gkeyll/Gkyl* data.  Externally, it does not distinguish between
ADIOS/HDF5 data nor between output frames and history sequence
data. The data loading is performed with:::

  import postgkyl as pg
  data = pg.data.GData('file.bp')


Init parameters and partial loading
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Appart from the file name, ``GData`` initialization has optional
parameters for partial loading (only works with ADIOS ``.bp`` files
now) and for the control of the internal stack.

.. list-table:: Initialization parameters for ``GData``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Decription
     - Default
   * - fileName (str)
     - Name of the file to be loaded or a name root for the history
       sequence load.
     - 
   * - coord0 (int or slice)
     - Index corresponding to the first coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - coord1 (int or slice)
     - Index corresponding to the second coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - coord2 (int or slice)
     - Index corresponding to the third coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - coord3 (int or slice)
     - Index corresponding to the fourth coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - coord4 (int or slice)
     - Index corresponding to the fifth coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - coord5 (int or slice)
     - Index corresponding to the sixth coordinate for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - comp (int or slice)
     - Index corresponding to the component for the partial
       load. Either integer or Python slice (e.g., '2:5').
     - None
   * - stack (bool)
     - Turns the internal data stack on and off.
     - True

Note that when specifying the slice, the last index is exclude,
i.e. '1:5' (quotes are required) is selecting the indices 1, 2, 3,
and 4.  The reasons for splitting the partial load indices into
individual parameters rather than multiple ``tuple`` like ``offset``
and ``count`` are: a) natural specification of the edges instead of
length and b) independance on other coordinates; user can subselect
just one coordinate without knowing how many elements have the other
one or even how many dimensions are there in total. Subselections of
higher dimensions than included in the data are safely ignored.

Gkyl data have offten one extra dimension.  This last dimension,
commonly refered to as *component*, can hade many meanings like vector
componets or DG expansion coefficients inside a cell.

Postgkyl is strictly retaining the number of dimensions and the
component index. This means that, for example, fixing the second
coordinate and selecting one component from originally 16 x 16 wit 8
components will produce data with a shape (16, 1, 1).  Note that
Postgkyl treats such data as 1D for the plotting purposes.

Members and the internal stack
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``GData`` inludes an internal stack for storing the history of data
manipulations (mainly usefull in the command line mode).  For this
reason, the internal variables should not be accesed directly but
rather through helper functions

.. list-table:: Members of the ``GData`` class
   :widths: 30, 70
   :header-rows: 1

   * - Member
     - Decription
   * - getBounds() -> narray, narray
     - Returns the upper and lower bounds for the current top of the
       stack.
   * - getNumCells() -> narray
     - Returns a narray withn numbers of cells.
   * - getNumComps() -> int
     - Returns the number of components (i.e., the last data index).
   * - getNumDims() -> int
     - Returns the nuber of dimentsions. Note that this includes the
       squeezed dimensions as well.
   * - peakGrid() -> [narray, ...]
     - Returns a list of 1D narray slices of the grid.
   * - peakValues() -> narray
     - Returns a narray of values with (N+1) dimensions.
   * - popGrid() -> narray
     - Returns a list of 1D narray slices of the grid and removes it
       from the stack (dissabled when the stack is off).
   * - popValues() -> narray
     - Returns a narray of values with (N+1) dimensions and removes it
       from the stack (dissabled when the stack is off).
   * - pushGrid(list grid, narray lo, narray up) -> None
     - Pushes the specified grid and bounds to the stack. Bounds are
       optional and when not specified, the previous values are used.
   * - pushValues(narray values) -> None
     - Pushes the specified values to the stack.
   * - info() -> str
     - Returns a string with information about the data

Note that ``info()`` produces a single string output. Therefore, it is
recommended to use ``print()`` for readable output::

  import postgkyl as pg
  data = pg.data.GData('bgk_neut_0.bp')
  print(data.info())

  - Time: 0.000000e+00
  - Number of components: 8
  - Number of dimensions: 2
    - Dim 0: Num. cells: 128; Lower: 0.000000e+00; Upper: 1.000000e+00
    - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
  - Maximum: 7.795721e-01 at (0, 15) component 0
  - Minimum: -5.179175e-02 at (0, 18) component 2


Note on history data
^^^^^^^^^^^^^^^^^^^^

``GData`` treats the output frame data and the history sequence data
the same way.  The time array is stored as a ``grid`` and values
naturally as ``values``.  The only internal difference is that the
history data are missing the ``GData.time`` variable (more preciselly,
it is set to ``None``).  By default, *Postgkyl* tries to load data as a
history when the file name is incomplete (history data are usually
spread accross multiple files) and as a frame when the file
exists. However, when a single file does not have the internal
structure of a *Gkyl* frame, *Postgkyl* tries to load it as a history
before raising an exception.

GInterp class
-------------

``GInterp`` is the class responsible for interpreting DG nodal and
modal data.  However, it should not be accessed directly; rather, its
childs ``GInterpModal`` and ``GInterpNodal`` should be used.

Init parameters
^^^^^^^^^^^^^^^
``GInterpModal`` and ``GInterpNodal`` share the initialization parameters

.. list-table:: Initialization parameters for ``GInterpModal`` and ``GInterpNodal``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Decription
     - Default
   * - gdata (GData)
     - A GData object to be used.
     - 
   * - polyOrder (int)
     - The polynomial order of the discontinuous Galerkin
       discretization.
     -
   * - basis (str)
     - The polynomial basis. Currently supported options are ``'ns'`` for
       nodal Serendipity, ``'ms'`` for modal Serendipity, and ``'mo'``
       for the maximal order basis.
     -

Members
^^^^^^^
After the initialization, both ``GInterpModal`` and ``GInterpNodal``
can be used to interpolate data on a uniform grid or to calculate
derivatives

.. list-table:: Members of ``GInterpModal`` and ``GInterpNodal``
   :widths: 30, 70
   :header-rows: 1

   * - Member
     - Decription
   * - interpolate(int component) -> narray, narray
     - Interpolates the selected component (default is 0) of the DG
       data on a uniform grid
   * - derivative(int component) -> narray, narray
     - Calculates the deriative of the DG data

An example of the usage::

  import postgkyl as pg
  data = pg.data.GData('bgk_neut_0.bp')
  interp = pg.data.GInterpModal(data, 2, 'ms')
  iGrid, iValues = interp.interpolate()

Select method
-------------
