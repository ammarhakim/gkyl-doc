.. _pg_cmd-interpolate:

interpolate
+++++++++++

``GInterp`` is the class responsible for interpreting DG nodal and
modal data.  However, it should not be accessed directly; rather, its
children ``GInterpModal`` and ``GInterpNodal`` should be used.

Init parameters
^^^^^^^^^^^^^^^
``GInterpModal`` and ``GInterpNodal`` share the initialization parameters

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

Members
^^^^^^^
After the initialization, both ``GInterpModal`` and ``GInterpNodal``
can be used to interpolate data on a uniform grid or to calculate
derivatives

.. list-table:: Members of ``GInterpModal`` and ``GInterpNodal``
   :widths: 30, 70
   :header-rows: 1

   * - Member
     - Description
   * - interpolate(int component) -> narray, narray
     - Interpolates the selected component (default is 0) of the DG
       data on a uniform grid
   * - derivative(int component) -> narray, narray
     - Calculates the derivative of the DG data

An example of the usage::

  import postgkyl as pg
  data = pg.data.GData('bgk_neut_0.bp')
  interp = pg.data.GInterpModal(data, 2, 'ms')
  iGrid, iValues = interp.interpolate()
