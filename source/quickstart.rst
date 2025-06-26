.. _quickstart:

.. title:: Gkeyll Quickstart Guide

:math:`\texttt{Gkeyll}` Quickstart Guide
========================================

.. _quickstart_moments:

A Simple :math:`\texttt{moments}` Simulation
--------------------------------------------

As our first example of a simple simulation using the :math:`\texttt{moments}` app, we
shall simulate the GEM (Geospace Environment Modeling) magnetic reconnection problem 
using the 5-moment multi-fluid equations, whose Lua input file can be found in
``moments/luareg/rt_5m_gem.lua``. In the 5-moment, multi-fluid model, an arbitrary number
of fluid species (indexed by :math:`s`) are evolved via the Euler equations, assuming an
ideal fluid model with an isotropic (scalar) pressure. These consist of evolution
equations for the species number density :math:`n_s`:

.. math::
  \frac{\partial n_s}{\partial t} + \nabla \cdot \left( n_s \mathbf{u}_s \right) = 0,

the species velocity :math:`\mathbf{u}_s`:

.. math::
  m_s n_s \left( \frac{\partial \mathbf{u}_s}{\partial t} + \mathbf{u}_s \cdot \nabla
  \mathbf{u}_s \right) = - \nabla p_s + q_s n_s \left( \mathbf{E} + \mathbf{u}_s \times
  \mathbf{B} \right),

and the species pressure :math:`p_s`:

.. math::
  \frac{\partial p_s}{\partial t} + \mathbf{u}_s \cdot \nabla p_s = - \gamma_s p_s
  \nabla \cdot \mathbf{u}_s,

where :math:`m_s` is the mass of each particle in the species, :math:`q_s` is the charge
of each particle in the species, and :math:`\gamma_s` is the adiabatic index of the fluid
species, assuming an ideal gas equation of state. The fluid species are coupled together
through their interactions with a shared electromagnetic field, evolved via Maxwell's
equations, consisting of curl and divergence equations for the electric field
:math:`\mathbf{E}`:

.. math::
  \nabla \times \mathbf{E} = - \frac{\partial \mathbf{B}}{\partial t}, \qquad \nabla
  \cdot \mathbf{E} = \frac{\rho_c}{\epsilon_0},

and the magnetic field :math:`\mathbf{B}`:

.. math::
  \nabla \times \mathbf{B} = \mu_0 \mathbf{J} + \frac{1}{c^2} \left(
  \frac{\partial \mathbf{E}}{\partial t} \right), \qquad \nabla \cdot \mathbf{B} = 0,

where :math:`\epsilon_0` and :math:`\mu_0` are the permittivity and permeability of free
space, respectively, :math:`c` is the speed of light:

.. math::
  c = \frac{1}{\sqrt{ \epsilon_0 \mu_0}},

and :math:`\rho_c` and :math:`\mathbf{J}` are the charge density and current density,
respectively:

.. math::
  \rho_c = \sum_s q_s n_s, \qquad \mathbf{J} = \sum_s q_s n_s \mathbf{u}_s.

For the GEM reconnection problem, we will simulate two fluid species (namely an electron
species, indexed by :math:`s = e`, and an ion species, indexed by :math:`s = i`),
coupled via an electromagnetic field. Looking inside the ``moments/luareg/rt_5m_gem.lua``
Lua input file, we see that it begins (after introductory comments) with:

.. code-block:: lua

  ...
  local Moments = G0.Moments
  local Euler = G0.Moments.Eq.Euler
  ...

which loads in the :math:`\texttt{moments}` app (i.e. ``G0.Moments``), so that
:math:`\texttt{Gkeyll}` knows which app we are intending to run, as well as the Euler
equations object (i.e. ``G0.Moments.Eq.Euler``) for the 5-moment model, since the
:math:`\texttt{moments}` app has support for many other equation systems besides
Euler/5-moments. The next part of the input file defines any necessary dimensionless or
mathematical constants:

.. code-block:: lua

  ...
  -- Mathematical constants (dimensionless).
  pi = math.pi
  ...

which in our case defines a value for :math:`\pi` (i.e. ``math.pi``). Next, we define any
necessary dimensional or physical constants:

