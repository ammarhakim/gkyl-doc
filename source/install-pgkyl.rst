Installing Postgkyl: Post-processing for Gkeyll/Gkyl output
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Installing with conda
---------------------

The easiest way to install postgkyl is to use the conda installer that
ships with Anaconda Python. Once you have installed `Anaconda
<https://www.continuum.io/downloads>`_ or Miniconda, the latest
version of postgkyl can be installed from the gkyl channel using the
command::

  conda install -c gkyl postgkyl 

To update the conda installed version of postgkyl, do::

  conda update postgkyl

Install from Bitbucket
----------------------
  
Unless you are planning develop postgkyl itself, you should install
using Anaconda's conda installer. Even if you plan to develop the
code, it is a good idea to use conda to install the dependencies.

The postgkyl repo is private and access is only available to our close
collaborators. This means, in practice, those who have funded projects
or joint student projects with Princeton.

Once you have access to the Bitbucket repo, clone postgkyl into a new
directory and add the path of the directory to your PYTHONPATH env
variable. You will also need to add the pgkyl executable to your PATH.
