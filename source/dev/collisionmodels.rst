.. _dev_collisionmodels:

Collision models in Gkeyll
++++++++++++++++++++++++++

In Gkeyll we currently have two different collision operators, one
is the Bhatnagar–Gross–Krook (BGK) collision operator and the other
is the Dougherty operator. We referred to the latter as the LBO for
the legacy of Lenard-Bernstein.

.. contents::

BGK collisions
--------------

The BGK operator [Gross1956]_ is for the effect of collisions on
species :math:`f_s` is

.. math::

  \left(\frac{\partial f_s}{\partial t}\right)_c = \sum_r\nu_{sr}
  \left(f_s - f_{Msr}\right)

where the sum is over all the species. The distribution functon
:math:`f_{Msr}` is the Maxwellian

.. math::

  f_{Msr} = \frac{n_s}{\left(2\pi v_{tsr}^2\right)^{d_v/2}}
  \exp\left[-\frac{\left(\mathbf{v}-\mathbf{u}_{sr}\right)^2}{2v_{tsr}^2}\right] 

with the primitive moments :math:`\mathbf{u}_{sr}` and :math:`v_{tsr}^2`
properly defined to preserve some properties (such as conservation),
and :math:`d_v` is the number of velocity-space dimensions.
For self-species collisions :math:`\mathbf{u}_{sr}=\mathbf{u}_s` and
:math:`v_{tsr}^2=v_{ts}^2`. For multi-species collisions we follow
an approach similar to [Greene1973]_ and define the cross-species
primitive moments as

.. math::

  \mathbf{u}_{sr} &= \mathbf{u}_s - \frac{\alpha_{E}}{2}
  \frac{m_s+m_r}{m_sn_{s}\nu_{sr}}\left(\mathbf{u}_s-\mathbf{u}_r\right) \\
  v_{tsr}^2 &= v_{ts}^2 - \frac{1}{d_v}\frac{\alpha_E}{m_sn_{s}\nu_{sr}}
  \left[d_v\left(m_sv_{ts}^2-m_rv_{tr}^2\right)-m_r\left(\mathbf{u}_s-\mathbf{u}_r\right)^2
  +4\frac{\alpha_E}{m_sn_{s}\nu_{sr}}\left(m_s+m_r\right)^2\left(\mathbf{u}_s-\mathbf{u}_r\right)^2\right]

but contrary to Greene's definition of :math:`\alpha_E`, we currently
use in Gkeyll the following expression

.. math::

  \alpha_E = m_sn_{s}\nu_{sr}\delta_s\frac{1+\beta}{m_s+m_r}.

Little guidance is provided by Greene as to how to choose :math:`\beta`,
although it seems clear that :math:`-1<\beta`. In Gkeyll the default
value is :math:`\beta=0`, but the user can specify it in the input file
(explained below). We have introduced the additional quantity :math:`\delta_s`
(which Greene indirectly assumed to equal 1) defined as

.. math::

  \delta_s = \frac{2m_sn_s\nu_{sr}}{m_sn_s\nu_{sr}+m_rn_r\nu_{rs}}

Dougherty collisions
--------------------

The Doughery (LBO) model for collisions [Dougherty1964]_ in Gkeyll is given by

.. math::

  \left(\frac{\partial f_s}{\partial t}\right)_c = \sum_r\nu_{sr}
  \frac{\partial}{\partial\mathbf{v}}\cdot\left[\left(\mathbf{v}-\mathbf{u}_{sr}\right)f_s
  +v_{tsr}^2\frac{\partial f_s}{\partial\mathbf{v}}\right].
 
In this case we compute the cross-primitive moments by a process analogous
to Greene's with the BGK operator, yielding the following formulas for the
cross flow velocity and thermal speed:

.. math::

  \mathbf{u}_{sr} &= \mathbf{u}_s + \frac{\alpha_{E}}{2}
  \frac{m_s+m_r}{m_sn_{s}\nu_{sr}}\left(\mathbf{u}_r-\mathbf{u}_s\right) \\
  v_{tsr}^2 &= v_{ts}^2+\frac{\alpha_{E}}{2}\frac{m_s+m_r}{m_sn_{s}\nu_{sr}}
  \frac{1}{1+\frac{m_s}{m_r}}\left[v_{tr}^2-\frac{m_s}{m_r}v_{ts}^2
  +\frac{1}{d_v}\left(\mathbf{u}_s-\mathbf{u}_r\right)^2\right]

with :math:`\alpha_E` defined in the BGK section above.

Collisions in Gkeyll input files
--------------------------------

Users can specify collisions in input files with either constant collisionality
or with spatially varying, time-evolving collisionality.

