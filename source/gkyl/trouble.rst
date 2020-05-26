Troubleshooting
++++++++++++++

In building or running the code you may encounter some natural
difficulties with pushing the code into new places, or using
it in new machines. In such cases you may find it helpful to
consider some of the following suggestions and lessons from past
experiences.


Build troubleshooting
--------------------

- The ``./waf build install`` command fails on some systems
  due to a combination of the size of certain kernels, and the
  default parallel compilation.
  **Suggestion:** try building with ``./waf build install -j 1``
