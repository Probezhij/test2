#!/bin/bash

set -e

export PATH=/Applications/CMake.app/Contents/bin:$PATH

ACTION=""
REPO_DIR=$PWD
BUILD_DIR=build

help () {
    cat << EOF
Usage: build.sh [<options>]
Options:
    -h or --help                - Output this help
    clean                       - Remove the last build
    rebuild                     - Build from scratch
    -o=<output directory> or
    --output=<output directory> - build results go there. By default 'build' directory will be created in current directory
    -i=<input directory> or
    --input=<input directory>   - Repo directory. By default current directory is used.

Report bugs to: jmhan@tenable.com
EOF
}

for i in "$@"
do
case $i in
    clean|rebuild|test)
    ACTION="${i}"
    ;;
    -i=*|--input=*)
    REPO_DIR="${i#*=}"
    shift
    ;;
    -o=*|--output=*)
    BUILD_DIR="${i#*=}"
    shift
    ;;
    -h|--help)
    help
    exit 0
    ;;
    *)
          # Unknown option, error out or ignore?
    ;;
esac
done

# Rebuild should be handled after processing all command line arguments
if [ "$ACTION" = "rebuild" ]; then
    ACTION=""
    rm -rf "$BUILD_DIR"
fi

mkdir -p $BUILD_DIR
pushd $BUILD_DIR
cmake $REPO_DIR
make $ACTION
./test2.out
popd