.. _pg_cmd_write:

write
=====

Postgkyl can store data into a new ADIOS ``bp`` file (default; useful
for storing partially processed data) or into a ASCII ``txt`` file
(useful when one wants to open the data in a program that does not
support ``bp`` or ``h5``).

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../_static/postgkyl/commands/write.html"></iframe>
   </details>
   <br>

Command line usage
^^^^^^^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl write --help
    Usage: pgkyl writ [OPTIONS]
    
      Write active dataset to a file. The output file format can be set  with
      ``--mode``, and is ADIOS BP by default. If data is saved as BP file it can
      be later loaded back into pgkyl to further manipulate or plot it.
    
    Options:
      -u, --use TEXT            Specify a 'tag' to apply to (default all tags).
      -f, --filename TEXT       Output file name
      -m, --mode [bp|txt|npy]   Output file mode. One of `bp` (ADIOS BP file;
                                default), `txt` (ASCII text file), or `npy` (NumPy
                                binary file)
    
      -b, --buffersize INTEGER  Set the buffer size for ADIOS write (default: 1000
                                MB)
    
      -h, --help                Show this message and exit.

.. raw:: html

  </details>
  <br>

Script mode
^^^^^^^^^^^

The ``write`` command internally calls the ``write()`` method of the
``GData`` class.

.. code-block:: python

  import postgkyl as pg
  
  data = pg.data.GData('bgk_neut_0.bp')
  data.write()


