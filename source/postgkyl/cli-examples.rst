Example Usage
+++++++++++++

The easiest way to understand Postgkyl is look at an example.

Imagine you want plot the pressure from a five-moment simulation. The
sequence of commands to this are:

- Read the data using the "-f" option
- Select the appropriate components using the *comp* command
- Use the *euler* command to compute the pressure
- Use the *plot* command to make the plot. 

Note that at present, "plot" command can only plot 1D or 2D
data. Hence, to plot 3D or higher fields, you will need to take slices
using the fix command.

The complete command is::

  pgkyl -f tf_q_10.h5 comp 0:5 euler -v pressure -g 1.4 plot

Note the command chaining: the "comp 0:5" command selects the five
conserved electron moments, the "euler -v pressure -g 1.4" command
computes the pressure and the "plot" command makes the actual plot.

To plot the ion pressure instead do::

  pgkyl -f tf_q_10.h5 comp 5:10 euler -v pressure -g 1.4 plot


To plot more than one frame at a time, you can load multiple data
files using a sequence of "-f" flags::

  pgkyl -f tf_q_10.h5 -f tf_q_20.h5 comp 0:5 euler -v pressure -g 1.4 plot

This will make two plots, one of the electron pressure from frame 10,
and the other of the electron pressure from frame 20.
