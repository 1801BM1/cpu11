transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/vm3.v}
vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/vm3_qbus.v}
vlog -vlog01compat -work work +incdir+../../../wbc/rtl {../../../wbc/rtl/vm3_plm.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/config.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/de0_tb3.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb3

do wave.do
view structure
view signals
run -all
