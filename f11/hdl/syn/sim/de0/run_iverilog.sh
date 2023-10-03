#!/bin/bash -ex
iverilog -c iverilog.cf -o tb_f11.vvp -s tb_f11
vvp -n -v ./tb_f11.vvp
