`timescale 1ns / 100ps

`define CONFIG_CPU_VM1	 1
`define CONFIG_WBC_CPU   wbc_vm1
`define CONFIG_WBC_MEM   wbc_mem
`ifdef __ICARUS__
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  50_000
  `define CONFIG_OSC_CLOCK  50_000
`elsif XILINX_SIMULATOR
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  5_000
  `define CONFIG_OSC_CLOCK  5_000
  `define CONFIG_SIM_TIME_LIMIT 1_000_000
  `define CONFIG_DCLO_WIDTH_CLK 2
`else
  `define CONFIG_PLL_125   1
  `define CONFIG_WBC_PLL   qa7_pll125
  `define CONFIG_OSC_CLOCK  50_000_000
  `define CONFIG_SYS_CLOCK 125_000_000
`endif
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm1.mif"
`define CPU_TEST_MEMF "../../tst/vm1.mem"
`define CPU_TEST_MEMN "vm1.mem"

// shared config
`include "../../lib/config.v"
