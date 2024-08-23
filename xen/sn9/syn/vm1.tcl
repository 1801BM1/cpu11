#!/opt/gowin/IDE/bin/gw_sh
add_file -type verilog rtl/vm1_defs.v
add_file -type verilog rtl/sn9_top.v
add_file -type verilog syn/gowin_rpll/gowin_rpll.v
add_file -type verilog rtl/gwn_mem.v
add_file -type verilog ../lib/wbc_vm1.v
add_file -type verilog ../../vm1/hdl/wbc/rtl/vm1_plm.v
add_file -type verilog ../../vm1/hdl/wbc/rtl/vm1_tve.v
add_file -type verilog ../../vm1/hdl/wbc/rtl/vm1_wb.v
add_file -type verilog ../../vm1/hdl/wbc/rtl/vm1_reg.v
add_file -type verilog ../lib/wbc_rst.v
add_file -type verilog ../lib/wbc_uart.v
add_file -type verilog ../lib/wbc_vic.v
add_file -type verilog src/mem_vm1/mem16x8k_vm1.v
add_file -type sdc ./src/cpu11.sdc
add_file -type cst ./syn/nano9k.cst
set_device GW1NR-LV9QN88PC6/I5 -name GW1NR-9C
set_option -synthesis_tool gowinsynthesis
set_option -output_base_name sn9_vm1
set_option -top_module sn9_top
set_option -verilog_std v2001
set_option -gen_sdf 1
set_option -gen_posp 1
set_option -gen_sim_netlist 1
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
