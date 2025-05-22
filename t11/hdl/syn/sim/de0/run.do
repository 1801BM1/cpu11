transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/config.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/de0_tb1.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/t11_plm.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/t11.v}

vsim -t 1ps -L rtl_work -L work -voptargs="+acc" -onfinish stop tb_t11

do wave.do
view structure
view signals
run -all
