
`define CONFIG_CPU_VM3	 1
`define CONFIG_WBC_CPU   wbc_vm3
`define CONFIG_WBC_MEM   wbc_mem_32k
`define CONFIG_MEM_32K   1
`ifdef __ICARUS__
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  50_000
  `define CONFIG_OSC_CLOCK  50_000
`elsif XILINX_SIMULATOR
  `define CONFIG_WBC_PLL	xsimpll
  `define CONFIG_SYS_CLOCK  50_000_000
  `define CONFIG_OSC_CLOCK  50_000_000
`else
  `define CONFIG_PLL_85    1
  `define CONFIG_WBC_PLL   qa7_pll85
  `define CONFIG_SYS_CLOCK  85_000_000
`endif
`define CONFIG_OSC_CLOCK  50_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm3.mif"
`define CPU_TEST_MEMF "../../tst/vm3.mem"
`define CPU_TEST_MEMN "vm3.mem"

// shared config
`include "../../lib/config.v"
