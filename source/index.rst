The  Gkeyll 2.0 Code: Documentation Home
++++++++++++++++++++++++++++++++++++++++

.. epigraph::

   "Magic Chicken Software Framework"
   -- Artificial 'Intelligence' view on Gkeyll

.. epigraph::

   "Don't Panic"
   -- The Hitchhiker's Guide to the Galaxy

Gkeyll v2.0 (pronounced as in the book `"The Strange Case of
Dr. Jekyll and Mr. Hyde"
<https://www.gutenberg.org/files/43/43-h/43-h.htm>`_) is a
computational plasma physics code mostly written in C and `LuaJIT
<http://luajit.org>`_. Gkeyll contains solvers for gyrokinetic
equations, Vlasov-Maxwell equations, and multi-fluid equations.

The Gkeyll package contains two major parts: the :ref:`gkyl <gkyl_main>`
simulation framework and the the :ref:`postgkyl <pg_main>` post-processing
package. Here you will find documentation for the full Gkeyll package.

For license see :doc:`License <aboutAndLicense>`.

.. image:: Shi2019image.png
    :class: align-right
    :scale: 80 %

.. toctree::
   :maxdepth: 2

   install
   quickstart/main
   gkyl/main
   postgkyl/main
   gkyl/pubs	     
   gkyl/presentations
   dev/main

Authors
+++++++

Gkeyll is developed at multiple institutions, with the present
leadership residing at Princeton University's Department of
Astrophysical Sciences and the Princeton Plasma Physics Laboratory
(PPPL), a Department of Energy (DOE) national lab, managed by
Princeton University. Other major partners are Virginia Tech, MIT,
Rensselaer Polytechnic Institute (RPI), University of Maryland,
Indiana University, and Helmholtz-Zentrum Dresden-Rossendorf.

As of 2022, the active funding for the project comes from:

- National Science Foundation's `CSSI program
  <https://www.nsf.gov/awardsearch/showAward?AWD_ID=2209471&HistoricalAwards=false>`_
- DOE's SciDAC program
- ARPA-E BETHE Theory and Simulation Grant to Virginia Tech and PPPL
- Other NSF individual-PI awards to Princeton University
- PPPL LDRD program

Past funding has come from the Airforce Office of Scientific Research
and NASA.

The CEO and Algorithm Alchemist of the project is `Ammar Hakim
<https://ammar-hakim.org/>`_.

The lead physicists for the project are `Greg Hammett
<https://w3.pppl.gov/~hammett/>`_, `Amitava Bhattacharjee
<https://theory.pppl.gov/people/profile.php?pid=1&n=Amitava-Bhattacharjee>`_,
and `Bhuvana Srinivasan
<https://www.aoe.vt.edu/people/faculty/srinivasan/personal-page.html>`_.

The `major contributors
<https://github.com/ammarhakim/gkyl/graphs/contributors>`_ (`see also
<https://github.com/ammarhakim/gkylzero/graphs/contributors>`_) to the
code are: James (Jimmy) Juno, Noah Mandell, Manaure (Mana)
Francisquez, Petr Cagas, Liang Wang, Tess Bernard, Jason TenBarge, and
Kolter Bradshaw. For a full list of contributors see our Github pages.
