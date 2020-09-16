.. _pg_cmd_animate:

animate
-------

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash
                
  $ pgkyl animate -h
  Usage: pgkyl animate [OPTIONS]

    Animate the actively loaded dataset and show resulting plots in a loop.
    Typically, the datasets are loaded using wildcard/regex feature of the -f
    option to the main pgkyl executable. To save the animation ffmpeg needs to
    be installed.

  Options:
    -s, --squeeze           Squeeze the components into one panel.
    -a, --arg TEXT          Additional plotting arguments like '*--'.
    -c, --contour           Switch to contour mode.
    -q, --quiver            Switch to quiver mode.
    -l, --streamline        Switch to streamline mode.
    -d, --diverging         Switch to diverging colormesh mode.
    --style TEXT            Specify Matplotlib style file (default: Postgkyl).
    --fix-aspect            Enforce the same scaling on both axes.
    --logx                  Set x-axis to log scale.
    --logy                  Set y-axis to log scale.
    --show / --no-show      Turn showing of the plot ON and OFF (default: ON).
    -x, --xlabel TEXT       Specify a x-axis label.
    -y, --ylabel TEXT       Specify a y-axis label.
    -t, --title TEXT        Specify a title label.
    -i, --interval INTEGER  Specify the animation interval.
    -f, --float             Choose min/max levels based on current frame (i.e.
                            each frame uses a different color range).
    --save                  Save figure as PNG.
    --saveas TEXT           Name to save the plot as.
    -e, --edgecolors TEXT   Set color for cell edges (default: None)
    -h, --help              Show this message and exit.
