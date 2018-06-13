#!/bin/bash -e

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
    pushd "$SNAP/bin" > /dev/null || exit 1
    find -L . -maxdepth 1 -type f | sed --expression='s/^.\///g' | grep -v "run-cuda-sample.sh"
    popd > /dev/null  || exit 1
    exit 0
    ;;
  list-types)
    # output all the sample types (which are organized into folders in $SNAP/bin)
    pushd "$SNAP/bin" > /dev/null  || exit 1
    find . -maxdepth 1 -type d | sed --expression='s/^.\///g' | grep -v '^.$'
    popd > /dev/null || exit 1
    exit 0
    ;;
  test)
    # TODO: handle testing individual groups, like 0_Simple, etc.
    "$SNAP/bin/test-cuda.sh"
    exit $?
    ;;
  *)
    if [ -f "$SNAP/bin/$1" ]; then
      # run the first argument as the program to run with all the rest as the arguments
      "$SNAP/bin/$1" "${@:2}"
    else 
      echo "$1 isn't a cuda-example"
      exit 1
    fi
esac