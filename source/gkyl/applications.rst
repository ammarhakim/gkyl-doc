Gkeyll Apps
+++++++++++

Gkeyll Apps are top-level objects that solve a class of problems. Apps
make it easy to setup a problem as the steps in the algorithm are
pre-packaged. Although the apps are usually flexible enough to support
most use cases, there may be problems for which a more fine-grained
control over the simulation is required. In this case, the user has
the option of directly instantiating various Gkeyll objects (grids,
fields etc) and calling updaters in a custom hand-coded time-stepping
loop [#gsim]_. This process can be complicated and is described elsewhere.

The following apps are available in Gkeyll.

.. toctree::
  :maxdepth: 1

  VlasovOnCartGrid
  GyroOnCartGrid

.. rubric:: Footnotes

.. [#gsim] The concept of apps was introduced in Gkeyll 2.0. In the
   1.0 version of the code the input files contained the complete
   simulation cycle. Although Gkeyll can still be used in that
   fashion, it is best to switch to the app model as it simplifies the
   user input considerably.


