.. _devGRHDEquations:

The equations of general relativistic hydrodynamics (GRHD) in Gkeyll
==========================================================

For the purpose of supporting the (prototype) general relativistic hydrodynamics
capabilities currently available within the Moment app, Gkeyll solves  a particular
hyperbolic conservation law form of the hydrodynamics equations in curved spacetime
known colloquially as the :math:`{3 + 1}` "Valencia" formulation, due originally to
[Banyuls1997]_, and based (as the name suggests) on the :math:`{3 + 1}` "ADM" formalism
of [Arnowitt1959]_. This technical note details exactly how Gkeyll performs and
represents the :math:`{3 + 1}` decomposition of the general relativistic hydrodynamics
equations, and hence introduces the specific form of the equations solved by the Moment
app's finite-volume numerical algorithms. Einstein summation convention (in which
repeated tensor indices are implicitly summed over) is assumed throughout. The Greek
indices :math:`\mu, \nu, \rho, \sigma` range over the full spacetime coordinate
directions :math:`\left\lbrace 0, \dots 3 \right\rbrace`, while the Latin indices
:math:`i, j, k, l` range over the spatial coordinate directions
:math:`\left\lbrace 1, \dots 3 \right\rbrace` only. The coordinate :math:`x^0 = t` is
assumed to be timelike, with the remaining coordinates
:math:`\left\lbrace x^1, x^2, x^3 \right\rbrace` being spacelike.

The :math:`{3 + 1}` split of the hydrodynamics equations
-----------------------------------

Assuming a smooth 4-dimensional Lorentzian manifold structure
:math:`\left( \mathcal{M}, g \right)` for spacetime, the law of conservation of
energy-momentum can be expressed as the statement that the covariant divergence of the
rank-2 stress-energy tensor :math:`T^{\mu \nu}` vanishes identically:

.. math::
  \nabla_{\nu} T^{\mu \nu} = 0.

On the other hand, the law of conservation of baryon number can be expressed as the
statement that the covariant divergence of the rank-1 (rest) mass current vector
:math:`J^{\mu}` also vanishes identically:

.. math::
  \nabla_{\mu} J^{\mu} = 0.

The spacetime covariant derivative :math:`{\nabla_{\mu}}` can then be represented
explicitly in terms of the coefficients :math:`\Gamma_{\mu \nu}^{\rho}` of the
Levi-Civita connection :math:`\nabla` (i.e. the rank-3 Christoffel symbols), thus
yielding:

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
(in the absence of heat conduction effects, and assuming vanishing fluid viscosity and
shear stresses), the stress-energy tensor :math:`T^{\mu \nu}` and (rest) mass current
vector :math:`J^{\mu}` take the forms:

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
each with an induced/spatial metric tensor :math:`\gamma_{i j}`. For this purpose, we
employ the particular form of the ADM decomposition due to [York1979]_, in which the
coordinate :math:`x^0 = t` is assumed to correspond to a distinguished time direction.
The overall spacetime line element/first fundamental form :math:`d s^2` (in terms of
:math:`g_{\mu \nu}`):

.. math::
  d s^2 = g_{\mu \nu} d x^{\mu} d x^{\nu}

thus decomposes into (in terms of :math:`\gamma_{i j}`):

.. math::
  d s^2 &= -\alpha^2 d t^2 + \gamma_{i j} \left( d x^i + \beta^i dt \right)
  \left( d x^j + \beta^j dt \right)\\
  &= \left( - \alpha^2 + \gamma_{i k} \beta^k \beta^i \right) d t^2
  + 2 \gamma_{i k} \beta^k dt d x^i + \gamma_{i j} d x^i d x^j\\
  &= \left( - \alpha^2 + \beta_i \beta^i \right) d t^2 + 2 \beta_i dt d x^i
  + \gamma_{i j} d x^i d x^j.

The scalar field :math:`\alpha` and 3-dimensional vector field :math:`\beta^i`
constitute the Lagrange multipliers of the ADM formalism, and are known as the *lapse
function* and *shift vector*, respectively. The lapse function :math:`\alpha` is a gauge
variable determining the proper time distance :math:`d \tau` between corresponding points
on neighboring spacelike hypersurfaces in the decomposition (labeled by coordinate time
values :math:`t = t_0` and :math:`t = t_0 + dt`):

.. math::
  d \tau \left( t_0, t_0 + dt \right) = \alpha dt,

