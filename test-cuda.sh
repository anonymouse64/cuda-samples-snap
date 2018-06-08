#!/bin/bash

# run all commands
for command in $(cuda-samples list-all); do
    case "$command" in
        marchingCubes|volumeRender|volumeFiltering|simpleTexture3D)
            # needs Bucky.raw
            ;;
        threadMigration)
            # needs threadMigration_kernel64.ptx or threadMigration_kernel64.cubin
            ;;
        vectorAddDrv)
            # needs vectorAdd_kernel64.ptx or vectorAdd_kernel.cubin
            ;;
        matrixMulDrv)
            # needs matrixMul_kernel64.ptx or matrixMul_kernel64.cubin
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
        imageDenoising)
            # needs portrait_noise.bmp
            ;;
        simpleCUFFT_2d_MGPU|simpleCUFFT_MGPU|simpleP2P)
            # needs multiple GPU's to run :(
            ;;
        cudaTensorCoreGemm)
            # requires sm 7.0
            # my GTX 1050M current card is 6.1 :(
            ;;
        simpleTextureDrv)
            # needs simpleTexture_kernel64.ptx or simpleTexture_kernel64.cubin
            ;;
        cudaDecodeGL)
            # segfault
            ;; 
        cuSolverSp_LinearSolver|cuSolverSp_LowlevelCholesky|cuSolverSp_LowlevelQR)
            # missing lap2D_5pt_n100.mtx
            ;;
        cuSolverRf)
            # missing default input file ?
            ;;
        cuSolverDn_LinearSolver)
            # needs gr_900_900_crg.mtx
            ;;
        # cuHook)
        #     ;;
        clock_nvrtc|inlinePTX_nvrtc|matrixMul_nvrtc|BlackScholes_nvrtc|binomialOptions_nvrtc|quasirandomGenerator_nvrtc|simpleAssert_nvrtc|simpleAtomicIntrinsics_nvrtc|vectorAdd_nvrtc|simpleVoteIntrinsics_nvrtc|simpleTemplates_nvrtc)
            # all nvrtc examples fail
            ;;
        recursiveGaussian)
            # needs lena.ppm
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
        FilterBorderControlNPP|boxFilterNPP|cannyEdgeDetectorNPP|freeImageInteropNPP|histEqualizationNPP)
            # needs "Lena.pgm"
            ;;
        FunctionPointers|SobelFilter)
            # needs "lena.pgm"
            ;;
        bilateralFilter)
            # needs some file nature_monte.bmp
            ;;
        c++11_cuda)
            # needs an input text file
            ;;
        HSOpticalFlow)
            # needs frame10.ppm
            ;;
        bicubicTexture|simpleTexture|simpleSurfaceWrite)
            # needs lena_bw.pgm
            ;;
        bindlessTexture)
            # needs flower.ppm
            ;;
        boxFilter)
            # needs lenaRGB.ppm
            ;;
        segmentationTreeThrust)
            # needs test.ppm
            ;;
        simpleAssert)
            # some assertion failed
            ;;
        BiCGStab)
            # TODO: figure out appropriate arguments here
            ;;
        *)
            echo "===== RUNNING $command ====="
            out=$(cuda-samples $command)
            res=$?
            if [ $res -ne 0 ]; then
                echo "$command failed:"
                echo "$out"
            fi
    esac
done

