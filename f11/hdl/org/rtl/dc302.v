//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
// DC302 Data Chip model, for debug and simulating only
//______________________________________________________________________________
//
module dc302
(
   input          pin_clk,    // main clock
   inout [15:0]   pin_ad,     // address/data bus
   inout [15:0]   pin_m,      // microinstruction bus
   inout          pin_bs_n,   // bus select
   input          pin_ez_n    // enable Z-state
);

//______________________________________________________________________________
//
endmodule
