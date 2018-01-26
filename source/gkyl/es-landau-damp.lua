-- Gkyl ------------------------------------------------------------------------
local Vlasov = require "App.VlasovOnCartGrid"

vthe, vthi, k, alpha = 1.0, 0.05, 0.375, 0.01

vlasovApp = Vlasov.App {
   logToFile = true,

   tEnd = 20, -- end time
   nFrame = 2, -- number of output frames
   lower = {-math.pi/k}, -- configuration space lower left
   upper = {math.pi/k}, -- configuration space upper right
   cells = {32}, -- configuration space cells
   basis = "serendipity", -- one of "serendipity" or "maximal-order"
   polyOrder = 2, -- polynomial order
   cflFrac = 1.0, -- CFL "fraction". Usually 1.0
   timeStepper = "rk3s4", -- one of "rk2" or "rk3"

   -- decomposition for configuration space
   decompCuts = {1}, -- cuts in each configuration direction
   useShared = false, -- if to use shared memory

   -- boundary conditions for configuration space
   periodicDirs = {1}, -- periodic directions
   bcx = { }, -- boundary conditions in X

   -- electrons
   elc = Vlasov.Species {
      charge = -1.0, mass = 1.0,
      -- velocity space grid
      lower = {-6.0},
      upper = {6.0},
      cells = {32},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
	 local x, v = xn[1], xn[2]
	 return 1/math.sqrt(2*math.pi*vthe^2)*math.exp(-v^2/(2*vthe^2))*(1.0 + alpha * math.cos(k*x))
      end,
      evolve = true, -- evolve species?
   },
   
   -- ions
   ions = Vlasov.Species {
      charge = 1.0, mass = 20.0,
      -- velocity space grid
      lower = {-0.30},
      upper = {0.30},
      cells = {32},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
	 local x, v = xn[1], xn[2]
	 return 1/math.sqrt(2*math.pi*vthi^2)*math.exp(-v^2/(2*vthi^2)) 
      end,
      evolve = false, -- evolve species?
   },
   -- field solver
   field = Vlasov.EmField {
      epsilon0 = 1.0, mu0 = 1.0,
      init = function (t, xn)
	    local Ex = -1.0*alpha/k * math.sin(k*xn[1])
	    return Ex, 0.0, 0.0, 0.0, 0.0, 0.0
      end,
      evolve = true, -- evolve field?
   },
}
-- run application
vlasovApp:run()
