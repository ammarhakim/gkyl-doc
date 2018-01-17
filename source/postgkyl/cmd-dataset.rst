Dataset
+++++++

The dataset command is used to select a specific dataset to be the
"active" dataset on the data stack. This is useful when one wants to
chain a sequence of commands that work on different data fields. By
default *all* datasets are active and hence any command will be
applied to *all* of the fields on the stack. Often, this is not the
desired behavior, and in this case the dataset command is useful.

The command takes the following options:

.. list-table::
   :widths: 30, 60, 10
   :header-rows: 1

   * - Option
     - Description
     - Default
   * - -i, --idx
     - Index of dataset to make active
     -
   * - -a, --allsets
     - Make all datasets active
     - Default
