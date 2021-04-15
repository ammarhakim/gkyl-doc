.. _pg_keyconcepts:

Key concepts
++++++++++++

There are a few basic concepts of using ``pgkyl`` in a command
line. Together, they allow to quickly and easily create quite complex
diagnostics, which would otherwise require writing custom
postpocessing scripts.

Note that there are often multiple ways to achieve the same
thing. Sometimes, they are analogous, sometimes one is superior. This
page makes an attempt to explain these key concepts to allow user to
choose the best for each situation.

.. contents::

Dataset
-------
.. _pg_keyconcepts_dataset:

Each data file which is :ref:`loaded <pg_loading>` creates a
dataset. Additionally, some commands can create new datasets during the
flow.

When files are loaded using wildcard characters, each match creates
its own dataset. Therefore, assuming there are two files, ``file1.bp``
and ``file2.bp``, located in the current directory, the two following
commands will have the same result; both will create two datasets:

.. code-block:: bash

   pgkyl file1.bp file2.bp
   pgkyl file?.bp

Command chaining
----------------
.. _pg_keyconcepts_chaining:

Commands are evaluated from left to right. Each command, by default
applies to *everything* to the left of it. For example, this command
chain combines :ref:`loading <pg_loading>` data files and
:ref:`pg_cmd_interpolate` command:

.. code-block:: bash

   pgkyl file1.bp interpolate file2.bp

``file1.bp`` is loaded first, its DG expansion coefficients
are then interpolated on a finer uniform mesh, and, finally,
``file2.bp`` is loaded. :ref:`pg_cmd_interpolate` will *not* be
applied on ``file2.bp``. This particular example can be used, for
example, to simultaneously work with finite-element and finite-volume
data.

Commands that should not be applied on all the datasets can be further
controlled using :ref:`tags <pg_pg_keyconcepts_tags>` and by
designating some datasets as :ref:`inactive
<pg_keyconcepts_active>`. **Note that there are some commands, e.g.,**
:ref:`pg_cmd_ev` **or** :ref:`pg_cmd_collect`, **which switch their inputs to
inactive themselves.**

It is worth noting that there is no limit on how many commands can be
chained. See, for example, the :ref:`particle balance
<qs_gk1_balance>` section the the gyrokinetic :ref:`quickstart page
<qs_gk1>`.

Tags
----
.. _pg_keyconcepts_tags:

During :ref:`loading <pg_loading>`, optional flag, ``--tag`` or
``-t``, can be used to assign a tag to the dataset(s). Note that if
wildcard characters are used, the specified tag will be assigned to all
the matches.

By default, most of the commands are agnostic to the tags. For
example, the following two commands will lead to the same result:

.. code-block:: bash
                
   pgkyl file1.bp file2.bp plot
   pgkyl file1.bp --tag 'f1' file2.bp --tag 'f2' plot

However, most of the commands can take the ``--use`` flag to limit them
only to all the datasets with the specified tag. Similar to the
example above, this can be useful when working with different types of
data:

.. code-block:: bash
                
   pgkyl file1.bp --tag 'f1' file2.bp --tag 'f2' interpolate --use f1 plot

Here, :ref:`pg_cmd_interpolate` will be used only on the ``file1.bp``
even though it follows loading both of the files.

Note that multiple comma-separated tags can be used:

.. code-block:: bash
                
   pgkyl file1.bp --tag 'f1' file2.bp --tag 'f2' file3.bp --tag 'f3' interpolate --use f1,f2 plot

Additionally, there are some commands like :ref:`pg_cmd_collect` or
:ref:`pg_cmd_animate` are by default tag-aware and separate datasets
with different tags from each other. :ref:`pg_cmd_ev` command uses
different syntax when when working with tags.

When no tag is specified, the ``default`` tag is assigned.

.. warning::
   When using tags together with wildcard characters, it is important
   to use quotes, e.g.:

   .. code-block:: bash
                
      pgkyl 'file?.bp' --tag name

   Without the quotes, the string is replaced with all the matches,
   ``pgkyl`` treats them as separate :ref:`load <pg_loading>`
   commands, and the specified tag is applied only to the last match.


Active and inactive datasets
----------------------------
.. _pg_keyconcepts_active:

In addition to specifying :ref:`tags <pg_keyconcepts_tags>`, the flow
of a ``pgkyl`` command chain can be controlled by :ref:`activating
<pg_cmd_activate>` and :ref:`deactivating <pg_cmd_deactivate>`
datasets. By default, all loaded datasets are active. This can be
changed with the pair of :ref:`pg_cmd_activate` and
:ref:`pg_cmd_deactivate` commands. In addition, some commands that
possibly change the nature of its inputs and create a new dataset,
e.g., :ref:`pg_cmd_ev`, :ref:`pg_cmd_collect`, or various diagnostics,
change their input datasets to inactive.

:ref:`pg_cmd_activate` can either take in indices, tags, or
both. When no inputs are specified, everything is activated. The two
following commands provide yet another way to to achieve the same as
above:

.. code-block:: bash
                
   pgkyl file1.bp --tag 'f1' file2.bp --tag 'f2' activate --tag f1 interpolate activate plot
   pgkyl file1.bp  file2.bp activate --index 0 interpolate activate plot
   
The :ref:`pg_cmd_info` command can be useful when working with
multiple active/inactive datasets. Its ``--compact`` option shows only
identifiers for each dataset, thus removes some clatter, and
``--allsets`` adds even the currently inactive datasets.

   
Overwriting vs. new dataset
---------------------------
.. _pg_keyconcepts_overwrite:

There are two basic types of commands in terms of how they interact
with inputs.

The first type modifies its inputs and pushes data down the chain. A
typical example is the :ref:`pg_cmd_interpolate` command, which takes
expansion coefficients of DG finite-element data and interpolates them
on a finer uniform mesh, essentially creating finite-volume data.

.. code-block:: bash
                
   pgkyl file1.bp interpolate plot

In this case the original information is lost after the
:ref:`pg_cmd_interpolate` command (lost within this command chain,
nothing happens to the data file itself).

The other type does not overwrite its inputs but rather creates a new
dataset. As a rule of thumb, these are commands that take (or can take)
multiple inputs and is, therefore, unclear which input to modify. Note
that these commands often make the result the only active dataset to
simplify the flow. A typical example is :ref:`pg_cmd_ev`:

.. code-block:: bash
                
   pgkyl file1.bp file2.bp ev 'f[0] f[1] -' plot

As a result of this chain, there will be three datasets; however, only
the result of :ref:`pg_cmd_ev` will be active, so the
:ref:`pg_cmd_plot` command will create just one figure.

There are instances when user does *not* want to overwrite the
inputs. For example, when we want to use :ref:`pg_cmd_select` to
create multiple slices of data. For this purpose, the commands that
would normally overwrite data have the optional ``--tag`` flag
which instead creates a new dataset with specified tag. Note that in
this case, the resulting dataset will *not* be the only one active.

.. code-block:: bash

   pgkyl file1.bp --tag input select --use input --z0 -1. --tag planes \
   select --use input --z0 1. --tag planes plot --use planes
