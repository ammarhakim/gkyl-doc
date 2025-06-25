.. _pg_cmd_info:

info
====

``info`` is a function of the ``postgkyl.data.Data`` class that
returns information about the current dataset (see :ref:`pg_loading`
for more details about the class itself). The function doesn't take
any arguments and it is wrapped into the ``info`` command.

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../../_static/postgkyl/commands/info.html"></iframe>
   </details>
   <br>
   
Command line
^^^^^^^^^^^^

.. raw:: html
         
   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl info --help
    Usage: pgkyl info [OPTIONS]

      Print info of active datasets.

    Options:
      -u, --use TEXT  Specify a 'tag' to apply to (default all tags).
      -c, --compact   Show in compact mode
      -a, --allsets   All data sets.
      -h, --help      Show this message and exit.
      
.. raw:: html
         
   </details>
   <br>

``info`` always prints information about time stamp, number of
components (these are typically individual expansion coefficients
and/or vector components), number of dimensions with number of cells. 

A useful capability of ``info`` when working with complex ``pgkyl``
commands (especially if using tags) is the ``-ac`` flags. For example,
if we had been working on the time averaged potential in the
:ref:`pg_cmd_integrate` page, and instead of plotting we placed
``info -ac`` at the end:

.. code-block:: bash

  pgkyl gk-ionSound-1x2v-p1_phi_0.bp -l '$t=0$' -t phi0 \
    "gk-ionSound-1x2v-p1_phi_[0-9]*.bp" -t phis interp collect -u phis -t phiC \
    integrate -u phiC -t phiInt 0 ev -l 'Time average' -t phiAvg 'phiInt 10. /' \
    activate -t phi0,phiAvg info -ac

we would get the following output

.. code-block:: bash

   Set $t=0$ (phi0#0)
   Set 0 (phis#0)
   Set 1 (phis#1)
   ...
   Set 50 (phis#50)
   Set collect (phiC#0)
   Set  (phiInt#0)
   Set Time average (phiAvg#0)

Showing the label, tag and index of each dataset.
   
Script mode
^^^^^^^^^^^

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
