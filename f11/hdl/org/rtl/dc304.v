//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
// DC304 MMU and Register Chip model, for debug and simulating only
//_____________________________________________________________________________
//
module dc304
(
   input          pin_clk,    // main clock
   inout [15:0]   pin_ad,     // address/data bus
   input [12:4]   pin_m,      // microinstruction bus
   output         pin_me_n,   // mapping enabled
   output         pin_ra_n,   // register access reply
   output         pin_de_n,   // invalid memory access
   output         pin_m15_n,  // address conversion flag
   inout          pin_bs_n,   // bus select
   input          pin_ez_n    // enable Z-state
);

//______________________________________________________________________________
//
endmodule
