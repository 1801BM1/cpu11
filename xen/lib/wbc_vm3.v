//
// Copyright (c) 2014-2024 by 1801BM1@gmail.com
//
// 1801BM3 base Wishbone SoC, universal wrapper for all boards
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/config.v"
// synopsys translate_on
//______________________________________________________________________________
//
// The 1801BM3 CPU wrapper
//
module wbc_vm3
(
   input          osc_clk,             // external oscillator clock
   input          sys_clk_p,           // system clock positive phase
   input          sys_clk_n,           // system clock negative phase
   input          sys_plock,           // PLL is locked
   output         sys_us,              //
   output         sys_ms,              //
   output         sys_rst,             // system reset
   output         pwr_rst,             // power reset
                                       //
   input          ext_reset,           // external reset button
   input          ext_ready,           // external system ready
   input   [15:0] ext_una,             // config word/start address
   input          ext_halt,            // external halt request
   input          ena_timer,           // enable system timer
   input          ena_slow,            // enable slow clock
                                       //
   input          uart_rxd,            // serial data input
   output         uart_txd,            // serial data output
   input          uart_cts,            // enable local transmitter
   output         uart_rts,            // enable remote transmitter
                                       //
   output         tty_end,             // debug stop
   output         tty_stb,             // debug data strobe
   output   [7:0] tty_dat,             // debug data value
                                       //
   output   [7:0] seg_hex0,            // seven segment digit 0
   output   [7:0] seg_hex1,            // seven segment digit 1
   output   [7:0] seg_hex2,            // seven segment digit 2
   output   [7:0] seg_hex3,            // seven segment digit 3
   output   [7:0] leds                 // output LEDs
);

//______________________________________________________________________________
//
wire        sys_init;                  // peripheral reset
wire        ena_us, ena_ms;            //
wire        clk_slow, i50Hz;           //
wire [1:0]  bsel;                      //
                                       //
wire        wb_clk;                    //
wire        wb_ios;                    // master I/O bank select
wire [22:0] wb_adr;                    // master address out bus
wire [15:0] wb_out;                    // master data out bus
wire [15:0] wb_mux;                    // master data in bus
wire        wb_cyc;                    // master wishbone cycle
wire        wb_we;                     // master wishbone direction
wire [1:0]  wb_sel;                    // master wishbone byte selection
wire        wb_stb;                    // master wishbone strobe
wire        wb_ack;                    // master wishbone acknowledgement
                                       //
wire        vm_istb;                   //
wire        vm_iack;                   //
wire [15:0] vm_ivec;                   //
wire [3:0]  mx_stb;                    //
wire [3:0]  mx_ack;                    // system wishbone data mux
wire [15:0] mx_dat[2:0];               //
                                       //
reg  [15:0] vm_reg0, vm_reg1;          //
                                       //
wire        vm_init_out;               //
wire        vm_dclo_in;                //
wire        vm_aclo_in;                //
wire [7:4]  vm_virq;                   //
wire        vm_halt;                   //
wire        vm_evnt;                   //
wire        vm_umap;                   //
wire        vm_hltm;                   //
                                       //
wire [31:0] baud;                      //
wire        tx_irq, tx_ack;            //
wire        rx_irq, rx_ack;            //
                                       //
reg         halt_rq;                   // debug register @177710
reg         evnt_rq;                   // for HALT testing
reg         halt_en;                   //
//______________________________________________________________________________
//
assign   wb_clk = sys_clk_p;
assign   sys_init = vm_init_out;
assign   bsel  = `CONFIG_LSI_BOOT_MODE;
assign   baud = 921600/`CONFIG_BAUD_RATE-1;

assign   vm_halt = ext_halt | halt_rq;
assign   vm_evnt = i50Hz & ena_timer | evnt_rq;

assign   sys_us = ena_us;
assign   sys_ms = ena_ms;

defparam reset.OSCCLK      = `CONFIG_OSC_CLOCK;
defparam reset.REFCLK      = `CONFIG_SYS_CLOCK;
defparam reset.PWR_WIDTH   = `CONFIG_RESET_PULSE_WIDTH_CLK;
defparam reset.DEBOUNCE    = `CONFIG_RESET_BUTTON_DEBOUNCE_MS;
defparam reset.DCLO_WIDTH  = `CONFIG_DCLO_WIDTH_CLK;
defparam reset.ACLO_DELAY  = `CONFIG_ACLO_DELAY_CLK;
defparam reset.SYSTICK     = `CONFIG_TIMER_TICK;
defparam reset.SLOW_DIV    = `CONFIG_SLOW_DIV;

wbc_rst reset
(
   .osc_clk(osc_clk),
   .sys_clk(wb_clk),
   .pll_lock(sys_plock),
   .button(ext_reset),
   .sys_ready(ext_ready),

   .pwr_rst(pwr_rst),
   .sys_rst(sys_rst),
   .sys_dclo(vm_dclo_in),
   .sys_aclo(vm_aclo_in),
   .sys_us(ena_us),
   .sys_ms(ena_ms),
   .sys_slow(clk_slow),
   .sys_irq(i50Hz)
);

//______________________________________________________________________________
//
// CPU instantiation
//
`ifdef CONFIG_VM3_CORE_FIX_SR3_RESERVED
defparam cpu.VM3_CORE_FIX_SR3_RESERVED = `CONFIG_VM3_CORE_FIX_SR3_RESERVED;
`endif

`ifdef CONFIG_VM3_CORE_FIX_PREFETCH_TIMEOUT
defparam cpu.VM3_CORE_FIX_PREFETCH_TIMEOUT = `CONFIG_VM3_CORE_FIX_PREFETCH_TIMEOUT;
`endif

