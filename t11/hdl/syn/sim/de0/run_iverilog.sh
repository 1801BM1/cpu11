#!/bin/bash -ex
iverilog -c iverilog.cf -o tb_t11.vvp -s tb_t11
vvp -n -v ./tb_t11.vvp
