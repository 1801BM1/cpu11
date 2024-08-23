#!/opt/gowin/IDE/bin/gw_sh
add_file -type cst ./syn/nano9k.cst
add_file -type sdc ./src/cpu11.sdc
add_file -type verilog rtl/f11_defs.v
add_file -type verilog rtl/sn9_top.v
add_file -type verilog syn/gowin_rpll/gowin_rpll.v
add_file -type verilog src/mem_f11/mem16x16k_f11.v
add_file -type verilog rtl/gwn_mem.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_302.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_303.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_304.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_fpp.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_pla.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_pla_0.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_pla_1.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_pla_2.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_rom.v
add_file -type verilog ../../f11/hdl/wbc/rtl/dc_mmu.v
add_file -type verilog ../../f11/hdl/wbc/rtl/f11_wb.v
add_file -type verilog ../lib/wbc_f11.v
add_file -type verilog ../lib/wbc_rst.v
add_file -type verilog ../lib/wbc_uart.v
add_file -type verilog ../lib/wbc_vic.v
# add_file -type other src/mem_f11/mem16x16k_f11.ipc
set_device GW1NR-LV9QN88PC6/I5 -name GW1NR-9C
set_option -synthesis_tool gowinsynthesis
set_option -output_base_name sn9_f11
set_option -top_module sn9_top
set_option -verilog_std v2001
set_option -gen_sdf 1
set_option -gen_posp 1
# set_option -gen_sim_netlist 1
set_option -ireg_in_iob 0
set_option -oreg_in_iob 0
set_option -ioreg_in_iob 0
set_option -timing_driven 1
# -use_i2c_as_gpio
set_option -use_mode_as_gpio 1
# -use_reconfign_as_gpio
# -use_done_as_gpio
# -use_ready_as_gpio
# -use_mspi_as_gpio
# -use_sspi_as_gpio
# -use_jtag_as_gpio
set_option -bg_programming off
# run syn
run all
report_timing -setup -max_paths 25 -max_common_paths 1
