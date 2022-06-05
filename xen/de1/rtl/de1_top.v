//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for DE1 board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// Top project module - instantiates the DE1 board itself
//
module de1
(
   input    [1:0] de1_clock_24,     // clock input 24 MHz
   input    [1:0] de1_clock_27,     // clock input 27 MHz
   input          de1_clock_50,     // clock input 50 MHz
   input          de1_clock_ext,    // external clock input
                                    //
   input    [3:0] de1_button,       // push button[3:0]
                                    //
   input    [9:0] de1_sw,           // DPDT toggle switch[9:0]
   output   [6:0] de1_hex0,         // seven segment digit 0
   output   [6:0] de1_hex1,         // seven segment digit 1
   output   [6:0] de1_hex2,         // seven segment digit 2
   output   [6:0] de1_hex3,         // seven segment digit 3
   output   [7:0] de1_ledg,         // LED green[7:0]
   output   [9:0] de1_ledr,         // LED red[9:0]
                                    //
   output         de1_uart_txd,     // UART transmitter
   input          de1_uart_rxd,     // UART receiver
                                    //
   inout   [15:0] de1_dram_dq,      // SDRAM data bus 16 bits
   output  [11:0] de1_dram_addr,    // SDRAM address bus 12 bits
   output         de1_dram_ldqm,    // SDRAM low-byte data mask
   output         de1_dram_udqm,    // SDRAM high-byte data mask
   output         de1_dram_we_n,    // SDRAM write enable
   output         de1_dram_cas_n,   // SDRAM column address strobe
   output         de1_dram_ras_n,   // SDRAM row address strobe
   output         de1_dram_cs_n,    // SDRAM chip select
   output   [1:0] de1_dram_ba,      // SDRAM bank address
   output         de1_dram_clk,     // SDRAM clock
   output         de1_dram_cke,     // SDRAM clock enable
                                    //
   inout    [7:0] de1_fl_dq,        // FLASH data bus 8 Bits
   output  [21:0] de1_fl_addr,      // FLASH address bus 22 Bits
   output         de1_fl_we_n,      // FLASH write enable
   output         de1_fl_rst_n,     // FLASH reset
   output         de1_fl_oe_n,      // FLASH output enable
   output         de1_fl_ce_n,      // FLASH chip enable
                                    //
   inout   [15:0] de1_sram_dq,      // SRAM Data bus 16 Bits
   output  [17:0] de1_sram_addr,    // SRAM Address bus 18 Bits
   output         de1_sram_ub_n,    // SRAM High-byte Data Mask
   output         de1_sram_lb_n,    // SRAM Low-byte Data Mask
   output         de1_sram_we_n,    // SRAM Write Enable
   output         de1_sram_ce_n,    // SRAM Chip Enable
   output         de1_sram_oe_n,    // SRAM Output Enable
                                    //
   inout          de1_sd_mosi,      // SD Card Data Output
   inout          de1_sd_miso,      // SD Card Data Input
   inout          de1_sd_cmd,       // SD Card Command Signal
   output         de1_sd_clk,       // SD Card Clock
                                    //
   input          de1_tdi,          // CPLD -> FPGA (data in)
   input          de1_tck,          // CPLD -> FPGA (clk)
   input          de1_tms,          // CPLD -> FPGA (mode select)
   output         de1_tdo,          // FPGA -> CPLD (data out)
                                    //
   inout          de1_i2c_dat,      // I2C Data
   output         de1_i2c_clk,      // I2C Clock
   inout          de1_ps2_dat,      // PS2 Data
   inout          de1_ps2_clk,      // PS2 Clock
                                    //
   output         de1_vga_hs,       // VGA H_SYNC
   output         de1_vga_vs,       // VGA V_SYNC
   output   [3:0] de1_vga_r,        // VGA Red[3:0]
   output   [3:0] de1_vga_g,        // VGA Green[3:0]
   output   [3:0] de1_vga_b,        // VGA Blue[3:0]
                                    //
   output         de1_aud_adclrck,  // Audio CODEC ADC LR Clock
   input          de1_aud_adcdat,   // Audio CODEC ADC Data
   output         de1_aud_daclrck,  // Audio CODEC DAC LR Clock
   output         de1_aud_dacdat,   // Audio CODEC DAC Data
   inout          de1_aud_bclk,     // Audio CODEC Bit-Stream Clock
   output         de1_aud_xck,      // Audio CODEC Chip Clock
                                    //
   inout [35:0]   de1_gpio0,        // GPIO Connection 0
   inout [35:0]   de1_gpio1         // GPIO Connection 1
);

//______________________________________________________________________________
//
wire        clk50;               // 50 MHz clock source entry
wire        sys_clk_p;           // system positive clock (all buses)
wire        sys_clk_n;           // system negative clock (180 phase shift)
wire        sys_plock;           //
wire        ena_us, ena_ms;      //
reg         ena_slow;            //
                                 //
wire        ext_ready;           // external system ready
wire [15:0] ext_una;             // config word/start address
reg         ext_halt;            // external halt request
reg         ena_timer;           // enable system timer
                                 //
wire        uart_rxd, uart_txd;  // serial data
wire        uart_cts, uart_rts;  // serial handshake
                                 //
wire        tty_end, tty_stb;    // debug
wire  [7:0] tty_dat;             // debug data
                                 //
