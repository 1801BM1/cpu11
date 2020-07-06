## Generated SDC file "de1.sdc"

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

## DATE    "Mon Jul 06 21:54:07 2020"

##
## DEVICE  "EP2C20F484C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {de1_clock_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {de1_clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {corepll|altpll_component|pll|clk[0]} -source [get_pins {corepll|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -master_clock {de1_clock_50} [get_pins {corepll|altpll_component|pll|clk[0]}] 
create_generated_clock -name {corepll|altpll_component|pll|clk[1]} -source [get_pins {corepll|altpll_component|pll|inclk[0]}] -duty_cycle 50.000 -multiply_by 1 -phase 180.000 -master_clock {de1_clock_50} [get_pins {corepll|altpll_component|pll|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_keepers {*:cpu|wbc_rst:reset|key_long}] -to [get_keepers {*:cpu|wbc_rst:reset|key_syn*}]
set_false_path -from [get_keepers {*:cpu|wbc_rst:reset|key_down}] -to [get_keepers {*:cpu|wbc_rst:reset|key_syn*}]
set_false_path -from [get_cells {*:cpu|wbc_rst:reset|pwr_event}] 


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

