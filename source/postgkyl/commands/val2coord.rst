.. _pg_cmd_val2coord:

val2coord
---------

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl val2coord -h
   Usage: pgkyl val2coord [OPTIONS]

     Given a DynVector dataset select columns from it to create new datasets.
     For example, you can choose say column 1 to be the X-axis of the new
     dataset and column 2 to be the Y-axis. Multiple columns can be choosen
     using range specifiers and as many datasets are then created.

   Options:
     -x TEXT     Select components that will became the grid of the new dataset.
     -y TEXT     Select components that will became the values of the new
                 dataset.
     -h, --help  Show this message and exit.
