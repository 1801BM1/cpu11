//______________________________________________________________________________
//
// Copyright (c) 2022 by yshestakov@gmail.com
//
// Top module for QMTECH Kintex-7 DDR3 with daughter board (QK7)
//
`include "../../lib/config.v"

//______________________________________________________________________________
//
// Top project module - instantiates the QK7 board itself
//
module qk7_top
(
   input          qk7_clock_50,     // clock input 50 MHz
                                    //
//   input          qk7_reset_n,      // push reset button, core board SW2
   input    [1:0] qk7_button,       // push button [4:0], daughter board
   output   [1:0] qk7_led,          // led outputs: 0 - core board, [5:1] - daughter board
                                    //
   output         qk7_uart_txd,     // UART transmitter
   input          qk7_uart_rxd,     // UART receiver
//   input          qk7_uart_dtr,     // UART DTR
//                                  //
// inout   [15:0] qk7_dram_dq,      // SDRAM data bus 16 bits
// output  [12:0] qk7_dram_addr,    // SDRAM address bus 13 bits
// output         qk7_dram_ldqm,    // SDRAM low-byte data mask
// output         qk7_dram_udqm,    // SDRAM high-byte data mask
// output         qk7_dram_we_n,    // SDRAM write enable
// output         qk7_dram_cas_n,   // SDRAM column address strobe
// output         qk7_dram_ras_n,   // SDRAM row address strobe
// output         qk7_dram_cs_n,    // SDRAM chip select
// output   [1:0] qk7_dram_ba,      // SDRAM bank address
// output         qk7_dram_clk,     // SDRAM clock
// output         qk7_dram_cke,     // SDRAM clock enable
//                                  //
// output         qk7_spi_cs_n,     // SPI FLASH chip select
// output         qk7_spi_clk,      // SPI FLASH clock
// output         qk7_spi_mosi,     // SPI FLASH master output
// input          qk7_spi_miso,     // SPI FLASH master input
//                                  //
// inout          qk7_sd_cs_n,      // SD Card chip select
// inout          qk7_sd_clk,       // SD Card clock
// inout          qk7_sd_mosi,      // SD Card master output
// inout          qk7_sd_miso,      // SD Card master input
//                                  //
// inout          qk7_i2c_clk,      // I2C Clock
// inout          qk7_i2c_dat,      // I2C Data
// output         qk7_rtc_rst_n,    // RTC DS1302 reset
// output         qk7_rtc_sclk,     // RTC DS1302_serial clock
// inout          qk7_rtc_sdat,     // RTC DS1302 serial data_
//                                  //
// output         qk7_vga_hs,       // VGA H_SYNC
// output         qk7_vga_vs,       // VGA V_SYNC
// output   [4:0] qk7_vga_r,        // VGA Red[4:0]
// output   [5:0] qk7_vga_g,        // VGA Green[5:0]
// output   [4:0] qk7_vga_b,        // VGA Blue[4:0]
//                                  //
// inout   [33:0] qk7_gpio0,        // GPIO Connection 0
// inout   [33:0] qk7_gpio1         // GPIO Connection 1
   inout   [1:0]  qk7_gpio1         // GPIO Connection 1
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
wire        uart_rxd, uart_txd, uart_cts;  // serial data
                                 //
wire        tty_end, tty_stb;    // debug
wire  [7:0] tty_dat;             // debug data
                                 //
wire  [1:0] leds;                // output LEDs
wire  [5:0] no_leds;

//______________________________________________________________________________
//
// Select of one of the available CPUs
`CONFIG_WBC_CPU cpu
(
   .osc_clk(sys_clk_p),          // qa7_clock_50 can feed PLL only
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(qk7_button[0]),    // external reset button
   .ext_ready(ext_ready),        // external system ready
   .ext_una(ext_una),            // config word/start address
   .ext_halt(ext_halt),          // external halt request
   .ena_timer(ena_timer),        // enable system timer
   .ena_slow(ena_slow),          // enable slow clock
                                 //
   .uart_rxd(uart_rxd),          // serial data input
   .uart_txd(uart_txd),          // serial data output
   .uart_cts(uart_cts),          // UART clear to send (inverted)
                                 //
   .tty_end(tty_end),            // debug stop
   .tty_stb(tty_stb),            // debug data strobe
   .tty_dat(tty_dat),            // debug data value
                                 //
   .seg_hex0(seg_hex0),          // seven segment digit 0
   .seg_hex1(seg_hex1),          // seven segment digit 1
   .seg_hex2(seg_hex2),          // seven segment digit 2
   .leds({no_leds, leds})        // output LEDs
);

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign clk50   = qk7_clock_50;

`CONFIG_WBC_PLL corepll
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
   ext_halt <= 1'b0;

//______________________________________________________________________________
//
assign qk7_uart_txd = uart_txd;
assign uart_rxd = qk7_uart_rxd;

assign qk7_led = leds[1:0];

//______________________________________________________________________________
//
wbc_toggle tog1
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(qk7_button[1]),
   .ena_ms(ena_ms),
   .out(ena_timer)
);

wbc_toggle tog2
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(1), // qk7_button[1]),
   .ena_ms(ena_ms),
   .out(ena_slow)
);

//______________________________________________________________________________
//
// Temporary and debug assignments
assign   qk7_gpio1[0]   = ena_us;
assign   qk7_gpio1[1]   = ena_ms;
//
endmodule

module `CONFIG_WBC_MEM
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
  wire [1:0] byteena;
  reg  [1:0] ack;

  ram_sp_nc 
  u_mem (
   .addr(wb_adr_i[13:1]),
   .clk(wb_clk_i),
   .din(wb_dat_i),
   .dout(wb_dat_o),
   .en(wb_cyc_i & wb_stb_i),
   .we(byteena)
  );
  defparam u_mem.MEMF = `CPU_TEST_MEMN;
  defparam u_mem.ADDR_WIDTH = 13; // 2**13 = 8192 x16 bit

  assign byteena = wb_we_i ? wb_sel_i : 2'b00;
  assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);

  always @ (posedge wb_clk_i)
  begin
     ack[0] <= wb_cyc_i & wb_stb_i;
     ack[1] <= wb_cyc_i & ack[0];
  end

endmodule
