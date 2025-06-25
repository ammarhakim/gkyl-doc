.. _app_neut:

Neutral models in Gkeyll
++++++++++++++++++++++++

Simplified models of plasma-neutral interactions available in Gkeyll. The neutral species is always modeled as a kinetic Boltzmann species using the Vlasov-Maxwell solver, while the plasma species to which it is coupled can be either Vlasov-Maxwell or gyrokinetic.

.. contents::

Electron-impact Ionization
--------------------------

This process is given by :math:`e^{-} + n \rightarrow i^{+} + 2e^{-} - E_{iz}`, where :math:`E_{iz}` is the ionization energy and modeled by collision terms on the RHS of the dynamical equations, as in [Wersal2015]_:

.. math::
   :label: izElc
	   
   \frac{d f_e}{d t} = -n_n \langle v_{e} \sigma_{iz}\rangle (2 f_{M,iz} - f_e),

.. math::
   :label: izIon
	  
   \frac{d f_i}{d t} = n_e \langle v_{e} \sigma_{iz}\rangle f_n, 
   
.. math::
   :label: izNeut
	   
   \frac{d f_n}{d t} = -n_e \langle v_{e} \sigma_{iz}\rangle f_n,


where :math:`f_{M,iz} = f_{M,iz}(n_e, \mathbf{u}_n, v^2_{th,iz})` is a Maxwellian distribution function that accounts for the lower-energy elelectrons resulting from this process. (See :ref:`Neutral species and gyrokinetic plasma species coupling` for definitions of Maxwellian distribution function on the Vlasov-Maxwell and gyrokinetic grids.) :math:`n_e` is the electron density, :math:`\mathbf{u}_n` is the neutral fluid velocity, and :math:`v^2_{th,iz}` is defined by

.. math::

   v^2_{th,iz} = \frac{v^2_{th,e}}{2} - \frac{E_{iz}}{3m_e}.

Currently the ionization rate :math:`\langle v_{e} \sigma_{iz}\rangle` is approximated using the fitting function from [Voronov1997]_

.. math::

   \langle v_e \sigma_{iz} \rangle = A  \frac{1 + P \, (E_{iz}/T_e)^{1/2}}{X + E_{iz}/T_e} \left(\frac{E_{iz}}{T_e}\right)^K e^{-E_{iz}/T_e} \, \times 10^{-6} {\rm m}^{3}/{\rm s}, 

where :math:`A`, :math:`K`, :math:`P` and :math:`X` are tabulated for elements up to :math:`Z=28`. To avoid unphysical negative temperatures, when :math:`v^2_{th,iz} < 0` the ionization rate is set to zero in the code.

A similar model of ionization was previously used in Gkeyll and was presented in [Cagas2017]_.
   
Charge exchange
---------------

This process is given by :math:`i^{+} + n \rightarrow n + i^{+}`, and the simplifed model of this process contained within Gkeyll is based on [Meier2012]_. Collision terms appear in the ion and neutral equations as:

..  math:: \frac{d f_i}{dt} =  \sigma_{cx} V_{cx}( n_i f_n - n_n f_i ),
    :label: cxIon

..  math:: \frac{d f_n}{dt} = -\sigma_{cx} V_{cx} (n_i f_n - n_n f_i),
    :label: cxNeut
 
where

.. math::

    V_{cx} &\equiv \sqrt{\frac{4}{\pi}v_{t,i}^2 + \frac{4}{\pi}v_{t,n}^2 + v^2_{in}}, \\
    v_{in} &\equiv |\mathbf{u}_i - \mathbf{u}_n|.

The cross section is approximated by a fitting function. For hydrogen and Deuterium these are given by, respectively

.. math::

    \sigma_{cx, H} = 1.12 \times 10^{-18} - 7.15 \times 10^{-20} \ln(V_{cx}), \\
    \sigma_{cx, D} = 1.09 \times 10^{-18} - 7.15 \times 10^{-20} \ln(V_{cx}).


Wall recycling boundary conditions
----------------------------------

