.. _qs_vlasov1:

Vlasov example
++++++++++++++

In this example, we extend the Vlasov-Maxwell input file shown in :ref:`qs_intro` to simulate a more general kinetic plasma.
Because the Vlasov-Maxwell system of equations is widely applicable in plasma physics, this example is intended to illustrate some of the functionality of the Vlasov-Maxwell solver a user may desire for production science.
For more extensive documentation on all of the available options for Vlasov-Maxwell simulations, we refer the reader to :ref:`app_vlasov`.

This simulation is based on the studies of [Skoutnev2019]_ and [Juno2020]_ and concerns the evolution of instabilities driven by counter-streaming beams of plasma.
This example demonstrates the flexibility of the Vlasov-Maxwell solver by showing how one extends Vlasov-Maxwell simulations to higher dimensionality, in this case 2x2v.
The input file for this example is also a standard performance benchmark for Gkeyll and timings for this input file with varying grid resolution can be found in the gkyl repo in the Benchmarks/ folder.

.. contents::

Physics model and initial conditions
------------------------------------

This example solves the Vlasov-Maxwell system of equations

.. math::

  \frac{\partial f_s}{\partial t} &+ \mathbf{v}\cdot\nabla f_s + \frac{q_s}{m_s}
  \left(\mathbf{E}+\mathbf{v}\times\mathbf{B}\right)\cdot\nabla_{\mathbf{v}}f = 0, \\
  \frac{\partial\mathbf{B}}{\partial t} &+ \nabla\times\mathbf{E} = 0, \\
  \epsilon_0\mu_0\frac{\partial\mathbf{E}}{\partial t} &- \nabla\times\mathbf{B} = -\mu_0\mathbf{J},

in two spatial dimensions and two velocity dimensions (2x2v).
For this example, the ions are taken to be a stationary, neutralizing background, and therefore do not contribute to the plasma current :math:`\mathbf{J}`.
The electrons are initialized as two equal density, equal temperature, counter-propagating, Maxwellian beams

.. math::

  f_e (x, y, v_x, v_y) = \frac{m_e n_0 }{2 \pi T_e} \left [ \exp \left (- m_e \frac{(v_x)^2 + (v_y - u_d)^2}{2 T_e} \right ) + \exp \left (- m_e \frac{(v_x)^2 + (v_y + u_d)^2}{2 T_e} \right ) \right ].

The electromagnetic fields are initialized as a bath of fluctuations in the electric and magnetic fields in the two configuration space dimensions,

.. math::

  B_z(t=0)=\sum_{n_x,n_y=-N,-N}^{N,N}\tilde B_{n_x,n_y}\sin \left (\frac{2\pi n_x x}{L_x}+\frac{2\pi n_y y}{L_y}+\tilde \phi_{n_x,n_y} \right ),

where :math:`N=16` and :math:`\tilde B_{n_x,n_y}` and :math:`\tilde \phi_{n_x,n_y}` are random amplitudes and phases. 
The electric fields, :math:`E_x, E_y` are initialized similarly.
Note that the sum goes from :math:`-N` to :math:`N` so as to initialize phases from 0 degrees to 180 degrees.

Input file
----------

The full Lua input file (found :doc:`here <inputFiles/vm-tsw-2x2v>`) has three components: the **App dependencies**, the **Preamble**, and the **App**.
In the **App dependencies** section, we load the necessary components of Gkeyll to perform a Vlasov-Maxwell simulation, as well as any additional functionality we require:

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- App dependencies
  --------------------------------------------------------------------------------
  -- Load the Vlasov-Maxwell App
  local Plasma = require("App.PlasmaOnCartGrid").VlasovMaxwell()
  -- Pseudo-random number generator from SciLua package for initial conditions.
  -- Specific rng is the mrg32k3a (multiple recursive generator) of Ecuyer99.
  local prng = require "sci.prng"
  local rng = prng.mrg32k3a()

