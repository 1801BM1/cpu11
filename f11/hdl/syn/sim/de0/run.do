transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/f11.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/dc_302.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/dc_303.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../rtl/dc_304.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/de0_top.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_fpp.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_mmu.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_rom.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_pla.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_pla_0.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_pla_1.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../../wbc/rtl/dc_pla_2.v}

vlog -vlog01compat -work work +incdir+../../syn/de0/../../tbe {../../tbe/de0_tbl.v}

vsim -t 1ps -L rtl_work -L work -voptargs="+acc" -onfinish stop tb_f11

do wave.do
view structure
view signals
run -all
