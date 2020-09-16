.. _pg_cmd_ev:

ev
+++

.. contents::

Function description
^^^^^^^^^^^^^^^^^^^^

Command line usage
^^^^^^^^^^^^^^^^^^

.. code-block:: bash

   $ pgkyl ev -h
   Usage: pgkyl ev [OPTIONS] CHAIN

     Manipulate dataset using math expressions. Expressions are specified using
     Reverse Polish Notation (RPN). Supported operators are: '+', '-', '*',
     '/', 'sqrt', 'sin', 'cos', 'tan', 'abs', 'avg', 'log', 'log10', 'max',
     'min', 'mean', 'len', 'pow', 'sq', 'exp', 'grad', 'int', 'div', 'curl'.
     User-specifed commands can also be used.

   Options:
     -l, --label TEXT  Specify a custom label for the dataset resulting from the
                       expression.
     -h, --help        Show this message and exit.
