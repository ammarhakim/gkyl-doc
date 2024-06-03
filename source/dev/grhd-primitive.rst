.. _devGRHDPrimitive:

Relativistic primitive variable reconstruction in Gkeyll
========================================================

In conservative formulations of non-relativistic hydrodynamics (as described, for
instance, by the non-relativistic Euler equations), the recovery of primitive variables
from conservative variables, as required for the computation of fluxes, is a purely
algebraic operation: it consists simply of dividing various quantities through by the
mass density :math:`\rho`, and then applying the equation of state to recover the
pressure :math:`P` from the total energy :math:`E`. In special and general relativistic
hydrodynamics, however, this recovery operation becomes considerably more complicated,
due to the appearance of the Lorentz factor:

.. math::
  \alpha u^0 = - u_i n^i = \frac{1}{\sqrt{1 - \gamma_{i j} v^i v^j}},

which guarantees that the (spatial) three-momenta :math:`p_k`, as measured by a normal
observer:

.. math::
  p_k = \frac{\rho h v_k}{1 - \gamma_{i j} v^i v^j} =
  - T_{\mu \nu} n^{\mu} \bot_{k}^{\nu},

are no longer algebraically independent of one another, in contrast to the
non-relativistic case. Thus, for a generic equation of state, it is argued by 
[Marti2003]_ that the conservative to primitive variable reconstruction in relativistic
hydrodynamics cannot be represented as a closed-form algebraic operation, and instead
requires one to perform some kind of (potentially higher-dimensional) root-finding
operation. To this end, Gkeyll employs a certain "robustified" variant of the algorithm
proposed by [Eulderink1995]_, which has been specifically modified to accommodate low
densities, low pressures, and high values of the Lorentz factor, without going unstable,
whilst still retaining the favorable convergence properties of the original Eulderink
and Mellema algorithm in less extreme cases. In this short technical note, we will
follow the notational and terminological conventions introduced within the description
of the :ref:`GRHD equations in Gkeyll <devGRHDEquations>`. In particular, we assume a
:math:`{3 + 1}` "ADM" decomposition of our 4-dimensional spacetime into 3-dimensional
spacelike hypersurfaces with induced metric tensor :math:`\gamma_{i j}`, lapse function
:math:`\alpha`, and shift vector :math:`\beta^i`. We also assume a perfect relativistic
fluid with (rest) mass density :math:`\rho`, spatial velocity components (as perceived
by normal observers) :math:`v^i`, pressure :math:`P`, specific enthalpy :math:`h`, and
local sound speed :math:`c_s`. Einstein summation convention (in which repeated tensor
indices are implicitly summed over) is assumed throughout. The Greek indices
:math:`\mu, \nu` range over the full spacetime coordinate directions
:math:`\left\lbrace 0, \dots, 3 \right\rbrace`, while the Latin indices
:math:`i, j, k, l` range over the spatial coordinate directions
:math:`\left\lbrace 1, \dots, 3 \right\rbrace` only.

Reconstruction algorithm for an ideal gas equation of state
-----------------------------------------------------------

Here we assume an ideal gas equation of state, with adiabatic index :math:`\Gamma`, for
which the specific relativistic enthalpy:

.. math::
  h = 1 + \varepsilon \left( \rho, P \right) + \frac{P}{\rho},

with specific internal energy :math:`\varepsilon \left( \rho, P \right)`, is now given
by:

.. math::
  h = 1 + \frac{P}{\rho} \left( \frac{\Gamma}{\Gamma - 1} \right),

such that the local fluid sound speed:

.. math::
  c_s = \frac{1}{\sqrt{h}} \sqrt{\left. \left( \frac{\partial P}{\partial \rho}
  \right) \right\vert_{\varepsilon} + \left( \frac{P}{\rho^2} \right) \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}},

now becomes:

.. math::
  c_s = \sqrt{\frac{\Gamma P}{\rho \left( 1 + \left( \frac{P}{\rho} \right) \left(
  \frac{\Gamma}{\Gamma - 1} \right) \right)}}.

The approach advocated by [Eulderink1995]_ is then to use a non-linear root-finding
algorithm (namely the one-dimensional Newton-Raphson method) to find the roots of the
following quartic polynomial in :math:`\xi`:

.. math::
  \alpha_4 \xi^3 \left( \xi - \eta \right) + \alpha_2 \xi^2 + \alpha_1 \xi + \alpha_0
  = 0,

where we have defined the variable :math:`\xi` and the constant term :math:`\eta` to be:

.. math::
  \xi &= \frac{\sqrt{- g_{\mu \nu} T^{0 \mu} T^{0 \nu}}}{\rho h u^0}\\
  &= \frac{\left( \sqrt{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2
  - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2 v_k v^k} \right)
  \sqrt{1 - \gamma_{i j} v^i v^j}}{\rho h},

and

