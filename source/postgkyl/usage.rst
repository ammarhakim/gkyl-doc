.. _pg_usage:

Using Postgkyl
==============

Postgkyl is, at its core, a Python library. When properly installed
(see :ref:`pg_install`), it can be loaded in any Python script or
interactive environment like `IPython <https://ipython.org/>`_ or
`JupyterLab <https://jupyter.org/>`_.
   
.. code-block:: python

   import postgkyl

Postgkyl can be used to read all the Gkeyll data outputs (including
the legacy Gkeyll 1 files), can transform the raw expansion
coefficients of Gkeyll basis functions to finite-volume style data,
and also contains many postprocessing functions. See the following
sections for more details.
 
.. toctree::
   :maxdepth: 1

   keyconcepts
   loading
   commands
   colormaps

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

The ``OPTIONS`` serve mostly to specify data files to work with
(Postgkyl can work with multiple data sets simultaneously). Each data
file needs to prefixerd with the flag ``-f`` (this is required to load
arbitrary number of inputs). Multiple data sets can be also loaded
using wild card characters. For more details about loading files, see
the :ref:`pg_loading` section. Another usefult options are ``-l`` to
label the inputs and ``-v`` for verbose. All the options can be listed
using the inbuilt help, ``pgkyl --help`` or ``pgkyl -h`` for short.

The ``OPTIONS`` are followed by a chain of commands. The commands are
generally applied to all the data set and work in a similar manner to
Linux piping, where the output of one command is passed and an input
to the next one. There is no theoretical limitation for the number of
commands. This allows to perform even a rather complex diagnostics
straight up from the terminal. However, this puts a responsibility on
the user to ensure that the commands are called in a logical
order. Similarly to the main part of ``pgkyl``, ``--help`` can be
called for each individual command which will provide additional
information. Finally, it is worth mentioning that it is not necessary
to write the full names of each command and the shortest unique
sequence is good enough. Still, full names will be used through this
documentation for clarity.


Quickstart
----------

For a quick set of examples, consider the output of a two-stream
instability simulation [:doc:`two-stream.lua<input/two-stream>`].

List outputs
............

We can list the different kinds of files outputted by the simulation
with the :ref:`pg_cmd_listoutputs` command 

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl list
  two-stream_elc
  two-stream_elc_M0
  two-stream_elc_M1i
  two-stream_elc_M2ij
  two-stream_elc_M3i
  two-stream_field

Notice that we used the abbreviation ``list`` instead of ``listoutputs``;
this is allowed and whenever convenient we will use abbreviations if
the meaning is clear. This writes out a list of the unique filename
stems of the files outputted by a simulation.

Obtain file information
.......................

