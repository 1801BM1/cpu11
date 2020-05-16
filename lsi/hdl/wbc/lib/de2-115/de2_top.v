//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Top module for DE2-115 board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/de2-115/config.v"
// synopsys translate_on
//
`define  DE2_DCLO_WIDTH_CLK         15
`define  DE2_ACLO_DELAY_CLK         7

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

de2_ram16k ram(
   .address(wb_adr_i[13:1]),
   .byteena(ena),
   .clock(wb_clk_i),
   .data(wb_dat_i),
   .rden(~wb_we_i & wb_cyc_i & wb_stb_i),
   .wren( wb_we_i & wb_cyc_i & wb_stb_i),
   .q(wb_dat_o));

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
wire        clk50;                     // 50 MHz clock source entry
wire        sys_clk_p;                 // system positive clock (all buses)
wire        sys_clk_n;                 // system negative clock (180 phase shift)
wire        sys_init;                  // peripheral reset
wire        sys_plock;                 //
wire        ena_us, ena_ms, i50Hz;     //
wire        sys_rst, pwr_rst;          //
wire [1:0]  bsel;                      //
                                       //
wire        wb_clk;                    //
wire [15:0] wb_adr;                    // master address out bus
wire [15:0] wb_out;                    // master data out bus
wire [15:0] wb_mux;                    // master data in bus
wire        wb_cyc;                    // master wishbone cycle
wire        wb_we;                     // master wishbone direction
wire [1:0]  wb_sel;                    // master wishbone byte election
wire        wb_stb;                    // master wishbone strobe
wire        wb_ack;                    // master wishbone acknowledgement
                                       //
wire        vm_istb;                   //
wire        vm_iack;                   //
wire [15:0] vm_ivec;                   //
wire [2:0]  mx_stb;                    //
wire [2:0]  mx_ack;                    // system wishbone data mux
wire [15:0] mx_dat[2:0];               //
                                       //
wire [15:0] vm_in14;                   //
reg  [15:0] vm_reg0, vm_reg1;          //
                                       //
wire        vm_init_out;               //
wire        vm_dclo_in;                //
wire        vm_aclo_in;                //
wire        vm_virq;                   //
wire        vm_halt;                   //
wire        vm_evnt;                   //
                                       //
wire        tx_irq, tx_ack;            //
wire        rx_irq, rx_ack;            //
wire [31:0] baud;                      //
                                       //
//______________________________________________________________________________
//
assign      sys_init = vm_init_out;
assign      baud = 921600/115200-1;

