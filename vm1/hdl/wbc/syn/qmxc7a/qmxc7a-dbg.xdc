set_property PACKAGE_PIN D4 [get_ports sys_uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_rxd]
set_property PACKAGE_PIN C4 [get_ports sys_uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_txd]

set_property PACKAGE_PIN A8 [get_ports sys_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_reset_n]

set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[0]}]
set_property PACKAGE_PIN C8 [get_ports {sys_led[0]}]

set_property PACKAGE_PIN N11 [get_ports sys_clock_50]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock_50]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
create_clock -period 20.000 -name sys_clock_50 -waveform {0.000 10.000} [get_ports sys_clock_50]


create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list corepll/inst/c0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 1 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {cpu/ack_reg[1][0]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {cpu/wb_dat[0]} {cpu/wb_dat[1]} {cpu/wb_dat[2]} {cpu/wb_dat[3]} {cpu/wb_dat[4]} {cpu/wb_dat[5]} {cpu/wb_dat[6]} {cpu/wb_dat[7]} {cpu/wb_dat[8]} {cpu/wb_dat[9]} {cpu/wb_dat[10]} {cpu/wb_dat[11]} {cpu/wb_dat[12]} {cpu/wb_dat[13]} {cpu/wb_dat[14]} {cpu/wb_dat[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {wb_out[0]} {wb_out[1]} {wb_out[2]} {wb_out[3]} {wb_out[4]} {wb_out[5]} {wb_out[6]} {wb_out[7]} {wb_out[8]} {wb_out[9]} {wb_out[10]} {wb_out[11]} {wb_out[12]} {wb_out[13]} {wb_out[14]} {wb_out[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list vm_aclo_in]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list cpu/wb_stb]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list wb_cyc]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list wb_we]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets sys_clk_p]
