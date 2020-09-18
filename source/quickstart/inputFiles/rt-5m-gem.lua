local Moments = require("App.PlasmaOnCartGrid").Moments()
local Euler = require "Eq.Euler"

-- basic constants
local gasGamma = 5./3.
local elcCharge = -1.0
local ionCharge = 1.0
local elcMass = 1.0
local lightSpeed = 1.0
local mu0 = 1.0

-- problem-specific characteristic parameters
local massRatio = 25.0
local n0 = 1.0
local vAe0 = 0.5
local plasmaBeta0 = 1.0
local lambda_Di0 = 0.5
local Ti0_Te0 = 5.0
local nb0_N0 = 0.2
local perturbationLevel = 0.1

-- derived parameters
local epsilon0 = 1.0 / lightSpeed^2 / mu0
local ionMass = elcMass * massRatio
local vAlf0 = vAe0 * math.sqrt(elcMass / ionMass)
local B0 = vAlf0 * math.sqrt(n0 * ionMass)
local OmegaCi0 = ionCharge * B0 / ionMass
local psi0 = perturbationLevel * B0

local OmegaPe0 = math.sqrt(n0 * elcCharge^2 / (epsilon0 * elcMass))
local de0 = lightSpeed / OmegaPe0
local OmegaPi0 = math.sqrt(n0 * ionCharge^2 / (epsilon0 * ionMass))
local di0 = lightSpeed / OmegaPi0
local lambda = lambda_Di0 * di0

-- domain and time
local Lx, Ly = 25.6 * di0, 12.8 * di0
local Nx, Ny = 128, 64
local tEnd = 25.0 / OmegaCi0
local nFrame = 5

local momentApp = Moments.App {
   logToFile = true,

   tEnd = tEnd,
   nFrame = nFrame,
   lower = {-Lx/2, -Ly/2},
   upper = {Lx/2, Ly/2},
   cells = {Nx, Ny},
   periodicDirs = {1}, -- periodic directions
   timeStepper = "fvDimSplit",

   -- electrons
   elc = Moments.Species {
      charge = elcCharge, mass = elcMass,
      equation = Euler { gasGamma = gasGamma },
      equationInv = Euler { gasGamma = gasGamma, numericalFlux = "lax" },
      init = function (t, xn)
         local x, y = xn[1], xn[2]

         local TeFrac = 1.0 / (1.0 + Ti0_Te0)
         local sech2 = (1.0 / math.cosh(y / lambda))^2
         local n = n0 * (sech2 + nb0_N0)
         local Jz = -(B0 / lambda) * sech2
         local Ttotal = plasmaBeta0 * (B0 * B0) / 2.0 /n0

         local rho_e = n * elcMass
         local rhovz_e = (elcMass / elcCharge) * Jz * TeFrac
         local thermalEnergy_e = n * Ttotal * TeFrac / (gasGamma-1.0)
         local kineticEnergy_e = 0.5 * rhovz_e * rhovz_e / rho_e
         local e_e = thermalEnergy_e + kineticEnergy_e

         return rho_e, 0.0, 0.0, rhovz_e, e_e
      end,
      evolve = true,
      bcy = { Euler.bcWall, Euler.bcWall },
   },

   -- ions
   ion = Moments.Species {
      charge = ionCharge, mass = ionMass,
      equation = Euler { gasGamma = gasGamma },
      equationInv = Euler { gasGamma = gasGamma, numericalFlux = "lax" },
      init = function (t, xn)
         local x, y = xn[1], xn[2]

         local TiFrac = Ti0_Te0 / (1.0 + Ti0_Te0)
         local sech2 = (1.0 / math.cosh(y / lambda))^2
         local n = n0 * (sech2 + nb0_N0)
         local Jz = -(B0 / lambda) * sech2
         local Ttotal = plasmaBeta0 * (B0 * B0)/ 2.0 / n0

         local rho_i = n*ionMass
         local rhovz_i = (ionMass / ionCharge) * Jz * TiFrac
         local thermalEnergy_i = n * Ttotal * TiFrac / (gasGamma - 1)
         local kineticEnergy_i = 0.5 * rhovz_i * rhovz_i / rho_i
         local e_i = thermalEnergy_i + kineticEnergy_i

         return rho_i, 0.0, 0.0, rhovz_i, e_i
      end,
      evolve = true,
      bcy = { Euler.bcWall, Euler.bcWall },
   },

   field = Moments.Field {
      epsilon0 = epsilon0, mu0 = mu0,
      init = function (t, xn)
         local x, y = xn[1], xn[2]
         local pi = math.pi
         local sin = math.sin
         local cos = math.cos

         local Ex, Ey, Ez = 0.0, 0.0, 0.0

         local Bx = B0 * math.tanh(y / lambda)
         local By = 0.0
         local Bz = 0.0

         local dBx = -psi0 *(pi / Ly) * cos(2 * pi * x / Lx) * sin(pi * y / Ly)
         local dBy = psi0 * (2 * pi / Lx) * sin(2 * pi * x / Lx) * cos(pi * y / Ly)
         local dBz = 0.0

         Bx = Bx + dBx
         By = By + dBy
         Bz = Bz + dBz

         return Ex, Ey, Ez, Bx, By, Bz
      end,
      evolve = true, -- evolve field?
      bcy = { Moments.Field.bcReflect, Moments.Field.bcReflect },
   },

   emSource = Moments.CollisionlessEmSource {
      species = {"elc", "ion"},
      timeStepper = "direct",
   },

}

momentApp:run()