as measured in the normal direction :math:`\mathbf{n}` to the :math:`t = t_0`
hypersurface. On the other hand, the shift vector :math:`\beta^i` is a gauge variable
determining the relabeling of the spatial coordinate basis :math:`x^i \left( t_0 \right)`
as one moves from the :math:`t = t_0` hypersurface to the :math:`t = t_0 + dt`
hypersurface:

.. math::
  x^i \left( t_0 + dt \right) = x^i \left( t_0 \right) - \beta^i dt.

The timelike unit vector :math:`\mathbf{n}` that is normal to each spacelike hypersurface
may be calculated as the spacetime contravariant derivative
:math:`{}^{\left( 4 \right)} \nabla^{\mu}` of the distinguished time coordinate
:math:`t`:

.. math::
  n^{\mu} &= -\alpha {}^{\left( 4 \right)} \nabla^{\mu} t\\
  &= -\alpha g^{\mu \sigma} {}^{\left( 4 \right)} \nabla_{\sigma} t\\
  &= -\alpha g^{\mu \sigma} \frac{\partial}{\partial x^{\sigma}} \left( t \right),

where the bracketed :math:`\left( 4 \right)` is used to distinguish the full spacetime
covariant derivative :math:`{}^{\left( 4 \right)} \nabla_{\mu}` from the purely
spatial covariant derivative :math:`{}^{\left( 3 \right)} \nabla_i`. If the components
of the spatial metric tensor :math:`\gamma_{i j}` represent the dynamical variables of
the ADM formalism (regarded here, following [Alcubierre2008]_, as a Hamiltonian
formulation of general relativity), then the components of the extrinsic curvature
tensor/second fundamental form :math:`K_{i j}` represent the corresponding conjugate
momenta, calculated in terms of the Lie derivative :math:`\mathcal{L}` of the spatial
metric tensor :math:`\gamma_{i j}` in the direction of the normal vector
:math:`\mathbf{n}`:

.. math::
  K_{i j} = - \frac{1}{2} \mathcal{L}_{\mathbf{n}} \gamma_{i j},

which we can expand out to yield, explicitly:

.. math::
  K_{i j} &= \frac{1}{2 \alpha} \left( {}^{\left( 3 \right)} \nabla_j \beta_i
  + {}^{\left( 3 \right)} \nabla_i \beta_j
  - \frac{\partial}{\partial t} \left( \gamma_{i j} \right) \right)\\
  &= \frac{1}{2 \alpha} \left( \frac{\partial}{\partial x^j} \left( \beta_i \right)
  - {}^{\left( 3 \right)} \Gamma_{j i}^{k} \beta_k
  + \frac{\partial}{\partial x^i} \left( \beta_j \right)
  - {}^{\left( 3 \right)} \Gamma_{i j}^{k} \beta_k
  - \frac{\partial}{\partial t} \left( \gamma_{i j} \right) \right),

where we have, as before, represented the spatial covariant derivative
:math:`{}^{\left( 3 \right)} \nabla_i` in terms of the coefficients
:math:`{}^{\left( 3 \right)} \Gamma_{i j}^{k}` of the spatial Levi-Civita connection:

.. math::
  {}^{\left( 3 \right)} \Gamma_{i j}^{k} = \frac{1}{2} \gamma^{k l} \left(
  \frac{\partial}{\partial x^i} \left( \gamma_{l j} \right)
  + \frac{\partial}{\partial x^j} \left( \gamma_{i l} \right)
  - \frac{\partial}{\partial x^l} \left( \gamma_{i j} \right) \right).

The energy density :math:`E`, momentum density (in covector form) :math:`p_i`, and
Cauchy stress tensor :math:`S_{i j}`, perceived by an observer moving in the direction
:math:`\mathbf{n}` normal to the spacelike hypersurfaces can then be calculated by
evaluating the following componentwise projections of the full (spacetime) stress-energy
tensor :math:`T^{\mu \nu}`:

.. math::
  E = T_{\mu \nu} n^{\mu \nu},

.. math::
  p_i = -T_{\mu \nu} n^{\mu} \bot_{i}^{\nu},

and:

.. math::
  S_{i j} = T_{\mu \nu} \bot_{i}^{\mu} \bot_{j}^{\nu},

respectively, where the :math:`\bot_{i}^{\mu}` denote the components of the orthogonal
projector (i.e. the projection operator in the normal direction :math:`\mathbf{n}`):

.. math::
  \bot_{i}^{\mu} = \delta_{i}^{\mu} + n_{i} n^{\mu}.

By projecting the continuity equations for the full stress-energy tensor
:math:`T^{\mu \nu}`:

