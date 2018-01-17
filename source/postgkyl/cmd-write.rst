Write
+++++

The write command is used to save the dataset on the top of the stack
to a file. The data can be either saved to HDF5 file or to a
plain-text file. *HDF5 should be preferred for large files*, and is
the default. The other advantage of HDF5 output it that the saved
files can be later read back into Postgkyl to do further analysis if
needed.

The command takes the following options:

.. list-table::
   :widths: 10, 80, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - -f
     - Name for output file
     -
   * - -m
     - Output file format. Either h5 or txt
     - h5
