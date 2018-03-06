.. _pg_output:

Data Output: info, plot, and write
++++++++++++++++++++++++++++++++++

Postgkyl allows to quickly print the data summary using the ``info``
command, plot the data using the ``plot``, and ``write`` the data into
either ADIOS ``bp`` file or ASCII ``txt`` file.

Info: Printing quick data summary
---------------------------------

.. code-block:: bash

   pgkyl -f bgk_neut_0.bp info
   - Time: 0.000000e+00
   - Number of components: 8
   - Number of dimensions: 2
     - Dim 0: Num. cells: 128; Lower: 0.000000e+00; Upper: 1.000000e+00
     - Dim 1: Num. cells: 32; Lower: -6.000000e+00; Upper: 6.000000e+00
   - Maximum: 7.795721e-01 at (0, 15) component 0
   - Minimum: -5.179175e-02 at (0, 18) component 2

Note that ``info()`` produces a single string output. Therefore, it is
recommended to use ``print()`` for readable output:

.. code-block:: python

  import postgkyl as pg
  data = pg.data.GData('bgk_neut_0.bp')
  print(data.info())
