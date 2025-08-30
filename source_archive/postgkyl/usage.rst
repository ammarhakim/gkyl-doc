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
   colormaps

What makes Postgkyl quite unique, is the wrapping of all the
*functions* into command line *commands* using the `Click
<http://click.pocoo.org>`_ Python package.  In other words, almost the
full functionality of Postgkyl can be used directly in any
terminal. This has beneficts for everyday work where typing a single
command is faster than writing a Python script and also for work with
remote machines and supercomputers, which are primarily accessed
through a terminal. However, the classical way of using Postgkyl in a
script still provides more control and is well suited, for example,
for long and complex scripts for publication level figures.

The command line executable for Postgkyl is called ``pgkyl`` and its
call has the following synopsis:

.. code-block:: bash

  pgkyl [OPTIONS] COMMAND1 [ARGS]... [COMMAND2 [ARGS]...]...

Here, the ``COMMAND`` represents either data to :ref:`load
<pg_loading>` or an opperation to be performed on the loaded data. All
the available options can be listed using the inbuilt help, ``pgkyl
--help`` or ``pgkyl -h`` for short.

Note that Postgkyl supports an arbitrary number of commands. Similar
to piping in Linux, results of one command are passed to another. This
allows Postgkyl to perform even a rather complex diagnostics and
create complicated plots straight up from the terminal. However, this
puts a responsibility on the user to ensure that the commands are
called in a logical order. Similarly to the main part of ``pgkyl``,
``--help`` can be called for each individual command which will
provide additional information. Finally, it is worth mentioning that
it is not necessary to write the full names of each command and the
shortest unique sequence is good enough. Still, full names will be
used through this documentation for clarity.

