
`define CONFIG_CPU_VM1	 1
`define CONFIG_WBC_CPU   wbc_vm1
`define CONFIG_WBC_MEM   wbc_mem
`define CONFIG_PLL_175   1
`define CONFIG_WBC_PLL   qk7_pll175
`define CONFIG_OSC_CLOCK  50_000_000
`define CONFIG_SYS_CLOCK 175_000_000
`define CONFIG_SLOW_DIV  (`CONFIG_SYS_CLOCK / 5000000)

`define CPU_TEST_FILE "../../tst/vm1.mif"
`define CPU_TEST_MEMF "../../tst/vm1.mem"
`define CPU_TEST_MEMN "vm1.mem"
