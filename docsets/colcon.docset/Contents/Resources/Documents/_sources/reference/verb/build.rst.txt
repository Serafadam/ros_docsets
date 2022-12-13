``build`` - Build Packages
==========================

The ``build`` verb is building a set of packages.
It is provided by the ``colcon-core`` package.

Command line arguments
----------------------

These common arguments can be used:

* :doc:`executor <../executor-arguments>` arguments
* :doc:`event handler <../event-handler-arguments>` arguments
* :doc:`discovery <../discovery-arguments>` arguments
* :doc:`package selection <../package-selection-arguments>` arguments
* :doc:`mixin <../mixin-arguments>` arguments

Additionally, the following specific command line arguments can be used:

.. _build-verb_build-base_arg:

\\--build-base BUILD_BASE
  The base path for all build directories.
  The default value is ``./build``.
  Each package uses a subdirectory in that base path as its package specific
  build directory.

.. _build-verb_install-base_arg:

\\--install-base INSTALL_BASE
  The base path for all install prefixes.
  The default value is ``./install``.

.. _build-verb_merge-install_arg:

\\--merge-install
  Use the ``--install-base`` as the install prefix for all packages instead of
  a package specific subdirectory in the install base.

  Without this option each package will contribute its own paths to environment
  variables which leads to very long environment variable values.
  
  With this option most of the paths added to environment variables will be the
  same, resulting in shorter environment variable
  values.

  The disadvantage of using this option is that it doesn't provide proper
  isolation between packages.
  For example declaring a dependency on one package also allows access to
  resources from other packages installed in the same install prefix (without
  requiring a declared dependency).

  Note: on Windows using ``cmd`` this argument should be used for workspaces
  with many packages otherwise the environment variables might exceed the
  supported maximum length.

.. _build-verb_symlink-install_arg:

\\--symlink-install
  Use symlinks instead of copying files from the source and build directories
  where possible.

.. _build-verb_test-result-base_arg:

\\--test-result-base TEST_RESULT_BASE
  The base path for all test results.
  The default value is the ``--build-base`` argument.
  Each package uses a subdirectory in that base path as its package specific
  test result directory.

.. _build-verb_continue-on-error_arg:

\\--continue-on-error
   Continue building other packages when a package fails to build.
   Packages recursively depending on the failed package are skipped.

CMake specific arguments
~~~~~~~~~~~~~~~~~~~~~~~~

The following arguments are provided by the ``colcon-cmake`` package:

.. _build-verb_cmake-args_arg:

\\--cmake-args [* [* ...]]
  Pass arbitrary arguments to CMake projects.
  Arguments matching other options must be prefixed by a space, e.g.
  ``--cmake-args " --help"``.

.. _build-verb_cmake-target_arg:

\\--cmake-target CMAKE_TARGET
  Build a specific target instead of the default target.
  To avoid packages which don't have that target causing the build to fail, also pass
  :ref:`--cmake-target-skip-unavailable
  <build-verb_cmake-target-skip-unavailable_arg>`.

.. _build-verb_cmake-target-skip-unavailable_arg:

\\--cmake-target-skip-unavailable
  Skip building packages which don't have the target passed to
  :ref:`--cmake-target <build-verb_cmake-target_arg>`.

.. _build-verb_cmake-clean-cache_arg:

\\--cmake-clean-cache
  Remove the CMake cache file ``CMakeCache.txt`` from the build directory
  before proceeding with the build.
  This implicitly forces a CMake configure step.

.. _build-verb_cmake-clean-first_arg:

\\--cmake-clean-first
  Build the target ``clean`` first, then proceed with a regular build.
  To only invoke the clean target use
  :ref:`--cmake-target clean <build-verb_cmake-target_arg>`.

.. _build-verb_cmake-force-configure_arg:

\\--cmake-force-configure
  Force CMake configure step.

ROS ``ament_cmake`` specific arguments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following arguments are provided by the ``colcon-ros`` package:

.. _build-verb_ament-cmake-args_arg:

\\--ament-cmake-args [* [* ...]]
  Pass arbitrary arguments to ROS packages with the build type ``ament_cmake``.
  Arguments matching other options must be prefixed by a space, e.g.
  ``--ament-cmake-args " --help"``.

ROS ``catkin`` specific arguments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following arguments are provided by the ``colcon-ros`` package:

.. _build-verb_catkin-cmake-args_arg:

\\--catkin-cmake-args [* [* ...]]
  Pass arbitrary arguments to ROS packages with the build type ``catkin``.
  Arguments matching other options must be prefixed by a space, e.g.
  ``--catkin-cmake-args " --help"``.

.. _build-verb_catkin-skip-building-tests_arg:

\\--catkin-skip-building-tests
  By default the ``tests`` target building the tests in ``catkin`` packages is
  invoked.
  If running ``colcon test`` later isn't intended this can be skipped.
