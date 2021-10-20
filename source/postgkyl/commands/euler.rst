.. _pg_cmd-euler:

euler
=====

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../../_static/postgkyl/commands/euler.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl euler --help
    Usage: pgkyl euler [OPTIONS]
    
      Compute Euler (five-moment) primitive and some derived variables from
      fluid conserved variables.
    
    Options:
      -u, --use TEXT                  Specify a 'tag' to apply to (default all
                                      tags).
    
      -g, --gas_gamma FLOAT           Gas adiabatic constant
      -v, --variable_name [density|xvel|yvel|zvel|vel|pressure|ke|mach]
                                      Variable to extract
      -h, --help                      Show this message and exit.

.. raw:: html

  </details>
  <br>


Script mode
^^^^^^^^^^^
