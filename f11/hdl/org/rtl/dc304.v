//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
// DC304 MMU and Register Chip model, for debug and simulating only
//_____________________________________________________________________________
//
module dc304
(
   input          pin_clk,    // main clock
   inout  [15:0]  pin_ad,     // address/data bus
   output [21:16] pin_a,      // high address bus
   input  [12:4]  pin_m,      // microinstruction bus
   output         pin_me_n,   // mapping enabled
   output         pin_ra_n,   // register access reply
   output         pin_de_n,   // invalid memory access
   output         pin_m15_n,  // address conversion flag
   inout          pin_bs_n,   // bus select
   input          pin_ez_n    // enable Z-state
);

//
// MMU is not implemented yet, empty socket emulation
//
assign pin_me_n = 1'b1;
assign pin_ra_n = 1'b1;
assign pin_de_n = 1'b1;

assign pin_bs_n = 1'bz;
assign pin_m15_n = 1'bz;

assign pin_a[21:16] = 6'bzzzzzz;
assign pin_ad[15:0] = 16'oZZZZZZ;

//______________________________________________________________________________
//
endmodule
