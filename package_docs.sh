#!/usr/bin/env bash
# Packages docsets into release archives and generates docset feed files.
set -e  # Terminate on error

BASEDIR=$(realpath $(dirname "${BASH_SOURCE[0]:-$0}"))  # Absolute path to script directory
DOCSDIR="${BASEDIR}/docsets"                            # Absolute path to docsets
PKGSDIR="${BASEDIR}/dist"                               # Absolute path for created archives
FEEDSDIR="${BASEDIR}/feeds"                             # Absolute path for created feeds

BASEURL=https://github.com/Serafadam/ros_docsets/releases/download
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


readarray -t FOLDERS <<<"$(find "${DOCSDIR}" -mindepth 1 -maxdepth 1 -type d -exec basename "{}" \;)"

echo "Creating archives and feeds for version $VERSION"
echo "Found ${#FOLDERS[@]} docsets"
echo
mkdir -p "$PKGSDIR"
mkdir -p "$FEEDSDIR"

# Create docset archives
for folder in "${FOLDERS[@]}" ; do
  echo -n "Archiving $(basename "$DOCSDIR")/${folder}.."
  filepath="${PKGSDIR}/${folder%%.docset// /_}.tgz"
  tar -cvzf "$filepath" --checkpoint=8192 --checkpoint-action="ttyout=." -C "$DOCSDIR" "${folder}" >/dev/null
  echo "  created $(basename "$PKGSDIR")/$(basename "$filepath") ($(du --bytes "$filepath" | cut --fields 1) bytes)"
done
echo

# Create feeds
for folder in "${FOLDERS[@]}" ; do
  feed=$(TMP="${folder%%.docset}" && echo "${TMP// /_}")
  filepath="${FEEDSDIR}/${feed}.xml"
  echo "Creating $(basename "$FEEDSDIR")/$(basename "$filepath")"
  cat > "$filepath" << EOF
<entry>
  <version>$VERSION</version>
  <url>$BASEURL/$VERSION/${feed}.tgz</url>
</entry>
EOF
done
