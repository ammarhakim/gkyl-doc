The  Gkeyll 2.0 Code: Documentation Home
++++++++++++++++++++++++++++++++++++++++

This is the documentation home for Version 2.0 of the Gkeyll code. The
name is pronounced as in the book `"The Strange Case of Dr. Jekyll and
Mr. Hyde" <https://www.gutenberg.org/files/43/43-h/43-h.htm>`_. Gkeyll
is written in a combination of LuaJIT and C++. Most of the top-level
code is written in LuaJIT, while time-critical parts are written in
C++. Gkeyll is developed at `Princeton Plasma Physics Laboratory
(PPPL) <http://www.pppl.gov>`_ in collaboration with Princeton
University, University of Maryland, Virginia Tech, University of New
Hampshire, University of Texas at Austin, and Darthmouth College. For
a full list of contributors see :doc:`Authors <gkyl/authors>` list.

Gkeyll 2.0 has been designed from ground up and has significant
flexibility and algorithmic innovations compared to the previous
version of the code. Gkeyll's innovative design completely blurs the
distinction between user input and the internal software, allowing for
a very powerful means of composing complex simulations. All of this is
achieved in a very compact code base with minimal external
dependencies, yet providing efficient solvers for Gyrokinetics,
Vlasov-Maxwell as well as multi-fluid equations.

Gkeyll Documentation
--------------------

.. toctree::
  :maxdepth: 3

  gkyl/about
  license
  gkyl/conda-install
  gkyl/install
  gkyl/applications

Gkeyll Publications & Presentations
-----------------------------------

.. toctree::
  :maxdepth: 1

  gkyl/pubs	     
  gkyl/presentations

Postgkyl Documentation
----------------------

Postgkyl is a Python post-processing tool for Gkeyll 1.0 and Gkeyll
data.  It allows the user to read data from HDF5 and ADIOS BP files,
manipulate the data in many wonderful ways, and then save or plot the
results.  Postgkyl can be run in two modes: command line mode and
Python package mode.


.. toctree::
  :maxdepth: 2

  postgkyl/install
  postgkyl/usage

Dev Notes
---------

This is a collection of notes, mainly meant for developers and those
wishing to understand some of the internal details of Gkeyll.

.. toctree::
  :maxdepth: 1

  dev/onmaxima
  dev/modalbasis
  dev/ssp-rk
  dev/vlasov-normalizations
  dev/vlasov-denorm  
  dev/maxwell-eigensystem
  dev/euler-eigensystem
  dev/tenmom-eigensystem
  dev/twofluid-sources
  dev/collisionmodels

