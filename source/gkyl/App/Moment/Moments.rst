.. highlight:: lua

.. _momentApp:

.. contents::

Moments: Multifluid-moment-Maxwell model
+++++++++++++++++++++++++++

Summary of model equations
--------------------------

The ``Moment`` app solves high-moment multifluid equations on a Cartesian grid, coupled to Maxwell's equations through the Lorentz force.

* Each fluid could be either five-moment, where the plasma pressure is assumed to a scalar (see [Hakim+2006]_), or ten-moment, where the full anisotropic and nongyrotropic plasma pressure tensors (see [Hakim2008]_) are evolved.

* The hyperbolic system is solved in converative forms of :ref:`the five-moment (Euler) equations<devEigenSysEuler>`, and/or :ref:`the ten-moment equations<devEigenSys10M>`, and :ref:`the perfectly hyperbolic Maxwell's equations<devEigenSysMaxwell>`.

* The sources that couples the plasma species momenta and electromagnetic fields are described :ref:`here<devFluidSrc>` and more comprehensively in [Wang+2020]_.


This App solves the hyperbolic and source parts parts of the coupled system separately and apply high accuracy schemes on both.

* Ignoring sources, the homogeneous equations of the fluid moments and electromagneic fields are solved separately using a high-resolution wave-propagation finite-volume method described in [Hakim+2006]_. The main time-step size constraint comes from the speed of light.

* The sources are evolved using a locally implicit, time-centered solver to step over the constraining scales like the Debye length and plasma frequency, etc. See :ref:`devFluidSrc` or [Wang+2020]_ for more details.

* Additonial sources can be added if needed, for example, for the ten-moment model, we may apply the closure to relax the pressure tensor towards a scalar pressure (see [Wang+2015]_).

* We then apply an Strang-type operator-splitting sequence to combine the hyperbolic and source parts to achive second-order accuracy in time:

  .. math:: \exp\left(\mathcal{L}_{S}\Delta t/2\right)\exp\left(\mathcal{L}_{H}\Delta t\right)\exp\left(\mathcal{L}_{S}\Delta t/2\right).

  Here, we represent the homogeneous update schematically as the operator :math:`\exp\left(\mathcal{L}_{H}\Delta t\right)` and the source update as :math:`\exp\left(\mathcal{L}_{S}\Delta t\right)`.

Overall structure of the Moments app
------------------------

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


Examples
--------


Basic parameters
------------------

.. list-table:: Basic Parameters for ``PlasmaOnCartGrid.Moments``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``logToFile``
     - If set to true, log messages are written to log file
     - ``true``
   * - ``tEnd``
     - End time of simulation
     -
   * - ``suggestedDt``
     - Initial suggested time-step. Adjusted as simulation progresses.
     - ``tEnd/nFrame``
   * - ``nFrame``
     - Number of frames of data to write. Initial conditions are
       always written. For more fine-grained control over species and
       field output, see below.
     -
   * - ``lower``
     - CDIM length table with lower-left configuration space coordinates
     -
   * - ``upper``
     - CDIM length table with upper-right configuration space coordinates
     -
   * - ``cells``
     - CDIM length table with number of configuration space cells
     -
   * - ``cfl``
     - CFL number to use. **This parameter should be avoided and
       ``cflFrac`` used instead.**
     - Determined from ``cflFrac``
   * - ``cflFrac``
     - Fraction (usually 1.0) to multiply CFL determined time-step. 
     - Determined from ``timeStepper``
   * - ``maximumDt``
     - Hard limit of time step size.
     - ``tEnd-tStart``
   * - ``timeStepper``
     - The multifluid-Maxwell model currently only supports the dimensional-
       splitting finite-volume method, i.e., ``"fvDimSplit"``.
     - ``"fvDimSplit"``
   * - ``decompCuts``
     - CDIM length table with number of processors to use in each
       configuration space direction.
     - ``{ }``
   * - ``useShared``
     - Set to ``true`` to use shared memory.
     - ``false``
   * - ``periodicDirs``
     - Periodic directions. Note: X is 1, Y is 2 and Z is 3. E.g., ``{2}`` sets
       the Y direction to be periodic.
     - ``{ }``

.. note::

   - In general, you should not specify ``cfl`` or ``cflFrac``,
     unless either doing tests or explicitly controlling the
     time-step. The app will determine the time-step automatically.
   - When ``useShared=true`` the ``decompCuts`` must specify the
     *number of nodes* and not number of processors. That is, the total
     number of processors will be determined from ``decompCuts`` and
     the number of threads per node.

     
Species parameters
------------------