Now suppose we wish to know more about one file in particular, say the
electron initial condition. We can load the data set and probe it with
the :ref:`pg_cmd_info` command:

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl two-stream_elc_0.bp info
  Set  (default#0)
  ├─ Time: 0.000000e+00
  ├─ Frame: 0
  ├─ Number of components: 8
  ├─ Number of dimensions: 2
  ├─ Grid: (uniform)
  │  ├─ Dim 0: Num. cells: 64; Lower: -6.283185e+00; Upper: 6.283185e+00
  │  └─ Dim 1: Num. cells: 64; Lower: -6.000000e+00; Upper: 6.000000e+00
  ├─ Maximum: 3.804653e+00 at (31, 26) component 0
  ├─ Minimum: -6.239745e-01 at (31, 38) component 2
  ├─ DG info:
  │  ├─ Polynomial Order: 2
  │  └─ Basis Type: serendipity (modal)
  ├─ Created with Gkeyll:
  │  ├─ Changeset: 82231b06678c+
  │  └─ Build Date: Feb  7 2021 09:14:06

The output shows (in order):

- Simulation time of this snapshot.
- Frame number of this snapshot.
- Number of degrees of freedom per cell (components). In this case 8
  basis functions for the second order 2D Serendipity basis
  ([Arnold2011]_, see :ref:`dev_modalbasis` for more details).
- Number of dimensions (in this case 2 because it is a 1x1v simulation, 1D in
  position and 1D in velocity).
- The grid resolution and extents.
- The maximum value of the dataset (in this case largest DG coefficient).
- The minimum value of the dataset (in this case smallest DG coefficient).
- The polynomial order and type of basis.
- The Gkeyll build used to produce this simulation.

Plotting (interpolated data or single coefficients)
...................................................

In the case of DG data one is most frequently interested in plotting
the actual function instead of its expansion (DG) coefficients. To do so
we construct finite-volume-like dataset on a uniform mesh with higher
resolution using the :ref:`pg_cmd_interpolate` command. If we interpolate 
the same dataset (electron initial condition) as in the previous example
and inspect it with ``info``, we get

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp interpolate info
  Set  (default#0)
  ├─ Time: 0.000000e+00
  ├─ Frame: 0
  ├─ Number of components: 1
  ├─ Number of dimensions: 2
  ├─ Grid: (uniform)
  │  ├─ Dim 0: Num. cells: 192; Lower: -6.283185e+00; Upper: 6.283185e+00
  │  └─ Dim 1: Num. cells: 192; Lower: -6.000000e+00; Upper: 6.000000e+00
  ├─ Maximum: 1.970512e+00 at (96, 79)
  ├─ Minimum: -1.177877e-08 at (94, 60)
  ├─ DG info:
  │  ├─ Polynomial Order: 2
  │  └─ Basis Type: serendipity (modal)
  ├─ Created with Gkeyll:
  │  ├─ Changeset: 82231b06678c+
  │  └─ Build Date: Feb  7 2021 09:14:06

Note that now there is only one degree of freedom (component) per cell but
there are 3X more cells; we have interpolated the function onto a finer mesh.

We can then plot the distribution function evaluated on this finer mesh
with the :ref:`pg_cmd_plot` command

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl two-stream_elc_0.bp interp plot

Note the allowed abbreviation of ``interpolate`` to ``interp``. This command
produces the figure below:

.. figure:: fig/default2D_0.png
  :align: center

In some cases one may also be interested in plotting single expansion 
coefficients. The most common use is to, for example, plot the cell-averaged
value (which is the zeroth coefficient times a constant). We can select
specific coefficients in all cells with the :ref:`pg_cmd_select` and the
``-c`` flag. So, to plot the cell averaged electron distribution function
(times a factor) we would use

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl two-stream_elc_0.bp select -c0 plot


Which produces the figure below. Notice how the values are slightly different
and the resolution is coarser than in the previous plot of interpolated data.

.. figure:: fig/default2D_c0_0.png
  :align: center

Plot data slices
................

The :ref:`pg_cmd_select` command introduced in the previous example can also be
used with the ``--z`` flag in order to select a data slice which we may
subsequently plot. In the two stream instability example, the electron initial
condition is clearly independent of position, so we can plot as a function of
velocity space at `x=-2.0` with

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl two-stream_elc_0.bp interp select --z0 -2. plot

producing the following plot


.. figure:: fig/default2D_z0eqm2p0_0.png
  :align: center

Postgkyl is currently limited to 1D and 2D plots, so in order to visualize
datasets that have more than 3 dimensions one may need to select several slices
at once. You can do that with multiple ``--z`` flags. For example, if we have a
2x2v simulation producing four-dimensional distribution functions, we can select
a slice at `vx=0.` and `vy=1.` with ``--z2 0. --z3 1.``. 


Extracting input file
.....................

In our commitment to reproducibility, Gkeyll output files store the
Lua input file used to produce that data. This input file can be
extracted using the :ref:`pg_cmd_extractinput` command, as follows

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl two-stream_elc_0.bp extractinput

By default, this commands simply prints the input file to screen.
However, this could be easily piped into a new file with

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp extractinput > newInputFile.lua



Reference
---------

.. [Arnold2011] Arnold, D. N. and Awanou, G. "The serendipity family
                of finite elements." *Foundations of Computational
                Mathematics* 11.3 (2011): 337-344.
