Design
======

Goals for colcon
----------------

A few high level goals are used to guide the overall development.

* The tool should make building, testing and using multiple packages easy.
* It should be possible to add support for any kind of build system using extensions.
  ``colcon-core`` only bundles Python support in order to bootstrap itself.
* It should be possible to build any set of packages without requiring changes to their sources.
  If necessary missing information can be provided externally.
* After building packages they must be immediately usable which includes setting up necessary environment variables etc.

Explicitly out of scope
~~~~~~~~~~~~~~~~~~~~~~~

The tool does not aim to address any of the following tasks.
Those should be left for other tools to take care of them.

* Fetch the source of the packages which should be processed by ``colcon``.
* Install dependencies of the packages which should be processed by ``colcon``.
* Perform packaging tasks like creating Debian packages.

.. note::

    While these items are specifically not targeted by ``colcon`` it is still possible to implement support for any of these features (or helpful functionality to integration with existing tools) in an extension.

Software design
---------------

Additionally some software design goals are stated:

* All the functionality provided should be exposed in a way that it can be reused by other extensions.
* The separation into multiple Python packages is being used to encourage modularity and loose coupling (`Law of Demeter <https://en.wikipedia.org/wiki/Law_of_Demeter>`_).
  It is also used to demonstrate extensibility and show that certain features are not "special" but can be contributed externally.
* Each component should have responsibility over a single part of the software (`Single responsibility principle <https://en.wikipedia.org/wiki/Single_responsibility_principle>`_).
* Each functionality added should follow the principle "you don't pay for what you don't use".
