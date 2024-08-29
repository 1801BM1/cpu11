//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.8 
//Created Time: 2024-08-24 01:28:10
#create_clock -name sys_clk_p -period 18.519 -waveform {0 9.259} [get_nets {sys_clk_p}]
#create_clock -name n4k_clk_27 -period 37.037 -waveform {0 18.518} [get_ports {n4k_clk_27}] -add
# 37.037 ns -> 27.000027 MHz
create_clock -name sys_clock_27 -period 37.037 -waveform {0 18.518} [get_ports {sys_clock_27}] -add
