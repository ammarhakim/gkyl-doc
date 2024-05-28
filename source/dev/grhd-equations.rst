.. _devGRHDEquations:

The equations of general relativistic hydrodynamics (GRHD) in Gkeyll
==========================================================

For the general relativistic hydrodynamics capabilities in the Moment app, Gkeyll solves 
a particular hyperbolic conservation law form of the hydrodynamics equations in curved
spacetime known colloquially as the :math:`{3 + 1}` "Valencia" formulation, due
originally to [Banyuls1997]_, and based (as the name suggests) on the :math:`{3 + 1}`
"ADM" formalism of [Arnowitt1959]_. This technical note details exactly how Gkeyll
performs and represents the :math:`{3 + 1}` decomposition of the general relativistic
hydrodynamics equations, and hence introduces the specific form of the equations solved
by the Moment app's finite-volume numerical algorithms. Einstein summation convention
(in which repeated tensor indices are implicitly summed over) is assumed throughout. The
Greek indices :math:`\mu, \nu, \rho, \sigma` range over the full spacetime coordinate
directions :math:`\left\lbrace 0, \dots 3 \right\rbrace`, while the Latin indices
:math:`i, j, k` range over the spatial coordinate directions
:math:`\left\lbrace 1, \dots 3 \right\rbrace` only.

The :math:`{3 + 1}` split of the hydrodynamics equations
-----------------------------------

Assuming a smooth 4-dimensional Lorentzian manifold
:math:`\left( \mathcal{M}, g \right)`, the law of conservation of energy-momentum can
be expressed as the statement that the covariant divergence of the rank-2 stress-energy
tensor :math:`T^{\mu \nu}` vanishes identically:

.. math::
  \nabla_{\nu} T^{\mu \nu} = 0.

On the other hand, the law of conservation of baryon number can be expressed as the
statement that the covariant divergence of the rank-1 (rest) mass current vector
:math:`J^{\mu}` also vanishes identically:

.. math::
  \nabla_{\mu} J^{\mu} = 0.

The spacetime covariant derivative :math:`{\nabla_{\mu}}` can then be represented in
terms of the coefficients :math:`\Gamma_{\mu \nu}^{\rho}` of the Levi-Civita connection
:math:`\nabla` (i.e. the rank-3 Christoffel symbols), thus yielding:

.. math::
  \nabla_{\nu} T^{\mu \nu} = \frac{\partial}{\partial x^{\nu}} \left( T^{\mu \nu} \right)
  + \Gamma_{\mu \sigma}^{\nu} T^{\sigma \nu} + \Gamma_{\nu \sigma}^{\nu} T^{\mu \sigma}
  = 0,

and:

.. math::
  \nabla_{\mu} J^{\mu} = \frac{\partial}{\partial x^{\mu}} \left( J^{\mu} \right)
  + \Gamma_{\mu \sigma}^{\mu} J^{\sigma} = 0,

respectively, which are themselves represented in terms of partial derivatives of the
rank-2 spacetime metric tensor :math:`g_{\mu \nu}` as:

.. math::
  \Gamma_{\mu \nu}^{\rho} = \frac{1}{2} g^{\rho \sigma} \left(
  \frac{\partial}{\partial x^{\mu}} \left( g_{\sigma \nu} \right)
  + \frac{\partial}{\partial x^{\nu}} \left( g_{\mu \sigma} \right)
  - \frac{\partial}{\partial x^{\sigma}} \left( g_{\mu \nu} \right) \right).

For the particular case of a perfect relativistic fluid in thermodynamic equilibrium
(in the absence of heat conduction, and assuming vanishing fluid viscosity and shear
stresses), the stress-energy tensor :math:`T^{\mu \nu}` and (rest) mass current vector
:math:`J^{\mu}` take the forms:

.. math::
  T^{\mu \nu} = \rho h u^{\mu} u^{\nu} + P g^{\mu \nu},

and:

.. math::
  J^{\mu} = \rho u^{\mu},

respectively, where :math:`\rho` is the fluid (rest) mass density, :math:`P` is the
hydrostatic pressure of the fluid, :math:`u^{\mu}` is its 4-velocity, and :math:`h` is
its specific relativistic enthalpy:

.. math::
  h = 1 + \varepsilon \left( \rho, P \right) + \frac{P}{\rho},

with :math:`\varepsilon \left( \rho, P \right)` designating the specific internal energy
of the fluid, which is determined by the equation of state. Once specified, the local
fluid sound speed :math:`c_s` may then be calculated as:

.. math::
  c_s = \frac{1}{\sqrt{h}} \sqrt{\left. \left( \frac{\partial P}{\partial \rho} \right)
  \right\vert_{\varepsilon} + \left( \frac{P}{\rho^2} \right) \left.
  \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{P}}.

We can now decompose our 4-dimensional spacetime :math:`\left( \mathcal{M}, g \right)`
into a time-ordered sequence of 3-dimensional spacelike (Riemannian) hypersurfaces,
each with an induced metric tensor :math:`\gamma_{\mu \nu}`. For this purpose, we employ
the particular form of the ADM decomposition due to [York1979]_. The overall spacetime
line element/first fundamental form :math:`d s^2`:

.. math::
  d s^2 = g_{\mu \nu} d x^{\mu} d x^{\nu}

thus decomposes into:

.. math::
  d s^2 &= -\alpha^2 d t^2 + \gamma_{i j} \left( d x^i + \beta^i dt \right)
  \left( d x^j + \beta^j dt \right)\\
  &= \left( - \alpha^2 + \gamma_{i k} \beta^k \beta^i \right) d t^2
  + 2 \gamma_{i k} \beta^k dt d x^i + \gamma_{i j} d x^i d x^j\\
  &= \left( - \alpha^2 + \beta_i \beta^i \right) d t^2 + 2 \beta_i dt d x^i
  + \gamma_{i j} d x^i d x^j. 

References
----------

.. [Banyuls1997] F. Banyuls, J. A. Font, J. M. Ibáñez, J. M. Martí and
   J. A. Miralles, "Numerical {3 + 1} General Relativistic Hydrodynamics:
   A Local Characteristic Approach", *The Astrophysical Journal*, **476**
   (1): 221-231, 1997.

.. [Arnowitt1959] R. L. Arnowitt, S. Deser and C. W. Misner, "Dynamical
   Structure and Definition of Energy in General Relativity", *Physical
   Review* **116** (5): 1322-1330. 1959.

.. [York1979] J. W. York, Jr., "Kinematics and Dynamics of General
   Relativity", *Sources of Gravitational Radiation*: 83-126. 1979.