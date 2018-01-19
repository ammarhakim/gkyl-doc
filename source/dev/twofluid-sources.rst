Handling two-fluid five-moment and ten-moment source terms
==========================================================

The two-fluid system treats a plasma as a mixture of electron and ion
fluids, coupled via the electromagnetic field and collisions. In the
*ideal* two-fluid system collisions and heat-flux are neglected,
leading to a closed system of coupled PDEs: one set of fluid equations
for each of the fluids, and Maxwell equations for the electromagnetic
field. Non-neutral effects, electron interia as well as displacement
currents are retained. Further, the fluid pressures can be treated as
either a scalar (five-moment model) or a symmetric :math:`3\times 3`
tensor (ten-moment model), or a combination.

While solving the two-fluid system there are two distinct solves: the
hyperbolic update, which can be performed for each equation system
separately and the source update, which couples the fluids and the
fields together. In this note I only focus on the *source updates*,
for both the five as well as the ten-moment equations. When written
in non-conservation law form, the only sources in the system are the
Lorentz force in the momentum equation, the plasma currents in the
electric field equation and, in the ten-moment model, the rotation of
the pressure tensor due to the magnetic field. The latter equation is
uncoupled from the source update for the momentum and the electric
field, and can be treated separately.

..
   The source terms add time and spatial scales in addition to those from
   the hyperbolic terms. These scales can be severe, specially the plasma
   and cyclotron frequencies for realistic mass ratios.

Five-moment source updates
--------------------------

The equations for the five-moment source updates are

.. math::
  
  \frac{d \mathbf{v}_s}{dt} &= \frac{q_s}{m_s}
  \left( \mathbf{E} + \mathbf{v}_s \times \mathbf{B} \right) \\
  \epsilon_0\frac{d \mathbf{E}}{dt}
  &= -\sum_s q_s n_s \mathbf{v}_s

where, for the plasma species :math:`s`, :math:`n_s` is the number
density, :math:`\mathbf{v}_s` is the velocity, :math:`q_s` and
:math:`m_s` are the charge and mass respectively. Further,
:math:`\mathbf{E}` is the electric field, and :math:`\epsilon_0` is
permittivity of free space. In these equations the magnetic field and
number density are constants, as there are no source terms for these
quantities.

It is more convenient to work in terms of the plasma current
:math:`\mathbf{J}_s \equiv q_s n_s \mathbf{v}_s`, which leads to the
coupled system

.. math::
  
  \frac{d \mathbf{J}_s}{dt} &= 
  \omega_s^2\epsilon_0\mathbf{E} + \mathbf{J}_s \times \mathbf{\Omega}_s \\
  \epsilon_0\frac{d \mathbf{E}}{dt}
  &= -\sum_s \mathbf{J}_s

where :math:`\mathbf{\Omega}_s \equiv q_s\mathbf{B}/m_s` and
:math:`\omega_s \equiv \sqrt{q_s^2 n_s/\epsilon_0 m_s}` is the species
plasma frequency. This is a system of linear, constant-coefficient
ODEs for the :math:`3s+3` unknowns :math:`\mathbf{J}_s` and
:math:`\mathbf{E}`.

Implicit solution
+++++++++++++++++

To solve the system of ODEs we replace the time-derivatives with
time-centered differences. This leads to the discrete equations

.. math::

  \frac{\mathbf{J}_s^{n+1/2}-\mathbf{J}_s^n}{\Delta t/2} &= 
  \omega_s^2\epsilon_0\mathbf{E}^{n+1/2} + \mathbf{J}_s^{n+1/2} \times \mathbf{\Omega}_s \\
  \epsilon_0\frac{\mathbf{E}^{n+1/2}-\mathbf{E}^n}{\Delta t/2}
  &= -\sum_s \mathbf{J}_s^{n+1/2}

where :math:`\mathbf{J}_s^{n+1/2} =
(\mathbf{J}_s^{n+1}+\mathbf{J}_s^{n})/2` and :math:`\mathbf{E}^{n+1/2}
= (\mathbf{E}^{n+1}+\mathbf{E}^n)/2`. This is a system of :math:`3p+3`
system of linear equations for the :math:`3p+3` unknowns
:math:`\mathbf{J}_s^{n+1/2}`, :math:`s=1,\ldots,p` and
:math:`\mathbf{E}_s^{n+1/2}` and can be solved with any linear algebra
routine.

Ten-moment source updates
-------------------------

The ten-moment equations have identical sources for currents and
electric field. For these terms the same implicit algorithm can be
used.  In addition, there are source terms in the pressure
equation. In non-conservative form these can be written as the linear
system of equations

.. math::

  \frac{d}{dt}
  \left[
    \begin{matrix}
    P_{xx} \\
    P_{xy} \\
    P_{xz} \\
    P_{yy} \\
    P_{yz} \\
    P_{zz}
    \end{matrix}
  \right]
  =
  \frac{q}{m}\pmatrix{0&2\,B_{z}&-2\,B_{y}&0&0&0\cr -B_{z}&0&B_{x}&B_{z}&-B_{y}&
  0\cr B_{y}&-B_{x}&0&0&B_{z}&-B_{y}\cr 0&-2\,B_{z}&0&0&2\,B_{x}&0\cr 
  0&B_{y}&-B_{z}&-B_{x}&0&B_{x}\cr 0&0&2\,B_{y}&0&-2\,B_{x}&0\cr }
  \left[
    \begin{matrix}
    P_{xx} \\
    P_{xy} \\
    P_{xz} \\
    P_{yy} \\
    P_{yz} \\
    P_{zz}
    \end{matrix}
  \right].

This system can be updated using a similar time-centered implicit
method as use for the currents and the electric field. Note that
unlike the sources for the currents and the electric field, the
pressure source terms are uncoupled from the other fluid and
electromagnetic terms.
