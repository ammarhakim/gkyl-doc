.. _dev_recovery:

The recovery Maxima code
++++++++++++++++++++++++

A major algorithm used in many parts of Gkeyll is the recovery
procedure. This is used to construct DG (hyper)diffusion equation
solvers, the LBO diffusion kernels and even some very high-order
hyperbolic solvers. We have attempted to abstract the recovery
procedure (which is rather complicated) into *three* very simple to
use functions. 
