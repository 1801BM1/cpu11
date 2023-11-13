//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Testbench for the DE0 board with various Wishbone CPUs
//______________________________________________________________________________
//
`include "../../lib/config.v"

module tb1();

reg         clk50;
reg [2:0]   button;
reg [9:0]   switch;
wire [7:0]  hex0, hex1, hex2, hex3;
wire [9:0]  led;
                           //
wire        uart_txd;      // UART transmitter
reg         uart_rxd;      // UART receiver
wire        uart_cts;      // UART clear to send
reg         uart_rts;      // UART request to send
                           //
wire [15:0] dram_dq;       // SDRAM data bus 16 bits
wire [12:0] dram_addr;     // SDRAM address bus 13 bits
wire        dram_ldqm;     // SDRAM low-byte data mask
wire        dram_udqm;     // SDRAM high-byte data mask
wire        dram_we_n;     // SDRAM write enable
wire        dram_cas_n;    // SDRAM column address strobe
wire        dram_ras_n;    // SDRAM row address strobe
wire        dram_cs_n;     // SDRAM chip select
wire [1:0]  dram_ba;       // SDRAM bank address
wire        dram_clk;      // SDRAM clock
wire        dram_cke;      // SDRAM clock enable
                           //
wire [15:0] fl_dq;         // FLASH data bus 15 Bits
wire [21:0] fl_addr;       // FLASH address bus 22 Bits
wire        fl_we_n;       // FLASH write enable
wire        fl_rst_n;      // FLASH reset
wire        fl_oe_n;       // FLASH output enable
wire        fl_ce_n;       // FLASH chip enable
wire        fl_wp_n;       // FLASH hardware write protect
wire        fl_byte_n;     // FLASH selects 8/16-bit mode
wire        fl_rb;         // FLASH ready/busy
                           //
wire        lcd_blig;      // LCD back light ON/OFF
wire        lcd_rw;        // LCD read/write select, 0 = write, 1 = read
wire        lcd_en;        // LCD enable
wire        lcd_rs;        // LCD command/data select, 0 = command, 1 = data
wire [7:0]  lcd_data;      // LCD data bus 8 bits
                           //
wire        sd_dat0;       // SD Card Data 0
wire        sd_dat3;       // SD Card Data 3
wire        sd_cmd;        // SD Card Command Signal
wire        sd_clk;        // SD Card Clock
wire        sd_wp_n;       // SD Card Write Protect
                           //
wire        ps2_kbdat;     // PS2 Keyboard Data
wire        ps2_kbclk;     // PS2 Keyboard Clock
wire        ps2_msdat;     // PS2 Mouse Data
wire        ps2_msclk;     // PS2 Mouse Clock
                           //
wire        vga_hs;        // VGA H_SYNC
wire        vga_vs;        // VGA V_SYNC
wire [3:0]  vga_r;         // VGA Red[3:0]
wire [3:0]  vga_g;         // VGA Green[3:0]
wire [3:0]  vga_b;         // VGA Blue[3:0]
                           //
wire [1:0]  gpio0_clkin;   // GPIO Connection 0 Clock In Bus
wire [1:0]  gpio0_clkout;  // GPIO Connection 0 Clock Out Bus
wire [31:0] gpio0_d;       // GPIO Connection 0 Data Bus
                           //
wire [1:0]  gpio1_clkin;   // GPIO Connection 1 Clock In Bus
wire [1:0]  gpio1_clkout;  // GPIO Connection 1 Clock Out Bus
wire [31:0] gpio1_d;       // GPIO Connection 1 Data Bus

//_____________________________________________________________________________
//
initial
begin
//
// Let PLL to lock incoming clock and short debouncer start time
//
#100000
   de0_top.cpu.reset.count_db = `CONFIG_RESET_BUTTON_DEBOUNCE_MS-1;
   de0_top.cpu.reset.key_down = 0;
// uart_send("T");
// uart_send("E");
// uart_send("S");
// uart_send("T");
end

initial
begin
   clk50 = 0;
   forever
      begin
         #10 clk50 = 0;
         #10 clk50 = 1;
      end