A model for wall recycling has been implemented at the boundaries where field lines terminate. These boundary conditions provide a source of neutrals from the targets that depends on the flux of outgoing ions. Consider a simulation with one configuration space dimension, parallel to the magnetic field, and three velocity space dimensions (1x3v). Since :math:`x` is parallel to the magnetic field, :math:`v_x` is the parallel velocity for neutrals. We define the neutral distribution function in the ghost cell at the lower ($x_\min$) boundary as

.. math::
    f_n(v_x,v_y,v_z,x=x_{ghost}) = C_{rec} f_{M,rec}(T= T_{n,rec}).

The Maxwellian function for recycled neutrals :math:`f_{M,rec}` is defined by a zero mean flow and a temperature that is set in the user input file to model the Franck-Condon atoms coming from the wall. The Maxwellian is scaled such that the magnitude of the flux of incoming neutrals is equal to the magnitude of the flux of outgoing ions. At this time, angular dependency is not included in the model of wall recycling.
    
Neutral species and gyrokinetic plasma species coupling
-------------------------------------------------------

Neutral species are always evolved on the Vlasov grid. For a Vlasov-Maxwell plasma species, the neutrals and ions are evolved on identical phase-space grids. Thus, the ion-neutral interaction terms in Eqs. :eq:`izIon`, :eq:`cxIon`, and :eq:`cxNeut` are straightforward. However, when the plasma species are evolved using the gyrokinetic model, the ion and neutral velocity-space grids are no longer identical, and it becomes necessary to pass information between two different phase-space grids. This is accomplished by taking fluid moments, :math:`n`, :math:`\mathbf{u}`, and :math:`v^2_{th}`, of the species distribution function and using them to project a Maxwellian distribution function on the destination phase-space grid. This is valid assuming that ion and neutral distribution functions are approximately Maxwellian.

In the Vlasov-Maxwell formulation, a Maxwellian distribution is defined

.. math::

  f_{M,vm}(\mathbf{x}, \mathbf{v}) = \frac{n}{\left(2\pi v_{th}^2\right)^{d_v/2}}
  \exp\left[-\frac{\left(\mathbf{v}-\mathbf{u}\right)^2}{2v_{th}^2}\right],

where :math:`d_v` is the velocity-space dimension. In the gyrokinetic formulation a Maxwellian distribution function is defined

.. math::

   f_{M,gk}(\mathbf{x}, v_\parallel, \mu) = \frac{n}{\left(2\pi v_{th}^2\right)^{3/2}}
   \exp\left[-\frac{\left(v_\parallel- u_\parallel \right)^2}{2v_{th}^2} - \frac{B \mu}{m v^2_{th}}\right],

where we have assumed the gyrokinetic grid is either 1X2V or 3X2V. Note that in the gyrokinetic formulation, the fluid velocity moment contains only one component, :math:`u_\parallel`, which is along the magnetic field line. However, the neutral fluid velocity contains 3 components. It is assumed that once a neutral particle is ionized, the perpendicular components are immediately "smeared out" by the gyro-motion. Thus, only the :math:`z`-component of the neutral fluid velocity moment is included in the Maxwellian projection on the gyrokinetic grid. Conversely, the ion fluid velocity moment contains only one component. Thus, the ion Maxwellian distribution function on the 3V Vlasov grid contains the fluid moment :math:`\mathbf{u}_i = (u_x = 0, u_y = 0, u_z = u_{\parallel,i})`.

The collision terms in this gyrokinetic-Vlasov coupling become

.. math::

   \frac{d}{dt}\mathcal{J}f_i(\mathbf{R}, v_\parallel, \mu, t) &= n_e  \langle \sigma_{iz} v_e \rangle \mathcal{J} f_{M,gk}(n_n, u_{z,n}, v_{th,n}^2) + \sigma_{cx} V_{cx}[ n_i \mathcal{J} f_{M,gk}(n_n, u_{z,n}, v_{th,n}^2) - n_n \mathcal{J} f_i], \\
   \frac{d}{dt}f_n(\mathbf{x}, \mathbf{v}, t) &= n_e f_n \langle \sigma_{iz} v_e \rangle - \sigma_{cx} V_{cx} [n_i f_n - n_n f_{M,vm}(n_i, u_{\parallel,i}, v_{th,i}^2)], 

