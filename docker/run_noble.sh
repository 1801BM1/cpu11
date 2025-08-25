#!/bin/bash
ROOT=$(realpath $(dirname $0)/..)
WD=$(realpath $(pwd))
podman run --rm -ti  \
	-v "$ROOT:/work" \
	-e "EXT_ROOT=$ROOT" \
	-e "WD=$WD" \
	quay.io/yshestakov/cpu11-tools-noble:latest  \
	/bin/bash "$@"