end

initial
begin
   switch = 10'b0000000000;
   uart_rxd = 1'b1;
   uart_rts = 1'b0;
end

initial
begin
   #`CONFIG_SIM_TIME_LIMIT $finish;
end

always @(posedge lcd_en)
begin
#2
   $display("tty: %03O (%c)", lcd_data, (lcd_data > 8'o037) ? lcd_data : 8'o52);
end

always @(posedge lcd_rs)
begin
   $display("Stop on debug request");
   $finish;
end

de0 de0_top(
   .de0_clock_50(clk50),
   .de0_clock_50_2(clk50),
   .de0_button(button),
   .de0_sw(switch),
   .de0_hex0(hex0),
   .de0_hex1(hex1),
   .de0_hex2(hex2),
   .de0_hex3(hex3),
   .de0_led(led),

   .de0_uart_txd(uart_txd),
   .de0_uart_rxd(uart_rxd),
   .de0_uart_cts(uart_cts),
   .de0_uart_rts(uart_rts),

   .de0_dram_dq(dram_dq),
   .de0_dram_addr(dram_addr),
   .de0_dram_ldqm(dram_ldqm),
   .de0_dram_udqm(dram_udqm),
   .de0_dram_we_n(dram_we_n),
   .de0_dram_cas_n(dram_cas_n),
   .de0_dram_ras_n(dram_ras_n),
   .de0_dram_cs_n(dram_cs_n),
   .de0_dram_ba(dram_ba),
   .de0_dram_clk(dram_clk),
   .de0_dram_cke(dram_cke),

   .de0_fl_dq(fl_dq),
   .de0_fl_addr(fl_addr),
   .de0_fl_we_n(fl_we_n),
   .de0_fl_rst_n(fl_rst_n),
   .de0_fl_oe_n(fl_oe_n),
   .de0_fl_ce_n(fl_ce_n),
   .de0_fl_wp_n(fl_wp_n),
   .de0_fl_byte_n(fl_byte_n),
   .de0_fl_rb(fl_rb),

   .de0_lcd_blig(lcd_blig),
   .de0_lcd_rw(lcd_rw),
   .de0_lcd_en(lcd_en),
   .de0_lcd_rs(lcd_rs),
   .de0_lcd_data(lcd_data),

   .de0_sd_dat0(sd_dat0),
   .de0_sd_dat3(sd_dat3),
   .de0_sd_cmd(sd_cmd),
   .de0_sd_clk(sd_clk),
   .de0_sd_wp_n(sd_wp_n),

   .de0_ps2_kbdat(ps2_kbdat),
   .de0_ps2_kbclk(ps2_kbclk),
   .de0_ps2_msdat(ps2_msdat),
   .de0_ps2_msclk(ps2_msclk),

   .de0_vga_hs(vga_hs),
   .de0_vga_vs(vga_vs),
   .de0_vga_r(vga_r),
   .de0_vga_g(vga_g),
   .de0_vga_b(vga_b),

   .de0_gpio0_clkin(gpio0_clkin),
   .de0_gpio0_clkout(gpio0_clkout),
   .de0_gpio0_d(gpio0_d),

   .de0_gpio1_clkin(gpio1_clkin),
   .de0_gpio1_clkout(gpio1_clkout),
   .de0_gpio1_d(gpio1_d)
);

//_____________________________________________________________________________
//
`define  UBIT (1000000000 / `CONFIG_BAUD_RATE)

task uart_send
(
   input [7:0] data
);
begin
   uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b0;
   #`UBIT uart_rxd = data[0];
   #`UBIT uart_rxd = data[1];
   #`UBIT uart_rxd = data[2];
   #`UBIT uart_rxd = data[3];
   #`UBIT uart_rxd = data[4];
   #`UBIT uart_rxd = data[5];
   #`UBIT uart_rxd = data[6];
   #`UBIT uart_rxd = data[7];
   #`UBIT uart_rxd = 1'b1;
   #`UBIT uart_rxd = 1'b1;
end
endtask

//_____________________________________________________________________________
//
endmodule


