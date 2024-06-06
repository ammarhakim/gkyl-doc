.. _devGRHDEigensystem:

The eigensystem of the general relativistic hydrodynamics (GRHD) equations
==========================================================================

The time-step calculation that Gkeyll performs as part of the finite-volume update step
for the general relativistic hydrodynamics (GRHD) equations within the Moment app
depends upon knowledge of the eigenvalues of the GRHD system, and, furthermore, the
implementation of a full Roe-type approximate Riemann solver requires knowledge of its
eigenvectors too. Thus, for the sake of convenience, we present here the complete
eigenystem for the GRHD equations. This was first calculated by [Anile1989]_ and
[Eulderink1995]_ for the specific case of the ideal gas equation of state, and later
generalized by [Banyuls1997]_ to the case of arbitrary equations of state. In this short
technical note, we will follow the notational and terminological conventions introduced
within the description of the :ref:`GRHD equations in Gkeyll <devGRHDEquations>`. In
particular, we assume a :math:`{3 + 1}` "ADM" decomposition of our 4-dimensional
spacetime into 3-dimensional spacelike hypersurfaces with induced metric tensor
:math:`\gamma_{i j}`, lapse function :math:`\alpha`, and shift vector :math:`\beta^i`.
We also assume a perfect relativistic fluid with (rest) mass density :math:`\rho`,
spatial velocity components (as perceived by normal observers) :math:`v^i`, pressure
:math:`P`, specific enthalpy :math:`h`, and local sound speed :math:`c_s`. Einstein
summation convention (in which repeated tensor indices are implicitly summed over) is
assumed throughout, and the Latin indices :math:`i, j, k, l` range over the spatial
coordinate directions :math:`\left\lbrace 1, \dots 3 \right\rbrace` only.

Eigenvalues
-----------

In each of the
3 spatial coordinate directions :math:`x^k`, we can compute a 5-dimensional Jacobian
matrix :math:`\mathbf{B}^k`:

.. math::
  \mathbf{B}^k = \alpha \frac{\partial \begin{bmatrix}
  \left( \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P
  - \frac{\rho}{\sqrt{1 - \gamma_{i j} v^i v^j}} \right) \left( v^k
  - \frac{\beta^k}{\alpha} \right) + P v^k\\
  \left( \frac{\rho h v_l}{1 - \gamma_{i j} v^i v^j} \right) \left( v^k
  - \frac{\beta^k}{\alpha} \right) + P \delta_{l}^{k}\\
  \left( \frac{\rho}{\sqrt{1 - \gamma_{i j} v^i v^j}} \right) \left( v^k
  - \frac{\beta^k}{\alpha} \right)
  \end{bmatrix}}{\partial \begin{bmatrix}
  \frac{\rho h}{1 - \gamma_{i j} v^i v^j} - P
  - \frac{\rho}{\sqrt{1 - \gamma_{i j} v^i v^j}}\\
  \frac{\rho h v_l}{1 - \gamma_{i j} v^i v^j}\\
  \frac{\rho}{\sqrt{1 - \gamma_{i j} v^i v^j}}
  \end{bmatrix}}.

The 5 eigenvalues of each such Jacobian matrix :math:`\mathbf{B}^k` can then be
categorized into those corresponding to the *material* wave-speeds:

.. math::
  \lambda_{0}^{k} = \alpha v^k - \beta^k,

which each have algebraic multiplicity 3, and those corresponding to the *acoustic*
wave-speeds:

.. math::
  \lambda_{\pm}^{k} = \frac{\alpha}{1 - \gamma_{i j} v^i v^j c_{s}^{2}} \left[
  v^k \left( 1 - c_{s}^{2} \right) \right.\\
  \left. \pm c_s \sqrt{\left( 1 - \gamma_{i j} v^i v^j \right) \left[ \gamma^{k k}
  \left( 1 - \gamma_{i j} v^i v^j c_{s}^{2} \right)
  - v^k v^k \left( 1 - c_{s}^{2} \right) \right]} \right] - \beta^k,

which each have algebraic multiplicity 1. These are used by Gkeyll in the approximation
of the maximum wave-speed across the computational domain, so as to ensure numerical
stability through explicit enforcement of the CFL condition.

Right eigenvectors
------------------

The right eigenvectors in the :math:`x^1` spatial coordinate direction (i.e. the right
eigenvectors of the :math:`\mathbf{B}^1` Jacobian matrix) are given by:

.. math::
  \mathbf{r}_{0, 1}^{1} = \begin{bmatrix}
  \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho}
  \left. \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  - c_{s}^{2} \right)}\\
  v_1\\
  v_2\\
  v_3\\
  1 - \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho}
  \left. \left( \frac{\partial P}{\partial \varepsilon} \right) \right)\vert_{\rho}
  - c_{s}^{2} \right)}
  \end{bmatrix},

.. math::
  \mathbf{r}_{0, 2}^{1} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^2\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^2\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^2 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^2\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^2
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^2
  \end{bmatrix},

and:

.. math::
  \mathbf{r}_{0, 3}^{1} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^3\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^3\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^3\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^3 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^3
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^3
  \end{bmatrix},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{1}` eigenvalues),
and:

.. math::
  \mathbf{r}_{\pm}^{1} = \begin{bmatrix}
  1\\
  h \sqrt{1 - \gamma_{i j} v^i v^j} \left( v_1 - \frac{v^1
  - \left( \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha} \right)}{\gamma^{1 1}
  - v^1 \left( \frac{\lambda_{\pm}^{1} +\beta^1}{\alpha} \right)} \right)\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_2\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_3\\
  \frac{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \gamma^{1 1}
  - v^1 v^1 \right)}{\gamma^{1 1} - v^1 \left( \frac{\lambda_{\pm}^{1}
  + \beta^1}{\alpha} \right)} - 1
  \end{bmatrix},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{1}` eigenvalues).
The right eigenvectors in the :math:`x^2` spatial coordinate direction (i.e. the right
eigenvectors of the :math:`\mathbf{B}^2` Jacobian matrix) are given by:

.. math::
  \mathbf{r}_{0, 1}^{2} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^1\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^1 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^1\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^1\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^1
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^1
  \end{bmatrix},

.. math::
  \mathbf{r}_{0, 2}^{2} = \begin{bmatrix}
  \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho} \left.
  \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  - c_{s}^{2} \right)}\\
  v_1\\
  v_2\\
  v_3\\
  1 - \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho}
  \left. \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  - c_{s}^{2} \right)}
  \end{bmatrix},

and:

.. math::
  \mathbf{r}_{0, 3}^{2} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^3\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^3\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^3\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^3 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^3
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^3
  \end{bmatrix},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{2}` eigenvalues),
and:

.. math::
  \mathbf{r}_{\pm}^{2} = \begin{bmatrix}
  1\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_1\\
  h \sqrt{1 - \gamma_{i j} v^i v^j} \left( v_2 - \frac{v^2
  - \left( \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right)}{\gamma^{2 2}
  - v^2 \left( \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right)} \right)\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_3\\
  \frac{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \gamma^{2 2}
  - v^2 v^2 \right)}{\gamma^{2 2} - v^2 \left( \frac{\lambda_{\pm}^{2}
  + \beta^2}{\alpha} \right)} - 1
  \end{bmatrix},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{2}` eigenvalues).
Finally, the right eigenvectors in the :math:`x^3` spatial coordinate direction (i.e. the
right eigenvectors of the :math:`\mathbf{B}^3` Jacobian matrix) are given by:

.. math::
  \mathbf{r}_{0, 1}^{3} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^1\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^1 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^1\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^1\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^1
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^1
  \end{bmatrix},

.. math::
  \mathbf{r}_{0, 2}^{3} = \begin{bmatrix}
  \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^2\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_1 v^2\\
  h \left( 1 + 2 \left( 1 - \gamma_{i j} v^i v^j \right) v_2 v^2 \right)\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v_3 v^2\\
  2 h \left( 1 - \gamma_{i j} v^i v^j \right) v^2
  - \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v^2
  \end{bmatrix},

and:

.. math::
  \mathbf{r}_{0, 3}^{3} = \begin{bmatrix}
  \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho} \left.
  \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  - c_{s}^{2} \right)}\\
  v_1\\
  v_2\\
  v_3\\
  1 - \frac{\frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho}}{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \frac{1}{\rho} \left.
  \left( \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  - c_{s}^{2} \right)}
  \end{bmatrix},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{3}` eigenvalues),
and:

.. math::
  \mathbf{r}_{\pm}^{3} = \begin{bmatrix}
  1\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_1\\
  h \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right) v_2\\
  h \sqrt{1 - \gamma_{i j} v^i v^j} \left( v_3 - \frac{v^3
  - \left( \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right)}{\gamma^{3 3}
  - v^3 \left( \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right)} \right)\\
  \frac{h \sqrt{1 - \gamma_{i j} v^i v^j} \left( \gamma^{3 3}
  - v^3 v^3 \right)}{\gamma^{3 3} - v^3 \left( \frac{\lambda_{\pm}^{3}
  + \beta^3}{\alpha} \right)} - 1
  \end{bmatrix},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{3}` eigenvalues).
The corresponding left eigenvectors may now be determined in each çase simply by
inverting the matrix whose columns are given by the right eigenvectors, and then
extracting the corresponding rows.

Left eigenvectors
-----------------

The left eigenvectors in the :math:`x^1` spatial coordinate direction (i.e. the left
eigenvectors of the :math:`\mathbf{B}^1` Jacobian matrix) are given by:

.. math::
  \mathbf{l}_{0, 1}^{1} = \begin{bmatrix}
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \sqrt{1
  - \gamma_{i j} v^i v^j} \left( h v_1 v^1 + \sqrt{1 - \gamma_{i j} v^i v^j} \left(
  v_2 v^2 + v_3 v^3 \right) - h \right) \right)}{c_{s}^{2} \left( v_1 v^1 - 1 \right)}\\
  \frac{\left( c_{s}^{2} - \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \right) v^1
  \left( 1 + \left( v_2 v^2 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} \left( v_1 v^1 - 1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^2 \left( 1
  - \gamma_{i j} v^i v^j \right)}{c_{s}^{2}}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^3 \left( 1
  - \gamma_{i j} v^i v^j \right)}{c_{s}^{2}}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \left( v_2 v^2 + v_3 v^3
  \right) \left( 1 - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} \left( v_1 v^1
  - 1 \right)}
  \end{bmatrix}^{\intercal},

.. math::
  \mathbf{l}_{0, 2}^{1} = \begin{bmatrix}
  - \frac{v_2}{h \left( 1 - v_1 v^1 \right)}\\
  \frac{v_2 v^1}{h \left( 1 - v_1 v^1 \right)}\\
  \frac{1}{h}\\
  0\\
  - \frac{v_2}{h \left( 1 - v_1 v^1 \right)}
  \end{bmatrix}^{\intercal},

and:

.. math::
  \mathbf{l}_{0, 3}^{1} = \begin{bmatrix}
  - \frac{v_3}{h \left( 1 - v_1 v^1 \right)}\\
  \frac{v_3 v^1}{h \left( 1 - v_1 v^1 \right)}\\
  0\\
  \frac{1}{h}\\
  - \frac{v_3}{h \left( 1 - v_1 v^1 \right)}
  \end{bmatrix}^{\intercal},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{1}` eigenvalues),
and:

.. math::
  \mathbf{l}_{\pm}^{1} = \begin{bmatrix}
  \frac{\left( \left( \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha} \right) v^1
  - \gamma^{1 1}  \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha} \right) + c_{s}^{2} \gamma^{1 1} v_1
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^1 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{1}
  + \beta^1}{\alpha} \right) v_1 v^1 + h \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} - c_{s}^{2} \right)
  \left( \left( \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha} \right) - v^1 \right)
  \left( v_1 v^1 - 1 \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)
  + \left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} 
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{1}
  + \beta^1}{\alpha} \right) - v^1 \right) \left( v_2 v^2 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{1}
  - \lambda_{\mp}^{1}}{\alpha} \right) \left( v_1 v^1 - 1 \right) \left( v^1 v^1
  - \gamma^{1 1} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \gamma^{1 1} - \left( \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha}
  \right) v^1 \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left( \left(
  \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha} \right) - v^1 \right) v^1
  + c_{s}^{2} \left( \gamma^{1 1} - \left( \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha}
  \right) v^1 \right) + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha} \right)
  - v^1 \right) v^1 \left( v_2 v^2 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{1}
  - \lambda_{\mp}^{1}}{\alpha} \right) \left( v_1 v^1 - 1 \right) \left( v^1 v^1
  - \gamma^{1 1} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{1}
  + \beta^1}{\alpha} \right) - v^1 \right) \left( \gamma^{1 1} - \left(
  \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha} \right) v^1 \right) v^2 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{1}
  - \lambda_{\mp}^{1}}{\alpha} \right) \left( \gamma^{1 1} - v^1 v^1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\varepsilon} \right)
  \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{1}
  + \beta^1}{\alpha} \right) - v^1 \right) \left( \gamma^{1 1} - \left(
  \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha} \right) v^1 \right) v^3 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{1}
  - \lambda_{\mp}^{1}}{\alpha} \right) \left( \gamma^{1 1} - v^1 v^1 \right)}\\
  \frac{\left( \left( \frac{\lambda_{\pm}^{1} + \beta^1}{\alpha} \right) v^1
  - \gamma^{1 1} \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha} \right) + c_{s}^{2} \gamma^{1 1} v_1
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^1 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha}
  \right) v_1 v^1 + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{1} + \beta^1}{\alpha}
  \right) \right) - v^1 \right) \left( v_2 v^2 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{1}
  - \lambda_{\mp}^{1}}{\alpha} \right) \left( v_1 v^1 - 1 \right) \left( v^1 v^1
  - \gamma^{1 1} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}
  \end{bmatrix}^{\intercal},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{1}` eigenvalues).
