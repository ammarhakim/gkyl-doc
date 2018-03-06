Using Postgkyl
++++++++++++++

Starting with the Postgkyl 1.0, the command line commands are only
wrappers over the Python functions and methods.  Therefore, the both
mode can be used interchangeably.  Still, using Postgkyl as a Python
package is better suited for writing longer and/or more sophisticated
scripts, while the the command line mode provides a fast
access to results and is well suited even for work on remote
machines.  What is more, almost unlimited chaining of the commands
makes the later very useful even for more complex diagnostics.

Postgkyl is configured as a standard Python package and can be
imported with:

.. code-block:: python

   import postgkyl

The command line mode is invoked with the ``pgkyl`` executable, which is
a wrapper over the ``postgkyl.pgkyl``.  The standard ``pgkyl`` usage follows
the pattern:

.. code-block:: bash

  pgkyl [OPTIONS] COMMAND1 [ARGS]... [COMMAND2 [ARGS]...]...

The ``OPTIONS`` serve mostly for the data loading and are followed by
a pipe of commands.  There is no arbitrary limit on the number of
commands; however, it is up to the user to make sure that the commands
are chained in a logical sense.  For example, the ``plot`` command
should be most likely at the end of the chain. See the :ref:`pg_chain`
section for more details.

Following are details about Postgkyl functions:

.. toctree::
   :maxdepth: 1

   loading
   output
   interpolation
   transformations
   diagnostics
   chain
