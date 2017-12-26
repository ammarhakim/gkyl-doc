The  Gkyl Code: Documentation Home
++++++++++++++++++++++++++++++++++

This is the documentation home for the Gkyl code. The name is
pronounced as in the book "The Strange Case of Dr. Jekyll and
Mr. Hyde". Gkyl is written in a combination of LuaJIT and C++. Most of
the top-level code is written in LuaJIT, while time-critical parts are
written in C++. Gkyl is developed at `Princeton Plasma Physics
Laboratory (PPPL) <http://www.pppl.gov>`_. For a full list of
contributors see :doc:`Authors <authors>` list.

Gkyl Documentation
------------------

.. toctree::
  :maxdepth: 2

  about
  license
  install

Postgkyl Documentation
----------------------

Postgkyl is a command line tool for post-processing Gkeyll 1.0 and
Gkyl data. Postgkyl allows the user to read data from HDF5 and ADIOS
BP files, manipulate the data in many wonderful ways and then save or
plot the results.


.. toctree::
  :maxdepth: 2

  install-pgkyl
  pgkyl-docs  
