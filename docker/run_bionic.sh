#!/bin/bash
ROOT=$(realpath $(dirname $0)/..)
WD=$(realpath $(pwd))
IMG=quay.io/yshestakov/cpu11-tools-bionic:latest
MODELSIM_DIR="${MODELSIM_DIR:-/tank/modelsim-q13/13.0sp1/modelsim_ase}"
podman run --rm -ti  \
        -v "$ROOT:/work" \
        -v "$MODELSIM_DIR:/modelsim" \
        -e "EXT_ROOT=$ROOT" \
        -e "WD=$WD" \
        $IMG  \
        /bin/bash "$@"
