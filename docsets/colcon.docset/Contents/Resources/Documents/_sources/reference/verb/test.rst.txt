``test`` - Test Packages
========================

The ``test`` verb runs the tests for a set of packages.
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

.. _test-verb_build-base_arg:

\\--build-base BUILD_BASE
  The base path for all build directories.
  The default value is ``./build``.
  Each package uses a subdirectory in that base path as its package specific
  build directory.

.. _test-verb_install-base_arg:

\\--install-base INSTALL_BASE
  The base path for all install prefixes.
  The default value is ``./install``.

.. _test-verb_merge-install_arg:

\\--merge-install
  Use the ``--install-base`` as the install prefix for all packages instead of
  a package specific subdirectory in the install base.
  See :ref:`here <build-verb_merge-install_arg>` for more information.

.. _test-verb_test-result-base_arg:

\\--test-result-base TEST_RESULT_BASE
  The base path for all test results.
  The default value is the ``--build-base`` argument.
  Each package uses a subdirectory in that base path as its package specific
  test result directory.

.. _test-verb_retest-until-fail_arg:

\\--retest-until-fail N
  Rerun tests up to N times if they pass.

.. _test-verb_retest-until-pass_arg:

\\--retest-until-pass N
  Rerun failing tests up to N times.

.. _test-verb_abort-on-error_arg:

\\--abort-on-error
  Abort after the first package with any errors.
  Failing tests are not considered errors in this context.

.. _test-verb_return-code-on-test-failure_arg:

\\--return-code-on-test-failure
  Use a non-zero return code to indicate any test failure.

CMake specific arguments
~~~~~~~~~~~~~~~~~~~~~~~~

.. _test-verb_ctest-args_arg:

\\--ctest-args [* [* ...]] [``colcon-cmake``]
  Pass arbitrary arguments to CTest projects.
  Arguments matching other options must be prefixed by a space, e.g.
  ``--ctest-args " --help"``.

Python specific arguments
~~~~~~~~~~~~~~~~~~~~~~~~~

.. _test-verb_python-testing_arg:

\\--python-testing {pytest,setuppy_test}
  Choose the Python testing framework to use.
  The default value is determined based on the packages ``tests_require``
  option.

  * ``pytest``: Use `pytest <https://docs.pytest.org/>`_ to test Python
    packages.
  * ``setuppy_test``: Use ``setup.py test`` to test Python packages.

.. _test-verb_pytest-args_arg:

\\--pytest-args [* [* ...]]
  Pass arbitrary arguments to Python packages using ``pytest``.
  Arguments matching other options must be prefixed by a space, e.g.
  ``--pytest-args " --help"``.

.. _test-verb_pytest-with-coverage_arg:

\\--pytest-with-coverage
  Generate coverage information in the package specific build directory.
  By default, coverage information is only generated for Python packages that
  declare a test dependency on ``pytest-cov``.
