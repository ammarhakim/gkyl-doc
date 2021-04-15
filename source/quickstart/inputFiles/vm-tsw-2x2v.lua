-- Gkyl ------------------------------------------------------------------------
-- 2x2v simulation of instabilities driven by counter-streaming beams of plasma.
-- Ions are stationary, neutralizing background.
-- First 16 wave modes are perturbed and allowed to evolve;
-- many of the modes have comparable growth rates, e.g., two-stream and oblique.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- App dependencies
--------------------------------------------------------------------------------
-- Load the Vlasov-Maxwell App
local Plasma = require("App.PlasmaOnCartGrid").VlasovMaxwell()
-- Pseudo-random number generator from SciLua package for initial conditions.
-- Specific rng is the mrg32k3a (multiple recursive generator) of Ecuyer99.
local prng = require "sci.prng"
local rng = prng.mrg32k3a()
--------------------------------------------------------------------------------
-- Preamble
--------------------------------------------------------------------------------
-- Constants
permitt = 1.0                               -- Permittivity of free space
permeab = 1.0                               -- Permeability of free space
lightSpeed = 1.0/math.sqrt(permitt*permeab) -- Speed of light
chargeElc = -1.0                            -- Electron charge
massElc = 1.0                               -- Electron mass

-- Initial conditions
-- 1 = Right-going beam; 2 = Left-going beam.
nElc1 = 0.5
nElc2 = 0.5

ud = 0.1                                    -- Drift velocity of beams
uxElc1 = 0.0
uyElc1 = ud
uxElc2 = 0.0
uyElc2 = -ud

R = 0.1                                     -- Ratio of thermal velocity to drift velocity
TElc1 = massElc*(R*ud)^2
TElc2 = massElc*(R*ud)^2
vthElc1 = math.sqrt(TElc1/massElc)
vthElc2 = math.sqrt(TElc2/massElc)

k0_TS = 6.135907273413176                   -- Wavenumber of fastest growing two-stream mode 
theta = 90.0/180.0*math.pi                  -- 0 deg is pure Weibel, 90 deg is pure two-stream
kx_TS = k0_TS*math.cos(theta)
ky_TS = k0_TS*math.sin(theta)

k0_Weibel = 2.31012970008316                -- Wavenumber of fastest growing Weibel mode 
theta = 0.0/180.0*math.pi                   -- 0 deg is pure Weibel, 90 deg is pure two-stream
kx_Weibel = k0_Weibel*math.cos(theta)
ky_Weibel = k0_Weibel*math.sin(theta)
kx = k0_Weibel
ky = k0_TS/3.0	

perturb_n = 1e-8
-- Perturbing the first 16 wave modes with random amplitudes and phases.
-- Note that loop goes from -N to N to sweep all possible phases.
N=16
P={}
for i=-N,N,1 do
   P[i]={}
   for j=-N,N,1 do
      P[i][j]={}
      for k=1,6,1 do         
         P[i][j][k]=rng:sample()
      end
   end
end

-- Domain size and number of cells
Lx = 2*math.pi/kx
Ly = 2*math.pi/ky
Nx = 16
Ny = 16
vLimElc = 3*ud                              -- Maximum velocity in velocity space
NvElc = 16

-- Maxwellian in 2x2v
local function maxwellian2D(n, vx, vy, ux, uy, vth)
   local v2 = (vx - ux)^2 + (vy - uy)^2
   return n/(2*math.pi*vth^2)*math.exp(-v2/(2*vth^2))
end

plasmaApp = Plasma.App {
   --------------------------------------------------------------------------------
   -- Common
   --------------------------------------------------------------------------------
   logToFile = true,

   tEnd = 50.0,                             -- End time
   nFrame = 1,                              -- Number of output frames
   lower = {0.0,0.0},                       -- Lower boundary of configuration space
   upper = {Lx,Ly},                         -- Upper boundary of configuration space
   cells = {Nx,Ny},                         -- Configuration space cells
   basis = "serendipity",                   -- One of "serendipity", "maximal-order", or "tensor"
   polyOrder = 2,                           -- Polynomial order
   timeStepper = "rk3s4",                   -- One of "rk2", "rk3", or "rk3s4"

   -- MPI decomposition for configuration space
   decompCuts = {1,1},                      -- Cuts in each configuration direction
   useShared = true,                        -- If using shared memory

   -- Boundary conditions for configuration space
   periodicDirs = {1,2},                    -- periodic directions (both x and y)

   -- Integrated moment flag, compute integrated quantities 1000 times in simulation
   calcIntQuantEvery = 0.001,
   --------------------------------------------------------------------------------
   -- Electrons
   --------------------------------------------------------------------------------
   elc = Plasma.Species {
      charge = chargeElc, mass = massElc,
      -- Velocity space grid
      lower = {-vLimElc, -vLimElc},
      upper = {vLimElc, vLimElc},
      cells = {NvElc, NvElc},
      -- Initial conditions
      init = function (t, xn)
         local x, y, vx, vy = xn[1], xn[2], xn[3], xn[4]
         local fv = maxwellian2D(nElc1, vx, vy, uxElc1, uyElc1, vthElc1) +
            maxwellian2D(nElc2, vx, vy, uxElc2, uyElc2, vthElc2)
         return fv
      end,
      evolve = true,
      diagnosticMoments = {"M0","M1i","M2ij","M3i"},
      diagnosticIntegratedMoments = {"intM0","intM1i","intM2Flow","intM2Thermal"},
   },
   --------------------------------------------------------------------------------
   -- Field solver
   --------------------------------------------------------------------------------
   field = Plasma.Field {
      epsilon0 = permitt, mu0 = permeab,
      init = function (t, xn)
         local x, y = xn[1], xn[2]
         local E_x, E_y, B_z = 0.0, 0.0, 0.0
         for i=-N,N,1 do
            for j=-N,N,1 do
               if i~=0 or j~=0 then          
                  E_x = E_x + perturb_n*P[i][j][1]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][2])
                  E_y = E_y + perturb_n*P[i][j][3]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][4])
                  B_z = B_z + perturb_n*P[i][j][5]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][6])
               end
            end
         end
         return E_x, E_y, 0.0, 0.0, 0.0, B_z
      end,
      evolve = true,
   },
}
--------------------------------------------------------------------------------
-- Run application
--------------------------------------------------------------------------------
plasmaApp:run()
