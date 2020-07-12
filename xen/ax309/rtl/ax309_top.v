//______________________________________________________________________________
//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for AX309 board based system
//
`include "../../lib/config.v"

//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16
//
module wbc_mem
(
   input          wb_clk_i,
   input  [15:0]  wb_adr_i,
   input  [15:0]  wb_dat_i,
   output [15:0]  wb_dat_o,
   input          wb_cyc_i,
   input          wb_we_i,
   input  [1:0]   wb_sel_i,
   input          wb_stb_i,
   output         wb_ack_o
);
wire [1:0] ena;
reg [1:0]ack;

ax309_mem ram(
   .addra(wb_adr_i[13:1]),
   .clka(wb_clk_i),
   .dina(wb_dat_i),
   .wea( wb_we_i & wb_cyc_i & wb_stb_i),
   .byteena(ena),
   .douta(wb_dat_o));

assign ena = wb_we_i ? wb_sel_i : 2'b11;
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end
endmodule

//______________________________________________________________________________
//
// Top project module - instantiates the AX309 board itself
//
module ax309
(
   input          ax3_clock_50,     // clock input 50 MHz
                                    //
   input          ax3_reset_n,      // push reset button
   input    [3:0] ax3_button,       // push button [3:0]
   output   [3:0] ax3_led,          // led outputs [3:0]
   output   [7:0] ax3_hex,          // seven segment digit mask
   output   [5:0] ax3_hsel,         // seven segment digit select
// output         ax3_buzzer,       //
                                    //
   output         ax3_uart_txd,     // UART transmitter
   input          ax3_uart_rxd,     // UART receiver
//                                  //
// inout   [15:0] ax3_dram_dq,      // SDRAM data bus 16 bits
// output  [12:0] ax3_dram_addr,    // SDRAM address bus 13 bits
// output         ax3_dram_ldqm,    // SDRAM low-byte data mask
// output         ax3_dram_udqm,    // SDRAM high-byte data mask
// output         ax3_dram_we_n,    // SDRAM write enable
// output         ax3_dram_cas_n,   // SDRAM column address strobe
// output         ax3_dram_ras_n,   // SDRAM row address strobe
// output         ax3_dram_cs_n,    // SDRAM chip select
// output   [1:0] ax3_dram_ba,      // SDRAM bank address
// output         ax3_dram_clk,     // SDRAM clock
// output         ax3_dram_cke,     // SDRAM clock enable
//                                  //
// output         ax3_spi_cs_n,     // SPI FLASH chip select
// output         ax3_spi_clk,      // SPI FLASH clock
// output         ax3_spi_mosi,     // SPI FLASH master output
// input          ax3_spi_miso,     // SPI FLASH master input
//                                  //
// inout          ax3_sd_cs_n,      // SD Card chip select
// inout          ax3_sd_clk,       // SD Card clock
// inout          ax3_sd_mosi,      // SD Card master output
// inout          ax3_sd_miso,      // SD Card master input
//                                  //
// inout          ax3_i2c_clk,      // I2C Clock
// inout          ax3_i2c_dat,      // I2C Data
// output         ax3_rtc_rst_n,    // RTC DS1302 reset
// output         ax3_rtc_sclk,     // RTC DS1302_serial clock
// inout          ax3_rtc_sdat,     // RTC DS1302 serial data_
//                                  //
// output         ax3_vga_hs,       // VGA H_SYNC
// output         ax3_vga_vs,       // VGA V_SYNC
// output   [4:0] ax3_vga_r,        // VGA Red[4:0]
// output   [5:0] ax3_vga_g,        // VGA Green[5:0]
// output   [4:0] ax3_vga_b,        // VGA Blue[4:0]
//                                  //
// inout   [33:0] ax3_gpio0,        // GPIO Connection 0
// inout   [33:0] ax3_gpio1         // GPIO Connection 1
   inout   [1:0]  ax3_gpio1         // GPIO Connection 1
);

//______________________________________________________________________________
//
wire        clk50;               // 50 MHz clock source entry
wire        sys_clk_p;           // system positive clock (all buses)
wire        sys_clk_n;           // system negative clock (180 phase shift)
wire        sys_plock;           //
wire        ena_us, ena_ms;      //
wire        sys_rst, pwr_rst;    //
wire        ena_slow;            //
                                 //
wire        ext_ready;           // external system ready
wire [15:0] ext_una;             // config word/start address
reg         ext_halt;            // external halt request
wire        ena_timer;           // enable system timer
                                 //
wire        uart_rxd, uart_txd;  // serial data
wire        uart_cts, uart_rts;  // serial handshake
                                 //
wire        tty_end, tty_stb;    // debug
wire  [7:0] tty_dat;             // debug data
                                 //
reg  [2:0]  hsel;                //
wire  [7:0] seg_hex0;            // seven segment digit 0
wire  [7:0] seg_hex1;            // seven segment digit 1
wire  [7:0] seg_hex2;            // seven segment digit 2
wire  [7:0] seg_hex3;            // seven segment digit 3
wire  [7:0] leds;                // output LEDs
				 //
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
(
   .osc_clk(sys_clk_p),          // ax3_clock_50 can feed PLL only
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(ax3_button[0]),    // external reset button
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
assign clk50   = ax3_clock_50;

`ifdef CONFIG_PLL_50
ax3_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
ax3_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
ax3_pll75 corepll
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
assign ext_una = `CONFIG_RESET_START_ADDRESS;

always @(posedge sys_clk_p)
   ext_halt  <= 1'b0;

//______________________________________________________________________________
//
assign ax3_uart_txd = uart_txd;
assign uart_rxd = ax3_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign ax3_hex = (hsel == 3'b000) ? ~seg_hex0
               : (hsel == 3'b001) ? ~seg_hex1
               : (hsel == 3'b010) ? ~seg_hex2
               : (hsel == 3'b011) ? ~seg_hex3 : 8'hFF;

assign ax3_hsel[0] = ~(hsel == 3'b000);
assign ax3_hsel[1] = ~(hsel == 3'b001);
assign ax3_hsel[2] = ~(hsel == 3'b010);
assign ax3_hsel[3] = ~(hsel == 3'b011);
assign ax3_hsel[4] = ~(hsel == 3'b100);
assign ax3_hsel[5] = ~(hsel == 3'b101);

always @(posedge sys_clk_p)
begin
	if (~ax3_button[0])
		hsel <= 3'b000;
	else
      if (ena_ms)
         if (hsel == 3'b000)
            hsel <= 3'b101;
         else
            hsel <= hsel - 3'b001;
end

assign ax3_led = leds[3:0];

//______________________________________________________________________________
//
wbc_toggle tog1
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(ax3_button[1]),
   .ena_ms(ena_ms),
   .out(ena_timer)
);

wbc_toggle tog2
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(ax3_button[2]),
   .ena_ms(ena_ms),
   .out(ena_slow)
);

//______________________________________________________________________________
//
// Temporary and debug assignments
//
// assign   ax3_dram_dq    = 16'hzzzz;
// assign   ax3_dram_addr  = 13'h0000;
// assign   ax3_dram_ldqm  = 1'b0;
// assign   ax3_dram_udqm  = 1'b0;
// assign   ax3_dram_we_n  = 1'b1;
// assign   ax3_dram_cas_n = 1'b1;
// assign   ax3_dram_ras_n = 1'b1;
// assign   ax3_dram_cs_n  = 1'b1;
// assign   ax3_dram_ba[0] = 1'b0;
// assign   ax3_dram_ba[1] = 1'b0;
// assign   ax3_dram_clk   = 1'b0;
// assign   ax3_dram_cke   = 1'b0;
//
// assign   ax3_spi_cs_n   = 1'b1;
// assign   ax3_spi_clk    = 1'b0;
// assign   ax3_spi_mosi   = 1'bz;
//
// assign   ax3_sd_cs_n    = 1'bz;
// assign   ax3_sd_clk     = 1'b0;
// assign   ax3_sd_mosi    = 1'bz;
// assign   ax3_sd_miso    = 1'bz;
//
// assign   ax3_i2c_dat    = 1'hz;
// assign   ax3_i2c_clk    = 1'hz;
// assign   ax3_rtc_rst_n  = 1'hz;
// assign   ax3_rtc_sclk   = 1'hz;
// assign   ax3_rtc_sdat   = 1'hz;
assign   ax3_buzzer     = 1'hz;
assign   ax3_gpio1[0]   = ena_us;
assign   ax3_gpio1[1]   = ena_ms;
//
// assign   ax3_vga_hs     = 1'b0;
// assign   ax3_vga_vs     = 1'b0;
// assign   ax3_vga_r      = 5'h0;
// assign   ax3_vga_g      = 6'h0;
// assign   ax3_vga_b      = 5'h0;
//
// assign   ax3_gpio0      = 34'hzzzzzzzzz;
// assign   ax3_gpio1      = 34'hzzzzzzzzz;
//
endmodule
