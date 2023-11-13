//
// Copyright (c) 2020 by 1801BM1@gmail.com
//
// Testbench for the Am2901 ALU
//______________________________________________________________________________
//
`include "../../tbe/config.v"

//______________________________________________________________________________
//
//
module mem29
(
   input       [11:0] a,
   output reg  [11:0] d
);

reg [11:0] mem [0:4095];

always @ (a)
begin
   d = mem[a];
end

initial
begin
   $readmemh("../../tbe/vec_2901.vec", mem);
end
endmodule

//______________________________________________________________________________
//
// Testbench for the am2901 ALU module
//
module tba();
integer i;

reg  [11:0] vec;     // input vectored
wire [11:0] out;     // test result
wire [11:0] ref;     // reference
wire [11:0] tst;     //
                     //
reg         clk;     // main clock
reg  [8:0]  iop;     // APU operation code
reg  [3:0]  portd;   // direct data port
wire [3:0]  porty;   // data output
reg         cin;     // carry input
                     //
wire        cout;    // carry output
wire        ovr;     // arithmetic overflow
wire        f3;      // MSB of ALU output
wire        zf;      // (F[3:0] == 0) flag output (OC)
wire        g_n;     // carry generate output
wire        p_n;     // carry propagate output
tri0 [3:0]  pd;      // pull down

//_____________________________________________________________________________
//
mem29 rom(
   .a(vec),
   .d(ref));

//_____________________________________________________________________________
//
am2901 alu
(
   .cp(clk),         // clock positive
   .i(iop),          // operation code
   .a(4'b0000),      // port A address
   .b(4'b0000),      // port B address
   .d(portd),        // direct data input
   .y(porty),        // data output (3-state)
   .oe_n(1'b0),      // Y output enable
   .q0(pd[0]),       // shift line Q-register LSB
   .q3(pd[1]),       // shift line Q-register MSB
   .ram0(pd[2]),     // shift line register stack LSB
   .ram3(pd[3]),      // shift line register stack MSB
   .cin(cin),        // carry input
   .cout(cout),      // carry output
   .ovr(ovr),        // arithmetic overflow
   .f3(f3),          // MSB of ALU output
   .zf(zf),          // (F[3:0] == 0) flag output (OC)
   .g_n(g_n),        // carry generate output
   .p_n(p_n)         // carry propagate output
);

//_____________________________________________________________________________
//
assign out[3:0] = porty;
assign out[4]   = zf;
assign out[5]   = f3;
assign out[6]   = ovr;
assign out[7]   = cout;
assign out[8]   = p_n;
assign out[9]   = g_n;
assign out[10]   = 1'b0;
assign out[11]   = 1'b0;

assign pd = 4'b0000;
assign tst = out ^ ref;
//_____________________________________________________________________________
//
initial
begin
   clk   = 1;
   iop   = 4'b0;
   portd = 4'b0;
   cin = 0;

   for (i=0; i<4095; i = i + 1)
   begin
   //
      // set Y operand to Q register
      //
      clk      = 0;
      vec      = i;
      portd    = vec[7:4];
      iop[2:0] = 3'b111;
      iop[8:3] = 6'b000000;
      cin      = 1'b0;

#`SIM_CONFIG_CLOCK_HPERIOD
      clk      = 1;
#`SIM_CONFIG_CLOCK_HPERIOD
      clk      = 0;

      portd    = vec[3:0];
      iop[2:0] = 3'b110;
      cin      = vec[8];
      iop[5:3] = vec[11:9];
      iop[8:6] = 3'b000;

#`SIM_CONFIG_CLOCK_HPERIOD
      if (out != ref)
      begin
         $display("Test failed @%03X: ref:%03X  out:%03X  xor:%03X", i, ref, out, out ^ ref);
         if (tst[3:0] != 4'b0000) $display("Function failed");
         if (tst[4]) $display("ZF failed");
         if (tst[5]) $display("F3 failed");
         if (tst[6]) $display("VF failed");
         if (tst[7]) $display("C4 failed");
         if (tst[8]) $display("nP failed");
         if (tst[9]) $display("nG failed");
         $finish;
      end
      clk      = 1;
#`SIM_CONFIG_CLOCK_HPERIOD
      clk      = 0;
   end
end

//_____________________________________________________________________________
//
endmodule
