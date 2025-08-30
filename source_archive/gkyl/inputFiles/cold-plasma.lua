local Species = require "Tool.LinearSpecies"

-- Electrons
elc = Species.Isothermal {
   mass = 1.0, -- mass
   charge = -1.0, -- charge
   density = 1.0, -- number density
   velocity = {0.0, 0.0, 0.0}, -- velocity vector
   temperature = 0.0, -- temperature
}

-- Ions
ion = Species.Isothermal {
   mass = 25.0, -- mass
   charge = 1.0, -- charge
   density = 1.0, -- number density
   velocity = {0.0, 0.0, 0.0}, -- velocity vector
   temperature = 0.0, -- temperature
}

-- EM field
field = Species.Maxwell {
   epsilon0 = 1.0, mu0 = 1.0,

   electricField = {0.0, 0.0, 0.0}, -- background electric field
   magneticField = {1.0, 0.0, 0.75}, -- background magnetic field
}

-- list of species to include in dispersion relation
speciesList = { elc, ion }

-- List of wave-vectors for which to compute dispersion relation
kvectors = {}

local kcurr, kmax, NK = 0.0, 4.0, 401
dk = (kmax-kcurr)/(NK-1)
for i = 1, NK do
   kvectors[i] = {kcurr, 0.0, 0.0} -- each k-vector is 3D
   kcurr = kcurr + dk
end
