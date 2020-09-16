.. highlight:: lua

.. _gkApp:

Gyrokinetic model for magnetized plasmas
++++++++++++++++++++++++++++++++++++++++

The ``Gyrokinetic`` App solves the gyrokinetic system on a
Cartesian grid.

.. contents::

Overall structure of app
------------------------

To set up a gyrokinetic simulation, we first need to load the ``Gyrokinetic`` App package.
This should be done at the top of the input file, via

.. code-block:: lua

  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()

This creates a table ``Plasma`` that loads the gyrokinetic species, fields, etc. packages.

The input file should then contain one or more ``Plasma.Species`` tables,
a ``Plasma.Field`` table, and a ``Plasma.Geometry`` table, which are used to specify
simulation parameters as shown below.

The general structure of the input file is then

.. code-block:: lua

  local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()

  plasmaApp = Plasma.App {  
    -- basic parameters, see [topLevelApp]

    -- description of each species (names, e.g. electron, are arbitrary but used for diagnostics)
    electron = Plasma.Species {
      -- GkSpecies parameters
    },

    -- other species, e.g. ions

    -- fields 
    field = Plasma.Field {  
      -- GkField parameters
    },

    funcField = Plasma.Geometry {
      -- GkGeometry parameters
    },
  }
  -- run application
  plasmaApp:run()

Note that if the app's ``run`` method is not called, the simulation
will not be run, but the simulation will be initialized and the
initial conditions will be written out to file.

By CDIM we mean configuration space dimension and by VDIM we mean
velocity space dimension. This app works in 1X1V, 1X2V and 3X2V. The
velocity coordinates are :math:`v_\parallel, \mu`. See [Shi2017]_ for
details.
  
Species parameters
----------------
  
The following parameters are used to specify species parameters for the gyrokinetic system. 
Parameters that have default values can be omitted. Units are arbitrary, but typically SI units are used.

.. list-table:: GkSpecies Parameters
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - charge
     - Species charge
     - 1.0
   * - mass
     - Species mass
     - 1.0
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
     - **NOT CURRENTLY SUPPORTED**, no processor decomposition in velocity space allowed
     - 
   * - init
     - Function with signature ``function(t,xn)`` that initializes the
       species distribution function. This function must return a
       single value, :math:`f(x,v,t=0)` at ``xn``, which is a NDIM
       vector.
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
