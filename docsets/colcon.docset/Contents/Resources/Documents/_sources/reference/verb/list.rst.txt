``list`` - List Packages
========================

The ``list`` verb enumerates a set of packages.
It is provided by the ``colcon-package-information`` package.

For each package a line is shown containing the path, name and type separated
by tabs.
By default the list is ordered alphabetically by the package name.
Optionally, it can order the packages topologically based on their dependencies.

Command line arguments
----------------------


These common arguments can be used:

* :doc:`discovery <../discovery-arguments>` arguments
* :doc:`package selection <../package-selection-arguments>` arguments
* :doc:`mixin <../mixin-arguments>` arguments

Additionally, the following specific command line arguments can be used:

.. _list-verb_topological-order_arg:

\\--topological-order, -t
  Order output based on topological ordering (breadth-first).
  For more detailed visualizations of dependencies see the :doc:`graph <graph>`
  verb.

.. _list-verb_names-only_arg:

\\--names-only, -n
  Output only the name of each package but not the path and type

.. _list-verb_paths-only_arg:

\\--paths-only, -p
  Output only the path of each package but not the name and type
