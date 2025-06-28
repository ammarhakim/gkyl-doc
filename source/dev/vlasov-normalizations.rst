.. _vlasovNorm:

Normalized units for the Vlasov-Maxwell system 
++++++++++++++++++++++++++++++++++++++++++++++

Many equation systems in Gkeyll are implemented in unit-full forms for ease of cross comparison 
with experiments. As such, equation systems such as the Vlasov-Maxwell system of equations are 
defined in Gkeyll in S.I units:

.. math::

   \frac{\partial f_s}{\partial t} + \mathbf{v} \cdot \nabla_{\mathbf{x}} \thinspace f_s + \frac{q_s}{m_s} (\mathbf{E} + \mathbf{v} \times \mathbf{B}) \cdot & \nabla_{\mathbf{v}} \thinspace f_s= 0, \\
   \frac{\partial \mathbf{B}}{\partial t} + \nabla_{\mathbf{x}} \times \mathbf{E} = 0, \qquad & \nabla_{\mathbf{x}} \cdot \mathbf{B} = 0, \\
   \epsilon_0\mu_0\frac{\partial \mathbf{E}}{\partial t} - \nabla_{\mathbf{x}} \times \mathbf{B} = -\mu_0 \mathbf{J}, \qquad &  \nabla_{\mathbf{x}} \cdot \mathbf{E} = \frac{\rho_c}{\epsilon_0} \\
   \rho_c = \sum_s q_s \int_{-\infty}^{\infty} f_s \thinspace d\mathbf{v}, \qquad & \mathbf{J} = \sum_s q_s \int_{-\infty}^{\infty} \mathbf{v} f_s \thinspace d\mathbf{v}.

The expectation is thus that a user define these various constants: 
:math:`\epsilon_0, \mu_0, q_s, m_s,` etc. Utilizing the provided Lib.Constants library 
in Gkeyll allows a user to use universal constants provided by the National Institute of 
Standards and Technology. However, one may not always wish to run simulations with the 
unit-full system. Instead, one can consider a normalized set of equations. 
A natural choice for the normalization of the Vlasov-Maxwell system of equations 
would redefine all the relevant quantities as follows,

.. math::

   t & = \omega_{pe}^{-1} \thinspace \tau, \\
   \mathbf{x} & = d_e \thinspace \boldsymbol \chi, \\
   \mathbf{v} & = c \thinspace \boldsymbol \nu, \\
   q_s & = e \thinspace \tilde{q_s}, \\
   m_s & = m_e \thinspace \tilde{m_s}, \\
   n_s & = n_0 \thinspace \tilde{n}, \\
   \mathbf{E} & = \frac{e n_0 d_e}{\epsilon_0} \tilde{\mathbf{E}}, \\
   \mathbf{B} & = \frac{e n_0}{\epsilon_0 \omega_{pe}} \tilde{\mathbf{B}},

where

.. math::

   c & = \frac{1}{\sqrt{\epsilon_0 \mu_0}}, \\
   \omega_{pe} & = \sqrt{\frac{e^2 n}{m_e \epsilon_0}}, \\
   d_e & = \frac{c}{\omega_{pe}},

are the speed of light, electron plasma frequency, and the electron skin depth respectively. 
Note that the charge normalization means that in a proton-electron plasma, :math:`\tilde{q}_s = \pm 1`, 
and the density normalization is such that in a quasi-neutral plasma, the initial density 
of each species is 1.0. We can also check that the electric and magnetic field normalizations 
are reasonable by making sure that the normalization has the correct units for the electric 
and magnetic fields in S.I. units, 

.. math::

   \frac{e n d_e}{\epsilon_0} & \quad \rightarrow \quad \frac{C \frac{1}{m^3} m}{\frac{C^2}{N m^2}} = \frac{N}{C} \\
   \frac{e n}{\epsilon_0 \omega_{pe}} & \quad \rightarrow \quad \frac{C \frac{1}{m^3}}{\frac{A^2 s^4}{kg m^3} \frac{1}{s}} = \frac{kg}{A s^2} = T.

With these normalizations, the Vlasov-Maxwell system of equations then becomes,

.. math::

   \frac{\partial f_s}{\partial \tau} + \boldsymbol \nu \cdot \nabla_{\boldsymbol \chi} \thinspace f_s + \frac{\tilde{q}_s}{\tilde{m}_s} (\tilde{\mathbf{E}} + \boldsymbol \nu \times \tilde{\mathbf{B}}) \cdot & \nabla_{\boldsymbol \nu} \thinspace f_s= 0, \\
   \frac{\partial \tilde{\mathbf{B}}}{\partial \tau} + \nabla_{\boldsymbol \chi} \times \tilde{\mathbf{E}} = 0, \quad & \nabla_{\boldsymbol \chi} \cdot \tilde{\mathbf{B}} = 0, \\
   \frac{\partial \tilde{\mathbf{E}}}{\partial \tau} - \nabla_{\boldsymbol \chi} \times \tilde{\mathbf{B}} = -\tilde{\mathbf{J}}, \quad &  \nabla_{\boldsymbol \chi} \cdot \mathbf{E} = \tilde{\rho_c} \\
   \tilde{\rho_c} = \sum_s \tilde{q}_s \int_{-\infty}^{\infty} f_s \thinspace d\boldsymbol \nu, \quad & \tilde{\mathbf{J}} = \sum_s \tilde{q}_s \int_{-\infty}^{\infty} \boldsymbol \nu f_s \thinspace d\boldsymbol \nu.

