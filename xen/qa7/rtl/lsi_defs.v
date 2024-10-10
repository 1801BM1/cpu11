
`define CONFIG_CPU_LSI   1
`define CONFIG_WBC_CPU   wbc_lsi
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
  `define CONFIG_PLL_85   1
  `define CONFIG_WBC_PLL   qa7_pll85
  `define CONFIG_OSC_CLOCK  50_000_000
  `define CONFIG_SYS_CLOCK  85_000_000
`endif
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`ifndef LSI11_FILE_MICROM
  // `define LSI11_FILE_MICROM "../../../../lsi/rom/all_22b.rom"
  `define LSI11_FILE_MICROM "all_22b.rom"
`endif
`define CPU_TEST_FILE "../../../tst/lsi.mif"
`ifndef CPU_TEST_MEMF
  `define CPU_TEST_MEMF "../../../tst/lsi.mem"
`endif
`define CPU_TEST_MEMN "lsi.mem"

// shared config
`include "../../lib/config.v"
