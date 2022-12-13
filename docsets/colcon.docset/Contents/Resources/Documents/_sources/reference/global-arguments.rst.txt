Global arguments
================

Command line arguments
----------------------

The following command line arguments can be used *before* every verb.
For each argument the name in brackets indicates which package contributes it.

.. _colcon_log-base_arg:

\\--log-base LOG_BASE [``colcon-core``]
  The base path for all log directories.
  The default value is ``./log``.
  To completely disable logging, pass ``/dev/null`` (on POSIX) / ``nul`` (on
  Windows).

  Within the base path all log files from a specific invocation are places in a
  subdirectory named ``<verb>_<timestamp>`` (in the following named
  ``log-dir``).
  If the system supports creating symlinks, shortcuts with the names
  ``latest_<verb>`` and ``latest`` are created (overwriting previous symlinks).

  Within the ``log-dir`` the following files are generated:

  * ``events.log`` [``colcon-output``]: All generated events - only used for
    debugging.
  * ``logger_all.log`` [``colcon-core``]: All log messages, independent of the
    chosen log level for the console output.
  * For each processed package a subdirectory with the following files is
    generated:

    * ``command.log`` [``colcon-output``]: All invoked external commands
      including their return code.
    * ``stderr.log`` [``colcon-output``]: All output from external commands to
      ``stdout``.
    * ``stdout.log`` [``colcon-output``]: All output from external commands to
      ``stderr``.
    * ``stdout_stderr.log`` [``colcon-output``]: A combination of
      ``stdout.log`` and ``stderr.log`` in the order the two streams were
      processed.
      Since both streams are read concurrently the order is not fully
      deterministic.
    * ``streams.log`` [``colcon-output``]: A combination of the command log as
      well as both output logs.
      Each line is being prefixed with the elapsed time since the package
      started being processed.

.. _colcon_log-level_arg:

\\--log-level LOG_LEVEL [``colcon-core``]
  Set the log level for the console output.
  The log file ``<log-dir>/logger_all.log`` always contains messages of all
  levels.
  The value can either be a numeric value or a string as defined in the `Python
  logging module
  <https://docs.python.org/3/library/logging.html#logging-levels>`_ (the names
  are case insensitive).
  The default value is ``warning``.

Environment variables
---------------------

The following environment variables are supported.
The name in brackets indicates which package contributes it.

.. _colcon-cmake_cmake-command_env:

CMAKE_COMMAND [``colcon-cmake``]
  The full path to the CMake executable.
  By default the executable ``cmake`` is being searched for on the ``PATH``.

.. _colcon-core_colcon-all-shells_env:

COLCON_ALL_SHELLS [``colcon-core``]
  Flag to enable all shell extensions.
  If the environment variable is set and not empty all shell extensions are
  being used even if they are supposed to be skipped based on the current
  platform.

.. _colcon-graphviz-anim_colcon-animation-progress_env:

COLCON_ANIMATION_PROGRESS [``colcon-graphviz-anim``]
  Flag to generate an animation of the task progress.
  If the environment variable is set and not empty the file
  ``./graphviz_anim_build.gif`` is generated.

.. _colcon-argcomplete_colcon-completion-logfile_env:

COLCON_COMPLETION_LOGFILE [``colcon-argcomplete``]
  Set the path of a logfile to append the completion time to.
  If the environment variable is set and not empty a line is appended to
  the specified file.
  The line contains the duration it took to compute the completion choices as
  well as the value of the environment variable ``COMP_LINE`` which was passed
  to determine the completion choices.

.. _colcon-defaults_colcon-defaults-file_env:

COLCON_DEFAULTS_FILE [``colcon-defaults``]
  Set the path to the yaml file containing the default values.
  By default the path :ref:`$COLCON_HOME <colcon-core_colcon-home_env>`\ ``/defaults.yaml`` is being used.

.. _colcon-core_colcon-default-executor_env:

COLCON_DEFAULT_EXECUTOR [``colcon-core``]
  Select the default executor extension for verbs which support it.
  By default the executor with the highest priority is used.
  The executor can also be chosen using the ``--executor`` argument.

.. _colcon-core_colcon-extension-blocklist_env:

COLCON_EXTENSION_BLOCKLIST [``colcon-core``]
  Block extensions which should not be used.
  The value uses a path separator to enumerate entry point group names or full
  entry point names.

.. _colcon-core_colcon-home_env:

COLCON_HOME [``colcon-core``]
  Set the base path of configuration files.
  By default the path ``~/.colcon`` is being used.

.. _colcon-core_colcon-log-level_env:

COLCON_LOG_LEVEL [``colcon-core``]
  Set the log level for the console output.
  See the :ref:`--log-level <colcon_log-level_arg>` arguments for details
  about the possible values.
  Using the environment variable instead of the command line argument allows
  setting the log level *before* the argument parsing has been performed.

.. _colcon-core_colcon-warnings_env:

COLCON_WARNINGS [``colcon-core``]
  Set the warnings filter similar to `PYTHONWARNINGS
  <https://docs.python.org/3/library/warnings.html#warning-filter>`_ except
  that the module entry is implicitly set to ``colcon.*``

.. _colcon-cmake_ctest-command_env:

CTEST_COMMAND [``colcon-cmake``]
  The full path to the CTest executable.
  By default the executable ``ctest`` is searched for on the ``PATH``.

.. _colcon-powershell_powershell-command_env:

POWERSHELL_COMMAND [``colcon-powershell``]
  The full path to the PowerShell executable.
  By default the executable ``PowerShell`` (on Windows) / ``pwsh`` (on
  non-Windows) is searched for on the ``PATH``.
