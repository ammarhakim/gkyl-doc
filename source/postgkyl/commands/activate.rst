.. _pg_cmd_activate:

activate
========

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl activate -h
    Usage: pgkyl activ [OPTIONS]
    
      Select datasets(s) to pass further down the command chain. Datasets are
      indexed starting 0. Multiple datasets can be selected using a comma
      separated list or a range specifier. Unless '--focused' is selected, all
      unselected datasets will be deactivated.
    
      '--tag' and '--index' allow to specify tags and indices. The not
      specified, 'activate' applies to all. Both parameters support comma-
      separated values. '--index' also supports slices following the Python
      conventions, e.g., '3:7' or ':-5:2'.
    
      'info' command (especially with the '-ac' flags) can be helpful when
      activating/deactivating multiple datasets.
    
    Options:
      -t, --tag TEXT    Tag(s) to apply to (comma-separated)
      -i, --index TEXT  Dataset indices (e.g., '1', '0,2,5', or '1:6:2')
      -f, --focused     Leave unspecified datasets untouched
      -h, --help        Show this message and exit.

.. raw:: html

   </details>
   <br>
