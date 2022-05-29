//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// DC304 MMU Chip Floating Point Register File
//______________________________________________________________________________
//
// Generic implementation of Register File, memory blocks are supposed to be
// inferred. Some verions of synthesys tools (Quartus, etc.) do not infer memory
// blocks correctly, so explicit RAM megafunction should be used, depending on
// device type. It provides much better Fmax and resource usage. If vendor
// specific memory function is used this file should not be included in project.
//
// Interface is compatible with Altera Single-Port Single Clock RAM.
//
module dc_fpp(
   input         clock,
   input [5:0]   address,
   input [15:0]  data,
   input         wren,
   input         rden,
   output [15:0] q
);

reg [15:0] ram[63:0];
reg [5:0] addr;

integer i;
initial
begin
   for (i=0; i<64; i = i + 1)
      ram[i]  = 16'h0000;
end

always @ (posedge clock)
begin
   if (wren)
      ram[address][15:0] <= data[15:0];
   if (rden)
      addr <= address;
end
assign q = ram[addr];

endmodule

