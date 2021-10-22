.. highlight:: lua

.. _app_gk:

Gyrokinetic App: Electromagnetic gyrokinetic model for magnetized plasmas
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The ``Gyrokinetic`` App solves the (electromagnetic) gyrokinetic system on a
Cartesian grid.

.. contents::

Overall structure of app
------------------------

To set up a gyrokinetic simulation, we first need to load the ``Gyrokinetic`` App package.
This should be done at the top of the input file, via

.. code-block:: lua

  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()

This creates a table ``Plasma`` that loads the gyrokinetic species, fields, etc. packages.

The general structure of the input file is then

.. code-block:: lua

  -------------------------------------------------------------------------------
  -- App dependencies.
  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()
  ...

  -------------------------------------------------------------------------------
  -- Preamble.
  ...

  -------------------------------------------------------------------------------
  -- App initialization.
  plasmaApp = Plasma.App {  
    -----------------------------------------------------------------------------
    -- Common 
    ...

    -----------------------------------------------------------------------------
    -- Species
    electron = Plasma.Species {
      -- GkSpecies parameters
      ...
    },

    -- other species, e.g. ions

    -----------------------------------------------------------------------------
    -- Fields 
    field = Plasma.Field {  
      -- GkField parameters
      ...
    },

    -----------------------------------------------------------------------------
    -- ExternalFields
    extField = Plasma.Geometry {
      -- GkGeometry parameters
      ...
    },
  }
  -------------------------------------------------------------------------------
  -- App run.
  plasmaApp:run()


.. Note that if the app's ``run`` method is not called, the simulation
.. will not be run, but the simulation will be initialized and the
.. initial conditions will be written out to file.
.. 
.. By CDIM we mean configuration space dimension and by VDIM we mean
.. velocity space dimension. This app works in 1X1V, 1X2V and 3X2V. The

Kinetic simulations may take additional parameters in the input file Common, such as

.. list-table:: Other Common parameters (for Gyrokinetic simulations).
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - nDistFuncFrame
     - These many distribution function outputs will be written during
       simulation. If not specified, top-level ``nFrame`` parameter
       will be used
     - ``nFrame`` from top-level
  
Species parameters
------------------

The Gyrokinetic App works with an arbitrary number of species. 

Each species should be declared as

.. code-block:: lua

    -----------------------------------------------------------------------------
    -- Species
    species_name = Plasma.Species {
      -- GkSpecies parameters
      ...
    },

The species name (``species_name`` here) is arbitrary, but will be used for naming in diagnostic files, so names like ``ion`` or ``electron`` are common.

Here we describe all possible parameters used to specify a gyrokinetic species.
Parameters that have default values can be omitted. Units are arbitrary, but often SI units are used.
In the following, VDIM refers to the velocity space dimension, and CDIM refers to the configuration space dimension. 
The gyrokinetic app works for 1X1V (CDIM=1, VDIM=1), 1X2V, 2X2V, and 3X2V. 
The velocity coordinates are :math:`(v_\parallel, \mu)`. See [Shi2017]_ for details.

.. list-table:: GkSpecies Parameters
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - charge
     - Species charge
     - 1.0
   * - mass
     - Species mass
     - 1.0
   * - lower
     - VDIM-length table with lower-left velocity space coordinates
     -
   * - upper
     - VDIM-length table with upper-right velocity space coordinates
     -
   * - cells
     - VDIM-length table with number of velocity space cells
     -
   * - decompCuts
     - **NOT CURRENTLY SUPPORTED**, no processor decomposition in velocity space allowed
     - 
   * - init
     - Specifies how to initialize the species distribution function. Use a Projection plugin (see `Projections <https://gkeyll.readthedocs.io/en/latest/gkyl/App/Projection/projection.html>`_), 
       or a function with signature ``function(t,xn)`` that return a
       single value, :math:`f(t=0,xn[0],xn[1],...)`, where ``xn`` is a NDIM vector.
     - 
   * - evolve
     - If set to ``false`` the species distribution function is not evolved. In this case, only initial conditions for this species will be written to file.
     - true
   * - bcx
     - Length two table with BCs in X direction. See details on BCs below.
     - { }
   * - bcy
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - { }
   * - bcz
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - { }     
   * - coll 
     - Collisions plugin. See `Collisions models in Gkeyll <https://gkeyll.readthedocs.io/en/latest/gkyl/App/Collisions/collisionModels.html>`_.
     -
   * - source
     - Specifies a source that is added to the RHS on every timestep. Use a Projection plugin (see `Projections <https://gkeyll.readthedocs.io/en/latest/gkyl/App/Projection/projection.html>`_), 
       or a function with signature ``function(t,xn)`` that return a
       single value, :math:`S(t,xn[0],xn[1],...)`, where ``xn`` is a NDIM vector.
     - 
   * - diagnostics
     - List of moments and volume integrated moments to compute. See below for list
       of moments supported.
     - { }

