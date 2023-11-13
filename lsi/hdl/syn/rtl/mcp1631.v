//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// MCP-1631 MicROM model, for debug and simulating only
//______________________________________________________________________________
//
//
module mcp1631
(
   input          pin_clk,       // main clock
   input  [10:0]  pin_lc,        // location counter
   output [21:0]  pin_mo         // microinstruction bus
);
//______________________________________________________________________________
//
// Memory array and its inititialization with 1631-10/07/15 content
//
reg [21:0] rom [0:2047];
reg [21:0] q;

initial
begin
   $readmemb("../../../../rom/all_22b.rom", rom);
end

always @ (posedge pin_clk)
begin
   q <= rom[pin_lc];
end

assign pin_mo = q;
endmodule
