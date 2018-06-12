#!/bin/bash

# the following files are needed to be in the same directory:
# - lena.pgm (FunctionPointers, SobelFilter)
# - Lena.pgm (FilterBorderControlNPP, boxFilterNPP, cannyEdgeDetectorNPP, freeImageInteropNPP, histEqualizationNPP)
# - frame10.ppm (HSOpticalFlow)
# - frame11.ppm (HSOpticalFlow)
# - lena_bw.pgm (bicubicTexture, simpleTexture, simpleSurfaceWrite)
# - sponge.ppm (bindlessTexture)
# - flower.ppm (bindlessTexture)
# - person.ppm (bindlessTexture)
# - nature_monte.bmp (bilateralFilter)
# - lenaRGB.ppm (boxFilter)
# - test.ppm (segmentationTreeThrust)
# - lena.ppm (recursiveGaussian)
# - gr_900_900_crg.mtx (cuSolverDn_LinearSolver)
# - lap2D_5pt_n100.mtx (cuSolverSp_LinearSolver, cuSolverSp_LowlevelCholesky, cuSolverSp_LowlevelQR)
# - portrait_noise.bmp (imageDenoising)
# - Bucky.raw (marchingCubes, volumeRender, volumeFiltering, simpleTexture3D)

pushd $SNAP/bin > /dev/null
samples=$(find -L . -maxdepth 1 -type f | grep -v "run-cuda-sample.sh")
popd > /dev/null

endExit=0

# go into the data directory to run all of the snaps, as that has all the example data files in it
pushd $SNAP/data > /dev/null

# run all commands
for sample in "$samples"; do
    case "$sample" in
        threadMigration)
            # needs threadMigration_kernel64.ptx or threadMigration_kernel64.cubin
            ;;
        vectorAddDrv)
            # needs vectorAdd_kernel64.ptx or vectorAdd_kernel.cubin
            ;;
        matrixMulDrv)
            # needs matrixMul_kernel64.ptx or matrixMul_kernel64.cubin
            ;;
        simpleTextureDrv)
            # needs simpleTexture_kernel64.ptx or simpleTexture_kernel64.cubin
            ;;
        smokeParticles)
            # needs some "floor image file"
            ;;
        jpegNPP)
            # usage:
            # jpegNPP -input=srcfile.jpg -output=destfile.jpg -scale=1.0
            ;;
        dwtHaar1D)
            # needs some specific usage:
            # dwtHaar1D --signal=<signal_file> --result=<result_file> --gold=<gold_file>
            ;;
        eigenvalues)
            # some kind of segfault
            ;;
        dct8x8|dxtc|stereoDisparity)
            # needs some sample image argument
            ;;
        simpleCUFFT_2d_MGPU|simpleCUFFT_MGPU|simpleP2P)
            # needs multiple GPU's to run :(
            ;;
        cudaTensorCoreGemm)
            # requires sm 7.0
            # my GTX 1050M current card is 6.1 :(
            ;;
        cudaDecodeGL)
            # segfault
            ;; 
        cuSolverRf)
            # missing default input file ?
            ;;
        cuHook)
            # some unknown error : cuHook sample failed (Didn't receive the allocation callback)
            ;;
        clock_nvrtc|inlinePTX_nvrtc|matrixMul_nvrtc|BlackScholes_nvrtc|binomialOptions_nvrtc|quasirandomGenerator_nvrtc|simpleAssert_nvrtc|simpleAtomicIntrinsics_nvrtc|vectorAdd_nvrtc|simpleVoteIntrinsics_nvrtc|simpleTemplates_nvrtc)
            # all nvrtc examples fail
            ;;
        simpleIPC)
            # hangs ... 
            ;;
        oceanFFT)
            # Error unable to find GLSL vertex and fragment shaders!
            ;;
        StreamPriorities)
            # some error allocating memory on the cuda device
            ;;
        segmentationTreeThrust)
            # needs test.ppm, but still fails for some reason
            ;;
        c++11_cuda)
            # needs an input text file
            ;;
        simpleAssert)
            # some assertion failed
            ;;
        BiCGStab)
            # TODO: figure out appropriate arguments here
            ;;
        *)
            echo "===== RUNNING $sample ====="
            out=$($SNAP/bin/$sample 2>&1)
            res=$?
            if [ $res -ne 0 ]; then
                echo "$sample failed:"
                echo "$out"
                endExit=$?
            fi
            ;;
    esac
done

# exit the data directory
popd > /dev/null

# exit with either 0 if all passed, or the resultant exit code 
# from the most recent failure
exit $endExit
