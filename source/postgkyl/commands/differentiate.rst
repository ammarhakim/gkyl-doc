.. _pg_cmd_differentiate:

differentiate
-------------

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl differentiate -h
   Usage: pgkyl differentiate [OPTIONS]

     Interpolate a derivative of DG data on a uniform mesh

   Options:
     -b, --basistype [ms|ns|mo]  Specify DG basis
     -p, --polyorder INTEGER     Specify polynomial order
     -i, --interp INTEGER        Interpolation onto a general mesh of specified
                                 amount
     -r, --read BOOLEAN          Read from general interpolation file
     -h, --help                  Show this message and exit.

