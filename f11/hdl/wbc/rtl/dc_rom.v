//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
// MicROM module, (128 + 10) lines x 4 pages x 25-bit words
// 25-bit word provides 9-bit next address in the upper bits,
// the rest is 16-bit microcode opcode
//
module dc_rom
#(parameter
//______________________________________________________________________________
//
// DC303_CS defines ROM content of the DC303 ROM module
//  - DC303_CS = 0, 23-001C7-AA, 000.rom
//  - DC303_CS = 1, 23-002C7-AA, 001.rom
//  - DC303_CS = 2, 23-203C7-AA, 002.rom
//
   DC303_ROM = 0
)
(
   input          clk,
   input          cen,
   input [9:0]    a_in,
   output [8:0]   ma,
   output [15:0]  mc
);

wire [8:0] addr;
reg  [8:0] qa;
reg [15:0] qc;
reg [31:0] mem [0:511];

integer i;


initial
begin
   for (i=0; i<512; i=i+1)
   begin
      mem[i] = 32'h00000000;
   end
   //
   // The filename for MicROM content might be explicitly
   // specified in synthesys/simulating tool settings
   //
   if (DC303_ROM == 0)
      `ifdef F11_FILE_MICROM_000
         $readmemh(`F11_FILE_MICROM_000, mem);
      `else
         $readmemh("../../../../rom/000.rom", mem);
      `endif
   else
   if (DC303_ROM == 1)
      `ifdef F11_FILE_MICROM_001
         $readmemh(`F11_FILE_MICROM_001, mem);
      `else
         $readmemh("../../../../rom/001.rom", mem);
      `endif
   else
   if (DC303_ROM == 2)
      `ifdef F11_FILE_MICROM_002
         $readmemh(`F11_FILE_MICROM_002, mem);
      `else
         $readmemh("../../../../rom/002.rom", mem);
      `endif
end

//
// Save memory block for the AX extension, only 10 upper MicROM locations depend on AX
// The lower quarter of memory is not used (addresses are reserved for the PLA mapping)
// and this can be engaged to store unique data for the locations with set AX line
//
assign addr[3:0] = a_in[3:0];
assign addr[8:4] = (a_in[9] & (a_in[6:4] == 3'b111)) ? {3'b000, a_in[8:7]} : a_in[8:4];

always @(posedge clk)
begin
   if (cen)
   begin
      qa <= mem[addr][24:16];
      qc <= mem[addr][15:0];
   end
end

assign mc = qc;
assign ma = qa;

endmodule

