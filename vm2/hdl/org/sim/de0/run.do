transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/vm2_qbus.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/vm2_plm.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/vm2.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/config.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/de0_tb2.v}

vsim -t 1ps -L rtl_work -L work -voptargs="+acc" -onfinish stop tb2
set RunLength 500ns

do wave.do
view structure
view signals
run -all
