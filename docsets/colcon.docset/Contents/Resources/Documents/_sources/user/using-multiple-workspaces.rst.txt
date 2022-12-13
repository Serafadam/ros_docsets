Using Multiple Workspaces
=========================

Assuming you know :doc:`what a workspace is <what-is-a-workspace>`, you know **sourcing a workspace** allows you to use the installed software.
It is possible to use software from multiple workspaces at the same time.

Using multiple independent workspaces
-------------------------------------

If you have multiple **independent workspaces**, then they can be used at the same time by sourcing them in sequence.
Workspaces are **independent** if neither workspace has a package that depends on a package in the other workspace.

.. code-block:: bash

    source foo_ws/install/setup.bash
    source bar_ws/install/setup.bash


The first workspace ``foo_ws`` is called the **underlay workspace**.
The second, ``bar_ws``, is called the **overlay workspace**.
When sourcing more then two workspaces each workspace is said to **overlay** the previous one.

Independent workspaces can usually be sourced in any order.

.. note::

    Be cautious when sourcing multiple workspaces.
    Undefined behavior can result if packages from one depend on packages from another, meaning they're not actually independent.
    Chain the workspaces instead if you're unsure.


Chaining workspaces
-------------------

**Chaining workspaces** means making a workspace depend on another workspace.
To chain workspaces, build the underlay workspace first.
Source the underlay in an new terminal and build the overlay.

.. code-block:: bash

    # Build ping_ws
    cd ping_ws
    colcon build
    # In a new terminal source ping_ws and build pong_ws
    source ping_ws/install/setup.bash
    cd pong_ws
    colcon build

In this example ``pong_ws`` overlays ``ping_ws``.
``pong_ws`` may have a package that depends on packages in ``ping_ws``, but ``ping_ws`` cannot have a package that depends on packages in ``pong_ws``.

Only the last workspace in a chain needs to be sourced.

.. code-block:: bash

    # Sourcing pong_ws automatically sources ping_ws first
    source pong_ws/install/setup.bash

.. note::

    Use ``local_setup.[sh|bash|bat|...]`` if you want to source a workspace without automatically sourcing the underlays it depends on, such as when you've already sourced the underlay.

You can chain any number of workspaces together by repeating these step with more overlay workspace.

Extending workspaces versus overriding packages
-----------------------------------------------

An overlay workspace **extends** an underlay workspace when it provides new packages.
Extending workspaces has no known issues and is the most common use case.

It is also possible for an overlay workspace to contain a different version of a package which has already been built in one of the underlay workspaces.
This is called **overriding a package**.
Ideally, the version in the overlay workspace should be the one used when the workspace chain is sourced, but that doesn't work in all cases.
See :doc:`overriding-packages` for more information about known issues.
