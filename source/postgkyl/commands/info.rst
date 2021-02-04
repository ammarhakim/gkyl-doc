.. _pg_cmd_info:

info
====


``info`` is a function of the ``postgkyl.data.Data`` class that
returns information about the current dataset (see :ref:`pg_loading`
for more details about the class itself). The function doesn't take
any arguments and it is wrapped into the ``info`` command.
   
.. raw:: html
         
   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl info --help
    Usage: pgkyl info [OPTIONS]

      Print info of the current top of stack

    Options:
      -a, --allsets  All data sets
      -h, --help     Show this message and exit.
      
.. raw:: html
         
   </details>
   <br>

``info`` always prints information about time stamp, number of
components (these are typically individual expansion coefficients
and/or vector components), number of dimensions with number of cells 
   
.. raw:: html
         
  <details open>
  <summary><a>Script</a></summary>

.. code-block:: python
  :emphasize-lines: 3

  import postgkyl as pg
  data = pg.data.Data('two-stream_elc_0.bp')
  print(data.info())

.. raw:: html
         
  </details>    

Note that ``info()`` produces a single string output. Therefore, it is
recommended to use the ``print()`` function for readable output.
