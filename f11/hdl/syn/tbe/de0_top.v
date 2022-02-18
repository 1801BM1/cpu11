//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Top module for DE0 board based system
//______________________________________________________________________________
//
// Top project module - instantiates the DE0 board itself
//
module de0
(
   input          de0_clock_50,        // clock input 50 MHz
   input          de0_clock_50_2,      // clock input 50 MHz
                                       //
   input    [2:0] de0_button,          // push button[2:0]
                                       //
   input    [9:0] de0_sw,              // DPDT toggle switch[9:0]
   output   [7:0] de0_hex0,            // seven segment digit 0
   output   [7:0] de0_hex1,            // seven segment digit 1
   output   [7:0] de0_hex2,            // seven segment digit 2
   output   [7:0] de0_hex3,            // seven segment digit 3
   output   [9:0] de0_led,             // LED green[9:0]
                                       //
   output         de0_uart_txd,        // UART transmitter
   input          de0_uart_rxd,        // UART receiver
   output         de0_uart_cts,        // UART clear to send
   input          de0_uart_rts,        // UART request to send
                                       //
   inout   [15:0] de0_dram_dq,         // SDRAM data bus 16 bits
   output  [12:0] de0_dram_addr,       // SDRAM address bus 13 bits
   output         de0_dram_ldqm,       // SDRAM low-byte data mask
   output         de0_dram_udqm,       // SDRAM high-byte data mask
   output         de0_dram_we_n,       // SDRAM write enable
   output         de0_dram_cas_n,      // SDRAM column address strobe
   output         de0_dram_ras_n,      // SDRAM row address strobe
   output         de0_dram_cs_n,       // SDRAM chip select
   output   [1:0] de0_dram_ba,         // SDRAM bank address
   output         de0_dram_clk,        // SDRAM clock
   output         de0_dram_cke,        // SDRAM clock enable
                                       //
   inout   [15:0] de0_fl_dq,           // FLASH data bus 15 Bits
   output  [21:0] de0_fl_addr,         // FLASH address bus 22 Bits
   output         de0_fl_we_n,         // FLASH write enable
   output         de0_fl_rst_n,        // FLASH reset
   output         de0_fl_oe_n,         // FLASH output enable
   output         de0_fl_ce_n,         // FLASH chip enable
   output         de0_fl_wp_n,         // FLASH hardware write protect
   output         de0_fl_byte_n,       // FLASH selects 8/16-bit mode
   input          de0_fl_rb,           // FLASH ready/busy
                                       //
   output         de0_lcd_blig,        // LCD back light ON/OFF
   output         de0_lcd_rw,          // LCD read/write select, 0 = write, 1 = read
   output         de0_lcd_en,          // LCD enable
   output         de0_lcd_rs,          // LCD command/data select, 0 = command, 1 = data
   inout    [7:0] de0_lcd_data,        // LCD data bus 8 bits
                                       //
   inout          de0_sd_dat0,         // SD Card Data 0
   inout          de0_sd_dat3,         // SD Card Data 3
   inout          de0_sd_cmd,          // SD Card Command Signal
   output         de0_sd_clk,          // SD Card Clock
   input          de0_sd_wp_n,         // SD Card Write Protect
                                       //
   inout          de0_ps2_kbdat,       // PS2 Keyboard Data
   inout          de0_ps2_kbclk,       // PS2 Keyboard Clock
   inout          de0_ps2_msdat,       // PS2 Mouse Data
   inout          de0_ps2_msclk,       // PS2 Mouse Clock
                                       //
   output         de0_vga_hs,          // VGA H_SYNC
   output         de0_vga_vs,          // VGA V_SYNC
   output   [3:0] de0_vga_r,           // VGA Red[3:0]
   output   [3:0] de0_vga_g,           // VGA Green[3:0]
   output   [3:0] de0_vga_b,           // VGA Blue[3:0]
                                       //
   input    [1:0] de0_gpio0_clkin,     // GPIO Connection 0 Clock In Bus
   output   [1:0] de0_gpio0_clkout,    // GPIO Connection 0 Clock Out Bus
   inout   [31:0] de0_gpio0_d,         // GPIO Connection 0 Data Bus
                                       //
   input    [1:0] de0_gpio1_clkin,     // GPIO Connection 1 Clock In Bus
   output   [1:0] de0_gpio1_clkout,    // GPIO Connection 1 Clock Out Bus
   inout   [31:0] de0_gpio1_d          // GPIO Connection 1 Data Bus
);

wire clk, rst_n;
reg [7:0] rcnt = 8'h00;
assign clk = de0_clock_50;

