.. _gkyl_usage:

Using gkyl
++++++++++

..
  contents::

We now cover the basics of runing gkyl on desktops, clusters, and GPUs. Gkyl can also be used
be used to run any Lua scripts, as well as tools provided within gkyl. We also comment
on some useful tools provided by `ADIOS <https://github.com/ornladios/ADIOS>`_.

Additional details on the contents of the input files can be found in the
:ref:`Input file file basics <gkyl_appBasics>` page and the pages for the
:ref:`Vlasov <app_vlasov>`, :ref:`Gyrokinetic <app_gk>` and :ref:`Moment <app_moments>` Apps.

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

Suppose you have the :doc:`gk-sheath.lua <inputFiles/gk-sheath>` input file for simple 3D
gyrokinetic calculation with sheaths at the z-boundaries and a source in the middle (along z).
In the Common section of the App declaration (i.e. between ``plasmaApp = Plasma.App {`` and
``electron = Plasma.Species {``) there are two variables, ``decompCuts`` and ``parallelizeSpecies``.
The refer to the number of MPI/NCCL decompositions and whether to parallelize amongst
species, respectively.

For serial simulations one can remove these from the input file, or ``parallelizeSpecies``
must be set to ``false``, and ``decompCuts`` must be a table with as many 1's as
there are configuration space dimensions (three in this case). That's why the input
file contains:

.. code:: Lua

  plasmaApp = Plasma.App {
     ...
     decompCuts = {1, 1, 1},       -- Parallel decomposition in each position dimension.
     parallelizeSpecies = false,   -- =True to parallelize amongst species.
     ...
  }

Then one can run the input file in serial with the simple command:

.. code:: bash

  gkyl gk-sheath.lua

By the time it completes, after 54 seconds on a 2015 MacbookPro, this simulation will
produce the following output to screen:

.. code-block:: bash
  :linenos:

  Wed Nov 22 2023 06:21:32.000000000
  Gkyl built with ba9804d818a0+
  Gkyl built on Nov 22 2023 05:53:12
  Initializing Gyrokinetic simulation ...
  ...Initializing the geometry...
  ...Finished initializing the geometry
  Initialization completed in 0.682254 sec
  
  Starting main loop of Gyrokinetic simulation ...
  
   Step 0 at time 0. Time step 3.85131e-09. Completed 0%
  0123456789 Step    181 at time  1.0034559e-06.  Time step  5.772559e-09.  Completed 10%
  0123456789 Step    354 at time  2.0008187e-06.  Time step  5.786316e-09.  Completed 20%
  0123456789 Step    526 at time  3.0054393e-06.  Time step  5.887145e-09.  Completed 30%
  0123456789 Step    694 at time  4.0039870e-06.  Time step  5.969119e-09.  Completed 40%
  0123456789 Step    863 at time  5.0043606e-06.  Time step  5.878178e-09.  Completed 50%
  0123456789 Step   1034 at time  6.0043831e-06.  Time step  5.826699e-09.  Completed 60%
  0123456789 Step   1206 at time  7.0044600e-06.  Time step  5.808335e-09.  Completed 70%
  0123456789 Step   1378 at time  8.0036796e-06.  Time step  5.814198e-09.  Completed 80%
  0123456789 Step   1550 at time  9.0054347e-06.  Time step  5.836166e-09.  Completed 90%
  0123456789 Step   1720 at time  1.0000000e-05.  Time step  5.867871e-09.  Completed 100%
  0
  
  Total number of time-steps 1721
     Number of forward-Euler calls 5160
     Number of RK stage-2 failures 0
     Number of RK stage-3 failures 0
  
  Initialization took                            0.68225 s   ( 0.000000 s/step)   ( 0.313%)
  Time loop took                               217.07308 s   ( 0.126132 s/step)   (99.687%)
    - dydt took                                189.46968 s   ( 0.110093 s/step)   (87.010%)
      * moments:                                 5.94806 s   ( 0.003456 s/step)   ( 2.732%)
      * cross moments:                           0.03912 s   ( 0.000023 s/step)   ( 0.018%)
      * field solver:                            0.63576 s   ( 0.000369 s/step)   ( 0.292%)
      * external field solver:                   0.00000 s   ( 0.000000 s/step)   ( 0.000%)
      * species advance:                       182.63234 s   ( 0.106120 s/step)   (83.870%)
        > collisionless:                        65.12254 s   ( 0.037840 s/step)   (29.906%)
        > collisions:                           17.88435 s   ( 0.010392 s/step)   ( 8.213%)
        > boundary flux:                        91.90787 s   ( 0.053404 s/step)   (42.207%)
        > sources:                               4.30072 s   ( 0.002499 s/step)   ( 1.975%)
        > [Unaccounted]                          3.41686 s   ( 0.001985 s/step)   ( 1.871%)
      * species advanceCross:                    0.04427 s   ( 0.000026 s/step)   ( 0.020%)
      * [Unaccounted]                            0.17012 s   ( 0.000099 s/step)   ( 0.090%)
    - forward Euler took                        10.72175 s   ( 0.006230 s/step)   ( 4.924%)
      * dt calc took                             0.33906 s   ( 0.000197 s/step)   ( 0.156%)
      * combine took                             7.84348 s   ( 0.004558 s/step)   ( 3.602%)
      * BCs took                                 2.51847 s   ( 0.001463 s/step)   ( 1.157%)
      * [Unaccounted]                            0.02074 s   ( 0.000012 s/step)   ( 0.193%)
    - copy took                                  1.26362 s   ( 0.000734 s/step)   ( 0.580%)
    - combine took                               6.46956 s   ( 0.003759 s/step)   ( 2.971%)
    - diagnostic write took                      8.22999 s   ( 0.004782 s/step)   ( 3.779%)
    - restart write took                         0.78727 s   ( 0.000457 s/step)   ( 0.362%)
    - [Unaccounted]                              0.13121 s   ( 0.000076 s/step)   ( 0.060%)
  Whole simulation took                        217.75546 s   ( 0.126528 s/step)   (100.000%)
  [Unaccounted]                                  0.00012 s   ( 0.000000 s/step)   ( 0.000%)
  
  Wed Nov 22 2023 06:25:10.000000000

These simulation logs contain the following:

.. list-table::
  :widths: 20 80

  * - Line 1:
    - start date and time.
  * - Lines 2-3:
    - gkyl repository revision with which this simulation was run (a + at the
      end indicate it's been modified from the version in github), and
      the date on which the executable was built.
  * - Line 11:
    - report the initial time step number, time and initial time step size.
  * - Lines 12-21:
    - report progress every 1% of the simulation (first column).
      Then, every 10% of the simulation time, give the number of time steps taken so far,
      simulation time transcurred, and the latest time step size.
  * - Lines 23-54:
    - give various metrics regarding the time-steps and wall-clock time taken
      by the simulation, and the time spent on various parts of the calculation.
  * - Line 55:
    - Date and time when the simulation finished.

Also, by default gkyl produces a log file with the format ``<input-file-name>_0.log``.
If you wish to disable this set ``logToFile = false,`` in the Common section of the App.

.. _gkyl_usage_run_parallel:

Parallel simulation
^^^^^^^^^^^^^^^^^^^

For large problems running on a single CPU can lead to impractical runtimes. In those
cases one benefits from parallelizing the simulation over many CPUs (or GPUs, see next
section). This is accomplished in gkyl by decomposing the (position) space into subdomains
and/or decomposing the species into subpopulations, and handing off each
subdomain/subpopulation to a separate parallel process (with MPI or NCCL on GPUs).

Suppose one wishes to run the 3D sheath calculation in
:ref:`the previous section <gkyl_usage_run_serial>` on a node with 16 cores,
using 4 MPI processes along :math:`x` and 4 along :math:`z`. In this case one must edit the
variable ``decompCuts`` in the Common of the input file to reflect this decomposition:

.. code:: Lua

  plasmaApp = Plasma.App {
     ...
     decompCuts = {4, 1, 4},       -- Parallel decomposition in each position dimension.
     parallelizeSpecies = false,   -- =True to parallelize amongst species.
     ...
  }

Once ``decompCuts`` and the rest of the input file is set appropriately, you can run
the simulation with the MPI executable provided by your cluster or MPI implementation
(e.g. mpirun, mpiexec, srun, ibrun). For example, with mpirun we would run the simulation as

.. code:: bash

  mpirun -n 16 gkyl gk-sheath.lua

The argument following ``-n`` is the total number of MPI processes to launch, in this case
:math:`4\times4=16`. This clearly requires that your computer/node/job has access to
at least 16 cores.

.. note::

   The number of ``decompCuts`` in any dimension should not exceed the number of cells in that dimension.

Another way to parallelize a simulation with more than one species is to send each
species (or groups of) to separate MPI processes. For example, we could instead use 2
MPI processes along :math:`z` and 4 along :math:`z`, and further parallelize species
to utilize all 16 cores by setting

.. code:: Lua

  plasmaApp = Plasma.App {
     ...
     decompCuts = {2, 1, 4},      -- Parallel decomposition in each position dimension.
     parallelizeSpecies = true,   -- =True to parallelize amongst species.
     ...
  }

and again launching the executable with

.. code:: bash

  mpirun -n 16 gkyl gk-sheath.lua

In simulations with few (or no) cross-species interactions species parallelization is
particularly efficient.

On many computer clusters where one may run parallel simulations one must submit
scripts in order to submit a job. This jobscript causes the simulation to be queued
so that it runs once resources (i.e. cores, nodes) become available. When resources are
finally available the simulation runs in a compute node (instead of the login node).

Jobscripts for some machines are provided in the ``gkyl/machine`` folder and below. Note
that the installation instructions point to :ref:`machine scripts <gkyl_install_machines>`
for building gkyl on each of these computers. If you need assistance with setting up gkyl
in a new cluster, :ref:`see this <gkyl_install_machines_readme>` or feel free to contact
the developers.

Sample submit scripts:

- :doc:`NERSC's Cori <inputFiles/jobscript_cori>`.
- :doc:`TACC's Stampede2 <inputFiles/jobscript_stampede2>`.
- :doc:`TACC's Frontera <inputFiles/jobscript_frontera>`.
- :doc:`MIT's Engaging <inputFiles/jobscript_engaging>`.
- :doc:`Princeton's Stellar <inputFiles/jobscript_stellar>`.
- :doc:`PPPL's Portal <inputFiles/jobscript_portal>`.

.. _gkyl_usage_run_gpu:

Running on GPUs
^^^^^^^^^^^^^^^

Gkyl is also capable of running on graphical processing units (GPUs) with minimal or no
modifiation of an input file that you would use to run on CPUs. Our implementation of GPU
capabilities uses CUDA and NCCL. Our model is to launch an MPI process for each GPU available.
For this reason one must always launch gkyl with ``mpirun``, ``mpiexec`` or any equivalent
command provided by the system (e.g. ``srun``). Furthermore, one must provide the ``-g`` flag
following the gkyl executable. For example given the input file ``gk-sheath.lua`` previously
mentioned, we would simply run it with on a single GPU with

.. code:: bash

  mpirun -np 1 gkyl -g gk-sheath.lua

If multiple GPUs are available, one may use those to decompose position space and/or
species using ``decompCuts`` and ``speciesParallelization`` in the same way it is done for
CPUs (as explained above). We just need to ensure there are enough GPUs for the amount of
parallelization requested. For example, if we have 4 nodes with 4 GPUs each, we can again
use

.. code:: Lua

  plasmaApp = Plasma.App {
     ...
     decompCuts = {2, 1, 4},      -- Parallel decomposition in each position dimension.
     parallelizeSpecies = true,   -- =True to parallelize amongst species.
     ...
  }

to parallelize along :math:`x`, :math:`z` and species on 16 GPUs, and launch the simulation
with

.. code:: bash

  mpirun -n 16 gkyl -g gk-sheath.lua

.. warning::
  :title: (multi)GPU runs on clusters
  :collapsible:

  Clusters often have specific instructions for running GPU and multi-GPU jobs. Please
  refer to your cluster's documentation/admins to determine the correct/best way to run
  such simulations on that system.

On clusters is often common to submit scripts that queue the job for running on compute
nodes (when the resources become available). In fact this is often preferable to `ssh`-ing
into a node if that is even possible. Some sample job scripts for running GPU-enabled jobs
are in the ``gkyl/machines`` folder and below:

- :doc:`PPPL's Portal <inputFiles/jobscript_portalGPU>`.
- :doc:`Princeton's Adroit <inputFiles/jobscript_adroitGPU>`.
- :doc:`NERSC's Perlmutter <inputFiles/jobscript_perlmutterGPU>`.

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

.. code:: bash

  gkyl inputFile.lua restart

This second, restart simulation will use the ``_restart.bp`` files of the first simulation to
construct an initial condition. **Note** that it will look for the restart files in the same
directory in which the restart simulation is being run, so typically we run restarts in the same
directory as the first simulation.

Using the ``fromFile`` option
-----------------------------

The ``fromFile`` option can be used to read data from a file on initialization. This can be used
for initial conditions, sources, and geometry data. The file to be read must have the same prefix
as the input file but can otherwise be named as desired, including the extension (it might be useful
to use a different extension, such as ``.read``, to avoid accidentally deleting needed files if one
does ``rm *.bp``).

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


.. _gkyl_toolsIntro:

gkyl Tools
^^^^^^^^^^


A number of additional tools that users and developers may find useful as part
of their (Gkeyll) workflow are shipped as :ref:`gkyl Tools <gkyl_tools>`. One such tool,
for example, allows us to compare BP (ADIOS) files.

Suppose you ran the `plasma beach <http://ammar-hakim.org/sj/je/je8/je8-plasmabeach.html>`_
simulation with the Moment App, using the :doc:`momBeach.lua <inputFiles/momBeach>` input file
which contains a variable

.. code:: Lua

  local J0 = 1.0e-12   -- Amps/m^3.

in the collisionless electromagnetic source. Let's assume you were scanning this variable, so
you may choose to create another input file :doc:`momBeachS.lua <inputFiles/momBeachS>` which
increases ``J0`` to

.. code:: Lua

  local J0 = 1.0e-10   -- Amps/m^3.

If after running `momBeachS` you are not sure if the results changed at all, you can use the
``comparefiles`` tool. For example, compare the electromagnetic fields produced at the end of
both simulations with the following command:

.. code:: bash

  gkyl comparefiles -a momBeach_field_100.bp -b momBeachS_field_100.bp

In this particular example the tool would then print the following to screen:

.. code:: bash

  Checking attr numCells in momBeach_field_100.bp momBeach_field_100s.bp ...
  ... comparing numCells
  Checking attr lowerBounds in momBeach_field_100.bp momBeach_field_100s.bp ...
  ... comparing lowerBounds
  Checking attr upperBounds in momBeach_field_100.bp momBeach_field_100s.bp ...
  ... comparing upperBounds
  Checking attr basisType in momBeach_field_100.bp momBeach_field_100s.bp ...
  ... comparing basisType
  Checking attr polyOrder in momBeach_field_100.bp momBeach_field_100s.bp ...
  ... comparing polyOrder
  Files are different!

So we know that increasing ``J0`` by a factor of a 100 did change the simulation.

Additional documentation of these tools is found in the :ref:`gkyl Tools reference <gkyl_tools>`.


ADIOS tools
^^^^^^^^^^^

ADIOS has two handy tools that one may use to explore data files produced by a gkyl
simulation. These are ``bpls`` and ``bpdump``. We give a brief example of each here, and
expanded descriptions of their capabilities can be found in the
:download:`ADIOS documentation <figures/ADIOS-UsersManual-1.13.1.pdf>`, or using the
``bpls -h`` and ``bpdump -h`` commands.

Note that these tools are complimentary to postgkyl's :ref:`info <pg_cmd_info>` command.

bpls
~~~~

``bpls`` provides a simple view of the structure and contents of a ``.bp`` file. For example,
in :ref:`the previous section <gkyl_toolsIntro>` we discussed a 5-moment calculation of the
`plasma beach <http://ammar-hakim.org/sj/je/je8/je8-plasmabeach.html>`_ problem. Such simulation
produced the file ``momBeach_field_1.bp``. We can explore this file with

.. code:: bash

  bpls momBeach_field_1.bp

which outputs

.. code:: bash

  double   time           scalar
  integer  frame          scalar
  double   CartGridField  {400, 8}

It tells us that this file contains three variables, the simulation ``time`` at which this snapshot
was produced, the ``frame`` number, and a Cartesian grid field (CartGridField) for 400 cells which
contains 8 electromagnetic components (3 for electric field, 3 for magnetic field, and the other 2
are used in gkyl's algorithms). One may dump one of these variables with the additional ``-d`` flag.
So if we wish to know the simulation time of this frame, we would use

.. code:: bash

  bpls momBeach_field_1.bp time -d

and see it output

.. code:: bash

   double   time           scalar
   5.1e-11

Note that for large variables (e.g. CartGridField) dumping can overwhelm the terminal/screen. One
can also slice the dataset and only dump part of it, see ``bpls -h``.

There are also a number of `attributes` (smaller pieces of time-constant data), which one can see with
the ``-a`` flag:

.. code:: bash

  ws:dir jill$ bpls momBeach_field_1.bp -a
    double   time           scalar
    integer  frame          scalar
    double   CartGridField  {400, 8}
    string   changeset      attr
    string   builddate      attr
    string   type           attr
    string   grid           attr
    integer  numCells       attr
    double   lowerBounds    attr
    double   upperBounds    attr
    string   basisType      attr
    integer  polyOrder      attr
    string   inputfile      attr

and you can peek the value of an attribute with ``bpls <filename> -a <attribute-name> -d``.

bpdump
~~~~~~

The ``-d`` flag in the previous dumps the values of a variable onto the screen. There's a separate
command to do just that called ``bpdump``. You can dump a specific variable with

.. code:: bash

  bpdump -d <variable-name> <filename>

