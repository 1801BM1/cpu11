#!/bin/bash
if [ $# -eq 0 ] ; then
    echo "Usage: $0 qa7-CPU.tcl" >&2
    exit 1
fi
vivado -mode batch -source $1