.. code-block:: lua

  ...
  -- Physical constants (using normalized code units).
  gas_gamma = 5.0 / 3.0 -- Adiabatic index.
  epsilon0 = 1.0 -- Permittivity of free space.
  mu0 = 1.0 -- Permeability of free space.
  mass_ion = 1.0 -- Ion mass.
  charge_ion = 1.0 -- Ion charge.
  mass_elc = 1.0 / 25.0 -- Electron mass.
  charge_elc = -1.0 -- Electron charge.
  ...

which defines the adiabatic index for both species
:math:`\gamma_e = \gamma_i = \frac{5}{3}`, the permittivity and permeability of free
space :math:`\epsilon_0 = \mu_0 = 1`, the mass and charge of the ion species
:math:`m_i = 1`, :math:`q_i = 1`, and the mass and charge of the electron species
:math:`m_e = \frac{1}{25}`, :math:`q_i = -1`. Several other physical constants are also
defined, to facilitate the process of initialization:

.. code-block:: lua

  ...
  Ti_over_Te = 5.0 -- Ion temperature / electron temperature.
  lambda = 0.5 -- Wavelength.
  n0 = 1.0 -- Reference number density.
  nb_over_n0 = 0.2 -- Background number density / reference number density.
  B0 = 0.1 -- Reference magnetic field strength.
  beta = 1.0 -- Plasma beta.
  ...

which defines the ratio of ion to electron temperature :math:`\frac{T_i}{T_e} = 5`,
the plasma wavelength :math:`\lambda = \frac{1}{2}`, the reference number density
:math:`n_0 = 1`, the ratio of background to reference number density
:math:`\frac{n_b}{n_0} = \frac{1}{5}`, the reference magnetic field strength
:math:`B_0 = \frac{1}{10}`, and the plasma beta :math:`\beta = 1`. Next we define any
*derived* physical quantities (i.e. quantities derived from the physical constants
defined above):

.. code-block:: lua

  ...
  -- Derived physical quantities (using normalized code units).
  psi0 = 0.1 * B0 -- Reference magnetic scalar potential.

  Ti_frac = Ti_over_Te / (1.0 + Ti_over_Te) -- Fraction of total temperature from ions.
  Te_frac = 1.0 / (1.0 + Ti_over_Te) -- Fraction of total temperature from electrons.
  T_tot = beta * (B0 * B0) / 2.0 / n0 -- Total temperature.
  ...

which defines the reference magnetic scalar potential :math:`\psi_0 = \frac{B_0}{10}`,
the fractions of the total plasma temperature contributed by the ions and electrons:

.. math::
  T_{i}^{frac} = \frac{\left( \frac{T_i}{T_e} \right)}{1 + \left( \frac{T_i}{T_e}
  \right)}, \qquad T_{e}^{frac} = \frac{1}{1 + \left( \frac{T_i}{T_e} \right)},

respectively, and the total plasma temperature
:math:`T^{tot} = \beta \left( \frac{B_{0}^{2}}{2 n_0} \right)`. Next, we define some
overall parameters for the simulation:

.. code-block:: lua

  ...
  --  Simulation parameters.
  Nx = 128 -- Cell count (x-direction).
  Ny = 64 -- Cell count (y-direction).
  Lx = 25.6 -- Cell count (x-direction).
  Ly = 12.8 -- Cell count (y-direction).
  cfl_frac = 1.0 -- CFL coefficient.
  ...

which defines a simulation domain consisting of :math:`128 \times 64 = 8192` total cells,
of size :math:`25.6 \times 12.8` (resulting in a uniform cell size of
:math:`\Delta x = \Delta y = 0.2`), and a CFL coefficient of
:math:`C_{CFL} = \frac{a \Delta t}{\Delta x} = 1` (corresponding to taking the largest
stable time-step :math:`\Delta t` permitted by the CFL stability criterion, where
:math:`a` is the largest absolute wave-speed in the simulation domain). Finally, we
complete this preambulatory section with the remaining simulation parameters:

.. code-block:: lua

  ...
  t_end = 250.0 -- Final simulation time.
  num_frames = 1 -- Number of output frames.
  field_energy_calcs = GKYL_MAX_INT -- Number of times to calculate field energy.
  integrated_mom_calcs = GKYL_MAX_INT -- Number of times to calculate integrated moments.
  dt_failure_tol = 1.0e-4 -- Minimum allowable fraction of initial time-step.
  num_failures_max = 20 -- Maximum allowable number of consecutive small time-steps.
  ...