.. math::
  \eta &= \frac{2 \rho u^0 \left( \Gamma - 1 \right)}{\left( \sqrt{- g_{\mu \nu}
  T^{0 \mu} T^{0 \nu}} \right) \Gamma}\\
  &= \frac{2 \rho \left( \Gamma - 1 \right)}{\left( \sqrt{\left( \frac{\rho h}{1
  - \gamma_{i j} v^i v^j} - P \right)^2 - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  \right)^2 v_k v^k} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) \Gamma},

respectively, and where the coefficients :math:`\alpha_4`, :math:`\alpha_2`,
:math:`\alpha_1` and :math:`\alpha_0` in the quartic are given by:

.. math::
  \alpha_4 &= \frac{\left( T^{0 0} \right)^2}{g^{0 0} g_{\mu \nu} T^{0 \mu} T^{0 \nu}}
  - 1\\
  &= \frac{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2}{\left(
  \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2 - \left(
  \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2 v_k v^k} - 1,

.. math::
  \alpha_2 &= \left( \frac{\Gamma - 2}{\Gamma} \right) \left( \frac{\left( T^{0 0}
  \right)^2}{g^{0 0} g_{\mu \nu} T^{0 \mu} T^{0 \nu}} - 1 \right) + 1 + \left(
  \frac{\left( \rho u^0 \right)^2}{g_{\mu \nu} T^{0 \mu} T^{0 \nu}} \right) \left(
  \frac{\Gamma - 1}{\Gamma} \right)^2\\
  &= \left( \frac{\Gamma - 2}{\Gamma} \right) \left( \frac{\left( \frac{\rho h}{1
  - \gamma_{i j} v^i v^j} - P \right)^2}{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  \right)^2 \left( 1 - v_k v^k \right)} - 1 \right) + 1\\
  &- \left( \frac{\rho^2}{\left( \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P
  \right)^2 - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2 v_k v^k \right)
  \left( 1 - \gamma_{i j} v^i v^j \right)} \right) \left( \frac{\Gamma - 1}{\Gamma}
  \right)^2,

.. math::
  \alpha_1 &= - \frac{2 \rho u^0 \left( \Gamma - 1 \right)}{\left( \sqrt{- g_{\mu nu}
  T^{0 \mu} T^{0 \nu}} \right) \Gamma^2}\\
  &= \frac{2 \rho \left( \Gamma - 1 \right)}{\left( \sqrt{\left( \frac{\rho h}{1
  - \gamma_{i j} v^i v^j} - P \right)^2 - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  \right)^2 v_k v^k} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) \Gamma^2},

and:

.. math::
  \alpha_0 = - \frac{1}{\Gamma^2},

respectively. Once an appropriately accurate value of :math:`\xi` has been calculated
in this way, it is then possible to compute an updated value for the Lorentz factor
:math:`W_{new}` using:

.. math::
  W_{new} = \frac{1}{2} \left( \frac{\frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  - P}{\sqrt{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2 -
  \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2 v_k v^k}} \right) \xi\\
  \times \left( 1 + \sqrt{1 + 4 \left( \frac{\Gamma - 1}{\Gamma} \right) \left(
  \frac{1 - \frac{\rho \xi}{\left( \sqrt{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  - P \right)^2 - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2 v_k v^k}
  \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}}{\frac{\left(
  \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2 \xi^2}{\left(
  \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P \right)^2 - \left( \frac{\rho h}{1
  - \gamma_{i j} v^i v^j} \right)^2 v_k v^k}}
  \right)} \right),

and, from this, an updated value for the fluid (rest) mass density :math:`\rho_{new}`
using:

.. math::
  \rho_{new} = \frac{\rho}{\left( 1 - \gamma_{i j} v^i v^j \right) W_{new}}.

It is also possible to compute, from the numerical value of :math:`\xi`, an updated
value for the specific relativistic enthalpy :math:`h_{new}` using:

.. math::
  h_{new} = \frac{\left( \sqrt{\left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j}
  - P \right)^2 - \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} \right)^2}
  \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}{\rho \xi^2},

from which, in turn, an updated value for the hydrostatic pressure :math:`P_{new}` can
also be recovered by means of the ideal gas equation of state. Finally, using the
updated values of all three quantities (i.e. :math:`\rho_{new}`, :math:`h_{new}`,
and :math:`W_{new}`) in conjunction, we are able to reconstruct the updated components of
the spatial velocity (co)vector :math:`v_{k}^{new}`, as measured by observers moving
normal to the spacelike hypersurfaces in the foliation, as:

.. math::
  v_{k}^{new} = \frac{\rho h v_k}{\left( 1 - \gamma_{i j} v^i v^j \right) \rho_{new}
  h_{new} W_{new}^{2}}.

References
----------

.. [Marti2003] J. M. Martí and E. Müller, "Numerical Hydrodynamics in Special
   Relativity", *Living Reviews in Relativity* **6** (7). 2003.

.. [Eulderink1995] F. Eulderink and G. Mellema, "General Relativistic Hydrodynamics
   with a Roe solver", *Astronomy and Astrophysics Supplement Series* **110**: 587-623.
   1995.