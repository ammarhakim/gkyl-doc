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

