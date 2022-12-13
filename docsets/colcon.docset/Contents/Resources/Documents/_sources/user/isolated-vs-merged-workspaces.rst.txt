Isolated vs Merged Workspaces
=============================

Assuming you know :doc:`what a workspace is <what-is-a-workspace>`, you know that by default colcon builds an **isolated workspace**.
It can also build a **merged workspace**.
These terms describe the layout of the **install space**, which is the directory software gets installed into.

This page describes the differences between the two.


Isolated Workspace
------------------

Colcon by default builds an isolated workspace.

Build the workspace from :doc:`what-is-a-workspace` without any extra arguments.

.. code-block:: bash

    colcon build

Now let's look in the ``install`` folder.

::

    install
    ├── COLCON_IGNORE
    ├── foo
    │    ├── lib/...
    │    └── share/...
    ├── local_setup.[bash|bat|ps1|sh|zsh|...]
    ├── _local_setup_util_[sh|ps1|...].py
    └── setup.[bash|bat|ps1|sh|zsh|...]

Colcon created a directory ``install/foo`` and installed the package ``foo`` inside of it.
Building an isolated workspace just means every software package is installed into its own directory.

An isolated workspace has some advantages.
When colcon tests a package in an isolated workspace it will only give the tests access to the install artifacts of the dependencies it declares.
This allows users to catch undeclared dependencies.
An isolated workspace also allows removing a single package's install artifacts by deleting its directory.


Merged Workspace
----------------

Delete the ``install`` directory and build the workspace again with the ``--merge-install`` option.

.. code-block:: bash

    colcon build --merge-install


Let's look in the ``install`` folder again.

::

    install
        ├── COLCON_IGNORE
        ├── lib/..
        ├── share/..
        ├── local_setup.[bash|bat|ps1|sh|zsh|...]
        ├── _local_setup_util_[sh|ps1|...].py
        └── setup.[bash|bat|ps1|sh|zsh|...]


Notice how there's no longer a ``foo`` folder.
The ``lib`` and ``share`` directories are now directly in ``install``.

Building a merged workspace just means every software package is installed into the same directory.

A merged workspace is advantageous on platforms where environment variables length is more tightly constrained, such as Windows 10.
Environment variables set by the shell scripts, such as ``PYTHONPATH``, will be shorter because there only needs to be one entry for all of the installed packages.
