``info`` - Show Package Information
===================================

The ``info`` verb shows detailed information about packages.
It is provided by the ``colcon-package-information`` package.

For each package a set of lines is shown starting with the path of the package.
Additionally the package type, name, build/run/test dependencies and metadata
like the package version are enumerated.

By default the information for all packages is shown.
Optionally, single or multiple package names can be passed to only show their
information.

Command line arguments
----------------------

These common arguments can be used:

* :doc:`discovery <../discovery-arguments>` arguments
* :doc:`package selection <../package-selection-arguments>` arguments
* :doc:`mixin <../mixin-arguments>` arguments

Additionally, the following specific command line arguments can be used:

.. _info-verb_package-names_arg:

PKG_NAME [PKG_NAME ...]
  Explicit package names to only show their information.
  This positional argument is redundant with the package selection argument
  ``--packages-select`` and only exists for ease of use.