This system of equations has the obvious advantage that universal constants, such as :math:`\epsilon_0`, 
are eliminated. In doing so, one does not need to worry about the propagation of round off error from, 
for example, the accumulation of the current to the electric field in the Ampere-Maxwell law, 
:math:`E^{n+1} = E^{n} + \Delta t \mathbf{J}/\epsilon_0` becomes :math:`E^{n+1} = E^{n} + \Delta t \tilde{\mathbf{J}}`. 
Given Gkeyll's unit-full representation, a simple way to force the Vlasov-Maxwell solver to "use" 
these units is to specify the following parameters be equal to 1.0,

.. math::

   \epsilon_0 = 1.0, & \qquad \mu_0 = 1.0, \qquad c = 1.0, \\
   m_e = 1.0, & \qquad q_i = 1.0, \qquad q_e = -1.0, \\
   \omega_{pe} = 1.0, & \qquad d_e = 1.0, \\
   n_0 = 1.0. &

With the above parameters set to 1.0, then Vlasov-Maxwell simulations require only a few parameters 
to be completely determined. In a proton-electron plasma these are: the proton-to-electron mass ratio, 
:math:`m_p/m_e`, the proton-to-electron temperature ratio, :math:`T_p/T_e`, the ratio of some 
characteristic velocity, such as the electron Alfv\'en speed, to the speed of light, :math:`v_{A_e}/c`, 
and the plasma beta of either the protons or the electrons, :math:`\beta`. It is often convenient 
with this normalized system to use the combination of the ratio of the electron  Alfv\'en speed 
to the speed of light and the plasma beta to derive the temperature in normalized units, like so,

.. math::

   \frac{v_{A_e}}{c} & = \frac{|\mathbf{B}|/\sqrt{n_e m_e \mu_0}}{c} \qquad \rightarrow \qquad \tilde{v_{A_e}} = |\tilde{\mathbf{B}}|, \\
   \beta_e & = \frac{ 2 n_e T_e \mu_0}{|\mathbf{B}|^2} \qquad \rightarrow \qquad \tilde{T_e} = \tilde{\beta_e} \tilde{v_{A_e}}^2/2.0,

assuming the plasma is quasineutral and thus, :math:`n_0 = 1.0` for both the protons and electrons. 
The proton beta and proton temperature then follow from the specified proton-to-electron temperature 
ratio. It is recommended that the user initialize Maxwellian distribution functions using this derived 
temperature, so as to avoid the ambiguity of the user's definition of the thermal velocity,

.. math::

   f_{\textrm{maxwellian}} = \frac{\tilde{n_s}}{\sqrt{2 \pi \tilde{T_s}/\tilde{m_s}}} \exp \left (-\tilde{m_s} \frac{(\boldsymbol\nu - \tilde{\mathbf{u}_s})^2}{2 \tilde{T_s}} \right ).

Whether the user ultimately elects to use :math:`v_{th_s} = \sqrt{2 T_s/m_s}` or 
:math:`v_{th_s} = \sqrt{T_s/m_s}` is of no consequence to the initialization of the simulation, 
and likely only to manifest in the user's specification of the velocity space extents. Indeed, if 
a user employs the LTE (local thermodynamic equilibrium) initial condition module, then 
the expected input is the temperature, **not the thermal velocity**. 

These normalized units can also be utilized in multi-fluid simulations of plasmas---see 
the :doc:`multi-fluid quickstart example <quickstart>`, which defines 

.. math::

   \epsilon_0 & = 1.0, \qquad \mu_0 = 1.0, \qquad c = 1.0, \\
   m_e & = 1.0/25.0, \qquad m_i = 1.0, \qquad q_i = 1.0, \qquad q_e = -1.0, \\
   n_0 & = 1.0,

and thus the derived quantities are

.. math::

   \omega_{pe} = 5.0, \qquad d_e = 1.0/5.0, \qquad \omega_{pi} = 1.0, \qquad d_i = 1.0. 

Note that in this case the ion scales are defined as the reference scales, and quantities such as the 
inverse electron plasma frequency, :math:`\omega_{pe}^{-1}`, and electron inertial length are 
:math:`\sqrt{m_e/m_i}` smaller than the inverse ion plasma frequency and ion inertial length. 