assign      vm_halt  = 1'b0;
assign      vm_evnt  = i50Hz & de2_sw[0];

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign wb_clk  = sys_clk_p;
assign clk50   = de2_clock_50;
assign bsel    = `SIM_CONFIG_BOOT_MODE;

de2_pll75 corepll
(
   .inclk0(clk50),
   .c0(sys_clk_p),
   .c1(sys_clk_n),
   .locked(sys_plock)
);

defparam reset.OSCCLK      = `CONFIG_OSC_CLOCK;
defparam reset.REFCLK      = `CONFIG_SYS_CLOCK;
defparam reset.PWR_WIDTH   = `CONFIG_RESET_PULSE_WIDTH_CLK;
defparam reset.DEBOUNCE    = `CONFIG_RESET_BUTTON_DEBOUNCE_MS;
defparam reset.DCLO_WIDTH  = `DE2_DCLO_WIDTH_CLK;
defparam reset.ACLO_DELAY  = `DE2_ACLO_DELAY_CLK;
defparam reset.SYSTICK     = 20000;

wbc_rst reset
(
   .osc_clk(clk50),
   .sys_clk(wb_clk),
   .pll_lock(sys_plock),
   .button(de2_button[0]),
   .sys_ready(1'b1),

   .pwr_rst(pwr_rst),
   .sys_rst(sys_rst),
   .sys_dclo(vm_dclo_in),
   .sys_aclo(vm_aclo_in),
   .sys_us(ena_us),
   .sys_ms(ena_ms),
   .sys_irq(i50Hz)
);

//______________________________________________________________________________
//
// CPU instantiation
//
lsi_wb cpu
(
   .vm_clk_p(sys_clk_p),               // positive processor clock
   .vm_clk_n(sys_clk_n),               // negative processor clock
   .vm_clk_slow(1'b0),                 // slow clock sim mode
   .vm_clk_ena(1'b1),                  // slow clock strobe
                                       //
   .vm_init(vm_init_out),              // peripheral reset
   .vm_dclo(vm_dclo_in),               // processor reset
   .vm_aclo(vm_aclo_in),               // power fail notoficaton
   .vm_halt(vm_halt),                  // halt mode interrupt requests
   .vm_evnt(vm_evnt),                  // timer interrupt requests
   .vm_virq(vm_virq),                  // vectored interrupt request
   .vm_bsel(bsel),                     //
                                       //
   .wbm_gnt_i(1'b1),                   // master wishbone granted
   .wbm_adr_o(wb_adr),                 // master wishbone address
   .wbm_dat_o(wb_out),                 // master wishbone data output
   .wbm_dat_i(wb_mux),                 // master wishbone data input
   .wbm_cyc_o(wb_cyc),                 // master wishbone cycle
   .wbm_we_o(wb_we),                   // master wishbone direction
   .wbm_sel_o(wb_sel),                 // master wishbone byte election
   .wbm_stb_o(wb_stb),                 // master wishbone strobe
   .wbm_ack_i(wb_ack),                 // master wishbone acknowledgement
                                       //
   .wbi_dat_i(vm_ivec),                // interrupt vector input
   .wbi_stb_o(vm_istb),                // interrupt vector strobe
   .wbi_ack_i(vm_iack)                 // interrupt vector acknowledgement
);

//______________________________________________________________________________
//
wbc_mem mem(
   .wb_clk_i(wb_clk),
   .wb_adr_i(wb_adr),
   .wb_dat_i(wb_out),
   .wb_dat_o(mx_dat[1]),
   .wb_cyc_i(wb_cyc),
   .wb_we_i(wb_we),
   .wb_sel_i(wb_sel),
   .wb_stb_i(mx_stb[1]),
   .wb_ack_o(mx_ack[1])
);

//______________________________________________________________________________
//
`ifdef CONFIG_SYS_CLOCK
defparam uart.REFCLK = `CONFIG_SYS_CLOCK;
`endif

