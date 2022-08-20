//
// Copyright (c) 2014-2017 by 1801BM1@gmail.com
//
// Simulation configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  SIM_CONFIG_TIME_LIMIT         5000000
//
// External clock frequency
//
`define  SIM_CONFIG_CLOCK_HPERIOD      5
//
//`define  SIM_CONFIG_DEBUG_MC           1
//`define  SIM_CONFIG_DEBUG_IO           1
`define  SIM_CONFIG_DEBUG_TTY          1
//
// The amount clki clocks to delay RPLY for DIN to reproduce the (PC)
// prefetch bug. Value 6 or more should be specified, 0 for maximal speed.
//
`define  SIM_CONFIG_PREFETCH_BUG       0

//______________________________________________________________________________
//
// External oscillator clock, feeds the PLLs
//
`define  OSC_CLOCK                  50000000
//
// Global system clock
//
`define  SYS_CLOCK                  50000000

//______________________________________________________________________________
//
// Reset button debounce interval (in ms))
//
`define  RESET_BUTTON_DEBOUNCE_MS   5
//
// Internal reset pulse width (in system clocks)
//
`define  RESET_PULSE_WIDTH_CLK      7
