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
introduce a generalized radial quantity :math:`R`, defined implicitly by the following
algebraic equation:

.. math::
  \frac{x^2 + y^2}{R^2 + M^2 a^2} + \frac{z^2}{R^2} = 1,

with the explicit (positive) solution:

.. math::
  R = \left( \frac{1}{\sqrt{2}} \right) \sqrt{x^2 + y^2 + z^2 - M^2 a^2
  + \sqrt{\left( x^2 + y^2 + z^2 - M^2 a^2 \right)^2 + 4 M^2 a^2 z^2}},

with respect to which the Kerr-Schild scalar :math:`V` and the components of the null
Kerr-Schild (co)vector :math:`l_{\mu} = l^{\mu}` may be straightforwardly expressed as:

.. math::
  V = - \frac{M R^3}{R^4 + M^2 a^2 z^2},

.. math::
  l_0 = l^0 = -1,

.. math::
  l_1 = l^1 = - \frac{R x + a M y}{R^2 + M^2 a^2},

.. math::
  l_2 = l^2 = - \frac{R y - a M x}{R^2 + M^2 a^2},

and:

.. math::
  l_3 = l^3 = - \frac{z}{R},

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

Transformation to standard Boyer-Lindquist coordinates
------------------------------------------------------

A more common representation of the Kerr metric for a spinning black hole is in the
Boyer-Lindquist spherical (or, more precisely, oblate spheroidal) coordinate system
:math:`\left\lbrace t, r, \theta, \phi \right\rbrace` proposed by [Boyer1967]_, which
can be straightforwardly related to the Cartesian coordinate system
:math:`\left\lbrace t, x, y, z \right\rbrace` in the usual way:

.. math::
  x = \sqrt{r^2 + a^2} \sin \left( \theta \right) \cos \left( \phi \right),

.. math::
  y = \sqrt{r^2 + a^2} \sin \left( \theta \right) \sin \left( \phi \right),

.. math::
  z = r \cos \left( \theta \right).

The :math:`{3 + 1}`/ADM decomposition of the Kerr metric in Boyer-Lindquist coordinates
then yields a family of spacelike hypersurfaces with a purely diagonal spatial metric
tensor :math:`\gamma_{i j}`, of the form:

.. math::
  \gamma_{i j} = \begin{bmatrix}
  \frac{R^2}{r^2 + a^2 - 2 M r} & 0 & 0\\
  0 & R^2 & 0\\
  0 & 0 & \frac{R^2 \left( r^2 + a^2 \right) + 2 M^3 a^2 r
  \sin^2 \left( \theta \right)}{R^2} \sin^2 \left( \theta \right),
  \end{bmatrix}

with the ADM lapse function :math:`\alpha` and shift vector components :math:`\beta^i`
now given by:

.. math::
  \alpha = \sqrt{\frac{R^2 \left( r^2 + a^2 - 2 M r \right)}{R^2 \left( r^2 + a^2 \right)
  + 2 M^3 a^2 r \sin^2 \left( \theta \right)}},

and:

.. math::
  \boldsymbol\beta = \begin{bmatrix}
  0\\
  0\\
  - \frac{2 a M r}{R^2 \left( r^2 + a^2 \right) + 2 M^3 a^2 r
  \sin^2 \left( \theta \right)}
  \end{bmatrix},

respectively. Although expressing the Kerr metric in Boyer-Lindquist coordinates has
certain aesthetic advantages (e.g. the diagonality of the spatial metric
:math:`\gamma_{i j}`, the non-zero angular component :math:`\beta^{\phi} \neq 0` of the
shift vector explicitly indicating frame-dragging effects, etc.), it is less appropriate
for numerical simulations than the Kerr-Schild coordinate system due to the appearance
of coordinate singularities wherever:

.. math::
  r^2 + a^2 - 2 M r = 0,

whose solutions :math:`r = r_{-}` and :math:`r = r_{+}` correspond to the interior and
exterior black hole horizons:

.. math::
  r_{\pm} = M \left( 1 \pm \sqrt{1 - a^2} \right),

respectively. By contrast, the Kerr-Schild coordinate system is *horizon-adapted*,
meaning that the solution may be smoothly extended across both the interior and exterior
horizons, guaranteeing greater numerical stability in the near-horizon region; it is for
this reason that Gkeyll represents black hole geometries in the Kerr-Schild coordinate
system by default. In order to see how to transform from the Cartesian Kerr-Schild
coordinate system into the spherical (oblate spheroidal) Boyer-Lindquist coordinate
system, we begin by transforming to a spherical (oblate spheroidal) form of the
Kerr-Schild coordinate system :math:`\left\lbrace t, r, \theta, \phi \right\rbrace`,
related to the old Cartesian form :math:`\left\lbrace t, x, y, z \right\rbrace` by the
transformation:

.. math::
  x = \left( r \cos \left( \phi \right) - a \sin \left( \phi \right) \right)
  \sin \left( \theta \right) = \sqrt{r^2 + a^2} \sin \left( \theta \right)
  \cos \left( \phi - \arctan \left( \frac{a}{r} \right) \right),

.. math::
  y = \left( r \sin \left( \phi \right) + a \cos \left( \phi \right) \right)
  \sin \left( \theta \right) = \sqrt{r^2 + a^2} \sin \left( \theta \right)
  \sin \left( \phi - \arctan \left( \frac{a}{r} \right) \right),

.. math::
  z = r \cos \left( \theta \right).

Note that this is *almost* the same as the Boyer-Lindquist coordinate system, but with
a small modification in the :math:`\phi` coordinate that causes the new system to remain
regular across the black hole horizon(s). The :math:`{3 + 1}`/ADM decomposition of the
Kerr metric in spherical (oblate spheroidal) Kerr-Schild coordinates now yields a
family of spacelike hypersurfaces with a single off-diagonal term in the spatial metric
tensor :math:`\gamma_{i j}`:

.. math::
  \gamma_{i j} = \begin{bmatrix}
  1 + \frac{2 M r}{R^2} & 0 & - M a \sin^2 \left( \theta \right) \left( 1
  + \frac{2 M r}{R^2} \right)\\
  0 & R^2 & 0\\
  - M a \sin^2 \left( \theta \right) \left( 1 + \frac{2 M r}{R^2} \right) & 0 &
  \left( r^2 + M^2 a^2 + \frac{2 M^3 a^2 r}{R^2} \sin^2 \left( \theta \right) \right)
  \sin^2 \left( \theta \right)
  \end{bmatrix},

coupling the radial and angular directions, with the ADM lapse function :math:`\alpha`
and shift vector components :math:`\beta^i` now given by:

.. math::
  \alpha = \frac{1}{\sqrt{1 + \frac{2 M r}{R^2}}},

and:

.. math::
  \boldsymbol\beta = \begin{bmatrix}
  \frac{2 M r}{R^2 \left( 1 + \frac{2 M r}{R^2} \right)}\\
  0\\
  0
  \end{bmatrix},

respectively.

References
----------

.. [Moreno2002] C. Moreno, D. Núñez and O. Sarbach, "Kerr-Schild type initial data for
   black holes with angular momenta", *Classical and Quantum Gravity* **19** (23):
   6059-6073. 2002.

.. [Debney1969] G. C. Debney, R. P. Kerr and A. Schild, "Solutions of the Einstein and
   Einstein-Maxwell Equations", *Journal of Mathematical Physics* **10** (10):
   1842-1854. 1969.

.. [Boyer1967] R. H. Boyer and R. W. Lindquist, "Maximal Analytic Extension of the Kerr
   Metric", *Journal of Mathematical Physics* **8** (2): 265-281. 1967.