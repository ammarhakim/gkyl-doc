.. _dev_modalbasis:

Modal basis functions
+++++++++++++++++++++

Each of the kinetic equations Gkeyll's solvers discretize using the discontinuous Galerkin 
algorithm---the Vlasov equation, the gyrokinetic equation, and the PKPM system---all 
benefit from utilizing polynomials for the basis in the underlying solution space. 
There is enormous freedom for the specific form of the polynomials, and Gkeyll benefits 
from a specific class of *orthonormal modal basis functions* for representing the discrete
distribution function and other variables of interest. 

These basis functions are defined on a d-dimensional hypercube :math:`I_d = [-1,1]^d`. Let
:math:`\psi_k(\mathbf{x})`, :math:`k=1,\ldots,N`, with :math:`\psi_1`
a constant, be the basis. Then the basis satisfy

.. math::

   \langle \psi_k \psi_m \rangle = \delta_{km}

where the angle brackets indicate integration over the hypercube
:math:`I_d`. In this note we describe some common operations that are
needed while working with these basis sets. 

.. contents::

Pre-computed basis functions
----------------------------

Precomputed modal basis sets on phase-space for 1x1v, 1x2v, 1x3v,
2x2v, 2x3v, 3x2v, and 3x3v phase-space are stored as Lisp files in
gkyl/cas-scripts/basis-precalc directory. Both maximal-order and
serendipity basis sets are computed for polynomial orders 1, 2, 3
and 4. Computing orthonormal basis set in higher dimensions is
time-consuming and so these pre-computed lisp files should be
used. For example::

  load("basis-precalc/basisSer2x3v")

will load the serendipity basis sets in 2x3v phase-space.

NOTE: please read :doc:`Maxima notes <onmaxima>` to get this command
to work.

The files define the following Maxima variables::

  varsC, varsP, basisC, basisP

The `varsC` are the configuration-space independent variables
(:math:`x,y` in 2X) and `varsP` are the phase-space independent
variables (:math:`x,y,vx,vy,vz` in 2X3V). The i-th entry in the list
`basisC` and `basisP` contain the basis sets of polynomial order
:math:`i`. Hence, to access the phase-space basis for :math:`p=2` do
something like::

  basisP2 : basisP[2].  
      

Computing cell averages
-----------------------

Consider some function that is expanded in the basis:

.. math::

   f(\mathbf{x}) = \sum_k f_k \psi_k\big(\boldsymbol{\eta}(\mathbf{x})\big)

where :math:`\boldsymbol{\eta}(\mathbf{x})` maps the physical space to
logical space. Then, the cell-average is defined as

.. math::

   \overline{f} = \frac{1}{2^d} \langle f \rangle = \frac{1}{2^d}
   f_1\psi_1 \langle 1 \rangle = f_1\psi_1.

where :math:`\psi_1` is constant. By orthonormality we have
:math:`\langle \psi_1^2 \rangle = 1` which indicates that

.. math::

   \psi_1 = \frac{1}{\sqrt{2^d}}.

This means that the cell-average is given by

.. math::

   \overline{f} = \frac{f_1}{\sqrt{2^d}}

Convolution of two functions
----------------------------

Now consider two functions, :math:`f` and :math:`g` that are both
expanded in the basis. The inner product of the two functions is:

.. math::

   \overline{f g} = \frac{1}{2^d}  \langle f g \rangle

Note the the bar on the LHS, i.e. this expression gives the *average*
of the inner product on a single cell. Now, as the basis functions are
orthonormal, this leads to the particularly simple expression

.. math::

   \overline{f g} = \frac{1}{2^d} \sum_k f_k g_k

This makes it very easy to compute things like electromagnetic energy,
and other quadratic quantities.
