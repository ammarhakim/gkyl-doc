.. highlight:: lua

.. _qs_gk1:

Gyrokinetic example
+++++++++++++++++++

The gyrokinetic system is used to study turbulence in magnetized plasmas.
Gkeyll's ``Gyrokinetic`` App is specialized to study the edge/scrape-off-layer region of fusion devices, which requires
handling of large fluctuations and open-field-line regions.
In this example, we will set up a gyrokinetic problem on open magnetic field lines (e.g. in the tokamak scrape-off layer).
Using specialized boundary conditions along the field line that model the sheath interaction between the plasma and 
conducting end plates, we will see that we can model the self-consistent formation of the sheath 
potential. This simple test case can then be used as a starting point for full nonlinear simulations of the tokamak SOL.

.. contents::

Background
----------

Gyrokinetics intro?

Input file
----------

The full Lua input file (:doc:`gk-sheath.lua <inputFiles/gk-sheath>`) for this simulation
is a bit longer than the one in :ref:`qs_intro`, 
but not to worry, we will go through each part of the input file carefully.

To set up a gyrokinetic simulation, we first need to load the ``Gyrokinetic`` App package and other
dependencies. This should be done at the top of the input file, via

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- App dependencies
  --------------------------------------------------------------------------------
  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()  -- load the Gyrokinetic App
  local Constants = require "Lib.Constants"                      -- load some Constants

Here we have also loaded the ``Constants`` library, which
contains various physical constants that we will use later.

The next block is the **Preamble**, containing input paramters and simple derived quantities:

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Preamble
  --------------------------------------------------------------------------------
  -- Universal constant parameters.
  eps0 = Constants.EPSILON0
  eV = Constants.ELEMENTARY_CHARGE
  qe = -eV                             -- electron charge
  qi = eV                              -- ion charge
  me = Constants.ELECTRON_MASS         -- electron mass
  mi = 2.014*Constants.PROTON_MASS     -- ion mass (deuterium ions)
  
  -- Plasma parameters.
  Te0 = 40*eV                          -- reference electron temperature, used to set up electron velocity grid [eV]
  Ti0 = 40*eV                          -- reference ion temperature, used to set up ion velocity grid [eV]
  n0 = 7e18                            -- reference density [1/m^3]
  
  -- Geometry and magnetic field parameters.
  B_axis = 0.5                         -- magnetic field strength at magnetic axis [T]
  R0 = 0.85                            -- device major radius [m]
  a0 = 0.15                            -- device minor radius [m]
  R = R0 + a0                          -- major radius of flux tube simulation domain [m]
  B0 = B_axis*(R0/R)                   -- magnetic field strength at R [T]
  Lpol = 2.4                           -- device poloidal length (e.g. from bottom divertor plate to top) [m]
  
  -- Parameters for collisions.
  nuFrac = 0.1                         -- use a reduced collision frequency (10% of physical)
  -- Electron collision freq.
  logLambdaElc = 6.6 - 0.5*math.log(n0/1e20) + 1.5*math.log(Te0/eV)
  nuElc = nuFrac*logLambdaElc*eV^4*n0/(6*math.sqrt(2)*math.pi^(3/2)*eps0^2*math.sqrt(me)*(Te0)^(3/2))
  -- Ion collision freq.
  logLambdaIon = 6.6 - 0.5*math.log(n0/1e20) + 1.5*math.log(Ti0/eV)
  nuIon = nuFrac*logLambdaIon*eV^4*n0/(12*math.pi^(3/2)*eps0^2*math.sqrt(mi)*(Ti0)^(3/2))
  
  -- Derived parameters
  vti = math.sqrt(Ti0/mi)              -- ion thermal speed
  vte = math.sqrt(Te0/me)              -- electron thermal speed
  c_s = math.sqrt(Te0/mi)              -- ion sound speed
  omega_ci = math.abs(qi*B0/mi)        -- ion gyrofrequency
  rho_s = c_s/omega_ci                 -- ion sound gyroradius
  
  -- Simulation box size
  Lx = 50*rho_s                        -- x = radial direction
  Ly = 100*rho_s                       -- y = binormal direction
  Lz = 4                               -- z = field-aligned direction

