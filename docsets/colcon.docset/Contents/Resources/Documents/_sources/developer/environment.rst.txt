Environment setup
=================

Using a package after it has been built or building a package on top of its dependencies might require updating environment variables.
For the former, the best option for the user is to have a script perform the environment update for ease of use.
In the latter case, automating the process is necessary to build packages in topological order without user interaction.
E.g. if a package installs an executable which should be invocable by name, the directory containing the executable needs to be part of the ``PATH`` environment variable.

Entry points
------------

To update environment variables:

* On non-Windows platforms a shell script needs to be ``source``-ed (e.g. ``.sh``, ``.bash``, ``.zsh``)
* On Windows a shell script needs to be ``call``-ed (e.g. ``.bat``, ``.ps1``)

.. note::

    Executables are unable to change the environment of the current shell.
    Therefore this needs to be done from a shell script.

Package-level
~~~~~~~~~~~~~

.. note::

    Each package installs its files under its install prefix.
    This corresponds to ``install/<package_name>`` except when ``colcon build --merge-install`` is used.
    In that case, the install prefix is ``install/``.

For each built package ``colcon`` generates a set of package-level scripts (one for each supported shell type): ``share/<package_name>/package.<ext>``.
These script files update the environment with information specific to this package.

``colcon`` supports multiple different approaches to update environment variables:

* A heuristic checking the installed files for known file types or known destinations.
  A few of the supported heuristics:

  * An executable under ``bin`` adds that directory to the ``PATH``
  * An existing Python library directory adds that directory to the ``PYTHONPATH``
  * A file ending in ``-config.cmake`` or ``Config.cmake`` adds the directory to the ``CMAKE_PREFIX_PATH`` (provided by ``colcon-cmake``)
  * A file starting with ``Find`` and ending in ``.cmake`` adds the directory to the ``CMAKE_MODULE_PATH`` (provided by ``colcon-cmake``)
  * A shared library adds the directory to one of the following environment variables (depending on the platform): ``LD_LIBRARY_PATH``, ``DYLD_LIBRARY_PATH``, ``PATH`` (provided by ``colcon-library-path``)
  * A file ending in ``.pc`` in a directory ``lib/pkgconfig`` adds the directory to the ``PKG_CONFIG_PATH`` (provided by ``colcon-pkg-config``)

* Specific package types providing their own scripts to setup the package specific environment.
  E.g. ``ament_cmake`` packages (supported by ``colcon-ros``) provide a file named ``share/<package_name>/local_setup.<ext>``.

Workspace-level
~~~~~~~~~~~~~~~

In the root of the install prefix path, ``colcon`` generates two kinds of scripts:

* ``local_setup.<ext>``: updates the environment with information from all packages installed under this prefix path.
  Since package-level scripts rely on information from their dependencies the package-level scripts must be invoked in topological order.
  In order to determine the topological order of all packages under the prefix path, ``colcon`` stores all run dependencies of a package in a file named ``share/colcon-core/packages/<package_name>``.

* ``setup.<ext>``: first invokes the ``local_setup.<ext>`` files from all parent prefix paths and then invokes the sibling ``local_setup.<ext>`` file.

Different shells
----------------

Each shell has a potentially different syntax and supports a different set of features.
Some environment changes like extending the ``PATH`` are applicable to all shells while others like providing completion functionality are only applicable to some.
If one shell (e.g. ``bash``) provides a superset of functionality and syntax of another shell (e.g. ``sh``) the logic of the ``.sh`` scripts doesn't have to be duplicated for ``bash`` but can be invoked from the package-level setup files.
The latter shell is called a *primary shell*.

Primary shells
~~~~~~~~~~~~~~

All environment changes necessary to use a package should be expressed in script with the extension of a primary shell.
Primary shell extensions are:

* ``.sh``: plain shell
* ``.bat``: Windows cmd
* ``.ps1``: PowerShell

Non-primary / additional shells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Other shells which are able to invoke primary shell scripts within their context commonly don't duplicate their content and logic.
Instead they first invoke the primary shell script and then add additional logic to provide specific functionalities like completion.

Avoid duplicate entries
-----------------------

Several environment variables store multiple values separated by a delimiter.
Commonly, duplicate values are not useful and only increase length and decrease readability.
Therefore, shell scripts try to avoid adding duplicate values where applicable.

With the number of values in such an environment variable the cost to check if a given value is already in the collection increases.
This significantly affects the time it takes to ``source`` / ``call`` the workspace-level setup file since for each attempt to update an environment variable the collection needs to be split and each existing value compared to the to-be-added value.

Therefore ``colcon`` provides an alternative way to update the environment.

.dsv files
~~~~~~~~~~

Since shell scripts can contain arbitrary logic it is opaque from the outside how they affect the environment.
That makes it impossible to optimize their execution.

Most scripts perform one of the following common operations:

* Set an environment variable to a value.
* Add a value to an environment variable (using a platform specific delimiter) if the value is not already in the collection.
* Source / call another script file.

A ``.dsv`` file contains the descriptive information about the intended environment change (instead of shell specific logic).
The content of such a file uses a semicolon as the delimiter and contains a single line.
The first value is the ``type`` of the operation followed by a variable number of arguments specific to the operation.

The following list enumerates the supported types and their arguments:

* ``prepend-non-duplicate;<name>;<value>``: Prepend a value ``<value>`` to an environment variable ``<name>`` (using a platform specific delimiter) if the value is not already in the collection.
  The value is considered to be a path.
  If the value is not an absolute path the prefix path of the ``.dsv`` file is prepended to the value.
  An empty value therefore represents the prefix path.
* ``prepend-non-duplicate-if-exists;<name>;<value>``: Same as ``prepend-non-duplicate`` but only if the path described by the value exists.
* ``set;<name>;<value>``: Set an environment variable ``<name>`` to a value ``<value>``.
  If the value is an existing relative path in the install prefix the install prefix is prepended to the value.
  Otherwise the value is used as is.
* ``set-if-unset;<name>;<value>``: Same as ``set``  but only if the environment variable is not yet set (or empty).
* ``source;<path>``: Source / call another script file ``<path>``.
  If the value is not an absolute path the prefix path of the ``.dsv`` file is prepended.

Implementation
--------------

Implementing the logic to determine the topological order of packages in every primary shell would be a lot of effort and (depending on the shell) cumbersome.
Also parsing and interpreting ``.dsv`` files would likely not be much faster than invoking the native scripts.

Therefore both parts are implemented in a Python script located in the root of the install prefix: ``_local_setup_util_<ext>.py``.
The Python script itself can't change the environment.
However, it is able to efficiently interpret the operations described by the ``.dsv`` files and generate the shell specific commands necessary to update the environment.
The Python file is templated with information specific to the primary shell it's used from, hence the ``<ext>`` in the filename.

Tracing
-------

When sourcing / calling a workspace-level setup file the number of evaluated scripts and / or interpreted ``.dsv`` files can be significant.
To debug what files are being considered in which order and what environment changes are being performed you can prepend the invocation with ``COLCON_TRACE=1``.
As a result each recursively invoked script as well as every generated command will be printed to the terminal.
