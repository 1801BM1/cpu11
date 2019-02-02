## Generated SDC file "vm1.out.sdc"

## Copyright (C) 1991-2012 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 12.1 Build 243 01/31/2013 Service Pack 1 SJ Full Version"

## DATE    "Thu Mar 12 20:30:05 2015"

##
## DEVICE  "EP3C16F484C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {de0_clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {clk_p} -source [get_pins {corepll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {clk} [get_pins {corepll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {clk_n} -source [get_pins {corepll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase 180.000 -master_clock {clk} [get_pins {corepll|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk_n}] -rise_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_n}] -fall_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_n}] -rise_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_n}] -fall_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_n}] -rise_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_n}] -fall_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_n}] -rise_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_n}] -fall_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_p}] -rise_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_p}] -fall_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_p}] -rise_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk_p}] -fall_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_p}] -rise_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_p}] -fall_to [get_clocks {clk_n}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_p}] -rise_to [get_clocks {clk_p}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk_p}] -fall_to [get_clocks {clk_p}]  0.020  
