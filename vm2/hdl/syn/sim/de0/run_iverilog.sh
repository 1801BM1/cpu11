#!/bin/bash -ex
iverilog -c iverilog.cf -o tb2.vvp -s tb2
vvp -n -v ./tb2.vvp
