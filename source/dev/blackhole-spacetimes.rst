.. _devBlackHoleSpacetimes:

Black hole spacetimes in Gkeyll
===============================

In principle, the Gkeyll Moment app provides the requisite algorithmic infrastructure
for solving the equations of general relativistic hydrodynamics within an arbitrary
curved spacetime background. However, Gkeyll provides specific in-built support for
stationary black hole spacetimes in the Cartesian Kerr-Schild coordinate system
:math:`\left\lbrace t, x, y, z \right\rbrace`, since such spacetimes and coordinate
systems prove particularly useful when performing hydrodynamic simulations of black hole
accretion and astrophysical jet formation. In the absence of electromagnetic fields, the
no-hair theorem implies that any stationary black hole in general relativity may be
characterized by a mass :math:`M` and a non-dimensional spin parameter:

.. math::
  a = \frac{J}{M} \in \left[ 0, 1 \right],

where :math:`J` is a dimensional angular momentum parameter. Gkeyll uses the formulation
of the Kerr-Schild coordinate system presented in [Moreno2002]_, based upon the earlier
work of [Debney1969]_. In this short technical note, we will follow the notational and
terminological conventions introduced within the description of the
:ref:`GRHD equations in Gkeyll <devGRHDEquations>`. In particular, we assume a
:math:`{3 + 1}` "ADM" decomposition of our 4-dimensional spacetime into 3-dimensional
spacelike hypersurfaces with induced metric tensor :math:`\gamma_{i j}`, lapse function
:math:`\alpha`, shift vector :math:`\beta^i`, and extrinsic curvature tensor
:math:`K_{i j}`. Einstein summation convention (in which repeated tensor indices are
implicitly summed over) is assumed throughout. The Greek indices :math:`\mu, \nu`
range over the full spacetime coordinate directions
:math:`\left\lbrace 0, \dots 3 \right\rbrace`, while the Latin indices :math:`i, j, k`
range over the spatial coordinate directions
:math:`\left\lbrace 1, \dots 3 \right\rbrace` only.

Cartesian Kerr-Schild coordinates
---------------------------------

By default, Gkeyll represents all black hole spacetimes as generalized Kerr-Schild
perturbations of flat (Minkowski) spacetime, of the form:

.. math::
  g_{\mu \nu} = \eta_{\mu \nu} - V l_{\mu} l_{\nu},

where :math:`\eta_{\mu \nu}` denotes the standard Minkowski metric:

.. math::
  \eta_{\mu \nu} = \begin{bmatrix}
  -1 & 0 & 0 & 0\\
  0 & 1 & 0 & 0\\
  0 & 0 & 1 & 0\\
  0 & 0 & 0 & 1
  \end{bmatrix},

:math:`V` is a scalar (referred to as the *Kerr-Schild scalar* within the Gkeyll code),
and :math:`l_{\mu} = l^{\mu}` is a null (co)vector with respect to the background
spacetime (referred to as the *Kerr-Schild vector* within the Gkeyll code). For a black
hole with mass :math:`M` and dimensionless spin :math:`a \in \left[ 0, 1 \right]` in
Cartesian coordinates :math:`\left\lbrace t, x, y, z \right\rbrace`, it is helpful to
introduce a generalized radial quantity :math:`r`, defined implicitly by the following
algebraic equation:

.. math::
  \frac{x^2 + y^2}{r^2 + M^2 a^2} + \frac{z^2}{r^2} = 1,

with the explicit (positive) solution:

.. math::
  r = \left( \frac{1}{\sqrt{2}} \right) \sqrt{x^2 + y^2 + z^2 - M^2 a^2
  + \sqrt{\left( x^2 + y^2 + z^2 - M^2 a^2 \right)^2 + 4 M^2 a^2 z^2}},

with respect to which the Kerr-Schild scalar :math:`V` and the components of the null
Kerr-Schild (co)vector :math:`l_{\mu} = l^{\mu}` may be straightforwardly expressed as:

.. math::
  V = - \frac{M r^3}{r^4 + M^2 a^2 z^2},

.. math::
  l_0 = l^0 = -1,

.. math::
  l_1 = l^1 = - \frac{r x + a M y}{r^2 + M^2 a^2},

.. math::
  l_2 = l^2 = - \frac{r y - a M x}{r^2 + M^2 a^2},

and:

.. math::
  l_3 = l^3 = - \frac{z}{r},

respectively. From here, we are able to perform a :math:`{3 + 1}`/ADM decomposition of
the spacetime into spacelike hypersurfaces, which are themselves generalized Kerr-Schild
perturbations of flat (Euclidean) space, of the form:

.. math::
  \gamma_{i j} = \delta_{i j} - 2 V l_i l_j,

where :math:`\delta_{i j}` denotes the standard Euclidean metric:

.. math::
  \delta_{i j} = \begin{bmatrix}
  1 & 0 & 0\\
  0 & 1 & 0\\
  0 & 0 & 1
  \end{bmatrix}.

Within such a foliation of a Kerr-Schild spacetime, the ADM lapse function :math:`\alpha`
and the components of the ADM shift vector :math:`\beta^i` may be written in terms of the
Kerr-Schild scalar :math:`V` and (co)vector components :math:`l_i = l^i` as:

.. math::
  \alpha = \frac{1}{\sqrt{1 - 2V}},

and:

.. math::
  \beta^i = \frac{2V}{1 - 2V} l^i,

respectively. The expression for the extrinsic curvature tensor :math:`K_{i j}` is
somewhat more involved:

.. math::
  K_{i j} = \alpha \left( - l_i \frac{\partial}{\partial x^j} \left( V \right)
  - l_j \frac{\partial}{\partial x^i} \left( V \right)
  - V \frac{\partial}{\partial x^j} \left( l_i \right)
  - V \frac{\partial}{\partial x^i} \left( l_j \right) \right.\\
  \left. + 2 V^2 \left( l_i l^k \frac{\partial}{\partial x^k} \left( l_j \right)
  + l_j l^k \frac{\partial}{\partial x^k} \left( l_i \right) \right)
  + 2 V l_i l_j l^k \frac{\partial}{\partial x^k} \left( V \right) \right).

References
----------

.. [Moreno2002] C. Moreno, D. Núñez and O. Sarbach, "Kerr-Schild type initial data for
   black holes with angular momenta", *Classical and Quantum Gravity* **19** (23):
   6059-6073. 2002.

.. [Debney1969] G. C. Debney, R. P. Kerr and A. Schild, "Solutions of the Einstein and
   Einstein-Maxwell Equations", *Journal of Mathematical Physics* **10** (10):
   1842-1854. 1969.

.. [[Kelly2007] B. Kelly, 