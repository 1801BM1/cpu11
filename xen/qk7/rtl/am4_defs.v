
`define CONFIG_CPU_AM4   1
`define CONFIG_WBC_CPU   wbc_am4
`define CONFIG_WBC_MEM   wbc_mem
`define CONFIG_WBC_PLL   qk7_pll125
`define CONFIG_PLL_125    1
`define CONFIG_OSC_CLOCK  50_000_000
`define CONFIG_SYS_CLOCK 125_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define M4_FILE_MICROM "../../../../am4/rom/mc.mif"

`define CPU_TEST_FILE "../../tst/am4.mif"
`define CPU_TEST_MEMF "../../tst/am4.mem"
`define CPU_TEST_MEMN "am4.mem"
