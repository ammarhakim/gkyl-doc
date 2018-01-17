Plot
++++

The plot command makes 1D or 2D plots. The dimension of the plot is
selected automatically, however, the user can control several aspects
of the actual plot itself.

By default, the plot command plots *all the datasets on the stack*,
and for each dataset plots all components individually. This is
usually not what one wants. Use the *comp* or other commands to select
the data you wish to plot before passing it to the plot command.

The plot command takes the following options:

.. list-table::
   :widths: 30, 60, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - --show/--no-show
     - Show/don't show the plot window
     - --show
   * - --style
     - Style file for plots
     - postgkyl standard style
   * - --fixed-axis
     - If set, aspect-ratio is 1:1
     - 
   * - --free-axis
     - If set, aspect-ratio is automatically choosen
     - Default
   * - -s,--save
     - Save figure as PNG file
     -
   * - -q,--quiver
     - Draw quiver plot
     -
   * - -l,--streamline
     - Draw stream-lines
     -
   * - -c,--contour
     - Draw contours instead of color plot
     -
   * - --logx
     - Use logarithmic X-axis
     -
   * - --logy
     - Use logarithmic Y-axis
     -

As an example, to plot a selected component from a multi-component
field do::

  pgkyl -f tf_q_10.h5 comp 0 plot

This will select the 0th component and plot it as a 2D color plot. If,
instead you want to plot a contour plot do::

  pgkyl -f tf_q_10.h5 comp 0 plot --contour

To plot the streamlines of the flow field do::

  pgkyl -f tf_q_10.h5 comp 0:5 euler -v vel plot --streamline

