//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Project configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
`define  _CONFIG_                      1

//
// Simulation stops (breakpoint) after this time elapsed
//
`ifdef __ICARUS__
// under Icarus Verilog 100k ticks takes ~ 46 seconds on my Macbook M1 Pro
`define  CONFIG_SIM_TIME_LIMIT         100000
`else
// execute by ModelSim
`define  CONFIG_SIM_TIME_LIMIT         2000000
`endif
//
// External clock frequency
//
`define  CONFIG_SIM_CLOCK_HPERIOD      5

//
// Generated processor clock phase durations
// In system clocks
//
`define  CONFIG_SIM_CLK_HIGH           _CONFIG_
`define  CONFIG_SIM_CLK_LOW            _CONFIG_

// `define  CONFIG_SIM_DEBUG_MC        _CONFIG_
// `define  CONFIG_SIM_DEBUG_IO        _CONFIG_
`define  CONFIG_SIM_DEBUG_TTY          _CONFIG_

//______________________________________________________________________________
//
// External oscillator clock, feeds the PLLs
//
`define  CONFIG_OSC_CLOCK              50000000
//
// Global system clock
//
`define  CONFIG_SYS_CLOCK              50000000

//______________________________________________________________________________
//
// Reset button debounce interval (in ms))
//
`define  RESET_BUTTON_DEBOUNCE_MS      5
//
// Internal reset pulse width (in system clocks)
//
`define  RESET_PULSE_WIDTH_CLK         7

//______________________________________________________________________________
//
`define  CONFIG_SIM_START_ADDRESS      16'o000000

//______________________________________________________________________________
//
// CONFIG_VM1_CORE_REG_USES_RAM == 0 - VM1 core uses RAM block for register file
// CONFIG_VM1_CORE_REG_USES_RAM != 0 - VM1 core uses flip-flops for register file
// Default value (if undefined)- 1
//
`define CONFIG_VM1_CORE_REG_USES_RAM         1
//
// CONFIG_VM1_CORE_MULG_VERSION == 0 - VM1 core implements microprogram revision A
// CONFIG_VM1_CORE_MULG_VERSION != 0 - VM1 core implements microprogram revision G
// Default value (if undefined) - 0
//
`define CONFIG_VM1_CORE_MULG_VERSION         0
