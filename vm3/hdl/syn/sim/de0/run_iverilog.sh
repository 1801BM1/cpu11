#!/bin/bash -ex
iverilog -c iverilog.cf -o tb3.vvp -s tb3
vvp -n -v ./tb3.vvp
