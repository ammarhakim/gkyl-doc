.. highlight:: lua

.. _momentApp:

Moments: Multifluid-moment-Maxwell model
+++++++++++++++++++++++++++

The ``Moment`` app solves high-moment multifluid equations on a Cartesian grid, coupled to Maxwell's equations through the Lorentz force.

* Each fluid could be either five-moment, where the plasma pressure is assumed to a scalar (see [Hakim+2006]_), or ten-moment, where the full anisotropic and nongyrotropic plasma pressure tensors (see [Hakim2008]_) are evolved.

* The hyperbolic system is solved in converative forms of :ref:`the five-moment (Euler) equations<devEigenSysEuler>`, and/or :ref:`the ten-moment equations<devEigenSys10M>`, and :ref:`the perfectly hyperbolic Maxwell's equations<devEigenSysMaxwell>`.

* The sources that couples the plasma species momenta and electromagnetic fields are described :ref:`here<devFluidSrc>` and more comprehensively in [Wang+2020]_.


This App solves the hyperbolic and source parts parts of the coupled system separately and apply high accuracy schemes on both.

* Ignoring sources, the homogeneous equations of the fluid moments and electromagneic fields are solved separately using a high-resolution wave-propagation finite-volume method described in [Hakim+2006]_. The main time-step size constraint comes from the speed of light.

* The sources are evolved using a locally implicit, time-centered solver to step over the constraining scales like the Debye length and plasma frequency, etc. See :ref:`devFluidSrc` or [Wang+2020]_ for more details.

* We then apply an Strang-type operator-splitting sequence to combine the hyperbolic and source parts to achive second-order accuracy in time:

  .. math:: \exp\left(\mathcal{L}_{S}\Delta t/2\right)\exp\left(\mathcal{L}_{H}\Delta t\right)\exp\left(\mathcal{L}_{S}\Delta t/2\right).

  Here, we represent the homogeneous update schematically as the operator :math:`\exp\left(\mathcal{L}_{H}\Delta t\right)` and the source update as :math:`\exp\left(\mathcal{L}_{S}\Delta t\right)`.

.. contents::

Overall structure of app
------------------------

The overall structure of the app is as follows

.. code-block:: lua

  -- the Moments app wraps fluid and field objects, and tells the
  -- the program how to evolve and couple them
  local Moments = require("App.PlasmaOnCartGrid").Moments()
  local TenMoment = require "Eq.TenMoment" -- TenMoment or Euler

  -- create the app
  momentApp = Moments.App {
    -- basic parameters, e.g., time step, grid, domain decomposition

    -- description of each species: names are arbitrary
    electron = Moments.Species {
      -- species parameters, equations, and boundary conditions
    },

    -- repeat to add more species
    -- hydrogen = Moments.Species { ... },
    -- oxygen = Moments.Species { ... },

    -- EM fields (optional, can be omitted for neutral fluids)
    field = Moments.Field {
      -- EM field parameters, equations, and boundary conditions
    },

    -- basic source that couple the fluids and EM fields
    emSource = Moments.CollisionlessEmSource {
       -- names of the species to be coupled
       species = {"electron", "hydorgen", "oxygen"},
       -- other specifications
    },

    -- additional sources if needed
    elc10mSource = Moments.TenMomentRelaxSource {
       species = {"elctron"},
       -- other specifications
    },
  }

  -- run the app
  momentApp:run()


References
----------

.. [Hakim+2006] Hakim, A., Loverich, J., & Shumlak, U. (2006). A high resolution wave propagation scheme for ideal Two-Fluid plasma equations. Journal of Computational Physics, 219, 418–442. https://doi.org/10.1016/j.jcp.2006.03.036

.. [Hakim2008] Hakim, A. H. (2008). Extended MHD modeling with the ten-moment equations. Journal of Fusion Energy, 27, 36–43. https://doi.org/10.1007/s10894-007-9116-z

.. [Wang+2020] Wang, L., Hakim, A. H., Ng, J., Dong, C., & Germaschewski, K. (2020). Exact and locally implicit source term solvers for multifluid-Maxwell systems. Journal of Computational Physics. https://doi.org/10.1016/j.jcp.2020.109510

.. [Wang+2015] Wang, L., Hakim, A. H. A. H., Bhattacharjee, A., & Germaschewski, K. (2015). Comparison of multi-fluid moment models with particle-in-cell simulations of collisionless magnetic reconnection. Physics of Plasmas, 22(1), 012108. https://doi.org/10.1063/1.4906063


