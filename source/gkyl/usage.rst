.. _gkyl_usage:

Using gkyl
++++++++++

.. contents::

We now cover the basics of runing gkyl on desktops, clusters, and GPUs. Gkyl can also be used
be used to run any Lua scripts, as well as tools provided within gkyl. We also comment
on some useful tools provided by `ADIOS <https://github.com/ornladios/ADIOS>`_.

Additional details on the contents of the input files can be found in the :ref:`<gkyl_appGeneral>`
and the pages for the :ref:`Vlasov <app_vlasov>`, :ref:`Gyrokinetic <app_gk>` and
:ref:`Moment <app_moment>` Apps.

The :ref:`installation <gkyl_install>` placed the gkyl executable in
``<INSTALL-DIR>/gkylsoft/gkyl/bin/`` (where the default ``<INSTALL-DIR>`` is home, ``~``),
so one typically needs to call gkyl as ``<INSTALL-DIR>/gkylsoft/gkyl/bin/gkyl``. **However**
most users `create an alias <https://linuxize.com/post/how-to-create-bash-aliases/>`_ so one
can simply call ``gkyl``. The documentation assumes such alias unless specified otherwise.

The ``gkyl`` command has a built-in help menu. Access it with

.. code-block:: bash

  gkyl -h

.. _gkyl_usage_run:

Run simulations
---------------

There are three ways of running simulations with gkyl:

- Serial: using a single core/processes/CPU.
- Parallel: running a multi-core simulation (using MPI).
- GPUs: using graphical processing units (GPUs).

The input file has to have some knowledge of which of these
modalities you will use. We provide some examples of each of these below.

.. _gkyl_usage_run_serial:

Serial simulations
^^^^^^^^^^^^^^^^^^

