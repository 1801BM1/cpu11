## Generated SDC file "de2-115.out.sdc"

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
## VERSION "Version 12.1 Build 243 01/31/2013 Service Pack 1 SJ Web Edition"

## DATE    "Fri Feb 01 11:27:04 2019"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {de2_clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {corepll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {corepll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -master_clock {clk} [get_pins {corepll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {corepll|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {corepll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50.000 -multiply_by 2 -phase 180.000 -master_clock {clk} [get_pins {corepll|altpll_component|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.020  


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

