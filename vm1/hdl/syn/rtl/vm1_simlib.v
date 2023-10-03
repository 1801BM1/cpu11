// Simple single clock dual-port RAM implementation
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module vm1_vcram (
   address_a,
   address_b,
   byteena_a,
   clock,
   data_a,
   data_b,
   wren_a,
   wren_b,
   q_a,
   q_b);

   input [5:0]  address_a;
   input [5:0]  address_b;
   input [1:0]  byteena_a;
   input   clock;
   input [15:0]  data_a;
   input [15:0]  data_b;
   input   wren_a;
   input   wren_b;
   output   [15:0]  q_a;
   output   [15:0]  q_b;

   reg  [15:0]  ram[63:0];

   assign q_a = ram[address_a];
   assign q_b = ram[address_b];

   always @(posedge clock)
   begin
       if (wren_a)
       begin
           if (byteena_a[0]) ram[address_a][7:0] <= data_a[7:0];
           if (byteena_a[1]) ram[address_a][15:8] <= data_a[15:8];
       end
   end

// TODO support NEW_DATA_NO_NBE_READ
//   altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
//   altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",

   always @(posedge clock)
   begin
       if (wren_b)
           ram[address_b] <= data_b;
   end

   initial
   begin
      ram[0] = 16'o000000;
      ram[1] = 16'o000000;
      ram[2] = 16'o000000;
      ram[3] = 16'o000000;
      ram[4] = 16'o000000;
      ram[5] = 16'o000000;
      ram[6] = 16'o000000;
      ram[7] = 16'o000000;

      ram[8] = 16'o000000;
      ram[9] = 16'o000000;
      ram[10] = 16'o000000;
      ram[11] = 16'o000000;
      ram[12] = 16'o000000;
      ram[13] = 16'o000000;
      ram[14] = 16'o000000;
      ram[15] = 16'o000000;

      ram[16] = 16'o160006;
      ram[17] = 16'o000020;
      ram[18] = 16'o000010;
      ram[19] = 16'o000014;
      ram[20] = 16'o000004;
      ram[21] = 16'o177716;
      ram[22] = 16'o000030;
      ram[23] = 16'o160012;

      ram[24] = 16'o000270;
      ram[25] = 16'o000024;
      ram[26] = 16'o000100;
      ram[27] = 16'o160002;
      ram[28] = 16'o000034;
      ram[29] = 16'o000000;
      ram[30] = 16'o000000;
      ram[31] = 16'o000000;

      ram[32] = 16'o000000;
      ram[33] = 16'o000340;
      ram[34] = 16'o000000;
      ram[35] = 16'o000002;
      ram[36] = 16'o000000;
      ram[37] = 16'o177716;
      ram[38] = 16'o177777;
      ram[39] = 16'o000001;

      ram[40] = 16'o000000;
      ram[41] = 16'o100000;
      ram[42] = 16'o177676;
      ram[43] = 16'o000020;
      ram[44] = 16'o000000;
      ram[45] = 16'o177400;
      ram[46] = 16'o000010;
      ram[47] = 16'o000000;

      ram[48] = 16'o000000;
      ram[49] = 16'o000000;
      ram[50] = 16'o000000;
      ram[51] = 16'o000000;
      ram[52] = 16'o000000;
      ram[53] = 16'o000000;
      ram[54] = 16'o000000;
      ram[55] = 16'o000000;

      ram[56] = 16'o000000;
      ram[57] = 16'o000000;
      ram[58] = 16'o000000;
      ram[59] = 16'o000000;
      ram[60] = 16'o000000;
      ram[61] = 16'o000000;
      ram[62] = 16'o000000;
      ram[63] = 16'o000000;
   end
endmodule /* vm1_vcram */
