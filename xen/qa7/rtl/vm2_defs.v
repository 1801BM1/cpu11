
`define CONFIG_CPU_VM2	 1
`define CONFIG_WBC_CPU   wbc_vm2
`define CONFIG_WBC_MEM   wbc_mem
`ifdef __ICARUS__
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  50_000
  `define CONFIG_OSC_CLOCK  50_000
`elsif XILINX_SIMULATOR
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  50_000_000
  `define CONFIG_OSC_CLOCK  50_000_000
`else
  `define CONFIG_PLL_105   1
  `define CONFIG_WBC_PLL   qa7_pll105
  `define CONFIG_SYS_CLOCK 105_000_000
  `define CONFIG_OSC_CLOCK  50_000_000
`endif
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm2.mif"
`define CPU_TEST_MEMF "../../tst/vm2.mem"
`define CPU_TEST_MEMN "vm2.mem"

// shared config
`include "../../lib/config.v"
