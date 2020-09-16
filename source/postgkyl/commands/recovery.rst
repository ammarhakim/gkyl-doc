.. _pg_cmd_recovery:

recovery
--------

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash
                
   $ pgkyl recovery -h
   Usage: pgkyl recovery [OPTIONS]

     Interpolate DG data on a uniform mesh

   Options:
     -b, --basistype [ms|ns|mo]  Specify DG basis
     -p, --polyorder INTEGER     Specify polynomial order
     -i, --interp INTEGER        Number of poins to evaluate on
     -r, --periodic              Flag for periodic boundary conditions
     -c, --c1                    Enforce continuous first derivatives
     -h, --help                  Show this message and exit.

