The  Gkyl Code: Documentation Home
++++++++++++++++++++++++++++++++++

This is the documentation home for the Gkyl code. The name is
pronounced as in the book `"The Strange Case of Dr. Jekyll and
Mr. Hyde" <https://www.gutenberg.org/files/43/43-h/43-h.htm>`_. Gkyl
is written in a combination of LuaJIT and C++. Most of the top-level
code is written in LuaJIT, while time-critical parts are written in
C++. Gkyl is developed at `Princeton Plasma Physics Laboratory (PPPL)
<http://www.pppl.gov>`_. For a full list of contributors see
:doc:`Authors <gkyl/authors>` list.

Gkyl Documentation
------------------

.. toctree::
  :maxdepth: 2

  gkyl/about
  license
  gkyl/install
  gkyl/applications

..
   And now for something completely different:

   .. image:: postgkyl/anfscd.jpg
      :width: 30%
      :align: center

Postgkyl Documentation
----------------------

Postgkyl is a Python post-processing tool for Gkeyll 1.0 and Gkyl
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
wishing to understand some of the internal details of Gkyl.

.. toctree::
  :maxdepth: 1

  dev/onmaxima
  dev/modalbasis
  dev/ssp-rk
  dev/vlasov-normalizations
  dev/maxwell-eigensystem
  dev/euler-eigensystem
  dev/tenmom-eigensystem
  dev/twofluid-sources

