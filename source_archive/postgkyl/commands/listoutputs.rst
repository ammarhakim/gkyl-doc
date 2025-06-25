.. _pg_cmd_listoutputs:

listoutputs
===========

You can list the unique filename stems of all the files written
by a simulation. This is useful if you are unsure about which
outputs were produced, or want to browse all possible files/diagnostics.
This command doesn't take any arguments, and can be used with
the appreviation ``list``

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../../_static/postgkyl/commands/listoutputs.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl list --help
    Usage: pgkyl list [OPTIONS]
    
      List Gkeyll filename stems in the current directory
    
    Options:
      -e, --extension TEXT  Output file extension  [default: bp]
      -h, --help            Show this message and exit.

.. raw:: html

   </details>
   <br>

In the directory where the simulation was run type

.. code-block:: bash

  pgkyl list

and you will obtain a list of the unique filename stems in
that directory. For example, if I run the gk-alfven-p1.lua
simulation I would get

.. code-block:: bash

  gk-alfven-p1_allGeo
  gk-alfven-p1_apar
  gk-alfven-p1_dApardt
  gk-alfven-p1_electron
  gk-alfven-p1_electron_GkM0
  gk-alfven-p1_electron_GkM1
  gk-alfven-p1_electron_f0
  gk-alfven-p1_electron_f1
  gk-alfven-p1_ion
  gk-alfven-p1_ion_GkM0
  gk-alfven-p1_ion_GkM1
  gk-alfven-p1_laplacianWeight
  gk-alfven-p1_modifierWeight
  gk-alfven-p1_phi

Note that if multiple simulations with different input files
have been run in the same directory it will list the unique
filename stems for all such simulations.
