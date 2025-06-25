-- Gkyl --------------------------------------------------------------
-- Basic SOL simulation ----------------------------------------------
----------------------------------------------------------------------

local Plasma = require("App.PlasmaOnCartGrid").Gyrokinetic()
local Constants = require "Lib.Constants"

function sech(x)
   return 2*math.exp(x)/(math.exp(2*x)+1)
end

-- Universal parameters
eps0 = Constants.EPSILON0
eV = Constants.ELEMENTARY_CHARGE
qe = -eV
qi =  eV
mi = Constants.PROTON_MASS   -- Hydrogen ions
me= mi/400                   -- Reduced ion/elc mass ratio
B0 = 0.5                     -- Magnetic field amplitude [T]
n0 = 5e18                    -- Number density [1/m^3]
Te0 = 75*eV                  -- Electron temperature
Ti0 = 75*eV                  -- Ion temperature

-- Derived physical parameters
-- set kmin*rho_s = 0.2, used for Field table
cs = math.sqrt(Te0/mi)
omega_ci = eV*B0/mi
rho_s = cs/omega_ci
kmin = 0.2/rho_s

-- Thermal speeds
vti = math.sqrt(Ti0/mi)
vte = math.sqrt(Te0/me)

-- Connection length
Lx = 80 --[m]

-- Source parameters
Ls = 25         -- [m] Source width
S0 = 5e22       -- [m^-3 s^-1] Particle source rate 

-- Source profiles
sourceDensity = function (t,xn)
   local x = xn[1]
   local flr = 0.001
   if math.abs(x) < Ls/2 then
      return S0*(math.cos(math.pi*x/Ls)+flr)
   else
    return S0*flr
   end
end
sourceTemperatureElc = function (t,xn)
   local x = xn[1]
   return 7.5*Te0
end
sourceTemperatureIon = function (t,xn)
   local x = xn[1]
   return 7.5*Te0
end
sourceDensityNeut = function (t,xn)
   local x = xn[1]
   local x0 = 1
   local S0n = 1e23
   if x <= 0 then
      return S0n*(sech((-Lx/2-x)/x0)^2)
   else       
      return S0n*(sech((Lx/2-x)/x0)^2)
   end
end

