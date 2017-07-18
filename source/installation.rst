.. _chapter_installation:

************
Installation
************

gkyl can be installed through `Conda
<https://anaconda.org/gkyl/gkyl>`_. Cloning the repository is
currently available only to the developers.


Conda installation
==================

.. image:: https://anaconda.org/gkyl/gkyl/badges/version.svg
   :target: https://anaconda.org/gkyl/gkyl
.. image:: https://anaconda.org/gkyl/gkyl/badges/downloads.svg
   :target: https://anaconda.org/gkyl/gkyl
.. image:: https://anaconda.org/gkyl/gkyl/badges/installer/conda.svg
   :target: https://conda.anaconda.org/gkyl 

Installing the conda package manager
------------------------------------

The Conda package manager is a part of both the full Continuum
Analytics Python distribution `Anaconda
<https://www.continuum.io/downloads>`_ or its light-weight version
`Miniconda <https://conda.io/miniconda.html>`_. More information can
be found in the official `conda documentation
<https://conda.io/docs/download.html>`_.

Installing gkyl
-------------------

With Conda installed and on ``PATH``, gkyl can be simply installed
with just one command:

.. code-block:: bash

   conda install -c gkyl gkyl

The flag ``-c`` is specifying the ``gkyl`` channel that contains both
Gkyl and postgkyl and also the custom builds of dependencies, which
are not available through main Conda channel (or are not available for
both Linux and OSx).

Alternatively, ``gkyl`` channel can be permanently added with

.. code-block:: bash

   conda config --add channels gkyl

and postgkyl can then be installed with just

.. code-block:: bash
		
   conda install gkyl

