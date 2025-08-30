-- Gkyl ------------------------------------------------------------------------
-- Local flux-tube simulation of a linear kinetic ballooning mode (KBM)
-- with 3x2v gyrokinetics.
--------------------------------------------------------------------------------
local Plasma    = require("App.PlasmaOnCartGrid").Gyrokinetic()
local Constants = require "Lib.Constants"

-- Universal parameters.
eV  = Constants.ELEMENTARY_CHARGE
qe  = -eV
qi  = eV
me  = Constants.ELECTRON_MASS
mi  = 2*Constants.PROTON_MASS   -- Deuterium ions.
mu0 = Constants.MU0

B0      = 1.91      -- Maximum field strength on axis [T].
R0      = 1.313     -- Major radius of magnetic axis [m].
a       = 0.4701    -- Minor radius [m].
Ti0     = 2072*eV   -- Ion temperature [J].
eps_n   = 0.2       -- Ratio of density gradient scale length to major radius, L_n/R.
eta_e   = 2.0       -- Ratio of density to electron temperature gradient scale lengths, L_n/L_Te.
eta_i   = 2.5       -- Ratio of density to ion temperature gradient scale lengths, L_n/L_Ti.
ky_rhoi = 0.5       -- Wavenumber along y, normalized to the ion gyroradius (ky*rho_i).
kz_Ln   = 0.1       -- Wavenumber along z, normalized to the density gradient scale length (kz*L_n).
beta_i  = .02       -- Ion plasma beta. 
tau     = 1         -- Ion to electron temperature ratio, Ti0/Te0.

r0       = 0.5*a                    -- Minor radius of flux tube.
R        = R0 + r0                  -- Major radius of flux tube.
B        = B0*R0/R                  -- Magnetic field strength in flux tube.
n0       = beta_i*B^2/(2*mu0*Ti0)   -- Reference density [m^{-3}].
Te0      = Ti0/tau                  -- Electron temperature [J].
vte  	 = math.sqrt(Te0/me)        -- Electron thermal speed [m/s]. 
vti  	 = math.sqrt(Ti0/mi)        -- Ion thermal speed [m/s]. 
c_s      = math.sqrt(Te0/mi)        -- Sound speed [m/s].
omega_ci = math.abs(qi*B/mi)        -- Ion cyclotron frequency [rad/s].
omega_ce = math.abs(qe*B/me)        -- Electron cyclotron frequency [rad/s].
rho_s    = c_s/omega_ci             -- Ion sound gyroradius [m].
rho_e    = vte/omega_ce             -- Electron gyroradius [m].
rho_i    = vti/omega_ci             -- Ion gyroradius [m].
ky_min   = ky_rhoi / rho_i          -- Smallest perpendicular wavenumber in the simulation [m^{-1}]. 
dr       = 2*math.pi/ky_min         -- Largest perpendicular wavelength in the box [m].
L_n      = R*eps_n                  -- Density gradient scale length [m].
L_Te     = L_n/eta_e                -- Electron temperature gradient scale length [m]. 
L_Ti     = L_n/eta_i                -- Ion temperature gradient scale length [m]. 
kz_min   = kz_Ln / L_n              -- Smallest parallel wavenumber [m^{-1}].
L_parallel = 2*math.pi/kz_min       -- Largest parallel wavelength [m].

-- Velocity grid parameters.
N_VPAR, N_MU = 8, 4
VPAR_UPPER   = 4*vte
VPAR_LOWER   = -VPAR_UPPER
MU_LOWER     = 0
MU_UPPER     = 16*me*vte*vte/B/2

