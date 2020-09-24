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

The input file should then contain one or more ``Plasma.Species`` tables,
a ``Plasma.Field`` table, and a ``Plasma.Geometry`` table, which are used to specify
simulation parameters as shown below.

The general structure of the input file is then

.. code-block:: lua

  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()

  plasmaApp = Plasma.App {  
    -- basic parameters, see [topLevelApp]

    -- description of each species (names, e.g. electron, are arbitrary but used for diagnostics)
    electron = Plasma.Species {
      -- GkSpecies parameters
    },

    -- other species, e.g. ions

    -- fields 
    field = Plasma.Field {  
      -- GkField parameters
    },

    funcField = Plasma.Geometry {
      -- GkGeometry parameters
    },
  }
  -- run application
  plasmaApp:run()

Note that if the app's ``run`` method is not called, the simulation
will not be run, but the simulation will be initialized and the
initial conditions will be written out to file.

By CDIM we mean configuration space dimension and by VDIM we mean
velocity space dimension. This app works in 1X1V, 1X2V and 3X2V. The
velocity coordinates are :math:`v_\parallel, \mu`. See [Shi2017]_ for
details.
  
Species parameters
----------------
  
The following parameters are used to specify species parameters for the gyrokinetic system. 
Parameters that have default values can be omitted. Units are arbitrary, but typically SI units are used.

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
     - VDIM length table with lower-left velocity space coordinates
     -
   * - upper
     - VDIM length table with upper-right velocity space coordinates
     -
   * - cells
     - VDIM length table with number of velocity space cells
     -
   * - decompCuts
     - **NOT CURRENTLY SUPPORTED**, no processor decomposition in velocity space allowed
     - 
   * - init
     - Function with signature ``function(t,xn)`` that initializes the
       species distribution function. This function must return a
       single value, :math:`f(x,v,t=0)` at ``xn``, which is a NDIM
       vector.
     - 

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

- ``diagnosticMoments``
  Velocity moments of the distribution function. The options are

  * ``GkM0``: number density :math:`n = \int\mathrm{d}\mathbf{w}~f`.
  * ``GkM1``: particle momentum density :math:`nu_\parallel=\int\mathrm{d}\mathbf{w}~v_\parallel f`.
  * ``GkM2``: particle energy density :math:`\int\mathrm{d}\mathbf{w}~v^2 f`.
  * ``GkUpar``: flow velocity :math:`u_\parallel=n^{-1}\int\mathrm{d}\mathbf{w}~v^2 f`.
  * ``GkTemp``: temperature :math:`T=(d_v n)^{-1}\int\mathrm{d}\mathbf{w}~(v_\parallel-u_\parallel)^2 f`.
- ``diagnosticIntegratedMoments``
  Velocity moments integrated over configuration-space. The options are

  * ``intM0``: particle number, so ``diagnosticMoment`` ``GkM0``
    integrated over configuration-space.
  * ``intM1``: momentum, so ``diagnosticMoment`` ``GkM1``
    integrated over configuration-space.
  * ``intKE``: kinetic energy, so ``diagnosticMoment`` ``GkM2``
    integrated over configuration-space.
  * ``intHE``: Hamiltonian integrated over phase-space.
- ``diagnosticBoundaryFluxMoments``
  Moments of the (phase-space) fluxes :math:`\Gamma_{\mathbf{z}}` through the
  boundaries of configuration-space. The options are

  * ``GkM0``: number density of the boundary fluxes :math:`\int\mathrm{d}\mathbf{w}~\Gamma_{\mathbf{z}}`.
  * ``GkUpar``: flow velocity of the boundary fluxes.
  * ``GkEnergy``: energy density of the boundary fluxes :math:`\int\mathrm{d}\mathbf{w}~v^2\Gamma_{\mathbf{z}}`.
- ``diagnosticIntegratedBoundaryFluxMoments``
  Boundary flux moments integrated over configuration space.

  * ``intM0``: integrated particle flux through the boundary.
  * ``intM1``: integrated momentum flux through the boundary.
  * ``intKE``: integrated kinetic energy flux through the boundary.

