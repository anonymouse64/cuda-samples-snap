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
}

# check if the first argument exists
if [ $# -eq 0 ]; then 
  usage
  exit 0
fi

# output all possible commands if the first argument is list-all
if [ "$1" = "list-all" ]; then
  ls -1 "$SNAP/bin" | grep -v "run-cuda-sample.sh"
  exit 0
fi

if [ -f "$SNAP/bin/$1" ]; then
  # run the first argument as the program to run with all the rest as the arguments
  $SNAP/bin/"$1" "${@:2}"
else 
  echo "$1 doesn't isn't a cuda-example"
  exit 1
fi