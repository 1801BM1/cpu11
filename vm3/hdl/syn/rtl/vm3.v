//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module vm3
(
   input          pin_clk_p,     // processor clock, rising edge
   input          pin_clk_n,     // processor clock, falling edge
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input  [3:0]   pin_virq_n,    // vectored interrupt request
   inout          pin_init_n,    // peripheral reset (open drain)
                                 //
   inout  [15:0]  pin_ad_n,      // inverted address/data bus
   output [21:16] pin_a_n,       // inverted high address bus
   output         pin_umap_n,    // upper address mapping
   output         pin_bs_n,      // I/O bank select
                                 //
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
   input          pin_rply_n,    // transaction reply
                                 //
   output         pin_hltm_n,    // halt mode flag
   output         pin_sel_n,     // halt mode access
   input          pin_bsel_n     // boot mode selector
);

//______________________________________________________________________________
//
// External pin wires and controls
//
wire  pin_ad_ena, pin_a_ena;
wire  [15:0] pin_ad_out;
wire  [21:16] pin_a;

wire  pin_bs_out, pin_umap_out;
wire  pin_sel_out, pin_hltm_out;
wire  pin_sync_out, pin_wtbt_out;
wire  pin_din_out, pin_dout_out;
wire  pin_iako_out;
wire  pin_init_out;

//
// Shared Qbus lines
//
assign pin_a_n[21:16]   = pin_a_ena ? ~pin_a[21:16]    : 5'bZZZZZ;
assign pin_ad_n         = pin_ad_ena   ? ~pin_ad_out   : 16'hZZZZ;
assign pin_wtbt_n       = ~pin_wtbt_out;
assign pin_sync_n       = ~pin_sync_out;
assign pin_dout_n       = ~pin_dout_out;
assign pin_din_n        = ~pin_din_out;
assign pin_init_n       = pin_init_out ? 1'b0 : 1'bZ;
assign pin_iako_n       = ~pin_iako_out;
assign pin_bs_n         = ~pin_bs_out;

assign pin_umap_n       = ~pin_umap_out;
assign pin_hltm_n       = ~pin_hltm_out;
assign pin_sel_n        = ~pin_sel_out;

//
// Core instantiation
//
vm3_qbus core
(
   .pin_clk_p     (pin_clk_p),
   .pin_clk_n     (pin_clk_n),
   .pin_dclo      (~pin_dclo_n),
   .pin_aclo      (~pin_aclo_n),
   .pin_halt      (~pin_halt_n),
   .pin_evnt      (~pin_evnt_n),
   .pin_virq      (~pin_virq_n),

   .pin_init_in   (~pin_init_n),
   .pin_init_out  (pin_init_out),

   .pin_ad_in     (~pin_ad_n),
   .pin_ad_out    (pin_ad_out),
   .pin_ad_ena    (pin_ad_ena),
   .pin_a_out     (pin_a),
   .pin_a_ena     (pin_a_ena),
   .pin_umap      (pin_umap_out),
   .pin_bs        (pin_bs_out),

   .pin_sync      (pin_sync_out),
   .pin_wtbt      (pin_wtbt_out),
   .pin_dout      (pin_dout_out),
   .pin_din       (pin_din_out),
   .pin_iako      (pin_iako_out),
   .pin_rply      (~pin_rply_n),

   .pin_hltm      (pin_hltm_out),
   .pin_sel       (pin_sel_out),
   .pin_bsel      (~pin_bsel_n)
);

//_____________________________________________________________________________
//
endmodule
