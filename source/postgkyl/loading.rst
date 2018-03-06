Data Loading
++++++++++++

Loading Files in the Command Line Mode
--------------------------------------

Loading data in the command line mode is done using the ``-f`` or
``--filename`` flag:

.. code-block:: bash

  pgkyl -f file.bp

Note that it is a parameter (keyword argument) rather than a simple
argument of the base ``pgkyl`` program.  This way, ``pgkyl`` can load
an arbitrary number of files:

.. code-block:: bash

  pgkyl -f file1.bp -f file2.bp

Without the ``-f`` flags, there is no simple way for Postgkyl to
determine whathever the input is a file to load or a first command.

A new data set is internally created for each file loaded.  Postgkyl
retains the input order, so the data in the ``file1.bp`` will become
the data set 0 and the data from the ``file2.bp`` will be data set 1.

Loading Multiple Files
^^^^^^^^^^^^^^^^^^^^^^

Apart from the above mentioned loading with multiple ``-f`` flags,
Postgkyl allows for loading with a wild card characters:

.. code-block:: bash

  pgkyl -f 'file*.bp'

Note that the quotes are mandatory in this case because the whole
``file*.bp`` string needs to be pasted into the Postgkyl rather that
"unrolling" it directly on the command line:

.. code-block:: bash

  pgkyl -f 'file*.bp' -> pgkyl -f file1.bp file2.bp ...

Finally, one needs to becareful about the wild card character because
of the way Gkyl outputs data files. For example, for species ``elc``
Gkyl will create ``sim_elc_0.bp``, ``sim_elc_1.bp``, ... However, it
could be also set to create dignostics data like ``sim_elc_M0_0.bp``
or ``sim_elc_intMom_0.bp``.  This way, running

.. code-block:: bash

  pgkyl -f 'sim_elc_*.bp'

would pull all of them.  The correct way is to manually exclude the
characters the diagnostics outpust start with:

.. code-block:: bash

  pgkyl -f 'sim_elc_[!iM]*.bp'

Loading Frames vs. Hstory Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Postgkyl treats the output frame data and the history sequence data
the same way.  Internally, the time array of history data is stored as
a ``grid`` and values naturally as ``values``. By default, Postgkyl
tries to load data as a history when the file name is incomplete
(history data are usually spread across multiple files), i.e.,

.. code-block:: bash

  pgkyl -f sim_elc_fieldEnergy_

and as a frame when the file exists. However, when a single file does
not have the internal structure of a Gkyl frame, Postgkyl tries to
load it as a history before raising an exception.

GData class
-----------

Internally, all the data loading is done throught the ``GData`` class.
It is a single unified class used for manipulation with all
Gkeyll/Gkyl data.  Externally, it does not distinguish between
ADIOS/HDF5 data nor between output frames and history sequence
data as was mentioned before. The data loading is performed with:

.. code-block:: python

  import postgkyl as pg
  data = pg.data.GData('file.bp')


Init parameters and partial loading
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Apart from the file name, ``GData`` initialization has optional
parameters for partial loading (currently, works only for ADIOS
``.bp`` files) and for the control of the internal stack.

.. list-table:: Initialization parameters for ``GData``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
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

Note that when specifying the slice, the last index is excluded,
i.e. '1:5' (quotes are required) is selecting the indices 1, 2, 3,
and 4.  The reasons for splitting the partial load indices into
individual parameters rather than multiple ``tuple`` like ``offset``
and ``count`` are: a) natural specification of the edges instead of
length and b) independent on other coordinates; user can subselect
just one coordinate without knowing how many elements have the other
one or even how many dimensions are there in total. Subselections of
higher dimensions than included in the data are safely ignored.

Gkyl data have often one extra dimension.  This last dimension,
commonly referred to as *component*, can have many meanings like vector
components or DG expansion coefficients inside a cell.

Postgkyl is strictly retaining the number of dimensions and the
component index. This means that, for example, fixing the second
coordinate and selecting one component from originally 16 x 16 wit 8
components will produce data with a shape (16, 1, 1).  Note that
Postgkyl treats such data as 1D for the plotting purposes.

Members and the internal stack
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``GData`` includes an internal stack for storing the history of data
manipulations (mainly useful in the command line mode).  For this
reason, the internal variables should not be accessed directly but
rather through helper functions

.. list-table:: Members of the ``GData`` class
   :widths: 30, 70
   :header-rows: 1

   * - Member
     - Description
   * - getBounds() -> narray, narray
     - Returns the upper and lower bounds for the current top of the
       stack.
   * - getNumCells() -> narray
     - Returns a narray with numbers of cells.
   * - getNumComps() -> int
     - Returns the number of components (i.e., the last data index).
   * - getNumDims() -> int
     - Returns the number of dimensions. Note that this includes the
       squeezed dimensions as well.
   * - peakGrid() -> [narray, ...]
     - Returns a list of 1D narray slices of the grid.
   * - peakValues() -> narray
     - Returns a narray of values with (N+1) dimensions.
   * - popGrid() -> narray
     - Returns a list of 1D narray slices of the grid and removes it
       from the stack (disabled when the stack is off).
   * - popValues() -> narray
     - Returns a narray of values with (N+1) dimensions and removes it
       from the stack (disabled when the stack is off).
   * - pushGrid(list grid, narray lo, narray up) -> None
     - Pushes the specified grid and bounds to the stack. Bounds are
       optional and when not specified, the previous values are used.
   * - pushValues(narray values) -> None
     - Pushes the specified values to the stack.
   * - info() -> str
     - Returns a string with information about the data
   * - write() -> None
     - Writes data into ADIOS ``bp`` file or ASCII ``txt`` file

More information about the ``info`` and ``write`` methods is in the
:ref:`pg_output` section.  


