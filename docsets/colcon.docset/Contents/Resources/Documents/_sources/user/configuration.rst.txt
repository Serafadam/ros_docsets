Configuration
=============

Configuration files can provide additional metadata for packages as well as define default command line arguments.
All files described below are using the `YAML <http://yaml.org/>`_ format.
Note that all strings are case sensitive.

colcon.pkg files
----------------

A ``colcon.pkg`` file must be placed in the root directory of a package.

The first level of the configuration file is a dictionary.
The key can contain any of the following:

* ``name`` (string) to declare the package name
* ``type`` (string) to explicitly declare which colcon extension should process the package.
* ``dependencies`` (list of strings) to declare additional dependencies on other packages.
  For more fine grain control it is also possible to set ``build-dependencies``, ``run-dependencies``, and ``test-dependencies``.
* ``hooks`` (list of relative paths within the install prefix) to declare additional scripts to be sourced.
* Any command line argument.
  The leading single or double dash must be omitted.

Values for command line arguments
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The value type depends on the kind of command line argument:

* For flags which are not followed by a value the value can be either ``true`` or ``false``.
* For options followed by a single decimal / float the value must be a decimal / float.
* For options followed by a single value the value must be a string.
* For options followed by one or more values the value must be a list where each item can be any of the mentioned types.

An example declaring an environment hook which should be sourced for a package:

.. code-block:: yaml

    {
        "hooks": ["share/pkgname/hook/something.sh"]
    }

.meta files
-----------

The first level of the configuration file is a dictionary.
The only two supported keys are:

* ``names`` to provide settings based on the package name.
* ``paths`` to provide settings based on the package path.

By package name
~~~~~~~~~~~~~~~

.. note::

    Providing metadata based on the package name only works if the package can be identified and the name can be determined.
    Otherwise using a `colcon.pkg` file or the `By package path`_ configuration is necessary.

The value under the ``names`` key is again a dictionary.

The key is the name of the package.
The value can contain the same package specific settings as described in the `colcon.pkg files`_ section above.
The only exception is that specifying a package name is not supported.

By package path
~~~~~~~~~~~~~~~

The value under the ``paths`` key is again a dictionary.

The key is the path of the package.
It can be either absolute or relative to the ``.meta`` file.
The value can contain the same package specific settings as described in the `colcon.pkg files`_ section above.
This can be used if the package name can't be determined automatically and placing a ``colcon.pkg`` file into the package directory is undesired.

Package specific configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The package specific part under the package name or package path has the same content as the package specific configuration files described in the `colcon.pkg files`_ section above.

Using .meta files
~~~~~~~~~~~~~~~~~

Some configuration files are being picked up by default.
The following are a few examples (see e.g. ``colcon build --help``):

* When ``--ignore-user-meta`` is not passed any file ending with ``.meta`` in any recursive subdirectory of ``$COLCON_HOME/metadata`` is being used.
* When ``--metas`` is not passed and a file ``./colcon.meta`` exists it is being used.
* Any file passed with ``--metas <path/to/file>`` is being used.

.. note::

    The default value for the environment variable ``COLCON_HOME`` is pointing to the directory ``.colcon`` within the users home directory.

defaults.yaml
-------------

If the configuration file ``$COLCON_HOME/defaults.yaml`` exists it is used to customize the default behavior of the CLI.
The location can also be modified using the environment variable ``COLCON_DEFAULTS_FILE`` (see ``colcon --help``).

The first level of the configuration file is a dictionary.
The key is the ``verb`` name.
In the case of more than one nested verbs the key is the names separated by dots.
To specify configuration options *before* the first verb use an empty string key.
The value is another dictionary containing the verb specific configuration.

Verb specific configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The key can contain any command line argument.
The leading single or double dash must be omitted.
The value type depends on the command line argument as mentioned in the `Values for command line arguments`_ section above.

An example to use the symlink install option by default:

.. code-block:: yaml

    {
        "build": {
            "symlink-install": true
        }
    }
