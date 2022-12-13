Bootstrap from source
=====================

When developing ``colcon`` you want to have a local checkout of all involved packages.

.. note::

    The following steps use the command line tool `vcstool <https://github.com/dirk-thomas/vcstool/>`_ to fetch a set of repositories.
    You can e.g. install it using ``pip install vcstool``.

.. note::

    While the following instructions use a Linux shell the same can be done on other platforms like Windows with slightly adjusted commands.

Virtual environment
-------------------

While not strictly necessary it is recommended to use a virtual environment for developing Python packages.

.. code-block:: bash

    $ mkdir colcon-venv
    $ python3 -m venv colcon-venv
    $ . colcon-venv/bin/activate

.. note::

    On Windows the Python 3 executable is likely named ``python`` and the activation script is invoked with ``colcon-venv\Scripts\activate``

You might want to make sure that the venv is using up-to-date versions of the some foundational packages.

.. code-block:: bash

    $ pip install -U pip setuptools

Fetch the sources
-----------------

.. code-block:: bash

    $ mkdir colcon-from-source && cd colcon-from-source
    $ curl --output colcon.repos https://raw.githubusercontent.com/colcon/colcon.readthedocs.org/main/colcon.repos
    $ mkdir src
    $ vcs import src < colcon.repos

.. note::

    Depending on your platform you might not want to use all cloned packages.
    On Windows you must ignore or remove ``colcon-argcomplete``, and may want to do the same for ``colcon-bash``.
    If you don't use PowerShell you might want to ignore / remove the package ``colcon-powershell``.
    To ignore a package add an empty file named COLCON_IGNORE to the folder.

Ignore ``colcon-argcomplete`` and ``colcon-bash`` on Windows.

.. code-block:: dosbatch

    > type nul > src\colcon-argcomplete\COLCON_IGNORE
    > type nul > src\colcon-bash\COLCON_IGNORE


Dependencies
------------

Make sure the dependencies are available:

.. code-block:: bash

    $ curl --output requirements.txt https://raw.githubusercontent.com/colcon/colcon.readthedocs.org/main/requirements.txt
    $ pip install -r requirements.txt


Build the sources - first time
------------------------------

In the first build we will use the minimal features provided by ``colcon-core`` to build the set of cloned packages.

.. code-block:: bash

    $ ./src/colcon-core/bin/colcon build --paths src/*

.. note::

    On Windows the command needs to be prefixed with ``python``.

The build of the packages will run sequentially and for each package the output will be printed directly to the console.
The install directory will contain a ``local_setup.sh`` (or ``.bat`` on Windows).

In order to generate scripts for additional shells the set of packages have to be built a second time but this time using all extension provided by the various cloned packages.

Build the sources - second time
-------------------------------

.. code-block:: bash

    $ . install/local_setup.sh
    $ colcon build

.. note::

    On Windows the setup file ends with ``.bat`` and is just being called.
    Also the ``colcon`` executable can't be invoked directly here since while it is being used it can't be overwritten by the build.
    Instead invoke the following command: ``python install\colcon-core\Scripts\colcon-script.py build``.

.. note::

    The second build will process packages in parallel as long as their dependencies are finished.
    Also the output of all packages is not shown on the console (until there are errors) but is being redirected to log files.
    Depending on the platform you might also notice a status line during the build, a continuously updated title of the shell windows, and a desktop notification at the end of the build.

To use the full functionality you can source the generated script for your shell:

.. code-block:: bash

    $ . install/local_setup.bash

.. note::

    With bash you should now also have completion for all arguments if you have the Python package `argcomplete <https://pypi.org/project/argcomplete/>`_ installed.
    Try typing ``colcon <tab>`` to see the completion of global options and verbs.
