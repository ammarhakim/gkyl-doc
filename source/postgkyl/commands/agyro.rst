.. _pg_cmd_agyro:

agyro
-----

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl agyro -h
   Usage: pgkyl agyro [OPTIONS]

     Compute a measure of agyrotropy. Default measure is taken from Swisdak
     2015. Optionally computes agyrotropy as Frobenius norm of agyrotropic
     pressure tensor. Pressure-tensor must be the first dataset and magnetic
     field the second dataset.

   Options:
     --forb      Compute agyrotropy using Forbenius norm.
     -h, --help  Show this message and exit.
