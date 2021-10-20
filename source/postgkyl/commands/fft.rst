.. _pg_cmd-fft:

fft
===

.. raw:: html

   <details closed>
   <summary><a>Command Docstrings</a></summary>
   <iframe src="../../_static/postgkyl/commands/fft.html"></iframe>
   </details>
   <br>

Command line
^^^^^^^^^^^^

.. raw:: html

  <details>
  <summary><a>Command help</a></summary>

.. code-block:: bash
  :emphasize-lines: 1

  pgkyl fft --help
    Usage: pgkyl fft [OPTIONS]
    
      Calculate the Fourier Transform or the power-spectral density of input
      data. Only works on 1D data at present.
    
    Options:
      -p, --psd       Limits output to positive frequencies and returns the power
                      spectral density |FT|^2.
    
      -u, --use TEXT  Specify a 'tag' to apply to (default all tags).
      -t, --tag TEXT  Optional tag for the resulting array
      -h, --help      Show this message and exit.

.. raw:: html

  </details>
  <br>

Script mode
^^^^^^^^^^^
