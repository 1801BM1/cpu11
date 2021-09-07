//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Delay line
//
module am4_delay
(
   input        clk,       // DLL input clock
   input        inp,       // DLL input data
   output [9:0] phase      // DLL outputs
);

reg  [9:0]  dll;           // digital delay line register

initial dll[9:0] = 10'h000;
always @(posedge clk) dll[9:0] <= {dll[8:0], inp};
//
// phase[0] - 15
// phase[1] - 30
// phase[2] - 45
// phase[3] - 60
// phase[4] - 75
// phase[5] - 90
// phase[6] - 105
// phase[7] - 120
// phase[8] - 135
// phase[9] - 150
//
assign phase[9:0] = dll[9:0];

//______________________________________________________________________________
//
endmodule

//
// sn74123 - retrigerable monostable multivibrator
//
module am4_pulse
#(parameter
//
// Monovibrator pulse width in clock periods
//
   AM4_PULSE_WIDTH_CLK = 100

)
(
   input  clk,          // input clock
   input  reset_n,      // negative reset
   input  a_n,          // negative start
   input  b,            // positive start
   output q             // output
);
localparam CNT_WIDTH = log2(AM4_PULSE_WIDTH_CLK);
reg   [CNT_WIDTH-1:0] cnt;

reg qout;
reg start;

initial
begin
   qout = 0;
   start = 0;
end

assign q = qout;
always @(posedge clk or negedge reset_n)
begin
   if (~reset_n)
      begin
         cnt <= 0;
         qout <= 1'b0;
         start <= 1'b0;
      end
   else
      begin
         if (~start & ~a_n & b)
            cnt <= AM4_PULSE_WIDTH_CLK;
         else
            if (|cnt)
               cnt <= cnt - 1'b1;
         qout <= |cnt;
         start <= ~a_n & b;
      end
end

function integer log2(input integer value);
   begin
      for (log2=0; value>0; log2=log2+1)
         value = value >> 1;
   end
endfunction
endmodule