which defines a final simulation time :math:`t_{end} = 250` (the initial simulation time
is always assumed to be :math:`t_{init} = 0`), specifies that a single output frame
should be written out to the file system (i.e. only the final state of the simulation is
written out, without any intermediate frames being stored), specifies that certain
diagnostic variables, namely the field energy and the integrated diagnostic moments,
should be calculated as frequently as possible (i.e. they are calculated every step, and
will be written out along with the output frames), and finally specifies that the
simulation should automatically terminate if more than 20 consecutive steps are taken
where the stable time-step :math:`\Delta t` is calculated to be less than
:math:`10^{-4}` times the initial stable time-step
:math:`\left( \Delta t \right)_{init}` (to prevent time-step crashes).

The next part of the Lua input initializes the :math:`\texttt{moments}` app itself, and
passes in several of the key simulation parameters defined above (i.e. the final
simulation time :math:`t_{end}`, the number of output frames, the frequency of field
energy and integrated diagnostic moments calculations, the small time-step termination
criteria, the lower and upper boundaries of the simulation domain, the number of cells in
each direction, and the CFL coefficient :math:`C_{CFL}`):

.. code-block:: lua

  ...
  momentApp = Moments.App.new {

    tEnd = t_end,
    nFrame = num_frames,
    fieldEnergyCalcs = field_energy_calcs,
    integratedMomentsCalcs = integrated_mom_calcs,
    dtFailureTol = dt_failure_tol,
    numFailuresMax = num_failures_max,
    lower = { -0.5 * Lx, -0.5 * Ly },
    upper = { 0.5 * Lx, 0.5 * Ly },
    cells = { Nx, Ny },
    cflFrac = cfl_frac,

    ...
  }
  ...

thus defining the range of the simulation domain to be
:math:`\left[ -12.8, 12.8 \right] \times \left[ -6.4, 6.4 \right]`. The next field to be
passed into ``Moments.App.new`` represents the decomposition of the simulation domain
into subdomains for the purposes of parallelization (in our case, we are running a serial
simulation, so we only want to partition into a single subdomain in each of the :math:`x`
and :math:`y` coordinate directions):

.. code-block:: lua

  ...
  -- Decomposition for configuration space.
  decompCuts = { 1, 1 }, -- Cuts in each coordinate direction (x- and y-directions).
  ...

The next field specifies which coordinate directions (if any) should have periodic
boundary conditions applied to them; for the GEM reconnection problem, the boundaries in
the :math:`x` coordinate direction are assumed to have periodic boundary conditions and
the boundaries in the :math:`y` coordinate direction are assumed to have reflective (or
*wall*) boundary conditions:

.. code-block:: lua

  ...
  -- Boundary conditions for configuration space.
  periodicDirs = { 1 }, -- Periodic directions (x-direction only).
  ...

where "1" here refers to the first coordinate direction (i.e. :math:`x`). The next items
to be passed into ``Moments.App.new`` are the two fluid species (``elc`` for the electron
species, ``ion`` for the ion species) themselves:

.. code-block:: lua

  ...
  -- Electrons.
  elc = Moments.Species.new {
    charge = charge_elc, mass = mass_elc,
    equation = Euler.new { gasGamma = gas_gamma },
    
    ...

    evolve = true, -- Evolve species?
    bcy = { G0.SpeciesBc.bcWall, G0.SpeciesBc.bcWall } -- Wall boundary conditions (y-direction).
  },

  -- Ions.
  ion = Moments.Species.new {
    charge = charge_ion, mass = mass_ion,
    equation = Euler.new { gasGamma = gas_gamma },

    ...

    evolve = true, -- Evolve species?
    bcy = { G0.SpeciesBc.bcWall, G0.SpeciesBc.bcWall } -- Wall boundary conditions (y-direction).
  },
  ...

where, in both cases, we begin by passing in parameters for the charge and mass of the
species (:math:`q_e` and :math:`m_e` for the electrons, :math:`q_i` and :math:`m_i` for
the ions, respectively), followed by an instantiation of the equation object itself via
``Euler.new`` (passing in the adiabatic index :math:`\gamma_e = \gamma_i` in both
cases), followed by some initialization code which we have omitted, followed finally by
a flag to indicate that both species should be evolved in time (i.e. the fluids are not
static) and that the boundaries in the :math:`y` coordinate direction, on both sides of
the domain, should have reflective/wall boundary conditions applied to them (i.e.
``G0.SpeciesBc.bcWall``). The initial conditions for the electron species are imposed via
the initialization function:

