Event handler arguments
=======================

The event handlers are used by several verbs to generate any kind of output
based on the progress of the invocation.
For each argument the name in brackets indicates which package contributes it.

\\--event-handlers [name1+ [name2- ...]] [``colcon-core``]
  A list of event handlers to enable (trailing ``+``) or disable (trailing
  ``-``).
  The default is chosen by each available event handler (see
  ``colcon <verb> --help``).

  * ``console_cohesion`` [``colcon-output``]:

    Pass job output at once to ``stdout`` after it has finished.

  * ``console_direct`` [``colcon-core``]:

    Pass output directly to ``stdout`` / ``stderr``.
    When processing multiple jobs in parallel the output will likely
    interleave.

  * ``console_package_list`` [``colcon-output``]:

    Output a list of queued job names.

  * ``console_start_end`` [``colcon-core``]:

    Output each job name when starting / ending.

  * ``console_stderr`` [``colcon-output``]:

    Output all ``stderr`` of a job at once after it has finished.

  * ``desktop_notification`` [``colcon-notification``]:

    Enable desktop notification of the summary indicating the result of the
    invocation.

  * ``event_log`` [``colcon-output``]:

    Log all events to a global log file ``events.log``.
    See :ref:`here <colcon_log-base_arg>` for more information about the
    location of that log file.

  * ``graphviz_anim`` [``colcon-graphviz-anim``]:

    Generate a ``.gif`` file of the job progress after the invocation has
    finished.
    See :ref:`here <colcon-graphviz-anim_colcon-animation-progress_env>` for
    more details.

  * ``log`` [``colcon-output``]:

    Output job specific log files containing all the output of invoked
    commands.
    See :ref:`here <colcon_log-base_arg>` for more information about the
    location of these log files.

  * ``log_command`` [``colcon-colcon``]:

    Log a debug message for each invoked command.
    Either :ref:`set a custom log level <colcon_log-level_arg>` to show
    debug messages or check the generated log files.

  * ``status`` [``colcon-notification``]:

    Show a status line at the current cursor in the terminal title and update
    it continuously.

  * ``store_result`` [``colcon-package-select``]:

    Persist the result of a job in a file in its build directory which allows
    the information to be used in subsequent invocation to select packages
    based on the previous result.

  * ``summary`` [``colcon-output``]:

    Output a single line summarizing the result of all jobs after the
    invocation has finished.

  * ``terminal_title`` [``colcon-notification``]:

    Show the ongoing status in the terminal title.
