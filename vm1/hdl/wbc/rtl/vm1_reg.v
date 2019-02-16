//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// 1801VM1 Register File and Constant Generator (64x16 Dual-Port RAM/ROM)
//______________________________________________________________________________
//
// Generic implementation of Register File and Constant Generator, memory blocks
// are assumed to be inferred. Some verions of synthesys tools (Quartus, etc.)
// do not infer memory blocks correctly, so explicit RAM megafunction should be
// used, depending on device type. It provides much better Fmax and resource
// usage. If vendor specific memory function is used this file should not be
// included in project.
//
// Interface is compatible with Altera Dual-Port Single Clock RAM.
// Writing on Port B is not used, because Port B is for ROM only.
//
module vm1_vcram(
   input [5:0]  address_a,
   input [5:0]  address_b,
   input [1:0]  byteena_a,
   input        clock,
   input [15:0] data_a,
   input [15:0] data_b,
   input        wren_a,
   input        wren_b,
   output reg [15:0] q_a,
   output reg [15:0] q_b);

reg [15:0] ram[63:0];
//
// Set initial content for Constant and Vector Generator
//
initial
begin
   ram[ 0] = 16'O000000;
   ram[ 1] = 16'O000000;
   ram[ 2] = 16'O000000;
   ram[ 3] = 16'O000000;
   ram[ 4] = 16'O000000;
   ram[ 5] = 16'O000000;
   ram[ 6] = 16'O000000;
   ram[ 7] = 16'O000000;

   ram[ 8] = 16'O000000;
   ram[ 9] = 16'O000000;
   ram[10] = 16'O000000;
   ram[11] = 16'O000000;
   ram[12] = 16'O000000;
   ram[13] = 16'O000000;
   ram[14] = 16'O000000;
   ram[15] = 16'O000000;

   ram[16] = 16'O160006;
   ram[17] = 16'O000020;
   ram[18] = 16'O000010;
   ram[19] = 16'O000014;
   ram[20] = 16'O000004;
   ram[21] = 16'O177716;
   ram[22] = 16'O000030;
   ram[23] = 16'O160012;

   ram[24] = 16'O000270;
   ram[25] = 16'O000024;
   ram[26] = 16'O000100;
   ram[27] = 16'O160002;
   ram[28] = 16'O000034;
   ram[29] = 16'O000000;
   ram[30] = 16'O000000;
   ram[31] = 16'O000000;

   ram[32] = 16'O000000;
   ram[33] = 16'O000340;
   ram[34] = 16'O000000;
   ram[35] = 16'O000002;
   ram[36] = 16'O000000;
   ram[37] = 16'O177716;
   ram[38] = 16'O177777;
   ram[39] = 16'O000001;

   ram[40] = 16'O000000;
   ram[41] = 16'O100000;
   ram[42] = 16'O177676;
   ram[43] = 16'O000020;
   ram[44] = 16'O000000;
   ram[45] = 16'O177400;
   ram[46] = 16'O000010;
   ram[47] = 16'O000000;

   ram[48] = 16'O000000;
   ram[49] = 16'O000000;
   ram[50] = 16'O000000;
   ram[51] = 16'O000000;
   ram[52] = 16'O000000;
   ram[53] = 16'O000000;
   ram[54] = 16'O000000;
   ram[55] = 16'O000000;

   ram[56] = 16'O000000;
   ram[57] = 16'O000000;
   ram[58] = 16'O000000;
   ram[59] = 16'O000000;
   ram[60] = 16'O000000;
   ram[61] = 16'O000000;
   ram[62] = 16'O000000;
   ram[63] = 16'O000000;
end

always @ (posedge clock)
begin
   if (wren_a)
   begin
      if (byteena_a[0]) ram[address_a][7:0] <= data_a[7:0];
      if (byteena_a[1]) ram[address_a][15:8] <= data_a[15:8];
   end
   q_a <= ram[address_a];
   if (wren_b)
      ram[address_b]<= data_b;
   q_b <= ram[address_b];
end
endmodule
