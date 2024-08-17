//______________________________________________________________________________
//
// Copyright (c) 2020 by yshestakov@gmail.com
//
// Top module for QMTECH Artix-7 DDR3 with daughter board (QA7)
//
`include "../../lib/config.v"

//______________________________________________________________________________
//
// Top project module - instantiates the QA7 board itself
//
module qa7_top
(
   input          qa7_clock_50,     // clock input 50 MHz
                                    //
   input          qa7_reset_n,      // push reset button, core board SW2
   input    [4:0] qa7_button,       // push button [4:0], daughter board
   output   [5:0] qa7_led,          // led outputs: 0 - core board, [5:1] - daughter board
   output   [7:0] qa7_hex,          // seven segment digit mask
   output   [2:0] qa7_hsel,         // seven segment digit select
                                    //
   output         qa7_uart_txd,     // UART transmitter
   input          qa7_uart_rxd,     // UART receiver
//                                  //
// inout   [15:0] qa7_dram_dq,      // SDRAM data bus 16 bits
// output  [12:0] qa7_dram_addr,    // SDRAM address bus 13 bits
// output         qa7_dram_ldqm,    // SDRAM low-byte data mask
// output         qa7_dram_udqm,    // SDRAM high-byte data mask
// output         qa7_dram_we_n,    // SDRAM write enable
// output         qa7_dram_cas_n,   // SDRAM column address strobe
// output         qa7_dram_ras_n,   // SDRAM row address strobe
// output         qa7_dram_cs_n,    // SDRAM chip select
// output   [1:0] qa7_dram_ba,      // SDRAM bank address
// output         qa7_dram_clk,     // SDRAM clock
// output         qa7_dram_cke,     // SDRAM clock enable
//                                  //
// output         qa7_spi_cs_n,     // SPI FLASH chip select
// output         qa7_spi_clk,      // SPI FLASH clock
// output         qa7_spi_mosi,     // SPI FLASH master output
// input          qa7_spi_miso,     // SPI FLASH master input
//                                  //
// inout          qa7_sd_cs_n,      // SD Card chip select
// inout          qa7_sd_clk,       // SD Card clock
// inout          qa7_sd_mosi,      // SD Card master output
// inout          qa7_sd_miso,      // SD Card master input
//                                  //
// inout          qa7_i2c_clk,      // I2C Clock
// inout          qa7_i2c_dat,      // I2C Data
// output         qa7_rtc_rst_n,    // RTC DS1302 reset
// output         qa7_rtc_sclk,     // RTC DS1302_serial clock
// inout          qa7_rtc_sdat,     // RTC DS1302 serial data_
//                                  //
// output         qa7_vga_hs,       // VGA H_SYNC
// output         qa7_vga_vs,       // VGA V_SYNC
// output   [4:0] qa7_vga_r,        // VGA Red[4:0]
// output   [5:0] qa7_vga_g,        // VGA Green[5:0]
// output   [4:0] qa7_vga_b,        // VGA Blue[4:0]
//                                  //
// inout   [33:0] qa7_gpio0,        // GPIO Connection 0
// inout   [33:0] qa7_gpio1         // GPIO Connection 1
   inout   [1:0]  qa7_gpio1         // GPIO Connection 1
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
                                 //
wire        tty_end, tty_stb;    // debug
wire  [7:0] tty_dat;             // debug data
                                 //
reg   [2:0] hsel;                //
wire  [7:0] seg_hex0;            // seven segment digit 0
wire  [7:0] seg_hex1;            // seven segment digit 1
wire  [7:0] seg_hex2;            // seven segment digit 2
wire  [5:0] leds;                // output LEDs
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

`ifdef CONFIG_CPU_VM3
wbc_vm3 cpu
`endif

`ifdef CONFIG_CPU_LSI
wbc_lsi cpu
`endif

`ifdef CONFIG_CPU_AM4
wbc_am4 cpu
`endif
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
   .ext_reset(qa7_button[0]),    // external reset button
   .ext_ready(ext_ready),        // external system ready
   .ext_una(ext_una),            // config word/start address
   .ext_halt(ext_halt),          // external halt request
   .ena_timer(ena_timer),        // enable system timer
   .ena_slow(ena_slow),          // enable slow clock
                                 //
   .uart_rxd(uart_rxd),          // serial data input
   .uart_txd(uart_txd),          // serial data output
                                 //
   .tty_end(tty_end),            // debug stop
   .tty_stb(tty_stb),            // debug data strobe
   .tty_dat(tty_dat),            // debug data value
                                 //
//   .seg_hex0(seg_hex0),          // seven segment digit 0
//   .seg_hex1(seg_hex1),          // seven segment digit 1
//   .seg_hex2(seg_hex2),          // seven segment digit 2
   .leds(leds)                   // output LEDs
);

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign clk50   = qa7_clock_50;

`ifdef CONFIG_PLL_50
qa7_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
qa7_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
qa7_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
qa7_pll100 corepll
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
   ext_halt  <= 1'b0;

