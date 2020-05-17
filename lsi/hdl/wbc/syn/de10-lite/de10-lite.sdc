## Generated SDC file "de10-lite.out.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.0.0 Build 614 04/24/2018 SJ Standard Edition"

## DATE    "Sun May 17 22:55:09 2020"

##
## DEVICE  "10M50DAF484C7G"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk} -period 20.000 -waveform { 0.000 10.000 } [get_ports {de10_clock_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {corepll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {corepll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 4 -divide_by 3 -master_clock {clk} [get_pins {corepll|altpll_component|auto_generated|pll1|clk[0]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.140  
set_clock_uncertainty -rise_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.200  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.140  
set_clock_uncertainty -rise_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.200  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {clk}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.140  
set_clock_uncertainty -fall_from [get_clocks {clk}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.200  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -setup 0.140  
set_clock_uncertainty -fall_from [get_clocks {clk}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -hold 0.200  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.040  
set_clock_uncertainty -rise_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.040  
set_clock_uncertainty -fall_from [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {corepll|altpll_component|auto_generated|pll1|clk[0]}]  0.040  


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

