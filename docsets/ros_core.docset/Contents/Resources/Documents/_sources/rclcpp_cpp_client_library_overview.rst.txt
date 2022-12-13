``rclcpp``: CPP Client Library Overview
=======================================

.. include:: global_substitutions.txt

The ROS 2 core software stack breaks down into a few discrete but related parts:

.. toctree::
   :hidden:

   glossary.rst

.. contents::
   :depth: 2
   :local:

.. highlight:: c

.. danger::

    This document is under construction and should not be used as a reference. Some things that are implemented are not documented here and other things documented here are the "desired" state but are not implemented in the actual code yet.

.. _init_and_shutdown:

Initialization and Shutdown
---------------------------

Before using |rclcpp| it must be initialized exactly once per process.
Initializing |rclcpp| is done using the :cpp:func:`rclcpp::init` function::

    #include <rclcpp/rclcpp.hpp>

    int main(int argc, char ** argv)
    {
      rclcpp::init(argc, argv);
    }

This function initializes any global resources needed by the middleware and the client library, as well as doing client library related command line argument parsing.
The command line arguments can be mutated by this function, as it will remove any client library specific arguments so that later argument parsing does not have to deal with client library specific arguments.
Therefore, it is generally a good idea to call this function before doing application specific command line argument parsing.

..
   Initialization Options
   ~~~~~~~~~~~~~~~~~~~~~~

   The :cpp:func:`rclcpp::init` function can optionally take extra initialization options.
   A few of the useful options (non-exhaustive):

   - :cpp:class:`rclcpp::init::do_not_prune_arguments`: Prevents :cpp:func:`rclcpp::init` from removing client library specific arguments from ``argv``.
   - :cpp:class:`rclcpp::init::on_sigint`: This option requires a callback that is to be called when ``SIGINT`` occurs, but before :cpp:func:`rclcpp::shutdown` is called.
   - :cpp:class:`rclcpp::init::no_sigint_handling`: Prevents |rclcpp| from handling any ``SIGINT`` signals (not recommended).

   These options, and others, can be combined into an :cpp:class:`rclcpp::init::InitializationOptions` object programmatically::

      int main(int argc, char ** argv)
      {
         rclcpp::init::InitializationOptions options;
         options |= rclcpp::init::do_not_prune_arguments;  // Do not prune
         options.do_not_prune_arguments = false;  // Do prune
         options.do_not_prune_arguments = true;  // Do not prune, again
         options.on_sigint = []() {fprintf(stderr, "on_sigint\n");}
         rclcpp::init(argc, argv, options);
      }

   Or they can be passed to :cpp:func:`rclcpp::init` directly::

      int main(int argc, char ** argv)
      {
         rclcpp::init(argc, argv, rclcpp::init::do_not_prune_arguments | rclcpp::init::on_sigint(my_sigint_func));
      }

Shutdown and Reinitialization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Initialization can be done again, after a call to :cpp:func:`rclcpp::shutdown` has been completed successfully::

    int main(int argc, char ** argv)
    {
      while (/* condition */) {
        rclcpp::init(argc, argv, rclcpp::init::do_not_prune_arguments);
        // ...
        rclcpp::shutdown();
      }
    }

The shutdown function causes all nodes and their constituent parts to become invalid and shutdown.
It also destroys any global resources created when the initialization function was originally called.

Note that if you intend to call :cpp:func:`rclcpp::init` multiple times, be sure to use the ``do_not_prune_arguments`` initialization option, as is done above, in order to preserve the original arguments for future invocations.

Testing for Shutdown and Reinitialization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In order to test whether or not :cpp:func:`rclcpp::shutdown` has been called, the :cpp:func:`rclcpp::ok` function can be used::

    while (rclcpp::ok()) {
      // Do work...
    }

In order to test if the system has been reinitialized, an :cpp:class:`rclcpp::init::InitInstance` can be retrieved using the :cpp:func:`rclcpp::init::get_instance` function and tested against the current instance using :cpp:func:`rclcpp::ok`::

    rclcpp::init::InitInstance init_instance = rclcpp::init::get_instance();
    while (rclcpp::ok(init_instance)) {
      // Do work...
    }
    // Either shutting down or restarting...

The instance can be compared to check that the reinitialization was not missed::

    rclcpp::init::InitInstance init_instance = rclcpp::init::get_instance();
    while (rclcpp::ok(init_instance)) {
      // Do work...
      if (init_instance != rclcpp::init::get_instance()) {
        // Reinitialization happened since the last rclcpp::ok check...
      }
    }

