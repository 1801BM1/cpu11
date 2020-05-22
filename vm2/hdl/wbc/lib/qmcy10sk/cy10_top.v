//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// Top module for QMTech Cyclone 10LP board based system, 1801BM2 cpu
//______________________________________________________________________________
//
// synopsys translate_off
`include "../../lib/qmcy10sk/config.v"
// synopsys translate_on
//
`define  CY10_DCLO_WIDTH_CLK         15
`define  CY10_ACLO_DELAY_CLK         7

//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16
//
module wbc_mem
(
   input          wb_clk_i,
   input  [16:0]  wb_adr_i,
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

cy10_ram16k ram(
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
// Top project module - instantiates QMTech Cyclone10 StarterKit board itself
//
module cy10_top
(
   input          c10sk_clk,             // clock input 50 MHz
   input          c10sk_rst_n,           // reset

   output         c10sk_uart_txd,        // UART transmitter
   input          c10sk_uart_rxd,        // UART receiver

   output   [7:0] c10sk_hex_seg,         // 7-seg segment lines
   output   [2:0] c10sk_hex_dig,         // 7-seg digit select

   output   [1:0] c10sk_led,             // led1=Y17, 0 -> turn ON
   input          c10sk_sw4,             // 1=P3
   input          c10sk_sw1,             // 0=P4
   // HDMI
   output         c10sk_hdmi_scl_a,
   output         c10sk_hdmi_sda_a,
   output         c10sk_hdmi_hpd_a,
   output         c10sk_hdmi_cec_a,
   output   [2:0] c10sk_hdmi_tmds,
   output         c10sk_hdmi_tmds_clk
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
wire [16:0] wb_adr;                    // master address out bus
wire [15:0] wb_out;                    // master data out bus
wire [15:0] wb_mux;                    // master data in bus
wire        wb_cyc;                    // master wishbone cycle
wire        wb_we;                     // master wishbone direction
wire [1:0]  wb_sel;                    // master wishbone byte election
wire        wb_stb;                    // master wishbone strobe
wire        wb_ack;                    // master wishbone acknowledgement
                                       //
wire        vm_una;                    //
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
wire			uart_rxd, uart_txd;			//
//______________________________________________________________________________
//
assign      sys_init = vm_init_out;
assign      baud = 921600/115200-1;

assign      vm_halt  = 1'b0;
assign      vm_evnt  = i50Hz;
//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign wb_clk  = sys_clk_p;
assign clk50   = c10sk_clk;

cy10_pll50 corepll
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
defparam reset.DCLO_WIDTH  = `CY10_DCLO_WIDTH_CLK;
defparam reset.ACLO_DELAY  = `CY10_ACLO_DELAY_CLK;
defparam reset.SYSTICK     = 20000;

wbc_rst reset
(
   .osc_clk(clk50),
   .sys_clk(wb_clk),
   .pll_lock(sys_plock),
   .button(c10sk_rst_n),
   .sys_ready(1'b1),

   .pwr_rst(pwr_rst),
   .sys_rst(sys_rst),
   .sys_dclo(vm_dclo_in),
   .sys_aclo(vm_aclo_in),
   .sys_us(ena_us),
   .sys_ms(ena_ms),
   .sys_irq(i50Hz)
);

///______________________________________________________________________________
//
// CPU instantiation
//
`ifdef CONFIG_VM2_CORE_FIX_PREFETCH
defparam cpu.VM2_CORE_FIX_PREFETCH = `CONFIG_VM2_CORE_FIX_PREFETCH;
`endif

vm2_wb cpu
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
   .wbi_una_o(vm_una)                  // unaddresse read request
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
assign c10sk_uart_txd = uart_txd;
assign uart_rxd = c10sk_uart_rxd;

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
   .tx_cts_i(1'b0),
   .rx_dat_i(uart_rxd),
//   .rx_dtr_o(uart_cts),

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
//______________________________________________________________________________
//
// 7-segment display registers and switches
//
//assign cy10_hex0      = ~vm_reg0[7:0];
//assign cy10_hex1      = ~vm_reg0[15:8];
//assign cy10_hex2      = ~vm_reg1[7:0];
//assign cy10_hex3      = ~vm_reg1[15:8];

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

assign vm_in14[15:0]   = 16'h00000;
assign mx_dat[0]        = vm_in14;
assign mx_ack[0]        = mx_stb[0];

//______________________________________________________________________________
//
// Temporary and debug assignments
assign  c10sk_led[0] = vm_dclo_in;
assign  c10sk_led[1] = vm_aclo_in;
// assign   c10sk_uart_txd   = 1'bz;
// assign   c10sk_uart_cts   = 1'bz;

assign   c10sk_hex_seg[7:0] = 8'hzz;
assign   c10sk_hex_dig[2:0] = 3'hz;

//______________________________________________________________________________
//
endmodule