where :math:`\mathcal{J}` is the Jacobian for the gyrokinetic model.
   
Neutral interactions in Gkeyll input files
------------------------------------------

Electron-impact ionization
``````````````````````````
Below is an example of adding ionization to a Vlasov-Maxwell simulation:
 
.. code-block:: lua

  --------------------------------------------------------------------------------
  -- App dependencies
  --------------------------------------------------------------------------------
  local Plasma = (require "App.PlasmaOnCartGrid").VlasovMaxwell()

  ...
  
  plasmaApp = Plasma.App {
     -----------------------------------------------------------------------------
     -- Common
     -----------------------------------------------------------------------------
     ...

     -----------------------------------------------------------------------------
     -- Species
     -----------------------------------------------------------------------------
     -- Vlasov-Maxwell electrons
     elc = Plasma.Species {
       evolve = true,
       charge = qe,
       mass = me,
       ...
       -- Ionization
       ionization = Plasma.Ionization {
         collideWith = {"neut"},        -- species to collide with
      	 electrons = "elc",             -- define name for electron species
      	 neutrals = "neut",             -- define name for neutral species
      	 elemCharge = eV,               -- define elementary charge
      	 elcMass = me,                  -- electron mass
         plasma = "H",                  -- ion species element
       },
       ...
     },
     
     -- Vlasov-Maxwell ions
     ion = Plasma.Species {
       evolve = true,
       charge = qi,
       mass = mi,
       ...
       -- Ionization
       ionization = Plasma.Ionization {
         collideWith = {"neut"},        -- species to collide with
      	 electrons = "elc",             -- define name for electron species
      	 neutrals = "neut",             -- define name for neutral species
      	 elemCharge = eV,               -- define elementary charge
      	 elcMass = me,                  -- electron mass
         plasma = "H",                  -- ion species element
       },
       ...
     },

     -- Vlasov neutrals
     neut = Plasma.Species {
       evolve = true,
       charge = 0,
       mass = mi,
       ...
       -- Ionization
       ionization = Plasma.Ionization {
         collideWith = {"elc"},         -- species to collide with
      	 electrons = "elc",             -- define name for electron species
      	 neutrals = "neut",             -- define name for neutral species
      	 elemCharge = eV,               -- define elementary charge
      	 elcMass = me,                  -- electron mass
         plasma = "H",                  -- ion species element
       },
       ...
     },
  },

In order to add ionization to a gyrokinetic simulation and include neutral particles which are evolved using the Vlasov solver, define the ``Gyrokinetic`` App in the dependencies as :code:`local Plasma = (require "App.PlasmaOnCartGrid").Gyrokinetic()`. Then replace the neutral Lua table above with

.. code-block:: lua

     neut = Plasma.Vlasov {
       evolve = true,
       charge = 0,
       mass = mi,
       init = Plasma.VmMaxwellianProjection { ... }   -- initial conditions (and source) defined using Vlasov app
       ...
       -- Ionization
       ionization = Plasma.Ionization {
         collideWith = {"elc"},         -- species to collide with
      	 electrons = "elc",             -- define name for electron species
      	 neutrals = "neut",             -- define name for neutral species
      	 elemCharge = eV,               -- define elementary charge
      	 elcMass = me,                  -- electron mass
         plasma = "H",                  -- ion species element
       },
       ...
       bcx = {Vlasov.Species.bcReflect, Vlasov.Species.bcReflect}  -- boundary conditions defined using Vlasov app
     },  

Note that :code:`Plasma.Species` became :code:`Plasma.Vlasov` and :code:`Plasma.MaxwellianProjection` became :code:`Plasma.VmMaxwellianProjection` but the ionization Lua table remains :code:`ionization = Plasma.Ionization`. The latter remains as is since the ionization calculation is carried out from within the ``Gyrokinetic`` App but other parameters such as initial conditions, source, and boundary conditions are defined using the ``Vlasov`` App, which gets called from within the ``Gyrokinetic`` App. 

