//
// Copyright (c) 2014-2024 by 1801BM1@gmail.com
//
// Memory Managment Unit Register File
//______________________________________________________________________________
//
// Generic implementation of Register File, memory blocks are supposed to be
// inferred. Some verions of synthesys tools (Quartus, etc.) do not infer memory
// blocks correctly, so explicit RAM megafunction should be used, depending on
// device type. It provides much better Fmax and resource usage. If vendor
// specific memory function is used this file should not be included in
// the project.
//
// Interface is compatible with Altera Dual-Port Single Clock RAM with
// byte lane enable strobes.
//
// Port A is used to access MMU registers from CPU bus and to present page
// address register (PAR) content on address translation cycle. Port B is used
// to present page descriptor register (PDR) content for address translation only.
// Actually, write enable for port B is not used.
//
module vm3_mmu (
   input         clock,
   input  [4:0]  address_a,
   input  [4:0]  address_b,
   input  [1:0]  byteena_a,
   input  [1:0]  byteena_b,
   input  [15:0] data_a,
   input  [15:0] data_b,
   output [15:0] q_a,
   output [15:0] q_b,
   input  wren_a,
   input  wren_b
);

reg [15:0] ram[31:0];
reg [5:0] addr_a;
reg [5:0] addr_b;

//______________________________________________________________________________
//
// Minimal required registers initalization, otherwise,
// undefined content would prevent simulation.
//
integer i;
initial
begin
   for (i=0; i<32; i = i+1)
      ram[i]  = 16'h0000;
end

//______________________________________________________________________________
//
always @ (posedge clock)
begin
   addr_a = address_a;
   if (wren_a)
   begin
      if (byteena_a[0]) ram[addr_a][7:0] = data_a[7:0];
      if (byteena_a[1]) ram[addr_a][15:8] = data_a[15:8];
   end

   addr_b = address_b;
   if (wren_b)
   begin
      if (byteena_b[0]) ram[addr_b][7:0] = data_b[7:0];
      if (byteena_b[1]) ram[addr_b][15:8] = data_b[15:8];
   end
end

assign q_a = ram[addr_a];
assign q_b = ram[addr_b];

endmodule
