colcon - collective construction
================================

`colcon`_ is a command line tool to improve the workflow of building, testing and using multiple software packages.
It automates the process, handles the ordering and sets up the environment to use the packages.

.. _colcon: http://colcon.readthedocs.io

The code is open source, and `available on GitHub`_.

.. _available on GitHub: http://github.com/colcon

The documentation exists in two version:

* `released <http://colcon.readthedocs.io/en/released/>`_: matching the latest released version of all packages
* `latest <http://colcon.readthedocs.io/en/main/>`_: matching the latest state on the default branch of all packages

The documentation is organized into a few sections:

* :ref:`user-docs`
* :ref:`migration-docs`

Information about development is also available:

* :ref:`developer-docs`

.. _user-docs:

.. toctree::
   :maxdepth: 2
   :caption: User Documentation

   user/installation
   user/quick-start
   user/configuration
   user/how-to
   user/what-is-a-workspace
   user/log-files
   user/isolated-vs-merged-workspaces
   user/using-multiple-workspaces
   user/overriding-packages

.. _reference-docs:

.. toctree::
   :maxdepth: 2
   :caption: Reference

   reference/verb/build
   reference/verb/edit
   reference/verb/graph
   reference/verb/info
   reference/verb/list
   reference/verb/metadata
   reference/verb/mixin
   reference/verb/test
   reference/verb/test-result
   reference/global-arguments
   reference/executor-arguments
   reference/event-handler-arguments
   reference/discovery-arguments
   reference/package-selection-arguments
   reference/mixin-arguments

.. _developer-docs:

.. toctree::
   :maxdepth: 2
   :caption: Developer Documentation

   developer/design
   developer/bootstrap
   developer/environment
   developer/program-flow
   developer/extension-point
   developer/contribution
   developer/release
   developer/changelog

.. _migration-docs:

.. toctree::
   :maxdepth: 2
   :caption: Migrate from other build tools

   migration/ament_tools
   migration/catkin_make_isolated
   migration/catkin_tools
