Note on the Windows Linux Subsystem (WSL)
=========================================

Historically, Gkeyll was supported only for Unix-like operating
systems. However, since the Windows 10 Anniversary Update in August
2016, it became possible to run Gkeyll even on Windows although with
reduced performance. This changed with the introduction of WSL 2 in
Spring/Summer 2020. With WSL 2, the performance on Unix and Windows is
indistinguishable.

.. tip::

   WSL 2 has its peak performance only when accessing files in the
   Linux part of the system rather then the mounted Windows
   directories. Therefore, it is not advisable to use locations like
   ``/mnt/c/Users/userid/Desktop/``. Instead, working from
   ``/home/userid/`` would lead to significantly improved performance.

Requirements:

* For x64 systems: **Version 1903** or higher, with **Build 18362** or higher
* For ARM64 systems: **Version 2004** or higher, with **Build 19041** or higher
* For WSL 2 (recommended): **Build 18362** and a CPU supporting
  Hyper-V virtualization

.. note::

   Windows 11 makes the process of installing WSL much easier. See the
   bottom of this page for additional steps required in Windows 10.
   

Installing WSL
--------------

First, WSL needs to be enabled. This can be done either using GUI or
PowerShell. For the former, go to *Turn Windows features on or off*
in the Control Panel and check Windows Subsystem for Linux at the
very bottom.

.. figure:: wsl/wf.png
  :align: center
          
Alternatively, this can be done in a terminal (running the PowerShell
as an Administrator):

.. code-block:: powershell

  dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

Linux distribution of choice is then available directly thru Microsoft
Store.  Currently, the following flavors are available:

* `Ubuntu 22.04 LTS <https://apps.microsoft.com/store/detail/ubuntu-2204-lts/9PN20MSR04DW>`_
* `Ubuntu 20.04 LTS <https://apps.microsoft.com/store/detail/ubuntu-20044-lts/9MTTCL66CPXJ>`_
* `Ubuntu 18.04 LTS <https://apps.microsoft.com/store/detail/ubuntu-18045-lts/9PNKSF5ZN4SW>`_
* `openSUSE Leap 15.4 <https://apps.microsoft.com/store/detail/opensuse-leap-154/9PJPFJHRM62V>`_
* `Kali Linux <https://apps.microsoft.com/store/detail/kali-linux/9PKR34TNCV07>`_
* `Debian <https://apps.microsoft.com/store/detail/debian/9MSVKQC78PK6>`_
* `Fedora Remix for WSL <https://apps.microsoft.com/store/detail/fedora-remix-for-wsl/9N6GDM4K2HNC>`_
* `Alpine WSL <https://apps.microsoft.com/store/detail/alpine-wsl/9P804CRF0395>`_

The Ubuntu distribution currently comes very much bare-bones. C
compiler and basic libraries (this is important even for running the
Conda version of Gkeyll) can be installed with

.. code-block::

   sudo apt install gcc

Using GUI requires additional dependencies. The official
`documentation
<https://docs.microsoft.com/en-us/windows/wsl/tutorials/gui-apps>`_
recommends installing and testing these with ``gedit``

.. code-block::

   sudo apt install gedit

To launch your bashrc file in the editor, enter: ``gedit ~/.bashrc``


Tips and tricks
---------------

Tools like ``jupyter-lab`` function through a web browser. While this
is not an issue on Windows 11 which does support GUI, it might be more
comfortable to use Windows browser. This can be achieved by launching
Jupyter without a browser using ``jupyter-lab --no-browser`` and then
copying the address including the token to a Windows browser of
choice. Alternatively, when using `Windows Terminal
<https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701>`_,
one can also use Ctrl + click.

Even though it is generally not recommended to modify Linux files
using Windows tools, it is often useful to access them, e.g. to open
a pdf. The Linux root, ``/``, can be accessed on Windows at
``\\wsl$\<DISTRIBUTION_NAME>``.

Popular text editor `Visual Studio Code
<https://code.visualstudio.com/>`_ can be used with advantage to work
with WSL files. The ``Remote - SSH`` is required.


Additional steps required on Windows 10
---------------------------------------

WSL 1 is the default on Windows 10. To update to WSL 2, virtualization
needs to be enabled first (in Administrator PowerShell)

.. code-block:: powershell

  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

The next step is to install the kernel update `package
<https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi>`_.
Finally, set WSL 2 needs to be changed to default (again using
PowerShell as Administrator).

.. code-block:: powershell

  wsl --set-version <distribution name> 2
  wsl --set-default-version 2


WSL on Windows 10 does not directly support GUI; however, this can be
overcome with a 3rd party X-server like `VcXsrv
<https://sourceforge.net/projects/vcxsrv/>`_ (this is our
**recommended** option as the other option does not seem to work on
some configurations) or `Xming
<https://sourceforge.net/projects/xming/>`_. Note that when using
VcXsrv, the `Disable access control` checkbox needs to be marked when
setting *XLaunch*. Otherwise, the X11 forwarding would not work
properly.

.. figure:: wsl/xlaunch.png
  :align: center

Finally, the ``$DISPLAY`` environmental variable needs to be set up on
the Linux side.

.. code-block:: bash
                
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

While this is an official recommendation, it might not work in some configurations. An alternative is bellow.

.. code-block:: bash

  export DISPLAY=$(route.exe print | grep 0.0.0.0 | head -1 | awk '{print $4}'):0.0


Known issues
------------

There is currently a known issue where Windows and Linux clocks might
get desynchronized when the computer sleeps. This might cause issues
with Git and update installation using ``sudo apt update``. There is a
workaround that works until this issue gets patched and that is
manually calling ``sudo hwclock -s`` to manually synchronize the time.