The **Preamble** to set up the initial conditions is:

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Preamble
  --------------------------------------------------------------------------------
  -- Constants
  permitt = 1.0                               -- Permittivity of free space
  permeab = 1.0                               -- Permeability of free space
  lightSpeed = 1.0/math.sqrt(permitt*permeab) -- Speed of light
  chargeElc = -1.0                            -- Electron charge
  massElc = 1.0                               -- Electron mass

  -- Initial conditions
  -- 1 = Right-going beam; 2 = Left-going beam.
  nElc1 = 0.5
  nElc2 = 0.5

  ud = 0.1                                    -- Drift velocity of beams
  uxElc1 = 0.0
  uyElc1 = ud
  uxElc2 = 0.0
  uyElc2 = -ud

  R = 0.1                                     -- Ratio of thermal velocity to drift velocity
  TElc1 = massElc*(R*ud)^2
  TElc2 = massElc*(R*ud)^2
  vthElc1 = math.sqrt(TElc1/massElc)
  vthElc2 = math.sqrt(TElc2/massElc)

  k0_TS = 6.135907273413176                   -- Wavenumber of fastest growing two-stream mode 
  theta = 90.0/180.0*math.pi                  -- 0 deg is pure Weibel, 90 deg is pure two-stream
  kx_TS = k0_TS*math.cos(theta)
  ky_TS = k0_TS*math.sin(theta)

  k0_Weibel = 2.31012970008316                -- Wavenumber of fastest growing Weibel mode 
  theta = 0.0/180.0*math.pi                   -- 0 deg is pure Weibel, 90 deg is pure two-stream
  kx_Weibel = k0_Weibel*math.cos(theta)
  ky_Weibel = k0_Weibel*math.sin(theta)
  kx = k0_Weibel
  ky = k0_TS/3.0  

  perturb_n = 1e-8
  -- Perturbing the first 16 wave modes with random amplitudes and phases.
  -- Note that loop goes from -N to N to sweep all possible phases.
  N=16
  P={}
  for i=-N,N,1 do
     P[i]={}
     for j=-N,N,1 do
        P[i][j]={}
        for k=1,6,1 do         
          P[i][j][k]=rng:sample()
        end
     end
  end

  -- Domain size and number of cells
  Lx = 2*math.pi/kx
  Ly = 2*math.pi/ky
  Nx = 16
  Ny = 16
  vLimElc = 3*ud                              -- Maximum velocity in velocity space
  NvElc = 16

  -- Maxwellian in 2x2v
  local function maxwellian2D(n, vx, vy, ux, uy, vth)
     local v2 = (vx - ux)^2 + (vy - uy)^2
     return n/(2*math.pi*vth^2)*math.exp(-v2/(2*vth^2))
  end

The **Preamble** defines the constants in the normalization standard outlined in :ref:`vlasovNorm` and sets the parameters and perturbations to the wave modes of interest for the study.
Note that because the dimensionality of the simulation is now 2x2v, the normalization of the Maxwellian has correspondingly changed from the 1x1v Langmuir wave simulation described in :ref:`qs_intro`.

The **App** can be further subdivided into a number of sections

.. code-block:: lua

  plasmaApp = Plasma.App {
     -----------------------------------------------------------------------------
     -- Common
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Species
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Fields
     -----------------------------------------------------------------------------
     ...
  }
  --------------------------------------------------------------------------------
  -- Run application
  --------------------------------------------------------------------------------
  plasmaApp:run()

The **Common** section of the **App** defines input parameters which will be utilized by all solvers in the simulation.
For example, the configuration space extents and number of configuration space cells (:code:`lower, upper, cells`), as well as what directions, if any, utilize periodic boundary conditions (:code:`periodicDirs`), and how to parallelize the simulation (:code:`decompCuts,useShared`).

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Common
  --------------------------------------------------------------------------------
  logToFile = true,

  tEnd = 50.0,                             -- End time
  nFrame = 1,                              -- Number of output frames
  lower = {0.0,0.0},                       -- Lower boundary of configuration space
  upper = {Lx,Ly},                         -- Upper boundary of configuration space
  cells = {Nx,Ny},                         -- Configuration space cells
  basis = "serendipity",                   -- One of "serendipity", "maximal-order", or "tensor"
  polyOrder = 2,                           -- Polynomial order
  timeStepper = "rk3s4",                   -- One of "rk2", "rk3", or "rk3s4"

  -- MPI decomposition for configuration space
  decompCuts = {1,1},                      -- Cuts in each configuration direction
  useShared = true,                        -- If using shared memory

  -- Boundary conditions for configuration space
  periodicDirs = {1,2},                    -- periodic directions (both x and y)

  -- Integrated moment flag, compute integrated quantities 1000 times in simulation
  calcIntQuantEvery = 0.001,

