# QMTECH XC7K325T DDR3 Core board
set_property IOSTANDARD LVCMOS33 [get_ports {qk7_clock_50}]
set_property PACKAGE_PIN F22 [get_ports {qk7_clock_50}]

# FPGA RESET - AF9
#set_property PACKAGE_PIN AF9 [get_ports qk7_reset_n]
#set_property IOSTANDARD LVCMOS18 [get_ports qk7_reset_n]

# SW1 is PROG_B - P6 - PROGRAM_B_0
# SW2 - AF9  - IO_L24N_T3_33
# SW3 - AF10 - IO_L24P_T3_33
#set_property PACKAGE_PIN P6 [get_ports {qk7_reset_n}]
#set_property IOSTANDARD LVCMOS33 [get_ports {qk7_reset_n}]
# button(s) on the core board: 0 - pressed, 1 - depressed
set_property PACKAGE_PIN AF9 [get_ports {qk7_button[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {qk7_button[0]}]
set_property PACKAGE_PIN AF10 [get_ports {qk7_button[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {qk7_button[1]}]

# LED1 - FPGA_DONE
# LED2, LED3 - J26, H26  (IO_L18P_T2_A12_D18_14, IO_L18N_T2_A12_D17_14
# led[0-1] are on the core board
set_property PACKAGE_PIN J26 [get_ports {qk7_led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qk7_led[0]}]
set_property PACKAGE_PIN H26 [get_ports {qk7_led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qk7_led[1]}]

set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]

# 4-pin 1-row connector plugs into U5 (close to JTAG connector) into odd numbers:
# (1 - GND, 3 - 3.3V), 5 - GND, 7 - RX, 9 - TX , 11 - DTR
# cp2102-gmr:  bank16_A8 - RX, ban16_B9 TXD, bank16_A10 - DTR
#set_property PACKAGE_PIN A8 [get_ports qk7_uart_rxd]
#set_property IOSTANDARD LVCMOS33 [get_ports qk7_uart_rxd]
#set_property PACKAGE_PIN B9 [get_ports qk7_uart_txd]
#set_property IOSTANDARD LVCMOS33 [get_ports qk7_uart_txd]
#set_property PACKAGE_PIN A10 [get_ports qk7_uart_dtr]
#set_property IOSTANDARD LVCMOS33 [get_ports qk7_uart_dtr]
set_property PACKAGE_PIN B9 [get_ports qk7_uart_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports qk7_uart_rxd]
set_property PACKAGE_PIN A8 [get_ports qk7_uart_txd]
set_property IOSTANDARD LVCMOS33 [get_ports qk7_uart_txd]
# GPIO1: U5.13 - B11,  U5.15 - C11 
set_property PACKAGE_PIN B11 [get_ports qk7_gpio1[0]]
set_property IOSTANDARD LVCMOS33 [get_ports qk7_gpio1[0]]
set_property PACKAGE_PIN C11 [get_ports qk7_gpio1[1]]
set_property IOSTANDARD LVCMOS33 [get_ports qk7_gpio1[1]]


create_clock -period 20.000 -name qk7_clock_50 -waveform {0.000 10.000} [get_ports qk7_clock_50]
set_input_jitter [get_clocks -of_objects [get_ports qk7_clock_50]] 0.200

set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]

