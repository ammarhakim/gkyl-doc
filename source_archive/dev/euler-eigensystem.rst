.. _devEigenSysEuler:

The eigensystem of the Euler equations
======================================

In this document I list the eigensystem of the Euler equations valid
for a general equation of state. The formulas are taken from
[Kulikovskii2001]_, Chapter 3, section 3.1. The Euler equations can be
written in conservative form as

.. math::
  :label: eq-euler-eqn

  \frac{\partial}{\partial{t}}
  \left[
    \begin{matrix}
      \rho \\
      \rho u \\
      \rho v \\
      \rho w \\
      E
    \end{matrix}
  \right]
  +
  \frac{\partial}{\partial{x}}
  \left[
    \begin{matrix}
      \rho u \\
      \rho u^2 + p \\
      \rho uv \\
      \rho uw \\
      (E+p)u
    \end{matrix}
  \right]
  =
  0

	    
where

.. math::

  E = \rho \varepsilon + \frac{1}{2}\rho q^2

is the total energy and :math:`\varepsilon` is the internal energy of
the fluid and :math:`q^2=u^2 + v^2 + w^2`. The pressure is given by an
equation of state (EOS) :math:`p=p(\varepsilon, \rho)`. For an ideal
gas the EOS is :math:`p = (\gamma-1)\rho \varepsilon`.

The eigenvalues are :math:`\{u-c, u, u, u, u+c\}`. The right
eigenvectors of the flux Jacobian are given by the columns of the
matrix

.. math::
  :label: eq:rev
	  
  R
  =
  \left[
    \begin{matrix}
      1 & 0 & 0 & 1 & 1 \\
      u-c & 0 & 0 & u & u+c \\
      v & 1 & 0 & v & v \\
      w & 0 & 1 & w & w \\
      h-uc & v & w & h-c^2/b & h+uc
    \end{matrix}
  \right]

  
here

.. math::

  h &= (E+p)/\rho \\
  c &= \sqrt{\frac{\partial p}{\partial \rho} 
    + \frac{p}{\rho^2}\frac{\partial p}{\partial \varepsilon}}

is the enthalpy and the sound speed respectively. Also,

.. math::

   b = \frac{1}{\rho}\frac{\partial p}{\partial \varepsilon}.

Note that for ideal gas EOS we have

.. math::
  h &= \frac{c^2}{\gamma-1} + \frac{1}{2}q^2 \\
  c &= \sqrt{\frac{\gamma p}{\rho}}

and :math:`b=\gamma-1`. Hence, in this case the term :math:`h-c^2/b`
in :eq:`eq:rev` is just :math:`q^2/2`. The left eigenvectors are the
rows of the matrix

.. math::
  :label: eq:lev
	  
  L
  =
  \frac{b}{2c^2}
  \left[
    \begin{matrix}
      \theta+uc/b & -u-c/b & -v & -w & 1 \\
      -2vc^2/b & 0 & 2c^2/b & 0 & 0 \\
      -2wc^2/b & 0 & 0 & 2c^2/b & 0 \\
      2h-2q^2 & 2u & 2v & 2w & -2 \\
      \theta-uc/b & -u+c/b & -v & -w & 1
    \end{matrix}
  \right]
  
where

.. math::

  \theta = q^2 - \frac{E}{\rho} 
    + \rho\frac{\partial p / \partial \rho}{\partial p / \partial \varepsilon}

which, for an ideal gas EOS reduces to :math:`q^2/2`.

Now consider the problem of splitting a jump vector :math:`\Delta
\equiv [\delta_0,\delta_1,\delta_2,\delta_3,\delta_4]^T` into
coefficients neeeded in computing the Riemann problem. The
coefficients are given by :math:`L\Delta`. For an ideal gas law EOS,
after some algebra we can show that an efficient way to compute these
are

.. math::
  :label: eq:jump-split

  \alpha_3 &= \frac{\gamma-1}{c^2}
  \left[
    (h-q^2)\delta_0 + u\delta_1 + v\delta_2 + w\delta_3 -\delta_4
  \right] \\
  \alpha_1 &= -v\delta_0 + \delta_2 \\
  \alpha_2 &= -w\delta_0 + \delta_3 \\
  \alpha_4 &= \frac{1}{2c}
  \left[
    \delta_1 + (c-u)\delta_0 - c\alpha_3
  \right] \\
  \alpha_0 &= \delta_0 - \alpha_3 - \alpha_4.

References
----------

.. [Kulikovskii2001] Andrei G. Kulikoviskii and Nikolai V. Pogorelov
   and Andrei Yu. Semenov, *Mathematical Aspects of Numerical
   Solutions of Hyperbolic Systems*, Chapman and Hall/CRC, 2001.
