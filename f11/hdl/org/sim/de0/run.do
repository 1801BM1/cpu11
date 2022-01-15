transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/f11.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_pla.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_delay.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_302.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_303.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_304.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/tbe {E:/GIT/cpu11/f11/hdl/org/tbe/de0_top.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/rtl {E:/GIT/cpu11/f11/hdl/org/rtl/dc_rom.v}

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/f11/hdl/org/syn/de0/../../tbe {E:/GIT/cpu11/f11/hdl/org/syn/de0/../../tbe/de0_tbl.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb_f11

add wave *
view structure
view signals
run -all
