Quick start
===========

This section gives a high-level overview of how to use the ``colcon`` command.

TL;DR
-----

The following is an example workflow and sequence of commands using default settings:

.. code-block:: bash

    $ mkdir -p /tmp/workspace/src     # Make a workspace directory with a src subdirectory
    $ cd /tmp/workspace               # Change directory to the workspace root
    $ <...>                           # Populate the `src` directory with packages
    $ colcon list                     # List all packages in the workspace
    $ colcon graph                    # List all packages in the workspace in topological order
                                      # and visualize their dependencies
    $ colcon build                    # Build all packages in the workspace
    $ colcon test                     # Test all packages in the workspace
    $ colcon test-result --all        # Enumerate all test results
    $ . install/local_setup.bash      # Setup the environment to use the built packages
    $ <...>                           # Use the built packages

The most commonly used arguments for the ``build`` and ``test`` verbs are to only process a specific package or a specific package including all the recursive dependencies it needs.

.. code-block:: bash

    $ colcon build --packages-select <name-of-pkg>
    $ colcon build --packages-up-to <name-of-pkg>

.. note::

    The log files of the latest invocation can be found in the log directory which is by default in ``~/.colcon/log/latest``.

.. note::

    If you want to see the output of each package after it finished you can pass the argument ``--event-handlers console_cohesion+``.

Build ROS 2 packages
--------------------

The process of building `ROS 2 <http://www.ros2.org/>`_ packages is described in the `ROS 2 building from source <https://github.com/ros2/ros2/wiki/Installation#building-from-source>`_ instructions.
Using ``colcon`` instead of the recommended tool ``ament_tools`` only changes a couple of the steps.

Instead of invoking ``ament build`` you can invoke ``colcon``.

.. code-block:: bash

    $ colcon build

In order to use the built packages you need to source the ``install/local_setup.<ext>`` script mentioned in the instructions.

For detailed information how command line arguments of ``ament_tools`` are mapped to ``colcon`` please see the :doc:`ament_tools migration guide <../migration/ament_tools>`.

Build ROS 1 packages
--------------------

The process of building `ROS 1 <http://www.ros.org/>`_ packages is described in the `distro specific <http://wiki.ros.org/melodic/Installation/Source>`_ building from source instructions.
Using ``colcon`` instead of the recommended tool ``catkin_make_isolated`` only changes a couple of the steps.

.. note::

    ``colcon-ros`` requires at least version 0.7.13 of ``catkin`` which provides a new CMake option the tool uses.

Instead of invoking ``catkin_make_isolated --install`` you can invoke ``colcon``.

.. code-block:: bash

    $ colcon build

.. note::

    ``colcon`` does by design not support the concept of a "devel space" as it exists in ROS 1.
    Instead it requires each package to be installed so each package must declare an install step in order to work with ``colcon``.

In order to use the built packages you need to source the ``install/local_setup.<ext>`` rather than the ``setup.<ext>`` script mentioned in the instructions.
For ``bash`` the command would be:

.. code-block:: bash

    $ source install/local_setup.bash

For detailed information how command line arguments of ``catkin_make_isolated`` are mapped to ``colcon`` please see the :doc:`catkin_make_isolated migration guide <../migration/catkin_make_isolated>`.
For detailed information how command line arguments of ``catkin_tools`` are mapped to ``colcon`` please see the :doc:`catkin_tools migration guide <../migration/catkin_tools>`.

Test ROS 1 packages
~~~~~~~~~~~~~~~~~~~

As of ``colcon-ros`` version 0.3.6 the ``build`` verb builds the test targets for ROS 1 packages implicitly (when available).

In earlier versions you must build the custom ``tests`` target explicitly:

.. code-block:: bash

    $ colcon build --cmake-target tests

Build Gazebo and the ignition packages
--------------------------------------

In more recent versions `Gazebo <http://www.gazebosim.org/>`_ has been refactored to split out a lot of the functionality into `ignition <https://bitbucket.org/ignitionrobotics/>`_ libraries.
While that makes the project more modular it also increases the effort necessary to build all these packages from source.
``colcon`` can make this process easy again.

In order to build a specific Gazebo version you need the right versions of the ignition libraries.
At the time of writing Gazebo 9 is the latest release so we will use that for the purpose of this example.
The following steps use a ``.repos`` to specify the various repositories with specific branches.

.. code-block:: bash

    $ mkdir -p /tmp/gazebo/src && cd /tmp/gazebo
    $ wget https://gist.githubusercontent.com/dirk-thomas/6c1ca2a7f5f8c70ce7d3e1ef10a9f678/raw/490aaba72321284af956c9db12f9ef1550ef88cf/Gazebo9.repos
    $ vcs import src < Gazebo9.repos

.. note::

    The Gist containing the repository list should be replaced with an "official" URL coming from the Gazebo project.

Before building the workspace with ``colcon`` the steps also fetch some additional metadata for Gazebo from a public repository.

.. code-block:: bash

    $ colcon metadata add default https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml
    $ colcon metadata update
    $ colcon build

To run Gazebo, which requires environment variables for e.g., the model paths, the same commands as for other packages can be used.
Using the additional metadata the source script will also automatically source the Gazebo specific file ``share/gazebo/setup.sh`` which defines these environment variables.

.. code-block:: bash

    $ . install/local_setup.bash
    $ gazebo