Charge exchange
```````````````
Charge exchange can be added much in the same way as ionization was included above, though the former only affects the ion and neutral species. For the case of gyrokinetic plasma species with Vlasov neutrals, include the following in the **Species** section of the input file.

.. code-block:: lua

   -- Gyrokinetic ions
   ion = Plasma.Species {
      evolve = true,
      charge = qi,
      mass = mi,
      ...
      -- Charge exchange 
      chargeExchange = Plasma.ChargeExchange {
         collideWith = {"neut"},              -- species to collide with
	 ions = "ion",                        -- define ion species name
      	 neutrals = "neut",                   -- define neutral species name
	 ionMass = mi,                        -- ion mass
      	 neutMass = mi,                       -- neutral mass
      	 plasma = "H",                        -- ion species element       
   	 charge = qi,                         -- species charge
      },
      ...
   },
   
   -- Vlasov neutrals
   neut = Plasma.Vlasov {
      evolve = true,
      charge = 0,
      mass = mi,
      ...
      -- Charge exchange
      chargeExchange = Plasma.ChargeExchange {
      	 collideWith = {"ion"},               -- species to collide with
      	 ions = "ion",                        -- define ion species name
      	 neutrals = "neut",                   -- define neutral species name
      	 ionMass = mi,                        -- ion mass
      	 neutMass = mi,                       -- neutral mass
      	 plasma = "H",                        -- ion species element
   	 charge = 0,                          -- species charge
      },
      ...
   },

Wall recycling
``````````````

Wall recycling boundary conditions can be included for the neutral Vlasov species by including the following in the neutral table for a simulation in one configuration-space dimension. Since particle fluxes necessary for wall recycling are stored in boundary flux diagnostics, :code:`diagnosticBoundaryFluxMoments` must be included in all species table as shown below. 

.. code-block:: lua

   ...

   -- Gyrokinetic electrons
   elc = Plasma.Species {
      evolve = true,
      ...
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkEnergy"},
   }
   
   -- Gyrokinetic ions
   ion = Plasma.Species {
      evolve = true,
      ...
      diagnosticBoundaryFluxMoments = {"GkM0", "GkUpar", "GkEnergy"},
   }
		
   -- Vlasov neutrals
   neut = Plasma.Vlasov {
      evolve = true,
      charge = 0,
      mass = mi,
      ...
      bcx = {Plasma.Vlasov.bcRecycle, Plasma.Vlasov.bcRecycle},

      -- Recycle elements
      recycleTemp = 10*eV,
      recycleFrac = 0.5,
      recycleIon = "ion",
      recycleTime = 100e-6,
      ...

      diagnosticBoundaryFluxMoments = {"M0", "u", "M2Flow", "M2Thermal"},
   },

Additional flags are required including :code:`recycleTemp` which defines :math:`T_{n,rec}`, :code:`recycleFrac` which defines the wall recycling fraction :math:`\alpha_{rec}`, and :code:`recycleIon` which defines the ion species name in the input file. An opptional flag :code:`recycleTime` provides a time dependency for the wall recycling fraction, which gradually ramps up to the desired value :math:`\alpha_{rec,0}` according to the equation

.. math::
   \frac{1}{2}(1 + \tanh(t/\tau_{rec}-1))\alpha_{rec},

where :math:`\tau_{rec}` is given by :code:`recycleTime`.
   
Examples
--------

Two examples of simulations with neutral interactions are presented here. The first uses the Vlasov-Maxwell solver for the plasma species and includes electron-impact ionization. The second uses the gyrokinetic solver with both electron-impact ionization and charge exchange.

1X1V Vlasov simulation
``````````````````````

A simple Vlasov-Maxwell test case in 1X1V with spatially constant fluid moments for all species and periodic boundary conditions can be set up to test conservation properties of this model. Simply run the included input file :doc:`vlasovIz.lua <inputFiles/vlasovIz>` using standard procedures detailed :ref:`here <Running simulations>`. The simulation completes in about 12 seconds on a 2019 MacBook Pro. Then use the Postgkyl command-line tool to check particle and energy conservation. To plot the sum of the integrated particle densities of ions and electrons, use the following command.

.. code-block:: bash

   pgkyl vlasovIz_ion_intM0.bp vlasovIz_neut_intM0.bp ev 'f[0] f[1] +' plot -x 'time' -y 'particles'

This produces the plot shown below, illustrating conservation of particle number. 

.. figure:: figures/totalIntM0.png
  :scale: 40 %
  :align: center

  Sum of ion and neutral integrated particle densities vs. time.

Next plot the sum of integrated thermal energy of ions and neutrals with the following command.

.. code-block:: bash

   pgkyl vlasovIz_ion_intM2Thermal.bp vlasovIz_neut_intM2Thermal.bp ev 'f[0] f[1] +' plot -x 'time' -y 'thermal energy'

This produces the plot shown below which demonstrates the conservation of thermal energy.
   
.. figure:: figures/totalIntM2.png
  :scale: 40 %
  :align: center

  Sum of ion and neutral integrated thermal energy vs. time. 


1X2V gyrokinetic + 1X3V Vlasov simulation
`````````````````````````````````````````
This example is based on a simplified model of a scrape-off layer plasma, the open-field line region in a fusion device. Parameters were chosen based on previous Gkeyll simulations described in [Shi2015]_. Gyrokinetic ion and electron species are coupled to Vlasov neutrals via electron-impact ionization and charge exchange interactions. Sheath model boundary conditions are used for the plasma species and reflecting boundary conditions are used for neutrals. The gyrokinetic species are evolved using two velocity-space dimensions, :math:`(v_\parallel, \mu)`. The Vlasov species are run using three velocity-space dimensions, :math:`(v_x, v_y, v_z)`, where the subscripts :math:`(x,y,z)` correspond to the non-orthogonal field-line following coordinate system used in the gyrokinetic solver. Thus, :math:`v_\parallel` in the gyrokinetic system is identical to the :math:`v_z` Vlasov coordinate.

