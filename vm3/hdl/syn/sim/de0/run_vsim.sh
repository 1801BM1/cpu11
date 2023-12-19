#!/bin/bash -e
SCRIPT_DIR=$(dirname $(readlink -f $0))
cd $SCRIPT_DIR
vsim -c -onfinish exit -do "run.do"
