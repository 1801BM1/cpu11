set_property PACKAGE_PIN D4 [get_ports sys_uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_rxd]
set_property PACKAGE_PIN C4 [get_ports sys_uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_txd]

set_property PACKAGE_PIN A8 [get_ports sys_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_reset_n]

set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[0]}]
set_property PACKAGE_PIN C8 [get_ports {sys_led[0]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

set_property PACKAGE_PIN N11 [get_ports sys_clock_50]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock_50]

create_clock -period 20.000 -name sys_clock_50 -waveform {0.000 10.000} [get_ports sys_clock_50]