.. code-block:: lua

  ...
  -- Initial conditions function.
  init = function (t, xn)
    local x, y = xn[1], xn[2]

    local sech_sq = (1.0 / math.cosh(y / lambda)) * (1.0 / match.cosh(y / lambda)) -- Hyperbolic secant squared.

    local n = n0 * (sech_sq * nb_over_n0) -- Total number density.
    local Jz = -(B0 / lambda) * sech_sq -- Total current density (z-direction).

    local rhoe = n * mass_elc -- Electron mass density.
    local mome_x = 0.0 -- Electron momentum density (x-direction).
    local mome_y = 0.0 -- Electron momentum density (y-direction).
    local mome_z = (mass_elc / charge_elc) * Jz * Te_frac -- Electron momentum density (z-direction).
    local Ee_tot = n * T_tot * Te_frac / (gas_gamma - 1.0) + 0.5 * mome_z * mome_z / rhoe -- Electron total energy density.

    return rhoe, mome_x, mome_y, mome_z, Ee_tot
  end,
  ...

while the initial conditions for the ion species are imposed via the corresponding
initialization function:

.. code-block:: lua

  ...
  -- Initial conditions function.
  init = function (t, xn)
    local x, y = xn[1], xn[2]

    local sech_sq = (1.0 / math.cosh(y / lambda)) * (1.0 / math.cosh(y / lambda)) -- Hyperbolic secant squared.

    local n = n0 * (sech_sq * nb_over_n0) -- Total number density.
    local Jz = -(B0 / lambda) * sech_sq -- Total current density (z-direction).

    local rhoi = n * mass_ion -- Ion mass density.
    local momi_x = 0.0 -- Ion momentum density (x-direction).
    local momi_y = 0.0 -- Ion momentum density (y-direction).
    local momi_z = (mass_ion / charge_ion) * Jz * Ti_frac -- Ion momentum density (z-direction).
    local Ei_tot = n * T_tot * Ti_frac / (gas_gamma - 1.0) + 0.5 * momi_z * momi_z / rhoi -- Ion total energy density.

    return rhoi, momi_x, momi_y, momi_z, Ei_tot
  end,
  ...

In both of these cases, we see that the final values that get passed into
:math:`\texttt{Gkeyll}` for the purposes of species initialization are the *conserved*
fluid variables, namely the species mass density :math:`\rho_s = n_s m_s`, the species
momentum density :math:`\rho_s \mathbf{u}_s`, and the species total energy density
(assuming an ideal gas equation of state):

.. math::
  E_s &= E_{s}^{internal} + E_{s}^{kinetic}\\
  &= \left( \frac{p_s}{\gamma_s - 1} \right) + \frac{1}{2} \rho_s \left\lVert
  \mathbf{u}_s \right\rVert^2

where, for the particular case of the GEM reconnection problem, both the electron and ion
species are initialized with number density:

.. math::
  n_s &= n_b \left[ \mathrm{sech} \left( \frac{y}{\lambda} \right) \right]^2\\
  &= n_0 \left[ \mathrm{sech} \left( \frac{y}{\lambda} \right) \right]^2 \left(
  \frac{n_b}{n_0} \right),

momentum density:

.. math::
  \rho_s \mathbf{u}_s = \left( \frac{m_s}{q_s} \right) T_{s}^{frac} \, \mathbf{J},

and total enegy density:

.. math::
  E_s &= \left( \frac{n_s \, T^{tot} \, T_{s}^{frac}}{\gamma_s - 1} \right) + \frac{1}{2}
  \rho_s \left\lVert \mathbf{u}_s \right\rVert^2\\
  &= \left( \frac{n_s \, T^{tot} \, T_{s}^{frac}}{\gamma_s - 1} \right) + \frac{1}{2}
  \left( \frac{\left\lVert \rho_s \mathbf{u}_s \right\rVert^2}{\rho_s} \right),

where the current density :math:`\mathbf{J}` is given by:

