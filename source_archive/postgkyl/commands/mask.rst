.. _pg_cmd_mask:

mask
====

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/mask.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl mask -h
    Usage: pgkyl mask [OPTIONS]
    
      Mask data with specified Gkeyll mask file.
    
    Options:
      -u, --use TEXT       Specify a 'tag' to apply to (default all tags).
      -f, --filename TEXT  Specify the file with a mask
      -l, --lower FLOAT    Specify the lower theshold to be masked out.
      -u, --upper FLOAT    Specify the upper theshold to be masked out.
      -h, --help           Show this message and exit.

.. raw:: html

  </details>
  <br>

Script mode
^^^^^^^^^^^
