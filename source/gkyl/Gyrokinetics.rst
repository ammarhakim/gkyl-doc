.. highlight:: lua

Gyrokinetic model for magnetized plasmas
++++++++++++++++++++++++++++++++++++++++

The ``Gyrokinetic`` app solves the gyrokinetic equation on a
Cartesian grid.

(**MORE TO COME**)

.. contents::

Overall structure of app
------------------------

By CDIM we mean configuration space dimension and by VDIM we mean
velocity space dimension. This app works in 1X1V, 1X2V and 3X2V. The
velocity coordinates are :math:`v_\parallel, \mu`. See [Shi2017]_ for
details.

The overall structure of the app is as follows

.. code-block:: lua

  local Vlasov = require "App.VlasovOnCartGrid"

  vlasovApp = Vlasov.App {  
    -- basic parameters

    -- description of each species: names are arbitrary
    elc = Vlasov.GkSpecies {
      -- species parameters
    },

    -- fields (optional, can be omitted for neutral particles)
    field = Vlasov.GkEsField {  -- or GkEmField
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
       sub-directory.
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
   * - bcx
     - Length two table with BCs in X direction. See details on BCs below.
     - { }
   * - bcy
     - Length two table with BCs in Y direction. Only needed if CDIM>1
     - { }
   * - bcz
     - Length two table with BCs in Z direction. Only needed if CDIM>2
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


References
----------

.. [Shi2017] Shi, E. L., Hammett, G. W., Stolzfus-Dueck, T., &
   Hakim, A. (2017). Gyrokinetic continuum simulation of turbulence in
   a straight open-field-line plasma. Journal of Plasma Physics, 83,
   1–27. http://doi.org/10.1017/S002237781700037X
