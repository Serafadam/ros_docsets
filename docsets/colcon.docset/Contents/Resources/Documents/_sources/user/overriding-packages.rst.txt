Overriding Packages
===================

Assuming you know :doc:`what a workspace is <what-is-a-workspace>` and :doc:`how to use multiple workspaces <using-multiple-workspaces>`, you may decide you want to change the version of a package in an underlay without rebuilding the whole chain of workspaces.
This can be done by  **overriding** the package.
It is accomplished by sourcing an existing workspace, then building a different version of that package again in a new overlay workspace.

Overriding a package is not always possible.
This page offers tips for avoiding common issues.

.. contents:: Table of Contents
    :depth: 3


How to avoid common issues
--------------------------

These are good practices to avoid common issues.
If the advice is too restrictive then see the known issue descriptions for more complex advice.

Use isolated workspaces
***********************

If you are building a workspace and suspect you may override a package from it in the future, then use an isolated workspace.
This avoids include directory search order issues.
See :doc:`this documentation <isolated-vs-merged-workspaces>` if you're unsure what an isolated workspace is.

Override every package that depends on the one you want to override
*******************************************************************

A **leaf package** is one that has no other packages that depend on it.
Overriding a non-leaf package can be problematic.
Packages in the underlay were built against the underlay version of the package, but they will be expected to run with the overlay version.
If their build process stores some information about the non-leaf package, such as an expected ABI, then the behavior at runtime is unpredictable.

Problems caused by packages remembering information at build time can be avoided by overriding every package that directly or indirectly depends on the one you actually want to override.
The group of overridden packages must span all underlays.

Say there are 3 workspaces, **A**, **B** and **C**, where **C** overlays **B** and **B** overlays **A**.
**A** contains packages ``foo`` and ``baz`` where ``baz`` depends on ``foo``.
**B** contains packages ``ping`` that depends on ``foo`` and  ``pong`` that depends on ``baz``.
**C** is the workspace being built.
If you want to override ``foo`` then you should also override ``baz``, ``ping``, and ``pong``.

Make sure overridden Python packages do not change entry point specifications
*****************************************************************************

Python packages may have `entry point specifications <https://packaging.python.org/en/latest/specifications/entry-points/>`_ in a ``setup.py`` or ``setup.cfg`` file.
Make sure the package in the overlay has identical specifications to the version in the underlay, or only adds new ones.
If any specification has been changed or removed then it may not be possible to override this package.

How to make it easier for your users to override
------------------------------------------------

This section has advice for package authors about how to make easier for your users to use your package and override it or other packages.

Install headers to a unique include directory
*********************************************

Install your package's headers to a unique folder rather than a shared folder.
Say you're the author of a package ``foo``, and it has a header meant to be included like ``#include <foo/foo.hpp>``.
Instead of installing the header to ``<prefix>/include/foo/foo.hpp``, install it to ``<prefix>/include/foo/foo/foo.hpp``.

If you have a CMake package ``foo``  with the directory structure ``include/foo/foo.hpp``, then it can install its headers to a unique directory with this:

.. code-block:: CMake

  install(DIRECTORY include/ DESTINATION include/${PROJECT_NAME})

All exported targets in your project need to export the unique include directory too.

.. code-block:: CMake

    target_include_directories(some_library_in_foo INTERFACE
      "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>"
      "$<INSTALL_INTERFACE:include/${PROJECT_NAME}>")

Dynamically link to libraries outside your package
**************************************************

If your package ``foo`` statically links to a library from package ``bar``, then users can't override ``bar`` without also overriding yours.
Prefer dynamic linking instead.

Handling Python entry point specifications
******************************************

If your package loads Python entry points and it encounters two specifications with the same name, then it should use the last specification returned by `entry_points() <https://docs.python.org/3/library/importlib.metadata.html#entry-points>`_.
It should also ignore entry points that can't be loaded.

Here's how to do it:

.. code-block:: Python

    from importlib.metadata import entry_points

    # Deduplicate entry point specifications before loading
    deduplicated_entry_points = {}
    # When faced with duplicates, this loop keeps the last entry point found
    for ep in entry_points()['your_group_name']:
        deduplicated_entry_points[ep.name] = ep

    for ep in deduplicated_entry_points:
        try:
            inst = ep.load()
        except ImportError:
            # Ignore entry point specifications that can't be loaded
            pass

All Known issues
----------------

Include Directory Search Order Problem
**************************************

When overriding a package, it's possible for another package to find that package's headers from the underlay instead of the overlay.
This may cause a failure to build or unexpected behavior at runtime depending on the differences between those headers.

Consider an overlay containing package ``foo`` and ``bar``, and an underlay containing ``bar`` and ``baz``.
``foo`` depends on ``bar`` and ``baz``.
Say the underlay is a merged workspace, and both the overridden ``bar`` and ``baz`` install their headers to a directory called ``include/``.
If any libraries or executables in ``foo`` are configured to search for headers in ``baz``'s include directory first, then headers from overridden ``bar`` will also be found first.

When it can happen
++++++++++++++++++

* The underlay workspace is a merged workspace
* The overridden package installs header files (C/C++)
* The overriding package's headers are different from the overridden package's
* Another package in the underlay is not overridden and installs headers to the same directory as the overridden package (such as ``include``)
* A package in the overlay depends on both the package being overridden and the aforementioned additional package in the underlay

