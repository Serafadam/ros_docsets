What is a Workspace?
====================

Colcon is a command line tool to build and test multiple software packages.
It builds and tests those packages in a **colcon workspace**, but what is a workspace?

This page assumes you have ``colcon-common-extensions`` installed.

What's in a workspace?
----------------------

A workspace has these parts:

* Software packages
* Build artifacts
* Logs
* Install artifacts

All these parts are put into different subdirectories of single directory, called the **workspace root**.
Lets create a single directory for our workspace.

.. code-block:: bash

    mkdir ws

Go into the root of our new workspace.

.. code-block:: bash

    cd ws


Software packages
*****************

A workspace needs the source code of all the software to be built.
Colcon will search all subdirectories of the workspace to look for packages, but an established convention is to put all the packages into a directory called ``src``.
Let's create a directory for source code.

.. code-block:: bash

    mkdir src

We'll need at least one software package in the workspace.
Let's create a Python package.

.. code-block:: bash

    mkdir src/foo
    touch src/foo/setup.cfg
    touch src/foo/setup.py
    touch src/foo/foo.py


Put this content into ``src/foo/setup.py``:

.. code-block:: python

    from setuptools import setup

    setup()

Put this content into ``src/foo/setup.cfg``:

.. code-block:: ini

    [metadata]
    name = foo
    version = 0.1.0

    [options]
    py_modules =
      foo
    zip_safe = true

    [options.extras_require]
    test =
      pytest

    [tool:pytest]
    junit_suite_name = foo

Put this content into ``src/foo/foo.py``:

.. code-block:: python

    def foo_func():
        print('Hello from foo.py')
        return True


Build artifacts
***************

The software build process often produces intermediate build artifacts.
They are usually not used directly, but keeping them around makes subsequent builds faster.
Colcon always directs packages to build out-of-source, meaning the build artifacts are put into a directory separate from the source code.
Every package gets its own build directory, but all build directories are put into a single base directory.
By default it's named  ``build`` at the root of the workspace.

.. note::

    You can change where build artifacts are put using the ``--build-base`` option to ``colcon build``.

Lets build the software and see its build artifacts.

.. code-block:: bash

    # Make sure you run this command from the root of the workspace!
    colcon build

You'll see these new directories: ``build``, ``install``, and ``log``.

::

    ws
    ├── build
    │    ├── COLCON_IGNORE
    │    └── foo/...
    ├── install/...
    ├── log/...
    └── src
        └── foo
            ├── foo.py
            ├── setup.cfg
            └── setup.py

Notice the ``build`` directory has a subdirectory ``foo`` and a file ``COLCON_IGNORE``.
The ``foo`` subdirectory has all the build artifacts produced when building ``foo``.
The ``COLCON_IGNORE`` file tells colcon there are no software packages in this directory.

Logs
****

If you've built software before you know there can be a lot of console output, but you might have noticed not much was output when you ran ``colcon build``.
This output was instead written to the ``log`` directory.

.. note::

    You can change where logs are written to using the ``--log-base`` option to ``colcon``.

Let's look at the ``log`` directory:

::

    log
    ├── build_2022-05-20_11-50-03
    │    ├── events.log
    │    ├── foo
    │    │    ├── command.log
    │    │    ├── stderr.log
    │    │    ├── stdout.log
    │    │    ├── stdout_stderr.log
    │    │    └── streams.log
    │    └── logger_all.log
    ├── COLCON_IGNORE
    ├── latest -> latest_build
    └── latest_build -> build_2022-05-20_11-50-03


The directory ``log/build_<date and time>`` contains all logs from the invocation of ``colcon build``.
A new directory is created every time ``colcon build`` is run.
The  ``foo`` sub directory contains all logs from building ``foo``.
There's a more complete description of log files at this page: :doc:`log-files`.

We've only built ``foo``, so there are only build logs.
Let's add tests to ``foo`` and see the output.

Make a new file for the test.

.. code-block:: bash

    touch src/foo/test_foo.py

Put the following content into ``test_foo.py``:

.. code-block:: python

    import foo

    def test_foo():
        assert foo.foo_func()


Tell ``colcon`` to run the tests.

.. code-block:: bash

    # Make sure you run this command from the root of the workspace!
    colcon test

Lets look in the ``log`` directory again.

::

    log
    ├── build_2022-05-20_11-50-03/...
    ├── COLCON_IGNORE
    ├── latest -> latest_test
    ├── latest_build -> build_2022-05-20_11-50-03
    ├── latest_test -> test_2022-05-20_11-50-05
    └── test_2022-05-20_11-50-05
        ├── events.log
        ├── foo
        │    ├── command.log
        │    ├── stderr.log
        │    ├── stdout.log
        │    ├── stdout_stderr.log
        │    └── streams.log
        └── logger_all.log


There's a new directory ``test_<date and time>``.
Let's look at ``stdout_stderr.log``  to see the output of the latest test.

.. code-block:: bash

    cat log/latest_test/foo/stdout_stderr.log

.. note::

    Use the command ``colcon test-result`` to see a summary of test results on the console after tests have been run.



Install artifacts
*****************

The last directory to talk about is the ``install`` directory.
It contains both the installed software, and shell scripts that enable you to use it.
This is sometimes called the **install space**.

.. note::

    You can change where packages are installed to with the ``--install-base`` option to ``colcon build``.

Let's look inside.

::

    install
    ├── COLCON_IGNORE
    ├── foo/...
    ├── local_setup.[bash|bat|ps1|sh|zsh|...]
    ├── _local_setup_util_[sh|ps1|...].py
    └── setup.[bash|bat|ps1|sh|zsh|...]

The package ``foo`` was installed into the directory ``install/foo``.
By default colcon builds an **isolated workspace** (for more info see :doc:`isolated-vs-merged-workspaces`).

The shell scripts set environment variables that allow you to use the the software.
Invoking the shell scripts is called **sourcing a workspace**.

.. note::

    Always source a workspace from a different terminal than the one you used ``colcon build``.
    Failure to do so can prevent colcon from detecting incorrect dependencies.

Source the workspace using the appropriate script for your shell.

``sh`` compatible shells:

.. code-block:: sh

    # Note the . at the front; that's important!
    . install/setup.sh

``bash``:

.. code-block:: bash

    source install/setup.bash

Windows ``cmd.exe``:

.. code-block:: bat

    call install/setup.bat

Now you can use ``foo``.
Open a ``python`` interactive console and try it out.

.. code-block:: python

    >>> import foo
    >>> foo.foo_func()
    Hello from foo.py
    True

Sourcing a workspace also allows you to build more software that depends on the packages in it.
For more info about using colcon to build software that depends on packages in another workspace, see :doc:`using-multiple-workspaces`.
