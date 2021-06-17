Note on the Windows Linux Subsystem (WSL)
=========================================

Historically, Gkeyll was supported only for Unix-like operating
systems. However, since the Windows 10 Anniversary Update in August
2016, it became possible to run Gkeyll even on Windows although with
reduced performance. This changed with the introduction of WSL 2 in
Spring/Summer 2020. With WSL 2, the performance on Unix and Windows is
indistinguishable.

Requirements:

* For x64 systems: **Version 1903** or higher, with **Build 18362** or higher
* For ARM64 systems: **Version 2004** or higher, with **Build 19041** or higher
* For WSL 2 (recommended): **Build 18362** and a CPU supporting
  Hyper-V virtualization

Enabling and installing WSL
---------------------------

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

The Linux distribution itself is
available thru Microsoft Store.  Currently, the following flavors are
available:

* `Ubuntu 16.04 LTS <https://www.microsoft.com/store/apps/9pjn388hp8c9>`_
* `Ubuntu 18.04 LTS <https://www.microsoft.com/store/apps/9N9TNGVNDL3Q>`_
* `Ubuntu 20.04 LTS <https://www.microsoft.com/store/apps/9n6svws3rx71>`_
* `openSUSE Leap 15.1 <https://www.microsoft.com/store/apps/9NJFZK00FGKV>`_
* `SUSE Linux Enterprise Server 12 SP5 <https://www.microsoft.com/store/apps/9MZ3D1TRP8T1>`_
* `SUSE Linux Enterprise Server 15 SP1 <https://www.microsoft.com/store/apps/9PN498VPMF3Z>`_
* `Kali Linux <https://www.microsoft.com/store/apps/9PKR34TNCV07>`_
* `Debian GNU/Linux <https://www.microsoft.com/store/apps/9MSVKQC78PK6>`_
* `Fedora Remix for WSL <https://www.microsoft.com/store/apps/9n6gdm4k2hnc>`_
* `Pengwin <https://www.microsoft.com/store/apps/9NV1GV1PXZ6P>`_
* `Pengwin Enterprise <https://www.microsoft.com/store/apps/9N8LP0X93VCP>`_
* `Alpine WSL <https://www.microsoft.com/store/apps/9p804crf0395>`_


It is strongly recommended to then enable WSL 2 for much better
performance. First, enable virtualization in Administrator PowerShell

.. code-block:: powershell

  dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

Download and install the kernel update `package
<https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi>`_.
And finally, set WSL 2 as the default (again using PowerShell as Administrator).

.. code-block:: powershell

  wsl --set-version <distribution name> 2
  wsl --set-default-version 2

  
Interaction between Windows and Linux; GUI
------------------------------------------

As of September 2020, WSL2 does not directly support GUI; however,
this is currently supposed to be in the works. Until the official
release, this can be overcome with a 3rd party X-server like `VcXsrv
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
the Linux side. In WSL 1 this was as simple as

.. code-block:: bash

  export DISPLAY=:0


WSL 2, however, uses virtualization and the forwarding address changes
which each launch of the system. The address is stored in
`/etc/resolv.conf`. The ``$DISPLAY`` can be set up with:

.. code-block:: bash
                
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0

Another issue might be caused by tools that want to open a browser,
for example, the commonly used ``jupyter-lab``. This can be easily
overcome by launching the server without a browser using ``jupyter-lab
--no-browser`` and then copying the address including the token to a
Windows browser.

Finally, it is often useful to access the Linux files from
Windows. Using WLS 2, the Linux root, ``/``, is located at
``\wsl$\<DISTRIBUTION_NAME>``.


Known issues
------------

There is currently a known issue where Windows and Linux clocks might
get desynchronized when the computer sleeps. This might cause issues
with Git and update installation using ``sudo apt update``. There is a
workaround that works until this issue gets patched and that is
manually calling ``sudo hwclock -s`` to manually synchronize the time.
