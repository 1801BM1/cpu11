//
// Copyright (c) 2020 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
// M4 microcode ROM, for debug and simulating only
//
module mcrom
(
   input       clk,     // input clock
   input       ena,     // clock enable
   input [9:0] addr,    // instruction address
   output [55:0] data   // output read opcode
);

//______________________________________________________________________________
//
// Memory array and its inititialization with K1656RE1-001/007 content
//
reg [55:0] rom [0:1023];
reg [55:0] q;
integer i;

initial
begin
end


initial
begin
   for (i=0; i<1023; i = i + 1)
   begin
      rom[i] = 56'h00000000000000;
   end
   //
   // The filename for MicROM content might be explicitly
   // specified in synthesys/simulating tool settings
   //
`ifdef M4_FILE_MICROM
   $readmemh(`M4_FILE_MICROM, rom);
`else
   $readmemh("../../../../rom/mc.rom", rom);
`endif
end

//______________________________________________________________________________
//
assign data = q;
always @ (posedge clk) if (ena) q <= rom[addr];

endmodule


