`include "../../lib/config.v"

module qa7_mem
(
   input [12:0]   addra,
   input          clka,
   input [15:0]   dina,
   input          wea,
   input [1:0]    ena,     // byteena
   output [15:0]  douta
);

reg [15:0]  mem [0:8191];
reg [12:0]  areg;
reg [1:0]   wreg;

always @ (posedge clka)
begin
   areg <= addra;
   wreg[0] <= wea & ena[0];
   wreg[1] <= wea & ena[1];

   if (wreg[0])
      mem[areg][7:0] <= dina[7:0];
   if (wreg[1])
      mem[areg][15:8] <= dina[15:8];
end

assign douta = mem[areg];
//
// $readmemh is synthezable in XST
// Use inferred block memory instead core generator
// (work too boring, difficult to change content)
//
initial
begin
   $readmemh(`CPU_TEST_MEMF, mem, 0, 8191);
end
endmodule

