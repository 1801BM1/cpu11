
`define CONFIG_CPU_AM4   1
`define CONFIG_WBC_CPU   wbc_am4
`define CONFIG_PLL_54    1
`define CONFIG_OSC_CLOCK 27000000
`define CONFIG_SYS_CLOCK 54000000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define M4_FILE_MICROM "../../am4/rom/mc.rom"

`define CPU_TEST_FILE "../../tst/am4.mif"
`define CPU_TEST_MEMF "../../tst/am4.mem"
`define CPU_TEST_MEMN "am4.mem"
