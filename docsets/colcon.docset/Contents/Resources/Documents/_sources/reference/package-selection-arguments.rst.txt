Package selection arguments
===========================

Package selection arguments determine the set of packages which should be
processed by a given verb.
If multiple arguments are passed the resulting set is a logical ``AND``
combination.
For each argument the name in brackets indicates which package contributes it.

.. _package-selection-args_build-base_arg:

\\--build-base BUILD_BASE
  The base path for all build directories.
  The default value is ``./build``.
  Each package uses a subdirectory in that base path as its package specific
  build directory.

  For some verbs this argument only exists since some of the package selection
  arguments use state information from previous builds to select / skip
  packages.

.. _package-selection-args_packages-up-to_arg:

\\--packages-up-to [PKG_NAME [PKG_NAME ...]]
  Select the packages with the passed names as well as their recursive
  dependencies.

.. _package-selection-args_packages-up-to-regex_arg:

\\--packages-up-to-regex [PATTERN [PATTERN ...]]
  Select the packages that match any of the passed patterns as well as their
  recursive dependencies.

.. _package-selection-args_packages-above_arg:

\\--packages-above [PKG_NAME [PKG_NAME ...]]
  Select the packages with the passed names as well as packages which
  recursively depend on them.

.. _package-selection-args_packages-above-and-dependencies_arg:

\\--packages-above-and-dependencies [PKG_NAME [PKG_NAME ...]]
  Select the packages with the passed names, packages which
  recursively depend on them as well as their recursive dependencies.

.. _package-selection-args_packages-above-depth_arg:

\\--packages-above-depth DEPTH [PKG_NAME ...]
  Select the packages with the passed names as well as packages which
  recursively depend on them up to the given depth.

.. _package-selection-args_packages-by-dep_arg:

\\--packages-select-by-dep [DEP_NAME [DEP_NAME ...]]
  Select packages which (recursively) depend on the given packages.

.. _package-selection-args_packages-skip-by-dep_arg:

\\--packages-skip-by-dep [DEP_NAME [DEP_NAME ...]]
  Skip packages which (recursively) depend on the given packages.

.. _package-selection-args_packages-skip-up-to_arg:

\\--packages-skip-up-to [PKG_NAME [PKG_NAME ...]]
  Skip the packages with the passed names as well as their recursive
  dependencies.

.. _package-selection-args_packages-select-build-failed_arg:

\\--packages-select-build-failed
  Select packages which have failed to build previously.
  Packages which have been aborted previously are not included.

.. _package-selection-args_packages-skip-build-finished_arg:

\\--packages-skip-build-finished
  Skip packages which have finished to build previously.

.. _package-selection-args_packages-select-test-failures_arg:

\\--packages-select-test-failures
  Select packages which had test failures previously.

.. _package-selection-args_packages-skip-test-passed_arg:

\\--packages-skip-test-passed
  Skip packages which had no test failures previously.

.. _package-selection-args_packages-select_arg:

\\--packages-select [PKG_NAME [PKG_NAME ...]]
  Select the packages with the passed names.

.. _package-selection-args_packages-skip_arg:

\\--packages-skip [PKG_NAME [PKG_NAME ...]]
  Skip the packages with the passed names.

.. _package-selection-args_packages-select-regex_arg:

\\--packages-select-regex [PATTERN [PATTERN ...]]
  Select the packages where any of the patterns match the package name.

.. _package-selection-args_packages-skip-regex_arg:

\\--packages-skip-regex [PATTERN [PATTERN ...]]
  Skip the packages where any of the patterns match the package name.

.. _package-selection-args_packages-start_arg:

\\--packages-start PKG_NAME
  Skip packages before the given package name in flat topological ordering.
  This option only makes sense when using the
  :ref:`sequential executor <executor-args_executor_arg_sequential>`.

.. _package-selection-args_packages-end_arg:

\\--packages-end PKG_NAME
  Skip packages after the given package name in flat topological ordering.
  This option only makes sense when using the
  :ref:`sequential executor <executor-args_executor_arg_sequential>`.
