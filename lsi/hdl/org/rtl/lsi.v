//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// LSI-11 asynchronous model, for debug and modelling only
// This file contains the wrapper for MCP-1600 chipset.
//______________________________________________________________________________
//
module lsi
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input          pin_virq_n,    // vectored interrupt request
   input          pin_rfrq_n,    // refresh DRAM request
                                 //
   input          pin_dmr_n,     // bus request line
   input          pin_sack_n,    // bus acknowlegement
   input          pin_rply_n,    // transaction reply
   output         pin_dmgo_n,    // bus granted output
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout [15:0]   pin_ad_n,      // inverted address/data bus
   output         pin_ref_n,     // dynamic RAM refresh
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n     // interrupt vector input
);

//______________________________________________________________________________
//
trireg [21:0] m_n;               // inverted microinstruction bus

//______________________________________________________________________________
//
// External pin wires and controls
//
wire  pin_ad_ena;
wire  pin_init_ena;
wire  pin_ctrl_ena;
wire  [15:0] pin_ad_out;

wire  pin_dmgo_out;
wire  pin_ref_out;
wire  pin_sync_out;
wire  pin_wtbt_out;
wire  pin_dout_out;
wire  pin_din_out;
wire  pin_iako_out;

//______________________________________________________________________________
//
// Shared Qbus lines
//
assign pin_ad_n   = pin_ad_ena   ? ~pin_ad_out : 16'oZZZZZZ;
assign pin_dout_n = pin_ctrl_ena ? ~pin_dout_out : 1'bZ;
assign pin_din_n  = pin_ctrl_ena ? ~pin_din_out  : 1'bZ;
assign pin_wtbt_n = pin_ctrl_ena ? ~pin_wtbt_out : 1'bZ;
assign pin_sync_n = pin_ctrl_ena ? ~pin_sync_out : 1'bZ;
//
// "Open drain" outputs
//
assign pin_init_n = pin_init_ena ? 1'b0 : 1'bZ;
//
// Other outputs
//
assign pin_dmgo_n = ~pin_dmgo_out;
assign pin_ref_n  = ~pin_ref_out;
assign pin_iako_n = ~pin_iako_out;

//______________________________________________________________________________
//
// Internal clock generator feeds the C1, C2, C3, C4 clock phases
//
reg [1:0] ccnt;
reg c1, c2, c3, c4;

initial ccnt = 2'b00;

always @(posedge pin_clk)
begin
   ccnt <= ccnt + 2'b01;
   c1 <= (ccnt == 2'b00);
   c2 <= (ccnt == 2'b01);
   c3 <= (ccnt == 2'b10);
   c4 <= (ccnt == 2'b11);
end

//_____________________________________________________________________________
//
assign pin_ad_ena    = 1'b0;
assign pin_init_ena  = 1'b0;
assign pin_ctrl_ena  = 1'b1;
assign pin_ad_out    = 16'h0000;

assign pin_dmgo_out  = 1'b0;
assign pin_sync_out  = 1'b0;
assign pin_wtbt_out  = 1'b0;
assign pin_iako_out  = 1'b0;
assign pin_dout_out  = 1'b0;
assign pin_din_out   = 1'b0;
assign pin_ref_out   = 1'b0;

//_____________________________________________________________________________
//
endmodule
