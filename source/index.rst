.. _home:

.. title:: The Gkeyll Simulation Framework

:hero: A multi-scale, multi-physics simulation framework

The :math:`\texttt{Gkeyll}` Simulation Framework
================================================

:math:`\texttt{Gkeyll}` is a multi-scale, multi-physics simulation framework, developed
for a variety of applications in plasma physics, space physics, general relativity, and
high-energy astrophysics. The core of :math:`\texttt{Gkeyll}` is written in C, featuring
a lightweight, modular design and minimal external dependencies, plus an additional Lua
scripting layer (for specifying simulation input parameters) provided via the `Lua-C API
<https://www.lua.org/pil/24.html>`_.

:math:`\texttt{Gkeyll}`'s clean and modular design ensures that the entire code can be
built hierarchically, with the following layers:

* :math:`\texttt{core}`
    Critical software infrastructure that is common to all parts of the
    :math:`\texttt{Gkeyll}` framework, including grid-generation, parallelism, file
    input/output, Lua tools, and certain fundamental array and discontinuous Galerkin
    operations.

* :math:`\texttt{moments}`
    :math:`\texttt{Gkeyll}`'s finite-volume solvers for various systems of hyperbolic
    PDEs, including (relativistic) multi-fluid equations, perfectly hyperbolic Maxwell
    equations, and Einstein field equations. Also includes infrastructure for
    integrating ODEs, solving Poisson equations, and specifying curved spacetime
    geometries (e.g. black holes and neutron stars) for general relativistic
    simulations.

* :math:`\texttt{vlasov}`
    :math:`\texttt{Gkeyll}`'s modal discontinuous Galerkin solvers for the
    (relativistic) Vlasov-Maxwell and Vlasov-Poisson equation systems, supporting
    continuum kinetics simulations in any number of configuration space and velocity
    space dimensions, from 1x1v (2D phase space) to full 3x3v (6D phase space). Also
    includes modal discontinuous Galerkin solvers for evolving various Hamiltonian
    systems, as specified via their canonical Poisson bracket structure.

* :math:`\texttt{gyrokinetic}`
    :math:`\texttt{Gkeyll}`'s modal discontinuous Galerkin solvers for the full
    :math:`f` gyrokinetic equation in the long-wavelength limit (coupled to the
    gyrokinetic Poisson equation), supporting continuum electrostatic gyrokinetics in
    any number of configuration space dimensions, from 1x2v (3D phase space) to
    full 3x2v (5D phase space). Also includes infrastructure for specifying tokamak and
    mirror geometries for nuclear fusion applications.

* :math:`\texttt{pkpm}`
    :math:`\texttt{Gkeyll}`'s modal discontinuous Galerkin solvers for the
    parallel-kinetic-perpendicular-moment equations, supporting simulation of weakly
    collisional, magnetized plasmas in any number of configuration space dimensions,
    from 1x1v (2D phase space) to 3x1v (4D phase space).

Technology Stack
----------------

:math:`\texttt{Gkeyll}` is written in straight C, with support for multi-CPU parallelism
via MPI, (NVIDIA) GPU acceleration via CUDA, and multi-GPU parallelism via NCCL. The only
strictly *required* dependencies for installing :math:`\texttt{Gkeyll}` are:

* ``OpenBLAS`` (including both ``BLAS`` and ``LAPACK``) for numerical linear algebra
  routines.

* ``SuperLU`` for solving sparse linear systems.

with the additional *optional* dependencies:

* ``LuaJIT`` (optional, but *strongly* recommended) for enabling
  :math:`\texttt{Gkeyll}`'s Lua scripting layer.

* ``cuDSS`` for solving sparse linear systems on GPUs (only required for GPU builds).

* ``OpenMPI`` for multi-CPU and multi-GPU parallelism (only required for parallel
  builds).

* ``ADAS`` for atomic data (only required for certain gyrokinetic simulations).

In addition to hand-written C code, :math:`\texttt{Gkeyll}` also consists of a large
amount of automatically-generated C code (especially for its modal discontinuous Galerkin
routines) that have been produced using the ``Maxima`` computer algebra system. Various
core aspects of :math:`\texttt{Gkeyll}`'s algorithmic infrastructure have also been
formally verified, with symbolic correctness proofs produced using a bespoke automated
theorem-proving system developed in ``Racket``. Both the ``Maxima`` computer algebra
code and the ``Racket`` automated theorem-proving code are packaged as part of the
:math:`\texttt{gkylcas}` project. Finally, the :math:`\texttt{postgkyl}` visualization
and post-processing framework is developed in Python, based on ``matplotlib``.

Developers
----------

The originator, lead developer and chief algorithm alchemist of the
:math:`\texttt{Gkeyll}` project is **Ammar Hakim** (*Princeton Plasma Physics
Laboratory*).

The other active developers of the :math:`\texttt{Gkeyll}` code (defined as being those
who have contributed to the ``main`` branch of the primary :math:`\texttt{Gkeyll}`
source repository within the past 12 months) include:

* **James (Jimmy) Juno**, *Princeton Plasma Physics Laboratory*
* **Manaure Francisquez**, *Princeton Plasma Physics Laboratory*
* **Jonathan Gorard**, *Princeton University*
* **Akash Shukla**, *University of Texas at Austin*
* **Maxwell Rosen**, *Princeton University*
* **Tess Bernard**, *General Atomics*
* **Antoine Hoffmann**, *Princeton Plasma Physics Laboratory*
* **Grant Johnson**, *Princeton University*
* **Kolter Bradshaw**, *Princeton University*
* **Jonathan Roeltgen**, *University of Texas at Austin*
* **Dingyun Liu**, *Princeton University*

The lead developers of the :math:`\texttt{postgkyl}` visualization and post-processing
framework are **Petr Cagas** and **Ammar Hakim**.

Previous contributors to the :math:`\texttt{Gkeyll}` project (defined as being those who
have ever contributed to the ``main`` branches of any :math:`\texttt{Gkeyll}` source
repository, present or past) include:

* **Liang Wang**, *Boston University*
* **Noah Mandell**, *Type One Energy*
* **Eric Shi**, *NVIDIA*
* **Petr Cagas**, *Center for Advanced Systems Understanding*
* **Jonathan Ng**, *University of Maryland*
* **Tony Qian**, *University of Wisconsin-Madison*
* **John Rodman**, *University of Rochester*
* **Collin Brown**, *U.S. Naval Research Laboratory*
* **Chuanfei Dong**, *Boston University*
* **Bhuvana Srinivasan**, *Washington University*
* **Chirag R. Skolar**, *New Jersey Institute of Technology*
* **Luca Georgescu**, *University of California San Diego*
* **Jason TenBarge**, *Princeton University*

Other Pages
-----------

.. toctree::
  :maxdepth: 2

  install
  quickstart