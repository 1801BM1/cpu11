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

   always @(posedge clock) begin
       if (wren_a) begin
           if (byteena_a[0]) ram[address_a][7:0] <= data_a[7:0];
           if (byteena_a[1]) ram[address_a][15:8] <= data_a[15:8];
       end
   end

// TODO support NEW_DATA_NO_NBE_READ
//   altsyncram_component.read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ",
//   altsyncram_component.read_during_write_mode_port_b = "NEW_DATA_NO_NBE_READ",

   always @(posedge clock) begin
       if (wren_b)
           ram[address_b] <= data_b;
   end

   initial begin
       $readmemh("../../rtl/vm1_reg.mem", ram, 0, 63);
   end
endmodule /* vm1_vcram */
