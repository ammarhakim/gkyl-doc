.. highlight:: lua

.. _qs_gk1:

Gyrokinetic example
+++++++++++++++++++

The gyrokinetic system is used to study turbulence in magnetized plasmas.
Gkeyll's ``Gyrokinetic`` App is specialized to study the edge/scrape-off-layer region of fusion devices, which requires
handling of large fluctuations and open-field-line regions.
In this example, we will set up a gyrokinetic problem on open magnetic field lines (e.g. in the tokamak scrape-off layer).
Using specialized boundary conditions along the field line that model the sheath interaction between the plasma and 
conducting end plates, we will see that we can model the self-consistent formation of the sheath potential.
This simple test case can then be used as a starting point for full nonlinear simulations of the tokamak SOL.

.. contents::

Background
----------

Gyrokinetics intro?

Input file
----------

Postprocessing
--------------
