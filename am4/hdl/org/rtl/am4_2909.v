//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Microprogram Sequencer
//
module am2909
(
   input          cp,         // input clock
                              //
   input          cin,        // carry input
   input    [3:0] ora,        // address or conditions
   input    [3:0] r,          // register input
   input    [3:0] d,          // direct data input
   output   [3:0] y,          // data output (3-state)
   output         cout,       // carry output
                              //
   input    [1:0] s,          // opcode
   input          fe_n,       // file enable
   input          pup,        // push/pop select
   input          oe_n,       // Y output enable
   input          re_n,       // register input enable
   input          za_n        // zero address set
);

//______________________________________________________________________________
//
reg  [3:0] pc;                // program counter
reg  [3:0] ar;                // address register
reg  [3:0] stk[3:0];          // stack file
reg  [1:0] sp;                // stack pointer
wire [3:0] out;               // address output
wire [3:0] mux;               // multiplexer

//______________________________________________________________________________
//
always @(posedge cp)
begin
   //
   // Address register latch
   //
   if (~re_n)
      ar <= r;

   if (~za_n)
      sp <= 2'b11;
   //
   // Stack file operations
   //
   if (~fe_n)
      if (pup)
         case(sp)
         2'b00:
            begin
               sp <= 2'b01;
               stk[1] <= pc;
            end
         2'b01:
            begin
               sp <= 2'b10;
               stk[2] <= pc;
            end
         2'b10:
            begin
               sp <= 2'b11;
               stk[3] <= pc;
            end
         2'b11:
            begin
               sp <= 2'b00;
               stk[0] <= pc;
            end
         endcase
      else
         case(sp)
            2'b00: sp <= 2'b11;
            2'b01: sp <= 2'b00;
            2'b10: sp <= 2'b01;
            2'b11: sp <= 2'b10;
         endcase

   //
   // Program counter
   //
   pc <= out + {3'b000, cin};
end

assign y = oe_n ? 4'bzzzz : out;
assign mux = ((s == 2'b00) ? pc      : 4'b0000)
           | ((s == 2'b01) ? ar      : 4'b0000)
           | ((s == 2'b10) ? stk[sp] : 4'b0000)
           | ((s == 2'b11) ? d       : 4'b0000)
           | ora;
assign out = za_n ? mux : 4'b0000;
assign cout = (out == 4'b1111) & cin;

//______________________________________________________________________________
//
endmodule
