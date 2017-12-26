Command line options
++++++++++++++++++++

The top-level executable is called "pgkyl". To use pgkyl, pass a set
of files to load using a sequence of -f flags, and then specify a
chain of commands to execute::

  Usage: pgkyl [OPTIONS] COMMAND1 [ARGS]... [COMMAND2 [ARGS]...]...

  Options:
    -v, --verbose        Turn on verbosity
    -f, --filename TEXT  Specify one or more file(s) to work with.
    -h,--histname TEXT Specify one or more history files to work with.
    --help               Show this message and exit.

Help for individual commands can be obtained by specifying the command
name and passing it the --help option. For example::

   pgkyl euler --help

   Usage: pgkyl euler [OPTIONS]

   Extract Euler (five-moment) primitive variables from fluid simulation

   Options:
   -g, --gas_gamma FLOAT           Gas adiabatic constant
   -v, --variable_name [density|xvel|yvel|zvel|vel|pressure]
   Variable to plot
   --help                          Show this message and exit.  

To read data from a field you need to specify the exact name of the
file containing that field, including the extension::

  pgkyl -f tf_q_1.h5 comp 0 plot

More than one file can be loaded at the same time by using the -f flag
repeatedly::

  pgkyl -f tf_q_1.h5 -f tf_q_10.h5 comp 0 plot

This will plot the density from both the 1st and the 10th frame on two
different windows.

When reading a sequence of history files, exclude the file
extension. For example::

  pgkyl -f tf_totalEnergy plot

will plot the complete time-history of total energy from a five-moment
simulation. Note that when used in this form all history files are
read and concatenated before becoming available to the command system.

If you want to plot data from a single history file use the -h option::

  pgkyl -h tf_totalEnergy_1.h5 plot

This will plot only that portion of the diagnostic data stored in the
specified file.

The -f flag allows wildcards in the name. However, *wildcards must be
enclosed in quotes*. For example::

  pgkyl -f '*.h5' info

Will run the *info* command on all HDF5 files in the directory.
