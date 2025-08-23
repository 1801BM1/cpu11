# Development env in Docker
The goal of creating such Docker container is to enable automated build and
tests running as part of CI workflow.

# What is added to the container

* SIMH 4.0-pre with `EXPECT/SEND` commands added, only `pdp11` binary
* `rt11dsk` tool by Zeemen to copy in/out files into RL02 disks
* `dectape` tool by by Bob Frazier to copy in/out files using "DEC tape" aka `MT0` device in RT-11
* RT-11 v5.3 (free for hobby use in SIMH), installed OS in the `rt11os.dsk` image
* Icarus Verilog to run test benches (Ubuntu 24.04 based image).
* a few 32-bit runtime libraries to run ModelSim 10.1d from Quartus 13 (externally mounted to the container)

# Docker image build flow

1. Create intermedita `builder` image to compile SIMH, `dectape` and `rt11dsk` from sources
2. Create final `worker` image, copy binaries from the `builder` image
3. Download Mentec software kit (RT11 V5.3) distributed as RL02 image
4. Automated installation of RT11 according to the
   [Installing RT-11 5.3 on SIMH](https://gunkies.org/wiki/Installing_RT-11_5.3_on_SIMH) document
5. Copying a few helper scripts into the image including `comp_mac2sav.sh`

The process is scripted into `docker/build_image.sh` script and it used Podman tool.
It should work with `docker` tool as well:

```sh
docker build -t quay.io/yshestakov/cpu11-tools-noble:latest -f docker/Dockerfile.ubuntu-noble ./ 
```

Resulting Docker image could be fetched from 
[Quay.io/yshestakov/cp11-tools](https://quay.io/repository/yshestakov/cpu11-tools?tab=tags&tag=latest)

# Usage

How to run the container and get interfactive shell (`docker` could be used instead of `podman`):

```
    podman run --rm -ti  \
        -v $(pwd):/work \
        quay.io/yshestakov/cpu11-tools-noble:latest  \
        /bin/bash $@
```


## Compile `test.mac` for T11 as an example


```sh
cd t11/tst
../../docker/run_noble.sh /work/docker/comp_mac2sav.sh test.mac
```

Resulting files will be storede in `t11/tst/out` relative to root of checked out `cpu11.git` repo

## Run Icarus Verilog for T11

```sh
cd ~/work/cpu11/t11/hdl/syn/sim/de0
~/work/cpu11/docker/run_noble.sh -c 'cd /work/t11/hdl/syn/sim/de0; ./run_iverilog.sh'
```

Need to note that `~/work/cpu11` is the directory where `cpu11.git` is checked out