vm3_wb cpu
(
   .vm_clk_p(sys_clk_p),               // positive processor clock
   .vm_clk_n(sys_clk_n),               // negative processor clock
   .vm_clk_slow(ena_slow),             // slow clock sim mode
   .vm_clk_ena(clk_slow),              // slow clock strobe
                                       //
   .vm_init(vm_init_out),              // peripheral reset
   .vm_dclo(vm_dclo_in),               // processor reset
   .vm_aclo(vm_aclo_in),               // power fail notificaton
   .vm_halt(vm_halt),                  // halt mode interrupt requests
   .vm_evnt(vm_evnt),                  // timer interrupt requests
   .vm_virq(vm_virq),                  // vectored interrupt requests
   .vm_umap(vm_umap),                  // enable UNIBUS mapping
   .vm_hltm(vm_hltm),                  // HALT mode indicator
   .vm_bsel(~bsel[1]),                 //
                                       //
   .wbm_gnt_i(1'b1),                   // master wishbone granted
   .wbm_ios_o(wb_ios),                 // master I/O bank select
   .wbm_adr_o(wb_adr),                 // master wishbone address
   .wbm_dat_o(wb_out),                 // master wishbone data output
   .wbm_dat_i(wb_mux),                 // master wishbone data input
   .wbm_cyc_o(wb_cyc),                 // master wishbone cycle
   .wbm_we_o(wb_we),                   // master wishbone direction
   .wbm_sel_o(wb_sel),                 // master wishbone byte selection
   .wbm_stb_o(wb_stb),                 // master wishbone strobe
   .wbm_ack_i(wb_ack),                 // master wishbone acknowledgement
                                       //
   .wbi_dat_i(vm_ivec),                // interrupt vector input
   .wbi_stb_o(vm_istb),                // interrupt vector strobe
   .wbi_ack_i(vm_iack)                 // interrupt vector acknowledgement
);

//______________________________________________________________________________
//
wbc_mem_32k mem(
   .wb_clk_i(wb_clk),
   .wb_adr_i(wb_adr[15:0]),
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
defparam uart.REFCLK = `CONFIG_SYS_CLOCK;

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
   .tx_cts_i(uart_cts),
   .rx_dat_i(uart_rxd),
   .rx_dtr_o(uart_rts),

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
   .rsel(ext_una),
   .ivec({16'o070064, 16'o070060}),
   .ireq({tx_irq, rx_irq}),
   .iack({tx_ack, rx_ack})
);

//______________________________________________________________________________
//
assign mx_stb[0]  = wb_stb & wb_cyc &  wb_ios & (wb_adr[12:2] == (13'o17714 >> 2));
assign mx_stb[1]  = wb_stb & wb_cyc & ~wb_ios & (wb_adr[15] == 1'o0);
assign mx_stb[2]  = wb_stb & wb_cyc &  wb_ios & (wb_adr[12:3] == (13'o17560 >> 3));
assign mx_stb[3]  = wb_stb & wb_cyc &  wb_ios & (wb_adr[12:2] == (13'o17710 >> 2));

assign wb_ack     = mx_ack[0] | mx_ack[1] | mx_ack[2] | mx_ack[3];
assign wb_mux     = (mx_stb[0] ? mx_dat[0] : 16'o000000)
                  | (mx_stb[1] ? mx_dat[1] : 16'o000000)
                  | (mx_stb[2] ? mx_dat[2] : 16'o000000);

//______________________________________________________________________________
//
// Debug register to test HALT mode
//
assign mx_ack[3] = wb_we & mx_stb[3];

always @(posedge wb_clk or posedge vm_dclo_in)
begin
   if (vm_dclo_in)
   begin
      halt_rq <= 1'b0;
      evnt_rq <= 1'b0;
      halt_en <= 1'b0;
   end
   else
      if (mx_ack[3])
      begin
         halt_rq <= wb_out[0];
         evnt_rq <= wb_out[1];
         halt_en <= wb_out[15];
      end
end

//______________________________________________________________________________
//
// Simulation stop flag and console
//
assign tty_end    = tty_stb & (tty_dat == 8'o100);
assign tty_dat    = wb_out[7:0];
assign tty_stb    = (wb_adr[12:0] == 13'o17566) & wb_ios & wb_stb & wb_we & wb_ack;

//______________________________________________________________________________
//
// 7-segment display registers and switches
//
assign seg_hex0   = vm_reg0[7:0];
assign seg_hex1   = vm_reg0[15:8];
assign seg_hex2   = vm_reg1[7:0];
assign seg_hex3   = vm_reg1[15:8];

always @(posedge wb_clk)
begin
   if (sys_init)
   begin
      vm_reg0 <= 16'o000000;
      vm_reg1 <= 16'o000000;
   end
   else
   begin
      if (mx_stb[0] & ~wb_adr[1] & wb_we) vm_reg0 <= wb_out;
      if (mx_stb[0] &  wb_adr[1] & wb_we) vm_reg1 <= wb_out;
   end
end

assign mx_dat[0]        = 16'o000000;
assign mx_ack[0]        = mx_stb[0];

assign leds[0]    = ena_timer;
assign leds[1]    = ena_slow;
assign leds[2]    = ext_halt;
assign leds[3]    = halt_en;
assign leds[4]    = vm_dclo_in;
assign leds[5]    = sys_rst;
assign leds[6]    = pwr_rst;
assign leds[7]    = vm_virq[7];

//______________________________________________________________________________
//
endmodule

