//
// Copyright (c) 2014-2024 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// CM-2420 Unibus processor model, with some differences for simpler forthcoming
// synchronous model convertion and implementing in FPGA:
//
// - all Unibus signals given in positive notation, assertion means high level
// - no dedicated I/O peripheral and memory master sync signals
// - no parity check logic is implemented
//______________________________________________________________________________
//
//
`timescale 1ns / 100ps

module s20
(
   input          pin_clk,       // processor clock
   input          pin_dclo,      // processor reset
   input          pin_aclo,      // power fail notification
   output         pin_init,      // peripherals and bus init
                                 //
   input  [15:0]  pin_di,        // data bus input
   output [15:0]  pin_do,        // data bus output
   output [21:0]  pin_a,         // address bus
   output         pin_bs,        // bank 7 select
                                 //
   output [1:0]   pin_c,         // type of data transfer
   output         pin_isyn,      // interrupt vector sync output
   output         pin_msyn,      // master sync output
   input          pin_ssyn,      // slave sync input
   input          pin_intr,      // interrupt vector transfer
                                 //
   input  [7:4]   pin_br,        // bus request for interrupt
   output [7:4]   pin_bg,        // bus grant for interrupt
   input          pin_npr,       // bus non-processor request
   output         pin_npg,       // bus non-processor grant
   input          pin_sack,      // bus acknowlegement
   input          pin_busy       // bus busy
);

//______________________________________________________________________________
//
// Temporary stubs
//
assign   pin_init = 1'b1;
assign   pin_do = 16'oZZZZ;
assign   pin_a = 22'oZZZZZZZ;
assign   pin_bs = 1'b0;
assign   pin_c = 2'b00;
assign   pin_isyn = 1'b0;
assign   pin_msyn = 1'b0;
assign   pin_bg = 4'b0000;
assign   pin_npg = 1'b0;

//_____________________________________________________________________________
//
endmodule