.. list-table:: Parameters for ``Moments.Species``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``charge``
     - Species charge (ignored for neutral particles)
     -
   * - ``mass``
     - Species mass (ignored for neutral particles)
     -
   * - ``equation``
     - The type of default moment equation for this species, e.g.,
       ```Euler {gasGamma=5/3}```, ```equation = TenMoment {}```. If domain
       invariance is violated, i.e., negative density/pressure occurs, the
       step is retaken using the ```equationInv``` method that is supposed to
       guarantee positivity but is more diffusive.
     - 
   * - ``equationInv``
     - Backup equation that guarantees positivity in case it is violated when
       the default ```equation``` is used. Examples are:
       ```equationInv = Euler { gasGamma = gasGamma, numericalFlux = 'lax' }```,
       ```equationInv = TenMoment { numericalFlux = "lax" }```.
     - 
   * - ``init``
     - Function with signature ``function(t,xn)`` that initializes the
       species moments. This function return n values, where n is the number
       of moments for this species.
     -
   * - ``bcx``
     - Length two table with BCs in X direction. See details on BCs below.
     - ``{ }``
   * - ``bcy``
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - ``{ }``
   * - ``bcz``
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - ``{ }``     
   * - ``evolve``
     - If set to ``false`` the moments are not evolved in the hyperbolic part,
       but could be modified in the source updater. In this case, by default
       only initial conditions for this species will be written to file. To
       force writing to file as usual, set the ``forceWrite`` option to true.
     - ``true``
   * - ``forceWrite``
     - If set to ``true`` the moments are written to file even if ``evolve`` is
       set to ``false``.
     - ``false``

       
Electromagnetic field parameters
--------------------------------


.. list-table:: Parameters for ``Moments.Field`` derived from ``App.Field.MaxwellField``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - ``nFrame``
     - These many field outputs will be written during simulation. If
       not specified, top-level ``nFrame`` parameter will be used
     - ``nFrame`` from top-level
   * - ``epsilon0``
     - Vacuum permittivity (:math:`\epsilon_0`)
     -
   * - ``mu0``
     - Vacuum permeability (:math:`\mu_0`)
     -
   * - ``mgnErrorSpeedFactor``
     - Factor specifying speed for magnetic field divergence error correction
     - ``0.0``
   * - ``elcErrorSpeedFactor``
     - Factor specifying speed for electric field divergence error correction
     - ``0.0``
   * - ``init``
     - Function with signature ``function(t,xn)`` that initializes the
       field. This function must return 6 values arranged as
       :math:`E_x, E_y, E_z, B_x, B_y, B_z` at :math:`t=0` at ``xn``,
       which is a CDIM vector.
     -
   * - ``bcx``
     - Length two table with BCs in X direction. See details on BCs below.
     - ``{ }``
   * - ``bcy``
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - ``{ }``
   * - ``bcz``
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - ``{ }``
   * - ``evolve``
     - If set to ``false`` the field is not evolved. In this case,
       only initial conditions will be written to file.
     - ``true``
   * - ``forceWrite``
     - If set to ``true`` the moments are written to file even if ``evolve`` is
       set to ``false``.
     - ``false``

     
App output
----------

The app will write snapshots of moments for each species and the EM
fields at specified time intervals. Diagnostics like integrated fluid
moments and field energy are recorded for each time-step and written
in one file for each species/field object.

The output format is `ADIOS BP
<https://www.olcf.ornl.gov/center-projects/adios/>`_ files. Say your
input file is called "5m.lua" and your species are called "elc"
and "ion". Then, over specified time invertals the app will write out
the following files:

- ``5m_elc_N.bp``
- ``5m_ion_N.bp``
- ``5m_field_N.bp``

Where ``N`` is the frame number (frame 0 is the initial
conditions). Note that if a species or the field is not evolved, then
only initial conditions will be written unless the ``forceWrite`` option
is set to ``true``.

In addition, integrated moments for each species are
written:

- ``vlasov_elc_intMom_N.bp``

For the field, the electromagnetic energy components :math:`E_x^2`,
:math:`E_y^2`, :math:`E_z^2`, :math:`B_x^2`, :math:`B_y^2`, and
:math:`B_z^2` (integrated over configuration space) are stored in the
file:

- ``vlasov_fieldEnergy_N.bp``

These can be plotted using postgkyl in the usual way.

References
----------

.. [Hakim+2006] Hakim, A., Loverich, J., & Shumlak, U. (2006). A high resolution wave propagation scheme for ideal Two-Fluid plasma equations. Journal of Computational Physics, 219, 418–442. https://doi.org/10.1016/j.jcp.2006.03.036

.. [Hakim2008] Hakim, A. H. (2008). Extended MHD modeling with the ten-moment equations. Journal of Fusion Energy, 27, 36–43. https://doi.org/10.1007/s10894-007-9116-z

.. [Wang+2020] Wang, L., Hakim, A. H., Ng, J., Dong, C., & Germaschewski, K. (2020). Exact and locally implicit source term solvers for multifluid-Maxwell systems. Journal of Computational Physics. https://doi.org/10.1016/j.jcp.2020.109510

.. [Wang+2015] Wang, L., Hakim, A. H. A. H., Bhattacharjee, A., & Germaschewski, K. (2015). Comparison of multi-fluid moment models with particle-in-cell simulations of collisionless magnetic reconnection. Physics of Plasmas, 22(1), 012108. https://doi.org/10.1063/1.4906063


