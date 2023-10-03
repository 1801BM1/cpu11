#!/bin/bash -ex
iverilog -c iverilog.cf -o tb1.vvp -s tb1
vvp -n -v ./tb1.vvp
