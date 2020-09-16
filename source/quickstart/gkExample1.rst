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

The full Lua input file (found :doc:`here <inputFiles/gk-sheath>`) for this simulation
is a bit longer than the first Vlasov :ref:`example <qs_intro>` from the introduction, 
but not to worry, we will go through each part of the input file carefully.

To set up a gyrokinetic simulation, we first need to load the ``Gyrokinetic`` App package.
This should be done at the top of the input file, via

.. code-block:: lua

  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()  -- load the Gyrokinetic App

We can also load other useful packages; here we load the ``Constants`` library, which
contains various physical constants that we will use later.

.. code-block:: lua

  local Constants = require "Lib.Constants"                      -- load some Constants

The next block of the input file contains input paramters and simple derived quantities:

.. code-block:: lua

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
The next block initializes some source parameters, along with some functions 
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

We now have everything we need to initialize the ``Gyrokinetics`` App.

Postprocessing
--------------
