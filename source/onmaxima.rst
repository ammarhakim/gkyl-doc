On use of the Maxima CAS
++++++++++++++++++++++++

Throughout Gkyl a large amount of Lua and C++ code is automatically
pre-generated using the `Maxima <http://maxima.sourceforge.net>`_
computer algebra system (CAS). Maxima is free and has a vast amount of
features. For some of the calculations the use of a CAS is essential
as the algebra, even though relatively easy, is very tedious, needing
thousands of evaluations of various integrals etc. All Maxima code is
checked into the gkyl/cas-scripts directory.

To use the Maxima code in this directory you need to tell Maxima to
find it. To do this, create the directory (if it does not exist
already)::

  mkdir $HOME/.maxima

In this create or edit the file called "maxima-init.mac" and add the
following lines to it::

  file_search_maxima: append(file_search_maxima,
    ["PATH_TO_YOUR_GKYL/gkyl/cas-scripts/###.{lisp,mac}"]) $

Where "PATH_TO_YOUR_GKYL" is the full path to the location where your
gkyl source lives. Start/restart Maxima. Once you do this, then the
Maxima code in the ``cas-scripts`` directory can be loaded, for
example as::

  load("modal-basis")$
  load("basis-precalc/basisSer1x1v")$

This will load the code to work with Modal basis functions and the
serendipity basis sets in 1x1v into your Maxima session/code.
