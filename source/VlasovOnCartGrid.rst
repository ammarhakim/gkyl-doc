.. highlight:: lua

VlasovOnCartGrid: Vlasov equations on a Cartesian grid
++++++++++++++++++++++++++++++++++++++++++++++++++++++

The ``VlasovOnCartGrid`` app solves the Vlasov equation on a Cartesian grid.

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

.. contents::

Overall structure of app
------------------------

By CDIM we mean configuration space dimension and by VDIM we mean
velocity space dimension. NDIM = CDIM+VDIM is the phase-space
dimension. Note that we must have VDIM>=CDIM.

The overall structure of the app is as follows

.. code-block:: lua

  local Vlasov = require "App.VlasovOnCartGrid"

  vlasovApp = Vlasov.App {  
    -- basic parameters

    -- description of each species: names are arbitrary
    elc = Vlasov.Species {
      -- species parameters
    },
  }
  -- run application
  vlasovApp:run()

For a complete example, see :doc:`Vlasov app
example <VlasovOnCartGridExample_LD>`.
  
Basic parameters
----------------
  
The app takes the following basic parameters. Parameters that have
default values can be omitted.

.. list-table:: Basic Parameters for ``VlasovOnCartGrid``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - logToFile
     - If set to true, log messages are written to log file
     - true
   * - tEnd
     - End time of simulation
     -
   * - suggestedDt
     - Initial suggested time-step. Adjusted as simulation progresses.
     - tEnd/nFrame
   * - nFrame
     - Number of frames
     -
   * - lower
     - CDIM length table with lower-left configuration space coordinates
     -
   * - upper
     - CDIM length table with upper-right configuration space coordinates
     -
   * - cells
     - CDIM length table with number of configuration space cells
     -
   * - basis
     - Basis functions to use. One of "serendipity" or "maximal-order"
     -
   * - polyOrder
     - Basis function polynomial order
     -
   * - cfl
     - CFL number to use. **This parameter should be avoided and
       cflFrac used instead.**
     - Determined from cflFrac
   * - cflFrac
     - Fraction (usually 1.0) to multiply CFL determined time-step. 
     - Determined from timeStepper
   * - timeStepper
     - One of "rk2" (SSP-RK2), "rk3" (SSP-RK3) or "rk3s4" (SSP-RK3
       with 4 stages). For the last, cflFrac is 2.0
     - "rk3"
   * - ioMethod
     - Method to use for file output. One of "MPI" or "POSIX". When
       "POSIX" is selected, each node writes to its own file in a
       sub-directory.
     - "MPI"
   * - decompCuts
     - CDIM length table with number of processors to use in each
       configuration space direction.
     - { }
   * - useShared
     - Set to ``true`` to use MPI-SHM based shared memory paradigm.
     - false
   * - periodicDirs
     - Periodic directions. Note: X is 1, Y is 2 and Z is 3.
     - { }
   * - bcx
     - Length two table with BCs in X direction. See details on BCs below.
     - { }
   * - bcy
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - { }
   * - bcz
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - { }

.. note::

   - In general, you should not specify ``cfl`` or ``cflFrac``,
     unless either doing tests or explicitly controlling the
     time-step. The app will determine the time-step automatically.
   - When ``useShared=true`` the ``decompCuts`` must specify the
     *number of nodes* and not number of processors. That is, the total
     number of processors will be determined from ``decompCuts`` and
     the number of threads per node.
   - The "rk3s4" time-stepper allows taking twice the time-step as
     "rk2" and "rk3" at the cost of an additional RK stage. Hence,
     with this stepper a speed-up of 1.5X can be expected.


Species parameters
------------------

The Vlasov app works with arbitrary number of species. Each species is
described using the ``Vlasov.Species`` objects. By default every species
in the app is evolved. However, species evolution can be turned off by
setting the ``evolve`` flag to ``false``. Species can be given arbitrary
names. However, the species names are used to label the output data
files and so reasonable names should be used.

.. code-block:: lua

    elc = Vlasov.Species {
      -- species parameters
    },


.. list-table:: Parameters for ``Vlasov.Species``
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - charge
     - Species charge
     -
   * - mass
     - Species mass
     -
   * - lower
     - VDIM length table with lower-left velocity space coordinates
     -
   * - upper
     - VDIM length table with upper-right velocity space coordinates
     -
   * - cells
     - VDIM length table with number of velocity space cells
     -
   * - decompCuts
     - VDIM length table with number of processors to use in each
       velocity space direction.
     - { }
   * - init 
     - Function with signature ``function(t,xn)`` that initializes the
       species distribution function. This function must return a
       single value, :math:`f(x,v,t=0)` at ``xn``, which is a NDIM
       vector.
     -
   * - evolve
     - If set to ``false`` the species distribution function is not
       evolved. In this case, only initial conditions for this species
       will be written to file.
     - true
     
References
----------

.. [Juno2018] Juno, J., Hakim, A., TenBarge, J., Shi, E., & Dorland,
    W.. "Discontinuous Galerkin algorithms for fully kinetic plasmas",
    *Journal of Computational Physics*, **353**,
    110–147, 2018. http://doi.org/10.1016/j.jcp.2017.10.009
