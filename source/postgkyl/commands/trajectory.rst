.. _pg_cmd_trajectory:

trajectory
----------

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash
                
   $ pgkyl trajectory -h
   Usage: pgkyl trajectory [OPTIONS]

     Animate a particle trajectory

   Options:
     --fix-aspect                Enforce the same scaling on both axes.
     --show / --no-show          Turn showing of the plot ON and OFF (default:
                                 ON).
     -i, --interval INTEGER      Specify the animation interval.
     --save                      Save figure as PNG.
     --velocity / --no-velocity  Plot velocity vectors.
     --saveas TEXT               Name to save the plot as.
     -e, --elevation FLOAT       Set elevation
     -a, --azimuth FLOAT         Set azimuth
     -n, --numframes INTEGER     Set number of frames for the animation
     --xmin FLOAT                Minimum value of the x-coordinate
     --xmax FLOAT                Maximum value of the x-coordinate
     --ymin FLOAT                Minimum value of the y-coordinate
     --ymax FLOAT                Maximum value of the y-coordinate
     --zmin FLOAT                Minimum value of the z-coordinate
     --zmax FLOAT                Maximum value of the z-coordinate
     -h, --help                  Show this message and exit.
