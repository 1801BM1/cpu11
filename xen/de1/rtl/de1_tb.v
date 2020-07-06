//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Testbench for the 1801BM1 replica, native QBUS version
//______________________________________________________________________________
//
`include "../../lib/config.v"

module tb1();

reg         clk50;
reg [3:0]   button;
reg [9:0]   switch;
wire [6:0]  hex0, hex1, hex2, hex3;
wire [9:0]  ledr;
wire [7:0]  ledg;
                           //
wire        uart_txd;      // UART transmitter
reg         uart_rxd;      // UART receiver
wire        uart_cts;      // UART clear to send
reg         uart_rts;      // UART request to send
                           //
wire [15:0] dram_dq;       // SDRAM data bus 16 bits
wire [11:0] dram_addr;     // SDRAM address bus 12 bits
wire        dram_ldqm;     // SDRAM low-byte data mask
wire        dram_udqm;     // SDRAM high-byte data mask
wire        dram_we_n;     // SDRAM write enable
wire        dram_cas_n;    // SDRAM column address strobe
wire        dram_ras_n;    // SDRAM row address strobe
wire        dram_cs_n;     // SDRAM chip select
wire [1:0]  dram_ba;       // SDRAM bank address
wire        dram_clk;      // SDRAM clock
wire        dram_cke;      // SDRAM clock enable
                           //
wire [15:0] sram_dq;       // SRAM Data bus 16 Bits
wire [17:0] sram_addr;     // SRAM Address bus 18 Bits
wire        sram_ub_n;     // SRAM High-byte Data Mask
wire        sram_lb_n;     // SRAM Low-byte Data Mask
wire        sram_we_n;     // SRAM Write Enable
wire        sram_ce_n;     // SRAM Chip Enable
wire        sram_oe_n;     // SRAM Output Enable
                           //
wire [7:0]  fl_dq;         // FLASH data bus 8 Bits
wire [21:0] fl_addr;       // FLASH address bus 22 Bits
wire        fl_we_n;       // FLASH write enable
wire        fl_rst_n;      // FLASH reset
wire        fl_oe_n;       // FLASH output enable
wire        fl_ce_n;       // FLASH chip enable
wire        fl_wp_n;       // FLASH hardware write protect
wire        fl_byte_n;     // FLASH selects 8/16-bit mode
wire        fl_rb;         // FLASH ready/busy
                           //
wire        sd_mosi;       // SD Card Data Output
wire        sd_miso;       // SD Card Data Input
wire        sd_cmd;        // SD Card Command Signal
wire        sd_clk;        // SD Card Clock
                           //
wire        ps2_kbdat;     // PS2 Keyboard Data
wire        ps2_kbclk;     // PS2 Keyboard Clock
                           //
wire        i2c_dat;       // I2C Data
wire        i2c_clk;       // I2C Clock
                           //
wire        tdi;           // CPLD -> FPGA (data in)
wire        tck;           // CPLD -> FPGA (clk)
wire        tms;           // CPLD -> FPGA (mode select)
wire        tdo;           // FPGA -> CPLD (data out)
                           //
wire        aud_adclrck;   // Audio CODEC ADC LR Clock
wire        aud_adcdat;    // Audio CODEC ADC Data
wire        aud_daclrck;   // Audio CODEC DAC LR Clock
wire        aud_dacdat;    // Audio CODEC DAC Data
wire        aud_bclk;      // Audio CODEC Bit-Stream Clock
wire        aud_xck;       // Audio CODEC Chip Clock
                           //
wire        vga_hs;        // VGA H_SYNC
wire        vga_vs;        // VGA V_SYNC
wire [3:0]  vga_r;         // VGA Red[3:0]
wire [3:0]  vga_g;         // VGA Green[3:0]
wire [3:0]  vga_b;         // VGA Blue[3:0]
                           //
wire [35:0] gpio0_d;       // GPIO Connection 0 Data Bus
wire [35:0] gpio1_d;       // GPIO Connection 1 Data Bus

//_____________________________________________________________________________
//
initial
begin
//
// Let PLL to lock incoming clock and short debouncer start time
//
#100000
   de1_top.cpu.reset.count_db = `CONFIG_RESET_BUTTON_DEBOUNCE_MS-1;
   de1_top.cpu.reset.key_down = 0;
// uart_send("T");
// uart_send("E");
// uart_send("S");
// uart_send("T");
end

initial
begin
   clk50 = 0;
   forever
      begin
         #10 clk50 = 0;
         #10 clk50 = 1;
      end
end

initial
begin
   switch = 9'b0000000000;
   button = 4'b1111;
   uart_rxd = 1'b1;
   uart_rts = 1'b0;
end

initial
begin
   #`CONFIG_SIM_TIME_LIMIT $stop;
end

`ifdef CONFIG_SIM_DEBUG_TTY
always @(posedge gpio1_d[9])
begin
#2
   $display("tty: %03O (%c)", gpio1_d[7:0],
           (gpio1_d[7:0] > 8'o037) ? gpio1_d[7:0] : 8'o52);
end
`endif

always @(posedge gpio1_d[8])
begin
   $display("Stop on debug request");
   $stop;
end

