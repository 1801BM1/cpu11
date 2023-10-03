#!/bin/bash -ex
iverilog -c iverilog.cf -o tb_lsi.vvp -s tbl
vvp -n -v ./tb_lsi.vvp