This simulation also requires a source, which models plasma crossing the separatrix. 
The next part of the **Preamble** initializes some source parameters, along with some functions 
that will be used later to set up the source density and temperature profiles.

.. code-block:: lua

  -- Source parameters
  P_SOL = 3.4e6                          -- total SOL power, from experimental heating power [W]
  P_src = P_SOL*Ly*Lz/(2*math.pi*R*Lpol) -- fraction of total SOL power into flux tube domain [W]
  xSource = R                            -- source peak radial location [m]
  lambdaSource = 0.005                   -- source radial width [m]

  -- Source density and temperature profiles. 
  -- Note that source density will be scaled to achieve desired source power.
  sourceDensity = function (t, xn)
     local x, y, z = xn[1], xn[2], xn[3]
     local sourceFloor = 1e-10
     if math.abs(z) < Lz/4 then
        -- near the midplane, the density source is a Gaussian
        return math.max(math.exp(-(x-xSource)^2/(2*lambdaSource)^2), sourceFloor)
     else
        return 1e-40
     end
  end
  sourceTemperature = function (t, xn)
     local x, y, z = xn[1], xn[2], xn[3]
     if math.abs(x-xSource) < 3*lambdaSource then
        return 80*eV
     else
        return 30*eV
     end
  end

This concludes the **Preamble**. We now have everything we need to initialize the ``Gyrokinetic`` App.
In this input file, the App initialization consists of 4 sections:

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- App initialization
  --------------------------------------------------------------------------------
  plasmaApp = Plasma.App {
     -----------------------------------------------------------------------------
     -- Common
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Species
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Fields
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Geometry
     -----------------------------------------------------------------------------
     ...
  }
  
- The **Common** section includes a declaration of parameters that control the (configuration space) discretization, and time advancement. This first block of code in :code:`Plasma.App` may specify the periodic directions, the MPI decomposition, and the frequency with which to output certain diagnostics.

.. code-block:: lua

     -----------------------------------------------------------------------------
     -- Common
     -----------------------------------------------------------------------------
     logToFile = true,                    -- will write simulation output log to gk-sheath_0.log
     tEnd = .5e-6,                        -- simulation end time [s]
     nFrame = 1,                          -- number of output frames for diagnostics
     lower = {R - Lx/2, -Ly/2, -Lz/2},    -- configuration space domain lower bounds, {x_min, y_min, z_min} 
     upper = {R + Lx/2, Ly/2, Lz/2},      -- configuration space domain upper bounds, {x_max, y_max, z_max}
     cells = {4, 1, 8},                   -- number of configuration space cells, {nx, ny, nz}
     basis = "serendipity",               -- basis type (only "serendipity" is supported for gyrokinetics)
     polyOrder = 1,                       -- polynomial order of basis set (polyOrder = 1 fully supported for gyrokinetics, polyOrder = 2 marginally supported)
     timeStepper = "rk3",                 -- timestepping algorithm 
     cflFrac = 0.4,                       -- fractional modifier for timestep calculation via CFL condition
     restartFrameEvery = .2,              -- restart files will be written after every 20% of simulation

     -- Specification of periodic directions 
     -- (1-based indexing, so x-periodic = 1, y-periodic = 2, etc)
     periodicDirs = {2},     -- Periodic in y only (y = 2nd dimension)

- The **Species** section sets up the species to be considered in the simulation. Each species gets its own Lua table, in which one provides the velocity-space domain and discretization of the species, initial conditions, sources, collisions, boundary conditions, and diagnostics.

