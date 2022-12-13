catkin_make_isolated
====================

The following describes the mapping of some ``catkin_make_isolated`` options and arguments to the ``colcon`` command line interface.

``--source PATH``
  ``--base-paths BASEPATH``

``--build PATH``
  ``--build-base PATH``

``--devel PATH``
  colcon doesn't support the concept of a "devel" space.
  Instead you can choose the path of the devel space as the install base and perform an normal installation.

``--install-space PATH``
  ``--install-base PATH``

``--merge``
  ``--merge-install``

``--use-ninja``
  ``--cmake-args -G Ninja``

``--use-nmake``
  ``--cmake-args -G "NMake Makefiles"``

``--install``
  colcon always performs an installation.
  It doesn't support the concept of a "devel" space.

``--cmake-args ...``
  ``--cmake-args ...``
  The closing double dash is not necessary anymore.
  Any CMake arguments which match colcon arguments need to be prefixed with a space.
  This can be done by quoting each argument with a leading space.

``--force-cmake``
  ``--cmake-force-configure``

``--pkg PKGNAME1 ... PKGNAMEn``
  ``--packages-select PKGNAME1 ... PKGNAMEn``

``--from-pkg PKGNAME``
  ``--packages-start PKGNAME``

``--only-pkg-with-deps PKGNAME1 ... PKGNAMEn``
  ``--packages-up-to PKGNAME1 ... PKGNAMEn``
