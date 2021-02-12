.. _pg_cmd_interpolate:

interpolate
+++++++++++

Gkeyll's simulation may employ higher-order methods with more
than one degree of freedom per cell, typically expansion
coefficients or nodal values. The `interpolate` command
interpolates this higher-order representation onto a finer mesh
with more points than the number of cells in the Gkeyll
simulation.

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl interpolate --help
    Usage: pgkyl interp [OPTIONS]
    
      Interpolate DG data onto a uniform mesh.
    
    Options:
      -b, --basistype [ms|ns|mo|mt]  Specify DG basis.
      -p, --polyorder INTEGER        Specify polynomial order.
      -i, --interp INTEGER           Interpolation onto a general mesh of
                                     specified amount.
    
      -u, --use TEXT                 Specify a 'tag' to apply to (default all
                                     tags).
    
      -t, --tag TEXT                 Optional tag for the resulting array
      -r, --read BOOLEAN             Read from general interpolation file.
      -n, --new                      for testing purposes
      -h, --help                     Show this message and exit.

.. raw:: html

   </details>
   <br>

We can illustrate the use of ``interpolate`` by plotting
the cell average of the electron distribution function in a
:doc:`two stream instability simulation<../input/two-stream>`
and adjacently plotting the interpolated distribution function
with the following command



Script mode
^^^^^^^^^^^

``interpolate`` uses the  ``GInterpModal`` and ``GInterpNodal``
classes based on the DG mode.


.. list-table:: Initialization parameters for ``GInterpModal`` and ``GInterpNodal``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - gdata (GData)
     - A GData object to be used.
     - 
   * - polyOrder (int)
     - The polynomial order of the discontinuous Galerkin
       discretization.
     -
   * - basis (str)
     - The polynomial basis. Currently supported options are ``'ns'`` for
       nodal Serendipity, ``'ms'`` for modal Serendipity, and ``'mo'``
       for the maximal order basis.
     -

After the initialization, both ``GInterpModal`` and ``GInterpNodal``
can be used to interpolate data on a uniform grid and to calculate
derivatives

.. list-table:: Members of ``GInterpModal`` and ``GInterpNodal``
   :widths: 40, 60
   :header-rows: 1

   * - Member
     - Description
   * - interpolate(int component, bool stack) -> narray, narray
     - Interpolates the selected component (default is 0) of the DG
       data on a uniform grid
   * - derivative(int component, bool stack) -> narray, narray
     - Calculates the derivative of the DG data

When the ``stack`` parameter is set to ``true`` (it is ``false`` by
default), the grid and values are pushed to the ``GData`` stack rather
than returned.

An example of the usage:

.. code-block:: Python

   import postgkyl as pg
   data = pg.data.GData('bgk_neut_0.bp')
   interp = pg.data.GInterpModal(data, 2, 'ms')
   iGrid, iValues = interp.interpolate()


