A Set of Normalized Units of the Vlasov-Maxwell System of Equations
+++++++++++++++++++++++++++++++++++++++++++++++++++++

The Gkyl design philosophy involves the implementation of unit-full systems of equations, i.e., Gkyl simulations can be run with real parameters for direct comparison with experiments, with universal constants specified by using values provided by the National Institute of Standards and Technology. For example, in the absence of collisions, the Vlasov-Maxwell system of equations in S.I. units is as follows,

.. math::

   \frac{\partial f_s}{\partial t} + \mathbf{v} \cdot \nabla_{\mathbf{x}} f_s + \frac{q_s}{m_s} (\mathbf{E} + \mathbf{v} \times \mathbf{B}) \cdot \nabla_{\mathbf{v}} f_s &= 0, \\
   \frac{\partial \mathbf{B}}{\partial t} + \nabla_{\mathbf{x}} \times \mathbf{E} = 0, \quad & \nabla_{\mathbf{x}} \cdot \mathbf{B} = 0, \\
   epsilon_0\mu_0\frac{\partial \mathbf{E}}{\partial t} - \nabla_{\mathbf{x}} \times \mathbf{B} = -\mu_0 \mathbf{J}, \quad &  \nabla_{\mathbf{x}} \cdot \mathbf{E} = \frac{\rho_c}{\epsilon_0} \\
   \rho_c = \sum_s q_s \int_{-\infty}^{\infty} f_s d\mathbf{v}, \quad & \mathbf{J} = \sum_s q_s \int_{-\infty}^{\infty} \mathbf{v} f_s d\mathbf{v}.

However, one may not always wish to run simulations with the unit-full system. Instead, one can consider a normalized set of equations. A natural choice for the normalization of the Vlasov-Maxwell system of equations would redefine all the relevant quantities as follows,

.. math::

   t & = \omega_{pe}^{-1} \tau, \\
   \mathbf{x} & = d_e \boldsymbol \chi, \\
   \mathbf{v} & = c \boldsymbol \nu, \\
   q_s & = e \tilde{q_s}, \\
   m_s & = m_e \tilde{m_s}, \\
   n_s & = n_0 \tilde{n}, \\
   \mathbf{E} & = \frac{e n_0 d_e}{\epsilon_0} \tilde{\mathbf{E}}, \\
   \mathbf{B} & = \frac{e n_0}{\epsilon_0 \omega_{pe}} \tilde{\mathbf{B}},

where

.. math::

   c & = \frac{1}{\sqrt{\epsilon_0 \mu_0}} \\
   \omega_{pe} & = \sqrt{\frac{e^2 n}{m_e \epsilon_0}} \\
   d_e & = \frac{c}{\omega_{pe}},

are the speed of light, electron plasma frequency, and the electron skin depth respectively. Note that the charge normalization means that in a proton-electron plasma, :math:`\tilde{q}_s = \pm 1`, and the density normalization is such that in a quasi-neutral plasma, the initial density of each species is 1.0. We can also check that the electric and magnetic field normalizations are reasonable by making sure that the normalization has the correct units for the electric and magnetic fields in S.I. units, 

.. math::

   \frac{e n d_e}{\epsilon_0} & \quad \rightarrow \quad \frac{C \frac{1}{m^3} m}{\frac{C^2}{N m^2}} = \frac{N}{C} \\
   \frac{e n}{\epsilon_0 \omega_{pe}} & \quad \rightarrow \quad \frac{C \frac{1}{m^3}}{\frac{A^2 s^4}{kg m^3} \frac{1}{s}} = \frac{kg}{A s^2} = T.

With these normalizations, the Vlasov-Maxwell system of equations then becomes,

.. math::

   \frac{\partial f_s}{\partial \tau} + \boldsymbol \nu \cdot \nabla_{\boldsymbol \chi} f_s + \frac{\tilde{q}_s}{\tilde{m}_s} (\tilde{\mathbf{E}} + \boldsymbol \nu \times \tilde{\mathbf{B}}) \cdot \nabla_{\boldsymbol \nu} f_s &= 0, \\
   \frac{\partial \tilde{\mathbf{B}}}{\partial \tau} + \nabla_{\boldsymbol \chi} \times \tilde{\mathbf{E}} = 0, \quad & \nabla_{\boldsymbol \chi} \cdot \tilde{\mathbf{B}} = 0, \\
   \frac{\partial \tilde{\mathbf{E}}}{\partial \tau} - \nabla_{\boldsymbol \chi} \times \tilde{\mathbf{B}} = -\tilde{\mathbf{J}}, \quad &  \nabla_{\boldsymbol \chi} \cdot \mathbf{E} = \tilde{\rho_c} \\
   \tilde{\rho_c} = \sum_s \tilde{q}_s \int_{-\infty}^{\infty} f_s d\boldsymbol \nu, \quad & \tilde{\mathbf{J}} = \sum_s \tilde{q}_s \int_{-\infty}^{\infty} \boldsymbol \nu f_s d\boldsymbol \nu.
