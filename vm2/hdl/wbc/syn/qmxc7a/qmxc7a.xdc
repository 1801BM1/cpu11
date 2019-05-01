# QMTECH XC7A35T DDR3 V2 with dauther board
set_property PACKAGE_PIN N11 [get_ports sys_clock_50]
set_property IOSTANDARD LVCMOS33 [get_ports sys_clock_50]

# FPGA RESET - B7
# set_property PACKAGE_PIN B7 [get_ports fpga_rst_n]
# set_property IOSTANDARD LVCMOS33 [get_ports fpga_reset_n]

# SW1 is PROG_B
# SW2 - bank35_K5
set_property PACKAGE_PIN K5 [get_ports sys_reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports sys_reset_n]

# led[0] is on the core board
set_property PACKAGE_PIN E6 [get_ports {sys_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[0]}]

# led[1-5] are on the dauther board
set_property PACKAGE_PIN R6 [get_ports {sys_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[1]}]
set_property PACKAGE_PIN T5 [get_ports {sys_led[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[2]}]
set_property PACKAGE_PIN R7 [get_ports {sys_led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[3]}]
set_property PACKAGE_PIN T7 [get_ports {sys_led[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[4]}]
set_property PACKAGE_PIN R8 [get_ports {sys_led[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_led[5]}]

# sys_button(s) on the dauterboard, 0 - pressed, 1 - depressed
# SW1 ... SW5 mapts to sys_button[0..4]
set_property PACKAGE_PIN B7 [get_ports {sys_button[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_button[0]}]
set_property PACKAGE_PIN M6 [get_ports {sys_button[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_button[1]}]
set_property PACKAGE_PIN N6 [get_ports {sys_button[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_button[2]}]
set_property PACKAGE_PIN R5 [get_ports {sys_button[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_button[3]}]
set_property PACKAGE_PIN P6 [get_ports {sys_button[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_button[4]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

# cp2102-gmr:  bank14_T15 - TXD, bank14_T14 - RXD
# cts/rts/dtr/dcd/dsr are not connected
set_property PACKAGE_PIN T14 [get_ports sys_uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_rxd]
set_property PACKAGE_PIN T15 [get_ports sys_uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports sys_uart_txd]

# 3x 7-seg display on the dauther board
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hsel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hsel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hsel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sys_hex[0]}]

set_property PACKAGE_PIN T8 [get_ports {sys_hsel[2]}]
set_property PACKAGE_PIN P10 [get_ports {sys_hsel[1]}]
set_property PACKAGE_PIN T9 [get_ports {sys_hsel[0]}]
set_property PACKAGE_PIN T10 [get_ports {sys_hex[0]}]
set_property PACKAGE_PIN K13 [get_ports {sys_hex[1]}]
set_property PACKAGE_PIN P11 [get_ports {sys_hex[2]}]
set_property PACKAGE_PIN R11 [get_ports {sys_hex[3]}]
set_property PACKAGE_PIN R10 [get_ports {sys_hex[4]}]
set_property PACKAGE_PIN N9 [get_ports {sys_hex[5]}]
set_property PACKAGE_PIN K12 [get_ports {sys_hex[6]}]
set_property PACKAGE_PIN P9 [get_ports {sys_hex[7]}]

# MicroSD
#set_property IOSTANDARD LVCMOS33 [get_ports sys_sd_clk]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_sd_cs_n]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_sd_miso]
#set_property IOSTANDARD LVCMOS33 [get_ports sys_sd_mosi]
#set_property PACKAGE_PIN E6 [get_ports sys_sd_clk]
#set_property PACKAGE_PIN J5 [get_ports sys_sd_cs_n]
#set_property PACKAGE_PIN K5 [get_ports sys_sd_mosi] // SD_datain
#set_property PACKAGE_PIN B5 [get_ports sys_sd_miso] // SD_dataout

# PMOD 9x2 connector
# 1 - 3.3V, 2 - GND, 3 - 3.3V+4k7 - M1, 4 - 3.3V+4k7 - M2
# 17 - P5, 18 - L5
set_property IOSTANDARD LVCMOS33 [get_ports sys_gpio1[0]]
set_property IOSTANDARD LVCMOS33 [get_ports sys_gpio1[1]]
set_property PACKAGE_PIN P5 [get_ports sys_gpio1[0]]
set_property PACKAGE_PIN L5 [get_ports sys_gpio1[1]]


create_clock -period 20.000 -name sys_clock_50 -waveform {0.000 10.000} [get_ports sys_clock_50]

