
`define CONFIG_CPU_F11	 1
`define CONFIG_WBC_CPU   wbc_f11
`define CONFIG_WBC_MEM   wbc_mem_32k
`define CONFIG_PLL_54	 1
`define CONFIG_OSC_CLOCK 27000000
`define CONFIG_SYS_CLOCK 54000000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/f11.mif"
`define CPU_TEST_MEMF "../../tst/f11.mem"
`define CPU_TEST_MEMN "f11.mem"
`define F11_FILE_MICROM_000 "../../f11/rom/000.rom"
`define F11_FILE_MICROM_001 "../../f11/rom/001.rom"
`define F11_FILE_MICROM_002 "../../f11/rom/002.rom"