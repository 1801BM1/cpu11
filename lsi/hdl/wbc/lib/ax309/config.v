//
// Project configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps

//______________________________________________________________________________
//
// External oscillator clock, feeds the PLLs
//
`define  CONFIG_OSC_CLOCK              50000000
//
// Global system clock
//
`define  CONFIG_SYS_CLOCK              66666667

//______________________________________________________________________________
//
// Reset button debounce interval (in ms))
//
`define  CONFIG_RESET_BUTTON_DEBOUNCE_MS  5
//
// Internal reset pulse width (in system clocks)
//
`define  CONFIG_RESET_PULSE_WIDTH_CLK     15
`define  CONFIG_DCLO_WIDTH_CLK            15
`define  CONFIG_ACLO_DELAY_CLK            7

//______________________________________________________________________________
//
// LSI-11 boot mode
//
// 00 - start reserved MicROM
// 01 - start from 173000
// 10 - break into ODT
// 11 - load vector 24
//
`define  SIM_CONFIG_BOOT_MODE          2'b11