Constant collisionality
```````````````````````

An example of adding
LBO collisions (for BGK collisions simply replace ``LBOcollisions`` with
``BGKCollisions``) to a species named 'elc' is

.. code-block:: lua

  elc = Plasma.Species {
     charge = q_e, mass = m_e,
     -- Velocity space grid.
     lower = {-6.0*vt_e},
     upper = { 6.0*vt_e},
     cells = {32},
     -- Initial conditions.
     init = Plasma.MaxwellianProjection{
        density = function (t, zn)
           local x, vpar = zn[1], zn[2]
           return n_e
        end,
        driftSpeed = function (t, zn)
           local x, vpar = zn[1], zn[2]
           return {u_e}
        end,
        temperature = function (t, zn)
           local x, vpar = zn[1], zn[2]
           return m_e*(vt_e^2)
        end,
     },
     evolve = true,
     -- Collisions.
     coll = Plasma.LBOCollisions {
        collideWith = { "elc" },
        frequencies = { nu_ee },
     },
  },

If there were another species, say one named 'ion', this 'elc' species could
be made to collide with 'ion' by adding 'ion' to the ``collideWidth``
table:

.. code-block:: lua

  coll = Plasma.LBOCollisions {
     collideWith = { "elc", "ion" },
     frequencies = { nu_ee, nu_ei },
  },

The constant collision frequencies ``nu_ee`` and ``nu_ei`` need to be previously
computed/specified in the input file.

It is also possible to specify both LBO and BGK collisions between different
binary pairs in a single input file. For example, if there are three species
'elc', 'ion' and 'neut', the 'elc' species could be made collide with both
'ion' and 'neut' as follows:

.. code-block:: lua

  cColl = Plasma.LBOCollisions {
     collideWith = { "elc", "ion" },
     frequencies = { nu_ee, nu_ei },
  },
  nColl = Plasma.BGKCollisions {
     collideWith = { "neut" },
     frequencies = { nu_en },
  },

If no collisionality is specified in the input file, it is assumed that the user
desires Gkeyll to build a spatially-varying collisionality from scratch using
a Spitzer-like formula for :math:`\nu_{sr}` (explained below).

Spatially varying collisionality
````````````````````````````````

The simplest way to run with spatially varying collisionality is to not specify
the table ``frequencies``. In this case the code computes :math:`\nu_{sr}`
according to

.. math::

  \nu_{sr} = \frac{n_r}{m_s}\left(\frac{1}{m_s}+\frac{1}{m_r}\right)
  \frac{q_s^2q_r^2\log\Lambda_{sr}}{3(2\pi)^{3/2}\epsilon_0^2}
  \frac{1}{\left(v_{ts}^2+v_{tr}^2\right)^{3/2}}

where the Coulomb logarithm is defined as

.. math::

  \lambda_{sr} = \ln\left\lbrace\left(\sum_\alpha\frac{\omega_{p\alpha}^2+\omega_{c\alpha}^2}
  {\frac{T_\alpha}{m_\alpha}+3\frac{T_s}{m_s}}\right)^{-1/2}
  \left[\max\left(\frac{|q_sq_r|}{4\pi\epsilon_0m_{sr}u^2},\frac{\hbar}{2e^{1/2}m_{sr}u}\right)\right]^{-1}\right\rbrace

and the :math:`alpha`-sum is over all the species. The relative velocity here
is computed as :math:`u=3v_{tr}^2+3v_{ts}^2`. Simpler formulas for the Coulomb
logarithm can be easily generated by developers if necessary.

The formulas above assume all the plasma quantities and universal constants are in
SI units. The user can provide a different value for these variables by passing them
to the collisions table in the input files, as shown here:

.. code-block:: lua

  coll = Plasma.LBOCollisions {
     collideWith = { "elc", "ion" },
     epsilon0    = 1.0,    -- Vacuum permitivity.
     elemCharge  = 1.0,    -- Elementary charge value.
     hBar        = 1.0,    -- Planck's constant h/2pi.
  },

Another way to use a specially varying collisionality is to passed a reference
collisionality normalized to some values of density and temperature. For example
if the input file specifies the normalized collisionality :math:`\nu_NT_{e0}^{3/2}/n_{e0}` through
``normNu``

.. code-block:: lua

  coll = Plasma.LBOCollisions {
     collideWith = { "elc" },
     normNu      = { nu_ee*T_e0^(3/2)/n_e0 }
  },

then in each time step the collisions will be applied with the following collisionality

.. math::

  \nu_ee(x) = \nu_N \frac{n_e(x,t)}{T_e(x,t)^{3/2}}.

Currently these options lead to a spatially varying, cell-wise constant collisionality.
We will be adding support for variation of the collisionality within a cell in the future.



References
----------

.. [Gross1956] Gross, E. P. & Krook, M. (1956) Model for collision precesses
   in gases: small-amplitude oscillations of charged two-component systems.
   *Physical Review*, 102(3), 593–604.

.. [Greene1973] Greene, J. M. (1973). Improved Bhatnagar-Gross-Krook model
   of electron-ion collisions. *Physics of Fluids*, 16(11), 2022–2023.

.. [Dougherty1964] Dougherty, J. P. (1964). Model Fokker-Planck Equation for
   a Plasma and Its Solution. *Physics of Fluids*, 7(11), 1788–1799.
