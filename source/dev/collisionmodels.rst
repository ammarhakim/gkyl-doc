.. _dev_collisionmodels:

Collision models in Gkeyll
++++++++++++++++++++++++++

In Gkeyll we currently have two different collision operators, one
is the Bhatnagar–Gross–Krook (BGK) collision operator and the other
is the Dougherty operator. We referred to the latter as the LBO for
the legacy of Lenard-Bernstein.


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

  \mathbf{u}_{sr} = \mathbf{u}_s - \frac{\alpha_{E}}{2}
  \frac{m_s+m_r}{m_sM_{0s}\nu_{sr}}\left(\mathbf{u}_s-\mathbf{u}_r\right) \\
  v_{tsr}^2 = v_{ts}^2 - \frac{1}{d_v}\frac{\alpha_E}{m_sM_{0s}\nu_{sr}}
  \left[d_v\left(m_sv_{ts}^2-m_rv_{tr}^2\right)-m_r\left(\mathbf{u}_s-\mathbf{u}_r\right)^2
  +4\frac{\alpha_E}{m_sM_{0s}\nu_{sr}}\left(m_s+m_r\right)^2\left(\mathbf{u}_s-\mathbf{u}_r\right)^2\right]

but contrary to Greene's definition of :math:`\alpha_E`, we currently
use in Gkeyll the following expression



Dougherty collisions
--------------------


References
---------

.. [Gross1956] Gross, E. P. & Krook, M. (1956) Model for collision precesses
   in gases: small-amplitude oscillations of charged two-component systems.
   *Physical Review*, 102(3), 593–604.

.. [Greene1973] Greene, J. M. (1973). Improved Bhatnagar-Gross-Krook model
   of electron-ion collisions. Physics of Fluids, 16(11), 2022–2023.
