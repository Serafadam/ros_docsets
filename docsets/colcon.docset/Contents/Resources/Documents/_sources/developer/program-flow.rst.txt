Program flow
============

The following depicts the high level program flow of a couple of verbs.

list
----

This verb is provided by the ``colcon-package-information`` package.

.. digraph:: list

   initial [shape="point", width="0.2"];
   initial -> get_package_descriptors [label=" args"];
   get_package_descriptors -> topological_order_packages [label=" set(pkg descriptor)"];
   topological_order_packages -> select_package_decorators [label=" list(pkg decorator)"];
   select_package_decorators -> decision [label=" list(pkg decorator)"];
   decision [label="", shape="diamond"];

   merge [label="", shape="diamond"];
   decision:sw -> merge:nw [xlabel=" alphabetical order "];
   decision:se -> merge:ne [label=" topological order"];

   merge -> print [label=" list(pkg decorator)"];
   print [label="print pkg name / path / type"];
   print -> activity_final;
   activity_final [label="", shape="circle", width="0.2"];

build
-----

This verb is provided by the ``colcon-core`` package.

.. digraph:: list

   initial [shape="point", width="0.2"];
   initial -> get_package_descriptors [label=" args"];

   subgraph cluster_get_packages {
      color = "gray";
      label = "get_packages";
      labeljust = "l";
      get_package_descriptors -> topological_order_packages [label=" set(pkg descriptor)"];
      topological_order_packages -> select_package_decorators [label=" list(pkg decorator)"];
      select_package_decorators -> decision [label=" list(pkg decorator)"];
      decision [label="", shape="diamond"];

      decision -> flow_final [label=" duplicate pkg names"];
      flow_final [fixedsize="true", label="✕", shape="circle", width="0.18"];
      {rank = same; decision; flow_final;}
   }

   decision -> get_jobs [label=" no duplicates"];
   get_jobs -> execute_jobs [label=" OrderedDict(job)"];
   execute_jobs -> create_prefix_scripts [label=" rc"];
   create_prefix_scripts -> activity_final [label=" rc"]
   activity_final [fillcolor="black", label="", shape="doublecircle", style="filled", width="0.2"];
