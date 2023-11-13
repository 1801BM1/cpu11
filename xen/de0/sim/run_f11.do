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
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/f11_wb.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_302.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_303.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_304.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_fpp.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_mmu.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_pla.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_pla_0.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_pla_1.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl {../../../f11/hdl/wbc/rtl/dc_pla_2.v}
vlog -vlog01compat -work work +incdir+../syn/db {../syn/db/de0_pll100_altpll.v}
vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_top.v}
vlog -vlog01compat -work work +incdir+../../lib {../../lib/wbc_f11.v}
vlog -vlog01compat -work work +incdir+../../../f11/hdl/wbc/rtl +define+F11_FILE_MICROM_000="../../../f11/rom/000.rom" +define+F11_FILE_MICROM_001="../../../f11/rom/001.rom" +define+F11_FILE_MICROM_002="../../../f11/rom/002.rom" {../../../f11/hdl/wbc/rtl/dc_rom.v}
vlog -vlog01compat -work work +incdir+../rtl {../rtl/de0_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc" -onfinish stop tb1

do wav_f11.do
view structure
view signals
run -all
