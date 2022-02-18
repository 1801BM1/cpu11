//______________________________________________________________________________
//
// sn74123 - retrigerable monostable multivibrator
//
module dc_pulse
#(parameter
//
// Monovibrator pulse width in clock periods
//
   DC_PULSE_WIDTH_CLK = 100

)
(
   input  clk,          // input clock
   input  reset_n,      // negative reset
   input  a_n,          // negative start
   input  b,            // positive start
   output q             // output
);
localparam CNT_WIDTH = log2(DC_PULSE_WIDTH_CLK);
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
            cnt <= DC_PULSE_WIDTH_CLK;
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
