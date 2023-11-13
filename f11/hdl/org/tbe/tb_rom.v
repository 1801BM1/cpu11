//
// Copyright (c) 2021 by 1801BM1@gmail.com
//
// Testbench for the KDF-11A control lines decoding ROM
//______________________________________________________________________________
//
`include "../../tbe/config.v"

module tb_test_rom
(
   input  [4:0] a,
   output [7:0] d
);

reg [7:0] rom;
assign d = rom;

always @(*)
begin
   case(a)
      5'h00: rom = 8'b10101111;
      5'h01: rom = 8'b11101111;
      5'h02: rom = 8'b10101111;
      5'h03: rom = 8'b11101111;
      5'h04: rom = 8'b10101011;
      5'h05: rom = 8'b11101011;
      5'h06: rom = 8'b10101011;
      5'h07: rom = 8'b11101011;
      5'h08: rom = 8'b10101011;
      5'h09: rom = 8'b11101011;
      5'h0A: rom = 8'b10101011;
      5'h0B: rom = 8'b11101011;
      5'h0C: rom = 8'b10101011;
      5'h0D: rom = 8'b11101011;
      5'h0E: rom = 8'b10101011;
      5'h0F: rom = 8'b11101011;
      5'h10: rom = 8'b10001111;
      5'h11: rom = 8'b10001111;
      5'h12: rom = 8'b11100111;
      5'h13: rom = 8'b11100111;
      5'h14: rom = 8'b10001011;
      5'h15: rom = 8'b10001011;
      5'h16: rom = 8'b11100011;
      5'h17: rom = 8'b11100011;
      5'h18: rom = 8'b10001011;
      5'h19: rom = 8'b10001011;
      5'h1A: rom = 8'b11011011;
      5'h1B: rom = 8'b11011011;
      5'h1C: rom = 8'b10001010;
      5'h1D: rom = 8'b10001010;
      5'h1E: rom = 8'b10001011;
      5'h1F: rom = 8'b10001011;
   endcase
end
endmodule

//______________________________________________________________________________
//
module tb_test_pla
(
   input  [4:0] a,
   output [7:0] d
);

wire dma_ena;
wire bus_cyc;
wire [12:8] m;

assign dma_ena = a[0];
assign bus_cyc = a[1];
assign m[8] = a[2];
assign m[9] = a[3];
assign m[12] = a[4];

wire cyc_stut  = ~(m[12] & m[9] & m[8] & ~bus_cyc);
wire wtbt      = ~m[9] & ~m[8];
wire out_cyc_n = ~(m[12] & ~m[9] & bus_cyc);
wire din_cyc   = m[12] & m[9] & ~m[8] & bus_cyc;
wire bus_ena   = ~m[12] | ~m[9] & bus_cyc;
wire clk_hold  = ~m[12] & dma_ena | m[12] & bus_cyc & ~(m[9] & m[8]);

assign d[0] = cyc_stut;
assign d[1] = 1'b1;
assign d[2] = wtbt;
assign d[3] = out_cyc_n;
assign d[4] = din_cyc;
assign d[5] = bus_ena;
assign d[6] = clk_hold;
assign d[7] = 1'b1;
endmodule

//______________________________________________________________________________
//
module tb_rom();

integer i;
reg  [4:0] a;
wire [7:0] drom;
wire [7:0] dpla;

tb_test_rom mod_rom (.a(a), .d(drom));
tb_test_pla mod_pla (.a(a), .d(dpla));

initial
begin
   for (i=0; i<32; i = i + 1)
   begin
#5    a = i;
#5    if (drom ^ dpla)
         $display("mismatch %02X: %02X %02X;", i, drom, dpla);
//    $display("%02X: %02X %02X;", i, drom, dpla);
   end
   $display("test completed");
   $finish;
end
endmodule
