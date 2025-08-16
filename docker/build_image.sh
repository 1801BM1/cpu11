#!/bin/bash
cd $(dirname $0)/..
podman build -t quay.io/yshestakov/cpu11-tools:latest -f docker/Dockerfile.ubuntu-noble docker/ $@
