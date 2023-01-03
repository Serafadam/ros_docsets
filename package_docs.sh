#!/usr/bin/env bash
# Packages docsets into release archives and generates docset feed files.
set -e  # Terminate on error

BASEDIR=$(realpath $(dirname "${BASH_SOURCE[0]:-$0}"))  # Absolute path to script directory
DOCSDIR="${BASEDIR}/docsets"                            # Absolute path to docsets
PKGSDIR="${BASEDIR}/dist"                               # Absolute path for created archives
FEEDSDIR="${BASEDIR}/feeds"                             # Absolute path for created feeds

BASEURL=https://github.com/Serafadam/ros_docsets/releases/download
# Feeds
FEEDS=(
  core
  extras
  tools
  full
)
# Docsets, as {name: feed name}
declare -A DOCSETS=(
  ["colcon"]="tools"
  ["launch"]="tools"
  ["rclcpp"]="core"
  ["rclpy"]="core"
  ["ros_core"]="core"
  ["MoveIt documentation"]="extras"
  ["Navigation 2"]="extras"
  ["ROS 2 documentation"]="extras"
)
VERSION=


# Prints script usage help.
print_usage() {
  echo "Usage: ${BASH_SOURCE[0]##*/} [--version VERSION]

Packages docsets into release archives and generates docset feed files.

Version defaults to docsets last commit date, or current date if docsets locally modified.

optional arguments:
  --version VERSION    explicit version to use
"
}


# Parse script parameters
while (( "$#" )); do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
    ;;
    -h|--help)
      print_usage
      exit
    ;;
    *)  # unsupported flags
      echo "Error: unknown parameter $1" >&2
      exit 1
    ;;
  esac
done


# Ensure version
if [[ -z "$VERSION" ]] ; then
  # Set version to docsets last commit date if not locally modified
  if [[ -z `git -C "$BASEDIR" status $(basename "$DOCSDIR") --short` ]] ; then
    VERSION=$(git -C "$BASEDIR" log -1 --format=%cd --date=format:'%Y.%m.%d' $(basename "$DOCSDIR"))
  fi
fi
if [[ -z "$VERSION" ]] ; then
  VERSION=$(date +'%Y.%m.%d')
fi


echo "Creating archives and feeds for version $VERSION"
echo
mkdir -p "$PKGSDIR"
mkdir -p "$FEEDSDIR"

# Create docset archives
for docset in "${!DOCSETS[@]}" ; do
  echo -n "Archiving ${docset}.."
  filepath="${PKGSDIR}/${docset// /_}.tgz"
  tar -cvzf "$filepath" -C "$DOCSDIR" "${docset}.docset" >/dev/null
  echo "  created $(basename "$PKGSDIR")/$(basename "$filepath") ($(du --bytes "$filepath" | cut -f1) bytes)"
done

# Create feeds
for feed in "${FEEDS[@]}" ; do
  filepath="${FEEDSDIR}/${feed}.xml"
  echo "Creating $(basename "$FEEDSDIR")/$(basename "$filepath")"
  echo "<entry>" > "$filepath"
  echo "    <version>$VERSION</version>" >> "$filepath"
  for docset in "${!DOCSETS[@]}" ; do
    if [[ "$feed" == "full" ]] || [[ "$feed" == "${DOCSETS[$docset]}" ]] ; then
      echo "    <url>$BASEURL/$VERSION/${docset// /_}.tgz</url>" >> "$filepath"
    fi
  done
  echo "</entry>" >> "$filepath"
done
