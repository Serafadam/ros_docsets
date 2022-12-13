``graph`` - Visualize Dependencies
==================================

The ``graph`` verb generates a visual representation of the package
dependency graph.
It is provided by the ``colcon-package-information`` package.

For each package, the path, name and type is shown.
By default it outputs a topologically ordered list of packages using ASCII art
to indicate direct as well as transitive dependencies.

Optionally the verb can generate
`DOT <https://en.wikipedia.org/wiki/DOT_(graph_description_language)>`_
code to render a graphical representation.

Command line arguments
----------------------

These common arguments can be used:

* :doc:`discovery <../discovery-arguments>` arguments
* :doc:`package selection <../package-selection-arguments>` arguments
* :doc:`mixin <../mixin-arguments>` arguments

Additionally, the following specific command line arguments can be used:

.. _graph-verb_density_arg:

\\--density
  Output the density of the dependency graph.
  This option is only supported without ``--dot``.

.. _graph-verb_legend_arg:

\\--legend
  Output a legend for the dependency graph.

.. _graph-verb_dot_arg:

\\--dot
  Output topological graph in DOT.
  Commonly the output should be piped to ``dot``, e.g.
  ``| dot -Tpng -o graph.png``.

  The differently colored edges represent the dependency types:
  blue=build, red=run, tan=test.
  Dashed edges are indirect dependencies which only appear if some packages are
  being skipped.

.. _graph-verb_dot-cluster_arg:

\\--dot-cluster
  Cluster packages by their file system path.
  This option only affects ``--dot``.

.. _graph-verb_dot-include-skipped_arg:

\\--dot-include-skipped
  Include skipped packages in the rendered graph with a gray color.
  This option only affects ``--dot``.

Example Output
--------------

ASCII
~~~~~

Example output of invoking ``colcon graph`` with ``--legend`` (which adds the
first paragraph describing the symbols).

.. code-block:: console

  + marks when the package in this row can be processed
  * marks a direct dependency from the package indicated
    by the + in the same column to the package in this row
  . marks a transitive dependency

  pkg1  + **.
  pkg2   + *
  pkg3    + *
  pkg4     +
  pkg5      +

DOT
~~~

Example output of invoking ``colcon graph`` with ``--dot`` rendered into an
image.
In this example the packages have the same build (blue edges) and run (red
edges) dependencies.

.. digraph:: list

   "pkg5";
   "pkg4";
   "pkg3";
   "pkg2";
   "pkg1";
   "pkg5" -> "pkg3" [color="#0000ff:#ff0000"];
   "pkg4" -> "pkg2" [color="#0000ff:#ff0000"];
   "pkg4" -> "pkg1" [color="#0000ff:#ff0000"];
   "pkg3" -> "pkg1" [color="#0000ff:#ff0000"];