.. note::

   - In general, you should not specify ``cfl`` or ``cflFrac``,
     unless either doing tests or explicitly controlling the
     time-step. The app will determine the time-step automatically.
   - When ``useShared=true`` the ``decompCuts`` must specify the
     *number of nodes* and not number of processors. That is, the total
     number of processors will be determined from ``decompCuts`` and
     the number of threads per node.
   - The "rk3s4" time-stepper allows taking twice the time-step as
     "rk2" and "rk3" at the cost of an additional RK stage. Hence,
     with this stepper a speed-up of 1.5X can be expected.

Diagnostics
^^^^^^^^^^^

There are species-specific diagnostics available, which mainly consist of moments of
the distribution function and integrals (over configuration-space) of these moments. There
are also additional species diagnostics which serve as metrics of positivity and
collisions-related errors.

Currently there are four types of diagnostic moments, defined below. Note that in these
definitions :math:`\mathrm{d}\mathbf{w}=\mathrm{d}v_\parallel` or 
:math:`\mathrm{d}\mathbf{w}=(2\pi B_0/m)\mathrm{d}v_\parallel\mathrm{d}\mu`
depending on whether it is a 1V or a 2V simulation. We also use the notation
:math:`d_v` to signify the number of physical velocity-space dimensions
included, i.e. :math:`d_v=1` for 1V and :math:`d_v=3` for 2V. Also,
:math:`v^2=v_\parallel^2` for 1V and :math:`v^2=v_\parallel^2+2\mu B_0/m` for 2V.

- Velocity moments of the distribution function, written as functions of configuration-space position on each diagnostic frame. The options are

  * ``M0``: number density, :math:`n = M_0 = \int\mathrm{d}\mathbf{w}~f`.
  * ``M1``: parallel momentum density, :math:`M_1=\int\mathrm{d}\mathbf{w}~v_\parallel f`.
  * ``M2``: energy density, :math:`M_2 = \int\mathrm{d}\mathbf{w}~v^2 f`.
  * ``Upar``: parallel flow velocity,
    :math:`u_\parallel= M_1/n`.
  * ``Temp``: temperature, :math:`T = (m/d_v)(M_2 - M_1 u_\parallel)/n`
  * ``Beta``: plasma beta, :math:`\beta = 2\mu_0 nT/B^2`
  * ``Energy``: particle energy density (kinetic + potential), :math:`\mathcal{E}_H = \int\mathrm{d}\mathbf{w}~H f`, where :math:`H = mv^2/2 + q\phi` is the Hamiltonian.
- Velocity moments integrated over configuration-space, written as time-series. The options are

  * ``intM0``: particle number, :math:`N = \int\mathrm{d}\mathbf{x}\mathrm{d}\mathbf{w}~f` 
  * ``intM1``: parallel momentum, :math:`U = \int\mathrm{d}\mathbf{x}\mathrm{d}\mathbf{w}~v_\parallel f` 
  * ``intM2``: :math:`\int\mathrm{d}\mathbf{x}\mathrm{d}\mathbf{w}~v^2 f`
  * ``intKE``: kinetic energy, :math:`\mathcal{E}_K = ({m}/{2})\int\mathrm{d}\mathbf{x}\mathrm{d}\mathbf{w}~v^2 f`
  * ``intEnergy``: total (kinetic + potential) energy, :math:`E_H = \int\mathrm{d}\mathbf{x}\mathrm{d}\mathbf{w}~H f`, where :math:`H = mv^2/2 + q\phi` is the Hamiltonian.

Boundary flux diagnostics
=========================

One can request diagnostics of the fluxes through non-periodic boundaries by providing a
``diagnostics = {}`` table to the boundary condition Apps. For example, sheath boundary
conditions along `z` would do this via

.. code-block:: bash

  bcz = {Plasma.SheathBC{diagnostics={"M0"}}, Plasma.SheathBC{diagnostics={"M0"}}}

in order to request the particle flux through the sheaths. Another example is provided
in :ref:`the gyrokinetic Quickstart page <qs_gk1>`.

