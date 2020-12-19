transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/tbe {E:/GIT/cpu11/am4/hdl/syn/tbe/config.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4_alu.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4_seq.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4_plm.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4_mcrom.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/rtl {E:/GIT/cpu11/am4/hdl/syn/rtl/am4_delay.v}
vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/tbe {E:/GIT/cpu11/am4/hdl/syn/tbe/de0_top.v}

vlog -vlog01compat -work work +incdir+E:/GIT/cpu11/am4/hdl/syn/syn/de0/../../tbe {E:/GIT/cpu11/am4/hdl/syn/syn/de0/../../tbe/de0_tb4.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb4

do wave.do
view structure
view signals
run -all
