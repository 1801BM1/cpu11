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
`define  CONFIG_SYS_CLOCK              80000000

//______________________________________________________________________________
//
// Test software start address
//
`define  CONFIG_SIM_START_ADDRESS      16'o000000

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
// CONFIG_VM2_CORE_FIX_PREFETCH == 0 - no prefetch bugfix applied
// CONFIG_VM2_CORE_FIX_PREFETCH != 0 - prefetch bug is fixed
// Default value (if undefined) - 1
//
`define CONFIG_VM2_CORE_FIX_PREFETCH         1
