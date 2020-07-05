transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../rtl {../../lib/config.v}
vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_alib.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_vic.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_uart.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_rst.v}
vlog -vlog01compat -work work +incdir+../../../lsi/hdl/wbc/rtl {../../../lsi/hdl/wbc/rtl/lsi_wb.v}
vlog -vlog01compat -work work +incdir+../../../lsi/hdl/wbc/rtl {../../../lsi/hdl/wbc/rtl/mcp_plm.v}
vlog -vlog01compat -work work +incdir+../../../lsi/hdl/wbc/rtl {../../../lsi/hdl/wbc/rtl/mcp1611.v}
vlog -vlog01compat -work work +incdir+../../../lsi/hdl/wbc/rtl {../../../lsi/hdl/wbc/rtl/mcp1621.v}
vlog -vlog01compat -work work +incdir+../syn/db {../syn/db/de0_pll75_altpll.v}
vlog -vlog01compat -work work +incdir+../rtl {../de0_top.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_lsi.v}
vlog -vlog01compat -work work +incdir+../../../lsi/hdl/wbc/rtl +define+LSI11_FILE_MICROM="../../../lsi/rom/all_22b.rom" {../../../lsi/hdl/wbc/rtl/mcp1631.v}

vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb1

do wav_lsi.do
view structure
view signals
run -all
