
`define CONFIG_CPU_VM2	 1
`define CONFIG_WBC_CPU   wbc_vm2
`define CONFIG_WBC_MEM   wbc_mem
`define CONFIG_PLL_150   1
`define CONFIG_WBC_PLL   qk7_pll150
`define CONFIG_OSC_CLOCK  50000000
`define CONFIG_SYS_CLOCK 150000000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm2.mif"
`define CPU_TEST_MEMF "../../tst/vm2.mem"
`define CPU_TEST_MEMN "vm2.mem"
