//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for DE2-115 board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// Top project module - instantiates the DE2-115 board itself
//
module de2
(
   input          de2_clock_50,        // clock input 50 MHz
   input          de2_clock_50_2,      // clock input 50 MHz
   input          de2_clock_50_3,      // clock input 50 MHz
   input          de2_clock_25,        // Ethernet clock 25MHz
   input          de2_sma_clkin,       // SMA socket clock input
   output         de2_sma_clkout,      // SMA socket clock output
                                       //
   input    [3:0] de2_button,          // push buttons
   input   [17:0] de2_sw,              // DPDT toggle switches
                                       //
   output   [6:0] de2_hex0,            // seven segment digit 0
   output   [6:0] de2_hex1,            // seven segment digit 1
   output   [6:0] de2_hex2,            // seven segment digit 2
   output   [6:0] de2_hex3,            // seven segment digit 3
   output   [6:0] de2_hex4,            // seven segment digit 4
   output   [6:0] de2_hex5,            // seven segment digit 5
   output   [6:0] de2_hex6,            // seven segment digit 6
   output   [6:0] de2_hex7,            // seven segment digit 7
   output   [8:0] de2_ledg,            // LEDs green
   output  [17:0] de2_ledr,            // LEDs red
                                       //
   output         de2_uart_txd,        // UART transmitter
   input          de2_uart_rxd,        // UART receiver
   output         de2_uart_cts,        // UART clear to send
   input          de2_uart_rts,        // UART request to send
                                       //
   inout   [31:0] de2_dram_dq,         // SDRAM data bus 32 bits
   output  [12:0] de2_dram_addr,       // SDRAM address bus 13 bits
   output   [3:0] de2_dram_dqm,        // SDRAM byte data lane mask
   output         de2_dram_we_n,       // SDRAM write enable
   output         de2_dram_cas_n,      // SDRAM column address strobe
   output         de2_dram_ras_n,      // SDRAM row address strobe
   output         de2_dram_cs_n,       // SDRAM chip select
   output   [1:0] de2_dram_ba,         // SDRAM bank address
   output         de2_dram_clk,        // SDRAM clock
   output         de2_dram_cke,        // SDRAM clock enable
                                       //
   inout   [15:0] de2_sram_dq,         // SRAM Data bus 16 Bits
   output  [19:0] de2_sram_addr,       // SRAM Address bus 20 Bits
   output         de2_sram_ub_n,       // SRAM High-byte Data Mask
   output         de2_sram_lb_n,       // SRAM Low-byte Data Mask
   output         de2_sram_we_n,       // SRAM Write Enable
   output         de2_sram_ce_n,       // SRAM Chip Enable
   output         de2_sram_oe_n,       // SRAM Output Enable
                                       //
   inout    [7:0] de2_fl_dq,           // FLASH data bus 8 Bits
   output  [22:0] de2_fl_addr,         // FLASH address bus 23 Bits
   output         de2_fl_we_n,         // FLASH write enable
   output         de2_fl_rst_n,        // FLASH reset
   output         de2_fl_oe_n,         // FLASH output enable
   output         de2_fl_ce_n,         // FLASH chip enable
   output         de2_fl_wp_n,         // FLASH hardware write protect
   input          de2_fl_rb,           // FLASH ready/busy
                                       //
   output         de2_lcd_blig,        // LCD back light ON/OFF
   output         de2_lcd_on,          // LCD power ON
   output         de2_lcd_rw,          // LCD read/write select, 0 = write, 1 = read
   output         de2_lcd_en,          // LCD enable
   output         de2_lcd_rs,          // LCD command/data select, 0 = command, 1 = data
   inout    [7:0] de2_lcd_data,        // LCD data bus 8 bits
                                       //
   inout    [3:0] de2_sd_dat,          // SD Card Data
   inout          de2_sd_cmd,          // SD Card Command Signal
   output         de2_sd_clk,          // SD Card Clock
   input          de2_sd_wp_n,         // SD Card Write Protect
                                       //
   inout          de2_ps2_kbdat,       // PS2 Keyboard Data
   inout          de2_ps2_kbclk,       // PS2 Keyboard Clock
   inout          de2_ps2_msdat,       // PS2 Mouse Data
   inout          de2_ps2_msclk,       // PS2 Mouse Clock
                                       //
   output         de2_vga_hs,          // VGA H_SYNC
   output         de2_vga_vs,          // VGA V_SYNC
   output   [7:0] de2_vga_r,           // VGA Red[3:0]
   output   [7:0] de2_vga_g,           // VGA Green[3:0]
   output   [7:0] de2_vga_b,           // VGA Blue[3:0]
   output         de2_vga_blank_n,     // VGA blank
   output         de2_vga_clk,         // VGA clock
   output         de2_vga_sync_n,      // VGA synchro
                                       //
   output         de2_enet0_gtx_clk,   // Ethernet 0 RGMII
   input          de2_enet0_int_n,     //
   output         de2_enet0_mdc,       //
   inout          de2_enet0_mdio,      //
   output         de2_enet0_rst_n,     //
   input          de2_enet0_rx_clk,    //
   input          de2_enet0_rx_col,    //
   input          de2_enet0_rx_crs,    //
   input    [3:0] de2_enet0_rx_dat,    //
   input          de2_enet0_rx_dv,     //
   input          de2_enet0_rx_er,     //
   input          de2_enet0_tx_clk,    //
   output   [3:0] de2_enet0_tx_dat,    //
   output         de2_enet0_tx_en,     //
   output         de2_enet0_tx_er,     //
   input          de2_enet0_link100,   //
                                       //
   output         de2_enet1_gtx_clk,   // Ethernet 1 RGMII
   input          de2_enet1_int_n,     //
   output         de2_enet1_mdc,       //
   inout          de2_enet1_mdio,      //
   output         de2_enet1_rst_n,     //
   input          de2_enet1_rx_clk,    //
   input          de2_enet1_rx_col,    //
   input          de2_enet1_rx_crs,    //
   input    [3:0] de2_enet1_rx_dat,    //
   input          de2_enet1_rx_dv,     //
   input          de2_enet1_rx_er,     //
   input          de2_enet1_tx_clk,    //
   output   [3:0] de2_enet1_tx_dat,    //
   output         de2_enet1_tx_en,     //
   output         de2_enet1_tx_er,     //
   input          de2_enet1_link100,   //
                                       //
   inout   [15:0] de2_otg_dat,         // USB OTG controller
   output   [1:0] de2_otg_addr,        //
   output         de2_otg_cs_n,        //
   output         de2_otg_wr_n,        //
   output         de2_otg_rd_n,        //
   input    [1:0] de2_otg_int,         //
   output         de2_otg_rst_n,       //
   input    [1:0] de2_otg_dreq,        //
   output   [1:0] de2_otg_dack_n,      //
   inout          de2_otg_fspeed,      //
   inout          de2_otg_lspeed,      //
                                       //
   inout   [35:0] de2_gpio,            // GPIO Connection Data
   inout    [6:0] de2_exio,            // Extend IO pins
   input          de2_irda,            //
                                       //
   output         de2_aud_adclrck,     // Audio CODEC ADC LR Clock
   input          de2_aud_adcdat,      // Audio CODEC ADC Data
   output         de2_aud_daclrck,     // Audio CODEC DAC LR Clock
   output         de2_aud_dacdat,      // Audio CODEC DAC Data
   inout          de2_aud_bclk,        // Audio CODEC Bit-Stream Clock
   output         de2_aud_xck,         // Audio CODEC Chip Clock
                                       //
   inout          de2_i2c_dat,         // I2C Data, Audio and TV
   inout          de2_i2c_clk,         // I2C Clock, Audio and TV
   inout          de2_eeprom_dat,      // I2C Data, EEPROM
   inout          de2_eeprom_clk,      // I2C Clock, EEPROM
                                       //
   input          de2_td_clk27,        // TV Decoder
   input    [7:0] de2_td_dat,          //
   input          de2_td_hs,           //
   input          de2_td_vs,           //
   output         de2_td_rst_n,        //
                                       //
   input          de2_hsmc_clkin_p1,   // HSMC (LVDS)
   input          de2_hsmc_clkin_p2,   //
   input          de2_hsmc_clkin0,     //
   output         de2_hsmc_clkout_p1,  //
   output         de2_hsmc_clkout_p2,  //
   output         de2_hsmc_clkout0,    //
   inout    [3:0] de2_hsmc_d,          //
   input   [16:0] de2_hsmc_rxd_p,      //
   output  [16:0] de2_hsmc_txd_p       //
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
   .ext_reset(de2_button[0]),    // external reset button
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
assign clk50   = de2_clock_50;

`ifdef CONFIG_PLL_50
de2_pll50 corepll
`endif
`ifdef CONFIG_PLL_66
de2_pll66 corepll
`endif
`ifdef CONFIG_PLL_75
de2_pll75 corepll
`endif
`ifdef CONFIG_PLL_100
de2_pll100 corepll
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
   ena_timer <= de2_sw[0];
   ena_slow  <= de2_sw[1];
   ext_halt  <= de2_sw[2];
end

//______________________________________________________________________________
//
assign de2_uart_txd = uart_txd;
assign de2_uart_cts = uart_rts;
assign uart_rxd = de2_uart_rxd;
assign uart_cts = 1'b0;


//______________________________________________________________________________
//
// Simulation stop flag and console (no DE2-115 simulation project)
// Be careful - on real DE2-115 board LCD requires power enabled
//
// assign lcd_rs    = wb_stb & wb_cyc & ((wb_adr == 16'o177676) | (wb_adr == 16'o177674));
// assign lcd_data  = wb_out[7:0];
// assign lcd_en    = (wb_adr == 16'o177566) & wb_stb & wb_we & wb_ack;
//
//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign de2_hex0      = ~seg_hex0[6:0];
assign de2_hex1      = ~seg_hex1[6:0];
assign de2_hex2      = ~seg_hex2[6:0];
assign de2_hex3      = ~seg_hex3[6:0];

assign de2_ledg[8]   = 1'hz;
assign de2_ledg[7:0] = leds;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign de2_dram_dq         = 32'hzzzzzzzz;
assign de2_dram_addr       = 13'h0000;
assign de2_dram_dqm        = 4'b0;
assign de2_dram_we_n       = 1'b1;
assign de2_dram_cas_n      = 1'b1;
assign de2_dram_ras_n      = 1'b1;
assign de2_dram_cs_n       = 1'b1;
assign de2_dram_ba[0]      = 1'b0;
assign de2_dram_ba[1]      = 1'b0;
assign de2_dram_clk        = 1'b0;
assign de2_dram_cke        = 1'b0;

assign de2_sram_dq         = 16'hzzzz;
assign de2_sram_addr       = 20'h00000;
assign de2_sram_ub_n       = 1'b1;
assign de2_sram_lb_n       = 1'b1;
assign de2_sram_we_n       = 1'b1;
assign de2_sram_ce_n       = 1'b1;
assign de2_sram_oe_n       = 1'b1;

assign de2_fl_dq           = 8'hzz;
assign de2_fl_addr         = 23'h000000;
assign de2_fl_we_n         = 1'b1;
assign de2_fl_rst_n        = 1'b0;
assign de2_fl_oe_n         = 1'b1;
assign de2_fl_ce_n         = 1'b1;
assign de2_fl_wp_n         = 1'b0;

assign de2_lcd_data        = 8'hzz;
assign de2_lcd_blig        = 1'b0;
assign de2_lcd_on          = 1'b0;
assign de2_lcd_rw          = 1'b0;
assign de2_lcd_en          = 1'b0;
assign de2_lcd_rs          = 1'b0;

assign de2_sd_dat          = 4'hz;
assign de2_sd_cmd          = 1'hz;
assign de2_sd_clk          = 1'h0;

assign de2_ps2_kbdat       = 1'hz;
assign de2_ps2_kbclk       = 1'hz;
assign de2_ps2_msdat       = 1'hz;
assign de2_ps2_msclk       = 1'hz;

assign de2_vga_blank_n     = 1'b0;
assign de2_vga_hs          = 1'b00;
assign de2_vga_vs          = 1'b00;
assign de2_vga_r           = 8'h00;
assign de2_vga_g           = 8'h00;
assign de2_vga_b           = 8'h00;
assign de2_vga_clk         = 1'b00;
assign de2_vga_sync_n      = 1'b00;
assign de2_td_rst_n        = 1'b0;

assign de2_gpio[35:10]     = 26'hzzzzzzz;
assign de2_exio            = 7'hzz;
assign de2_ledr            = 18'hzzzzz;

assign de2_enet0_gtx_clk   = 1'b0;
assign de2_enet0_mdc       = 1'b0;
assign de2_enet0_mdio      = 1'bz;
assign de2_enet0_rst_n     = 1'b0;
assign de2_enet0_tx_dat    = 4'h0;
assign de2_enet0_tx_en     = 1'b0;
assign de2_enet0_tx_er     = 1'b0;

assign de2_enet1_gtx_clk   = 1'b0;
assign de2_enet1_mdc       = 1'b0;
assign de2_enet1_mdio      = 1'bz;
assign de2_enet1_rst_n     = 1'b0;
assign de2_enet1_tx_dat    = 4'h0;
assign de2_enet1_tx_en     = 1'b0;
assign de2_enet1_tx_er     = 1'b0;

assign de2_i2c_dat         = 1'bz;
assign de2_i2c_clk         = 1'bz;
assign de2_eeprom_dat      = 1'bz;
assign de2_eeprom_clk      = 1'bz;

assign de2_otg_dat         = 16'hzzzz;
assign de2_otg_addr        = 2'b00;
assign de2_otg_cs_n        = 1'b1;
assign de2_otg_wr_n        = 1'b1;
assign de2_otg_rd_n        = 1'b1;
assign de2_otg_rst_n       = 1'b1;
assign de2_otg_dack_n      = 2'b11;
assign de2_otg_fspeed      = 1'bz;
assign de2_otg_lspeed      = 1'bz;

assign de2_aud_adclrck     = 1'bz;
assign de2_aud_daclrck     = 1'bz;
assign de2_aud_dacdat      = 1'bz;
assign de2_aud_bclk        = 1'b0;
assign de2_aud_xck         = 1'b0;

assign de2_hsmc_clkout_p1  = 1'b0;
assign de2_hsmc_clkout_p2  = 1'b0;
assign de2_hsmc_clkout0    = 1'b0;
assign de2_hsmc_d          = 4'hz;
assign de2_hsmc_txd_p      = 16'h0000;
assign de2_sma_clkout      = 1'b0;

assign de2_hex4            = 7'hzz;
assign de2_hex5            = 7'hzz;
assign de2_hex6            = 7'hzz;
assign de2_hex7            = 7'hzz;

assign de2_gpio[7:0]       = tty_dat;
assign de2_gpio[8]         = tty_end;
assign de2_gpio[9]         = tty_stb;
assign de2_gpio[35:10]     = 26'hzzzzzzz;


//______________________________________________________________________________
//
endmodule
