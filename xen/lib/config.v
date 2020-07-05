//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Project configuration parameters
//______________________________________________________________________________
//
`timescale 1ns / 100ps
//
// CPU selector - only one of available CPU type must be defined
//
`define CONFIG_CPU_VM1        1

//`define CONFIG_CPU_VM1      1
//`define CONFIG_CPU_VM2      1
//`define CONFIG_CPU_LSI      1
//
//
// PLL selector - only one of available PLL type must be defined
// The appropriate .sdc file musy be copied to provide constraints
//
`define  CONFIG_PLL_100       1

// `define  CONFIG_PLL_50     1
// `define  CONFIG_PLL_75     1
// `define  CONFIG_PLL_100    1
//______________________________________________________________________________
//
// Simulation stops (breakpoint) after this time elapsed
//
`define  CONFIG_SIM_TIME_LIMIT      5000000
//
// External clock frequency
//
`define  CONFIG_SIM_CLOCK_HPERIOD   5

//______________________________________________________________________________
//
// External oscillator clock, feeds the PLLs
//
`define  CONFIG_OSC_CLOCK     50000000
//
// Global system clock
//
`ifdef   CONFIG_PLL_50
`define  CONFIG_SYS_CLOCK     50000000
`endif

`ifdef   CONFIG_PLL_66
`define  CONFIG_SYS_CLOCK     66666666
`endif

`ifdef   CONFIG_PLL_75
`define  CONFIG_SYS_CLOCK     75000000
`endif

`ifdef   CONFIG_PLL_100
`define  CONFIG_SYS_CLOCK     100000000
`endif

`define  CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

//______________________________________________________________________________
//
`ifdef CONFIG_CPU_VM1
`define CPU_TEST_FILE "../../tst/vm1.mif"
`endif

`ifdef CONFIG_CPU_VM2
`define CPU_TEST_FILE "../../tst/vm2.mif"
`endif

`ifdef CONFIG_CPU_LSI
`define CPU_TEST_FILE "../../tst/lsi.mif"
`endif

//______________________________________________________________________________
//
// Reset button debounce interval (in ms))
//
`define CONFIG_RESET_BUTTON_DEBOUNCE_MS   5
//
// Internal reset pulse width (in system clocks)
//
`define CONFIG_RESET_PULSE_WIDTH_CLK      15
`define CONFIG_DCLO_WIDTH_CLK             15
`define CONFIG_ACLO_DELAY_CLK             7

//______________________________________________________________________________
//
// Test software start address
//
`define CONFIG_RESET_START_ADDRESS        16'o000000
//
// LSI-11 boot mode
//
// 00 - start reserved MicROM
// 01 - start from 173000
// 10 - break into ODT
// 11 - load vector 24
//
`define CONFIG_LSI_BOOT_MODE              2'b11
//
// Test UART baud rate
//
`define CONFIG_BAUD_RATE                  115200
//
// System timer tick in microseconds
//
`define CONFIG_TIMER_TICK                 20000

//______________________________________________________________________________
//
// CONFIG_VM1_CORE_REG_USES_RAM == 0 - VM1 core uses RAM block for register file
// CONFIG_VM1_CORE_REG_USES_RAM != 0 - VM1 core uses flip-flops for register file
// Default value (if undefined) - 1
//
`define CONFIG_VM1_CORE_REG_USES_RAM         1
//
// CONFIG_VM1_CORE_MULG_VERSION == 0 - VM1 core implements microprogram revision A
// CONFIG_VM1_CORE_MULG_VERSION != 0 - VM1 core implements microprogram revision G
// Default value (if undefined) - 0
//
`define CONFIG_VM1_CORE_MULG_VERSION         0

//______________________________________________________________________________
//
// CONFIG_VM2_CORE_FIX_PREFETCH == 0 - no prefetch bugfix applied
// CONFIG_VM2_CORE_FIX_PREFETCH != 0 - prefetch bug is fixed
// Default value (if undefined) - 1
//
`define CONFIG_VM2_CORE_FIX_PREFETCH         0