de1 de1_top(
   .de1_clock_24({clk50, clk50}),   // clock input 24 MHz
   .de1_clock_27({clk50, clk50}),   // clock input 27 MHz
   .de1_clock_50(clk50),            // clock input 50 MHz
   .de1_clock_ext(clk50),           // external clock input

   .de1_button(button),             // push button[3:0]
   .de1_sw(switch),                 // DPDT toggle switch[9:0]
   .de1_hex0(hex0),                 // seven segment digit 0
   .de1_hex1(hex1),                 // seven segment digit 1
   .de1_hex2(hex2),                 // seven segment digit 2
   .de1_hex3(hex3),                 // seven segment digit 3
   .de1_ledr(ledr),                 // LED red[9:0]
   .de1_ledg(ledg),                 // LED green[7:0]
                                    //
   .de1_uart_txd(uart_txd),         // UART transmitter
   .de1_uart_rxd(uart_rxd),         // UART receiver
                                    //
   .de1_dram_dq(dram_dq),           // SDRAM data bus 16 bits
   .de1_dram_addr(dram_addr),       // SDRAM address bus 12 bits
   .de1_dram_ldqm(dram_ldqm),       // SDRAM low-byte data mask
   .de1_dram_udqm(dram_udqm),       // SDRAM high-byte data mask
   .de1_dram_we_n(dram_we_n),       // SDRAM write enable
   .de1_dram_cas_n(dram_cas_n),     // SDRAM column address strobe
   .de1_dram_ras_n(dram_ras_n),     // SDRAM row address strobe
   .de1_dram_cs_n(dram_cs_n),       // SDRAM chip select
   .de1_dram_ba(dram_ba),           // SDRAM bank address
   .de1_dram_clk(dram_clk),         // SDRAM clock
   .de1_dram_cke(dram_cke),         // SDRAM clock enable
                                    //
   .de1_sram_dq(sram_dq),           // SRAM Data bus 16 Bits
   .de1_sram_addr(sram_addr),       // SRAM Address bus 18 Bits
   .de1_sram_ub_n(sram_ub_n),       // SRAM High-byte Data Mask
   .de1_sram_lb_n(sram_lb_n),       // SRAM Low-byte Data Mask
   .de1_sram_we_n(sram_we_n),       // SRAM Write Enable
   .de1_sram_ce_n(sram_ce_n),       // SRAM Chip Enable
   .de1_sram_oe_n(sram_oe_n),       // SRAM Output Enable
                                    //
   .de1_fl_dq(fl_dq),               // FLASH data bus 8 Bits
   .de1_fl_addr(fl_addr),           // FLASH address bus 22 Bits
   .de1_fl_we_n(fl_we_n),           // FLASH write enable
   .de1_fl_rst_n(fl_rst_n),         // FLASH reset
   .de1_fl_oe_n(fl_oe_n),           // FLASH output enable
   .de1_fl_ce_n(fl_ce_n),           // FLASH chip enable
                                    //
   .de1_sd_mosi(sd_mosi),           // SD Card Data Output
   .de1_sd_miso(sd_miso),           // SD Card Data Input
   .de1_sd_cmd(sd_cmd),             // SD Card Command Signal
   .de1_sd_clk(sd_clk),             // SD Card Clock
                                    //
   .de1_ps2_dat(ps2_kbdat),         //
   .de1_ps2_clk(ps2_kbclk),         //
                                    //
   .de1_i2c_dat(i2c_dat),           // I2C Data
   .de1_i2c_clk(i2c_clk),           // I2C Clock
                                    //
   .de1_tdi(tdi),                   // CPLD -> FPGA (data in)
   .de1_tck(tck),                   // CPLD -> FPGA (clk)
   .de1_tms(tms),                   // CPLD -> FPGA (mode select)
   .de1_tdo(tdo),                   // FPGA -> CPLD (data out)
                                    //
   .de1_aud_adclrck(aud_adclrck),   // Audio CODEC ADC LR Clock
   .de1_aud_adcdat(aud_adcdat),     // Audio CODEC ADC Data
   .de1_aud_daclrck(aud_daclrck),   // Audio CODEC DAC LR Clock
   .de1_aud_dacdat(aud_dacdat),     // Audio CODEC DAC Data
   .de1_aud_bclk(aud_bclk),         // Audio CODEC Bit-Stream Clock
   .de1_aud_xck(aud_xck),           // Audio CODEC Chip Clock
                                    //
   .de1_vga_hs(vga_hs),             //
   .de1_vga_vs(vga_vs),             //
   .de1_vga_r(vga_r),               //
   .de1_vga_g(vga_g),               //
   .de1_vga_b(vga_b),               //
                                    //
   .de1_gpio0(gpio0_d),             //
   .de1_gpio1(gpio1_d)              //
);

//_____________________________________________________________________________
//
`define  UBIT (1000000000 / `CONFIG_BAUD_RATE)

task uart_send
(
   input [7:0] data
);
begin
   uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b0;
   #`UBIT uart_rxd = data[0];
   #`UBIT uart_rxd = data[1];
   #`UBIT uart_rxd = data[2];
   #`UBIT uart_rxd = data[3];
   #`UBIT uart_rxd = data[4];
   #`UBIT uart_rxd = data[5];
   #`UBIT uart_rxd = data[6];
   #`UBIT uart_rxd = data[7];
   #`UBIT uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b1;
end
endtask

//_____________________________________________________________________________
//
endmodule
