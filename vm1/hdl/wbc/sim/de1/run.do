transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/de1/config.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../rtl/vm1_wb.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../rtl/vm1_tve.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../rtl/vm1_plm.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/de1/vm1_alib.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/de1/de1_alib.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/de1/de1_top.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/wbc_uart.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/wbc_vic.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../lib/wbc_rst.v}
vlog -vlog01compat -work work +incdir+../../lib/de1 {../../tbe/de1_tb1.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneii_ver -L rtl_work -L work -voptargs="+acc"  tb1

do wave.do
view structure
view signals
run -all
