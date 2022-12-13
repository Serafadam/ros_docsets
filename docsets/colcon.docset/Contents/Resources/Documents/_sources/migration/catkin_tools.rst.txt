catkin_tools
============

The following describes the mapping of some ``catkin_tools`` options and arguments to the ``colcon`` command line interface.

catkin build
------------

``[PKGNAME1 ... PKGNAMEn]``
  ``--packages-up-to PKGNAME1 ... PKGNAMEn``

``--no-deps``
  ``--packages-select PKGNAME1 ... PKGNAMEn``

``--start-with PKGNAME``
  ``--packages-start PKGNAME``

``--force-cmake``
  ``--cmake-force-configure``

``--cmake-args ... --``
  ``--cmake-args ...``
  The closing double dash is not necessary anymore.
  Any CMake arguments which match colcon arguments need to be prefixed with a space.
  This can be done by quoting each argument with a leading space.

``-v``, ``--verbose``
  ``--event-handlers console_cohesion+``

``-i``, ``--interleave-output``
  ``--event-handlers console_direct+``

``--no-status``
  ``--event-handlers status-``

``--no-summarize``, ``--no-summary``
  ``--event-handlers summary-``

``--no-notify``
  ``--event-handlers desktop_notification-``
