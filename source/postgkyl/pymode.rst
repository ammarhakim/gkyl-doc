Postgkyl as Python Package
++++++++++++++++++++++++++

Postgkyl can be imported in Python using::

  import postgkyl 

It has three major submodules

.. toctree::
   :maxdepth: 1

   py-data
   py-diagnostics
   py-output

**Data** provides the baseline class ``GData`` for data loading and
manipulation, but it also includes tools for handling of discontinuous
Galerkin data and for data slicing and subselection.  **Diagnostics**
submodule is a library of useful diagnostics, quick-looks, and other
postprocessing tools.  Finally, **Output** provides a streamlined
plotting features and some additional functionality for writing data
into ADIOS files.