The left eigenvectors in the :math:`x^2` spatial coordinate direction (i.e. the left
eigenvectors of the :math:`\mathbf{B}^2` Jacobian matrix) are given by:

.. math::
  \mathbf{l}_{0, 1}^{2} = \begin{bmatrix}
  - \frac{v_1}{h \left( 1 - v_2 v^2 \right)}\\
  \frac{1}{h}\\
  \frac{v_1 v^2}{h \left( 1 - v_2 v^2 \right)}\\
  0\\
  - \frac{v_1}{h \left( 1 - v_2 v^2 \right)}
  \end{bmatrix}^{\intercal},

.. math::
  \mathbf{l}_{0, 2}^{2} = \begin{bmatrix}
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \sqrt{1
  - \gamma_{i j} v^i v^j} \left( h v_2 v^2 + \sqrt{1 - \gamma_{i j} v^i v^j} \left(
  v_1 v^1 + v_3 v^3 \right) - h \right) \right)}{c_{s}^{2} \left( v_2 v^2 - 1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^1 \left( 1 - \gamma_{i j} v^i v^j
  \right)}{c_{s}^{2}}\\
  \frac{\left( c_{s}^{2} - \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \right) v^2
  \left( 1 + \left( v_1 v^1 + v_3 v^3 \right) \left( 1 - \gamma_{i j} v^i v^j \right)
  \right)}{c_{s}^{2} \left( v_2 v^2 - 1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^3 \left( 1 - \gamma_{i j} v^i v^j
  \right)}{c_{s}^{2}}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \left( v_1 v^1 + v_3 v^3
  \right) \left( 1 - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} \left( v_2 v^2
  - 1 \right)}
  \end{bmatrix}^{\intercal},

and:

.. math::
  \mathbf{l}_{0, 3}^{2} = \begin{bmatrix}
  - \frac{v_3}{h \left( 1 - v_2 v^2 \right)}\\
  0\\
  \frac{v_3 v^2}{h \left( 1 - v_2 v^2 \right)}\\
  \frac{1}{h}\\
  - \frac{v_3}{h \left( 1 - v_2 v^2 \right)}
  \end{bmatrix}^{\intercal},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{2}` eigenvalues),
and:

.. math::
  \mathbf{l}_{\pm}^{2} = \begin{bmatrix}
  \frac{\left( \left( \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right) v^2
  - \gamma^{2 2}  \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha} \right) + c_{s}^{2} \gamma^{2 2} v_2
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^2 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{2}
  + \beta^2}{\alpha} \right) v_2 v^2 + h \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} - c_{s}^{2} \right)
  \left( \left( \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha} \right) - v^2 \right)
  \left( v_2 v^2 - 1 \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)
  + \left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} 
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{2}
  + \beta^2}{\alpha} \right) - v^2 \right) \left( v_1 v^1 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{2}
  - \lambda_{\mp}^{2}}{\alpha} \right) \left( v_2 v^2 - 1 \right) \left( v^2 v^2
  - \gamma^{2 2} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{2}
  + \beta^2}{\alpha} \right) - v^2 \right) \left( \gamma^{2 2} - \left(
  \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right) v^2 \right) v^1 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{2}
  - \lambda_{\mp}^{2}}{\alpha} \right) \left( \gamma^{2 2} - v^2 v^2 \right)}\\
  \frac{\left( \gamma^{2 2} - \left( \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha}
  \right) v^2 \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left( \left(
  \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha} \right) - v^2 \right) v^2
  + c_{s}^{2} \left( \gamma^{2 2} - \left( \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha}
  \right) v^2 \right) + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha} \right)
  - v^2 \right) v^2 \left( v_1 v^1 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{2}
  - \lambda_{\mp}^{2}}{\alpha} \right) \left( v_2 v^2 - 1 \right) \left( v^2 v^2
  - \gamma^{2 2} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\varepsilon} \right)
  \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{2}
  + \beta^2}{\alpha} \right) - v^2 \right) \left( \gamma^{2 2} - \left(
  \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right) v^2 \right) v^3 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{2}
  - \lambda_{\mp}^{2}}{\alpha} \right) \left( \gamma^{2 2} - v^2 v^2 \right)}\\
  \frac{\left( \left( \frac{\lambda_{\pm}^{2} + \beta^2}{\alpha} \right) v^2
  - \gamma^{2 2} \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha} \right) + c_{s}^{2} \gamma^{2 2} v_2
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^2 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha}
  \right) v_2 v^2 + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{2} + \beta^2}{\alpha}
  \right) \right) - v^2 \right) \left( v_1 v^1 + v_3 v^3 \right) \left( 1
  - \gamma_{i j} v^i v^j \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{2}
  - \lambda_{\mp}^{2}}{\alpha} \right) \left( v_2 v^2 - 1 \right) \left( v^2 v^2
  - \gamma^{2 2} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}
  \end{bmatrix}^{\intercal},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{2}` eigenvalues).