always @(posedge clk)
begin
   if (~de0_button[2])
      rcnt <= 8'h00;
   else
      if (rcnt != 8'hFF) rcnt <= rcnt + 8'h01;
end

//______________________________________________________________________________
//
f11 cpu
(
   .pin_clk(clk),                      // processor clock
   .pin_init_n(de0_gpio0_d[0]),        // peripheral reset
   .pin_dclo_n(de0_gpio0_d[1]),        // processor reset
   .pin_aclo_n(de0_gpio0_d[2]),        // power fail notoficaton
   .pin_halt_n(de0_gpio0_d[3]),        // halt request
   .pin_evnt_n(de0_gpio0_d[4]),        // timer interrupt requests
   .pin_virq_n(de0_gpio0_d[17:14]),    // vectored interrupt request

   .pin_a_n(de0_gpio0_d[23:18]),       // inverted high address bus
   .pin_ad_n(de0_dram_dq),             // inverted address/data bus
   .pin_dout_n(de0_gpio0_d[7]),        // data output strobe
   .pin_din_n(de0_gpio0_d[8]),         // data input strobe
   .pin_wtbt_n(de0_gpio0_d[9]),        // write/byte status
   .pin_sync_n(de0_gpio0_d[10]),       // address strobe
   .pin_rply_n(de0_gpio0_d[11]),       // transaction reply
   .pin_iako_n(de0_gpio0_d[6])         // interrupt vector input
);

assign   de0_gpio0_d[1]    = 1'bZ;
assign   de0_gpio0_d[2]    = 1'bZ;
assign   de0_gpio0_d[3]    = 1'bZ;
assign   de0_gpio0_d[4]    = 1'bZ;
assign   de0_gpio0_d[5]    = 1'bZ;
assign   de0_gpio0_d[11]   = 1'bZ;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign   de0_uart_txd   = 1'bz;
assign   de0_uart_cts   = 1'bz;

// assign   de0_dram_dq    = 16'hzzzz;
assign   de0_dram_addr  = 13'h0000;
assign   de0_dram_ldqm  = 1'b0;
assign   de0_dram_udqm  = 1'b0;
assign   de0_dram_we_n  = 1'b1;
assign   de0_dram_cas_n = 1'b1;
assign   de0_dram_ras_n = 1'b1;
assign   de0_dram_cs_n  = 1'b1;
assign   de0_dram_ba[0] = 1'b0;
assign   de0_dram_ba[1] = 1'b0;
assign   de0_dram_clk   = 1'b0;
assign   de0_dram_cke   = 1'b0;

assign   de0_fl_dq      = 16'hzzzz;
assign   de0_fl_addr    = 22'hzzzzzz;
assign   de0_fl_we_n    = 1'b1;
assign   de0_fl_rst_n   = 1'b0;
assign   de0_fl_oe_n    = 1'b1;
assign   de0_fl_ce_n    = 1'b1;
assign   de0_fl_wp_n    = 1'b0;
//assign de0_fl_byte_n  = 1'b1;

assign   de0_lcd_data   = 8'hzz;
assign   de0_lcd_blig   = 1'b0;
assign   de0_lcd_rw     = 1'b0;
assign   de0_lcd_en     = 1'b0;
assign   de0_lcd_rs     = 1'b0;

assign   de0_sd_clk     = 1'b0;
assign   de0_sd_dat0    = 1'hz;
assign   de0_sd_dat3    = 1'hz;
assign   de0_sd_cmd     = 1'hz;

assign   de0_ps2_kbdat  = 1'hz;
assign   de0_ps2_kbclk  = 1'hz;
assign   de0_ps2_msdat  = 1'hz;
assign   de0_ps2_msclk  = 1'hz;

assign   de0_vga_hs     = 1'b0;
assign   de0_vga_vs     = 1'b0;
assign   de0_vga_r      = 4'h0;
assign   de0_vga_g      = 4'h0;
assign   de0_vga_b      = 4'h0;

assign   de0_gpio0_clkout  = 2'b00;
assign   de0_gpio1_clkout  = 2'b00;
assign   de0_gpio0_d[31:24]= 8'hzz;
assign   de0_gpio1_d       = 32'hzzzzzzzz;

assign   de0_hex0         = 8'hzz;
assign   de0_hex1         = 8'hzz;
assign   de0_hex2         = 8'hzz;
assign   de0_hex3         = 8'hzz;
assign   de0_led[9:0]     = 10'hzzz;

//______________________________________________________________________________
//
endmodule
