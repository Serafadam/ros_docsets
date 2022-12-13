Installation
============

The functionality of ``colcon`` is split over multiple Python packages.
The package ``colcon-core`` provides the command line tool ``colcon`` itself as well as a few fundamental extensions.
Additional functionality is provided by separate packages, e.g. ``colcon-cmake`` adds support for packages which use `CMake <https://cmake.org/>`_.
The following instructions install a set of common ``colcon`` packages.

Using Debian packages
---------------------

On platforms which support Debian packages using those is preferred since they will be updated using ``apt`` together with other system packages.

In the context of the ROS project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `ROS project <https://www.ros.org/>`_ hosts copies of the Debian packages in their apt repositories.
You can choose either of the two following apt repositories.

* `ROS 1 repository <http://wiki.ros.org/Installation/Ubuntu#Installation.2BAC8-Ubuntu.2BAC8-Sources-4.Setup_your_sources.list>`_

  .. code-block:: bash

      $ sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros-latest.list'
      $ sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

* `ROS 2 repository <https://github.com/ros2/ros2/wiki/Linux-Install-Debians#setup-sources>`_

  .. code-block:: bash

      $ sudo sh -c 'echo "deb [arch=amd64,arm64] http://repo.ros2.org/ubuntu/main `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list'
      $ curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

After that you can install the Debian package which depends on ``colcon-core`` as well as commonly used extension packages (see `setup.cfg <https://github.com/colcon/colcon-common-extensions/blob/master/setup.cfg>`_).

.. code-block:: bash

    $ sudo apt update
    $ sudo apt install python3-colcon-common-extensions

Outside the ROS project
~~~~~~~~~~~~~~~~~~~~~~~

The Debian packages are also hosted in an apt repository provided by `packagecloud <https://packagecloud.io/>`_: |packagecloud|

.. |packagecloud| image:: https://img.shields.io/badge/deb-packagecloud.io-844fec.svg
    :target: https://packagecloud.io/dirk-thomas/colcon

You can add the GPG key as well as the apt repository using the following command (which is described `here <https://packagecloud.io/dirk-thomas/colcon/install>`_).

  .. code-block:: bash

      $ curl -s https://packagecloud.io/install/repositories/dirk-thomas/colcon/script.deb.sh | sudo bash

After that you can install the Debian package which depends on ``colcon-core`` as well as commonly used extension packages (see `setup.cfg <https://github.com/colcon/colcon-common-extensions/blob/master/setup.cfg>`_).

.. code-block:: bash

    $ sudo apt install python3-colcon-common-extensions

Using pip on any platform
-------------------------

On all non-Debian platforms the most common way of installation is the Python package manager ``pip``.
The following assumes that you are using a virtual environment with Python 3.5 or higher.
If you want to install the packages globally it might be necessary to invoke ``pip3`` instead of ``pip`` and require ``sudo``.

.. code-block:: bash

    $ pip install -U colcon-common-extensions

.. note::

    The package ``colcon-common-extensions`` doesn't contain any functionality itself but only depends on a set of other packages (see `setup.cfg <https://github.com/colcon/colcon-common-extensions/blob/master/setup.cfg>`_).

.. note::

    You can find a list of released packages on `PyPI <https://pypi.org/search/?q=colcon>`_ using the keyword ``colcon``.

Installing from source
----------------------

.. note::

    This approach is commonly only used by advanced users.

Commonly this is the case when you want to try or leverage new features or bug fixes which have been committed already but are not available in a released version yet.
In order to use the latest state of any of the above packages you can invoke ``pip`` with a URL of the GitHub repository:

.. code-block:: bash

    $ pip install -U git+https://github.com/colcon/colcon-common-extensions.git

Installing custom branches from source
--------------------------------------

To try a patch proposed in a pull request you can install the sources of that specific branch by appending the branch name to the URL:

.. code-block:: bash

    $ pip install -U git+https://github.com/colcon/colcon-core.git@branch_name

.. note::

    Make sure to uninstall that custom version again using ``pip uninstall <name>`` to revert back to the previously used version.
    Otherwise if you use the Debian packages this pip installed package will overlay even newer Debian packages.

Building from source
--------------------

Since this is not a common use case for users you will find the documentation in the :doc:`developer section <../developer/bootstrap>`.

Quick directory changes
-----------------------

Sh (and compatible shells)
~~~~~~~~~~~~~~~~~~~~~~~~~~

On Linux / macOS the above instructions install the package ``colcon-cd`` which offers a command to change to the directory a package specified by its name is in.
To enable this feature you need to source the shell script provided by that package.
The script is named ``colcon_cd.sh``.
For convenience you might want to source it in the user configuration, e.g. ``~/.bashrc``:

Depending on which instructions you followed to install the packages the location will vary:

* Debian package: ``/usr/share/colcon_cd/function``
* PIP - user specific: ``$HOME/.local/share/colcon_cd/function``
* PIP - global: ``/usr/local/share/colcon_cd/function``

When building ``colcon`` from source the generated setup files will automatically include this hook.

Enable completion
-----------------

Bash / zsh
~~~~~~~~~~

On Linux / macOS the above instructions install the package ``colcon-argcomplete`` which offers command completion for bash and bash-like shells.
To enable this feature you need to source the shell-specific script provided by that package.
These scripts are named ``colcon-argcomplete.bash`` / ``colcon-argcomplete.zsh``.
For convenience you might want to source the one matching your shell in the user configuration, e.g. ``~/.bashrc``:

Depending on which instructions you followed to install the packages the location will vary:

* Debian package: ``/usr/share/colcon_argcomplete/hook``
* PIP - user specific: ``$HOME/.local/share/colcon_argcomplete/hook``
* PIP - global: ``/usr/local/share/colcon_argcomplete/hook``

When building ``colcon`` from source the generated setup files will automatically include this hook.
