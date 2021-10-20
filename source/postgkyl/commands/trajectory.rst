.. _pg_cmd_trajectory:

trajectory
==========

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/trajectory.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl trajectory -h
    Usage: pgkyl traj [OPTIONS]
    
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
      -u, --use TEXT              Specify a 'tag' to apply to (default all tags).
      -h, --help                  Show this message and exit.

.. raw:: html

  </details>
  <br>

