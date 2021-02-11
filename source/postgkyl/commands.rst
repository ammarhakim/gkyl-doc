.. _pg_commands:

Function/Command reference
++++++++++++++++++++++++++

This is the reference for Postgkyl functions and commands. In the most
cases, the commands are simple `click <http://click.pocoo.org>`_
wrappers of the Python function. However, where a command addresses
something that is easilly done in a script, there is no Python
function equivalent.

Examples are provided simultaneously for the analogous functions and
commands using output files of an electrostatic two-stream instability
simulation [:doc:`two-stream.lua<input/two-stream>`].

.. contents::

Output
------
.. toctree::
   :maxdepth: 1

   .. commands/animate
   commands/extractinput
   commands/info
   commands/listoutputs
   commands/plot
   .. commands/pr
   .. commands/trajectory
   .. commands/write

Data selection
--------------
.. toctree::
   :maxdepth: 1

   .. commands/activate
   .. commands/collect
   .. commands/deactivate
   .. commands/mask
   .. commands/select
   .. commands/val2coord

Data manipulation
-----------------
.. toctree::
   :maxdepth: 1

   .. commands/agyro
   commands/differentiate
   .. commands/euler
   commands/ev
   .. commands/fft
   commands/integrate
   .. commands/interpolate
   .. commands/norm
   .. commands/recovery
   .. commands/tenmoment

Diagnostics
-----------
.. toctree::
   :maxdepth: 1

   commands/growth

Command control
---------------
.. toctree::
   :maxdepth: 1

   .. commands/pop
   .. commands/runchain
