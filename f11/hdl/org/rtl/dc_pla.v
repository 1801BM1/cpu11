//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
// PLA matrix:
//    - 23 inputs - 7 lower bits of next address, 16 bits of data
//    - selected if upper next address bits na[8:7] are both zeroes
//    - 25 outputs - 9 bits of next address and 16 bits of microcode
//    - 138 minterms (products)
//
module dc_pla
#(parameter
//______________________________________________________________________________
//
// DC303_PLA defines PLA content of the DC303 module
//  - DC303_PLA = 0, 23-001C7-AA - 1811VU1
//  - DC303_PLA = 1, 23-002C7-AA - 1811VU3
//  - DC303_PLA = 2, 23-203C7-AA - 1811VU2
//
   DC303_PLA = 0
)
(
   input [6:0]    a_in,
   input [15:0]   d_in,
   output [8:0]   ma,
   output [15:0]  mc
);

generate
   case(DC303_PLA)
      0: dc_pla_0 pla(.a_in(a_in), .d_in(d_in), .ma(ma), .mc(mc));
      1: dc_pla_1 pla(.a_in(a_in), .d_in(d_in), .ma(ma), .mc(mc));
      2: dc_pla_2 pla(.a_in(a_in), .d_in(d_in), .ma(ma), .mc(mc));
   endcase
endgenerate
endmodule
