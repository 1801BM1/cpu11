#!/bin/bash -ex
iverilog -c iverilog.cf -o tb4.vvp -s tb4
vvp -n -v ./tb4.vvp
