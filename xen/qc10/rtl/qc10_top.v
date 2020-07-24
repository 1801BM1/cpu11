//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for QMTech Cyclone-10 core board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// Top project module - instantiates the qc10 board itself
//
module qc10
(
   input          qc10_clock_50,     // clock input 50 MHz
                                    //
   input    [1:0] qc10_button,       // push button[1:0]
   output   [0:0] qc10_led,          // LED [0:0]
                                    //
   output         qc10_uart_txd,     // UART transmitter
   input          qc10_uart_rxd,     // UART receiver
                                    //
   inout   [15:0] qc10_dram_dq,      // SDRAM data bus 16 bits
   output  [12:0] qc10_dram_addr,    // SDRAM address bus 13 bits
   output         qc10_dram_ldqm,    // SDRAM low-byte data mask
   output         qc10_dram_udqm,    // SDRAM high-byte data mask
   output         qc10_dram_we_n,    // SDRAM write enable
   output         qc10_dram_cas_n,   // SDRAM column address strobe
   output         qc10_dram_ras_n,   // SDRAM row address strobe
   output         qc10_dram_cs_n,    // SDRAM chip select
   output   [1:0] qc10_dram_ba,      // SDRAM bank address
   output         qc10_dram_clk,     // SDRAM clock
   output         qc10_dram_cke      // SDRAM clock enable
);

//______________________________________________________________________________
//
wire        clk50;               // 50 MHz clock source entry
wire        sys_clk_p;           // system positive clock (all buses)
wire        sys_clk_n;           // system negative clock (180 phase shift)
wire        sys_plock;           //
wire        ena_us, ena_ms;      //
wire        sys_rst, pwr_rst;    //
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
                                 //
wire        tog1_out;            // button controlled bits
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
   .osc_clk(clk50),              // external oscillator clock
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(qc10_button[0]),    // external reset button
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
assign clk50   = qc10_clock_50;

`ifdef CONFIG_PLL_50
qc10_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
qc10_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
qc10_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
qc10_pll100 corepll
`endif
(
   .inclk0(clk50),
   .c0(sys_clk_p),
   .c1(sys_clk_n),
   .locked(sys_plock)
);

//______________________________________________________________________________
//
wbc_toggle tog1
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(qc10_button[1]),
   .ena_ms(ena_ms),
   .out(tog1_out)
);

//______________________________________________________________________________
//
assign ext_ready = 1'b1;
assign ext_una = `CONFIG_RESET_START_ADDRESS;

always @(posedge sys_clk_p)
begin
   ena_timer <= tog1_out;
   ena_slow  <= 1'b0;
   ext_halt  <= 1'b0;
end

//______________________________________________________________________________
//
assign qc10_uart_txd = uart_txd;
assign uart_rxd = qc10_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign qc10_dram_dq      = 16'hzzzz;
assign qc10_dram_addr    = 13'h0000;
assign qc10_dram_ldqm    = 1'b0;
assign qc10_dram_udqm    = 1'b0;
assign qc10_dram_we_n    = 1'b1;
assign qc10_dram_cas_n   = 1'b1;
assign qc10_dram_ras_n   = 1'b1;
assign qc10_dram_cs_n    = 1'b1;
assign qc10_dram_ba[0]   = 1'b0;
assign qc10_dram_ba[1]   = 1'b0;
assign qc10_dram_clk     = sys_clk_p;
assign qc10_dram_cke     = 1'b1;

assign qc10_led[0]       = ~tog1_out;

//______________________________________________________________________________
//
endmodule
