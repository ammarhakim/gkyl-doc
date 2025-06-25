.. _devEigenSys10M:

The eigensystem of the ten-moment equations
===========================================

In this document I list the eigensystem of the ten-moment
equations. These equations are derived by taking moments of the
Boltzmann equation and truncating the resulting infinite series of
equations by assuming the heat flux tensor vanishes. In
non-conservative form these equations are

.. math::

  \partial_t{n} + n \partial_j{u_j} + u_j \partial_j{n} &= 0 \\
  \partial_t{u_i}
  + \frac{1}{mn}\partial_j{P_{ij}}
  + u_j \partial_j{u_i} &=
  \frac{q}{m}\left(E_i + \epsilon_{kmi}u_kB_m\right) \\
  \partial_t{P_{ij}} + P_{ij}\partial_k{u_k}
  + \partial_k{u_{[i}}P_{j]k}
  + u_k\partial_k{P_{ij}}
  &= \frac{q}{m}B_m \epsilon_{km[i}P_{jk]}

In these equations square brackets around indices represent the
minimal sum over permutations of free indices within the bracket
needed to yield completely symmetric tensors. Note that there is one
such system of equations for *each* species in the plasma. Here,
:math:`q` is the species charge, :math:`m` is the species mass,
:math:`n` is the number density, :math:`u_j` is the velocity,
:math:`P_{ij}` the pressure tensor and :math:`\mathbf{E}` and
:math:`\mathbf{B}` are the electric and magnetic field
respectively. Also :math:`\partial_t \equiv \partial /\partial t` and
:math:`\partial_i \equiv \partial /\partial x_i`.

To determine the eigensystem of the homogeneous part of this system we
first write, in one-dimension, the left-hand side of of these
equations in the form

.. math::

  \partial_t{\mathbf{v}} + \mathbf{A}\partial_{1}{\mathbf{v}} = 0 \label{eq:qlForm}

