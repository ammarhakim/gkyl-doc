.. _pg_loading:

Data loading
++++++++++++

.. epigraph::

   "I disagree strongly with whatever work this quote is attached to."
   -- Randall Munroe

One can argue that loading data is the most important part of a
postprocessing tool. In Postgkyl, it is handled by the
``postgkyl.data.Data`` class (there is a ``postgkyl.Data``
shortcut). It load data on initialization and serves as an input for
all the other parts of Postgkyl.

.. raw:: html

   <details closed>
   <summary><a>Docstrings</a></summary>
   <iframe src="../_static/postgkyl/data/data.html"></iframe>
   </details>
   <br>

Examples are provided simultaneously for scripting and command line
using output files of an electrostatic two-stream instability
simulation [:doc:`two-stream.lua<input/two-stream>`].




Loading a Gkeyll file
---------------------

Gkeyll files are loaded in Postgkyl by creating a new instance of the
``Data`` class with the file name as the parameter.


.. raw:: html
         
   <details open>
   <summary><a>Script</a></summary>

.. code-block:: python

  import postgkyl as pg
  data = pg.Data(filename)

.. raw:: html
         
   </details>

In a command line mode, a data file is loaded using the ``-f`` flag
of the ``pgkyl`` script.

.. raw:: html
         
   <details open>
   <summary><a>Command line</a></summary>

.. code-block:: bash

  pgkyl -f filename

.. raw:: html
         
   </details>

Note that the syntax is the same for the newer Adios and older HDF5
file; however, some of the newer additions like information about
Gkeyll build, polynomial order, and basis functions are not available
for HDF5 files. Postgkyl also treats the data that are functions of
phase space coordinates the same way as the time-dependent quantities
of the integrated diagnostics.

Note that it is also possible to create an empty instance and store
data into it manually.

.. _pg_loading_stack:

Internal stack
--------------

With the command line interface utilizing the `Click
<http://click.pocoo.org>`_ Python package, an internal *stack* was
added to the the ``Data`` class. This means that instead of just including
a NumPy array for values, ``Data`` class includes a ``list`` of NumPy
arrays. Each command or function that can add and remove things from
the stack. As this might be quite memory intensive, Postgkyl
allows to turn this off.

.. raw:: html
         
   <details open>
   <summary><a>Script</a></summary>

.. code-block:: python

  import postgkyl as pg
  data = pg.Data(filename, stack=False)

.. raw:: html
         
   </details>       
   <details open>
   <summary><a>Command line</a></summary>

.. code-block:: bash

  pgkyl -f filename --no-stack

.. raw:: html

  </details>

Note that even with the stack off, ``Data`` still contains a list of
NumPy arrays but this list always contain only one element which gets
overwritten.

The ``Data`` class serves as an input to the most of the Postgkyl
functions. The function themselves then have an option to either
return the result or add it to the stack of the input. We can use the
:ref:`pg_cmd_interpolate` as an example. It can return new grid
and values.

.. raw:: html
         
   <details open>
   <summary><a>Script not using the stack</a></summary>

.. code-block:: python
  :emphasize-lines: 4

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp')
  dg = pg.GInterpModal(data)
  grid, values = dg.interpolate()

.. raw:: html
         
   </details>

Alternatively, it can put the new results back to the stack of the
``data`` object. This has an advantage that ``data`` can be easily
passed to other Postgkyl functions which take a ``Data`` class as an
input.

.. raw:: html
         
   <details open>
   <summary><a>Script using the stack</a></summary>

.. code-block:: python
  :emphasize-lines: 4

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp')
  dg = pg.GInterpModal(data)
  dg.interpolate(stack=True)
  pg.output.plot(data)

.. raw:: html
         
   </details>

Member functions
----------------

In a script, data can be accessed using the member functions. 

