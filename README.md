# cuda-samples-snap

This snap provides bundles all CUDA samples from the CUDA SDK into a snap for testing CUDA support in snapd and development of a `cuda-support` interface in snapd.

Currently there are a few samples that don't run successfully, either due to setup files I didn't get setup inside the snap, etc.

Notably all nvrtc CUDA samples fail, I haven't debugged why this is the case though.

## Usage

To test through all samples, you can run:

```bash
cuda-samples test
```

which will report on any failures, etc.

You can also run individual tests or groups of tests, as identified by their directory in the SDK installation. For example to run through all of the simple samples you would do

```bash
cuda-samples 0_Simple
```

Or to do just the `vectorAdd` sample you would run

```bash
cuda-samples vectorAdd
```

## Building

All you need to build the snap is snapcraft. Just run `snapcraft cleanbuild` to do a clean build in a container. Note that the container will download/install the CUDA SDK in it's entirety so it takes quite a while to build. 