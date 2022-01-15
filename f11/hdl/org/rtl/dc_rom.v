//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
// MicROM module, (128 + 10) lines x 4 pages x 25-bit words
// 25-bit word provides 9-bit next address in the upper bits,
// the rest is 16-bit microcode opcode
//
module dc_rom
(
   input [9:0]    a_in,
   input [15:0]   d_in,
   output [8:0]   ma,
   output [15:0]  mc
);

wire [8:0] addr;
reg [31:0] mem [0:511];
integer i;

initial
begin
   for (i=0; i<512; i=i+1)
   begin
      mem[i] = 32'h00000000;
   end
   $readmemh("..\\..\\..\\..\\rom\\000.rom", mem);
end

//
// Save memory block for the AX extension, only 10 upper MicROM locations depend on AX
// The lower quarter of memory is not used (addresses are reserved for the PLA mapping)
// and this can be engaged to store unique data for the locations with set AX line
//
assign addr[3:0] = a_in[3:0];
assign addr[8:4] = (a_in[9] & (a_in[6:4] == 3'b111)) ? {3'b000, a_in[8:7]} : a_in[8:4];

assign mc = mem[addr][15:0];
assign ma = mem[addr][24:16];

endmodule

