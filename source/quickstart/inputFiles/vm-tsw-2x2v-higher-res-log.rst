.. code-block:: bash

  Wed Sep 16 2020 19:14:03.000000000
  Gkyl built with a4430cbb5d93
  Gkyl built on Sep 16 2020 01:25:31
  Initializing Vlasov-Maxwell simulation ...
  Initializing completed in 3.50176 sec

  Starting main loop of Vlasov-Maxwell simulation ...
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