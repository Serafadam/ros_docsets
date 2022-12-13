ament_tools
===========

The following describes the mapping of some ``ament_tools`` options and arguments to the ``colcon`` command line interface.

ament build | test
------------------

``[BASEPATH]``
  ``--base-paths BASEPATH``

``--build-space PATH``
  ``--build-base PATH``

``--install-space PATH``
  ``--install-base PATH``

``--build-tests``
  CMake configures tests by default.
  To skip configuring tests use ``--cmake-args -DBUILD_TESTING=OFF``.

``-s``, ``--symlink-install``
  ``--symlink-install``

``--isolated``
  The colcon option ``--merge-install`` has the inverse logic.

``--start-with PKGNAME``
  ``--packages-start PKGNAME``

``--end-with PKGNAME``
  ``--packages-end PKGNAME``

``--only-packages PKGNAME1 ... PKGNAMEn``
  ``--packages-select PKGNAME1 ... PKGNAMEn``

``--skip-packages PKGNAME1 ... PKGNAMEn``
  ``--packages-skip PKGNAME1 ... PKGNAMEn``

``--parallel``
  colcon uses the parallel execution by default.
  To build packages sequentially use ``--executor sequential``.

ament build
-----------

``colcon build ...``

``--cmake-args -D... --``
  ``--cmake-args -D...``
  The closing double dash is not necessary anymore.
  Any CMake arguments which match colcon arguments need to be prefixed with a space.
  This can be done by quoting each argument with a leading space.

``--force-cmake-configure``
  ``--cmake-force-configure``

``--make-flags``
  When using this option to pass a target name the substitution is: ``--cmake-target TARGET``.
  When using this option to control the parallel execution with arguments like ``-jN`` the substitution is to use the environment variable ``MAKEFLAGS``.

``--use-ninja``
  ``--cmake-args -G Ninja``

ament test
----------

``colcon test ...``

``--ctest-args ... --``
  ``--ctest-args ...``
  Any CTest arguments which start with a dash need to be prefixed with a space (see ``--cmake-args``).

``--retest-until-fail N``
  ``--retest-until-fail N``

``--retest-until-pass N``
  ``--retest-until-pass N``

``--abort-on-test-error``
  ``--abort-on-error``

ament test_results
------------------

``colcon test-result ...``

``[BASEPATH]``
  ``--build-base BASEPATH``

``--verbose``
  ``--all``

Behavioral changes
------------------

The colcon ``test`` verb performs only the action of running tests.
It does not build any packages.

``--retest-until-fail`` with ``colcon`` uses `pytest-repeat <https://github.com/pytest-dev/pytest-repeat>`_ which runs individual tests of a package N+1 times each (the first test N+1 times, then the second test N+1 times, etc).
With ``ament_tools`` the entire test suite of a package was run up to N+1 times.
As a consequence ``colcon`` provides a more accurate result since each test that passed has actually run N times.
Note that with ``pytest-repeat``, ``pytest`` tests are repeated N times regardless of the result of the previous runs; if a test fails it will be repeated N times anyway.
This is different from the behavior of a `CTest <https://cmake.org/cmake/help/v3.5/manual/ctest.1.html>`_ test that will stop being repeated as soon as it fails once.

The location of JUnit test results file for ``ament_python`` packages tested with ``colcon`` is in ``<pkg-build>/pytest.xml``, whereas with ``ament_tools`` it is in ``<pkg-build>/test_results/<pkgname>/pytest.xunit.xml``.
