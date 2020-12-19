//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Four-bit Microprocessor Slice
//
`timescale 1ns / 100ps

module am2901
(
   input          cp,         // clock positive
   input    [8:0] i,          // operation code
   input    [3:0] a,          // port A address (readonly)
   input    [3:0] b,          // port B address (read/write)
   input    [3:0] d,          // direct data input
   output   [3:0] y,          // data output (3-state)
                              //
   input          oe_n,       // Y output enable
   inout          q0,         // shift line Q-register LSB
   inout          q3,         // shift line Q-register MSB
   inout          ram0,       // shift line register stack LSB
   inout          ram3,       // shift line register stack MSB
   input          cin,        // carry input
                              //
   output         cout,       // carry output
   output         ovr,        // arithmetic overflow
   output         f3,         // MSB of ALU output
   output         zf,         // (F[3:0] == 0) flag output (OC)
   output         g_n,        // carry generate output
   output         p_n         // carry propagate output
);

//______________________________________________________________________________
//
reg  [3:0]  q_ram[15:0];      // RAM array
wire [3:0]  i_ram;            // RAM input mux
                              //
reg  [3:0]  q_reg;            // Q register
wire [3:0]  q_mux;            // Q register input mux
                              //
wire [3:0]  r_alu;            // ALU input mux R
wire [3:0]  r_ext;            //
wire [3:0]  s_alu;            // ALU input mux S
wire [3:0]  s_ext;            //
wire [3:0]  f_alu;            // ALU result output
                              //
wire        c3, c4;           // carries
wire [3:0]  g_alu;            // ALU carry generate
wire [3:0]  p_alu;            // ALU carry propagate

//______________________________________________________________________________
//
// Initialization to eliminate uncertain simulation
//
integer m;

initial
begin
   for (m=0; m<16; m = m + 1)
      q_ram[m] = 4'b0000;
#1 q_reg = 4'b0000;
end

//______________________________________________________________________________
//
// RAM registers and RAM input mux
//
assign i_ram = (i[8:7] == 2'b00) ? 4'b0000 :                      // QREG, NOP
               (i[8:7] == 2'b01) ? f_alu[3:0] :                   // RAMA, RAMF - load
               (i[8:7] == 2'b10) ? {ram3, f_alu[3:1]} :           // RAMQD, RAMD - shift down/right
               (i[8:7] == 2'b11) ? {f_alu[2:0], ram0} : 4'b0000;  // RAMQU, RAMU - shift up/left

always @(posedge cp) if (i[8:7] != 2'b00) q_ram[b] <= i_ram;

assign ram0 = (i[8:7] == 2'b10) ? f_alu[0] : 1'bz;
assign ram3 = (i[8:7] == 2'b11) ? f_alu[3] : 1'bz;

//______________________________________________________________________________
//
// Q-register input mux and latches
//
assign q_mux = (i[8:6] == 3'b000) ? f_alu[3:0] :                     // QREG
               (i[8:6] == 3'b100) ? {q3, q_reg[3:1]} :               // RAMQD - shift down/right
               (i[8:6] == 3'b110) ? {q_reg[2:0], q0} : q_reg[3:0];   // RAMQU - shift up/left

assign q0 = (i[8:7] == 2'b10) ? q_reg[0] : 1'bz;
assign q3 = (i[8:7] == 2'b11) ? q_reg[3] : 1'bz;

always @(posedge cp) q_reg <= q_mux;

//______________________________________________________________________________
//
// Y-output mux and enable logic
//
assign y = (oe_n) ? 4'bzzzz : (i[8:6] == 3'b010) ? q_ram[a] : f_alu[3:0];

//______________________________________________________________________________
//
// ALU input muxes
//
assign r_alu = (i[2:0] == 3'b000) ? q_ram[a] :              // AQ
               (i[2:0] == 3'b001) ? q_ram[a] :              // AB
               (i[2:0] == 3'b010) ? 4'b0000 :               // ZQ
               (i[2:0] == 3'b011) ? 4'b0000 :               // ZB
               (i[2:0] == 3'b100) ? 4'b0000 : d;            // ZA, DA, DQ, DZ

assign s_alu = (i[2:0] == 3'b000) ? q_reg :                 // AQ
               (i[2:0] == 3'b001) ? q_ram[b] :              // AB
               (i[2:0] == 3'b010) ? q_reg :                 // ZQ
               (i[2:0] == 3'b011) ? q_ram[b] :              // ZB
               (i[2:0] == 3'b100) ? q_ram[a] :              // ZA
               (i[2:0] == 3'b101) ? q_ram[a] :              // DA
               (i[2:0] == 3'b110) ? q_reg : 4'b0000;        // DQ, DZ

assign r_ext = ( (i[5:3] == 3'b001)
               | (i[5:3] == 3'b101)
               | (i[5:3] == 3'b110)) ? ~r_alu : r_alu;

assign s_ext = (i[5:3] == 3'b010) ? ~s_alu : s_alu;

assign p_alu = r_ext | s_ext;
assign g_alu = r_ext & s_ext;
//
// Carry from f_alu[2]->f_alu[3]
//
assign c3 = g_alu[2]
          | g_alu[1] & p_alu[2]
          | g_alu[0] & p_alu[2] & p_alu[1]
          | cin      & p_alu[2] & p_alu[1] & p_alu[0];
//
// Carry from f_alu[3]->f_alu[4]
//
assign c4 = g_alu[3]
          | g_alu[2] & p_alu[3]
          | g_alu[1] & p_alu[3] & p_alu[2]
          | g_alu[0] & p_alu[3] & p_alu[2] & p_alu[1]
          | cin      & p_alu[3] & p_alu[2] & p_alu[1] & p_alu[0];
//
// ALU result
//
assign f_alu = (i[5:3] == 3'b000) ? r_ext + s_ext + cin :      // ADD
               (i[5:3] == 3'b001) ? r_ext + s_ext + cin :      // SUBR
               (i[5:3] == 3'b010) ? r_ext + s_ext + cin :      // SUBS
               (i[5:3] == 3'b011) ? r_ext | s_ext :            // OR
               (i[5:3] == 3'b100) ? r_ext & s_ext :            // AND
               (i[5:3] == 3'b101) ? r_ext & s_ext :            // NOTRS
               (i[5:3] == 3'b110) ? ~r_ext ^ s_ext :           // EXOR
               (i[5:3] == 3'b111) ? ~r_ext ^ s_ext : 4'b0000;  // EXNOR

assign cout  = (i[5:3] == 3'b000) ? c4 :                       // ADD
               (i[5:3] == 3'b001) ? c4 :                       // SUBR
               (i[5:3] == 3'b010) ? c4 :                       // SUBS
               (i[5:3] == 3'b011) ? ~&p_alu | cin :            // OR
               (i[5:3] == 3'b100) ?  |g_alu | cin :            // AND
               (i[5:3] == 3'b101) ?  |g_alu | cin :            // NOTRS
                  ~( g_alu[3]                                  // EXOR
                  |  g_alu[2] & p_alu[3]                       // EXNOR
                  |  g_alu[1] & p_alu[3] & p_alu[2]
                  | (g_alu[0] | ~cin) & &p_alu);

assign ovr   = (i[5:3] == 3'b000) ? c3 ^ c4 :                  // ADD
               (i[5:3] == 3'b001) ? c3 ^ c4 :                  // SUBR
               (i[5:3] == 3'b010) ? c3 ^ c4 :                  // SUBS
               (i[5:3] == 3'b011) ? ~&p_alu | cin :            // OR
               (i[5:3] == 3'b100) ?  |g_alu | cin :            // AND
               (i[5:3] == 3'b101) ?  |g_alu | cin :            // NOTRS
                  ( ~p_alu[2]                                  // EXOR
                  | ~p_alu[1] & ~g_alu[2]                      // EXNOR
                  | ~p_alu[0] & ~g_alu[2] & ~g_alu[1]
                  | cin & ~g_alu[2] & ~g_alu[1] & ~g_alu[0]) ^
                  ( ~p_alu[3]
                  | ~p_alu[2] & ~g_alu[3]
                  | ~p_alu[1] & ~g_alu[3] & ~g_alu[2]
                  | ~p_alu[0] & ~g_alu[3] & ~g_alu[2] & ~g_alu[1]
                  | cin & ~g_alu[3] & ~g_alu[2] & ~g_alu[1] & ~g_alu[0]);

assign p_n   = (i[5:3] == 3'b000) ? ~&p_alu :                  // ADD
               (i[5:3] == 3'b001) ? ~&p_alu :                  // SUBR
               (i[5:3] == 3'b010) ? ~&p_alu :                  // SUBS
               (i[5:3] == 3'b011) ? 1'b0 :                     // OR
               (i[5:3] == 3'b100) ? 1'b0 :                     // AND
               (i[5:3] == 3'b101) ? 1'b0 :                     // NOTRS
               (i[5:3] == 3'b110) ? |g_alu :                   // EXOR
               (i[5:3] == 3'b111) ? |g_alu : 1'b0;             // EXNOR

assign g_n   = (i[5:3] == 3'b000 |                             // ADD
                i[5:3] == 3'b001 |                             // SUBR
                i[5:3] == 3'b010) ? ~( g_alu[3]                // SUBS
                                     | g_alu[2] & p_alu[3]
                                     | g_alu[1] & p_alu[3] & p_alu[2]
                                     | g_alu[0] & p_alu[3] & p_alu[2] & p_alu[1]) :
               (i[5:3] == 3'b011) ? &p_alu :                   // OR
               (i[5:3] == 3'b100) ? ~|g_alu :                  // AND
               (i[5:3] == 3'b101) ? ~|g_alu :                  // NOTRS
                  ( g_alu[3]                                   // EXOR
                  | g_alu[2] & p_alu[3]                        // EXNOR
                  | g_alu[1] & p_alu[3] & p_alu[2]
                  | p_alu[0] & p_alu[3] & p_alu[2] & p_alu[1]);

assign f3 = f_alu[3];
assign zf = ~|f_alu[3:0];
//______________________________________________________________________________
//
endmodule
