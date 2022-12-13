``test-result`` - Summarize Test Results
========================================

The ``test-result`` verb summarizes the results of previous run tests.
It is provided by the ``colcon-test-result`` package.

Command line arguments
----------------------

These common arguments can be used:

* :doc:`mixin <../mixin-arguments>` arguments

Additionally, the following specific command line arguments can be used:

.. _test-result-verb_test-result-base_arg:

\\--test-result-base TEST_RESULT_BASE
  The base path for all test results.
  The default value is ``./build``.
  Each package uses a subdirectory in that base path as its package specific
  test result directory.

.. _test-result-verb_all_arg:

\\--all
  Show all test result files including the ones without errors / failures.

.. _test-result-verb_verbose_arg:

\\--verbose
  Show additional information for each error / failure.

.. _test-result-verb_result-files-only_arg:

\\--result-files-only
  Print only the paths of the result files.
  Use with ``--all`` to include files without errors / failures.

.. _test-result-verb_delete_arg:

\\--delete
  Delete all result files.
  This might include additional files beside what is listed by
  ``--result-files-only``.
  An interactive prompt will ask for confirmation.

.. _test-result-verb_delete-yes_arg:

\\--delete-yes
  Same as ``--delete`` without an interactive confirmation.
