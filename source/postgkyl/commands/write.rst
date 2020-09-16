.. _pg_cmd_write:

write
-----

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

The ``write`` command internally calls the ``write()`` method of the
``GData`` class.

.. code-block:: python

  import postgkyl as pg
  
  data = pg.data.GData('bgk_neut_0.bp')
  data.write()


Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl write --help
   Usage: pgkyl write [OPTIONS]

     Write data into a file

   Options:
     -f, --filename TEXT  Output file name.
     -t, --txt            Output file as ASCII `txt` instead of `bp`.
     --help               Show this message and exit.

Postgkyl can store data into a new ADIOS ``bp`` file (default; useful
for storing partially processed data) or into a ASCII ``txt`` file
(useful when one wants to open the data in a program that does not
support ``bp`` or ``h5``).
