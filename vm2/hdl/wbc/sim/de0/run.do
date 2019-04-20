transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../lib/de0 {../../rtl/vm2_wb.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../rtl/vm2_plm.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/de0/config.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/de0/de0_alib.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/de0/de0_top.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/wbc_uart.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/wbc_vic.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../lib/wbc_rst.v}
vlog -vlog01compat -work work +incdir+../../lib/de0 {../../tbe/de0_tb2.v}
vlog -vlog01compat -work work +incdir+../../syn/de0/db {../../syn/de0/db/de0_pll100_altpll.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb2

do wave.do
view structure
view signals
run -all
