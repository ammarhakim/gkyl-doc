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

which in our case defines a value for :math:`\pi` (i.e. ``pi``). Next, we define any
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
:math:`T^{tot} = \beta \frac{B_{0}^{2}}{2 n_0}`. Next, we define some overall parameters
for the simulation:

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
:math:`a` is the largest absolute wave-speed in the simulation domain).

.. toctree::
  :maxdepth: 2