The initialization instance is just a handle used for comparison and can be copied, moved, or destroyed without consequence.

Nodes
-----

The main entry point to the |rclcpp| API is the :cpp:class:`rclcpp::Node` class.
The :cpp:class:`rclcpp::Node` class represents a single element in the ROS graph.
Node's can have publishers and subscribers on topics, provide or call services, have parameters, and many other things.

Creating a node is done by calling the constructor of the :cpp:class:`rclcpp::Node` class and providing a name for the node (after calling :cpp:func:`rclcpp::init`)::

    #include <rclcpp/rclcpp.hpp>

    // ...
    {
      rclcpp::init(/* ... */);
      rclcpp::Node::SharedPtr node = rclcpp::Node::make_shared("my_node");
    }

It is recommended that nodes be created within a smart pointer for automatic object lifetime management, e.g. a shared pointer or a unique pointer, as demonstrated above for the former with the ``make_shared`` alias::
However, it can be created on the stack as well::

    // ...
    {
      rclcpp::Node node("my_node");
    }

Since the :cpp:class:`rclcpp::Node` class operates on an `RAII-style pattern <http://en.cppreference.com/w/cpp/language/raii>`_, the node is initialized and exposed to the ROS graph on construction and is shutdown and removed from the graph on destruction.
Therefore nodes are scoped and must be kept around to keep the node valid.
If the node object goes out of scope or is explicitly shutdown then any objects created using the node are also invalid.

The name of the node must be unique across all nodes in the ROS graph.
If a node with a colliding name is created, then the conflicting node already running will be shutdown.

.. todo:: Add section about namespaces within nodes, e.g. http://wiki.ros.org/roscpp/Overview/NodeHandles#Namespaces

..
   Node Options
   ~~~~~~~~~~~~

   Nodes can optionally take extra options to control their behavior, for example:

   - :cpp:class:`rclcpp::node::anonymous_name`: When passed it generates a unique name for the node by appending an ``_`` followed by a randomly generated string of numbers and letters.
   - :cpp:class:`rclcpp::node::no_parameters`: Disable parameter functionality for this node. It will not be able to have its own parameters nor will other nodes be able to set parameters on it, but it can still read parameters from other nodes.

   .. todo:: Link to exhaustive list of Node options.
   .. todo:: Consider a different namespace to put node options in.
   .. todo:: Follow through with or remove the no_parameters option, as it is sort of half-baked.

   Options can be assembled programmatically::

      // ...
      {
         rclcpp::node::NodeOptions options;
         options |= rclcpp::node::anonymous_name;
         options.no_parameters = true;
         auto node = rclcpp::Node::make_shared("my_node", options);
      }

   Or can be passed directly to the Node's constructor::

      // ...
      {
         auto node = rclcpp::Node::make_shared("my_node", rclcpp::node::anonymous_name | rclcpp::node::no_parameters);
      }

Publish and Subscribe with Topics
---------------------------------

One of the middleware communication primitives provided by |rclcpp| is the publish-subscribe pattern using topics.
In this pattern Messages, that are defined by the user in an interface description file, are passed between Publishers and Subscribers which are on the same Topic.
A Topic is a name with an associated Message type, which determines whether or not Publishers and Subscribers should exchange messages.
Publishers publish new Messages onto the Topic and any Subscribers that have subscribed to the same Topic (and with the same Message type) will receive those messages asynchronously.

Working with Messages
~~~~~~~~~~~~~~~~~~~~~

Before publishing, a message must be created and filled with information.
Messages are defined using the ROS IDL within ``.msg`` files.
These files are used to generate C++ code and data structures which are used for publishing and when receiving from a subscription.
Messages are namespaced by the package in which they are defined and are converted into C++ code in a conventional way.
For example, a C++ header file is generated for each message:

- ``package_name/msg/Foo.msg`` -> ``package_name/msg/foo.hpp``

And that header would contain a C++ data structure with a similar namespace:

- ``package_name/msg/Foo.msg`` -> ``package_name::msg::Foo``

In addition to defining custom Messages, there are many predefined Messages that are defined in the common Message packages that come with ROS, for example:

- ``std_msgs/msg/String.msg``
- ``geometry_msgs/msg/Point.msg``
- ``builtin_msgs/msg/Time.msg``

There are many others, but throughout this document some of the standard messages will be used.

