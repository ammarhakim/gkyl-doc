write: processed data storing
-----------------------------

Command Line Mode
^^^^^^^^^^^^^^^^^

Postgkyl can store data into a new ADIOS ``bp`` file (default; useful for
storing partially processed data) or into a ASCII ``txt`` file (useful
when one wants to open the data in a program that does not support
``bp`` or ``h5``).

.. list-table:: Write parameters
   :widths: 10, 30, 60
   :header-rows: 1

   * - Abbreviation
     - Parameter
     - Description
   * - ``-f``
     - ``--filename``
     - Specify a name of the new file (an automatic name is
       composed if left blank)
   * - ``-t``
     - ``--txt``
     - Write into a ``txt`` file instead of a ``bp`` file

------

Script Mode
^^^^^^^^^^^

The ``write`` command internally calls the ``write()`` method of the
``GData`` class.

.. code-block:: python

  import postgkyl as pg
  
  data = pg.data.GData('bgk_neut_0.bp')
  data.write()
