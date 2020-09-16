.. _neutralModels:

Neutral models in Gkeyll
++++++++++++++++++++++++

Simplified models of plasma-neutral interactions available in Gkeyll. The neutral species is always modeled as a kinetic Boltzmann species using the Vlasov-Maxwell solver, while the plasma species to which it is coupled can be either Vlasov-Maxwell or Gyrokinetic. 

.. contents::


Electron-impact Ionization
--------------------------

This process is given by :math:`e^{-} + n \rightarrow i^{+} + 2e^{-} - E_{iz}`, where :math:`E_{iz}` is the ionization energy and modeled by collision terms on the RHS of the dynamical equations, as in [Wersal2015]_:

.. math::

   \frac{d f_n}{d t} &= -n_e \langle v_{e} \sigma_{iz}(v_e)\rangle f_n, \\
   \frac{d f_i}{d t} &= n_e \langle v_{e} \sigma_{iz}(v_e)\rangle f_n, \\
   \frac{d f_e}{d t} &= -n_n \langle v_{e} \sigma_{iz}(v_e)\rangle [2 f_{M,iz} - f_e],

where :math:`f_{M,iz} = f_{M,iz}(n_e, \mathbf{u}_n, v^2_{th,iz})` is a Maxwellian distribution function that accounts for the lower-energy elelectrons resulting from this process. (See [reference section below] for definitions of Maxwellian distribution function on the Vlasov-Maxwell and gyrokinetic grids.) :math:`n_e` is the electron density, :math:`\mathbf{u}_n` is the neutral fluid velocity, and :math:`v^2_{th,iz}` is defined by

.. math::

   v^2_{th,iz} = \frac{v^2_{th,e}}{2} - \frac{E_{iz}}{3m_e}.

Currently the ionization rate :math:`\langle v_{e} \sigma_{iz}(v_e)\rangle` is estimated by the fitting function from [Voronov1997]_

.. math::

   \langle v_e \sigma_{iz} \rangle = A  \frac{1 + P \, (E_{iz}/T_e)^{1/2}}{X + E_{iz}/T_e} \left(\frac{E_{iz}}{T_e}\right)^K e^{-E_{iz}/T_e} \, \times 10^{-6} {\rm m}^{3}/{\rm s}, 

where :math:`A`, :math:`K`, :math:`P` and :math:`X` are tabulated for elements up to :math:`Z=28`. To avoid unphysical negative temperatures, when :math:`v^2_{th,iz} < 0` the ionization rate is set to zero in the code.
   
Charge exchange
---------------

This process is given by :math:`i^{+} + n \rightarrow n + i^{+}`, and the simplifed model of this process contained within Gkeyll is based on [Meier2012]_. Collision terms appear in the ion and neutral equations as:

..  math::

    \frac{d f_i}{dt} &=  \sigma_{cx} V_{cx}( n_i f_n - n_n f_i ) \\
    \frac{d f_n}{dt} &= -\frac{m_i}{m_n}\sigma_{cx} V_{cx} (n_i f_n - n_n f_i),

where

.. math::

    V_{cx} &\equiv \sqrt{\frac{4}{\pi}v_{t,i}^2 + \frac{4}{\pi}v_{t,n}^2 + v^2_{in}}, \\
    v_{in} &\equiv |\mathbf{u}_i - \mathbf{u}_n|.

The cross section is approximated by a fitting function. For hydrogen and Deuterium these are given by, respectively

.. math::

    \sigma_{cx, H} = 1.12 \times 10^{-18} - 7.15 \times 10^{-20} \ln(V_{cx}), \\
    \sigma_{cx, D} = 1.09 \times 10^{-18} - 7.15 \times 10^{-20} \ln(V_{cx}).


Kinetic Boltzmann and gyrokinetic species coupling
--------------------------------------------------