In this input file, we initialize gyrokinetic electron and ion species. Since this
section is the most involved part of the input file, we will discuss various parts in detail below.

.. code-block:: lua

   --------------------------------------------------------------------------------
   -- Species
   --------------------------------------------------------------------------------
   -- Gyrokinetic electrons
   electron = Plasma.Species {
      evolve = true,     -- evolve species?
      charge = qe,       -- species charge
      mass = me,         -- species mass

      -- Species-specific velocity domain
      lower = {-4*vte, 0},                    -- velocity space domain lower bounds, {vpar_min, mu_min}
      upper = {4*vte, 12*me*vte^2/(2*B0)},    -- velocity space domain upper bounds, {vpar_max, mu_max}
      cells = {8, 4},                         -- number of velocity space cells, {nvpar, nmu}

      -- Initial conditions
      init = Plasma.MaxwellianProjection {    -- initialize a Maxwellian with the specified density and temperature profiles
              -- density profile
              density = function (t, xn)
                 -- The particular functional form of the initial density profile 
                 -- comes from a 1D single-fluid analysis (see Shi thesis), which derives
                 -- quasi-steady-state initial profiles from the source parameters.
                 local x, y, z, vpar, mu = xn[1], xn[2], xn[3], xn[4], xn[5]
                 local Ls = Lz/4
                 local floor = 0.1
                 local effectiveSource = math.max(sourceDensity(t,{x,y,0}), floor)
                 local c_ss = math.sqrt(5/3*sourceTemperature(t,{x,y,0})/mi)
                 local nPeak = 4*math.sqrt(5)/3/c_ss*Ls*effectiveSource/2
                 local perturb = 0 
                 if math.abs(z) <= Ls then
                    return nPeak*(1+math.sqrt(1-(z/Ls)^2))/2*(1+perturb)
                 else
                    return nPeak/2*(1+perturb)
                 end
              end,
              -- temperature profile
              temperature = function (t, xn)
                 local x = xn[1]
                 if math.abs(x-xSource) < 3*lambdaSource then
                    return 50*eV
                 else 
                    return 20*eV
                 end
              end,
              scaleWithSourcePower = true,     -- when source is scaled to achieve desired power, scale initial density by same factor
      },

      -- Collisions parameters
      coll = Plasma.LBOCollisions {          -- Lenard-Bernstein model collision operator
         collideWith = {'electron'},         -- only include self-collisions with electrons
         frequencies = {nuElc},              -- use a constant (in space and time) collision freq. (calculated in Preamble)
      },

      -- Source parameters
      source = Plasma.MaxwellianProjection {       -- source is a Maxwellian with the specified density and temperature profiles
                isSource = true,                   -- designate as source
                density = sourceDensity,           -- use sourceDensity function (defined in Preamble) for density profile
                temperature = sourceTemperature,   -- use sourceTemperature function (defined in Preamble) for temperature profile
                power = P_src/2,                   -- sourceDensity will be scaled to achieve desired power
      },

      -- Non-periodic boundary condition specification
      bcx = {Plasma.Species.bcZeroFlux, Plasma.Species.bcZeroFlux},   -- use zero-flux boundary condition in x direction
      bcz = {Plasma.Species.bcSheath, Plasma.Species.bcSheath},       -- use sheath-model boundary condition in z direction

      -- Diagnostics
      diagnosticMoments = {"GkM0", "GkUpar", "GkTemp"},     
      diagnosticIntegratedMoments = {"intM0", "intM1", "intKE", "intHE", "intSrcKE"},
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkHamilEnergy"},
      diagnosticIntegratedBoundaryFluxMoments = {"intM0", "intM1", "intKE", "intHE"},
   },

   -- Gyrokinetic ions
   ion = Plasma.Species {
      evolve = true,     -- evolve species?
      charge = qi,       -- species charge
      mass = mi,         -- species mass

      -- Species-specific velocity domain
      lower = {-4*vti, 0},                    -- velocity space domain lower bounds, {vpar_min, mu_min}
      upper = {4*vti, 12*mi*vti^2/(2*B0)},    -- velocity space domain upper bounds, {vpar_max, mu_max}
      cells = {8, 4},                         -- number of velocity space cells, {nvpar, nmu}

      -- Initial conditions
      init = Plasma.MaxwellianProjection {    -- initialize a Maxwellian with the specified density and temperature profiles
              -- density profile
              density = function (t, xn)
                 -- The particular functional form of the initial density profile 
                 -- comes from a 1D single-fluid analysis (see Shi thesis), which derives
                 -- quasi-steady-state initial profiles from the source parameters.
                 local x, y, z, vpar, mu = xn[1], xn[2], xn[3], xn[4], xn[5]
                 local Ls = Lz/4
                 local floor = 0.1
                 local effectiveSource = math.max(sourceDensity(t,{x,y,0}), floor)
                 local c_ss = math.sqrt(5/3*sourceTemperature(t,{x,y,0})/mi)
                 local nPeak = 4*math.sqrt(5)/3/c_ss*Ls*effectiveSource/2
                 local perturb = 0 
                 if math.abs(z) <= Ls then
                    return nPeak*(1+math.sqrt(1-(z/Ls)^2))/2*(1+perturb)
                 else
                    return nPeak/2*(1+perturb)
                 end
              end,
              -- temperature profile
              temperature = function (t, xn)
                 local x = xn[1]
                 if math.abs(x-xSource) < 3*lambdaSource then
                    return 50*eV
                 else 
                    return 20*eV
                 end
              end,
              scaleWithSourcePower = true,     -- when source is scaled to achieve desired power, scale initial density by same factor
      },

      -- Collisions parameters
      coll = Plasma.LBOCollisions {     -- Lenard-Bernstein model collision operator
         collideWith = {'ion'},         -- only include self-collisions with ions
         frequencies = {nuIon},         -- use a constant (in space and time) collision freq. (calculated in Preamble)
      },

      -- Source parameters
      source = Plasma.MaxwellianProjection {       -- source is a Maxwellian with the specified density and temperature profiles
                isSource = true,                   -- designate as source
                density = sourceDensity,           -- use sourceDensity function (defined in Preamble) for density profile
                temperature = sourceTemperature,   -- use sourceTemperature function (defined in Preamble) for temperature profile
                power = P_src/2,                   -- sourceDensity will be scaled to achieve desired power
      },

      -- Non-periodic boundary condition specification
      bcx = {Plasma.Species.bcZeroFlux, Plasma.Species.bcZeroFlux},   -- use zero-flux boundary condition in x direction
      bcz = {Plasma.Species.bcSheath, Plasma.Species.bcSheath},       -- use sheath-model boundary condition in z direction

      -- Diagnostics
      diagnosticMoments = {"GkM0", "GkUpar", "GkTemp"},     
      diagnosticIntegratedMoments = {"intM0", "intM1", "intKE", "intHE", "intSrcKE"},
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkHamilEnergy"},
      diagnosticIntegratedBoundaryFluxMoments = {"intM0", "intM1", "intKE", "intHE"},
   },

