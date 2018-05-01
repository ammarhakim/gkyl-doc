.. _pg_cmd-collect:

collect
-------

Command Line Mode
^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl collect --help
   Usage: pgkyl collect [OPTIONS]

     Collect data from the active datasets

   Options:
     -s, --sumdata       Sum data in the collected datasets (retain components)
     -p, --period FLOAT  Specify a period to create epoch data instead of time
                         data
     -o, --offset FLOAT  Specify an offset to create epoch data instead of time
                         data (default: 0)
     --help              Show this message and exit.