Kinetic Boltzmann eutral species are always evolved on the Vlasov grid. For a Vlasov-Maxwell plasma species, the neutrals and ions are evolved on identical phase-space grids. Thus, the interaction terms in [ref eqns. here] are straightforward. However, when the plasma species are evolved using the gyrokinetic model, the ion and neutral velocity-space grids are no longer identical and it becomes necessary to pass information between two different phase-space grids. This is accomplished by taking fluid moments, :math:`n`, :math:`\mathbf{u}`, and :math:`v^2_{th}`, of the species distribution function and using them to project a Maxwellian distribution function on the destination phase-space grid. This is valid assuming that ion and neutral distribution functions are approximately Maxwellian.

In the Vlasov-Maxwell formulation, a Maxwellian distribution is defined

.. math::

  f_{M,VM}(\mathbf{x}, \mathbf{v}) = \frac{n}{\left(2\pi v_{th}^2\right)^{d_v/2}}
  \exp\left[-\frac{\left(\mathbf{v}-\mathbf{u}\right)^2}{2v_{th}^2}\right],

where :math:`d_v` is the velocity-space dimension, which is identical to VDIM. In the gyrokinetic formulation a Maxwellian distribution function is defined

.. math::

   f_{M,GK}(\mathbf{x}, \mathbf{v}) = \frac{n}{\left(2\pi v_{th}^2\right)^{3/2}}
   \exp\left[-\frac{\left(v_\parallel- u_\parallel \right)^2}{2v_{th}^2} - \frac{B \mu}{m v^2_{th}}\right],

where we have assumed the gyrokinetic grid is either 1X2V or 3X2V. For more details about VM and GK, see [app_vm] and [app_gk], respectively. Note that in the gyrokinetic formulation, the fluid velocity moment contains only one component, :math:`u_\parallel`, which is along the magnetic field line. However, the neutral fluid velocity contains 3 components. It is assumed that once a neutral particle is ionized, the perpendicular components are immediately "smeared out" by the gyro-motion. Thus, only the :math:`z`-component of the neutral fluid velocity moment is included in the Maxwellian projection on the gyrokinetic grid. Conversely, the ion fluid velocity moment contains only one component. Thus, the ion Maxwellian distribution function on the 3V Vlasov grid contains the fluid moment :math:`\mathbf{u}_i = (u_x = 0, u_y = 0, u_z = u_{\parallel,i})`.

The collision terms in this gyrokinetic-Vlasov coupling become

.. math::

   \frac{d}{dt}\mathcal{J}f_i(\mathbf{R}, v_\parallel, \mu, t) &= n_e  \langle \sigma_{iz} v_e \rangle \mathcal{J} f_{M,GK}(n_n, u_{z,n}, v_{th,n}^2) + \sigma_{cx} V_{cx}[ n_i \mathcal{J} f_{M,GK}(n_n, u_{z,n}, v_{th,n}^2) - n_n \mathcal{J} f_i], \\
   \frac{d}{dt}f_n(\mathbf{x}, \mathbf{v}, t) &= n_e f_n \langle \sigma_{iz} v_e \rangle -\frac{m_i}{m_n}\sigma_{cx} V_{cx} [n_i f_n - n_n f_{M,VM}(n_i, u_{\parallel,i}, v_{th,i}^2)].

Neutral interactions in Gkeyll input files
------------------------------------------

Electron-impact ionization
``````````````````````````

Charge exchange
```````````````


References
----------


.. [Wersal2015] Wersal, C., & Ricci, P. (2015). A first-principles self-consistent model of plasma turbulence and kinetic neutral dynamics in the tokamak scrape-off layer. Nuclear Fusion, 55(12), 123014.
		
.. [Voronov1997] Voronov, G. S. (1997). A practical fit formula for ionization rate coefficients of atoms and ions by electron impact: Z = 1-28. Atomic Data and Nuclear Data Tables, 65(1), 1–35.
		 
.. [Meier2012] Meier, E. T., & Shumlak, U. (2012). A general nonlinear fluid model for reacting plasma-neutral mixtures. Physics of Plasmas, 19(7).


		
