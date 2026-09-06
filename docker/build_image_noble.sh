#!/bin/bash
cd $(dirname $0)/..
IMG=quay.io/yshestakov/cpu11-tools-noble:latest 
podman build -t $IMG -f docker/Dockerfile.ubuntu-noble . $@
