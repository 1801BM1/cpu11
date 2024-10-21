
`define CONFIG_CPU_AM4   1
`define CONFIG_WBC_CPU   wbc_am4
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
  `define CONFIG_WBC_PLL   qa7_pll85
  `define CONFIG_PLL_85    1
  `define CONFIG_SYS_CLOCK 85_000_000
`endif
`define CONFIG_OSC_CLOCK 50_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`ifndef M4_FILE_MICROM
// `define M4_FILE_MICROM "../../../../am4/rom/mc.mif"
  `define M4_FILE_MICROM "mc.rom"
`endif
`ifndef CPU_TEST_MEMF
  `define CPU_TEST_MEMF "../../tst/am4.mem"
`endif
`define CPU_TEST_FILE "../../tst/am4.mif"
`define CPU_TEST_MEMN "am4.mem"

// shared config
`include "../../lib/config.v"
