//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for DE10-Lite board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// Top project module - instantiates the DE10-lite board itself
//
module de10
(
   input          de10_clock_10,       // ADC clock input 10 MHz
   input          de10_clock_50,       // clock input 50 MHz
   input          de10_clock_50_2,     // clock input 50 MHz
                                       //
   input    [1:0] de10_button,         // push buttons
   input    [9:0] de10_sw,             // DPDT toggle switches
                                       //
   output   [7:0] de10_hex0,           // seven segment digit 0
   output   [7:0] de10_hex1,           // seven segment digit 1
   output   [7:0] de10_hex2,           // seven segment digit 2
   output   [7:0] de10_hex3,           // seven segment digit 3
   output   [7:0] de10_hex4,           // seven segment digit 4
   output   [7:0] de10_hex5,           // seven segment digit 5
   output   [9:0] de10_ledr,           // LEDs red
                                       //
   inout   [15:0] de10_dram_dq,        // SDRAM data bus 15 bits
   output  [12:0] de10_dram_addr,      // SDRAM address bus 13 bits
   output   [1:0] de10_dram_dqm,       // SDRAM byte data lane mask
   output         de10_dram_we_n,      // SDRAM write enable
   output         de10_dram_cas_n,     // SDRAM column address strobe
   output         de10_dram_ras_n,     // SDRAM row address strobe
   output         de10_dram_cs_n,      // SDRAM chip select
   output   [1:0] de10_dram_ba,        // SDRAM bank address
   output         de10_dram_clk,       // SDRAM clock
   output         de10_dram_cke,       // SDRAM clock enable
                                       //
   output         de10_vga_hs,         // VGA H_SYNC
   output         de10_vga_vs,         // VGA V_SYNC
   output   [3:0] de10_vga_r,          // VGA Red[3:0]
   output   [3:0] de10_vga_g,          // VGA Green[3:0]
   output   [3:0] de10_vga_b,          // VGA Blue[3:0]
                                       //
   output         de10_gsensor_cs_n,   //
   input    [2:1] de10_gsensor_int,    //
   output         de10_gsensor_sclk,   //
   inout          de10_gsensor_sdi,    //
   inout          de10_gsensor_sdo,    //
                                       //
   inout   [15:0] de10_uino_d,         // Arduino I/O
   inout          de10_uino_rst_n,     // Arduino reset
                                       //
   inout   [35:0] de10_gpio_d          // Generic I/O
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

`ifdef CONFIG_CPU_VM3
wbc_vm3 cpu
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
   .ext_reset(de10_button[0]),   // external reset button
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
assign clk50 = de10_clock_50;

`ifdef CONFIG_PLL_50
de10_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
de10_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
de10_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
de10_pll100 corepll
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
   ena_timer <= de10_sw[0];
   ena_slow  <= de10_sw[1];
   ext_halt  <= de10_sw[2];
end

//______________________________________________________________________________
//
assign de10_uino_d[15]  = uart_txd;
assign de10_uino_d[14]  = 1'bz;
assign de10_uino_d[13]  = uart_rts;
assign uart_cts         = 1'b0;
assign uart_rxd         = de10_uino_d[14];

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign de10_dram_dq        = 16'hzzzz;
assign de10_dram_addr      = 13'h0000;
assign de10_dram_dqm       = 2'b00;
assign de10_dram_we_n      = 1'b1;
assign de10_dram_cas_n     = 1'b1;
assign de10_dram_ras_n     = 1'b1;
assign de10_dram_cs_n      = 1'b1;
assign de10_dram_ba[0]     = 1'b0;
assign de10_dram_ba[1]     = 1'b0;
assign de10_dram_clk       = 1'b0;
assign de10_dram_cke       = 1'b0;

assign de10_vga_hs         = 1'b0;
assign de10_vga_vs         = 1'b0;
assign de10_vga_r          = 4'h0;
assign de10_vga_g          = 4'h0;
assign de10_vga_b          = 4'h0;

assign de10_ledr[7:0]      = leds;
assign de10_ledr[9:8]      = 2'hz;

assign de10_hex0           = ~seg_hex0;
assign de10_hex1           = ~seg_hex1;
assign de10_hex2           = ~seg_hex2;
assign de10_hex3           = ~seg_hex3;
assign de10_hex4           = 8'hzz;
assign de10_hex5           = 8'hzz;

assign de10_gpio_d         = 36'hzzzzzzzzz;
assign de10_uino_rst_n     = 1'bz;
assign de10_uino_d[12:10]  = 3'hz;
assign de10_uino_d[7:0]    = tty_dat;
assign de10_uino_d[8]      = tty_stb;
assign de10_uino_d[9]      = tty_end;

assign de10_gsensor_cs_n   = 1'b1;
assign de10_gsensor_sclk   = 1'b0;
assign de10_gsensor_sdi    = 1'bz;
assign de10_gsensor_sdo    = 1'bz;

//______________________________________________________________________________
//
endmodule
