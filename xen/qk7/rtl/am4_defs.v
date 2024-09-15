
`define CONFIG_CPU_AM4   1
`define CONFIG_WBC_CPU   wbc_am4
`define CONFIG_WBC_MEM   wbc_mem
`define CONFIG_WBC_PLL   qk7_pll115
`define CONFIG_PLL_115   1
`define CONFIG_SYS_CLOCK 115_000_000
`define CONFIG_OSC_CLOCK  50_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

// `define M4_FILE_MICROM "../../../../am4/rom/mc.mif"
`define M4_FILE_MICROM "mc.rom"

`define CPU_TEST_FILE "../../tst/am4.mif"
`define CPU_TEST_MEMF "../../tst/am4.mem"
`define CPU_TEST_MEMN "am4.mem"

// shared config
`include "../../lib/config.v"
