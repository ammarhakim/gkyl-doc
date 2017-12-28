VlasovOnCartGrid: Vlasov equations on a Cartesian grid
++++++++++++++++++++++++++++++++++++++++++++++++++++++

The `VlasovOnCartGrid` app solves the Vlasov equation on a Cartesian grid.

.. math::

   \frac{\partial f_s}{\partial t} +
   \nabla_{\mathbf{x}}\cdot(\mathbf{v}f_s)
   +
   \nabla_{\mathbf{v}}\cdot(\mathbf{a}_sf_s)
   =
   \sum_{s'} C[f_s,f_{s'}]

where :math:`f_s` the *particle* distribution function,
:math:`\mathbf{a}_s` is particle acceleration and
:math:`C[f_s,f_{s'}]` are collisions. This app uses a version of the
discontinuous Galerkin (DG) scheme to discretize the phase-space
advection, and Strong Stability-Preserving Runge-Kutta (SSP-RK)
schemes to discretize the time derivative. We use a *matrix and
quadrature free* version of the algorithm described in [Juno2018]_
which should be consulted for details of the numerics the properties
of the discrete system.

For neutral particles, the acceleration can be set to zero. For
electromagnetic (or electrostatic) problems, the acceleration is due
to the Lorentz force:

.. math::

   \mathbf{a}_s = \frac{q_s}{m_s}\left(\mathbf{E} + \mathbf{v}\times\mathbf{B}\right)

The electromagnetic fields can be either specified, or determined from
Maxwell or Poisson equations.


References
----------

.. [Juno2018] Juno, J., Hakim, A., TenBarge, J., Shi, E., & Dorland,
    W.. "Discontinuous Galerkin algorithms for fully kinetic plasmas",
    *Journal of Computational Physics*, **353**,
    110–147, 2018. http://doi.org/10.1016/j.jcp.2017.10.009
