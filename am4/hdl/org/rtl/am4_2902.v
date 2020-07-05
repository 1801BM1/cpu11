//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Hig-Speed Look-Ahead Carry Generator
//
module am2902
(
   input          cin,        // carry input
   input [3:0]    g_n,        // carry generate input
   input [3:0]    p_n,        // carry propagate input
   output [2:0]   cout,       // carry output
   output         gout_n,     // carry generate output
   output         pout_n      // carry propagate output
);

//______________________________________________________________________________
//
wire [3:0] g;
wire [3:0] p;

assign g = ~g_n;
assign p = ~p_n;

assign cout[0] = g[0]
               | cin  & p[0];
assign cout[1] = g[1]
               | g[0] & p[1]
               | cin  & p[1] & p[0];
assign cout[2] = g[2]
               | g[1] & p[2]
               | g[0] & p[2] & p[1]
               | cin  & p[2] & p[1] & p[0];
assign gout_n = ~( g[3]
                 | g[2] & p[3]
                 | g[1] & p[3] & p[2]
                 | g[0] & p[3] & p[2] & p[1]);
assign pout_n = ~&p;

//______________________________________________________________________________
//
endmodule