The initial condition for this problem is given by a Maxwellian. This is specified using ``init = Plasma.MaxwellianProjection { ... }``,
which is a table with entries for the density and temperature profile functions (we could also specify the driftSpeed profile) to be
used to initialze the Maxwellian. In this simulation, the initial density profile takes a particular form that 
comes from a 1D single-fluid analysis (see [Shi2019]_), which derives quasi-steady-state initial profiles from the source parameters.

The sources also take the form of Maxwellians, specified via ``source = Plasma.MaxwellianProjection { isSource = true, ... }``. 
For the density and temperature profile functions,
we use the sourceDensity and sourceTemperature functions defined in the Preamble. We also specify
the desired source power. The source density is then scaled so that the integrated power in the source
matches the desired power. Therefore, sourceDensity only controls the shape of the source density profile,
not the amplitude. Since the initial conditions are related to the source, we also scale the initial
species density by the same factor as the source via the ``scaleWithSourcePower = true`` flag in the initial conditions.

Self-species collisions are included using a Lenard-Bernstein model collision operator via the ``coll = Plasma.LBOCollisions { ... }`` table.
For more details about collision models and options, see :ref:`Collisions <collisionModels>`.

Non-periodic boundary conditions are specified via the ``bcx`` and ``bcz`` tables.
For this simulation, we use zero-flux boundary conditions in the x (radial) direction, 
and sheath-model boundary conditions in the z (field-aligned) direction.

