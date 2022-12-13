Log Files
=========

You may notice with ``colcon-common-extensions`` installed there's not much output to the console when you run ``colcon build`` or ``colcon test``.
The log output isn't lost; it was written to the ``log`` directory.

.. note::

    The ``--event-handlers`` argument can be used to output build logs to the console.
    For example, ``colcon build --event-handlers console_direct+`` or ``colcon test --event-handlers console_direct+`` will output everything in real time.

Let's look at the ``log`` directory from :doc:`what-is-a-workspace`.

::

  log
  ├── build_2022-05-20_11-50-03
  │ ├── events.log
  │ ├── foo
  │ │ ├── command.log
  │ │ ├── stderr.log
  │ │ ├── stdout.log
  │ │ ├── stdout_stderr.log
  │ │ └── streams.log
  │ └── logger_all.log
  ├── COLCON_IGNORE
  ├── latest -> latest_build
  ├── latest_build -> build_2022-05-20_11-50-03
  ├── latest_test -> test_2022-05-20_11-50-05
  └── test_2022-05-20_11-50-05
      ├── events.log
      ├── foo
      │ ├── command.log
      │ ├── stderr.log
      │ ├── stdout.log
      │ ├── stdout_stderr.log
      │ └── streams.log
      └── logger_all.log


The directory ``build_<date and time>`` contains all logs from the invocation of ``colcon build``.
``test_<date and time>`` contains all the logs from the invocation of ``colcon test``.
On platforms that support symbolic links, ``latest_build`` points to the most recent build, and ``latest_test`` does the same for tests.

More generally, any verb that generates logs (e.g. ``build``, ``test``, ``test-result``) will put them into a subdirectory named ``<verb>_<date and time>``.
``latest_<verb>`` will point to the logs of the most recent invocation of that verb.
The symbolic link ``latest`` will point to the most recent logs for any colcon verb.

Each ``<verb>_<date and time>`` directory has these files:

* ``events.log`` contains all internal events dispatched.
  This file is mostly for debugging purposes.
* ``logger_all.log`` contains all logging messages regardless of the log level.
  The first line of this file contains the exact command line invocation including all the arguments passed.

Notice each ``<verb>_<date and time>`` directory has a ``foo`` directory.
More generally, a directory for every package is created.
Package log directories have these files:

* ``command.log`` contains the commands invoked for the package, e.g. calls to ``python setup.py``.
* ``stdout.log`` contains all the output printed to ``stdout``.
* ``stderr.log`` contains all the output printed to ``stderr``.
* ``stdout_stderr.log`` contains all the output printed to either ``stdout`` or ``stderr`` in the order they appeared.
* ``streams.log`` combines the output of all log files in the order they appeared.

.. note::

    ``colcon`` does its best to read concurrently from ``stdout`` and ``stderr`` to preserve the order, but it can't guarantee correct order of log messages in all cases.
