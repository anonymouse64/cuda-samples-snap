#!/bin/bash

# assumes that the nvidia examples have been put into $SNAPCRAFT_STAGE
cd $HOME/NVIDIA_CUDA-9.1_Samples

# only go into directories that match "*_*", i.e. like 0_Simple, 1_Utilities, etc.
for sampleType in $(ls -d *_*); do
    pushd $sampleType > /dev/null
    for sampleProg in $(ls -d *); do
        case "$sampleProg" in 
            common)
                # data dir - not a sample directory
                ;;
            *)
                pushd $sampleProg > /dev/null
                # compile the sample program
                out=$(make 2>&1)
                # check if the sample program exists as an executable
                # if it doesn't then we consider the build a "failure"
                if [ ! -f "$sampleProg" ]; then
                    echo "$sampleType/$sampleProg" >> /root/failures.txt
                    echo "===================================================="
                    echo "======= FAILURE : $sampleType/$sampleProg =========="
                    echo "===================================================="
                    echo $out
                fi
                popd > /dev/null
                ;;
        esac
        
    done
    popd > /dev/null
done
