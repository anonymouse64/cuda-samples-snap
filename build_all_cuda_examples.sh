#!/bin/bash

# assumes that the nvidia examples have been put into $SNAPCRAFT_STAGE
cd $SNAPCRAFT_STAGE/NVIDIA_CUDA-9.1_Samples

mkdir -p $SNAPCRAFT_PART_INSTALL/bin
# only go into directories that match "*_*", i.e. like 0_Simple, 1_Utilities, etc.
for sampleType in $(ls -d *_*); do
    pushd $sampleType > /dev/null
    for sampleProg in $(ls -d *); do
        pushd $sampleProg > /dev/null
        # compile the sample program
        make
        # copy the sample program to the install directory
        cp $sampleProg $SNAPCRAFT_PART_INSTALL/bin
        popd > /dev/null
    done
    popd > /dev/null
done
