//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Project configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
`define  _CONFIG_                      1
//
// CAUTION: CONFIG_SIM_FAST_RESET should be undefined in release version
// Defining this parameter shorts the system reset time intervals and
// provides much quicker simulation
//
`define  CONFIG_SIM_FAST_RESET         _CONFIG_
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  CONFIG_SIM_TIME_LIMIT         5000000
//
// External clock frequency
//
`define  CONFIG_SIM_CLOCK_HPERIOD      5
//
// Test software start address
//
`define  CONFIG_SIM_START_ADDRESS      16'o000000

//______________________________________________________________________________
//
// External oscillator clock, feeds the PLLs
//
`define  CONFIG_OSC_CLOCK              50000000
//
// Global system clock
//
`define  CONFIG_SYS_CLOCK              100000000

//______________________________________________________________________________
//
//`define  CONFIG_SIM_DEBUG_MC         _CONFIG_
//`define  CONFIG_SIM_DEBUG_IO         _CONFIG_
`define  CONFIG_SIM_DEBUG_TTY          _CONFIG_

//______________________________________________________________________________
//
// Reset button debounce interval (in ms))
//
`define  CONFIG_RESET_BUTTON_DEBOUNCE_MS   5
//
// Internal reset pulse width (in system clocks)
//
`define  CONFIG_RESET_PULSE_WIDTH_CLK      15

//______________________________________________________________________________
//
// CONFIG_VM2_CORE_FIX_PREFETCH == 0 - no prefetch bugfix applied
// CONFIG_VM2_CORE_FIX_PREFETCH != 0 - prefetch bug is fixed
// Default value (if undefined) - 1
//
`define CONFIG_VM2_CORE_FIX_PREFETCH         1
