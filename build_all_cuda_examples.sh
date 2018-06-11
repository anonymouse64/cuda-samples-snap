#!/bin/bash -e

# assumes that the nvidia examples have been put into $SNAPCRAFT_STAGE
cd $SNAPCRAFT_STAGE/NVIDIA_CUDA-9.1_Samples

# handle any artifacts needed for individual targets
mkdir -p $SNAPCRAFT_PART_INSTALL/data/
for dataFile in $(cat input_files_from_cuda_samples); do
    cp $dataFile $SNAPCRAFT_PART_INSTALL/data/
done

mkdir -p $SNAPCRAFT_PART_INSTALL/bin
# only go into directories that match "*_*", i.e. like 0_Simple, 1_Utilities, etc.
for sampleType in $(ls -d *_*); do
    pushd $sampleType > /dev/null
    mkdir -p $SNAPCRAFT_PART_INSTALL/bin/$sampleType
    for sampleProg in $(ls -d *); do
        case "$sampleProg" in 
            simpleGLES|simpleGLES_EGLOutput|simpleGLES_screen|EGLStream_CUDA_CrossGPU|EGLStreams_CUDA_Interop)
                # don't build these examples
                # as they  aren't supported on all architecture's
                ;;
            *)
                pushd $sampleProg > /dev/null
                # compile the sample program
                make
                # copy the sample program to the install directory for this sample
                cp $sampleProg $SNAPCRAFT_PART_INSTALL/bin/$sampleType/$sampleProg
                # make a symbolic link from the bin folder to the sample folder
                ln -s $SNAPCRAFT_PART_INSTALL/bin/$sampleType/$sampleProg/$sampleProg $SNAPCRAFT_PART_INSTALL/bin/$sampleProg
                popd > /dev/null
                ;;
        esac
        
    done
    popd > /dev/null
done