wbc_uart uart
(
   .wb_clk_i(wb_clk),
   .wb_rst_i(sys_init),
   .wb_adr_i(wb_adr[2:0]),
   .wb_dat_i(wb_out),
   .wb_dat_o(mx_dat[2]),
   .wb_cyc_i(wb_cyc),
   .wb_we_i(wb_we),
   .wb_stb_i(mx_stb[2]),
   .wb_ack_o(mx_ack[2]),

   .tx_dat_o(de2_uart_txd),
   .tx_cts_i(de2_uart_rts),
   .rx_dat_i(de2_uart_rxd),
   .rx_dtr_o(de2_uart_cts),

   .tx_irq_o(tx_irq),
   .tx_ack_i(tx_ack),
   .rx_irq_o(rx_irq),
   .rx_ack_i(rx_ack),

   .cfg_bdiv(baud[15:0]),
   .cfg_nbit(2'b11),
   .cfg_nstp(1'b1),
   .cfg_pena(1'b0),
   .cfg_podd(1'b0)
);

wbc_vic #(.N(2)) vic
(
   .wb_clk_i(wb_clk),
   .wb_rst_i(vm_dclo_in),
   .wb_irq_o(vm_virq),
   .wb_dat_o(vm_ivec),
   .wb_stb_i(vm_istb),
   .wb_ack_o(vm_iack),
   .wb_una_i(1'b0),
   .rsel(16'h0000),
   .ivec({16'o000064, 16'o000060}),
   .ireq({tx_irq, rx_irq}),
   .iack({tx_ack, rx_ack})
);

//______________________________________________________________________________
//
assign mx_stb[0]  = wb_stb & wb_cyc & (wb_adr[15:4] == (16'o177700 >> 4));
assign mx_stb[1]  = wb_stb & wb_cyc & (wb_adr[15:14] == 2'o0);
assign mx_stb[2]  = wb_stb & wb_cyc & (wb_adr[15:3] == (16'o177560 >> 3));

assign wb_ack     = mx_ack[0] | mx_ack[1] | mx_ack[2];
assign wb_mux     = (mx_stb[0] ? mx_dat[0] : 16'o000000)
                  | (mx_stb[1] ? mx_dat[1] : 16'o000000)
                  | (mx_stb[2] ? mx_dat[2] : 16'o000000);
//______________________________________________________________________________
//
// Simulation stop flag and console (no DE2-115 simulation project)
// Be careful - on real DE2-115 board LCD requires power enabled
//
// assign lcd_rs    = wb_stb & wb_cyc & (wb_adr[15:0] == 16'o000172);
// assign lcd_data  = wb_out[7:0];
// assign lcd_en    = (wb_adr[15:0] == 16'o177566) & wb_stb & wb_we & wb_ack;
//
//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign de2_hex0      = ~vm_reg0[6:0];
assign de2_hex1      = ~vm_reg0[14:8];
assign de2_hex2      = ~vm_reg1[6:0];
assign de2_hex3      = ~vm_reg1[14:8];

always @(posedge wb_clk)
begin
   if (sys_init)
   begin
      vm_reg0 <= 16'o000000;
      vm_reg1 <= 16'o000000;
   end
   else
   begin
      if (mx_stb[0] & wb_we & ~wb_adr[0]) vm_reg0 <= wb_out;
      if (mx_stb[0] & wb_we &  wb_adr[0]) vm_reg1 <= wb_out;
   end
end

assign vm_in14[3:0]     = de2_button;
assign vm_in14[15:4]    = de2_sw[11:0];
assign mx_dat[0]        = vm_in14;
assign mx_ack[0]        = mx_stb[0];

assign   de2_ledg[8:5]  = 4'hz;
assign   de2_ledg[0]    = de2_sw[0];
assign   de2_ledg[1]    = vm_dclo_in;
assign   de2_ledg[2]    = vm_aclo_in;
assign   de2_ledg[3]    = sys_rst;
assign   de2_ledg[4]    = pwr_rst;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
// assign   de2_uart_txd   = 1'bz;
// assign   de2_uart_cts   = 1'bz;

assign   de2_dram_dq    = 32'hzzzzzzzz;
assign   de2_dram_addr  = 13'h0000;
assign   de2_dram_dqm   = 4'b0;
assign   de2_dram_we_n  = 1'b1;
assign   de2_dram_cas_n = 1'b1;
assign   de2_dram_ras_n = 1'b1;
assign   de2_dram_cs_n  = 1'b1;
assign   de2_dram_ba[0] = 1'b0;
assign   de2_dram_ba[1] = 1'b0;
assign   de2_dram_clk   = 1'b0;
assign   de2_dram_cke   = 1'b0;

assign   de2_sram_dq    = 16'hzzzz;
assign   de2_sram_addr  = 20'h00000;
assign   de2_sram_ub_n  = 1'b1;
assign   de2_sram_lb_n  = 1'b1;
assign   de2_sram_we_n  = 1'b1;
assign   de2_sram_ce_n  = 1'b1;
assign   de2_sram_oe_n  = 1'b1;

assign   de2_fl_dq      = 8'hzz;
assign   de2_fl_addr    = 23'h000000;
assign   de2_fl_we_n    = 1'b1;
assign   de2_fl_rst_n   = 1'b0;
assign   de2_fl_oe_n    = 1'b1;
assign   de2_fl_ce_n    = 1'b1;
assign   de2_fl_wp_n    = 1'b0;

assign   de2_lcd_data   = 8'hzz;
assign   de2_lcd_blig   = 1'b0;
assign   de2_lcd_on     = 1'b0;
assign   de2_lcd_rw     = 1'b0;
assign   de2_lcd_en     = 1'b0;
assign   de2_lcd_rs     = 1'b0;

assign   de2_sd_dat     = 4'hz;
assign   de2_sd_cmd     = 1'hz;
assign   de2_sd_clk     = 1'h0;

assign   de2_ps2_kbdat  = 1'hz;
assign   de2_ps2_kbclk  = 1'hz;
assign   de2_ps2_msdat  = 1'hz;
assign   de2_ps2_msclk  = 1'hz;

assign   de2_vga_blank_n = 1'b0;
assign   de2_vga_hs     = 1'b00;
assign   de2_vga_vs     = 1'b00;
assign   de2_vga_r      = 8'h00;
assign   de2_vga_g      = 8'h00;
assign   de2_vga_b      = 8'h00;
assign   de2_vga_clk    = 1'b00;
assign   de2_vga_sync_n = 1'b00;
assign   de2_td_rst_n   = 1'b0;

assign   de2_gpio       = 36'hzzzzzzzzz;
assign   de2_exio       = 7'hzz;
assign   de2_ledr       = 18'hzzzzz;

assign   de2_enet0_gtx_clk = 1'b0;
assign   de2_enet0_mdc     = 1'b0;
assign   de2_enet0_mdio    = 1'bz;
assign   de2_enet0_rst_n   = 1'b0;
assign   de2_enet0_tx_dat  = 4'h0;
assign   de2_enet0_tx_en   = 1'b0;
assign   de2_enet0_tx_er   = 1'b0;

assign   de2_enet1_gtx_clk = 1'b0;
assign   de2_enet1_mdc     = 1'b0;
assign   de2_enet1_mdio    = 1'bz;
assign   de2_enet1_rst_n   = 1'b0;
assign   de2_enet1_tx_dat  = 4'h0;
assign   de2_enet1_tx_en   = 1'b0;
assign   de2_enet1_tx_er   = 1'b0;

assign   de2_i2c_dat       = 1'bz;
assign   de2_i2c_clk       = 1'bz;
assign   de2_eeprom_dat    = 1'bz;
assign   de2_eeprom_clk    = 1'bz;

assign   de2_otg_dat       = 16'hzzzz;
assign   de2_otg_addr      = 2'b00;
assign   de2_otg_cs_n      = 1'b1;
assign   de2_otg_wr_n      = 1'b1;
assign   de2_otg_rd_n      = 1'b1;
assign   de2_otg_rst_n     = 1'b1;
assign   de2_otg_dack_n    = 2'b11;
assign   de2_otg_fspeed    = 1'bz;
assign   de2_otg_lspeed    = 1'bz;

assign   de2_aud_adclrck   = 1'bz;
assign   de2_aud_daclrck   = 1'bz;
assign   de2_aud_dacdat    = 1'bz;
assign   de2_aud_bclk      = 1'b0;
assign   de2_aud_xck       = 1'b0;

assign   de2_hsmc_clkout_p1   = 1'b0;
assign   de2_hsmc_clkout_p2   = 1'b0;
assign   de2_hsmc_clkout0     = 1'b0;
assign   de2_hsmc_d           = 4'hz;
assign   de2_hsmc_txd_p       = 16'h0000;
assign   de2_sma_clkout       = 1'b0;

assign   de2_hex4          = 7'hzz;
assign   de2_hex5          = 7'hzz;
assign   de2_hex6          = 7'hzz;
assign   de2_hex7          = 7'hzz;

//______________________________________________________________________________
//
endmodule