wire  [7:0] seg_hex0;            // seven segment digit 0
wire  [7:0] seg_hex1;            // seven segment digit 1
wire  [7:0] seg_hex2;            // seven segment digit 2
wire  [7:0] seg_hex3;            // seven segment digit 3
wire  [7:0] leds;                // output LEDs

//______________________________________________________________________________
//
// Select of one of the available CPUs
//
`ifdef CONFIG_CPU_VM1
wbc_vm1 cpu
`endif

`ifdef CONFIG_CPU_VM2
wbc_vm2 cpu
`endif

`ifdef CONFIG_CPU_LSI
wbc_lsi cpu
`endif

`ifdef CONFIG_CPU_AM4
wbc_am4 cpu
`endif

`ifdef CONFIG_CPU_F11
wbc_f11 cpu
`endif
(
   .osc_clk(clk50),              // external oscillator clock
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
                                 //
   .ext_reset(de1_button[0]),    // external reset button
   .ext_ready(ext_ready),        // external system ready
   .ext_una(ext_una),            // config word/start address
   .ext_halt(ext_halt),          // external halt request
   .ena_timer(ena_timer),        // enable system timer
   .ena_slow(ena_slow),          // enable slow clock
                                 //
   .uart_rxd(uart_rxd),          // serial data input
   .uart_txd(uart_txd),          // serial data output
   .uart_rts(uart_rts),          // enable remote transmitter
   .uart_cts(uart_cts),          //
                                 //
   .tty_end(tty_end),            // debug stop
   .tty_stb(tty_stb),            // debug data strobe
   .tty_dat(tty_dat),            // debug data value
                                 //
   .seg_hex0(seg_hex0),          // seven segment digit 0
   .seg_hex1(seg_hex1),          // seven segment digit 1
   .seg_hex2(seg_hex2),          // seven segment digit 2
   .seg_hex3(seg_hex3),          // seven segment digit 3
   .leds(leds)                   // output LEDs
);

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign clk50   = de1_clock_50;

`ifdef CONFIG_PLL_50
de1_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
de1_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
de1_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
de1_pll100 corepll
`endif
(
   .inclk0(clk50),
   .c0(sys_clk_p),
   .c1(sys_clk_n),
   .locked(sys_plock)
);

//______________________________________________________________________________
//
assign ext_ready = 1'b1;
assign ext_una = `CONFIG_START_ADDR_OPTIONS;

always @(posedge sys_clk_p)
begin
   ena_timer <= de1_sw[0];
   ena_slow  <= de1_sw[1];
   ext_halt  <= de1_sw[2];
end

//______________________________________________________________________________
//
assign de1_uart_txd = uart_txd;
assign uart_rxd = de1_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign de1_dram_dq      = 16'hzzzz;
assign de1_dram_addr    = 12'h000;
assign de1_dram_ldqm    = 1'b0;
assign de1_dram_udqm    = 1'b0;
assign de1_dram_we_n    = 1'b1;
assign de1_dram_cas_n   = 1'b1;
assign de1_dram_ras_n   = 1'b1;
assign de1_dram_cs_n    = 1'b1;
assign de1_dram_ba[0]   = 1'b0;
assign de1_dram_ba[1]   = 1'b0;
assign de1_dram_clk     = sys_clk_p;
assign de1_dram_cke     = 1'b0;

assign de1_fl_dq        = 7'hzz;
assign de1_fl_addr      = 22'hzzzzzz;
assign de1_fl_we_n      = 1'b1;
assign de1_fl_rst_n     = 1'b0;
assign de1_fl_oe_n      = 1'b1;
assign de1_fl_ce_n      = 1'b1;

assign de1_sram_dq      = 16'hzzzz;
assign de1_sram_addr    = 18'h00000;
assign de1_sram_we_n    = 1'b1;
assign de1_sram_ce_n    = 1'b1;
assign de1_sram_oe_n    = 1'b1;
assign de1_sram_lb_n    = 1'b1;
assign de1_sram_ub_n    = 1'b1;

assign de1_sd_clk       = 1'b0;
assign de1_sd_mosi      = 1'hz;
assign de1_sd_miso      = 1'hz;
assign de1_sd_cmd       = 1'hz;

assign de1_ps2_dat      = 1'hz;
assign de1_ps2_clk      = 1'hz;
assign de1_i2c_dat      = 1'hz;
assign de1_i2c_clk      = 1'hz;
assign de1_tdo          = 1'hz;

assign de1_vga_hs       = 1'b0;
assign de1_vga_vs       = 1'b0;
assign de1_vga_r        = 4'h0;
assign de1_vga_g        = 4'h0;
assign de1_vga_b        = 4'h0;

assign de1_hex0         = ~seg_hex0[6:0];
assign de1_hex1         = ~seg_hex1[6:0];
assign de1_hex2         = ~seg_hex2[6:0];
assign de1_hex3         = ~seg_hex3[6:0];

assign de1_ledg         = 8'hzz;
assign de1_ledr[9:8]    = 2'hz;
assign de1_ledr[7:0]    = leds;

assign de1_aud_adclrck  = 1'b0;
assign de1_aud_daclrck  = 1'b0;
assign de1_aud_dacdat   = 1'b0;
assign de1_aud_xck      = 1'b0;

assign de1_gpio0        = 36'hzzzzzzzzz;
assign de1_gpio1[7:0]   = tty_dat;
assign de1_gpio1[8]     = tty_end;
assign de1_gpio1[9]     = tty_stb;
assign de1_gpio1[35:10] = 26'hzzzzzzz;

//______________________________________________________________________________
//
endmodule
