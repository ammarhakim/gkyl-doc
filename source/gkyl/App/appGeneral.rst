.. _gkyl_appBasics:

Input file basics
+++++++++++++++++

.. contents::

Input file structure
--------------------

Although this has been covered in the :ref:`quickstart <qs_main>`, we remind
the reader that most input files have a similar structure regardless of which
model (App) is being used.

On the whole, input files consist of four parts: the **App dependencies**,
the **Preamble**, the **App initialization**, and the **App run**. So most
input files look like

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- App dependencies.
  ...

  --------------------------------------------------------------------------------
  -- Preamble.

  ...

  --------------------------------------------------------------------------------
  -- App initialization.

  ...

  --------------------------------------------------------------------------------
  -- App run.

  ...

We expand on the description of each part in the following sections:

.. raw:: html

  <details>
  <summary><a>App dependencies</a></summary>

  This section loads the App one wishes to use for the simulation. At the moment
  these can be <b>one</b> of VlasovMaxwell, Gyrokinetic <b>or</b> Moments app:

.. code:: lua

  local Plasma = require("App.PlasmaOnCartGrid").VlasovMaxwell() -- Load the Vlasov App.
  local Plasma = require("App.PlasmaOnCartGrid").Gyrokinetic()   -- Load the Gyrokinetic App.
  local Plasma = require("App.PlasmaOnCartGrid").Moments()       -- Load the Moments App.

.. raw:: html

  The App dependencies is also a place to load other libraries or packages, from
  gkyl or elsewhere. So for example, if we wanted to load the <i>Constants</i> library
  from which we can grab universal constants like the speed of light, we could use

.. code:: lua

  local Constants = require "Lib.Constants"   -- Load universal physical Constants.

.. raw:: html

  </details>
  <br>


.. raw:: html

  <details>
  <summary><a>Preamble</a></summary>

  In the Preamble one can declare local variables, functions and any object allowed
  by Lua which may help the user set up the calculation. Often this section is used
  to define user input parameters, calculate quantities derived from these inputs and
  create functions which we may later pass to the App. So for example, the simple
  Landau damping calculation in <a href=https://gkeyll.readthedocs.io/en/latest/quickstart/introduction.html>
  the first quickstart</a> contained the following Preamble:

.. code:: lua

  permitt  = 1.0   -- Permittivity of free space.
  permeab  = 1.0   -- Permeability of free space.
  eV       = 1.0   -- Elementary charge, or Joule-eV conversion factor.
  elcMass  = 1.0   -- Electron mass.
  ionMass  = 1.0   -- Ion mass.
  
  nElc = 1.0    -- Electron number density.
  nIon = nElc   -- Ion number density.
  Te   = 1.0    -- Electron temperature.
  Ti   = Te     -- Ion temperature.
  
  vtElc   = math.sqrt(eV*Te/elcMass)                   -- Electron thermal speed.
  vtIon   = math.sqrt(eV*Ti/ionMass)                   -- Ion thermal speed.
  wpe     = math.sqrt((eV^2)*nElc/(permitt*elcMass))   -- Plasma frequency.
  lambdaD = vtElc/wpe                                  -- Debye length.
  
  -- Amplitude and wavenumber of sinusoidal perturbation.
  pertA = 1.0e-3
  pertK = .750/lambdaD
  
  -- Maxwellian in (x,vx)-space, given the density (denU), bulk flow
  -- velocity (flowU), mass and temperature (temp).
  local function maxwellian1D(x, vx, den, flowU, mass, temp)
     local v2   = (vx - flowU)^2
     local vtSq = temp/mass
     return (den/math.sqrt(2*math.pi*vtSq))*math.exp(-v2/(2*vtSq))
  end

.. raw:: html

  The length and complexity of the Preamble depends on the details of the simulation.

.. raw:: html

  </details>
  <br>



.. raw:: html

  <details>
  <summary><a>App initialization</a></summary>

  After loading the App, and setting up the App preliminaries in the Preabmle, we must
  initialize the App itself. This is accomplished with a table like

.. code:: lua

  local plasmaApp = Plasma.App {
     -----------------------------------------------------------------------------
     -- Common.
     ...

     -----------------------------------------------------------------------------
     -- Species.
     ...

     -----------------------------------------------------------------------------
     -- Fields.
     ...

     -----------------------------------------------------------------------------
     -- ExternalFields.
     ...

     -----------------------------------------------------------------------------
     -- Extras.
     ...
  }