The boundary fluxes are computed via integrals of the time rates of change computed
in the ghost cells. If we consider a simple phase-space advection equation in 2X2V
without any forces

.. math::
  
  \frac{\partial f}{\partial t} + \mathbf{v}\cdot\nabla f = 0

.. + \mathbf{a}\cdot\nabla_{\mathbf{v}} f = 0

the weak form used by the algorithm is obtained by multiplying this equation by a test function
:math:`\psi` and integrating over phase space in a single cell. After an integration by parts
one obtains

.. math::
  
  \int\mathrm{d}\mathbf{z}\frac{\partial f}{\partial t}\psi
  + \int\mathrm{d}\mathbf{v}\,\mathrm{d}y\,\widehat{v_xf\psi}\Big|^{x_{i+1/2}}_{x_{i-1/2}} 
  + \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{y_{j+1/2}}_{y_{j-1/2}}
  - \int\mathrm{d}\mathbf{z}\,\mathbf{v}\cdot(\nabla\psi)f = 0

..  + \mathbf{a}\cdot\nabla_{\mathbf{v}} f = 0

where the hat means that a numerical flux is constructed, and
:math:`\mathrm{d}\mathbf{z}=\mathrm{d}\mathbf{x}\,\mathrm{d}\mathbf{v}`. In
ghost cells only the surface terms corresponding to fluxes through the physical domain boundaries
are computed. This means tha in the ghost cell at the upper boundary along :math:`x`, for example

.. math::
  :label: dfdtGhost
  
  \int\mathrm{d}\mathbf{z}\frac{\partial f}{\partial t}\psi =
  - \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{y_{j+1/2}}_{y_{j-1/2}}

This is phase-space flux through the upper :math:`x` boundary during a stage of the PDE solver.
For Runge-Kutta steppers one must form a linear combination of these fluxes from every stage in
the same manner as the time rates of change are combined for forward time stepping. For the sake
of simplicity here we just assume a single forward Euler step, and define phase-space flux
during a single time step through the upper :math:`x` boundary as

.. math::
  
  \Gamma_{\mathbf{z},x_+} = - \frac{1}{V}
  \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{y_{j+1/2}}_{y_{j-1/2}}

where the volume factor :math:`V` arises from the phase-space integral on the left side of
equation :eq:`dfdtGhost`. **Note** that these integrals are over a single cell, and that the
quantity :math:`\Gamma_{\mathbf{z},x_+}` is phase-space field,
:math:`\Gamma_{\mathbf{z},x_+}=\Gamma_{\mathbf{z},x_+}(\mathbf{x},\mathbf{v})`.

With this boundary flux in mind, if one requests the particle density of the boundary flux
through ``diagnosticBoundaryFluxMoments={GkM0}`` the diagnostic would be computed as 

.. math::

  \int\mathrm{d}\mathbf{v}\,\Gamma_{\mathbf{z},x_+} = - \int\mathrm{d}\mathbf{v}\frac{1}{V}
  \int\mathrm{d}\mathbf{v}'\,\mathrm{d}x\,\widehat{v_y'f\psi}\Big|^{y_{j+1/2}'}_{y_{j-1/2}'}

This yields the rate of number density crossing the upper :math:`x` boundary (per cell-length in
the :math:`x` direction of the ghost cell). In order to compute
the number of particles per unit time crossing the upper :math:`x` boundary
(``diagnosticIntegratedBoundaryFluxMoments={intM0}``) we simply integrate the above quantity over
:math:`y` (and multiply it by the :math:`x`-cell length of the ghost cell)

.. math::

  (\Delta x)\int\mathrm{d}\mathbf{v}\,\mathrm{d}y\,\Gamma_{\mathbf{z},x_+} =
  - (\Delta x)\int\mathrm{d}\mathbf{v}\,\mathrm{d}y\frac{1}{V}
  \int\mathrm{d}\mathbf{v}'\,\mathrm{d}x\,\widehat{v_y'f\psi}\Big|^{y_{j+1/2}'}_{y_{j-1/2}'}

The final detail is that the files created by these diagnostics contain the fluxes 
through the boundary accumulated since the last snapshot (frame), not since the beginning of the
simulation.


References
----------

.. [Shi2017] Shi, E. L., Hammett, G. W., Stolzfus-Dueck, T., &
   Hakim, A. (2017). Gyrokinetic continuum simulation of turbulence in
   a straight open-field-line plasma. Journal of Plasma Physics, 83,
   1–27. http://doi.org/10.1017/S002237781700037X
