//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module vm3
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input  [3:0]   pin_virq_n,    // vectored interrupt request
                                 //
   input          pin_ssync_n,   // sync handshake
   input          pin_dmr_n,     // bus access request
   input          pin_sack_n,    // bus acknowlegement
   output         pin_dmgo_n,    // bus access grant
   inout          pin_init_n,    // peripheral reset (open drain)
                                 //
   inout  [15:0]  pin_ad_n,      // inverted address/data bus
   output [21:16] pin_a_n,       // inverted high address bus
   output         pin_bs_n,      // I/O bank select
                                 //
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
   input          pin_rply_n,    // transaction reply
                                 //
   output         pin_umap_n,    // upper address mapping
   output         pin_hltm_n,    // halt mode flag
   output         pin_sel_n,     // halt mode access
   output         pin_ta_n,      // translate address
                                 //
   output         pin_lin_n,     // load instruction
   input          pin_frdy_n,    // FPP ready
   inout          pin_ftrp_n,    // FPP trap/fatal error
   input          pin_drdy_n,    // data ready
   input          pin_fl_n,      // fload long
   input          pin_fd_n,      // fload double
   input          pin_et_n,      // enable bus timeout
   input          pin_wo_n       // boot mode selector
);

//______________________________________________________________________________
//
// External pin wires and controls
//
wire  pin_ad_ena, pin_a_ena;
wire  pin_ins_ena, pin_ins_out;
wire  [15:0] pin_ad_out;
wire  [21:16] pin_a;
wire  pin_ctrl_ena;

wire  pin_bs_out, pin_umap_out;
wire  pin_sel_out, pin_hltm_out;
wire  pin_lin_out, pin_ta_out;
wire  pin_sync_out, pin_wtbt_out;
wire  pin_din_out, pin_dout_out;
wire  pin_dmgo_out, pin_iako_out;
wire  pin_ftrp_out, pin_init_out;

//
// Shared Qbus lines
//
assign pin_a_n[21]      = pin_ins_ena  ? ~pin_ins_out  :
                        ( pin_a_ena ? ~pin_a[21]       : 1'bZ);
assign pin_a_n[20:16]   = pin_a_ena ? ~pin_a[20:16]    : 5'bZZZZZ;
assign pin_ad_n         = pin_ad_ena   ? ~pin_ad_out   : 16'hZZZZ;
assign pin_wtbt_n       = pin_ctrl_ena ? ~pin_wtbt_out : 1'bZ;
assign pin_sync_n       = pin_ctrl_ena ? ~pin_sync_out : 1'bZ;
assign pin_dout_n       = pin_ctrl_ena ? ~pin_dout_out : 1'bZ;
assign pin_din_n        = pin_ctrl_ena ? ~pin_din_out  : 1'bZ;
assign pin_init_n       = pin_init_out ? 1'b0 : 1'bZ;
assign pin_ftrp_n       = pin_ftrp_out ? 1'b0 : 1'bZ;
assign pin_iako_n       = ~pin_iako_out;
assign pin_dmgo_n       = ~pin_dmgo_out;
assign pin_bs_n         = ~pin_bs_out;

assign pin_umap_n       = ~pin_umap_out;
assign pin_hltm_n       = ~pin_hltm_out;
assign pin_sel_n        = ~pin_sel_out;
assign pin_ta_n         = ~pin_ta_out;
assign pin_lin_n        = ~pin_lin_out;

//
// Core instantiation
//
vm3_qbus core
(
   .pin_clk       (pin_clk),
   .pin_dclo      (~pin_dclo_n),
   .pin_aclo      (~pin_aclo_n),
   .pin_halt      (~pin_halt_n),
   .pin_evnt      (~pin_evnt_n),
   .pin_virq      (~pin_virq_n),

   .pin_ssync     (~pin_ssync_n),
   .pin_dmr       (~pin_dmr_n),
   .pin_sack      (~pin_sack_n),
   .pin_dmgo      (pin_dmgo_out),
   .pin_init_in   (~pin_init_n),
   .pin_init_out  (pin_init_out),

   .pin_ad_in     (~pin_ad_n),
   .pin_ad_out    (pin_ad_out),
   .pin_ad_ena    (pin_ad_ena),
   .pin_a_out     (pin_a),
   .pin_a_ena     (pin_a_ena),
   .pin_ins_out   (pin_ins_out),
   .pin_ins_ena   (pin_ins_ena),
   .pin_ctrl_ena  (pin_ctrl_ena),
   .pin_bs        (pin_bs_out),

   .pin_sync      (pin_sync_out),
   .pin_wtbt      (pin_wtbt_out),
   .pin_dout      (pin_dout_out),
   .pin_din       (pin_din_out),
   .pin_iako      (pin_iako_out),
   .pin_rply      (~pin_rply_n),

   .pin_umap      (pin_umap_out),
   .pin_hltm      (pin_hltm_out),
   .pin_sel       (pin_sel_out),
   .pin_ta        (pin_ta_out),
   .pin_lin       (pin_lin_out),

   .pin_ftrp_out  (pin_ftrp_out),
   .pin_ftrp_in   (~pin_ftrp_n),
   .pin_frdy      (~pin_frdy_n),
   .pin_drdy      (~pin_drdy_n),
   .pin_fl        (~pin_fl_n),
   .pin_fd        (~pin_fd_n),
   .pin_et        (~pin_et_n),
   .pin_wo        (~pin_wo_n)
);

//_____________________________________________________________________________
//
endmodule
