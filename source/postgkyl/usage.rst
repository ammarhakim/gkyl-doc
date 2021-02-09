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

As a quick example, and output of two-stream instability
[:doc:`two-stream.lua<input/two-stream>`] is loaded and probed using
the :ref:`pg_cmd_info` command.

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl -f two-stream_elc_0.bp info
  Dataset #0
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

The output shows information about the data like grid extends and
minima and muxima but also information about Gkeyll build that was
used for running the simulation. Note that this raw data represent
expansion coefficients of the basis functions. The 8 components
correspond to the 8 basis functions for the second order 2D
Serendipity basis ([Arnold2011]_, see :ref:`dev_modalbasis` for more
details). This information can be used to construct finite-volume like
data on uniform mesh with higher resolution using the
:ref:`pg_cmd_interpolate` command. This is particulary useful for
plotting. Note that the resolution increases 3x and the number of
components drops to 1.

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp interpolate info
  Dataset #0
  - Time: 0.000000e+00
  - Frame: 0
  - Number of components: 1
  - Number of dimensions: 2
  - Grid: (uniform)
    - Dim 0: Num. cells: 192; Lower: -6.283185e+00; Upper: 6.283185e+00
    - Dim 1: Num. cells: 192; Lower: -6.000000e+00; Upper: 6.000000e+00
  - Maximum: 1.970512e+00 at (96, 79)
  - Minimum: -1.177877e-08 at (94, 60)
  - DG info:
    - Polynomial Order: 2
    - Basis Type: serendipity (modal)
  - Created with Gkeyll:
    - Changeset: 9e81ededec52+
    - Build Date: Sep 21 2020 06:07:17

Now, nothing technically stops user from calling
:ref:`pg_cmd_interpolate` one more time. However since the data are no
longer in the form of expansion coefficients and have only one
component, this will result in an error.
      
One of the basic functions of Postgkyl is to visualize the data. This
can be simply done by just replacing :ref:`pg_cmd_info` with
:ref:`pg_cmd_plot`.

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp interpolate plot
      

.. figure:: fig/default2D_0.png
  :align: center

In the commitment to reproducibility, Gkeyll output files store the
Lua input file. This can be extracted using the
:ref:`pg_cmd_extractinput` command.

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp extractinput

By default, thi commands simply prints the input file into the
terminal. However, this could be easily piped into a new file .

.. code-block:: bash
  :emphasize-lines: 1
     
  pgkyl -f two-stream_elc_0.bp extractinput > input.lua



Reference
---------

.. [Arnold2011] Arnold, D. N. and Awanou, G. "The serendipity family
                of finite elements." *Foundations of Computational
                Mathematics* 11.3 (2011): 337-344.
