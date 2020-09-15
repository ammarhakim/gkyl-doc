Installing Postgkyl
+++++++++++++++++++

Installing Postgkyl is even easier than installing Gkyl.  One option
is to to use the Conda package manager, the other is to manually clone the
Postgkyl repository.  It should be noted that having both the
repository and having Postgkyl installed through Conda on a single
machine can cause unforeseen consequences.

Installing with Conda
---------------------

The easiest way to install Postgkyl is to use the Conda installer that
ships with Anaconda Python. Once you have installed `Anaconda
<https://conda.io/miniconda.html>`_, the latest
version of postgkyl can be installed from the ``gkyl`` channel using the
command::

  conda install -c gkyl postgkyl 

Alternatively, one can permanently add the channel and install
Postgkyl with::

  conda config --add channels gkyl
  conda install postgkyl

The big advantage of the installation through Conda is that all the
dependencies are installed together with Postgkyl.  To update the
Conda installed version of Postgkyl, do::

  conda update -c gkyl postgkyl

In order to use the Conda installation, the user requires to have the
write permission to the Anaconda directory.  This is not the case when
anaconda is loaded as a module on a supercomputer.  For
supercomputers, one can either create a Conda
`environment <https://conda.io/docs/user-guide/tasks/manage-environments.html>`_
or install the Anaconda into ``$HOME`` directory.

Installing from source
----------------------
  
Unless you are planning develop postgkyl itself, you should install
using Anaconda's conda installer. Even if you plan to develop the
code, it is a good idea to use Conda to install the dependencies:

* adios
* click
* matplotlib
* numpy
* pytables
* scipy
* sympy

The postgkyl repository is private and access is only available to our close
collaborators. This means, in practice, those who have funded projects
or joint student projects with Princeton.

Once you have access to the Github repository, clone postgkyl into a
new directory and add the path of the directory to your ``PYTHONPATH``
env variable. You will also need to add the ``pgkyl`` executable to
your ``PATH``.
