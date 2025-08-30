-- Gkyl ------------------------------------------------------------------------
local Vlasov = (require "App.PlasmaOnCartGrid").VlasovMaxwell()

vlasovApp = Vlasov.App {
   logToFile = true,

   tEnd = 20.0, -- end time
   nFrame = 2, -- number of output frames
   lower = {0.0}, -- configuration space lower left
   upper = {2*math.pi}, -- configuration space upper right
   cells = {32}, -- configuration space cells
   basis = "serendipity", -- one of "serendipity" or "maximal-order"
   polyOrder = 2, -- polynomial order
   timeStepper = "rk3s4", -- one of "rk2", "rk3" or "rk3s4"

   -- decomposition for configuration space
   decompCuts = {1}, -- cuts in each configuration direction
   useShared = false, -- if to use shared memory

   -- boundary conditions for configuration space
   periodicDirs = {1}, -- periodic directions

   -- electrons
   elc = Vlasov.Species {
      charge = -1.0, mass = 1.0,
      -- velocity space grid
      lower = {-6.0},
      upper = {6.0},
      cells = {16},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
	 local x, v = xn[1], xn[2]
	 return 1/math.sqrt(2*math.pi)*math.exp(-v^2/2)
      end,
      evolve = true, -- evolve species?
   },

   -- field solver
   field = Vlasov.Field {
      epsilon0 = 1.0, mu0 = 1.0,
      init = function (t, xn)
	 local Ex = -math.sin(xn[1])
	 return Ex, 0.0, 0.0, 0.0, 0.0, 0.0
      end,
      evolve = false, -- evolve field?
   },
}
-- run application
vlasovApp:run()
