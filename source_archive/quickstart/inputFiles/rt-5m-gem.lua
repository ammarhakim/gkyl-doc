--------------------------------------------------------------------------------
-- App dependencies
--------------------------------------------------------------------------------
-- Load the App and equations to be used
local Moments = require("App.PlasmaOnCartGrid").Moments()
local Euler = require "Eq.Euler"


--------------------------------------------------------------------------------
-- Preamble
--------------------------------------------------------------------------------
-- Basic constants
local gasGamma = 5./3.  -- gas gamma
local elcCharge = -1.0  -- electron charge
local ionCharge = 1.0   -- ion charge
local elcMass = 1.0     -- electron mass 
local lightSpeed = 1.0  -- light speed
local mu0 = 1.0         -- mu_0

-- Problem-specific characteristic parameters
local n0 = 1.0                 -- characteristic density variation
local nb_n0 = 0.2              -- background density vs. varation density
local plasmaBeta0 = 1.0        -- thermal pressure vs. magnetic pressure
local lambda_di0 = 0.5         -- transition layer thickness over ion inertial length
local Ti0_Te0 = 5.0            -- ion temperature vs. electron temperature
local massRatio = 25.0         -- ion mass vs. electron mass
local vAe0_lightSpeed = 0.5    -- electron Alfven speed vs. c
local perturbationLevel = 0.1  -- relative perturbation magnitude

-- Derived parameters for problem setup or for diagnostic information
local epsilon0 = 1.0 / lightSpeed^2 / mu0          -- epsilon_0
local ionMass = elcMass * massRatio                -- ion mass
local vAe0 = lightSpeed * vAe0_lightSpeed          -- electron Alfven speed
local vAlf0 = vAe0 * math.sqrt(elcMass / ionMass)  -- plasma Alfven speed
local B0 = vAlf0 * math.sqrt(n0 * ionMass)         -- background B field
local OmegaCi0 = ionCharge * B0 / ionMass          -- ion cyclotron frequency
local OmegaPe0 = math.sqrt(n0 * elcCharge^2 / (epsilon0 * elcMass))
                                                   -- electron plasma frequency
local de0 = lightSpeed / OmegaPe0                  -- electron inertial length
local OmegaPi0 = math.sqrt(n0 * ionCharge^2 / (epsilon0 * ionMass))
                                                   -- ion plasma frequency
local di0 = lightSpeed / OmegaPi0                  -- ion inertial length
local lambda = lambda_di0 * di0                    -- transition layer thickness
local psi0 = perturbationLevel * B0                -- potential of perturbation B field

-- Domain and time control
local Lx, Ly = 25.6 * di0, 12.8 * di0  -- domain lengths
local Nx, Ny = 128, 64                 -- grid size
local tEnd = 25.0 / OmegaCi0           -- end of simulation
local nFrame = 5                       -- number of output frames at t=tEnd


--------------------------------------------------------------------------------
-- App construction
--------------------------------------------------------------------------------
local momentApp = Moments.App {
   -----------------------------------------------------------------------------
   -- Common
   -----------------------------------------------------------------------------
   logToFile = true,            -- will log to rt-5m-gem_0.log
   tEnd = tEnd,                 -- stop the simulation at t=tEnd
   nFrame = nFrame,             -- number of output frames at t=tEnd
   lower = {-Lx/2, -Ly/2},      -- lower limit of domain in each direction
   upper = {Lx/2, Ly/2},        -- upper limit of domain in each direction
   cells = {Nx, Ny},            -- number of cells in each direction
   timeStepper = "fvDimSplit",  -- always use fvDimSplit for fluid simulations,
                                -- i.e., finite-volume dimensional-splitting
   periodicDirs = {1},          -- periodic boundary condition directions

   -----------------------------------------------------------------------------
   -- Species
   -----------------------------------------------------------------------------
   -- electrons
   elc = Moments.Species {
      charge = elcCharge, mass = elcMass,  -- charge and mass
      equation = Euler { gasGamma = gasGamma },
                                           -- default equation to be evolved
                                           -- using 2nd-order scheme
      equationInv = Euler { gasGamma = gasGamma, numericalFlux = "lax" },
                                           -- backup equation to be solved to
                                           -- retake the time step in case of 
                                           -- negative density/pressure
      init = function (t, xn)              -- initial condition to set the
                                           -- moments of this species
         local x, y = xn[1], xn[2]

         local TeFrac = 1.0 / (1.0 + Ti0_Te0)
         local sech2 = (1.0 / math.cosh(y / lambda))^2
         local n = n0 * (sech2 + nb_n0)
         local Jz = -(B0 / lambda) * sech2
         local Ttotal = plasmaBeta0 * (B0 * B0) / 2.0 /n0

         local rho_e = n * elcMass
         local rhovx_e = 0.0
         local rhovy_e = 0.0
         local rhovz_e = (elcMass / elcCharge) * Jz * TeFrac
         local thermalEnergy_e = n * Ttotal * TeFrac / (gasGamma-1.0)
         local kineticEnergy_e = 0.5 * rhovz_e * rhovz_e / rho_e
         local e_e = thermalEnergy_e + kineticEnergy_e

         return rho_e, rhovx_e, rhovy_e, rhovz_e, e_e
      end,
      evolve = true,                         -- whether to evolve this species
                                             -- in the hyperbolic step; it could
                                             -- still be evolved in the source
                                             -- update step, though
      bcy = { Euler.bcWall, Euler.bcWall },  -- boundary conditions along
                                             -- non-periodic directions; in this
                                             -- case, the y direction
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
         local n = n0 * (sech2 + nb_n0)
         local Jz = -(B0 / lambda) * sech2
         local Ttotal = plasmaBeta0 * (B0 * B0)/ 2.0 / n0

         local rho_i = n*ionMass
         local rhovx_i = 0.0
         local rhovy_i = 0.0
         local rhovz_i = (ionMass / ionCharge) * Jz * TiFrac
         local thermalEnergy_i = n * Ttotal * TiFrac / (gasGamma - 1)
         local kineticEnergy_i = 0.5 * rhovz_i * rhovz_i / rho_i
         local e_i = thermalEnergy_i + kineticEnergy_i

         return rho_i, rhovx_i, rhovy_i, rhovz_i, e_i
      end,
      evolve = true,
      bcy = { Euler.bcWall, Euler.bcWall },
   },

   -----------------------------------------------------------------------------
   -- Electromagnetic field
   -----------------------------------------------------------------------------
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
      evolve = true, -- whether to evolve the field in the hyperbolic step; even
                     -- if this is set to false, the E field could still be
                     -- evolved in the source update step
      bcy = { Moments.Field.bcReflect, Moments.Field.bcReflect },
                     -- boundary conditions along the nonperiodic directions,
                     -- in this case, the y direction.
   },

   -----------------------------------------------------------------------------
   -- Source equations that couple the plasma fluids and EM fields
   -----------------------------------------------------------------------------
   emSource = Moments.CollisionlessEmSource {
      species = {"elc", "ion"},  -- plasma species involved
      timeStepper = "direct",    -- time-stepper; one of "time-centered",
                                 -- "direct", and "exact"
   },

}


--------------------------------------------------------------------------------
-- Run the App
--------------------------------------------------------------------------------
momentApp:run()