A note on bundary flux diagnostics
==================================

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
  + \int\mathrm{d}\mathbf{v}\,\mathrm{d}y\,\widehat{v_xf\psi}\Big|^{v_{x,i+1/2}}_{v_{x,i-1/2}} 
  + \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{v_{y,j+1/2}}_{v_{y,j-1/2}}
  - \int\mathrm{d}\mathbf{z}\,\mathbf{v}\cdot(\nabla\psi)f = 0

..  + \mathbf{a}\cdot\nabla_{\mathbf{v}} f = 0

where the hat means that a numerical flux is constructed, and
:math:`\mathrm{d}\mathbf{z}=\mathrm{d}\mathbf{x}\,\mathrm{d}\mathbf{v}`. In
ghost cells only the surface terms corresponding to fluxes through the physical domain boundaries
are computed. This means tha in the ghost cell at the upper boundary along :math:`x`, for example

.. math::
  :label: dfdtGhost
  
  \int\mathrm{d}\mathbf{z}\frac{\partial f}{\partial t}\psi =
  - \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{v_{y,j+1/2}}_{v_{y,j-1/2}}

This is phase-space flux through the upper :math:`x` boundary during a stage of the PDE solver.
Runge-Kutta integrators however have :math:`s` stages, so we accumulate these to calculate the total
phase-space flux during a single time step through the upper :math:`x` boundary as

.. math::
  
  \Gamma_{\mathbf{z},x_+} = - \frac{1}{V}\sum_s
  \int\mathrm{d}\mathbf{v}\,\mathrm{d}x\,\widehat{v_yf\psi}\Big|^{v_{y,j+1/2}}_{v_{y,j-1/2}}

where the volume factor :math:`V` arises from the phase-space integral on the left side of
equation :eq:`dfdtGhost`. **Note** that these integrals are over a single cell, and that the
quantity :math:`\Gamma_{\mathbf{z},x_+}` is phase-space field,
:math:`\Gamma_{\mathbf{z},x_+}=\Gamma_{\mathbf{z},x_+}(\mathbf{x},\mathbf{v})`.

With this boundary flux in mind, if one requests the particle density of the boundary flux
through ``diagnosticBoundaryFluxMoments={GkM0}`` the diagnostic would be computed as 

.. math::

  \int\mathrm{d}\mathbf{v}\,\Gamma_{\mathbf{z},x_+} = - \int\mathrm{d}\mathbf{v}\frac{1}{V}\sum_s
  \int\mathrm{d}\mathbf{v}'\,\mathrm{d}x\,\widehat{v_y'f\psi}\Big|^{v_{y,j+1/2}'}_{v_{y,j-1/2}'}

This yields the rate of number density crossing the upper :math:`x` boundary (per cell-length in
the :math:`x` direction of the ghost cell). In order to compute
the number of particles per unit time crossing the upper :math:`x` boundary
(``diagnosticIntegratedBoundaryFluxMoments={intM0}``) we simply integrate the above quantity over
:math:`y` (and multiply it by the :math:`x`-cell length of the ghost cell)

.. math::

  (\Delta x)\int\mathrm{d}\mathbf{v}\,\mathrm{d}y\,\Gamma_{\mathbf{z},x_+} =
  - (\Delta x)\int\mathrm{d}\mathbf{v}\,\mathrm{d}y\frac{1}{V}\sum_s
  \int\mathrm{d}\mathbf{v}'\,\mathrm{d}x\,\widehat{v_y'f\psi}\Big|^{v_{y,j+1/2}'}_{v_{y,j-1/2}'}

The final detail is that the files created by these diagnostics contain the fluxes 
through the boundary accumulated since the last snapshot (frame), not since the beginning of the
simulation.


References
----------

.. [Shi2017] Shi, E. L., Hammett, G. W., Stolzfus-Dueck, T., &
   Hakim, A. (2017). Gyrokinetic continuum simulation of turbulence in
   a straight open-field-line plasma. Journal of Plasma Physics, 83,
   1–27. http://doi.org/10.1017/S002237781700037X
