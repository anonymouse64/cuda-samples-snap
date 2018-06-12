#!/bin/bash

# NOTE: WORKAROUND
# snapcraft inadvertantly will bring in nvidia drivers from the build host
# which is wrong because we need the cuda application to use the host system drivers
# so this function modified from https://unix.stackexchange.com/a/291611 will delete
# the snap folders
function ld_library_path_remove {
  # Delete LD_LIBRARY_PATH by parts so we can never accidentally remove sub paths
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH//":$1:"/":"} # delete any instances in the middle
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH/#"$1:"/} # delete any instance at the beginning
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH/%":$1"/} # delete any instance in the at the end
}
# ld_library_path_remove $SNAP/usr/lib/x86_64-linux-gnu
# NVIDIA_DRIVER_PATH=$(ls -d $SNAP/usr/lib/nvidia*)
# ld_library_path_remove $NVIDIA_DRIVER_PATH

function usage {
  echo "cuda-samples [sample] [args...]"
  echo "  use list-all or list-types to show possible samples and types"
  echo "  use test or test [type] to test groups of samples"
}

# check if the first argument exists
if [ $# -eq 0 ]; then 
  usage
  exit 0
fi

case "$1" in
  list-all)
    # output all of the sample executables themselves
    pushd "$SNAP/bin" > /dev/null
    find . -maxdepth 1 -type f | sed --expression='s/^.\///g' | grep -v "run-cuda-sample.sh"
    popd > /dev/null
    exit 0
    ;;
  list-types)
    # output all the sample types (which are organized into folders in $SNAP/bin)
    pushd "$SNAP/bin" > /dev/null
    find . -maxdepth 1 -type d | sed --expression='s/^.\///g' | grep -v '^.$'
    popd > /dev/null
    exit 0
    ;;
  test)
    # TODO: handle testing individual groups, like 0_Simple, etc.
    $SNAP/bin/test-cuda.sh
    exit $?
    ;;
  *)
    if [ -f "$SNAP/bin/$1" ]; then
      # run the first argument as the program to run with all the rest as the arguments
      $SNAP/bin/"$1" "${@:2}"
    else 
      echo "$1 isn't a cuda-example"
      exit 1
    fi
esac