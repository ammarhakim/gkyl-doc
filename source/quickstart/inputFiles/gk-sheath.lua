-- Gkyl ------------------------------------------------------------------------
-- This test sets up a simple 5D (3x2v) gyrokinetic scrape-off layer calculation.
-- Gyrokinetic electron and ion species are evolved in a helical magnetic field geometry.
-- The boundary condition along the background field models the sheath interaction of
-- the plasma with conducting end plates, allowing the sheath potential to form self-consistently.
--------------------------------------------------------------------------------
-- App dependencies
--------------------------------------------------------------------------------
local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()  -- load the Gyrokinetic App
local Constants = require "Lib.Constants"                      -- load some physical Constants

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

--------------------------------------------------------------------------------
-- App initialization
--------------------------------------------------------------------------------
plasmaApp = Plasma.App {
   --------------------------------------------------------------------------------
   -- Common
   --------------------------------------------------------------------------------
   logToFile = true,                    -- will write simulation output log to gk-sheath_0.log
   tEnd = 10e-6,                        -- simulation end time [s]
   nFrame = 10,                          -- number of output frames for diagnostics
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

   decompCuts = {2,1,4},

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
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkEnergy"},
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
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkEnergy"},
      diagnosticIntegratedBoundaryFluxMoments = {"intM0", "intM1", "intKE", "intHE"},
   },

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
}

--------------------------------------------------------------------------------
-- Run the App
--------------------------------------------------------------------------------
plasmaApp:run()