.. math::
  {}^{\left( 4 \right)} \nabla_{\nu} T^{\mu \nu} =
  \frac{\partial}{\partial x^{\nu}} \left( T^{\mu \nu} \right)
  + {}^{\left( 4 \right)} \Gamma_{\nu \sigma}^{\mu} T^{\sigma \nu}
  + {}^{\left( 4 \right)} \Gamma_{\nu \sigma}^{\nu} T^{\mu \sigma} = 0,

in the purely timelike direction (and expanding out the resulting Lie derivative term
:math:`\mathcal{L}_{\boldsymbol\beta} E`), we obtain the following energy conservation
equation:

.. math::
  \frac{\partial}{\partial t} \left( E \right) - \mathcal{L}_{\boldsymbol\beta}
  + \alpha \left( {}^{\left( 3 \right)} \nabla_i p^i - K E - K_{i j} S^{i j} \right)
  + 2 p^i {}^{\left( 3 \right)} \nabla_i \alpha\\
  = \frac{\partial}{\partial t} \left( E \right)
  - \beta^i \frac{\partial}{\partial x^i} \left( E \right)
  + \alpha \left( {}^{\left( 3 \right)} \nabla_i p^i - K E - K_{i j} S^{i j} \right)
  + 2 p^i {}^{\left( 3 \right)} \nabla_i \alpha\\
  = \frac{\partial}{\partial t} \left( E \right)
  - \beta^i \frac{\partial}{\partial x^i} \left( E \right)
  + \alpha \left( \frac{\partial}{\partial x^i} \left( p^i \right)
  + {}^{\left( 3 \right)} \Gamma_{i k}^{i} p^{k} - K E - K_{i j} S^{i j} \right)\\
  + 2 p^i \frac{\partial}{\partial x^i} \left( \alpha \right) = 0.

On the other hand, by projecting in the 3 purely spacelike directions (and expanding out
the resulting Lie derivative terms :math:`\mathcal{L}_{\boldsymbol\beta} p_i`), we
obtain instead the following momentum conservation equations:

.. math::
  \frac{\partial}{\partial t} \left( p_i \right) - \mathcal{L}_{\boldsymbol\beta} p_i
  + \alpha {}^{\left( 3 \right)} \nabla_j S_{i}^{j}
  + S_{i j} {}^{\left( 3 \right)} \nabla^j \alpha - \alpha K p_i
  + E {}^{\left( 3 \right)} \nabla_i \alpha\\
  = \frac{\partial}{\partial t} \left( p_i \right)
  - \beta^k \frac{\partial}{\partial x^k} \left( p_i \right)
  - p_k \frac{\partial}{\partial x^i} \left( \beta^k \right)
  + \alpha {}^{\left( 3 \right)} \nabla_j S_{i}^{j}\\
  + S_{i j} \gamma^{j k} {}^{\left( 3 \right)} \nabla_k \alpha
  - \alpha K p_i + E {}^{\left( 3 \right)} \nabla_i \alpha\\
  = \frac{\partial}{\partial t} \left( p_i \right)
  - \beta^k \frac{\partial}{\partial x^k} \left( p_i \right)
  - p_k \frac{\partial}{\partial x^i} \left( \beta^k \right)
  + \alpha \left( \frac{\partial}{\partial x^j} \left( S_{i}^{j} \right)
  + {}^{\left( 3 \right)} \Gamma_{j k}^{j} S_{i}^{k}
  - {}^{\left( 3 \right)} \Gamma_{j i}^{k} S_{k}^{j} \right)\\
  + S_{i j} \gamma^{j k} \frac{\partial}{\partial x^k} \left( \alpha \right)
  - \alpha K p_i + E \frac{\partial}{\partial x^i} \left( \alpha \right) = 0.

In the above, :math:`K` denotes the trace of the extrinsic curvature tensor
:math:`K_{i j}`:

.. math::
  K = K_{i}^{i} = \gamma^{i j} K_{i j}.

Note moreover that, in all of the above, the indices of the spacetime quantities
:math:`T^{\mu \nu}` and :math:`n^{\mu}` are raised and lowered using the spacetime
metric tensor :math:`g_{\mu \nu}`, while the purely spatial quantities
:math:`\beta^i`, :math:`K_{i j}`, :math:`p^i`, and :math:`S_{i j}`, are raised and
lowered using the spatial metric tensor :math:`\gamma_{i j}`.

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

.. [Alcubierre2008] M. Alcubierre *Introduction to 3 + 1 Numerical
   Relativity*, Oxford University Press. 2008.