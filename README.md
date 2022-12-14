# ROS Docsets

Newest snapshot: 2022.12.13

![](docsets.gif)

Docsets to use in Dash/Zeal. These allow you to browse documentation for ROS (specifically for ROS Humble/Rolling). Sadly, no automation yet, all of those were compiled manually with the use of few scripts, if there's interest I might add automatic generation.

## How to use

To use with Zeal, add URLs for desired docsets from this repository's [feeds](feeds) directory to Zeal configuration.

#### Using manually

To manually provide the docsets to Zeal, download the repo, and put directories from `docsets` directory to Zeal's data folder,
e.g. `~/.local/share/Zeal/Zeal/docsets`.
Note, Zeal needs to be restarted afterwards if already running.

## Available docs
* colcon (feed: [colcon.xml](feeds/colcon.xml?raw=true))
* launch (feed: [launch.xml](feeds/launch.xml?raw=true))
* Moveit2 (feed: [MoveIt_documentation.xml](feeds/MoveIt_documentation.xml?raw=true))
* Navigation2 (feed: [Navigation_2.xml](feeds/Navigation_2.xml?raw=true))
* rclcpp (feed: [rclcpp.xml](feeds/rclcpp.xml?raw=true))
* rclpy (feed: [rclpy.xml](feeds/rclpy.xml?raw=true))
* main ros documentation (feed: [ROS_2_documentation.xml](feeds/ROS_2_documentation.xml?raw=true))
* ros_core (feed: [ros_core.xml](feeds/ros_core.xml?raw=true))

## Recreating

For tools like Moveit2, Navigation2 and colcon one only has to download latest docs source and use `doc2dash` after building ROS.

For libraries such as rclcpp, rclpy,launch etc. it's a little bit more complicated.
First, run `build_docs.sh`. Then for each directory that you want (provided it generated documentation) run `doxygen2docset`

Example

```
build_docs.sh -r humble
```

```
doxygen2docset --doxygen /tmp/tmp.z0rJ443ajE/src/ros2/rclcpp/rclcpp/doc_output/html --docset ~/rclcpp_docset
```

Note that the main directory name (in this case `tmp.z0rJ443aJe`) is generated randomly 
You might also need to edit manually `Info.plist` file inside `Contents` directory to set proper name for the docs.

Links:

https://github.com/ros2/docs.ros2.org/tree/doc_gen
https://github.com/chinmaygarde/doxygen2docset
https://pypi.org/project/doc2dash/