plasmaApp = Plasma.App {
   logToFile = true,

   tEnd   = 6*L_n/vti/2,                             -- End time.
   nFrame = 20,                                      -- Number of output frames
   lower  = {r0 - .01*dr/2, -dr/2, -L_parallel/2},   -- Configuration space lower left
   upper  = {r0 + .01*dr/2,  dr/2,  L_parallel/2},   -- Configuration space upper right
   cells  = {1, 8, 8},                               -- Configuration space cells.
   basis  = "serendipity",                           -- One of "serendipity" or "maximal-order".
   polyOrder   = 1,                                  -- Polynomial order.
   timeStepper = "rk3",                              -- One of "rk2" or "rk3".
   cflFrac     = 1.0,                                -- CFL factor. 

   -- Decomposition for configuration space.
   decompCuts = {1, 1, 1},   -- Cuts in each configuration direction.
   useShared  = false,       -- If to use shared memory.

   periodicDirs = {1,2,3},   -- Periodic directions.

   -- Gyrokinetic electrons.
   electron = Plasma.Species {
      charge = qe, mass = me,
      -- Velocity space grid.
      lower = {VPAR_LOWER, MU_LOWER},
      upper = {VPAR_UPPER, MU_UPPER},
      cells = {N_VPAR, N_MU},
      -- Initial conditions.
      -- Specify an equilibrium/background Maxwellian distribution.
      background = Plasma.MaxwellianProjection {
         density = function (t, xn)
            local x = xn[1]
            return n0*(1-(x-r0)/L_n)
         end,
         driftSpeed = 0.0,
         temperature = function (t, xn)
            local x = xn[1]
            return Te0*(1-(x-r0)/L_Te)
         end,
         exactScaleM012 = true,
      },
      -- The full initial distribution is a combination of the
      -- equilibrium plus an initial perturbation.
      init = Plasma.MaxwellianProjection {
         density = function (t, xn)
            local x, y, z = xn[1], xn[2], xn[3]
            local perturb = 1e-5*rho_s/L_n*math.cos(ky_min*y+kz_min*z)
            return n0*(1-(x-r0)/L_n) + n0*perturb
         end,
         driftSpeed = 0.0,
         temperature = function (t, xn)
            local x = xn[1]
            return Te0*(1-(x-r0)/L_Te)
         end,
         exactScaleM012 = true,
      },
      fluctuationBCs = true,   -- Only apply (periodic) BCs to fluctuations.
      evolve         = true,   -- Evolve species?
      diagnostics    = {"M0", "Beta", "intM0", "intM2"},
   },

   -- Gyrokinetic ions.
   ion = Plasma.Species {
      charge = qi, mass = mi,
      -- Velocity space grid.
      lower = {VPAR_LOWER*vti/vte, MU_LOWER*mi*(vti^2)/(me*(vte^2))},
      upper = {VPAR_UPPER*vti/vte, MU_UPPER*mi*(vti^2)/(me*(vte^2))},
      cells = {N_VPAR, N_MU},
      -- Initial conditions.
      -- Specify an equilibrium/background Maxwellian distribution.
      background = Plasma.MaxwellianProjection {
         density = function (t, xn)
            local x = xn[1]
            return n0*(1-(x-r0)/L_n)
         end,
         driftSpeed = 0.0,
         temperature = function (t, xn)
            local x = xn[1]
            return Ti0*(1-(x-r0)/L_Ti)
         end,
         exactScaleM012 = true,
      },
      -- The full initial distribution is a combination of the
      -- equilibrium plus an initial perturbation.
      init = Plasma.MaxwellianProjection {
         density = function (t, xn)
            local x, y, z = xn[1], xn[2], xn[3]
            local perturb = 1e-5*rho_s/L_n*math.cos(ky_min*y+kz_min*z)
            return n0*(1-(x-r0)/L_n) --+ n0*perturb
         end,
         driftSpeed = 0.0,
         temperature = function (t, xn)
            local x = xn[1]
            return Ti0*(1-(x-r0)/L_Ti)
         end,
         exactScaleM012 = true,
      },
      fluctuationBCs = true,   -- Only apply (periodic) BCs to fluctuations.
      evolve         = true,   -- Evolve species?
      diagnostics    = {"M0", "Beta", "intM0", "intM2"},
   },

   -- Field solver.
   field = Plasma.Field {
      evolve            = true,   -- Evolve fields?
      isElectromagnetic = true,
   },

   -- Magnetic geometry. 
   funcField = Plasma.Geometry {
      -- background magnetic field
      bmag = function (t, xn)
         local x, y, z = xn[1], xn[2], xn[3]
         return B0*R0/(R0 + x)
      end,
      -- Geometry is not time-dependent.
      evolve = false,
   },
}
-- Run application.
plasmaApp:run()

