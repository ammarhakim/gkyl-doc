.. _pg_cmd-info:

info
++++

Command Line Mode
^^^^^^^^^^^^^^^^^

``info`` prints an overview of the data. It outputs time (when
available), number of components, number of dimensions, minimum and
maximum (plus where they occur), and number of cells and bounds for
each dimension.

.. code-block:: bash

   pgkyl -f bgk_neut_0.bp info
   - Time: 0.000000e+00
   - Number of components: 8
   - Number of dimensions: 2
     - Dim 0: Num. cells: 128; Lower: 0.000000e+00; Upper: 1.000000e+00
     - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 7.795721e-01 at (0, 15) component 0
   - Minimum: -5.179175e-02 at (0, 18) component 2

------

Script Mode
^^^^^^^^^^^

The ``info`` command internally calls the ``info()`` method of the
``GData`` class.

.. code-block:: python

  import postgkyl as pg
  
  data = pg.data.GData('bgk_neut_0.bp')
  print(data.info())

Note that ``info()`` produces a single string output. Therefore, it is
recommended to use the ``print()`` function for readable output.
