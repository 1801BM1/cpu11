//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module vm2
(
   input          pin_clk_p,     // processor clock, rising edge f1
   input          pin_clk_n,     // processor clock, falling edge f1
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input          pin_virq_n,    // vectored interrupt request
                                 //
   input          pin_ar_n,      // address ready strobe
   input          pin_dmr_n,     // bus request line
   input          pin_sack_n,    // bus acknowlegement
   input          pin_rply_n,    // transaction reply
                                 //
   input          pin_waki_n,    // window access granted
   output         pin_wrq_n,     // window access request (open drain)
   output         pin_init_n,    // peripheral reset (open drain)
   output         pin_clko,      // internal core clock output
   output         pin_dmgo_n,    // bus granted output
                                 //
   inout [15:0]   pin_ad_n,      // inverted address/data bus
   output         pin_sel_n,     // halt mode access
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n     // interrupt vector input
);

//______________________________________________________________________________
//
// External pin wires and controls
//
wire  pin_ad_ena;
wire  pin_init_ena;
wire  pin_ctrl_ena;
wire  [15:0] pin_ad_out;

wire  pin_clko_out;
wire  pin_dmgo_out;
wire  pin_sel_out;
wire  pin_sync_out;
wire  pin_wtbt_out;
wire  pin_dout_out;
wire  pin_din_out;
wire  pin_iako_out;
//
// Shared Qbus lines
//
assign pin_ad_n      = pin_ad_ena   ? ~pin_ad_out : 16'oZZZZZZ;
assign pin_dout_n    = pin_ctrl_ena ? ~pin_dout_out : 1'bZ;
assign pin_din_n     = pin_ctrl_ena ? ~pin_din_out  : 1'bZ;
assign pin_wtbt_n    = pin_ctrl_ena ? ~pin_wtbt_out : 1'bZ;
assign pin_sync_n    = pin_ctrl_ena ? ~pin_sync_out : 1'bZ;
//
// "Open drain" outputs
//
assign pin_init_n    = pin_init_ena ? 1'b0 : 1'bZ;
assign pin_wrq_n     = 1'bZ;
//
// Other outputs
//
assign pin_clko      = pin_clko_out;
assign pin_dmgo_n    = ~pin_dmgo_out;
assign pin_sel_n     = ~pin_sel_out;
assign pin_iako_n    = ~pin_iako_out;
//
// Core instantiation
//
vm2_qbus core
(
   .pin_clk_p     (pin_clk_p),
   .pin_clk_n     (pin_clk_n),

   .pin_init      (pin_init_ena),
   .pin_dclo      (~pin_dclo_n),
   .pin_aclo      (~pin_aclo_n),
   .pin_halt      (~pin_halt_n),
   .pin_evnt      (~pin_evnt_n),
   .pin_virq      (~pin_virq_n),

   .pin_ar        (~pin_ar_n),
   .pin_dmr       (~pin_dmr_n),
   .pin_sack      (~pin_sack_n),
   .pin_rply      (~pin_rply_n),

   .pin_clko      (pin_clko_out),
   .pin_dmgo      (pin_dmgo_out),
   .pin_sel       (pin_sel_out),
   .pin_iako      (pin_iako_out),

   .pin_ad_in     (~pin_ad_n),
   .pin_ad_out    (pin_ad_out),
   .pin_ad_ena    (pin_ad_ena),
   .pin_ctrl_ena  (pin_ctrl_ena),

   .pin_sync      (pin_sync_out),
   .pin_wtbt      (pin_wtbt_out),
   .pin_dout      (pin_dout_out),
   .pin_din       (pin_din_out)
);
endmodule
