//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
// F-11 asynchronous model, for debug and modelling only.
// This file contains the wrapper for F-11 "Fonz" chipset,
// it implements external circuits of the M6/KDF-11Ax (M8186)
// processor, supporting MMU and 22-bit address and micROM
// options (FPP, CIS, etc).
//
// DC302 21-15541-AB Data, 16-bit ALU, etc
// DC303 23-001C7-AA Control, standard instruction set
// DC303 23-002C7-AA Control, FP instruction set, part 1
// DC303 23-003C7-AA Control, FP instruction set, part 2
// DC304 21-15542-01 MMU
//
//______________________________________________________________________________
//
module f11
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input  [7:4]   pin_virq_n,    // vectored interrupt requests
                                 //
   input          pin_dmr_n,     // bus request line
   input          pin_sack_n,    // bus acknowlegement
   input          pin_rply_n,    // transaction reply
   output         pin_dmgo_n,    // bus granted output
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout          pin
   output [21:16] pin_a_n,       // inverted high address bus
   inout  [15:0]  pin_ad_n,      // inverted address/data bus
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
                                 //
   input [1:0]    pin_bsel_n     // boot mode selector
);

//______________________________________________________________________________
//
trireg [15:0] m;                 // microinstruction bus
trireg [15:0] ad;                // address/data bus
reg    [15:0] ad_in;             // input address/data register
tri1   [21:16] a;                // high address bus
                                 //
wire  ad_ena;                    // enable address/data bus drivers
wire  ad_stb;                    // latch address/data bus inputs

assign pin_ad_n = ad_ena ? ~ad : 16'oZZZZZZ;
always @(posedge ad_stb) ad_in <= ~pin_ad_n;
assign ad =
//______________________________________________________________________________
//
// Temporary workarounds
//
assign pin_dmgo_n = 1'bz;
assign pin_init_n = 1'bz;
assign pin_a_n    = 6'bzzzzzz;
assign pin_ad_n   = 16'hzzzz;
assign pin_sync_n = 1'b1;
assign pin_wtbt_n = 1'b1;
assign pin_dout_n = 1'b1;
assign pin_din_n  = 1'b1;
assign pin_iako_n = 1'b1;


//_____________________________________________________________________________
//
endmodule
