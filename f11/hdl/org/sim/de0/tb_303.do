transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/f11.v}
vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/dc_303.v}
vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/dc_rom.v}
vlog -vlog01compat -work work +incdir+../../rtl {../../rtl/dc_pla.v}
vlog -vlog01compat -work work +incdir+../../tbe {../../tbe/tb_plm.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb_303

add wave *
view structure
view signals
run -all
