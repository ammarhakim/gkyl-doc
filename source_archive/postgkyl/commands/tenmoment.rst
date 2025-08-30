.. _pg_cmd_tenmoment:

tenmoment
=========

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/tenmoment.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl tenmoment --help
    Usage: pgkyl tenmom [OPTIONS]
    
      Extract ten-moment primitive variables from ten-moment conserved
      variables.
    
    Options:
      -u, --use TEXT                  Specify a 'tag' to apply to (default all
                                      tags).
    
      -v, --variable_name [density|xvel|yvel|zvel|vel|pressureTensor|pxx|pxy|pxz|pyy|pyz|pzz|pressure]
                                      Variable to plot
      -h, --help                      Show this message and exit.

.. raw:: html

  </details>
  <br>

Script mode
^^^^^^^^^^^
