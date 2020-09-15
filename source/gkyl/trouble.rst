Troubleshooting
++++++++++++++

As you build or run Gkeyll you may encounter some difficulties. 
This is natural when pushing the code in new directions, or using
it in new machines. In such cases you may find it helpful to
consider some of the following suggestions and lessons from past
experiences.


Build troubleshooting
--------------------

- The ``./waf build install`` command fails on some systems
  due to a combination of the size of certain kernels, and the
  default parallel compilation.
  **Suggestion:** try building with ``waf build install -j 1``.
  If this causes compilation to take too long, you can use ``waf -h``
  to see the default number of threads used, and then try something
  smaller than that but larger than 1.
