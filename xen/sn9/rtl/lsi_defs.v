
`define CONFIG_CPU_LSI   1
`define CONFIG_WBC_CPU   wbc_lsi
`define CONFIG_PLL_54    1
`define CONFIG_OSC_CLOCK 27000000
`define CONFIG_SYS_CLOCK 54000000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define LSI11_FILE_MICROM "../../lsi/rom/all_22b.rom"
`define CPU_TEST_FILE "../../tst/lsi.mif"
`define CPU_TEST_MEMF "../../tst/lsi.mem"
`define CPU_TEST_MEMN "lsi.mem"
