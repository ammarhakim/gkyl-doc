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
indices are implicitly summed over) is assumed throughout, and the Latin indices
:math:`i, j, k, l` range over the spatial coordinate directions
:math:`\left\lbrace 1, \dots 3 \right\rbrace` only.

Reconstruction for the ideal gas equation of state
--------------------------------------------------

References
----------

.. [Marti2003] J. M. Martí and E. Müller, "Numerical Hydrodynamics in Special
   Relativity", *Living Reviews in Relativity* **6** (7). 2003.

.. [Eulderink1995] F. Eulderink and G. Mellema, "General Relativistic Hydrodynamics
   with a Roe solver", *Astronomy and Astrophysics Supplement Series* **110**: 587-623.
   1995.