//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// MCP-1631 MicROM model, for debug and simulating only
//______________________________________________________________________________
//
module mcp1631
(
   input          pin_c1,        // clock phase 1
   input          pin_c2,        // clock phase 2
   input          pin_c3,        // clock phase 3
   input          pin_c4,        // clock phase 4
   inout [21:0]   pin_m_n        // microinstruction bus
);

//______________________________________________________________________________
//
// Memory array and its inititialization with 1631-10/07/15 content
//
reg [31:0] mem [0:2047];
integer i;

initial
begin
   for (i=0; i<2048; i = i + 1)
   begin
      mem[i] = 32'h00000000;
   end
   $readmemh("../../../../rom/all.rom", mem);
end

//______________________________________________________________________________
//
reg [10:0] addr;
reg [21:0] data;
reg [21:0] mout;

assign pin_m_n = mout;
always @ (*) if (pin_c2) addr <= ~pin_m_n[10:0];
always @ (*) if (pin_c3) data <= pin_m_n[16] ? mem[addr][21:0] : 22'h000000;
always @ (*)
begin
   if (pin_c1)
   begin
      //
      // Discharge microinstruction bus lines to low
      // data[] was set to zeroes if m16 was low on C3
      //
      mout[0]  <= data[0]  ? 1'b0 : 1'bz;
      mout[1]  <= data[1]  ? 1'b0 : 1'bz;
      mout[2]  <= data[2]  ? 1'b0 : 1'bz;
      mout[3]  <= data[3]  ? 1'b0 : 1'bz;
      mout[4]  <= data[4]  ? 1'b0 : 1'bz;
      mout[5]  <= data[5]  ? 1'b0 : 1'bz;
      mout[6]  <= data[6]  ? 1'b0 : 1'bz;
      mout[7]  <= data[7]  ? 1'b0 : 1'bz;
      mout[8]  <= data[8]  ? 1'b0 : 1'bz;
      mout[9]  <= data[9]  ? 1'b0 : 1'bz;
      mout[10] <= data[10] ? 1'b0 : 1'bz;
      mout[11] <= data[11] ? 1'b0 : 1'bz;
      mout[12] <= data[12] ? 1'b0 : 1'bz;
      mout[13] <= data[13] ? 1'b0 : 1'bz;
      mout[14] <= data[14] ? 1'b0 : 1'bz;
      mout[15] <= data[15] ? 1'b0 : 1'bz;
      mout[16] <= data[16] ? 1'b0 : 1'bz;
      mout[17] <= data[17] ? 1'b0 : 1'bz;
      mout[18] <= data[18] ? 1'b0 : 1'bz;
      mout[19] <= data[19] ? 1'b0 : 1'bz;
      mout[20] <= data[20] ? 1'b0 : 1'bz;
      mout[21] <= data[21] ? 1'b0 : 1'bz;
   end
   if (pin_c2)
   begin
      //
      // Prepare to get address from Control Chip
      //
      mout[10:0] <= 11'hzzz;
      //
      // Precharge line 16 of microinstruction bus
      // If discharged to low on C3 then
      // MicROM outputs on C1 will be disabled
      //
      mout[16] <= 1'b1;
   end
   if (pin_c3)
   begin
      //
      // Precharge cut off
      //
      mout[16] <= 1'bz;
      //
      // Precharge line 15 of microinstruction bus
      //
      mout[15] <= 1'b1;
   end
   if (pin_c4)
   begin
      //
      // Precharge cut off
      //
      mout[15] <= 1'bz;
      //
      // Precharge the microinstruction bus to read on C1
      //
      mout[14:0] <= 15'h7fff;
      mout[21:16] <= 6'h3f;
   end
end
endmodule
