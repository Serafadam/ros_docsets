#!/usr/bin/env bash
set -e

# Default options
opt_rosdistro=${ROS_DISTRO:-galactic}
opt_interactive=0
opt_skip_generate_interfaces=0
unset opt_repos

print_usage() {
  echo "usage: $0 [-r DISTRO] [-e URL] [-y] [-h] [package [package ...]]"
  echo ""
  echo "  -r DISTRO  Set the name of the ROS distribution (default: ${opt_rosdistro})"
  echo "             This also determines the version of repositories unless the '-e' option is given."
  echo "  -e URL     Location of a ROS 2 repos file to use instead of a release repos file."
  echo "  -i         Skip the generation of the interface documentation"
  echo "  -y         Run the script in non-interactive mode"
  echo "  -h         Display this help message"
}

# Path to this file
# Taken from SO post https://stackoverflow.com/a/246128
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

while getopts "r:e:iyh" opt; do
  case "${opt}" in
    r)
      opt_rosdistro=${OPTARG}
      ;;
    e)
      opt_repos=${OPTARG}
      ;;
    i)
      opt_skip_generate_interfaces=1
      ;;
    y)
      opt_interactive=1
      ;;
    h)
      print_usage
      exit 0
      ;;
    *)
      print_usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z ${opt_repos+x} ]; then
  repos_file_url=https://raw.githubusercontent.com/ros2/ros2/${opt_rosdistro}/ros2.repos
else
  repos_file_url=${opt_repos}
fi

if [ $# -gt 0 ]; then
  package_names=$@
else
  # If no packages are provided as arguments, use defaults
  package_names=(
    rcutils
    rcl
    rcl_action
    rcl_yaml_param_parser
    rclcpp
    rclcpp_action
    rclcpp_components
    rclpy
    rmw
  )
  # Append additional default packages for Foxy
  if [[ "foxy" == "${opt_rosdistro}" || "galactic" == "${opt_rosdistro}" ]]; then
    package_names+=(
      ament_index_cpp
      ament_index_python
#      console_bridge_vendor
      class_loader
      libstatistics_collector
      rcl_lifecycle
      rcl_logging_spdlog
      rclcpp_lifecycle
      rcpputils
      rmw_dds_common
      rmw_fastrtps_cpp
      rmw_fastrtps_dynamic_cpp
      rmw_fastrtps_shared_cpp
      rosidl_runtime_c
      rosidl_runtime_cpp
      rosidl_typesupport_c
      rosidl_typesupport_cpp
      rosidl_typesupport_fastrtps_c
      rosidl_typesupport_fastrtps_cpp
      rosidl_typesupport_interface
      tf2
      tf2_bullet
      tf2_eigen
      tf2_geometry_msgs
      tf2_kdl
      tf2_ros
#      tracetools
    )
  fi
  if [[ "foxy" == "${opt_rosdistro}" ]]; then
    package_names+=(
      tf2_tools
    )
  fi
  # Convert bash array to string
  package_names=${package_names[@]}
fi

# List packages for generating ROS interface documentation
generate_interface_docs_packages=""
if [ 0 -eq ${opt_skip_generate_interfaces} ]; then
  # Packages used for generating documentation
  generate_interface_docs_packages=(
    ros2_generate_interface_docs
    ros2run
  )
  # Packages to generate documentation for
  interface_packages=(
    action_msgs
    action_tutorials_interfaces
    builtin_interfaces
    composition_interfaces
    diagnostic_msgs
    example_interfaces
    geometry_msgs
    lifecycle_msgs
    logging_demo
    map_msgs
    nav_msgs
    pendulum_msgs
    rcl_interfaces
    rmw_dds_common
    rosgraph_msgs
    sensor_msgs
    shape_msgs
    statistics_msgs
    std_msgs
    std_srvs
    stereo_msgs
    test_msgs
    tf2_msgs
    trajectory_msgs
    turtlesim
    unique_identifier_msgs
    visualization_msgs
  )
#  if [[ "galactic" != "${opt_rosdistro}" ]]; then
#    interface_packages+=(
#      move_base_msgs
#    )
#  fi
  # Convert bash array to string
  generate_interface_docs_packages="${generate_interface_docs_packages[@]} ${interface_packages[@]}"
fi

if [ 0 -eq ${opt_interactive} ]; then
  echo "Building docs with the following configuration:"
  echo "    Release name: ${opt_rosdistro}"
  echo "    Repos file: ${repos_file_url}"
  echo "    Packages: ${package_names}"
  if [ 0 -eq ${opt_skip_generate_interfaces} ]; then
    echo "    Interfaces: ${interface_packages[@]}"
  fi
  echo ""
  read -p "Is this correct? (Yn) " yn
  case $yn in
    [Yy]* ) ;;
    [Nn]* ) exit;;
    * ) echo "Please answer yes or no."; exit;;
  esac
fi

# Build code
workspace_dir=$(mktemp -d)
echo "Building workspace in the directory '${workspace_dir}'"
cd ${workspace_dir}
mkdir src
curl -o ros2.repos ${repos_file_url}
vcs import src < ros2.repos
git clone https://github.com/ros2/ros2_generate_interface_docs src/ros2_generate_interface_docs
rosdep update
rosdep install --rosdistro ${opt_rosdistro} --from-paths src -iry
colcon build --cmake-args -DBUILD_TESTING=OFF --packages-up-to ${package_names} ${generate_interface_docs_packages}

# Clone documentation-specific repos
vcs import src < ${script_dir}/ros2_doc.repos

# Uncomment Doxyfile lines for generating tag files
sed -i "s/#\s*GENERATE_TAGFILE/GENERATE_TAGFILE/g" $(find src -name Doxyfile)
# Change the ROS 2 TAGFILES links so that they reference docs.ros2.org/<release name> instead of latest
sed -i "s/\(^TAGFILES.*docs\.ros2\.org\/\)latest/\1${opt_rosdistro}/g" $(find src -name Doxyfile)
find . -name 'Doxyfile' -exec sh -c "echo GENERATE_DOCSET   = YES >> {}" \;
# Sort packages topologically so that Doxygen tags are available for packages later in order
sorted_packages=$(colcon list --names-only -t --packages-select ${package_names} | tr '\n' ' ')

# Copy Makefile to current directory
cp ${script_dir}/Makefile .

# Build the docs
if [[ "galactic" == "${opt_rosdistro}" ]]; then
  opt_skip_distro_html="skip_distro_html=true"
fi
make install release_name=${opt_rosdistro} package_names="${sorted_packages}" ${opt_skip_distro_html}

#API is not ready in Dashing to generate interfaces
if [[ "dashing" == "${opt_rosdistro}" ]]; then
  opt_skip_generate_interfaces=1
fi

# Build interfaces docs
if [ 0 -eq ${opt_skip_generate_interfaces} ]; then
  . install/setup.sh
  ros2 run ros2_generate_interface_docs ros2_generate_interface_docs --outputdir ${workspace_dir}/api
  cp -r ${workspace_dir}/api/html/* ${workspace_dir}/src/ros2/docs.ros2.org/${opt_rosdistro}/api
fi

echo "Documentation has been generated and copied into '${workspace_dir}/src/ros2/docs.ros2.org'."
echo ""
echo "Before commiting:"
echo "  1) Check that cross-references between packages, external references, and references to generated files are working."
echo ""
echo "  2) Update 'index.html' and the 'latest' symlink to refer to the latest release."