plasmaApp = Plasma.App {
   logToFile = true,

   tEnd = 0.1*Lx/cs,         -- End time, in terms of ion transit time Lx/cs
   nFrame = 10,              -- Number of output frames
   lower = {-Lx/2},          -- Configuration space lower left
   upper = {Lx/2},           -- Configuration space upper right
   cells = {64},             -- Configuration space cells
   basis = "serendipity",    -- One of "serendipity" or "maximal-order"
   polyOrder   = 1,          -- Polynomial order
   cflFrac     = 1,          -- CFL "fraction". Usually 1.0
   timeStepper = "rk3",      -- One of "rk2" or "rk3"

   -- Decomposition for configuration space
   decompCuts = {4},   -- Cuts in each configuration direction
   useShared = false,  -- If to use shared memory

   -- Boundary conditions for configuration space
   periodicDirs = {},  -- Periodic directions
      
   -- Gyrokinetic electrons
   elc = Plasma.Species {
      evolve = true,
      charge = qe, mass = me,

      -- Species-specific velocity domain
      lower = {-4.0*vte, 0},
      upper = {4.0*vte, 12*me*vte^2/(2*B0)},
      cells = {16, 8},

      -- Initial conditions
      init = Plasma.MaxwellianProjection{
         density = function (t, xn)
	    local x, vpar = xn[1], xn[2]
	    local L0 = Lx/4
	    local c_ss = math.sqrt(5/3*Te0/mi)
	    local nPeak = 1.5*n0
	    local perturb = 0 
	    if math.abs(x) <= L0 then
	       return nPeak*(1+math.sqrt(1-(x/L0)^2))/2*(1+perturb)
	    else
	       return nPeak/2*(1+perturb)
	    end
	 end,
         temperature = function (t, xn)
            local x, vpar = xn[1], xn[2]
            return Te0
         end,
      },

      -- Source parameters
      source = Plasma.Source {
	 density = sourceDensity,
	 temperature = sourceTemperatureElc,
      },  

      -- Collisions
      coll = Plasma.LBOCollisions {
         collideWith = {'elc', 'ion'},
         nuFrac = 0.1,
      },

      -- Neutral interactions
      ionization = Plasma.Ionization {
      	 collideWith = {"neut"},
      	 electrons = "elc",
      	 neutrals = "neut",
      	 elemCharge = eV, 
      	 elcMass = me,
      	 plasma = "H",         
      },

      -- Boundary conditions
      bcx = {Plasma.Species.bcSheath, Plasma.Species.bcSheath},

      -- Diagnostics
      diagnostics = {"M0", "M1", "M2", "Upar", "VtSq", "intM0", "intM1", "intM2"},
   },

   -- Gyrokinetic ions
   ion = Plasma.Species {
      evolve = true,
      charge = qi, mass = mi,

      -- Species-specific velocity domain
      lower = {-4.0*vti, 0},
      upper = {4.0*vti, 12*mi*vti^2/(2*B0)},
      cells = {16, 8},
      decompCuts = {1},
      
      -- Initial conditions
      init = Plasma.MaxwellianProjection {
         density = function (t, xn)
	    local x, vpar = xn[1], xn[2]
	    local L0 = Lx/4
	    local c_ss = math.sqrt(5/3*Te0/mi)
	    local nPeak = 1.5*n0
	    local perturb = 0 
	    if math.abs(x) <= L0 then
	       return nPeak*(1+math.sqrt(1-(x/L0)^2))/2*(1+perturb)
	    else
	       return nPeak/2*(1+perturb)
	    end
	 end,
         temperature = function (t, xn)
            local x, vpar = xn[1], xn[2]
            return Ti0
         end,
      },

      -- Source Parameters
      source = Plasma.Source {
	 density = sourceDensity,
	 temperature = sourceTemperatureIon,
      },   

      -- Collisions
      coll = Plasma.LBOCollisions {
         collideWith = {'ion','elc'},
         nuFrac = 0.1,
      },

      -- Neutral interactions
      ionization = Plasma.Ionization {
      	 collideWith = {"neut"},
      	 electrons = "elc",
      	 neutrals = "neut",
      	 elemCharge = eV,
      	 elcMass = me,
      	 plasma = "H",
      },
      chargeExchange = Plasma.ChargeExchange {
      	 collideWith = {"neut"},
      	 ions = "ion",
      	 neutrals = "neut",
      	 ionMass = mi,
      	 neutMass = mi,
      	 plasma = "H",
	 charge = qi,
      },

      -- Boundary conditions
      bcx = {Plasma.Species.bcSheath, Plasma.Species.bcSheath},

      -- Diagnostics
      diagnostics = {"M0", "M1", "M2", "Upar", "VtSq", "intM0", "intM1", "intM2"},

   },

   -- Vlasov neutrals
   neut = Plasma.Vlasov {
      evolve = true,
      charge = 0.0, mass = mi,
      
      -- Species-specific velocity domain
      lower = {-4.0*vti, -4.0*vti, -4.0*vti},
      upper = {4.0*vti, 4.0*vti, 4.0*vti},
      cells = {8, 8, 8},
      decompCuts = {1},

      -- Initial conditions
      init = Plasma.VmMaxwellianProjection {
         density = function (t, xn)
            local x = xn[1]
            local n_n = n0
	    local x0 = 1.0
	    local flr = 0.01
	    if x <= 0 then
	       return n_n*(sech((-Lx/2-x)/x0)^2 + flr)
	    else	       
	       return n_n*(sech((Lx/2-x)/x0)^2 + flr)
	    end
         end,
         driftSpeed = function (t, xn)
	    return {0,0,0}
         end,
         temperature = function (t, xn)
            return 5*eV
         end,
      },

      -- Source parameters
      source = Plasma.VmSource {
	 density = sourceDensityNeut,
	 driftSpeed = function (t, xn)
            return {0,0,0}
         end,
	 temperature = function (t, xn)
	    return 5*eV
	 end,
      },      

      -- Neutral interactions
      ionization = Plasma.Ionization {
      	 collideWith  = {"elc"},
      	 electrons = "elc",
      	 neutrals = "neut",
      	 elemCharge = eV, 
      	 elcMass = me,
      	 plasma = "H",         
      },
      chargeExchange = Plasma.ChargeExchange {
      	 collideWith = {"ion"},
      	 ions = "ion",
      	 neutrals = "neut",
      	 ionMass = mi,
      	 neutMass = mi,
      	 plasma = "H",
	 charge = 0,
      },

      -- Boundary conditions
      bcx = {Plasma.Vlasov.bcReflect, Plasma.Vlasov.bcReflect},

      -- Diagnostics
      diagnostics = {"M0", "Udrift", "vtSq", "intM0", "intM1i", "intM2Flow", "intM2Thermal"},
 
   },
   
   -- Field solver
   field = Plasma.Field {
      phiBcLeft = { T ="N", V = 0.0},
      phiBcRight = { T ="N", V = 0.0},
      evolve = true,
      kperp2 = kmin*kmin,
   },

      -- Magnetic geometry
   funcField = Plasma.Geometry {
      -- background magnetic field
      bmag = function (t, xn)
         local x = xn[1]
         return B0
      end,
      -- geometry is not time-dependent
      evolve = false,
   },
}
-- Run application.
plasmaApp:run()
