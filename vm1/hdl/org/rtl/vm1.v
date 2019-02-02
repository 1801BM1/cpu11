//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module vm1
(
   input          pin_clk,       // processor clock
   input [1:0]    pin_pa_n,      // processor number
   inout          pin_init_n,    // peripheral reset
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input [3:1]    pin_irq_n,     // radial interrupt requests
   input          pin_virq_n,    // vectored interrupt request
                                 //
   inout [15:0]   pin_ad_n,      // inverted address/data bus
   inout          pin_dout_n,    // data output strobe
   inout          pin_din_n,     // data input strobe
   output         pin_wtbt_n,    // write/byte status
   inout          pin_sync_n,    // address strobe
   inout          pin_rply_n,    // transaction reply
   inout          pin_dmr_n,     // bus request shared line
   inout          pin_sack_n,    // bus acknowlegement
   input          pin_dmgi_n,    // bus granted input
   output         pin_dmgo_n,    // bus granted output
   output         pin_iako_n,    // interrupt vector input
   input          pin_sp_n,      // peripheral timer input
   output [2:1]   pin_sel_n,     // register select outputs
   output         pin_bsy_n      // bus busy flag
);

//______________________________________________________________________________
//
// External pin wires and controls
//
wire  pin_ad_ena;
wire  [15:0] pin_ad_out;
wire  [2:1] pin_sel_out;
wire  pin_sync_out, pin_sync_ena;
wire  pin_dmgo_out, pin_iako_out, pin_din_out, pin_dout_out;
wire  pin_wtbt_out, pin_ctrl_ena, pin_init_out, pin_sack_out;
wire  pin_rply_out, pin_dmr_out, pin_bsy_out;
//
// Shared Qbus lines
//
assign pin_ad_n      = pin_ad_ena   ? ~pin_ad_out : 16'hZZZZ;
assign pin_dout_n    = pin_ctrl_ena ? ~pin_dout_out : 1'bZ;
assign pin_din_n     = pin_ctrl_ena ? ~pin_din_out  : 1'bZ;
assign pin_wtbt_n    = pin_ctrl_ena ? ~pin_wtbt_out : 1'bZ;
assign pin_iako_n    = pin_ctrl_ena ? ~pin_iako_out : 1'bZ;
assign pin_sync_n    = pin_sync_ena ? ~pin_sync_out : 1'bZ;
assign pin_dmgo_n    = ~pin_dmgo_out;
//
// "Open collector" outputs
//
assign pin_init_n    = pin_init_out ? 1'b0 : 1'bZ;
assign pin_sack_n    = pin_sack_out ? 1'b0 : 1'bZ;
assign pin_rply_n    = pin_rply_out ? 1'b0 : 1'bZ;
assign pin_dmr_n     = pin_dmr_out  ? 1'b0 : 1'bZ;
assign pin_bsy_n     = pin_bsy_out  ? 1'b0 : 1'bZ;
assign pin_sel_n[1]  = pin_sel_out[1] ? 1'b0 : 1'bZ;
assign pin_sel_n[2]  = pin_sel_out[2] ? 1'b0 : 1'bZ;

vm1_qbus core
(
   .pin_clk       (pin_clk),
   .pin_pa        (~pin_pa_n),
   .pin_init_in   (~pin_init_n),
   .pin_init_out  (pin_init_out),
   .pin_dclo      (~pin_dclo_n),
   .pin_aclo      (~pin_aclo_n),
   .pin_irq       (~pin_irq_n),
   .pin_virq      (~pin_virq_n),

   .pin_ad_in     (~pin_ad_n),
   .pin_ad_out    (pin_ad_out),
   .pin_ad_ena    (pin_ad_ena),

   .pin_dout_in   (~pin_dout_n),
   .pin_dout_out  (pin_dout_out),
   .pin_din_in    (~pin_din_n),
   .pin_din_out   (pin_din_out),
   .pin_wtbt      (pin_wtbt_out),
   .pin_ctrl_ena  (pin_ctrl_ena),

   .pin_sync_in   (~pin_sync_n),
   .pin_sync_out  (pin_sync_out),
   .pin_sync_ena  (pin_sync_ena),

   .pin_rply_in   (~pin_rply_n),
   .pin_rply_out  (pin_rply_out),
   .pin_dmr_in    (~pin_dmr_n),
   .pin_dmr_out   (pin_dmr_out),
   .pin_sack_in   (~pin_sack_n),
   .pin_sack_out  (pin_sack_out),

   .pin_dmgi      (~pin_dmgi_n),
   .pin_dmgo      (pin_dmgo_out),
   .pin_iako      (pin_iako_out),
   .pin_sp        (~pin_sp_n),
   .pin_sel       (pin_sel_out),
   .pin_bsy       (pin_bsy_out)
);
endmodule
