//
// Copyright (c) 2014-2025 by 1801BM1@gmail.com
//
// Simulation configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  SIM_CONFIG_TIME_LIMIT         15000000
//
// External clock frequency
//
`define  SIM_CONFIG_CLOCK_HPERIOD      5
//`define  SIM_CONFIG_DEBUG_IO           1
`define  SIM_CONFIG_DEBUG_TTY          1

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

//______________________________________________________________________________
//
// Mode selection (removed in synchronous model - static 16-bit only)
//
// 0  1 - COUT is processor clock phase W
//    0 - COUT is constant clock
//
// 1  1 - standard microcycle
//    0 - long microcycle
//
// 8  1 - delayed read/write (on CAS)
//    0 - normal read/write (on RAS)
//
// 9  1 - static memory
//    0 - dynamic memory
//
// 10 1 - 4K/16K memory
//    0 - 64K memory
//
// 11 1 - 8-bit bus
//    0 - 16-bit bus
//
// 12 1 - User mode
//    0 - Test mode
//
// 15:13 - start/restart address
//    000 - 140000
//    001 - 100000
//    010 - 040000
//    011 - 020000
//    100 - 010000
//    101 - 000000
//    110 - 173000
//    111 - 172000
//
`ifndef MODE_SELECT_START_ADDR
`define MODE_SELECT_START_ADDR      5
`endif

`ifndef SIM_CONFIG_MODE_SELECT
`define SIM_CONFIG_MODE_SELECT      (`MODE_SELECT_START_ADDR << 13)
`endif
