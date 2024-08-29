
`define CONFIG_CPU_VM1	 1
`define CONFIG_WBC_CPU   wbc_vm1
`define CONFIG_PLL_54	 1
`define CONFIG_OSC_CLOCK 27000000
`define CONFIG_SYS_CLOCK 54000000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm1.mif"
`define CPU_TEST_MEMF "../../tst/vm1.mem"
`define CPU_TEST_MEMN "vm1.mem"