Generated Messages provide attribute access to the Fields so they can be accessed directly for setting and getting::

    #include <geometry_msgs/msg/point.hpp>

    // ...
    {
      geometry_msgs::msg::Point p;
      p.x = 1;
      p.y = 2;
      p.z = 3;
      printf("Point at (%d, %d, %d)\n", p.x, p.y, p.z);
    }

The fields can also be accessed using methods and the named parameter idiom, a.k.a. `method chaining <https://en.wikipedia.org/wiki/Method_chaining>`_::

    #include <geometry_msgs/msg/point.hpp>

    // ...
    {
      geometry_msgs::msg::Point p;
      p.set__x(1).set__y(2).set__z(3);
      printf("Point at (%d, %d, %d)\n", p.x, p.y, p.z);
    }

.. rst-class:: html-toggle

**Advanced:** Messages and Smart Pointers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generated Messages also have some common smart pointer definitions built in, for example:

- ``geometry_msgs::msg::Point::SharedPtr`` is equivalent to ``std::shared_ptr<geometry_msgs::msg::Point>``
- ``geometry_msgs::msg::Point::ConstSharedPtr`` is equivalent to ``std::shared_ptr<const geometry_msgs::msg::Point>``
- ``geometry_msgs::msg::Point::UniquePtr`` is equivalent to ``std::unique_ptr<geometry_msgs::msg::Point>``
- ``geometry_msgs::msg::Point::WeakPtr`` is equivalent to ``std::weak_ptr<geometry_msgs::msg::Point>``

.. todo:: link to exhaustive list of aliases provided.

.. rst-class:: html-toggle

**Advanced:** Messages and Allocators
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Generated Messages are also template-able based on an Allocator.
Since the fixed and dynamic sized arrays within a generated C++ Message use STL containers like ``std::vector``, the generated Messages also expose an Allocator.
For example, the ``nav_msgs/msg/Path.msg`` Message has a list of time stamped poses which are stored in a ``std::vector``.
You could use the Message with a custom allocator by using the template version of the Message structure that ends with a ``_``::

    #include <nav_msgs/msg/path.hpp>

    // ...
    {
      MyAllocator a;
      nav_msgs::msg::Path_<MyAllocator> path(a);
    }

Publishing with a ``Publisher``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In |rclcpp| publishing is achieved by creating an :cpp:class:`rclcpp::Publisher` object and calling :cpp:member:`rclcpp::Publisher::publish` with a Message as the first parameter.

.. todo:: link to complete API docs for Publishers.

Creating an :cpp:class:`rclcpp::Publisher` is done using the node and by providing a topic name, topic type, and, at a minimum, the publishing queue depth.
The topic type is conveyed as a template argument to the :cpp:member:`rclcpp::Node::advertise` method, for example::

    #include <rclcpp/rclcpp.hpp>

    #include <geometry_msgs/msg/point.hpp>

    // ...
    {
      // Previously created a node of type rclcpp::Node::SharedPtr...
      rclcpp::Publisher::SharedPtr publisher = node->advertise<geometry_msgs::msg::Point>("my_topic", 10);
      geometry_msgs::msg::Point point;
      point.set__x(1).set__y(2).set__z(3);
      publisher->publish(point);
    }

.. rst-class:: html-toggle

**Advanced:** Alternative Ways to Create Publishers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An :cpp:class:`rclcpp::Publisher` can also be created by passing one of the built-in QoS policies::

    // ...
    {
      auto publisher = node->advertise<geometry_msgs::msg::Point>("my_topic", rclcpp::qos::profile_sensor_data);
    }

Or with a programmatically created QoS profile based on an existing one::

    // ...
    {
      rclcpp::qos::QoS qos = rclcpp::qos::profile_default;
      qos.depth = 10;
      auto publisher = node->advertise<geometry_msgs::msg::Point>("my_topic", qos);
    }

Or passed directly to the method call::

    // ...
    {
      auto publisher = node->advertise<geometry_msgs::msg::Point>(
        "my_topic",
        rclcpp::qos::profile_default | rclcpp::qos::best_effort | rclcpp::qos::depth(10));
    }

.. todo:: Consider moving alternative signatures to a separate section and link to it.

The `RAII-style pattern <http://en.cppreference.com/w/cpp/language/raii>`_ is also used with the :cpp:class:`rclcpp::Publisher`, so once created it has been advertised to the ROS graph and other nodes are aware of it.
Conversely, when the :cpp:class:`rclcpp::Publisher` is allowed to go out of scope, or is explicitly deleted, it is unadvertised from the ROS graph.
