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
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_am4.v}
vlog -vlog01compat -work work +incdir+../../../am4/hdl/wbc/rtl {../../../am4/hdl/wbc/rtl/am4_wb.v}
vlog -vlog01compat -work work +incdir+../../../am4/hdl/wbc/rtl {../../../am4/hdl/wbc/rtl/am4_plm.v}
vlog -vlog01compat -work work +incdir+../../../am4/hdl/wbc/rtl {../../../am4/hdl/wbc/rtl/am4_seq.v}
vlog -vlog01compat -work work +incdir+../../../am4/hdl/wbc/rtl {../../../am4/hdl/wbc/rtl/am4_alu.v}
vlog -vlog01compat -work work +incdir+../syn/db {../syn/db/de0_pll50_altpll.v}
vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_top.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_lsi.v}
vlog -vlog01compat -work work +incdir+../../../am4/hdl/wbc/rtl +define+M4_FILE_MICROM="../../../am4/rom/mc.rom" {../../../am4/hdl/wbc/rtl/am4_mcrom.v}
vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc" -onfinish stop tb1

do wav_am4.do
view structure
view signals
run -all
