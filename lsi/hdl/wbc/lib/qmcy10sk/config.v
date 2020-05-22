//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
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
`define  CONFIG_SIM_TIME_LIMIT         50000000
//
// External clock frequency
//
`define  CONFIG_SIM_CLOCK_HPERIOD      5
//
// LSI-11 boot mode
//
// 00 - start reserved MicROM
// 01 - start from 173000
// 10 - break into ODT
// 11 - load vector 24
//
`define  SIM_CONFIG_BOOT_MODE          2'b11

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