How to avoid it
+++++++++++++++

Use isolated workspaces
^^^^^^^^^^^^^^^^^^^^^^^

If your underlay is an isolated workspace, then no two packages in it will have the same include directory.
Using an isolated overlay workspace won't help if your underlay is already a merged workspace (for example, the default ROS installation when installed from binary packages).

Sort include directories according to the workspace order
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

One solution is to sort include directories before passing them to the compiler such that headers are found in overlay workspaces before underlays.
This requires making the build system for every package in an overlay aware of workspaces and the order they were sourced.
The only known implementation of this is the ``find_package(catkin COMPONENTS ...)`` CMake feature in ROS 1.

Only override packages that install headers to unique include directories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If every package in the underlay installs their headers to unique directories, then packages in the overlay cannot accidentally find headers when depending on other packages in the underlay.

Unpredictable behavior when overridden package breaks API
*********************************************************

Consider an overlay containing ``bar``, and an underlay containing ``bar`` and ``baz``.
``baz`` depends on ``bar``.
If ``bar`` in the overlay changed an API used by ``baz``, then the behavior of ``baz`` at runtime can't be predicted.

When it can happen
++++++++++++++++++

* The overriding package removed or changed APIs compared to the overridden package
* A package in the underlay depends on the overridden package

How to avoid it
+++++++++++++++

Build everything above the overridden package from source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If an API has changed, then every package in the underlay which depends on the overridden package (directly or indirectly) must be overridden too.
You will need to find versions of those packages that are compatible with the API changes.

Undefined behavior when overridden package breaks ABI
*****************************************************

Consider an overlay containing ``bar``, and an underlay containing ``bar`` and ``baz``.
``baz`` depends on ``bar``.
If ``bar`` in the overlay changed ABI, then it is unpredictable what will happen when ``baz`` is used at runtime.

When it can happen
++++++++++++++++++

* The overridden package uses a compiled language (C/C++, etc.)
* The overriding package is ABI incompatible with the overridden one

How to avoid it
+++++++++++++++

Build everything above the overridden package from source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If ABI has changed, then every package in the underlay which depends on the overridden package (directly or indirectly) must be overridden too.
If only ABI has changed, then no changes to the packages are needed.
Compiling them again is enough.

Renamed or deleted Python modules still importable
**************************************************

Consider an overlay containing a Python package ``pyfoo`` and an underlay containing a Python package ``pyfoo``.
``pyfoo`` in the underlay installs the Python modules ``foo``, ``foo.bar``, and ``baz``.
``pyfoo`` in the overlay installs only the Python modules ``foo``.

When the overlay is active, users will still be able to import ``baz`` from the underlay version of ``pyfoo``
However, they will not be able to import ``foo.bar`` because Python will find the ``foo`` package in overlay first, and that one does not contain ``bar``.

When it can happen
++++++++++++++++++

* The package being overridden is a Python package
* The overridden package installs top level modules not present in the overriding package

How to avoid it
+++++++++++++++

No workaround is known yet, but it's unlikely to cause problems unless combined with another issue.

One-definition rule violations caused by static linking
*******************************************************

Consider an overlay containing packages ``foo`` and ``bar``, and an underlay containing packages ``bar`` and ``baz``.
``foo`` depends on ``bar`` and ``baz``.
``baz`` depends on ``bar`` and has a library that statically links to another library in ``bar``.
``foo`` has a library depending on both the mentioned library in ``baz`` and in ``bar``.

When ``foo`` is used there are two definitions for symbols from ``bar``: the ones from the underlay version of ``bar`` via ``baz``, and the one from the overlay version of ``bar``.
At runtime, the implementations from the underlay version may be used.

When it can happen
++++++++++++++++++

* a package in the underlay statically links to the overridden package
* a package in the overlay depends on the overriding package and the package in the underlay

How to avoid it
+++++++++++++++

Build everything above the overridden package from source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

All packages directly or indirectly depending on the overridden package must be added to the overlay.
No changes to the packages are needed.
Compiling them again is enough.

Python entry_points are duplicated
**********************************

Consider a package ``pyfoo`` that has an entry point specification  ``foobar = pyfoo.bar:baz``.
If ``pyfoo`` is overridden and the overridden version has same specification, then the entry point will be listed twice.
Whether or not it is a problem depends on how those entry points are loaded.

If the code loading entry points loads all of them without checking for duplicates, then the same entry points may be used twice.

When it can happen
++++++++++++++++++

* A python package providing entry points is overridden with a version that provides the same specification.

How to avoid it
+++++++++++++++

There is no known workaround.

Deleted Python entry_points may still be loaded
***********************************************

Consider a package ``pyfoo`` that has an entry point specification  ``foobar = pyfoo.bar:baz``.
say ``pyfoo`` is overridden and the overridden version does not have that specification.

If the specification is still importable, then entry points from the underlay may be run undesirably.
If the specification is not importable, then the code loading them must gracefully handle import errors.

When it can happen
++++++++++++++++++

* A python package providing entry points is overridden with a version that omits an entry point available in the underlay.

How to avoid it
+++++++++++++++

There is no known workaround.