Finally, the left eigenvectors in the :math:`x^3` spatial coordinate direction (i.e.
the left eigenvectors of the :math:`\mathbf{B}^3` Jacobian matrix) are given by:

.. math::
  \mathbf{l}_{0, 1}^{3} = \begin{bmatrix}
  - \frac{v_1}{h \left( 1 - v_3 v^3 \right)}\\
  \frac{1}{h}\\
  0\\
  \frac{v_1 v^3}{h \left( 1 - v_3 v^3 \right)}\\
  - \frac{v_1}{h \left( 1 - v_3 v^3 \right)}
  \end{bmatrix}^{\intercal},

.. math::
  \mathbf{l}_{0, 2}^{3} = \begin{bmatrix}
  - \frac{v_2}{h \left( 1 - v_3 v^3 \right)}\\
  0\\
  \frac{1}{h}\\
  \frac{v_2 v^3}{h \left( 1 - v_3 v^3 \right)}\\
  - \frac{v_2}{h \left( 1 - v_3 v^3 \right)}
  \end{bmatrix}^{\intercal},

and:

.. math::
  \mathbf{l}_{0, 3}^{3} = \begin{bmatrix}
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \sqrt{1
  - \gamma_{i j} v^i v^j} \left( h v_3 v^3 + \sqrt{1 - \gamma_{i j} v^i v^j} \left(
  v_1 v^1 + v_2 v^2 \right) - h \right) \right)}{c_{s}^{2} \left( v_3 v^3 - 1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^1 \left( 1 - \gamma_{i j} v^i v^j
  \right)}{c_{s}^{2}}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) v^2 \left( 1- \gamma_{i j} v^i v^j
  \right)}{c_{s}^{2}}\\
  \frac{\left( c_{s}^{2} - \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \right) v^3 \left(
  1 + \left( v_1 v^1 + v_2 v^2 \right) \left( 1 - \gamma_{i j} v^i v^j \right)
  \right)}{c_{s}^{2} \left( v_3 v^3 - 1 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} - c_{s}^{2} \right) \left( 1 + \left( v_1 v^1 + v_2 v^2
  \right) \left( 1 - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} \left( v_3 v^3
  - 1 \right)}
  \end{bmatrix}^{\intercal},

for the 3 material waves (corresponding to the 3 :math:`\lambda_{0}^{3}` eigenvalues),
and:

.. math::
  \mathbf{l}_{\pm}^{3} = \begin{bmatrix}
  \frac{\left( \left( \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right) v^3
  - \gamma^{3 3}  \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha} \right) + c_{s}^{2} \gamma^{3 3} v_3
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^3 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{3}
  + \beta^3}{\alpha} \right) v_3 v^3 + h \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} - c_{s}^{2} \right)
  \left( \left( \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha} \right) - v^3 \right)
  \left( v_3 v^3 - 1 \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)
  + \left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} 
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{3}
  + \beta^3}{\alpha} \right) - v^3 \right) \left( v_1 v^1 + v_2 v^2 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{3}
  - \lambda_{\mp}^{3}}{\alpha} \right) \left( v_3 v^3 - 1 \right) \left( v^3 v^3
  - \gamma^{3 3} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon}
  \right) \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{3}
  + \beta^3}{\alpha} \right) - v^3 \right) \left( \gamma^{3 3} - \left(
  \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right) v^3 \right) v^1 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{3}
  - \lambda_{\mp}^{3}}{\alpha} \right) \left( \gamma^{3 3} - v^3 v^3 \right)}\\
  \frac{\left( \frac{1}{\rho} \left. \left( \frac{\partial P}{\varepsilon} \right)
  \right\vert_{\rho} + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{3}
  + \beta^3}{\alpha} \right) - v^3 \right) \left( \gamma^{3 3} - \left(
  \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right) v^3 \right) v^2 \left( \sqrt{1
  - \gamma_{i j} v^i v^j} \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{3}
  - \lambda_{\mp}^{3}}{\alpha} \right) \left( \gamma^{3 3} - v^3 v^3 \right)}\\
  \frac{\left( \gamma^{3 3} - \left( \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha}
  \right) v^3 \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left( \left(
  \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha} \right) - v^3 \right) v^3
  + c_{s}^{2} \left( \gamma^{3 3} - \left( \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha}
  \right) v^3 \right) + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha} \right)
  - v^3 \right) v^3 \left( v_1 v^1 + v_2 v^2 \right) \left( 1
  - \gamma_{i j} v^i v^j \right) \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{3}
  - \lambda_{\mp}^{3}}{\alpha} \right) \left( v_3 v^3 - 1 \right) \left( v^3 v^3
  - \gamma^{3 3} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}\\
  \frac{\left( \left( \frac{\lambda_{\pm}^{3} + \beta^3}{\alpha} \right) v^3
  - \gamma^{3 3} \right) \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho} \left(
  \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha} \right) + c_{s}^{2} \gamma^{3 3} v_3
  - \frac{1}{\rho} \left. \left( \frac{\partial P}{\partial \varepsilon} \right)
  \right\vert_{\rho} v^3 - c_{s}^{2} \left( \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha}
  \right) v_3 v^3 + \left( \frac{1}{\rho} \left. \left(
  \frac{\partial P}{\partial \varepsilon} \right) \right\vert_{\rho}
  + c_{s}^{2} \right) \left( \left( \frac{\lambda_{\mp}^{3} + \beta^3}{\alpha}
  \right) \right) - v^3 \right) \left( v_1 v^1 + v_2 v^2 \right) \left( 1
  - \gamma_{i j} v^i v^j \right)}{c_{s}^{2} h \left( \frac{\lambda_{\pm}^{3}
  - \lambda_{\mp}^{3}}{\alpha} \right) \left( v_3 v^3 - 1 \right) \left( v^3 v^3
  - \gamma^{3 3} \right) \left( \sqrt{1 - \gamma_{i j} v^i v^j} \right)}
  \end{bmatrix}^{\intercal},

for the 2 acoustic waves (corresponding to the 2 :math:`\lambda_{\pm}^{3}` eigenvalues).

References
----------

.. [Anile1989] A. M. Anile, *Relativistic Fluids and Magneto-fluids: With Applications
   in Astrophysics and Plasma Physics*, Cambridge University Press. 1989.

.. [Eulderink1995] F. Eulderink and G. Mellema, "General Relativistic Hydrodynamics
   with a Roe solver", *Astronomy and Astrophysics Supplement Series* **110**: 587-623.
   1995.

.. [Banyuls1997] F. Banyuls, J. A. Font, J. M. Ibáñez, J. M. Martí and J. A. Miralles,
   "Numerical {3 + 1} General Relativistic Hydrodynamics: A Local Characteristic
   Approach", *The Astrophysical Journal* **476** (1): 221-231. 1997.