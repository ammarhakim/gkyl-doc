.. _pg_usage:

Using Postgkyl
++++++++++++++

Postgkyl is, at its core, a Python library. When properly installed
(see :ref:`pg_installing`), it can be loaded in any Python script or
interactive environment like `IPython <https://ipython.org/>`_ or
`JupyterLab <https://jupyter.org/>`_.
   
.. code-block:: python

   import postgkyl

Postgkyl understands all the Gkeyll data outputs (including the legacy
Gkeyll 1 files), can transform the raw expansion coefficients of
Gkeyll basis functions to more intuitive finite-volume style data, and
also contains many postprocessing functions. See the following
sections for more details.
 
.. toctree::
   :maxdepth: 1

   loading
   commands

What makes Postgkyl quite unique, is the wrapping of all the *functions*
into command line *commands* using the `Click
<http://click.pocoo.org>`_ Python package.  In other words, almost the
full functionality of Postgkyl can be used directly from a
terminal. This has beneficts for everyday work where typing a single
command is faster than writing a Python script and also for work with
remote machines and supercomputers, which are primarily accessed through a
terminal. However, the classical way of using Postgkyl in a script
still provides more control and is well suited, for example, for loang
and complex scripts for publication level figures.

The command line executable for Postgkyl is called ``pgkyl`` and its
call has the following synopsis:

.. code-block:: bash

  pgkyl [OPTIONS] COMMAND1 [ARGS]... [COMMAND2 [ARGS]...]...

The ``OPTIONS`` serve mostly for the data loading and are followed by
a pipe of commands. Each data file needs to prefixerd with the flag
``-f`` (this is required to load arbitrary number of inputs). Another
usefult options are ``-l`` to label the inputs and ``-v`` for
verbose. See :ref:`pg_loading` section for more details.

While there are not theoretical limitation for the command order, it
us up to the user to make sure that the sequence has a logical
sense. For example, two stream instability DG data have 8 components,
each representing an expansion coefficients of the modal basis (see
:ref:`dev_modalbasis`). The data file is probed using the
:ref:`pg_cmd_info` command.

.. code-block:: bash
   
   pgkyl -f two-stream_elc_0.bp info

   Dataset #0
   - Time: 0.000000e+00
   - Number of components: 8
   - Number of dimensions: 2
     - Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
     - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 1.676015e+00 at (31, 18) component 0
   - Minimum: -4.698334e-01 at (31, 19) component 2

The :ref:`pg_cmd_interpolate` command then evaluates the solution on a
uniform mesh, which is useful for plotting. The mesh will have higher
resolution (3x resolution for the second order polynomial
approximation) and the number of components decreases to 1.

.. code-block:: bash

   pgkyl -f two-stream01_elc_0.bp interpolate -p2 -b ms info

   Dataset #0
   - Time: 0.000000e+00
   - Number of components: 1
   - Number of dimensions: 2
     - Dim 0: Num. cells: 192; Lower: -6.283185e+00; Upper: 6.283185e+00
     - Dim 1: Num. cells: 96; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 9.498275e-01 at (95, 55)
   - Minimum: -6.751242e-04 at (97, 62)

Calling :ref:`pg_cmd_interpolate` one more time will then result in an
error because the data no longer have the format of the expansion
coefficients.


Each command pushes data to the top of stack; i.e. the history is
retained. The last entry to the stack can be deleted with the
:ref:`pg_cmd_pop` command. The following example shows a situation
where data are loaded, interpolated, and then reverted back. The total
of three :ref:`pg_cmd_info` commands is used in addition to the verbose
``-v`` flag to demonstrate this behavior 

.. code-block:: bash

   pgkyl -v -f two-stream01_elc_0.bp info interpolate -p2 -b ms info pop info

   [0.000002] This is Postgkyl running in verbose mode!
   [0.000071] Spam! Spam! Spam! Spam! Lovely Spam! Lovely Spam!
   [0.000093] And now for something completely different...
   [0.000119] Loading 'two-stream01_elc_0.bp' as data set #0
   [0.001475] Starting info
   [0.001522] Printing the current top of stack information (active data sets):
   Dataset #0
   - Time: 0.000000e+00
   - Number of components: 8
   - Number of dimensions: 2
     - Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
     - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 1.676015e+00 at (31, 18) component 0
   - Minimum: -4.698334e-01 at (31, 19) component 2

   [0.001801] Finishing info
   [0.001852] Starting interpolate
   [0.001930] interpolate: interpolating dataset #0
   [0.009575] Finishing interpolate
   [0.009740] Starting info
   [0.009811] Printing the current top of stack information (active data sets):
   Dataset #0
   - Time: 0.000000e+00
   - Number of components: 1
   - Number of dimensions: 2
     - Dim 0: Num. cells: 192; Lower: -6.283185e+00; Upper: 6.283185e+00
     - Dim 1: Num. cells: 96; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 9.498275e-01 at (95, 55)
   - Minimum: -6.751242e-04 at (97, 62)

   [0.010365] Finishing info
   [0.010498] Poping the stack
   [0.010663] Starting info
   [0.010733] Printing the current top of stack information (active data sets):
   Dataset #0
   - Time: 0.000000e+00
   - Number of components: 8
   - Number of dimensions: 2
     - Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
     - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 1.676015e+00 at (31, 18) component 0
   - Minimum: -4.698334e-01 at (31, 19) component 2

   [0.011342] Finishing info
