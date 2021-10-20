.. _pg_cmd_val2coord:

val2coord
=========

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/val2coord.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl val2coord -h
    Usage: pgkyl val2 [OPTIONS]
    
      Given a dataset (typically a DynVector) selects columns from it to create
      new datasets. For example, you can choose say column 1 to be the X-axis of
      the new dataset and column 2 to be the Y-axis. Multiple columns can be
      choosen using range specifiers and as many datasets are then created.
    
    Options:
      -u, --use TEXT  Specify a 'tag' to apply to (default all tags).
      -t, --tag TEXT  Tag for the result
      -x TEXT         Select components that will became the grid of the new
                      dataset.
    
      -y TEXT         Select components that will became the values of the new
                      dataset.
    
      -h, --help      Show this message and exit.

.. raw:: html

  </details>
  <br>