.. raw:: html

  where the name of name following the = sign must equal that used in the App
  dependencies in order to load the App (in this case "Plasma"). The contents of this
  table depend on the specific App being used, although all the Apps have a similar
  structure. They consist of a <b>Common</b>, a <b>Species</b>, a <b>Fields</b>, a 
  <b>ExternalFields</b> and an <b>Extras</b> section:
  <ul>
  <li> <b>Common</b> has parameters that are common to all Apps and control some aspects
  of the simulation, most notably the final simulation time and the frames to ouput.</li>
  <li> <b>Species</b> contains a declaration of each plasma species to be considered
  (e.g. electrons, hydrogen ions, neutrals).</li>
  <li> <b>Fields</b> specifies the electrostatic or electromagnetic fields
  to be included in the simulation.</li>
  <li> <b>ExternalFields</b>: Some simulations also require the specification of (possibly time-dependent) external fields.
      For <a href=https://gkeyll.readthedocs.io/en/latest/gkyl/App/Gk/Gyrokinetics.html> gyrokinetics</a>, parameters and functions pertaining to the magnetic geometry are specified here.</li>
  <li> <b>Extras</b>: there are additional features that some simulations may require.</li>

  </details>
  <br>

.. raw:: html

  <details>
  <summary><a>App run</a></summary>

  Gkyl input files conclude with a call to the <i>run</i> method of the App, in order
  to get the simulation running once the input file is called by the gkyl executable.
  This <b>App run</b> command looks like

.. code:: lua

  plasmaApp:run()

.. raw:: html

  where the name to the left of the : must match the one used in the App initialization
  (plasmaApp in this case).

  </details>
  <br>

.. _gkyl_appBasics_common:

The input file Common
---------------------

As mentioned in the previous section, the **App initialization** has a section called the
**Common**, which contains parameters common to all the Apps. Here we describe what these
possible entries are and their default value (if a default value is not given it means
that **the user must provide this parameter**).


.. list-table:: Parameters in the App's **Common**
   :widths: 20, 60, 20
   :header-rows: 1

   * - Parameter
     - Description
     - Default
   * - tEnd
     - Final simulation time.
     -
   * - lower
     - Table with configuration space coordinates of lower boundaries.
     -
   * - upper
     - Table with configuration space coordinates of upper boundaries.
     -
   * - cells
     - Table with number of cells along configuration space each direction.
     -
   * - nFrame
     - Number of frames of data to write. Initial conditions are always written. 
       For more fine-grained control over species and field output, see below.
     -
   * - periodicDirs
     - Periodic directions. Note: X is 1, Y is 2 and Z is 3.
     - ``{ }``
   * - basis
     - Basis functions to use. One of ``"serendipity"``, ``"tensor"`` or ``"maximal-order"``.
     - ``"serendipity"``
   * - polyOrder
     - Polynomial order of the basis.
     - 0
   * - basis
     - Basis functions to use. One of ``"serendipity"``, ``"tensor"`` or ``"maximal-order"``.
     - ``"serendipity"``
   * - decompCuts
     - Table with number of processors to use in each configuration space direction.
     - ``{ }``
   * - useShared
     - Set to ``true`` to use MPI shared memory.
     - ``false``
   * - maximumDt
     - Largest time step size allowed.
     - ``tEnd-tStart``
   * - suggestedDt
     - Initial suggested time-step. Adjusted as simulation progresses.
     - ``maximumDt``
   * - cflFrac
     - Fraction (usually 1.0) to multiply CFL determined time-step.
     - 1.0, or 2.0 for ``timeStepper = "rk3s4"``.
   * - cfl
     - CFL number to use in determining the time step. **This parameter should be
       avoided and cflFrac used instead.**
     - ``cflFrac/(2*polyOrder+1)`` 
   * - timeStepper
     - One of ``"rk1"`` (first order Runge-Kutta), ``"rk2"`` (SSP-RK2), ``"rk3"``
       (SSP-RK3) or "rk3s4" (SSP-RK3 with 4 stages) or ``"fvDimSplit"``.
     - ``"rk3"``
   * - restartFrameEvery
     - Frequency with which to write restart files, given as a decimal
       fraction. Default is every 5% (=0.05) of the simulation, or as frequently 
       as frames are outputted (whichever is largest).
     - ``max(0.05, 1./nFrame)`` 
   * - ioMethod
     - Method to use for file output. One of ``"MPI"`` or ``"POSIX"``. When ``"POSIX"``
       is selected, each node writes to its own file in a sub-directory.
     - ``"MPI"``
   * - logToFile
     - If set to true, log messages are written to log file.
     - ``true``


.. note::

   - In general, you should not specify ``cfl`` or ``cflFrac``,
     unless either doing tests or explicitly controlling the
     time-step. The app will determine the time-step automatically.
   - The ``"rk3s4"`` time-stepper allows taking twice the time-step as
     ``"rk2"`` and ``"rk3"`` at the cost of an additional RK stage. Hence,
     with this stepper a speed-up of 1.5X can be expected.
   - (**This feature may be superseeded soon**) One can request additional
     parallelism in velocity space for kinetic simulations by setting ``useShared = true``.
     This enables MPI shared memory. In this case the ``decompCuts`` must specify the
     *number of nodes* and not number of processors. That is, the total
     number of processors will be determined from ``decompCuts`` and
     the number of threads per node.

