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
//`define SIM_CONFIG_DEBUG_RDY            1
//`define  SIM_CONFIG_DEBUG_DMR          1
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
// Mode selection
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
`ifndef MODE_SELECT_COUT_PHASE_W
`define MODE_SELECT_COUT_PHASE_W    1
`endif

`ifndef MODE_SELECT_STD_CYCLE
`define MODE_SELECT_STD_CYCLE       1
`endif

`ifndef MODE_SELECT_DELAYED_RW
`define MODE_SELECT_DELAYED_RW      0
`endif

`ifndef MODE_SELECT_STATIC_MEMORY
`define MODE_SELECT_STATIC_MEMORY   1
`endif

`ifndef MODE_SELECT_4K_16K_MEMORY
`define MODE_SELECT_4K_16K_MEMORY   0
`endif

`ifndef MODE_SELECT_8BIT_BUS
`define MODE_SELECT_8BIT_BUS        0
`endif

`ifndef MODE_SELECT_USER_MODE
`define MODE_SELECT_USER_MODE       1
`endif

`ifndef MODE_SELECT_START_ADDR
`define MODE_SELECT_START_ADDR      5
`endif

`ifndef SIM_CONFIG_MODE_SELECT
`define SIM_CONFIG_MODE_SELECT      ( (`MODE_SELECT_START_ADDR << 13) \
                                    | (`MODE_SELECT_COUT_PHASE_W   ? 16'o000001 : 16'o000000) \
                                    | (`MODE_SELECT_STD_CYCLE      ? 16'o000002 : 16'o000000) \
                                    | (`MODE_SELECT_DELAYED_RW     ? 16'o000400 : 16'o000000) \
                                    | (`MODE_SELECT_STATIC_MEMORY  ? 16'o001000 : 16'o000000) \
                                    | (`MODE_SELECT_4K_16K_MEMORY  ? 16'o002000 : 16'o000000) \
                                    | (`MODE_SELECT_8BIT_BUS       ? 16'o004000 : 16'o000000) \
                                    | (`MODE_SELECT_USER_MODE      ? 16'o010000 : 16'o000000) )

`endif
