-- Plasma ------------------------------------------------------------------------
--
-- 2D incompressible Euler simulation of Kelvin-Helmholtz instability.
--
local Plasma = require("App.PlasmaOnCartGrid").IncompEuler()

local Lx = 10.0
local Ly = 4.*Lx

plasmaApp = Plasma.App {
   logToFile = true,

   tEnd        = 1000.0,           -- End time.
   nFrame      = 100,              -- Number of output frames.
   lower       = {0, 0},           -- Configuration space lower left.
   upper       = {Lx, Ly},         -- Configuration space upper right.
   cells       = {64,64},          -- Configuration space cells.
   basis       = "serendipity",    -- One of "serendipity" or "maximal-order".
   polyOrder   = 1,                -- Polynomial order.
   timeStepper = "rk3",            -- One of "rk2" or "rk3".
   cflFrac     = 0.9,
   
   -- Decomposition for configuration space.
   decompCuts = {2,2},    -- Cuts in each configuration direction.
   useShared  = false,    -- If to use shared memory.

   -- Boundary conditions for configuration space.
   periodicDirs = {1, 2},    -- Periodic directions.

   -- Fluid species.
   fluid = Plasma.Species {
      charge = -1.0,
      -- Initial conditions.
      init = function(t, xn)
         local x, y   = xn[1], xn[2]
         local pi     = math.pi
         local alpha  = 0.05
         local kx, ky = 2.*pi/Lx, 8.*(2.*pi/Ly)
         return alpha*math.sin(ky*y)+math.cos(kx*x)
      end,
      diagnostics = {"intMom"},
      evolve = true,    -- Evolve species?
   },

   -- Field solver.
   field = Plasma.Field {
      evolve = true,    -- Evolve field?
   },
}
-- Run application.
plasmaApp:run()
