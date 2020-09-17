.. highlight:: lua

.. _app_vlasov:

VlasovMaxwell App: Vlasov-Maxwell equations on a Cartesian grid
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The ``VlasovMaxwell`` app solves the Vlasov equation on a Cartesian
grid.

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
advection, and :ref:`sspRK` (SSP-RK) to discretize the time derivative. We use a
*matrix and quadrature free* version of the algorithm described in
[Juno2018]_ which should be consulted for details of the numerics the
properties of the discrete system.

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

    -- fields (optional, can be omitted for neutral particles)
    field = Vlasov.EmField {
      -- field parameters
    },
  }
  -- run application
  vlasovApp:run()

Note that if the app's ``run`` method is not called, the simulation
will not be run, but the simulation will be initialized and the
initial conditions will be written out to file.
  
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
     - Number of frames of data to write. Initial conditions are
       always written. For more fine-grained control over species and
       field output, see below.
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
       sub-directory. Depending on your system "MPI_LUSTRE" may be
       available and, if so, should be preferred.
     - "MPI"
   * - decompCuts
     - CDIM length table with number of processors to use in each
       configuration space direction.
     - { }
   * - useShared
     - Set to ``true`` to use shared memory.
     - false
   * - periodicDirs
     - Periodic directions. Note: X is 1, Y is 2 and Z is 3.
     - { }
   * - field
     - Type of field solver to use. See details below. This is
       optional and if not specified no force terms will be evolved,
       i.e. the particles will be assumed to be neutral.
     - nil
   * - *species-name*
     - Species objects. There can be more than one of these. See
       details below.
     - 

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

**Note that the field object must be called "field".** You can also
omit the field object completely. In this case, it will be assumed
that you are evolving neutral particles and the acceleration will be
set to zero (i.e. :math:`\mathbf{a}_s = 0` in the Vlasov equation).

Only one field object (if not omitted) is required. At present, the
app supports a EM field evolved with Maxwell equations, or a EM field
specified as a time-dependent function.
     
Species parameters
------------------

The Vlasov app works with arbitrary number of species. Each species is
described using the ``Vlasov.Species`` objects. By default every
species in the app is evolved. However, species evolution can be
turned off by setting the ``evolve`` flag to ``false``. Species can be
given arbitrary names. As the species names are used to label the
output data files, reasonable names should be used.

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
   * - nDistFuncFrame
     - These many distribution function outputs will be written during
       simulation. If not specified, top-level ``nFrame`` parameter
       will be used
     - ``nFrame`` from top-level
   * - nDiagnosticFrame
     - These many diagnostics outputs (moments etc) will be written
       during simulation. If not specified, top-level ``nFrame``
       parameter will be used
     - ``nFrame`` from top-level
   * - charge
     - Species charge (ignored for neutral particles)
     -
   * - mass
     - Species mass (ignored for neutral particles)
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
   * - bcx
     - Length two table with BCs in X direction. See details on BCs below.
     - { }
   * - bcy
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - { }
   * - bcz
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - { }     
   * - evolve
     - If set to ``false`` the species distribution function is not
       evolved. In this case, only initial conditions for this species
       will be written to file.
     - true
   * - diagnosticMoments
     - List of moments to compute for diagnostics. See below for list
       of moments supported.
     - { }

The supported diagnostic moments are, "M0", "M1i", "M2ij", "M2" and
"M3i" defined by

.. math::

   M0 &= \int f \thinspace dv \\
   M1i &= \int v_i f \thinspace dv \\
   M2ij &= \int v_i v_j f \thinspace dv \\
   M2 &= \int v^2 f \thinspace dv \\
   M3i &= \int v^2 v_i f \thinspace dv

In these diagnostics, the index :math:`i,j` run over :math:`1\ldots
VDIM`.

The boundary conditions (if not periodic) are specified with the
``bcx`` etc. tables. Each table must have exactly two entries, one for
BC on the lower edge and one for the upper edge. The supported values
are

.. list-table:: Boundary conditions for ``Vlasov.Species``
   :widths: 30, 70
   :header-rows: 1

   * - Parameter
     - Description
   * - Vlasov.Species.bcAbsorb
     - All outgoing particles leave the domain, and none reenter.
   * - Vlasov.Species.bcOpen
     - A zero-gradient BC, approximating an open domain
   * - Vlasov.Species.bcReflect
     - Particles are specularly reflected (i.e. billiard ball reflection)

Note that often "reflection" boundary condition is used to specify a
symmetry for particles.
       
For example, for a 1x simulation, to specify that the left boundary is
a reflector, while the right an absorber use:

.. code-block:: lua

   bcx = { Vlasov.Species.bcReflect, Vlasov.Species.bcAbsorb }
       
Electromagnetic field parameters
--------------------------------

The EM field object is used as follows

.. code-block:: lua

    field = Vlasov.EmField {
      -- field parameters
    },


