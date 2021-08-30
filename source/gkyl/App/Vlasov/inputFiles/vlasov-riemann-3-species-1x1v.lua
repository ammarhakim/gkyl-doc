-- Gkyl ------------------------------------------------------------------------
local Vlasov = (require "App.PlasmaOnCartGrid").VlasovMaxwell()

epsilon0 = 1.0 -- permittivity of free space
mu0 = 1.0 -- pemiability of free space
lightSpeed = 1/math.sqrt(mu0*epsilon0) -- speed of light

Te_Ti = 45.0 -- ratio of electron to ion temperature
n0 = 1.0 -- initial number density
n1 = 2.0 -- initial number density on high side

elcTemp = 1.0e-2 -- electron temperature
elcMass = 1.0 -- electron mass
elcCharge = -1.0 -- electron charge

ionTemp = elcTemp/Te_Ti -- ion temperature
ionMass = 1836.2 -- ion mass
ionCharge = 1.0 -- ion charge
ionFrac = 0.01

AlTemp = elcTemp/Te_Ti -- Al temperature
AlMass = 49577. -- Al mass
AlCharge = 13.0 -- Al charge
AlFrac = 1. - ionFrac

nfrac = math.abs(elcCharge/(ionFrac*ionCharge + AlFrac*AlCharge)) -- Maintain charge neutrality 

-- thermal speeds
cs = math.sqrt(elcTemp/ionMass)
vtElc = math.sqrt(elcTemp/elcMass)
vtIon = math.sqrt(ionTemp/ionMass)
vtAl = math.sqrt(AlTemp/ionMass)
-- plasma frequency and Debye length
wpe = math.sqrt(elcCharge^2*n0/(epsilon0*elcMass))
wpi = math.sqrt(ionCharge^2*n0*ionFrac*nfrac/(epsilon0*ionMass))
wpAl = math.sqrt(AlCharge^2*n0*AlFrac*nfrac/(epsilon0*AlMass))
lambdaD = vtElc/wpe

-- domain size and simulation time
LX = 200*lambdaD

vlasovApp = Vlasov.App {
   logToFile = true,

   tEnd = 1720.0/wpe, -- end time
   nFrame = 40, -- number of output frames
   lower = {0.0}, -- configuration space lower left
   upper = {LX}, -- configuration space upper right
   cells = {512}, -- configuration space cells
   basis = "serendipity", -- one of "serendipity" or "maximal-order"
   polyOrder = 2, -- polynomial order
   timeStepper = "rk3", -- one of "rk2" or "rk3"

   -- decomposition for configuration space
   decompCuts = {256}, -- cuts in each configuration direction
   useShared = false, -- if to use shared memory

   -- boundary conditions for configuration space
   periodicDirs = {1}, -- periodic directions

   -- electrons
   elc = Vlasov.Species {
      charge = elcCharge, mass = elcMass,
      -- velocity space grid
      lower = {-8.0*vtElc},
      upper = {8.0*vtElc},
      cells = {64},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
       local x, v = xn[1], xn[2]
         local sloc1 = 0.25*LX
         local sloc2 = 0.75*LX
	  local fv = n1/math.sqrt(2*math.pi*elcTemp/elcMass)*math.exp(-elcMass*v^2/(2.0*elcTemp))
         if x>sloc1 and x<sloc2 then
            fv = n0/math.sqrt(2*math.pi*elcTemp/elcMass)*math.exp(-elcMass*v^2/(2.0*elcTemp))
         end
	  return fv
      end,
      evolve = true, -- evolve species?
      diagnosticMoments = { "M0", "M1i", "M2" }
   },
   -- protons
   ion = Vlasov.Species {
      charge = ionCharge, mass = ionMass,
      -- velocity space grid
      lower = {-32.0*vtIon},
      upper = {32.0*vtIon},
      cells = {256},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
       local x, v = xn[1], xn[2]
         local sloc1 = 0.25*LX
         local sloc2 = 0.75*LX
	  local fv = n1*nfrac*ionFrac/math.sqrt(2*math.pi*ionTemp/ionMass)*math.exp(-ionMass*v^2/(2.0*ionTemp))
         if x>sloc1 and x<sloc2 then
            fv = n0*nfrac*ionFrac/math.sqrt(2*math.pi*ionTemp/ionMass)*math.exp(-ionMass*v^2/(2.0*ionTemp))
         end
	  return fv
      end,
      evolve = true, -- evolve species?
      diagnosticMoments = { "M0", "M1i", "M2" }
   },
   -- Aluminum
   Al = Vlasov.Species {
      charge = AlCharge, mass = AlMass,
      -- velocity space grid
      lower = {-64.0*vtAl},
      upper = {64.0*vtAl},
      cells = {512},
      decompCuts = {1},
      -- initial conditions
      init = function (t, xn)
       local x, v = xn[1], xn[2]
         local sloc1 = 0.25*LX
         local sloc2 = 0.75*LX
	  local fv = n1*nfrac*AlFrac/math.sqrt(2*math.pi*AlTemp/AlMass)*math.exp(-AlMass*v^2/(2.0*AlTemp))
         if x>sloc1 and x<sloc2 then
            fv = n0*nfrac*AlFrac/math.sqrt(2*math.pi*AlTemp/AlMass)*math.exp(-AlMass*v^2/(2.0*AlTemp))
         end
	  return fv
      end,
      evolve = true, -- evolve species?
      diagnosticMoments = { "M0", "M1i", "M2" }
   },

   -- field solver
   field = Vlasov.Field {
      epsilon0 = 1.0, mu0 = 1.0,
      init = function (t, xn)
       return 0.0, 0.0, 0.0, 0.0, 0.0, 0.0
      end,
      evolve = true, -- evolve field?
   },
}
-- run application
vlasovApp:run()
