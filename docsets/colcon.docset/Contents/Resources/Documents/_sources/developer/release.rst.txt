Make Releases
=============

If you are developing a Python package containing colcon extensions you might want to make a release of it.
Commonly that involves bumping the version number and tagging the commit with that version.

Commonly Python packages are released to PyPI following the `packaging instructions for Python projects <https://packaging.python.org/tutorials/packaging-projects/>`_.
For colcon packages the recommendation is to use `publish-python <https://github.com/dirk-thomas/publish-python>`_ which not only uploads a wheel to PyPI but also creates and uploads Debian packages.

First-time setup
----------------

Before using ``publish-python`` you need to do the following:

* Install the prerequisites of ``publish-python``
* Configure credentials for twine / PyPI
* Configure credentials for packagecloud.io and request to be added as a contributor to the `colcon repository <https://packagecloud.io/dirk-thomas/colcon>`_
* Create a configuration file for your package

For details please see the `publish-python documentation <https://github.com/dirk-thomas/publish-python/blob/main/README.rst>`_.

Example configuration file ``publish-python.yaml``:

.. code-block:: yaml

    artifacts:
      - type: wheel
        uploads:
          - type: pypi
      - type: stdeb
        uploads:
          - type: packagecloud
            config:
              repository: dirk-thomas/colcon
              distributions:
                - ubuntu:xenial
                - ubuntu:bionic
                - ubuntu:focal
                - debian:stretch
                - debian:buster

The list of targeted distributions might need to be updated to match the configuration files mentioned in the following subsection.

Publishing a release
--------------------

After having tagged the repository you only need to invoke ``publish-python --upload`` to create the configured artifacts as well as upload them to the configured destinations.

In the case the Debian package is used by the ROS community you need to open a ticket in the GitHub repository `ros-infrastructure/reprepro-updater <https://github.com/ros-infrastructure/reprepro-updater/>`_.
The pull request should update the two files `colcon.ubuntu.upstream.yaml <https://github.com/ros-infrastructure/reprepro-updater/blob/master/config/colcon.ubuntu.upstream.yaml>`_ and `colcon.debian.upstream.yaml <https://github.com/ros-infrastructure/reprepro-updater/blob/master/config/colcon.debian.upstream.yaml>`_ file with a bumped version number for the package.
Someone from the ROS team will then review and merge the pull request and import the latest artifacts into the apt repositories of ROS.
