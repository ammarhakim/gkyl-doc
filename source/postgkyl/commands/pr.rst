.. _pg_cmd_pr:

pr
--

Print data to screen.

Command line
^^^^^^^^^^^^

.. raw:: html

   <details>
   <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl pr -h
    Usage: pgkyl pr [OPTIONS]

      Print the data

    Options:
      -u, --use TEXT  Specify a 'tag' to apply to (default all tags).
      -h, --help  Show this message and exit.

.. raw:: html

   </details>
   <br>

This command allows us to print a dataset to screen. Large
data sets like time-traces or multidimensional data might
fill up the screen, so this might not be a good way to
explore those. However, since postgkyl does not plot 0D
data (single points), it is useful to print those to screen.

For example, we could integrate the initial number density
in the :doc:`two stream instability simulation<../input/two-stream>`
and print out the total number of particles to the screen with

.. code-block:: bash

  pgkyl two-stream_elc_M0_0.bp interp integrate 0 pr

and produce the following output:

.. code-block:: bash

  25.132741228817842
