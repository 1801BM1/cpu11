transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib/de0 {E:/GIT/cpu11/lsi/hdl/wbc/lib/de0/config.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib/de0 {E:/GIT/cpu11/lsi/hdl/wbc/lib/de0/de0_alib.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib {E:/GIT/cpu11/lsi/hdl/wbc/lib/wbc_vic.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib {E:/GIT/cpu11/lsi/hdl/wbc/lib/wbc_uart.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib {E:/GIT/cpu11/lsi/hdl/wbc/lib/wbc_rst.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/rtl {E:/GIT/cpu11/lsi/hdl/wbc/rtl/lsi_wb.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/rtl {E:/GIT/cpu11/lsi/hdl/wbc/rtl/mcp1611.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/rtl {E:/GIT/cpu11/lsi/hdl/wbc/rtl/mcp1621.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/rtl {E:/GIT/cpu11/lsi/hdl/wbc/rtl/mcp_plm.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/syn/de0/db {E:/GIT/cpu11/lsi/hdl/wbc/syn/de0/db/de0_pll50_altpll.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/lib/de0 {E:/GIT/cpu11/lsi/hdl/wbc/lib/de0/de0_top.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/rtl {E:/GIT/cpu11/lsi/hdl/wbc/rtl/mcp1631.v}

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/lsi/hdl/wbc/syn/de0/../../tbe {E:/GIT/cpu11/lsi/hdl/wbc/syn/de0/../../tbe/de0_tb2.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb2

add wave *
view structure
view signals
run -all