.. list-table:: Parameters for EM field objects
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - nFrame
     - These many field outputs will be written during simulation. If
       not specified, top-level ``nFrame`` parameter will be used
     - ``nFrame`` from top-level
   * - epsilon0
     - Vacuum permittivity (:math:`\epsilon_0`)
     -
   * - mu0
     - Vacuum permeability (:math:`\mu_0`)
     -
   * - mgnErrorSpeedFactor
     - Factor specifying speed for magnetic field divergence error correction
     - 0.0
   * - elcErrorSpeedFactor
     - Factor specifying speed for electric field divergence error correction
     - 0.0
   * - hasMagneticField
     - Flag to indicate if there is a magnetic field
     - true
   * - init
     - Function with signature ``function(t,xn)`` that initializes the
       field. This function must return 6 values arranged as
       :math:`E_x, E_y, E_z, B_x, B_y, B_z` at :math:`t=0` at ``xn``,
       which is a CDIM vector.
     -
   * - bcx
     - Length two table with BCs in X direction. See details on BCs below.
     - { }
   * - bcy
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - { }
   * - bcz
     - Length two table with BCs in Z direction. Only needed if CDIM>2
     - { }
   * - evolve
     - If set to ``false`` the field is not evolved. In this case,
       only initial conditions will be written to file.
     - true

**Note**: When doing an electrostatic problem with no magnetic field,
set the ``hasMagneticField`` to ``false``. This will choose
specialized solvers that are much faster and can lead to significant
gain in efficiency.

The boundary conditions (if not periodic) are specified with the
``bcx`` etc. tables. Each table must have exactly two entries, one for
BC on the lower edge and one for the upper edge. The supported values
are

.. list-table:: Boundary conditions for ``Vlasov.EmField``
   :widths: 30, 70
   :header-rows: 1

   * - Parameter
     - Description
   * - Vlasov.EmField.bcOpen
     - A zero-gradient BC, approximating an open domain
   * - Vlasov.EmField.bcReflect
     - Perfect electrical conductor wall

Functional field parameters
---------------------------

To peform "test-particle" simulation one can specify a time-dependent
electromagnetic field which does not react to particle currents.

.. code-block:: lua

    field = Vlasov.FuncField {
      -- field parameters
    },

.. list-table:: Parameters for functional field objects
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - nFrame
     - These many field outputs will be written during simulation. If
       not specified, top-level ``nFrame`` parameter will be used
     - ``nFrame`` from top-level
   * - emFunc
     - Function with signature ``function(t, xn)`` that specifies
       time-dependent EM field. It should return six values, in order,
       :math:`E_x, E_y, E_z, B_x, B_y, B_z`.
     - 
   * - evolve
     - If set to ``false`` the field is not evolved. In this case,
       only initial conditions will be written to file.
     - true

App output
----------

The app will write distribution function for each species and the EM
fields at specified time intervals. Depending on input parameters
specified to the species and field block, different number of
distribution functions, fields and diagnostics (moments, integrated
quantities) will be written.

The output format is `ADIOS BP
<https://www.olcf.ornl.gov/center-projects/adios/>`_ files. Say your
input file is called "vlasov.lua" and your species are called "elc"
and "ion". Then, the app will write out the following files:

- ``vlasov_elc_N.bp``
- ``vlasov_ion_N.bp``
- ``vlasov_field_N.bp``

Where ``N`` is the frame number (frame 0 is the initial
conditions). Note that if a species or the field is not evolved, then
only initial conditions will be written.

In addition to the above, optionally diagnostic data may also be
written. For example, the moments files are named:

- ``vlasov_elc_M0_N.bp``
- ``vlasov_ion_M0_N.bp``
- ``vlasov_elc_M1i_N.bp``
- ``vlasov_ion_M1i_N.bp``

etc, depending on the entries in the ``diagnosticMoments`` table for
each species. In addition, integrated moments for each species are
written:

- ``vlasov_elc_intMom_N.bp``

This file has the time-dependent "M0", three contributions of kinetic
energy and the "M2" (integrated over configuration space) stored in
them.

For the field, the electromagnetic energy components :math:`E_x^2`,
:math:`E_y^2`, :math:`E_z^2`, :math:`B_x^2`, :math:`B_y^2`, and
:math:`B_z^2` (integrated over configuration space) are stored in the
file:

- ``vlasov_fieldEnergy_N.bp``

These can be plotted using postgkyl in the usual way.

Examples
--------

- :doc:`Advection in a potential well <pot-well>` (Field not evolved)
- :doc:`Landau damping of Langmuir waves <es-landau-damp>`  
- :doc:`Two-stream instability <es-two-stream>`
- :doc:`Three species electrostatic shock problem
  <al-ion-es-shock>`. See [Pusztai2018]_ for full problem description.
- :doc:`Advection of particles in a constant magnetic field
  <adv-const-mag>`. (Field not evolved)
- :doc:`Weibel instability in 1x2v <weibel-1x2v>`. See [Cagas2017]_
  for full problem description.

References
----------

.. [Juno2018] Juno, J., Hakim, A., TenBarge, J., Shi, E., & Dorland,
    W.. "Discontinuous Galerkin algorithms for fully kinetic plasmas",
    *Journal of Computational Physics*, **353**,
    110–147, 2018. http://doi.org/10.1016/j.jcp.2017.10.009

.. [Pusztai2018] I Pusztai, J M TenBarge, A N Csapó, J Juno, A Hakim,
   L Yi and T Fülöp "Low Mach-number collisionless electrostatic
   shocks and associated ion acceleration". Plasma
   Phys. Control. Fusion **60**
   035004, 2018. https://doi.org/10.1088/1361-6587/aaa2cc

.. [Cagas2017] P. Cagas, A. Hakim, W. Scales, and
   B. Srinivasan, "Nonlinear saturation of the Weibel
   instability. Physics of Plasmas", **24** (11), 112116–8, 2017
   http://doi.org/10.1063/1.4994682