//______________________________________________________________________________
//
assign qa7_uart_txd = uart_txd;
assign uart_rxd = qa7_uart_rxd;

//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign qa7_hex = (hsel == 3'b000) ? ~seg_hex0
               : (hsel == 3'b001) ? ~seg_hex1
               : (hsel == 3'b010) ? ~seg_hex2 : 8'hFF;

assign qa7_hsel[0] = ~(hsel == 3'b000);
assign qa7_hsel[1] = ~(hsel == 3'b001);
assign qa7_hsel[2] = ~(hsel == 3'b010);

always @(posedge sys_clk_p)
begin
	if (~qa7_button[0])
		hsel <= 3'b000;
	else
      if (ena_ms)
         if (hsel == 3'b000)
            hsel <= 3'b101;
         else
            hsel <= hsel - 3'b001;
end

assign qa7_led = leds[5:0];

//______________________________________________________________________________
//
wbc_toggle tog1
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(qa7_button[1]),
   .ena_ms(ena_ms),
   .out(ena_timer)
);

wbc_toggle tog2
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(qa7_button[2]),
   .ena_ms(ena_ms),
   .out(ena_slow)
);

//______________________________________________________________________________
//
// Temporary and debug assignments
//
// assign   qa7_dram_dq    = 16'hzzzz;
// assign   qa7_dram_addr  = 13'h0000;
// assign   qa7_dram_ldqm  = 1'b0;
// assign   qa7_dram_udqm  = 1'b0;
// assign   qa7_dram_we_n  = 1'b1;
// assign   qa7_dram_cas_n = 1'b1;
// assign   qa7_dram_ras_n = 1'b1;
// assign   qa7_dram_cs_n  = 1'b1;
// assign   qa7_dram_ba[0] = 1'b0;
// assign   qa7_dram_ba[1] = 1'b0;
// assign   qa7_dram_clk   = 1'b0;
// assign   qa7_dram_cke   = 1'b0;
//
// assign   qa7_spi_cs_n   = 1'b1;
// assign   qa7_spi_clk    = 1'b0;
// assign   qa7_spi_mosi   = 1'bz;
//
// assign   qa7_sd_cs_n    = 1'bz;
// assign   qa7_sd_clk     = 1'b0;
// assign   qa7_sd_mosi    = 1'bz;
// assign   qa7_sd_miso    = 1'bz;
//
// assign   qa7_i2c_dat    = 1'hz;
// assign   qa7_i2c_clk    = 1'hz;
// assign   qa7_rtc_rst_n  = 1'hz;
// assign   qa7_rtc_sclk   = 1'hz;
// assign   qa7_rtc_sdat   = 1'hz;
assign   qa7_gpio1[0]   = ena_us;
assign   qa7_gpio1[1]   = ena_ms;
//
// assign   qa7_vga_hs     = 1'b0;
// assign   qa7_vga_vs     = 1'b0;
// assign   qa7_vga_r      = 5'h0;
// assign   qa7_vga_g      = 6'h0;
// assign   qa7_vga_b      = 5'h0;
//
// assign   qa7_gpio0      = 34'hzzzzzzzzz;
// assign   qa7_gpio1      = 34'hzzzzzzzzz;
//
endmodule
