//
// Copyright (c) 2014-2023 by 1801BM1@gmail.com
//
// Simulation configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  SIM_CONFIG_TIME_LIMIT         10000000
//
// External clock frequency
//
`define  SIM_CONFIG_CLOCK_HPERIOD      10
//
// `define  SIM_CONFIG_DEBUG_MC           1
// `define  SIM_CONFIG_DEBUG_IO           1
`define  SIM_CONFIG_DEBUG_TTY          1

//
// 1801VM3 boot mode
//
// 1x - start from 173000
// 0x - load vector 24
//
`define  SIM_CONFIG_BOOT_MODE          2'b00

//______________________________________________________________________________
//
// These parameters can be defined externally by the CI script
//
`define  SIM_CONFIG_SLOW_QBUS          0

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
`define RESET_BUTTON_DEBOUNCE_MS   5
//
// Internal reset pulse width (in system clocks)
//
`define RESET_PULSE_WIDTH_CLK      7

