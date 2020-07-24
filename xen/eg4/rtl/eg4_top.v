//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for Lichee Tang EG4S20 board based system
//______________________________________________________________________________
//
`define  CONFIG_OSC_CLOCK     24000000
`include "../../lib/config.v"

//______________________________________________________________________________
//
// Top project module - instantiates the Lichee Tang board itself
//
module eg4
(
   input          eg4_clock_24,  // clock input 24 MHz
   input    [0:0] eg4_button,    // push button
   output   [2:0] eg4_led,       // LEDs (RGB)
   output         eg4_uart_txd,  // UART transmitter
   input          eg4_uart_rxd   // UART receiver
);

//______________________________________________________________________________
//
wire        clk24;               // 24 MHz clock source entry
wire        sys_clk_p;           // system positive clock (all buses)
wire        sys_clk_n;           // system negative clock (180 phase shift)
wire        sys_plock;           //
                                 //
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
   .osc_clk(clk24),              // external oscillator clock
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(eg4_button[0]),    // external reset button
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
assign clk24   = eg4_clock_24;

`ifdef CONFIG_PLL_50
eg4_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
eg4_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
eg4_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
eg4_pll100 corepll
`endif
(
   .refclk(clk24),
   .reset(1'b0),
   .extlock(sys_plock),
   .clk0_out(sys_clk_p),
   .clk1_out(sys_clk_n)
);

//______________________________________________________________________________
//
assign ext_ready = 1'b1;
assign ext_una = `CONFIG_RESET_START_ADDRESS;

always @(posedge sys_clk_p)
begin
   ena_timer <= 1'b1;
   ena_slow  <= 1'b0;
   ext_halt  <= 1'b0;
end

//______________________________________________________________________________
//
assign eg4_uart_txd = uart_txd;
assign uart_rxd = eg4_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
assign eg4_led = ~leds[2:0];

//______________________________________________________________________________
//
endmodule
