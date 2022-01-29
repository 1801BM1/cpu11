//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// Simulation configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  SIM_CONFIG_TIME_LIMIT         20000000
//
// External clock frequency
//
`define  SIM_CONFIG_CLOCK_HPERIOD      10
//
// `define  SIM_CONFIG_DEBUG_MC           1
// `define  SIM_CONFIG_DEBUG_IO           1
`define  SIM_CONFIG_DEBUG_TTY          1

//
// F-11 boot mode
//
// 11 - extended microcode, chip 37, location 76
// 10 - 173000 or start address SIM_START_ADDRESS
// 01 - break into ODT console
// 00 - load vector 24
//
`define  SIM_CONFIG_BOOT_MODE          2'b00

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

//______________________________________________________________________________
//
`define SIM_START_ADDRESS 16'o000000
