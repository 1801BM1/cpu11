//
// Copyright (c) 2024 by yshestakov@gmail.com
//
// Top module for Sipeed TangNano-9K board based on GW1NR-9C fpga
//______________________________________________________________________________
//
// `define  CONFIG_OSC_CLOCK     27000000
`include "../lib/config.v"


//______________________________________________________________________________
//
// Top project module - instantiates the TangNano-9K board itself
//
module sn9_top
(
   input            sys_clock_27,  // clock input 27 MHz
   input            sys_reset_n,   // push button
   input            sys_user_n,    // push button
   output reg [5:0] sys_led,       // 6x LEDs
   output           sys_uart_txd,  // UART transmitter
   input            sys_uart_rxd   // UART receiver
);

//______________________________________________________________________________
//
wire        clk27;               // 27 MHz clock source entry
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
wire  [7:0] leds;                // output LEDs

reg   [2:0] hsel;                //
wire  [7:0] seg_hex0;            // seven segment digit 0
wire  [7:0] seg_hex1;            // seven segment digit 1
wire  [7:0] seg_hex2;            // seven segment digit 2
wire  [7:0] seg_hex3;            // seven segment digit 3
                                 //
//______________________________________________________________________________
//
// Select of one of the available CPUs
//
`CONFIG_WBC_CPU cpu
(
   .osc_clk(clk27),              // external oscillator clock
   .sys_clk_p(sys_clk_p),        // system clock positive phase
   .sys_clk_n(sys_clk_n),        // system clock negative phase
   .sys_plock(sys_plock),        // PLL is locked
   .sys_us(ena_us),              // microsecond strobe
   .sys_ms(ena_ms),              // millisecond strobe
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(!sys_reset_n),    // external reset button
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
assign clk27   = sys_clock_27;

//`ifdef CONFIG_PLL_54
//`endif
gwn_pll54 corepll (
        .clkin(clk27),       //input clkin
        .clkout(sys_clk_n),  //output clkout
        .clkoutp(sys_clk_p), //output clkoutp
        .lock(sys_plock)     //output lock
);

//______________________________________________________________________________
//
assign ext_ready = 1'b1;
assign ext_una = `CONFIG_START_ADDR_OPTIONS;

always @(posedge sys_clk_p)
begin
   ena_timer <= 1'b1;
   ena_slow  <= 1'b0;
   ext_halt  <= 1'b0;
end

//______________________________________________________________________________
//
assign sys_uart_txd = uart_txd;
assign uart_rxd = sys_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
// assign sys_led[0] = ~leds[0];

reg no_leds[6:0];

always @(posedge sys_clk_p)
begin
    no_leds[6] <= leds[7];
    sys_led[5] <= leds[6];
    sys_led[4] <= leds[5];
    sys_led[3] <= leds[4];
    sys_led[2] <= leds[3];
    sys_led[1] <= leds[2];
    sys_led[0] <= leds[1];
end

//______________________________________________________________________________
//
endmodule
