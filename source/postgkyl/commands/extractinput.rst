.. _pg_cmd_extractinput:

extractinput
------------

Data files produced by Gkeyll may have the input file used
to generate that data saved in them as an attribute. We can
extract the input file and print it to screen or to a new
file with ``extractinput``.

Certain versions of ADIOS (the I/O library Gkeyll uses) have
trouble saving very long files. For this reason saving the
input file in data files is sometimes disabled. In those cases
``extractinput`` may fail or return nothing.

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl extractinput -h
    Usage: pgkyl extractinput [OPTIONS]

       Extract embedded input file from compatible BP files

    Options:
       -u, --use TEXT  Specify a 'tag' to apply to (default all tags).
       -h, --help  Show this message and exit.

.. raw:: html

   </details>
   <br>

If we run the :doc:`ion acoustic gyrokinetic simulation<../input/gk-ionSound-1x2v-p1>`,
it would produce save the initial ion distribution function in
the file ``gk-ionSound-1x2v-p1_ion_0.bp``. We can extract the
input file used to generate this data with

.. code-block:: bash

  pgkyl gk-ionSound-1x2v-p1_ion_0.bp extract

where we have shortened ``extractinputfile`` into ``extract``
for simplicity. This would print it to screen.

Suppose you wish to write it to a new file because, say, you
lost the original input file and wish to recreate or restart
this simulation. You could write the saved input file to a new
input file with:

.. code-block:: bash

  pgkyl gk-ionSound-1x2v-p1_ion_0.bp extract > gk-ionSound-1x2v-p1.lua

If you are using the same name as the original input file
you'll be able to restart the simulation. If the original
input file is still in the directory it will be overwritten.
