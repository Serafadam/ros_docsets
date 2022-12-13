Discovery arguments
===================

Discovery arguments determine which locations should be checked if they contain
packages.
For each argument the name in brackets indicates which package contributes it.

.. _discovery-args_paths_arg:

\\--paths [PATH [PATH ...]] [``colcon-core``]
  The (non recursive) paths to check for a package.
  Use shell wildcards (e.g. ``src/*``) to select all direct subdirectories of
  ``src``.

.. _discovery-args_base-paths_arg:

\\--base-paths [PATH [PATH ...]] [``colcon-recursive-crawl``]
  The base paths to recursively crawl for packages.
  The default value is ``.``.
  In a workspace root the subdirectories other than ``src`` (commonly
  ``build``, ``install``, ``log``) contain a ``COLCON_IGNORE`` marker file
  which causes them to be ignored.

.. _discovery-args_metas_arg:

\\--metas [PATH [PATH ...]] [``colcon-metadata``]
  The directories containing a ``colcon.meta`` file or paths to arbitrary files
  containing the same meta information.
  The default value is ``./colcon.meta``.

.. _discovery-args_ignore-user-meta_arg:

\\--ignore-user-meta [``colcon-metadata``]
  Ignore ``*.meta`` files in the configuration directory
  :ref:`$COLCON_HOME <colcon-core_colcon-home_env>`\ ``/metadata/``.

.. _discovery-args_packages-ignore_arg:

\\--packages-ignore [PKG_NAME [PKG_NAME ...]] [``colcon-package-selection``]
  Ignore packages by name as if they were not discovered.
  In contrast to being skipped using
  :doc:`package selection <package-selection-arguments>` arguments, ignored
  packages aren't considered in the dependency graph.

.. _discovery-args_packages-ignore-regex_arg:

\\--packages-ignore-regex [PATTERN [PATTERN ...]] [``colcon-package-selection``]
  Ignore packages where any of the patterns match the package name.
  In contrast to being skipped using
  :doc:`package selection <package-selection-arguments>` arguments, ignored
  packages aren't considered in the dependency graph.