.. list-table::
   :widths: 30, 70
   :header-rows: 1

   * - Function
     - Description
   * - getBounds() -> narray, narray
     - Returns the upper and lower bounds for the current top of the
       stack.
   * - getNumCells() -> narray
     - Returns a Numpy array with numbers of cells.
   * - getNumComps() -> int
     - Returns the number of components (i.e., the last data index).
   * - getNumDims() -> int
     - Returns the number of dimensions. Note that this includes the
       squeezed dimensions as well.
   * - getGrid() -> [narray, ...]
     - Returns a list of 1D Numpy array slices of the grid.
   * - getValues() -> narray
     - Returns a NumPy array of values with (N+1) dimensions.
   * - pop() -> [narray, ...], narray
     - Returns a list of NumPy arrays for grid and a NumPy array of
       values with (N+1) dimensions and removes it from the stack
       (disabled when the stack is off).
   * - push(narray values, list grid=None) -> None
     - Pushes the specified values and grid to the stack.
   * - info() -> str
     - Returns a string with information about the data
   * - getInputFile() -> str
     - Returns an emended Lua input file for the simulation.
   * - write(int buffersize, str outName, bool txt) -> None
     - Writes data into ADIOS ``bp`` file or ASCII ``txt`` file

The first few functions, ``getBounds()``, ``getNumCells()``, ``getNumComps()``,
and ``getNumDims()``, return a number NumPy array(s) or a single
integer number. 

.. raw:: html
         
   <details>
   <summary><a>Script example</a></summary>

.. code-block:: python
  :emphasize-lines: 1,2,3,5,7,9

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp')
  print(data.getBounds())
    (array([-6.283185307179586, -6.]), array([6.283185307179586, 6.]))
  print(data.getNumCells())
    [64 64]
  print(data.getNumComps())
    8
  print(data.getNumDims())
    2
  
.. raw:: html
         
   </details>
   <br>

``getGrid()`` and ``getValues()`` return the grid and values array
respectively. For structured meshes, the ``getGrid()`` return a Python
``list`` of 1D NumPy arrays which represent the nodal points of the
grid in each dimension. Note that since these are nodal points, these
arrays will always have one more cell in each dimension in comparison
to the value array. Another important note is that the **value array
always have one extra dimension for components**. This extra dimension
is always retained even if there is just one component.

.. raw:: html
         
   <details>
   <summary><a>Script example</a></summary>

