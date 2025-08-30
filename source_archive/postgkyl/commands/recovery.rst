.. _pg_cmd_recovery:

recovery
========

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/recovery.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl recovery -h
   Usage: pgkyl recov [OPTIONS]
   
     Interpolate DG data on a uniform mesh
   
   Options:
     -u, --use TEXT              Specify a 'tag' to apply to (default all tags).
     -t, --tag TEXT              Optional tag for the resulting array
     -b, --basistype [ms|ns|mo]  Specify DG basis
     -p, --polyorder INTEGER     Specify polynomial order
     -i, --interp INTEGER        Number of poins to evaluate on
     -r, --periodic              Flag for periodic boundary conditions
     -c, --c1                    Enforce continuous first derivatives
     -h, --help                  Show this message and exit.

.. raw:: html

  </details>
  <br>

Script mode
^^^^^^^^^^^