Finally, we specify the diagnostics that should be outputted for each species. These consist of various moments
and integrated quantities. For more details about available diagnostics, see the Gyrokinetic app reference :ref:`page <gk_app>`.

- The **Fields** section specifies parameters and options related to the field solvers for the gyrokinetic potential(s). 

.. code-block:: lua

   --------------------------------------------------------------------------------
   -- Fields
   --------------------------------------------------------------------------------
   -- Gyrokinetic field(s)
   field = Plasma.Field {
      evolve = true, -- Evolve fields?
      isElectromagnetic = false,  -- use electromagnetic GK by including magnetic vector potential A_parallel? 

      -- Non-periodic boundary condition specification for electrostatic potential phi
      -- Dirichlet in x.
      phiBcLeft = { T ="D", V = 0.0},
      phiBcRight = { T ="D", V = 0.0},
      -- Periodic in y. --
      -- No BC required in z (Poisson solve is only in perpendicular x,y directions)
   },

- The **Geometry** section specifies parameters related to the background magnetic field and other geometry parameters.

.. code-block:: lua

   --------------------------------------------------------------------------------
   -- Geometry
   --------------------------------------------------------------------------------
   -- Magnetic geometry
   funcField = Plasma.Geometry {
      -- Background magnetic field profile
      -- Simple helical (i.e. cylindrical slab) geometry is assumed
      bmag = function (t, xn)
         local x = xn[1]
         return B0*R/x
      end,

      -- Geometry is not time-dependent.
      evolve = false,
   },

This concludes the App initialization section. The final thing to do in the input file is tell the simulation to run:

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Run the App
  --------------------------------------------------------------------------------
  plasmaApp:run()

Running the simulation
----------------------

The simulation can be run from the command line by navigating to the directory
where the input file lives, and executing

.. code-block:: bash

  ~/gkylsoft/gkyl/bin/gkyl gk-sheath.lua

You should see the program printing to the screen like this:

.. code-block:: bash

	bash$ ~/gkylsoft/gkyl/bin/gkyl gk-sheath.lua 
	Thu Sep 17 2020 12:02:01.000000000
	Gkyl built with 1b66bd4a21e5
	Gkyl built on Sep 17 2020 11:59:51
	Initializing Gyrokinetic simulation ...
	Initializing completed in 2.30621 sec
	
	Starting main loop of Gyrokinetic simulation ...
	
	 Step 0 at time 0. Time step 5.4405e-09. Completed 0%
	012345678 Step    13 at time 5.44914e-08. Time step 4.85799e-09. Completed 10%
	9012345678 Step    24 at time 1.02034e-07. Time step 4.46502e-09. Completed 20%
	90123

This simulation should run in ~15 seconds. The full output to the screen 
will look something like :doc:`this <inputFiles/gk-sheath-log>`.

Postprocessing
--------------

References
----------

.. [Shi2019] Shi, E. L., Hammett, G. W., Stoltzfus-Dueck, T., & Hakim,
  A. (2019). "Full-f gyrokinetic simulation of turbulence in a helical
  open-field-line plasma", *Physics of Plasmas*, **26**,
  012307. https://doi.org/10.1063/1.5074179
