-- Gkyl ------------------------------------------------------------------------
-- Collisional relaxation for a bump-in-tail initial distribution function
-- in 1x1v with a Dougherty collision operator.
--------------------------------------------------------------------------------
local Plasma = require("App.PlasmaOnCartGrid").VlasovMaxwell()

n0  = 1.0       -- Density.
u0  = 0.0       -- Flow speed.
vt0 = 1.0/3.0   -- Thermal speed.
nu  = 0.01      -- Collision frequency.

nb  = n0*0.1    -- Amplitude of bump.
ub  = u0        -- Speed in bump's exponential.
vtb = 1.0       -- Thermal speed of Maxwellian in bump.
sb  = 0.12      -- Softening factor to avoid divergence.
uL  = 4*math.sqrt(((3*vt0/2)^2)/3)   -- Location of bump.

-- Maxwellian with a Maxwellian bump in the tail.
local function bumpMaxwell(x,vx,n,u,vth,bN,bU,bVth,bL,bS)
   local vSq  = ((vx-u)/(math.sqrt(2.0)*vth))^2
   local vbSq = ((vx-bU)/(math.sqrt(2.0)*bVth))^2
   return (n/math.sqrt(2.0*math.pi*vth))*math.exp(-vSq)
         +(bN/math.sqrt(2.0*math.pi*bVth))*math.exp(-vbSq)/((vx-bL)^2+bS^2)
end

plasmaApp = Plasma.App {
   tEnd         = 80,      -- End time.
   nFrame       = 80,      -- Number of frames to write.
   lower        = {0.0},   -- Configuration space lower coordinate.
   upper        = {1.0},   -- Configuration space upper coordinate.
   cells        = {8},     -- Configuration space cells.
   polyOrder    = 2,       -- Polynomial order.
   periodicDirs = {1},     -- Periodic directions.
   -- Neutral species with a bump in the tail.
   bump = Plasma.Species {
      charge = 0.0, mass = 1.0,
      -- Velocity space grid.
      lower = {-8.0*vt0}, upper = { 8.0*vt0},
      cells = {32},
      -- Initial conditions.
      init = function (t, xn)
	 local x, v = xn[1], xn[2]
         return bumpMaxwell(x,v,n0,u0,vt0,nb,ub,vtb,uL,sb)
      end,
      evolve = true,                 -- Evolve species?
      evolveCollisionless = false,   -- Evolve collisionless terms?
      diagnosticIntegratedMoments = { "intM2Flow", "intM2Thermal" },
      -- Collisions.
      coll = Plasma.LBOCollisions {
         collideWith = {'bump'},
         frequencies = {nu},
      },
   },
}
-- Run application.
plasmaApp:run()
