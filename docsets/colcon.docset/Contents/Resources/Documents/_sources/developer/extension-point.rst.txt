Extension points
================

The following describes some of the extension points and how they are used.

VerbExtensionPoint
------------------

This extension point is used by the ``colcon`` command.
Each verb extension defines custom logic which can be invoked by calling ``colcon <verb>``.
Each verb extension can add command line arguments to the verb specific subparser in ``argparse``.

PackageDiscoveryExtensionPoint
------------------------------

This extension point is used by verb extensions.
Each package discovery extension can add command line arguments which are grouped in the "Discovery arguments" section of the usage help.
Each extension returns a set of package descriptors which identify a package with the tuple path, name, and type.
While a package discovery extension only provides candidate paths it uses the package identification extension point to determine if a path contains a package.

If explicit arguments are provided for any package discovery extensions only those extension are being used.
Otherwise the package discovery extensions which provide a default value are used.

PackageIdentificationExtensionPoint
-----------------------------------

This extension point is used by package discovery extensions.
A package identification extension determines if a given path contains a package and returns the tuple path, name, and type.

Package identification extensions are grouped by their priority.
The extensions are invoked in order of their priority and the first extension successfully identifying a package stops further extensions from being considered.

If multiple extensions have the same priority they are all invoked.
If more than one extension within the priority group identifies the package in the given path the result must be identical or a warning is printed and the path is skipped.

PackageAugmentationExtensionPoint
---------------------------------

This extension point is used by verb extensions after packages have been discovered and identified.
A package augmentation extension can add arbitrary information to a package descriptor, like additional dependencies.

PackageSelectionExtensionPoint
------------------------------

This extension point is used by verb extensions after packages have been discovered, identified, and augmented.
Each package selection extension adds command line arguments which are grouped in the "Package selection arguments" section of the usage help.

By default all packages are selected.
Each extension can select / unselect matching package decorators based on the passed arguments.
If arguments for multiple extensions are being passed the combined boolean flag is a logical ``AND`` combination.

TaskExtensionPoint
------------------

This extension point is used by verb extensions after packages have been discovered, identified, and augmented.
Each task extension implements the logic for the combination of a ``verb`` and a ``package type``, e.g. building a Python package.

In order to be invoked a task extension needs parameters provided by a context object.
A job object brings those two together.

ExecutorExtensionPoint
----------------------

This extension point is used by some verb extensions to execute a set of jobs.
The executor extension with the highest priority is used by default.

ShellExtensionPoint
-------------------

This extension point is used by some task extensions to generate shells scripts to setup the environment or create environment hooks for each supported shell.
Each extension implements the logic for a specific shell.
For the primary shells each extension also provides the environment to run commands.

EnvironmentExtensionPoint
-------------------------

This extension point is used by some task extensions as well as shell extensions to create environment hooks for each supported shell.
Each extension creates environment hooks for a specific environment variable and uses the shell extensions to generate scripts for each supported shell.

EventHandlerExtensionPoint
--------------------------

This extension point defines how events are handled.
An event can be any kind of object, like a line of output, a job starting, progressing or ending, or a command executing.
Every event is dispatched to all extensions in order of their priority.
