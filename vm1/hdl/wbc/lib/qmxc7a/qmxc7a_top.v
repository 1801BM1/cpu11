//______________________________________________________________________________
//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
// Copyright (c) 2019 by yshestakov@gmail.com
//
// Top module for QMTech XC7A35T SDRAM board
//
`include "config.v"

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

xram_16k ram(
   .addra(wb_adr_i[13:1]),
   .clka(wb_clk_i),
   .dina(wb_dat_i),
   .wea( wb_we_i & wb_cyc_i & wb_stb_i),
//   .byteena(ena),
   .ena(ena),
   .douta(wb_dat_o));

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
// Top project module - instantiates the QM_XC7A35T_SDRAM board itself
//
module qmxc7a
(
   input          sys_clock_50,        // clock input 50 MHz (N11)
                                       //
   input          sys_reset_n,         // push reset button (A8 == sw2)
   output   [0:0] sys_led,             // led outputs [0:0] (C8)

   output         sys_uart_txd,        // UART transmitter (C4)
   input          sys_uart_rxd         // UART receiver (D4)
);

//______________________________________________________________________________
//
// Top module for QM_XC6XSL16_DDR3 board based system
//
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
reg  [2:0]  hsel;                      //
reg         tena;                      //
//______________________________________________________________________________
//
assign      sys_init = vm_init_out;
assign      baud = 921600/115200-1;

assign      vm_irq[1] = 1'b0;
assign      vm_irq[2] = i50Hz & tena;
assign      vm_irq[3] = 1'b0;

//______________________________________________________________________________
//
// System Reset and Clock controller
//
assign clk50   = sys_clock_50;
//
// assign sys_clk_p = clk50;
// assign sys_clk_n = ~clk50;
// assign sys_plock = 1'b1;
//
sys_pll corepll
(
   .inclk0(clk50),
   .c0(sys_clk_p),
   .c1(sys_clk_n),
   .locked(sys_plock)
);

assign wb_clk     = sys_clk_p;
defparam reset.OSCCLK      = `CONFIG_OSC_CLOCK;
defparam reset.REFCLK      = `CONFIG_SYS_CLOCK;
defparam reset.PWR_WIDTH   = `CONFIG_RESET_PULSE_WIDTH_CLK;
defparam reset.DEBOUNCE    = `CONFIG_RESET_BUTTON_DEBOUNCE_MS;
defparam reset.DCLO_WIDTH  = `CONFIG_DCLO_WIDTH_CLK;
defparam reset.ACLO_DELAY  = `CONFIG_ACLO_DELAY_CLK;
defparam reset.SYSTICK     = 20000;

wbc_rst reset
(
   .osc_clk(sys_clk_p),
   .sys_clk(wb_clk),
   .pll_lock(sys_plock),
   .button(sys_reset_n),
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

   .tx_dat_o(sys_uart_txd),
   .tx_cts_i(1'b0),
   .rx_dat_i(sys_uart_rxd),
// .rx_dtr_o(uart_cts),

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
// 7-segment display registers and switches
//
// QMTech Spartan-6 core board has no 7seg display

always @(posedge wb_clk)
begin
   if (sys_init)
      hsel <= 3'b000;
   else
      if (ena_ms)
         if (hsel == 3'b000)
            hsel <= 3'b101;
         else
            hsel <= hsel - 3'b001;
end

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

assign vm_in14[15:0]    = 16'h000000;

/*
always @(posedge wb_clk)
begin
   if (sys_button)
      tena <= 1'b1;
end
*/

assign sys_led[1] = tena;
assign sys_led[0] = pwr_rst;

//______________________________________________________________________________
//
// Temporary and debug assignments
//
endmodule
