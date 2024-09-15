
`define CONFIG_CPU_LSI   1
`define CONFIG_WBC_CPU   wbc_lsi
`define CONFIG_WBC_MEM   wbc_mem
`define CONFIG_PLL_133   1
`define CONFIG_WBC_PLL   qk7_pll133
`define CONFIG_SYS_CLOCK 133_333_333
`define CONFIG_OSC_CLOCK  50_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define LSI11_FILE_MICROM "../../../../lsi/rom/all_22b.rom"
`define CPU_TEST_FILE "../../../tst/lsi.mif"
`define CPU_TEST_MEMF "../../../tst/lsi.mem"
`define CPU_TEST_MEMN "lsi.mem"

// shared config
`include "../../lib/config.v"