.. math::
  \mathbf{J} = \begin{bmatrix}
  0\\
  0\\
  - \left( \frac{B_0}{\lambda} \right) \left[ \mathrm{sech} \left( \frac{y}{\lambda}
  \right) \right]^2
  \end{bmatrix},

and :math:`\mathrm{sech}` is the hyperbolic secant function:

.. math::
  \left[ \mathrm{sech} \left( \frac{y}{\lambda} \right) \right]^2 = \left(
  \frac{1}{\cosh \left( \frac{y}{\lambda} \right)} \right)^2.

The final item to be passed into ``Moments.App.new`` is the electromagnetic field itself:

.. code-block:: lua

  ...
  -- Field.
  field = Moments.Field.new {
    epsilon0 = epsilon0, mu0 = mu0,
    mgnErrorSpeedFactor = 1.0,

    ...

    evolve = true, -- Evolve field?
    bcy = { G0.FieldBc.bcWall, G0.FieldBc.bcWall } -- Wall boundary conditions (y-direction).
  }
  ...

where we begin by passing in parameters for the permittivity and permeability of free
space (:math:`\epsilon_0` and :math:`\mu_0`, respectively), followed by the propagation
speed for divergence errors in the magnetic field :math:`\mathbf{B}`
(since :math:`\texttt{Gkeyll}` uses hyperbolic divergence cleaning methods to correct
numerical deviations from the divergence constraint :math:`\nabla \cdot \mathbf{B} = 0`)
as a fraction of the speed of light, followed by some initialization code which we have
omitted, followed finally by a flag to indicate that the electromagnetic field should be
evolved in time (i.e. the field is not static), and that the boundaries in the :math:`y`
coordinate direciton, on both sides of the domain, should have reflective/wall boundary
conditions applied to them (i.e. ``G0.FieldBc.bcWall``). The initial conditions for the
electromagnetic field are imposed via the initialization function:

.. code-block:: lua

  ...
  -- Initial conditions function.
  init = function (t, xn)
    local x, y = xn[1], xn[2]

    local Bxb = B0 * math.tanh(y / lambda) -- Total magnetic field strength.

    local Ex = 0.0 -- Total electric field (x-direction).
    local Ey = 0.0 -- Total electric field (y-direction).
    local Ez = 0.0 -- Total electric field (z-direction).

    local Bx = Bxb - psi0 * (pi / Ly) * math.cos(2.0 * pi * x / Lx) * math.sin(pi * y / Ly) -- Total magnetic field (x-direction).
    local By = psi0 * (2.0 * pi / Lx) * math.sin(2.0 * pi * x / Lx) * math.cos(pi * y / Ly) -- Total magnetic field (y-direction).
    local Bz = 0.0 -- Total magnetic field (z-direction).

    return Ex, Ey, Ez, Bx, By, Bz, 0.0, 0.0
  end,
  ...

We see that the final values that get passed in :math:`\texttt{Gkeyll}` for the purposes
of electromagnetic field initialization are the electric field :math:`\mathbf{E}`, the
magnetic field :math:`\mathbf{B}`, and the two field potentials :math:`\phi` and
:math:`\psi` (both set to 0 here), used by the hyperbolic divergence cleaning algorithm
for the propagation of divergence errors in the :math:`\mathbf{E}` and :math:`\mathbf{B}`
fields, respectively. For the particular case of the GEM reconnection problem, the
electromagnetic field is initialized with vanishing electric field
:math:`\mathbf{E} = \mathbf{0}`, and non-vanishing magnetic field:

.. math::
  \mathbf{B} = \begin{bmatrix}
  B_{strength} - \psi_0 \left( \frac{\pi}{L_y} \right) \cos \left( \frac{2 \pi x}{L_x}
  \right) \sin \left( \frac{\pi y}{L_y} \right)\\
  \psi_0 \left( \frac{2 \pi}{L_x} \right) \sin \left( \frac{2 \pi x}{L_x} \right) \cos
  \left( \frac{\pi y}{L_y} \right)\\
  0
  \end{bmatrix},

where the magnetic field strength :math:`B_{strength}` is given by:

.. math::
  B_{strength} = B_0 \tanh \left( \frac{y}{\lambda} \right).

With the :math:`\texttt{moments}` app thus fully initialized, all that remains is for us
to run the simulation itself:

.. code-block:: lua
  
  ...
  -- Run application.
  momentApp:run()

.. toctree::
  :maxdepth: 2