.. _pg_cmd_current:

current
=======

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../../_static/postgkyl/commands/current.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl velocity -h
    Usage: pgkyl curr [OPTIONS]
    
      Accumulate current, sum over species of charge multiplied by flow
    
    Options:
      -q, --qbym TEXT   Flag for multiplying by charge/mass ratio instead of just
                        charge  [default: False]
    
      -u, --use TEXT    Specify a 'tag' to apply to (default all tags).
      -t, --tag TEXT    Tag for the resulting current array  [default: current]
      -l, --label TEXT  Custom label for the result  [default: J]
      -h, --help        Show this message and exit.

.. raw:: html

   </details>
   <br>