where :math:`\mathbf{v}` is the vector of primitive variables and
:math:`\mathbf{A}` is the quasilinear coefficient matrix
[#quasilinear]_. For the ten-moment system we have

.. math::

  \mathbf{v} = 
    \left[
    \begin{matrix}
      \rho,
      u_1,
      u_2,
      u_3,
      P_{11},
      P_{12},
      P_{13},
      P_{22},
      P_{23},
      P_{33}
    \end{matrix}
  \right]^T

where :math:`\rho \equiv mn` and 

.. math::

  \mathbf{A} = 
    \left[
    \begin{matrix}
      u_1  & \rho   & 0      & 0     & 0     & 0     & 0      & 0    & 0    & 0 \\
      0    & u_1    & 0      & 0     & 1/\rho & 0     & 0     & 0    & 0    & 0 \\
      0    & 0      & u_1    & 0     & 0     & 1/\rho & 0     & 0    & 0    & 0 \\
      0    & 0      & 0      & u_1   & 0     & 0     & 1/\rho & 0    & 0    & 0 \\
      0    & 3P_{11} & 0      & 0     & u_1   & 0     & 0      & 0    & 0    & 0 \\
      0    & 2P_{12} & P_{11} & 0     & 0    & u_1    & 0      & 0    & 0    & 0 \\
      0    & 2P_{13} & 0      & P_{11} & 0    & 0      & u_1    & 0    & 0    & 0 \\
      0    & P_{22}  & 2P_{12} & 0     & 0    & 0      & 0     & u_1   & 0    & 0 \\
      0    & P_{23}  & P_{13}  & P_{12} & 0    & 0      & 0     & 0     & u_1  & 0 \\
      0    & P_{33}  & 0      & 2P_{13} & 0   & 0      & 0     & 0     & 0    & u_1
    \end{matrix}
  \right]

The eigensystem of this matrix needs to be determined. It is easiest
to use a computer algebra system for this. I prefer the open source
package `Maxima <http://maxima.sourceforge.net>`_ for this. The
right-eigenvectors returned by Maxima need to massaged a little bit to
bring them into a clean form. The results are described below.

The eigenvalues of the system are given by 

.. math::

  \lambda^{1,2} &= u_1-\sqrt{P_{11}/\rho} \\
  \lambda^{3,4} &= u_1+\sqrt{P_{11}/\rho} \\
  \lambda^{5}   &= u_1-\sqrt{3P_{11}/\rho} \\
  \lambda^{6}   &= u_1+\sqrt{3P_{11}/\rho} \\
  \lambda^{7,8,9,10}    &= u_1

To maintain hyperbolicity we must hence have :math:`\rho>0` and
:math:`P_{11}>0`. In multiple dimensions, in general, the diagonal
elements of the pressure tensor must be positive. When
:math:`P_{11}=0` the system reduces to the cold fluid equations which
is known to be rank deficient and hence not hyperbolic as usually
understood [#cold-fluid]_. Also notice that the eigenvalues do not
include the usual fluid sound-speed :math:`c_s=\sqrt{5p/3\rho}` but
instead have two different propagation speeds
:math:`c_1=\sqrt{P_{11}/\rho}` and
:math:`c_2=\sqrt{3P_{11}/\rho}`. This is because the (neutral)
ten-moment system does not go to the correct limit of Euler equations
in the absence of collisions. In fact, it is collisions that drive the
pressure tensor to isotropy. These collision terms should also be
included in the plasma ten-moment system. In this case, however, the
situation is complicated due to the presence of multiple species of
very different masses which leads to inter-species collision terms
that need to be computed carefully. For a two-species plasma, for
example, see the paper by Green [Green1973]_ in which the relations
for relaxation of momentum and energy are used to derive a simplified
collision integral for use in the Boltzmann equation.

The right eigenvectors (column vectors) are given below.

.. math::

  \mathbf{r}^{1,3}
  =
  \left[
    \begin{matrix}
      0 \\
      0 \\
      \mp c_1 \\
      0 \\
      0 \\
      P_{11} \\
      0 \\
      2P_{12} \\
      P_{13} \\
      0
    \end{matrix}
  \right]
  \quad
  \mathbf{r}^{2,4}
  =
  \left[
    \begin{matrix}
      0 \\
      0 \\
      0 \\
      \mp c_1 \\
      0 \\
      0 \\
      P_{11} \\
      0 \\
      P_{12} \\
      2P_{13}
    \end{matrix}
  \right]

and

.. math::

  \mathbf{r}^{5,6}
  =
  \left[
    \begin{matrix}
      \rho P_{11} \\
      \mp c_2 P_{11} \\
      \mp c_2 P_{12} \\
      \mp c_2 P_{13} \\
      3 P_{11}^2 \\
      3 P_{11}P_{12} \\
      3 P_{11}P_{13} \\
      P_{11}P_{22} + 2 P_{12}^2 \\
      P_{11}P_{23} + 2P_{12}P_{13} \\
      P_{11}P_{33} + 2P_{13}^2
    \end{matrix}
  \right]

and

.. math::

  \mathbf{r}^{7}
  =
  \left[
    \begin{matrix}
      1 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0
    \end{matrix}
  \right]
  \quad
  \mathbf{r}^{8}
  =
  \left[
    \begin{matrix}
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      1 \\
      0 \\
      0
    \end{matrix}
  \right]
  \quad
  \mathbf{r}^{9}
  =
  \left[
    \begin{matrix}
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      1 \\
      0
    \end{matrix}
  \right]
  \quad
  \mathbf{r}^{10}
  =
  \left[
    \begin{matrix}
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      0 \\
      1
    \end{matrix}
  \right]

We can now compute the left eigenvectors (row vectors) by inverting
the matrix with right eigenvectors stored as columns. This ensures the
normalization :math:`\mathbf{l}^p \mathbf{r}^k = \delta^{pk}`, where
the :math:`\mathbf{l}^p` are the left eigenvectors. On performing the
inversion we have

.. math::

  \mathbf{l}^{1,3} &= 
  \left[
    \begin{matrix}
      0 & \pm\dfrac{P_{12}}{2c_1P_{11}} & \mp\dfrac{1}{2c_1} & 
      0 & -\dfrac{P_{12}}{2P_{11}^2} & \dfrac{1}{2P_{11}} & 0 & 0 & 0 & 0
    \end{matrix}
  \right] \\
  \mathbf{l}^{2,4} &= 
  \left[
    \begin{matrix}
      0 & \pm\dfrac{P_{13}}{2c_1P_{11}} & 0 & \mp\dfrac{1}{2c_1}
      & -\dfrac{P_{13}}{2P_{11}^2} & 0 & \dfrac{1}{2P_{11}} & 0 & 0 & 0
    \end{matrix}
  \right]

and

.. math::

  \mathbf{l}^{5,6} = 
  \left[
    \begin{matrix}
      0 & \mp\dfrac{1}{2c_2P_{11}} & 0 & 0 & \dfrac{1}{6P_{11}^2}
      & 0 & 0 & 0 & 0 & 0
    \end{matrix}
    \right]

and

.. math::

  \mathbf{l}^{7} &= 
  \left[
    \begin{matrix}
      1 & 0 & 0 & 0 & -\dfrac{1}{3c_1^2} & 0 & 0 & 0 & 0 & 0
    \end{matrix}
    \right] \\
  \mathbf{l}^{8} &= 
  \left[
    \begin{matrix}
      0 & 0 & 0 & 0 & \dfrac{4P_{12}^2-P_{11}P_{22}}{3P_{11}^2} 
      & -\dfrac{2P_{12}}{P_{11}} & 0 & 1 & 0 & 0
    \end{matrix}
    \right] \\
  \mathbf{l}^{9} &= 
  \left[
    \begin{matrix}
      0 & 0 & 0 & 0 & \dfrac{4P_{12}P_{13}-P_{11}P_{23}}{3P_{11}^2} 
      & -\dfrac{P_{13}}{P_{11}} & -\dfrac{P_{12}}{P_{11}} & 0 & 1 & 0
    \end{matrix}
    \right] \\
  \mathbf{l}^{10} &= 
  \left[
    \begin{matrix}
      0 & 0 & 0 & 0 & \dfrac{4P_{13}^2-P_{11}P_{33}}{3P_{11}^2} & 0
      & -\dfrac{2P_{13}}{P_{11}} & 0 & 0 & 1
    \end{matrix}
    \right]

The eigensystem of the equations written in conservative form
-------------------------------------------------------------

In the wave-propagation scheme the quasilinear equations can be
updated. However, the resulting solution will not be
conservative. This actually might not be a problem for the ten-moment
system as the system (as written) can not be put into a homogeneous
conservation law form anyway. However, most often for numerical
simulations the eigensystem of the conservation form of the
homogeneous system is needed. This eigensystem is related to the
eigensystem of the quasilinear form derived above. To see this
consider a conservation law

.. math::

  \partial_t \mathbf{q} + \partial_1 \mathbf{f} = 0

where :math:`\mathbf{f} = \mathbf{f}(\mathbf{q})` is a flux
function. Now consider an invertible transformation :math:`\mathbf{q}
= \varphi(\mathbf{v})`. This transforms the conservation law to

.. math::

  \partial_t \mathbf{v} 
  + (\varphi')^{-1}\ D\mathbf{f}\ \varphi' \partial_1 \mathbf{v} = 0

where :math:`\varphi'` is the Jacobian matrix of the transformation
and :math:`D\mathbf{f} \equiv \partial \mathbf{f}/\partial \mathbf{q}`
is the flux Jacobian. Comparing this to the quasilinear form we see
that the quasilinear matrix is related to the flux Jacobian by

.. math::

  \mathbf{A} = (\varphi')^{-1}\ D\mathbf{f}\ \varphi'

This clearly shows that the eigenvalues of the flux Jacobian are the
same as those of the quasilinear matrix while the right and left
eigenvectors can be computed using :math:`\varphi' \mathbf{r}^p` and
:math:`\mathbf{l}^p(\varphi')^{-1}` respectively.

For the ten-moment system the required transformation is

.. math::

  \mathbf{q} = \varphi(\mathbf{v})
  =
  \left[
    \begin{matrix}
      \rho \\
      \rho u_1 \\
      \rho u_2 \\
      \rho u_3 \\
      \rho u_1u_1 + P_{11} \\
      \rho u_1u_2 + P_{12} \\
      \rho u_1u_3 + P_{13} \\
      \rho u_2u_2 + P_{22} \\
      \rho u_2u_3 + P_{23} \\
      \rho u_3u_3 + P_{33}
    \end{matrix}
  \right]

For this transformation we have

.. math::

  \varphi'(\mathbf{v}) = 
    \left[
    \begin{matrix}
      1         & 0          & 0         & 0         & 0 & 0 & 0 & 0 & 0 & 0 \\
      u_1       & \rho       & 0         & 0         & 0 & 0 & 0 & 0 & 0 & 0 \\
      u_2       & 0          & \rho      & 0         & 0 & 0 & 0 & 0 & 0 & 0 \\
      u_3       & 0          & 0         & \rho      & 0 & 0 & 0 & 0 & 0 & 0 \\
      u_1u_1    & 2\rho u_1  & 0         & 0         & 1 & 0 & 0 & 0 & 0 & 0 \\
      u_1u_2    & \rho u_2   & \rho u_1  & 0         & 0 & 1 & 0 & 0 & 0 & 0 \\
      u_1u_3    & \rho u_3   & 0         & \rho u_1  & 0 & 0 & 1 & 0 & 0 & 0 \\
      u_2u_2    & 0          & 2\rho u_2 & 0         & 0 & 0 & 0 & 1 & 0 & 0 \\
      u_2u_3    & 0          & \rho u_3  & \rho u_2  & 0 & 0 & 0 & 0 & 1 & 0\\
      u_3u_3    & 0          & 0         & 2\rho u_3 & 0 & 0 & 0 & 0 & 0 & 1
    \end{matrix}
  \right]

The inverse of the transformation Jacobian is

.. math::

  (\varphi')^{-1} = 
    \left[
    \begin{matrix}
      1         & 0          & 0         & 0      & 0 & 0 & 0 & 0 & 0 & 0 \\
      -u_1/\rho & 1/\rho     & 0         & 0      & 0 & 0 & 0 & 0 & 0 & 0 \\
      -u_2/\rho & 0          & 1/\rho    & 0      & 0 & 0 & 0 & 0 & 0 & 0 \\
      -u_3/\rho & 0          & 0         & 1/\rho & 0 & 0 & 0 & 0 & 0 & 0 \\
      u_1u_1    & -2u_1      & 0         & 0      & 1 & 0 & 0 & 0 & 0 & 0 \\
      u_1u_2    & -u_2       & -u_1      & 0      & 0 & 1 & 0 & 0 & 0 & 0 \\
      u_1u_3    & -u_3       & 0         & -u_1   & 0 & 0 & 1 & 0 & 0 & 0 \\
      u_2u_2    & 0          & -2 u_2    & 0      & 0 & 0 & 0 & 1 & 0 & 0 \\
      u_2u_3    & 0          & -u_3      & -u_2   & 0 & 0 & 0 & 0 & 1 & 0\\
      u_3u_3    & 0          & 0         & -2u_3  & 0 & 0 & 0 & 0 & 0 & 1
    \end{matrix}
  \right]


References
----------

.. [Green1973] John M. Greene. Improved Bhatnagar-Gross-Krook model of
   electron-ion collisions. *The Physics of Fluids*,
   16(11):2022-2023, 1973.

-----------

.. [#quasilinear] There is no standard name for this matrix. I choose
   to call it the *quasilinear coefficient matrix* instead of the
   incorrect term "primitive flux Jacobian".

.. [#cold-fluid] For hyperbolicity the quasilinear matrix must posses
   real eigenvalues and a complete set of linearly independent right
   eigenvectors. For the cold fluid system we only have a single
   eigenvalue (the fluid velocity) and a single eigenvector. This can
   lead to generalized solutions like delta shocks.

