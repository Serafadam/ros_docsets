Executor arguments
==================

The executor is responsible for processing jobs in verbs which have more than
one item of work.
For each argument the name in brackets indicates which package contributes it.

.. _executor-args_executor_arg:

\\--executor EXECUTOR [``colcon-core``]
  The executor to process all jobs.
  The default is chosen based on the priorities of all available executor
  extensions.
  To see a complete list invoke
  ``colcon extensions colcon_core.executor --verbose``.

  .. _executor-args_executor_arg_sequential:

  * ``sequential`` [``colcon-core``]

    Process one package at a time.

  .. _executor-args_executor_arg_parallel:

  * ``parallel`` [``colcon-parallel-executor``]

    Process multiple jobs in parallel.

.. _executor-args_parallel-workers_arg:

\\--parallel-workers NUMBER [``colcon-parallel-executor``]
  The maximum number of jobs to process in parallel.
  The default value is the number of logical CPU cores as reported by
  `os.cpu_count() <https://docs.python.org/3/library/os.html#os.cpu_count>`_.
  This option only affects ``--executor parallel``.