.. code-block:: python
  :emphasize-lines: 1,2,3,36,47,49,51

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp')
  print(data.getGrid())
    [array([-6.283185307179586 , -6.086835766330224 , -5.890486225480862 ,
            -5.6941366846315   , -5.497787143782138 , -5.301437602932776 ,
            -5.105088062083414 , -4.908738521234052 , -4.71238898038469  ,
            -4.516039439535327 , -4.319689898685965 , -4.123340357836604 ,
            -3.9269908169872414, -3.730641276137879 , -3.5342917352885173,
            -3.3379421944391554, -3.141592653589793 , -2.945243112740431 ,
            -2.748893571891069 , -2.552544031041707 , -2.356194490192345 ,
            -2.1598449493429825, -1.9634954084936211, -1.7671458676442588,
            -1.5707963267948966, -1.3744467859455343, -1.178097245096172 ,
            -0.9817477042468106, -0.7853981633974483, -0.589048622548086 ,
            -0.3926990816987246, -0.1963495408493623,  0.                ,
             0.1963495408493623,  0.3926990816987246,  0.589048622548086 ,
             0.7853981633974483,  0.9817477042468106,  1.178097245096172 ,
             1.3744467859455343,  1.5707963267948966,  1.767145867644258 ,
             1.9634954084936211,  2.1598449493429825,  2.356194490192344 ,
             2.552544031041707 ,  2.7488935718910685,  2.9452431127404317,
             3.141592653589793 ,  3.3379421944391545,  3.5342917352885177,
             3.730641276137879 ,  3.9269908169872423,  4.123340357836604 ,
             4.319689898685965 ,  4.516039439535328 ,  4.71238898038469  ,
             4.908738521234051 ,  5.105088062083414 ,  5.301437602932776 ,
             5.497787143782137 ,  5.6941366846315   ,  5.890486225480862 ,
             6.086835766330225 ,  6.283185307179586 ]),
     array([-6.    , -5.8125, -5.625 , -5.4375, -5.25  , -5.0625, -4.875 ,
            -4.6875, -4.5   , -4.3125, -4.125 , -3.9375, -3.75  , -3.5625,
            -3.375 , -3.1875, -3.    , -2.8125, -2.625 , -2.4375, -2.25  ,
            -2.0625, -1.875 , -1.6875, -1.5   , -1.3125, -1.125 , -0.9375,
            -0.75  , -0.5625, -0.375 , -0.1875,  0.    ,  0.1875,  0.375 ,
             0.5625,  0.75  ,  0.9375,  1.125 ,  1.3125,  1.5   ,  1.6875,
             1.875 ,  2.0625,  2.25  ,  2.4375,  2.625 ,  2.8125,  3.    ,
             3.1875,  3.375 ,  3.5625,  3.75  ,  3.9375,  4.125 ,  4.3125,
             4.5   ,  4.6875,  4.875 ,  5.0625,  5.25  ,  5.4375,  5.625 ,
             5.8125,  6.    ])]
  print(data.getValues())
    [[[ 1.6182154425614533e-127  2.2497634664678846e-136
        2.1705614015952743e-127 ...  1.4466223559100639e-127
        7.7862978418103503e-137  2.0112020871650523e-136]
      [ 7.2163320153412515e-118  1.0032681083505769e-126
        9.6785762877207286e-118 ...  6.4497610162539372e-118
        3.4719259660326997e-127  8.9669370964188083e-127]
      [ 1.3363156717841295e-108  1.8578453383418215e-117
        1.7920360303344134e-108 ...  1.1940080895062958e-108
        6.4284392330301674e-118  1.6599988152412963e-117]
      ...
  print(data.getGrid()[0].shape)
    (65,)
  print(data.getGrid()[1].shape)
    (65,)
  print(data.getValues().shape)
    (64, 64, 8)
      
.. raw:: html
         
   </details>
   <br>

``pop()`` behaves very similarly to ``getGrid()`` and ``getValues()``
with the difference that it returns grid and values simultaneously
and removes them from the :ref:`pg_loading_stack`. Analogously,
``push(values, grid=None)`` allows to add new values and grid to the
stack. The ``grid`` is optional for ``push``. If it is not specified,
the previous ``grid`` is reused in the stack. This is useful for many
operations that modify only the values and not the grid.

``info()`` returns information about grid, minimum and maximum values
and some meta data like the Gkyl build number and date that was used
to create the output file. Note that the information is returned as a
string and, therefore, ``print()`` is required to visualize it with
proper line breaks. This is also the function that the
:ref:`pg_cmd_info` command calls for each data set.

.. raw:: html
         
   <details open>
   <summary><a>Script</a></summary>

.. code-block:: python
  :emphasize-lines: 3

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp')
  print(data.info())
    - Time: 0.000000e+00
    - Frame: 0
    - Number of components: 8
    - Number of dimensions: 2
    - Grid: (uniform)
      - Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
      - Dim 1: Num. cells: 64; Lower: -6.000000e+00; Upper: 6.000000e+00
    - Maximum: 3.804653e+00 at (31, 26) component 0
    - Minimum: -6.239745e-01 at (31, 38) component 2
    - DG info:
      - Polynomial Order: 2
      - Basis Type: serendipity (modal)
    - Created with Gkeyll:
      - Changeset: 9e81ededec52+
      - Build Date: Sep 21 2020 06:07:17

.. raw:: html
         
   </details>
   <details>
   <summary><a>Command line</a></summary>
  
.. code-block:: bash
  :emphasize-lines: 1
                    
  pgkyl -f two-stream_elc_0.bp info
    - Time: 0.000000e+00
    - Frame: 0
    - Number of components: 8
    - Number of dimensions: 2
    - Grid: (uniform)
      - Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
      - Dim 1: Num. cells: 64; Lower: -6.000000e+00; Upper: 6.000000e+00
    - Maximum: 3.804653e+00 at (31, 26) component 0
    - Minimum: -6.239745e-01 at (31, 38) component 2
    - DG info:
      - Polynomial Order: 2
      - Basis Type: serendipity (modal)
    - Created with Gkeyll:
      - Changeset: 9e81ededec52+
      - Build Date: Sep 21 2020 06:07:17

.. raw:: html
         
   </details>

Gkeyll output files also in most cases include the Lua input file which
was used for the run. This improves reproducibility and helps with
book keeping. ``getInputFile()`` returns a string with the file. This
is particularly useful in the command line mode with the
:ref:`pg_cmd_extractinput` command and Linux piping. This can create
an input file which is immediately usable with ``gkyl``

.. raw:: html
         
   <details open>
   <summary><a>Command line</a></summary>
  
.. code-block:: bash
  :emphasize-lines: 1,2
                    
  pgkyl -f two-stream_elc_0.bp extractinput > input.lua
  gkyl input.lua
    Fri Oct 02 2020 12:30:48.000000000
    Gkyl built with 4aad9d94863f+
    Gkyl built on Oct  1 2020 09:44:52
    Initializing Vlasov-Maxwell simulation ...
    Initializing completed in 0.0575099 sec

    Starting main loop of Vlasov-Maxwell simulation ...
    
.. raw:: html
         
   </details>

Finally, the ``write`` function allows to write data either to a Adios
``bp`` file or to a simple text file. It is called by the
:ref:`pg_cmd_write` command. The default behavior is to write a ``bp``
file, but this can be changed with setting ``txt=True``. The
``outName`` can be specified manually but can be also left blank, in
which Postgkyl constructs a new name. When using the ``bp`` mode, the
function allows to set the Adios parameter ``bufferSize``. By default,
it is set to 1000 (default Adios value) but can be increased if
needed. Apart from storing the data post-process with a command line
chain, it is useful for users that want to different post-processing
tool, e.g. Matlab, but want to use Postgkyl to read Gkeyll data and
interpolate them to a finite-volume-like format.

.. raw:: html
         
   <details open>
   <summary><a>Command line example</a></summary>
  
.. code-block:: bash
  :emphasize-lines: 1
                    
  pgkyl -f two-stream_elc_0.bp interpolate write -f new_file.bp
  
.. raw:: html
         
   </details>

Loading multiple files in a terminal
------------------------------------

Loading multiple files in a script is simple; one creates more
instances of the ``Data`` class. Postgkyl does support loading
multiple files in the command line mode as well by simply using
multiple ``-f`` flags.

.. code-block:: bash

  pgkyl -f two-stream_elc_0.bp -f two-stream_ion_0.bp

Loading multiple files is the reason why is the ``-f`` flag always
mandatory rather than taking an argument without any flags. Postgkyl
makes no assumptions about the number of data files.

All the following commands are then generally performed on all the
data sets. Commands like :ref:`pg_cmd_interpolate` are performed in
parallel on all the data. This is also the default behavior of the
:ref:`pg_cmd_plot` command; it creates a separate figure for each data
set. This can, however, be altered with :ref:`pg_cmd_plot` options to
allow, for example, a direct comparison of data. See the
:ref:`pg_cmd_plot` page for more details.

Performing commands on all the data sets in parallel is not always
desired. An example of that might be a comparison of kinetic (DG) and
fluid (finite-volume) results. There, a user wants to
:ref:`pg_cmd_interpolate` only the kinetic DG data. For these cases,
Postgkyl has the :ref:`pg_cmd_dataset` command, which allows to select
only some data sets, perform some commands, and then select all
data sets again. Note that for this, all the data set are numbered from
zero up in the order they were loaded.

.. raw:: html
         
   <details open>
   <summary><a>Command line</a></summary>
  
.. code-block:: bash
  :emphasize-lines: 1
                    
  pgkyl -f kinetic.bp -f fluid.bp dataset -i 0 interpolate dataset -a plot -f0
    
.. raw:: html
         
   </details>

There are also some commands like :ref:`pg_cmd_collect` and
:ref:`pg_cmd_ev` which create a new data set out of existing
ones. These commands then set the newly created data set as the only
active one. However, the other data sets are still available through
the :ref:`pg_cmd_dataset` command.

When in doubt about a data set index, one can always use the
:ref:`pg_cmd_info` command. By default, it shows only the active data
sets but can show all with the ``-a`` flag.

Postgkyl also allows for loading with a wild card characters:

.. raw:: html
         
   <details open>
   <summary><a>Command line</a></summary>

.. code-block:: bash

  pgkyl -f 'two-stream*.bp'

.. raw:: html
         
   </details>

It is important to stress out that the **quotes are required** in this
case. Without the quotes, the command line interpreter simply
"unrolls" the expression creating something like 

Note that the quotes are mandatory in this case because the whole
``file*.bp`` string needs to be pasted into the Postgkyl rather that
"unrolling" it directly on the command line:

.. code-block:: bash

  -> pgkyl -f two-stream_elc_0.bp two-stream_elc_1.bp ...

Without the ``-f``, ``two-stream_elc_1.bp`` gets interpreted as the
first commands and ``pgkyl`` ends up with an unknown command
error. When the file name is passed with quotes, the wild card
characters are nor resolved but the whole string is passed to
Postgkyl and the names are then properly resolved inside. They are
also properly sorted so a file name ``two-stream_elc_2.bp`` will come
after ``two-stream_elc_100.bp``.

Finally, it is worth pointing out that using wild card characters might
lead to unexpected situations. For example in the two-stream case,
the query ``two-stream_elc_*`` is going to return
``two-stream_elc_0.bp`` but also ``two-stream_elc_M0_0.bp`` which is
in most cases not desirable. As the diagnostic outputs are adding to
the name, their names are usually unique enough so this does not cause
any problems. This, however, complicates loading all distribution
functions. One way to overcome this is to be more specific.

.. raw:: html
         
   <details open>
   <summary><a>Command line</a></summary>

.. code-block:: bash

  pgkyl -f 'two-stream_elc_[0-9]*.bp'

.. raw:: html
         
   </details>

This requires the first character of the wild card string to be a
number between 0 and 9, which effectively eliminates all the outputs
except for the distribution functions themselves.

Partial loading
---------------

Gkeyll output files, especially the higher dimensionality ones, can be
large. Therefore, Postgkyl allows to load just a smaller subsection of
each file. This is done with the optional ``z0`` to ``z5`` parameters
for coordinates and ``comp`` for components. Each can be either an
integer number or a string in the form of ``start:end``. Note that
this does follow the Python conventions so **the last index is
excluded**, i.e., ``1:5`` will load only the indices/components 1, 2,
3, and 4. This functionality is supported both in the script mode and
the command line mode.

.. raw:: html
         
   <details open>
   <summary><a>Script</a></summary>

.. code-block:: python
  :emphasize-lines: 5

  import postgkyl as pg
  data = pg.Data('two-stream_elc_0.bp', z1='1:3', comp=0)
.. raw:: html
         
   </details>
   <details open>
   <summary><a>Command line</a></summary>
  
.. code-block:: bash

  pgkyl -f two-stream_elc_0.bp --z1 1:3 --comp 0

.. raw:: html
         
   </details>

Note that the :ref:`pg_cmd_select` command does a similar thing but
also allows extra options like specifying a coordinate value instead
of an index. However, it requires the whole file to be loaded.
