//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Top module for DE0 board based system
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/de0/config.v"
// synopsys translate_on
//
`define  DE0_DCLO_WIDTH_CLK         15
`define  DE0_ACLO_DELAY_CLK         7

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

de0_ram16k ram(
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
// Top project module - instantiates the DE0 board itself
//
module de0
(
   input          de0_clock_50,        // clock input 50 MHz
   input          de0_clock_50_2,      // clock input 50 MHz
                                       //
   input    [2:0] de0_button,          // push button[2:0]
                                       //
   input    [9:0] de0_sw,              // DPDT toggle switch[9:0]
   output   [7:0] de0_hex0,            // seven segment digit 0
   output   [7:0] de0_hex1,            // seven segment digit 1
   output   [7:0] de0_hex2,            // seven segment digit 2
   output   [7:0] de0_hex3,            // seven segment digit 3
   output   [9:0] de0_led,             // LED green[9:0]
                                       //
   output         de0_uart_txd,        // UART transmitter
   input          de0_uart_rxd,        // UART receiver
   output         de0_uart_cts,        // UART clear to send (inverted)
   input          de0_uart_rts,        // UART request to send  (inverted)
                                       //
   inout   [15:0] de0_dram_dq,         // SDRAM data bus 16 bits
   output  [12:0] de0_dram_addr,       // SDRAM address bus 13 bits
   output         de0_dram_ldqm,       // SDRAM low-byte data mask
   output         de0_dram_udqm,       // SDRAM high-byte data mask
   output         de0_dram_we_n,       // SDRAM write enable
   output         de0_dram_cas_n,      // SDRAM column address strobe
   output         de0_dram_ras_n,      // SDRAM row address strobe
   output         de0_dram_cs_n,       // SDRAM chip select
   output   [1:0] de0_dram_ba,         // SDRAM bank address
   output         de0_dram_clk,        // SDRAM clock
   output         de0_dram_cke,        // SDRAM clock enable
                                       //
   inout   [15:0] de0_fl_dq,           // FLASH data bus 15 Bits
   output  [21:0] de0_fl_addr,         // FLASH address bus 22 Bits
   output         de0_fl_we_n,         // FLASH write enable
   output         de0_fl_rst_n,        // FLASH reset
   output         de0_fl_oe_n,         // FLASH output enable
   output         de0_fl_ce_n,         // FLASH chip enable
   output         de0_fl_wp_n,         // FLASH hardware write protect
   output         de0_fl_byte_n,       // FLASH selects 8/16-bit mode
   input          de0_fl_rb,           // FLASH ready/busy
                                       //
   output         de0_lcd_blig,        // LCD back light ON/OFF
   output         de0_lcd_rw,          // LCD read/write select, 0 = write, 1 = read
   output         de0_lcd_en,          // LCD enable
   output         de0_lcd_rs,          // LCD command/data select, 0 = command, 1 = data
   inout    [7:0] de0_lcd_data,        // LCD data bus 8 bits
                                       //
   inout          de0_sd_dat0,         // SD Card Data 0
   inout          de0_sd_dat3,         // SD Card Data 3
   inout          de0_sd_cmd,          // SD Card Command Signal
   output         de0_sd_clk,          // SD Card Clock
   input          de0_sd_wp_n,         // SD Card Write Protect
                                       //
   inout          de0_ps2_kbdat,       // PS2 Keyboard Data
   inout          de0_ps2_kbclk,       // PS2 Keyboard Clock
   inout          de0_ps2_msdat,       // PS2 Mouse Data
   inout          de0_ps2_msclk,       // PS2 Mouse Clock
                                       //
   output         de0_vga_hs,          // VGA H_SYNC
   output         de0_vga_vs,          // VGA V_SYNC
   output   [3:0] de0_vga_r,           // VGA Red[3:0]
   output   [3:0] de0_vga_g,           // VGA Green[3:0]
   output   [3:0] de0_vga_b,           // VGA Blue[3:0]
                                       //
   input    [1:0] de0_gpio0_clkin,     // GPIO Connection 0 Clock In Bus
   output   [1:0] de0_gpio0_clkout,    // GPIO Connection 0 Clock Out Bus
   inout   [31:0] de0_gpio0_d,         // GPIO Connection 0 Data Bus
                                       //
   input    [1:0] de0_gpio1_clkin,     // GPIO Connection 1 Clock In Bus
   output   [1:0] de0_gpio1_clkout,    // GPIO Connection 1 Clock Out Bus
   inout   [31:0] de0_gpio1_d          // GPIO Connection 1 Data Bus
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
wire [2:1]  vm_sel;                    //
wire [15:0] vm_in14;                   //
reg  [15:0] vm_reg0, vm_reg1;          //
                                       //
wire        vm_init_out;               //
wire        vm_dclo_in;                //
wire        vm_aclo_in;                //
wire        vm_virq;                   //
wire [3:1]  vm_irq;                    //
                                       //
wire        tx_irq, tx_ack;            //
wire        rx_irq, rx_ack;            //
wire [31:0] baud;                      //
                                       //
wire        uart_rxd, uart_txd;        //
wire        uart_rts, uart_cts;        //
//______________________________________________________________________________
//
assign      sys_init = vm_init_out;
assign      baud = 921600/115200-1;

assign      vm_irq[1] = 1'b0;
assign      vm_irq[2] = i50Hz & de0_sw[0];
assign      vm_irq[3] = 1'b0;

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign wb_clk  = sys_clk_p;
assign clk50   = de0_clock_50_2;

de0_pll100 corepll
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
defparam reset.DCLO_WIDTH  = `DE0_DCLO_WIDTH_CLK;
defparam reset.ACLO_DELAY  = `DE0_ACLO_DELAY_CLK;
defparam reset.SYSTICK     = 20000;

wbc_rst reset
(
   .osc_clk(clk50),
   .sys_clk(wb_clk),
   .pll_lock(sys_plock),
   .button(de0_button[0]),
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
`ifdef CONFIG_VM1_CORE_REG_USES_RAM
defparam cpu.VM1_CORE_REG_USES_RAM = `CONFIG_VM1_CORE_REG_USES_RAM;
`endif

`ifdef CONFIG_VM1_CORE_MULG_VERSION
defparam cpu.VM1_CORE_MULG_VERSION = `CONFIG_VM1_CORE_MULG_VERSION;
`endif

vm1_wb cpu
(
   .vm_clk_p(sys_clk_p),               // positive processor clock
   .vm_clk_n(sys_clk_n),               // negative processor clock
   .vm_clk_slow(1'b0),                 // slow clock sim mode
   .vm_clk_ena(1'b1),                  // slow clock strobe
   .vm_clk_tve(1'b1),                  // VE-timer clock enable
   .vm_clk_sp(1'b0),                   // external pin SP clock
                                       //
   .vm_pa(2'b00),                      // processor number
   .vm_init_in(1'b0),                  // peripheral reset
   .vm_init_out(vm_init_out),          // peripheral reset
   .vm_dclo(vm_dclo_in),               // processor reset
   .vm_aclo(vm_aclo_in),               // power fail notoficaton
   .vm_irq(vm_irq),                    // radial interrupt requests
   .vm_virq(vm_virq),                  // vectored interrupt request
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
   .wbi_ack_i(vm_iack),                // interrupt vector acknowledgement
                                       //
   .wbs_adr_i(wb_adr[3:0]),            // slave wishbone address
   .wbs_dat_i(wb_out),                 // slave wishbone data input
   .wbs_cyc_i(wb_cyc),                 // slave wishbone cycle
   .wbs_we_i(wb_we),                   // slave wishbone direction
   .wbs_stb_i(mx_stb[0]),              // slave wishbone strobe
   .wbs_ack_o(mx_ack[0]),              // slave wishbone acknowledgement
   .wbs_dat_o(mx_dat[0]),              // slave wishbone data output
                                       //
   .vm_reg14(vm_in14),                 // register 177714 data input
   .vm_reg16(16'o000000),              // register 177716 data input
   .vm_sel(vm_sel)                     // register select outputs
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
//
// RS-232/3.3V-CMOS UART multiplexer
// sw[9] selects the receiving line
//
assign de0_uart_txd = uart_txd;
assign de0_uart_cts = uart_cts;
assign de0_gpio1_d[5] = uart_txd;
assign uart_rxd = de0_gpio1_d[7] & de0_sw[9]
                | de0_uart_rxd & ~de0_sw[9];
assign uart_rts = 1'b0;

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

   .tx_dat_o(uart_txd),
   .tx_cts_i(uart_rts),
   .rx_dat_i(uart_rxd),
   .rx_dtr_o(uart_cts),

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
//
// Simulation stop flag and console
//
assign de0_lcd_rs    = wb_stb & wb_cyc & ((wb_adr == 16'o177676) | (wb_adr == 16'o177674));
assign de0_lcd_data  = wb_out[7:0];
assign de0_lcd_en    = (wb_adr == 16'o177566) & wb_stb & wb_we & wb_ack;

//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign de0_hex0      = ~vm_reg0[7:0];
assign de0_hex1      = ~vm_reg0[15:8];
assign de0_hex2      = ~vm_reg1[7:0];
assign de0_hex3      = ~vm_reg1[15:8];

always @(posedge wb_clk)
begin
   if (sys_init)
   begin
      vm_reg0 <= 16'o000000;
      vm_reg1 <= 16'o000000;
   end
   else
   begin
      if (vm_sel[2] & wb_we & ~wb_adr[0]) vm_reg0 <= wb_out;
      if (vm_sel[2] & wb_we &  wb_adr[0]) vm_reg1 <= wb_out;
   end
end

assign vm_in14[2:0]     = de0_button;
assign vm_in14[12:3]    = de0_sw;
assign vm_in14[15:13]   = de0_button;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
assign   de0_dram_dq    = 16'hzzzz;
assign   de0_dram_addr  = 13'h0000;
assign   de0_dram_ldqm  = 1'b0;
assign   de0_dram_udqm  = 1'b0;
assign   de0_dram_we_n  = 1'b1;
assign   de0_dram_cas_n = 1'b1;
assign   de0_dram_ras_n = 1'b1;
assign   de0_dram_cs_n  = 1'b1;
assign   de0_dram_ba[0] = 1'b0;
assign   de0_dram_ba[1] = 1'b0;
assign   de0_dram_clk   = wb_clk;
assign   de0_dram_cke   = 1'b1;

assign   de0_fl_dq      = 16'hzzzz;
assign   de0_fl_addr    = 22'hzzzzzz;
assign   de0_fl_we_n    = 1'b1;
assign   de0_fl_rst_n   = 1'b0;
assign   de0_fl_oe_n    = 1'b1;
assign   de0_fl_ce_n    = 1'b1;
assign   de0_fl_wp_n    = 1'b0;
assign   de0_fl_byte_n  = 1'b1;

// assign   de0_lcd_data   = 8'hzz;
assign   de0_lcd_blig   = 1'b0;
assign   de0_lcd_rw     = 1'b0;
// assign   de0_lcd_en     = 1'b0;
// assign   de0_lcd_rs     = 1'b0;

assign   de0_sd_clk     = 1'b0;
assign   de0_sd_dat0    = 1'hz;
assign   de0_sd_dat3    = 1'hz;
assign   de0_sd_cmd     = 1'hz;

assign   de0_ps2_kbdat  = 1'hz;
assign   de0_ps2_kbclk  = 1'hz;
assign   de0_ps2_msdat  = 1'hz;
assign   de0_ps2_msclk  = 1'hz;

assign   de0_vga_hs     = 1'b0;
assign   de0_vga_vs     = 1'b0;
assign   de0_vga_r      = 4'h0;
assign   de0_vga_g      = 4'h0;
assign   de0_vga_b      = 4'h0;

// assign de0_hex0      = 8'hzz;
// assign de0_hex1      = 8'hzz;
// assign de0_hex2      = 8'hzz;
// assign de0_hex3      = 8'hzz;
assign de0_led[8:5]     = 4'hz;
assign de0_led[0]       = de0_sw[0];
assign de0_led[1]       = vm_dclo_in;
assign de0_led[2]       = vm_aclo_in;
assign de0_led[3]       = sys_rst;
assign de0_led[4]       = pwr_rst;
assign de0_led[9]       = de0_sw[9];

assign   de0_gpio0_clkout  = 2'b00;
assign   de0_gpio1_clkout  = 2'b00;
assign   de0_gpio0_d       = 32'hzzzzzzzz;
//assign   de0_gpio1_d[]   = 32'hzzzzzzzz;
assign   de0_gpio1_d[31:8] = 24'hzzzzzz;
assign   de0_gpio1_d[4:0]  = 5'hzz;
assign   de0_gpio1_d[6]    = 1'hz;

//______________________________________________________________________________
//
endmodule