The simulation can be run with the input file :doc:`1x2vSOL.lua <inputFiles/1x2vSOL>`, which is currently set to run in parallel on 4 processors (``decompCuts = {4}``). On a 2019 Macbook Pro, this simulation takes approximately 15 minutes to complete. The output can be analyzed with the Postgkyl tools. For example, the ``anim`` command can be used to observe changes in the electron density profile, as shown below.

.. code-block:: bash

    pgkyl "1x2vSOL_elc_GkM0_[0-9]*.bp" interp anim -x '$x$' -y '$n_e$'

This command produces the following animation of the evolution of the electron density profile in time.

.. raw:: html

  <center>
  <video controls height="300" width="450">
    <source src="../../../_static/1x2vSOLneut.mp4" type="video/mp4">
  </video>
  </center>
 
References
----------

.. [Wersal2015] Wersal, C., & Ricci, P. (2015). A first-principles self-consistent model of plasma turbulence and kinetic neutral dynamics in the tokamak scrape-off layer. Nuclear Fusion, 55(12), 123014.
		
.. [Voronov1997] Voronov, G. S. (1997). A practical fit formula for ionization rate coefficients of atoms and ions by electron impact: Z = 1-28. Atomic Data and Nuclear Data Tables, 65(1), 1–35.

.. [Cagas2017] Cagas, P., Hakim, A., Juno, J., & Srinivasan, B. (2017). Continuum kinetic and multi-fluid simulations of classical sheaths. Phys. Plasmas, 24(2), 22118.
		 
.. [Meier2012] Meier, E. T., & Shumlak, U. (2012). A general nonlinear fluid model for reacting plasma-neutral mixtures. Physics of Plasmas, 19(7).

.. [Shi2015] Shi, E. L., Hakim, A. H., & Hammett, G. W. (2015). A gyrokinetic one-dimensional scrape-off layer model of an edge-localized mode heat pulse. Physics of Plasmas, 22(2).


		
