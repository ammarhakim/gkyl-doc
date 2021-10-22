-- Gkyl ------------------------------------------------------------------------
-- 1x1v simulation of two stream instability
--------------------------------------------------------------------------------
-- App dependencies
--------------------------------------------------------------------------------
local Plasma = require("App.PlasmaOnCartGrid").VlasovMaxwell()
--------------------------------------------------------------------------------
-- Preamble
--------------------------------------------------------------------------------
local vth_e = 0.2             -- electron thermal velocity
local drift = 1.0             -- drift velocity
local perturbK = 0.5          -- perturbation wave-number
local perturbMag = 1.0e-6     -- distribution function perturbation

local function maxwellian(v, n, u, vth)   -- Maxwellian in 1x1v
   return 1/math.sqrt(2*math.pi*vth^2)*math.exp(-(v-u)^2/(2*vth^2))
end

plasmaApp = Plasma.App {
   -----------------------------------------------------------------------------
   -- Common
   -----------------------------------------------------------------------------
   logToFile = true,

   tEnd = 50.0,                  -- end time
   nFrame = 100,                 -- number of output frames
   lower = {-math.pi/perturbK},  -- configuration space lower left
   upper = {math.pi/perturbK},   -- configuration space upper right
   cells = {64},                 -- number of configuration space cells
   basis = "serendipity",        -- basis function
   polyOrder = 2,                -- polynomial order
   timeStepper = "rk3",          -- 3rd order Runge-Kutta

   -- MPI decomposition for configuration space
   decompCuts = {1},   -- number of cuts in each configuration direction
   useShared = false,  -- flag for MPI shared memory

   -- boundary conditions for configuration space
   periodicDirs = {1}, -- periodic directions

   -----------------------------------------------------------------------------
   -- Electrons
   -----------------------------------------------------------------------------
   elc = Plasma.Species {
      charge = -1.0, mass = 1.0,
      -- velocity space grid
      lower = {-6.0},
      upper = {6.0},
      cells = {64},
      decompCuts = {1},
      -- initial conditions
      init = function (t, z)
	 local x, vx = z[1], z[2]
	 local f = maxwellian(vx, 0.5, drift, vth_e) +
            maxwellian(vx, 0.5, -drift, vth_e)
	 return (1+perturbMag*math.cos(perturbK*x))*f
      end,
      evolve = true,
      diagnostics = {"M0","M1i","M2ij","M3i","intM0","intM1i","intM2Flow","intM2Thermal"},
   },

   
   -----------------------------------------------------------------------------
   -- Field Solver
   -----------------------------------------------------------------------------
   field = Plasma.Field {
      epsilon0 = 1.0, mu0 = 1.0,
      init = function (t, z)
         local x = z[1]
	 local Ex = -perturbMag*math.sin(perturbK*x)/perturbK
	 return Ex, 0.0, 0.0, 0.0, 0.0, 0.0
      end,
      evolve = true,
   },
}
--------------------------------------------------------------------------------
-- Run the application
--------------------------------------------------------------------------------
plasmaApp:run()