Suppose you have the :doc:`kbm.lua <inputFiles/kbm>` input file for a linear
kinetic ballooning mode (KBM) calculation with gyrokinetics. In the Common section
of the App declaration (i.e. between ``plasmaApp = Plasma.App {`` and
``electron = Plasma.Species {``) there are two variables, ``decompCuts`` and ``useShared``.
The refer to the number of MPI decompositions and the use of MPI shared memory, respectively.

For serial simulations one can remove these from the input file, or ``useShared``
must be set to ``false``, and ``decompCuts`` must be a table with as many 1's as
there are configuration space dimensions (three in this case). That's why the input
file contains:

.. code:: Lua

   decompCuts = {1, 1, 1},   -- Cuts in each configuration direction.
   useShared  = false,       -- If to use shared memory.

Then one can run the input file in serial with the simple command:

.. code:: bash

  gkyl kbm.lua

By the time it completes, after 54 seconds on a 2015 MacbookPro, this simulation will
produce the following output to screen:

.. code-block:: bash
  :linenos:

  Thu Sep 17 2020 22:20:16.000000000
  Gkyl built with 1b66bd4a21e5+
  Gkyl built on Sep 17 2020 22:20:05
  Initializing Gyrokinetic simulation ...
  Initializing completed in 12.9906 sec
  
  Starting main loop of Gyrokinetic simulation ...
  
   Step 0 at time 0. Time step 1.11219e-08. Completed 0%
  0123456789 Step    27 at time 3.00286e-07. Time step 1.11215e-08. Completed 10%
  0123456789 Step    54 at time 6.00559e-07. Time step 1.1121e-08. Completed 20%
  0123456789 Step    80 at time 8.89697e-07. Time step 1.11204e-08. Completed 30%
  0123456789 Step   107 at time 1.18994e-06. Time step 1.11197e-08. Completed 40%
  0123456789 Step   133 at time 1.47904e-06. Time step 1.11189e-08. Completed 50%
  0123456789 Step   160 at time 1.77924e-06. Time step 1.11179e-08. Completed 60%
  0123456789 Step   186 at time 2.06828e-06. Time step 1.11165e-08. Completed 70%
  0123456789 Step   213 at time 2.3684e-06. Time step 1.11145e-08. Completed 80%
  0123456789 Step   239 at time 2.65735e-06. Time step 1.11121e-08. Completed 90%
  0123456789 Step   266 at time 2.94849e-06. Time step 2.27109e-09. Completed 100%
  0
  Total number of time-steps 267
  Solver took				 25.14505 sec   (0.094176 s/step)   (46.493%)
  Solver BCs took 			  2.14804 sec   (0.008045 s/step)   ( 3.972%)
  Field solver took 			  0.58969 sec   (0.002209 s/step)   ( 1.090%)
  Field solver BCs took			  0.20732 sec   (0.000776 s/step)   ( 0.383%)
  Function field solver took		  0.00000 sec   (0.000000 s/step)   ( 0.000%)
  Moment calculations took		 18.12544 sec   (0.067886 s/step)   (33.514%)
  Integrated moment calculations took	  4.57880 sec   (0.017149 s/step)   ( 8.466%)
  Field energy calculations took		  0.03020 sec   (0.000113 s/step)   ( 0.056%)
  Collision solver(s) took		  0.00000 sec   (0.000000 s/step)   ( 0.000%)
  Collision moments(s) took		  0.00000 sec   (0.000000 s/step)   ( 0.000%)
  Source updaters took 			  0.00000 sec   (0.000000 s/step)   ( 0.000%)
  Stepper combine/copy took		  1.39611 sec   (0.005229 s/step)   ( 2.581%)
  Time spent in barrier function		  0.14791 sec   (0.000554 s/step)   ( 0.273%)
  [Unaccounted for]			  1.86320 sec   (0.006978 s/step)   ( 3.445%)
  
  Main loop completed in			 54.08386 sec   (0.202561 s/step)   (   100%)
  
  Thu Sep 17 2020 22:21:23.000000000

These simulation logs contain the following:

.. list-table::

  * - Line 1:
    - start date and time.
  * - Lines 2-3:
    - gkyl repository revision with which this simulation was run, and
      the date on which the executable was built.
  * - Line 9:
    - report the initial time step number, time and initial time step size.
  * - Lines 10-19:
    - report progress every 1% of the simulation (first column).
      Then, every 10% of the simulation time, give the number of time steps taken so far,
      simulation time transcurred, and the latest time step size.
  * - Lines 21-37:
    - give various metrics regarding the time-steps and wall-clock time taken
      by the simulation, and the time spent on various parts of the calculation.
  * - Line 39:
    - Date and time when the simulation finished.

Also, by default gkyl produces a log file with the format ``<input-file-name>_0.log``.
If you wish to disable this set ``logToFile = false,`` in the Common section of the App.

.. _gkyl_usage_run_parallel:

Parallel simulation
^^^^^^^^^^^^^^^^^^^

Show how to run various simulations with MPI (with and without shared memory?)

On many computer clusters where one may run parallel simulations one must submit
scripts in order to submit a job. This jobscript causes the simulation to be queued
so that it runs once resources (i.e. cores, nodes) become available. When resources are
finally available the simulation runs in a compute node (instead of the login node).

Jobscripts for some machines are provided below. Note that the installation
instructions point to :ref:`machine scripts <gkyl_install_machines>` for building gkyl
on each of these computers. If you need assistance with setting up gkyl in a new cluster,
:ref:`see this <gkyl_install_machines_readme>` or feel free to contact the developers.

Sample submit scripts:

- :doc:`NERSC's Cori <inputFiles/jobscript_cori>`.
- :doc:`TACC's Stampede2 <inputFiles/jobscript_stampede2>`.
- :doc:`MIT's Engaging <inputFiles/jobscript_engaging>`.
- :doc:`Princeton's Eddy <inputFiles/jobscript_eddy>`.
- :doc:`Princeton's Adroit <inputFiles/jobscript_adroitCPU>`.

.. _gkyl_usage_run_gpu:

Running on GPUs
^^^^^^^^^^^^^^^

Gkyl is also capable of running on graphical processing units (GPUs) with minimal modifiation
of an input file you would use to run on CPUs. At the moment, if gkyl was built with CUDA
and the node one is performing the computation in has a GPU, it will default to running the
calculation in a GPU. So given an input file `cudaFile.lua`, we would simply run it with

.. code:: bash

  gkyl cudaFile.lua


On clusters is often common to submit scripts that queue the job for running on compute
nodes (when the resources become available). In fact this is often preferable to `ssh`-ing
into a node if that is even possible. Some sample job scripts for running parallel (CPU)
jobs were given in :ref:`the previous section <gkyl_usage_run_parallel>`, and below we
provide some sample jobscripts for submitting GPU jobs:

- :doc:`PPPL's Portal <inputFiles/jobscript_portalGPU>`.
- :doc:`Princeton's Adroit <inputFiles/jobscript_adroitGPU>`.

Some usage and development notes regarding gkyl's GPU capabilities can be found
`in this repository <https://github.com/ammarhakim/gkylgpuhack/tree/master/clusterInfo>`_.


Restarts
--------

Sometimes a simulations ends prematurely (e.g. your job's wallclock time allocation ran out),
or perhaps it ended successfully but now you wish to run it longer. In these cases one can
**restart** the simulation.

The first simulation prints out a number of restart files, those ending in ``_restart.bp``. In
order to begin a second simulation from where the first left off, check the ``tEnd`` and ``nFrame``
variables in the input file. These are defined as absolute times/number of frames, that is, they
specify the final simulation time and number of ouput frames from the beginning of the first
simulation, **not relative to the previous simulation**.

So suppose we run simulation 1 with the following in the App's Common section:

.. code-block:: Lua

  momentApp = Moments.App {
     ...
     tEnd   = 10.0,
     nFrame = 100,
     ...
  }

There are two restart scenarios:

 - If the simulation completes successfully, one must increase ``tEnd`` and ``nFrame`` in order to
   run the second, restart simulation. Otherwise it will just initialize, realize it does not need
   to advance any further, and terminate.
 - The first simulation ended prematurely, so ``tEnd=10.0`` was not reached. One
   can restart the simulation with the same ``tEnd`` and ``nFrame`` and it will simply try to get
   there this second time. Or one can increase ``tEnd`` and ``nFrame`` so the second simulation
   goes farther than the first one intended to.

Once you've made the appropriate edits to the input file the second, restart simulation 
is run by simply appending the word `restart` after the input file, like

.. code: bash

  gkyl inputFile.lua restart

This second, restart simulation will use the ``_restart.bp`` files of the first simulation to
construct an initial condition. **Note** that it will look for the restart files in the same
directory in which the restart simulation is being run, so typically we run restarts in the same
directory as the first simulation.

Handy perks
-----------

Run Lua with gkyl
^^^^^^^^^^^^^^^^^

One can use `gkyl` to run (almost?) any Lua code. Say for example I find code in the
interverse which promises to compute the factors of "Life, the Universe, and Everything"
(who wouldn't want that?). We can take such code, put it in an input file named
:doc:`factors.lua <inputFiles/factors>` and run it with

.. code:: bash

  gkyl factors.lua

Try it! It's free!

gkyl Tools
^^^^^^^^^^

Provide a (very) brief example of using a tool, and give a link to the
:ref:`gkyl Tools <gkyl_tools>` website.

ADIOS tools
^^^^^^^^^^^

ADIOS has two handy tools that one may use to explore data files of a gkyl simulation.
For additional description of ADIOS and these tools see :download:`their documentation <figures/ADIOS-UsersManual-1.13.1.pdf>`.

bpls
~~~~

bpdump
~~~~~~


