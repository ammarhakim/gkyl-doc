.. _pg_cmd_ev:

ev
===

``ev`` is a special command that enables simple operations like adding
or multiplying datasets directly in a terminal. As these operations
are generally simple to do in a script mode, ``ev`` is available only
in the command line interface.

.. note::
   This page uses the Postgkyl 1.6 syntax and features.

.. contents::

Reverse Polish notation
-----------------------

``ev`` uses reverse Polish notation (RPN; also know as postfix
notation) to input operations. Unlike in the more common infix
notation, in RPN, the operators follow operands. For example ``4 - 2``
is written in RPN as ``4 2 -``; ``4 - (2 / 5)`` is ``4 2 5 / -``. This
can be further demonstrated on the sequence that processes this
expression.

1. ``4`` >>> ``4`` (Add 4 to the stack)
2. ``4 2`` >>> ``4 2`` (Add 2 to the stack)
3. ``4 2 5`` >>> ``4 2 5`` (Add 5 to the stack)
4. ``4 2 5 /`` >>> ``4 0.4`` (Divide the last two elements with each other)
5. ``4 2 5 / -`` >>> ``3.6`` (Subtract the last two elements from each other)

More information about RPN can be found, for example, on
`Wikipedia <https://en.wikipedia.org/wiki/Reverse_Polish_notation>`_.

Using ``ev`` on simple datasets
-------------------------------

The ``ev`` command has one required argument, which is the operation
sequence. Datasets are specified in the sequence with
``f[set_index][component]``. Note that Python indexing conventions are
used. Specifically, when no indices are specified, everything is used,
i.e., ``f[0][:]`` and ``f[0]`` are treated as identical calls. Python
slice syntax can be used as well including negative indices and
strides. For example, ``f[2:-1:2]`` will select every other dataset,
starting with the third one (zero-indexed), and ending with one before
the last (by Python conventions, the upper bound is not included; in
this example it might end with the third element from the end because
of the stride).

.. note::
  Dataset selection in ``ev`` internally uses the same code as the
  :ref:`pg_cmd_activate`/:ref:`pg_cmd_deactivate` commands, so the
  following commands produce similar results (``ev`` actually copies
  the datasets instead of just activating some).

  .. code-block:: bash

     pgkyl two-stream_elc_?.bp activate -i '2:-1:2'
     pgkyl two-stream_elc_?.bp ev 'f[2:-1:2]'

  However, this is probably a fringe application of ``ev``.

The simplest example of ``ev`` is a numerical operation performed on
a dataset, e.g., dividing the values by the insidious factor of 2:

.. code-block:: bash

   pgkyl two-stream_elc_0.bp ev 'f[0] 2 /'

This can be also combined with the fact that ``ev`` can access dataset
metadata as long as they are included (which is a new feature in
Gkeyll introduced in January 2021). An example of this can be plotting
number density from a fluid simulation (Gkeyll outputs mass density).

.. code-block:: bash

   pgkyl 5m_fluid_elc_0.bp ev 'f[0][0] f[0].mass /' plot

Note that on top of dividing by mass, only the first component, which
corresponds to density, was selected. This can be easily extended to
apply on multiple datasets and create an animation using the
:ref:`pg_cmd_animate` command

.. code-block:: bash

   pgkyl '5m_fluid_elc_[0-9]*.bp' ev 'f[:][0] f[:].mass /' animate

The capabilities are not limited to operations with float factors. As
an example, ``ev`` can be used to visualize differences
(``--diverging`` mode of the :ref:`pg_cmd_plot` command is well suited
for this)

.. code-block:: bash

  pgkyl two-stream_elc_0.bp two-stream_elc_80.bp interpolate ev 'f[1] f[0] -' plot --diverging

  
.. figure:: ../fig/plot/diverging.png
  :align: center
        
  Visualizing difference between two datasets

.. note::
   :ref:`pg_cmd_info` command, especially with the ``--compact``
   ``-c`` flag can be useful to print indices for available datasets.

The same concept can be used to calculate bulk velocity from the first
two moments:

.. code-block:: bash

  pgkyl two-stream_elc_M0_0.bp two-stream_elc_M1i_0.bp interpolate ev 'f[1] f[0] /' plot

Finally, it is worth noting that this syntax cannot be used when there
are datasets with more than one tag active.

Using ``ev`` on datasets with tags
----------------------------------

The ``ev`` command is tag-aware. Tagged datasets use the following
notation ``t.tag_name[set_index][component]``. Using this, the
previous example can be reproduced:

.. code-block:: bash

  pgkyl two-stream_elc_M0_0.bp -t dens two-stream_elc_M1i_0.bp -t mom interp ev 'mom dens /' plot

However, unlike the previous example, this can be naturally extended
for batch loading and :ref:`pg_cmd_animate`:

.. code-block:: bash

  pgkyl 'two-stream_elc_M0_[0-9].bp' -t dens 'two-stream_elc_M1i_[0-9]*.bp' -t mom interp ev 'mom dens /' animate
