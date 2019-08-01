.. _dev_collisionmodels:

Collision models in Gkeyll
++++++++++++++++++++++++++

In Gkeyll we currently have two different collision operators, one
is the Bhatnagar–Gross–Krook (BGK) collision operator and the other
is the Dougherty operator. We referred to the latter as the LBO for
the legacy of Lenard-Bernstein.

The BGK operator [Gross1956]_ is

.. math::

  \left(\frac{\partial f}{\partial t}\right)_c = \nu\left(f - f_M\right)


References
---------

.. [Gross1956] E. P. Gross and M. Krook. Model for collision precesses
   in gases: small-amplitude oscillations of charged two-component systems.
   *Physical Review*, 102(3), 593–604, 1956.