The **Species** section of the **App** defines the species-specific inputs for the Vlasov-Maxwell simulation within a :code:`Plasma.Species` table.
For example, the velocity space extents and number of velocity space cells (:code:`lower, upper, cells`), the function which prescribes the initial condition, and the types of diagnostics.
More discussion of diagnostic capabilities can be found in :ref:`app_vlasov`.

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Electrons
  --------------------------------------------------------------------------------
  elc = Plasma.Species {
    charge = chargeElc, mass = massElc,
    -- Velocity space grid
    lower = {-vLimElc, -vLimElc},
    upper = {vLimElc, vLimElc},
    cells = {NvElc, NvElc},
    -- Initial conditions
    init = function (t, xn)
       local x, y, vx, vy = xn[1], xn[2], xn[3], xn[4]
       local fv = maxwellian2D(nElc1, vx, vy, uxElc1, uyElc1, vthElc1) +
          maxwellian2D(nElc2, vx, vy, uxElc2, uyElc2, vthElc2)
      return fv
    end,
    evolve = true,
    diagnosticMoments = {"M0","M1i","M2ij","M3i"},
    diagnosticIntegratedMoments = {"intM0","intM1i","intM2Flow","intM2Thermal"},
  },

Note that for this particular simulation the ions are a stationary, neutralizing background that does not contribute to the plasma current, so we only require a species table for the electrons.

The **Field** section if the final section of the **App** and specifies the input parameters for the field equation, in this case Maxwell's equation, in the :code:`Plasma.Field` table.
For example, similar to the :code:`Plasma.Species` table, the :code:`Plasma.Field` table contains the initial condition for the electromagnetic field.

.. code-block:: lua

  --------------------------------------------------------------------------------
  -- Field solver
  --------------------------------------------------------------------------------
  field = Plasma.Field {
    epsilon0 = permitt, mu0 = permeab,
    init = function (t, xn)
       local x, y = xn[1], xn[2]
       local E_x, E_y, B_z = 0.0, 0.0, 0.0
       for i=-N,N,1 do
          for j=-N,N,1 do
             if i~=0 or j~=0 then          
                E_x = E_x + perturb_n*P[i][j][1]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][2])
                E_y = E_y + perturb_n*P[i][j][3]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][4])
                B_z = B_z + perturb_n*P[i][j][5]*math.sin(i*kx*x+j*ky*y+2*math.pi*P[i][j][6])
             end
          end
       end
       return E_x, E_y, 0.0, 0.0, 0.0, B_z
    end,
    evolve = true,
  },

Postprocessing
--------------

The input file :code:`vm-tsw-2x2v.lua` can be run using the gkyl executable

.. code-block:: bash

  gkyl vm-tsw-2x2v.lua

assuming :code:`gkyl` has been aliased to the location of the executable.
A complete run of this simulation will output the following text to the terminal.

.. code-block:: bash

  Wed Sep 16 2020 11:38:54.000000000
  Gkyl built with a4430cbb5d93
  Gkyl built on Sep 16 2020 01:25:31
  Initializing PlasmaOnCartGrid simulation ...
  Using CFL number 0.4
  Initializing completed in 1.39731 sec

  Starting main loop of PlasmaOnCartGrid simulation ...

  Step 0 at time 0. Time step 0.0360652. Completed 0%
  0123456789 Step   139 at time 5.01307. Time step 0.0360652. Completed 10%
  0123456789 Step   278 at time 10.0261. Time step 0.0360652. Completed 20%
  0123456789 Step   416 at time 15.0031. Time step 0.0360652. Completed 30%
  0123456789 Step   555 at time 20.0162. Time step 0.0360652. Completed 40%
  0123456789 Step   694 at time 25.0293. Time step 0.0360652. Completed 50%
  0123456789 Step   832 at time 30.0063. Time step 0.0360652. Completed 60%
  0123456789 Step   971 at time 35.0193. Time step 0.0360652. Completed 70%
  0123456789 Step  1110 at time 40.0324. Time step 0.0360652. Completed 80%
  0123456789 Step  1248 at time 45.0094. Time step 0.0360652. Completed 90%
  0123456789 Step  1387 at time 50. Time step 0.0136003. Completed 100%
  0
  Total number of time-steps 1388
  Number of barriers 116062 barriers (83.6182 barriers/step)

  Solver took                           699.52738 sec     (0.503982 s/step)   (76.289%)
  Solver BCs took                       5.13684 sec       (0.003701 s/step)   ( 0.560%)
  Field solver took                     1.68614 sec       (0.001215 s/step)   ( 0.184%)
  Field solver BCs took                 0.30194 sec       (0.000218 s/step)   ( 0.033%)
  Function field solver took            0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Moment calculations took              105.12776 sec     (0.075740 s/step)   (11.465%)
  Integrated moment calculations took   54.01177 sec      (0.038913 s/step)   ( 5.890%)
  Field energy calculations took        0.05532 sec       (0.000040 s/step)   ( 0.006%)
  Collision solver(s) took              0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Collision moments(s) took             0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Source updaters took                  0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Stepper combine/copy took             56.49974 sec      (0.040706 s/step)   ( 6.162%)
  Time spent in barrier function        0.48815 sec       (0.000352 s/step)   (     0%)
  [Unaccounted for]                     -5.39741 sec      (-0.003889 s/step)   (-0.589%)

  Main loop completed in      916.94948 sec   (0.660626 s/step)   (   100%)

