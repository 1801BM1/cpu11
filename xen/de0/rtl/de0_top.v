//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Top module for DE0 board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// Top project module - instantiates the DE0 board itself
//
module de0
(
   input          de0_clock_50,     // clock input 50 MHz
   input          de0_clock_50_2,   // clock input 50 MHz
                                    //
   input    [2:0] de0_button,       // push button[2:0]
                                    //
   input    [9:0] de0_sw,           // DPDT toggle switch[9:0]
   output   [7:0] de0_hex0,         // seven segment digit 0
   output   [7:0] de0_hex1,         // seven segment digit 1
   output   [7:0] de0_hex2,         // seven segment digit 2
   output   [7:0] de0_hex3,         // seven segment digit 3
   output   [9:0] de0_led,          // LED green[9:0]
                                    //
   output         de0_uart_txd,     // UART transmitter
   input          de0_uart_rxd,     // UART receiver
   output         de0_uart_cts,     // UART clear to send (inverted)
   input          de0_uart_rts,     // UART request to send  (inverted)
                                    //
   inout   [15:0] de0_dram_dq,      // SDRAM data bus 16 bits
   output  [12:0] de0_dram_addr,    // SDRAM address bus 13 bits
   output         de0_dram_ldqm,    // SDRAM low-byte data mask
   output         de0_dram_udqm,    // SDRAM high-byte data mask
   output         de0_dram_we_n,    // SDRAM write enable
   output         de0_dram_cas_n,   // SDRAM column address strobe
   output         de0_dram_ras_n,   // SDRAM row address strobe
   output         de0_dram_cs_n,    // SDRAM chip select
   output   [1:0] de0_dram_ba,      // SDRAM bank address
   output         de0_dram_clk,     // SDRAM clock
   output         de0_dram_cke,     // SDRAM clock enable
                                    //
   inout   [15:0] de0_fl_dq,        // FLASH data bus 15 Bits
   output  [21:0] de0_fl_addr,      // FLASH address bus 22 Bits
   output         de0_fl_we_n,      // FLASH write enable
   output         de0_fl_rst_n,     // FLASH reset
   output         de0_fl_oe_n,      // FLASH output enable
   output         de0_fl_ce_n,      // FLASH chip enable
   output         de0_fl_wp_n,      // FLASH hardware write protect
   output         de0_fl_byte_n,    // FLASH selects 8/16-bit mode
   input          de0_fl_rb,        // FLASH ready/busy
                                    //
   output         de0_lcd_blig,     // LCD back light ON/OFF
   output         de0_lcd_rw,       // LCD read/write select, 0 = write, 1 = read
   output         de0_lcd_en,       // LCD enable
   output         de0_lcd_rs,       // LCD command/data select, 0 = command, 1 = data
   inout    [7:0] de0_lcd_data,     // LCD data bus 8 bits
                                    //
   inout          de0_sd_dat0,      // SD Card Data 0
   inout          de0_sd_dat3,      // SD Card Data 3
   inout          de0_sd_cmd,       // SD Card Command Signal
   output         de0_sd_clk,       // SD Card Clock
   input          de0_sd_wp_n,      // SD Card Write Protect
                                    //
   inout          de0_ps2_kbdat,    // PS2 Keyboard Data
   inout          de0_ps2_kbclk,    // PS2 Keyboard Clock
   inout          de0_ps2_msdat,    // PS2 Mouse Data
   inout          de0_ps2_msclk,    // PS2 Mouse Clock
                                    //
   output         de0_vga_hs,       // VGA H_SYNC
   output         de0_vga_vs,       // VGA V_SYNC
   output   [3:0] de0_vga_r,        // VGA Red[3:0]
   output   [3:0] de0_vga_g,        // VGA Green[3:0]
   output   [3:0] de0_vga_b,        // VGA Blue[3:0]
                                    //
   input    [1:0] de0_gpio0_clkin,  // GPIO Connection 0 Clock In Bus
   output   [1:0] de0_gpio0_clkout, // GPIO Connection 0 Clock Out Bus
   inout   [31:0] de0_gpio0_d,      // GPIO Connection 0 Data Bus
                                    //
   input    [1:0] de0_gpio1_clkin,  // GPIO Connection 1 Clock In Bus
   output   [1:0] de0_gpio1_clkout, // GPIO Connection 1 Clock Out Bus
   inout   [31:0] de0_gpio1_d       // GPIO Connection 1 Data Bus
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
wire        tog1_out, tog2_out;  // button controlled bits
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
   .sys_rst(sys_rst),            // system reset
   .pwr_rst(pwr_rst),            // power-on reset
                                 //
   .ext_reset(de0_button[0]),    // external reset button
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
assign clk50   = de0_clock_50_2;

`ifdef CONFIG_PLL_50
de0_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
de0_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
de0_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
de0_pll100 corepll
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
   .but_n(de0_button[1]),
   .ena_ms(ena_ms),
   .out(tog1_out)
);

wbc_toggle tog2
(
   .clk(sys_clk_p),
   .rst(pwr_rst),
   .but_n(de0_button[2]),
   .ena_ms(ena_ms),
   .out(tog2_out)
);

//______________________________________________________________________________
//
assign ext_ready = 1'b1;
assign ext_una = `CONFIG_START_ADDR_OPTIONS;

always @(posedge sys_clk_p)
begin
   ena_timer <= de0_sw[0];
   ena_slow  <= de0_sw[1];
   ext_halt  <= de0_sw[2];
end

//______________________________________________________________________________
//
assign de0_uart_txd = uart_txd;
assign de0_uart_cts = uart_rts;
assign uart_rxd = de0_uart_rxd;
assign uart_cts = 1'b0;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign de0_dram_dq      = 16'hzzzz;
assign de0_dram_addr    = 13'h0000;
assign de0_dram_ldqm    = 1'b0;
assign de0_dram_udqm    = 1'b0;
assign de0_dram_we_n    = 1'b1;
assign de0_dram_cas_n   = 1'b1;
assign de0_dram_ras_n   = 1'b1;
assign de0_dram_cs_n    = 1'b1;
assign de0_dram_ba[0]   = 1'b0;
assign de0_dram_ba[1]   = 1'b0;
assign de0_dram_clk     = sys_clk_p;
assign de0_dram_cke     = 1'b1;

assign de0_fl_dq        = 16'hzzzz;
assign de0_fl_addr      = 22'hzzzzzz;
assign de0_fl_we_n      = 1'b1;
assign de0_fl_rst_n     = 1'b0;
assign de0_fl_oe_n      = 1'b1;
assign de0_fl_ce_n      = 1'b1;
assign de0_fl_wp_n      = 1'b0;
assign de0_fl_byte_n    = 1'b1;

assign de0_lcd_data     = tty_dat;
assign de0_lcd_blig     = 1'b0;
assign de0_lcd_rw       = 1'b0;
assign de0_lcd_en       = tty_stb;
assign de0_lcd_rs       = tty_end;

assign de0_sd_clk       = 1'b0;
assign de0_sd_dat0      = 1'hz;
assign de0_sd_dat3      = 1'hz;
assign de0_sd_cmd       = 1'hz;

assign de0_ps2_kbdat    = 1'hz;
assign de0_ps2_kbclk    = 1'hz;
assign de0_ps2_msdat    = 1'hz;
assign de0_ps2_msclk    = 1'hz;

assign de0_vga_hs       = 1'b0;
assign de0_vga_vs       = 1'b0;
assign de0_vga_r        = 4'h0;
assign de0_vga_g        = 4'h0;
assign de0_vga_b        = 4'h0;

assign de0_hex0         = ~seg_hex0;
assign de0_hex1         = ~seg_hex1;
assign de0_hex2         = ~seg_hex2;
assign de0_hex3         = ~seg_hex3;
assign de0_led[7:0]     = leds;
assign de0_led[8]       = tog1_out;
assign de0_led[9]       = tog2_out;

assign de0_gpio0_clkout = 2'b00;
assign de0_gpio1_clkout = 2'b00;
assign de0_gpio0_d      = 32'hzzzzzzzz;
assign de0_gpio1_d      = 32'hzzzzzzzz;

//______________________________________________________________________________
//
endmodule