This example was run with a single core of a 10th gen Intel i9 (Comet Lake) processor.
Increasing the resolution to :math:`32^2 \times 32^2` and now running the simulation using all 10 cores of the Intel i9 using

.. code-block:: bash

  ~/gkylsoft/openmpi/bin/mpirun -n 10 ~/gkylsoft/gkyl/bin/gkyl vm-tsw-2x2v.lua

we obtain the following performance with :code:`useShared=true` and the installed MPI from the Gkeyll build

.. code-block:: bash

  Wed Sep 16 2020 19:14:03.000000000
  Gkyl built with a4430cbb5d93
  Gkyl built on Sep 16 2020 01:25:31
  Initializing PlasmaOnCartGrid simulation ...
  Using CFL number 0.4
  Initializing completed in 3.50176 sec
  Starting main loop of PlasmaOnCartGrid simulation ...
  Step 0 at time 0. Time step 0.0180326. Completed 0%
  0123456789 Step   278 at time 5.01307. Time step 0.0180326. Completed 10%
  0123456789 Step   555 at time 10.0081. Time step 0.0180326. Completed 20%
  0123456789 Step   832 at time 15.0031. Time step 0.0180326. Completed 30%
  0123456789 Step  1110 at time 20.0162. Time step 0.0180326. Completed 40%
  0123456789 Step  1387 at time 25.0112. Time step 0.0180326. Completed 50%
  0123456789 Step  1664 at time 30.0063. Time step 0.0180326. Completed 60%
  0123456789 Step  1941 at time 35.0013. Time step 0.0180326. Completed 70%
  0123456789 Step  2219 at time 40.0144. Time step 0.0180326. Completed 80%
  0123456789 Step  2496 at time 45.0094. Time step 0.0180326. Completed 90%
  0123456789 Step  2773 at time 50. Time step 0.0136003. Completed 100%
  0
  Total number of time-steps 2774
  Number of barriers 220012 barriers (79.3122 barriers/step)
  Solver took                           3209.08362 sec    (1.156843 s/step)   (54.918%)
  Solver BCs took                       83.27781 sec      (0.030021 s/step)   ( 1.425%)
  Field solver took                     3.61164 sec       (0.001302 s/step)   ( 0.062%)
  Field solver BCs took                 1.40878 sec       (0.000508 s/step)   ( 0.024%)
  Function field solver took            0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Moment calculations took              289.90340 sec     (0.104507 s/step)   ( 4.961%)
  Integrated moment calculations took   101.71780 sec     (0.036668 s/step)   ( 1.741%)
  Field energy calculations took        0.11471 sec       (0.000041 s/step)   ( 0.002%)
  Collision solver(s) took              0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Collision moments(s) took             0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Source updaters took                  0.00000 sec       (0.000000 s/step)   ( 0.000%)
  Stepper combine/copy took             1251.96865 sec    (0.451323 s/step)   (21.425%)
  Time spent in barrier function        174.33926 sec     (0.062848 s/step)   (     3%)
  [Unaccounted for]                     902.31721 sec     (0.325277 s/step)   (15.442%)
  Main loop completed in                5843.40363 sec    (2.106490 s/step)   (   100%)

The :math:`32^2 \times 32^2` higher resolution simulation is ~3.2 times more expensive per time-step than the :math:`16^2 \times 16^2`.
This cost difference corresponds to a speed-up of a factor of five compared to the expected cost of a serial simulation (16 times more grid cells and only 3.2 times more expensive).

References
----------

.. [Skoutnev2019] Skoutnev, V., Hakim, A., Juno, J., & TenBarge,
  J. M. (2019). "Temperature-Dependent Saturation of Weibel-Type
  Instabilities in Counter-streaming Plasmas", *Astrophysical Journal
  Letters*, **872**, (2). https://doi.org/10.3847%2F2041-8213%2Fab0556

.. [Juno2020] Juno, J., Swisdak, M. M., TenBarge. J. M., Skoutnev, V., & Hakim, A. 
  "Noise-induced magnetic field saturation in kinetic simulations", *Journal of Plasma Physics*,
  **86**, (4). https://doi.org/10.1017/S0022377820000707