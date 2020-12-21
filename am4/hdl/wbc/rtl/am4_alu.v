//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Four-bit Microprocessor Slice
//
module am4_alu
(
   input          clk,        // clock positive
   input          ena,        // clock enable
   input    [8:0] i,          // operation code
   input    [3:0] a,          // port A address (readonly)
   input    [3:0] b,          // port B address (read/write)
   input   [15:0] d,          // direct data input
   output  [15:0] y,          // data output
   output  [15:0] r,          // ram[a] output
                              //
   input          cin,        // carry input
   output         c8,         // carry output, LSB
   output         c16,        // carry output, MSB
   output         v8,         // arithmetic overflow, LSB
   output         v16,        // arithmetic overflow, MSB
   output         zl,         // zero flag, LSB
   output         zh,         // zero flag, MSB
   output         f7,         // msb of LSB
   output         f15,        // msb of MSB
                              //
   input          ram0_i,     // shift register stack lsb LSB
   output         ram0_o,     //
   input          ram7_i,     // shift register stack msb LSB
   output         ram7_o,     //
   input          ram8_i,     // shift register stack lsb MSB
   output         ram8_o,     //
   input          ram15_i,    // shift register stack msb MSB
   output         ram15_o,    //
   input          q0_i,       // shift Q-register lsb LSB
   output         q0_o,       //
   input          q15_i,      // shift Q-register msb MSB
   output         q15_o       //
);

//______________________________________________________________________________
//
reg  [15:0] q_ram[15:0];      // RAM array
wire [15:0] i_ram;            // RAM input mux
                              //
reg  [15:0] q_reg;            // Q register
wire [15:0] q_mux;            // Q register input mux
                              //
wire [15:0] r_alu;            // ALU input mux R
wire [15:0] r_ext;            //
wire [15:0] s_alu;            // ALU input mux S
wire [15:0] s_ext;            //
wire [15:0] f_alu;            // ALU result output
                              //
wire        c6, c7, c14, c15; // carries
wire [16:0] sum;              // sum to get carries

//______________________________________________________________________________
//
// Initialization to eliminate uncertain simulation
//
integer m;

initial
begin
   for (m=0; m<16; m = m + 1)
      q_ram[m] = 4'b0000;
   q_reg = 4'b0000;
end

//______________________________________________________________________________
//
// RAM registers and RAM input mux
//
assign i_ram = (i[8:7] == 2'b00) ? 16'h0000 :                     // QREG, NOP
               (i[8:7] == 2'b01) ? f_alu :                        // RAMA, RAMF - load
               (i[8:7] == 2'b10) ? {ram15_i, f_alu[15:9],         //
                                    ram7_i, f_alu[7:1]} :         // RAMQD, RAMD - shift down/right
               (i[8:7] == 2'b11) ? {f_alu[14:8], ram8_i,          //
                                    f_alu[6:0], ram0_i} :         // RAMQU, RAMU - shift up/left
                                    16'h0000;                     // default

always @(posedge clk) if ((i[8:7] != 2'b00) & ena) q_ram[b] <= i_ram;

assign ram0_o  = f_alu[0];
assign ram7_o  = f_alu[7];
assign ram8_o  = f_alu[8];
assign ram15_o = f_alu[15];

//______________________________________________________________________________
//
// Q-register input mux and latches
//
assign q_mux = (i[8:6] == 3'b000) ? f_alu :                       // QREG
               (i[8:6] == 3'b100) ? {q15_i, q_reg[15:1]} :        // RAMQD - shift down/right
               (i[8:6] == 3'b110) ? {q_reg[14:0], q0_i} : q_reg;  // RAMQU - shift up/left

assign q0_o  = q_reg[0];
assign q15_o = q_reg[15];

always @(posedge clk) if (ena) q_reg <= q_mux;

//______________________________________________________________________________
//
// Y-output mux and RAMA output
//
assign y = (i[8:6] == 3'b010) ? q_ram[a] : f_alu;
assign r = q_ram[a];

//______________________________________________________________________________
//
// ALU input muxes
//
assign r_alu = (i[2:0] == 3'b000) ? q_ram[a] :              // AQ
               (i[2:0] == 3'b001) ? q_ram[a] :              // AB
               (i[2:0] == 3'b010) ? 16'h0000 :              // ZQ
               (i[2:0] == 3'b011) ? 16'h0000 :              // ZB
               (i[2:0] == 3'b100) ? 16'h0000 : d;           // ZA, DA, DQ, DZ

assign s_alu = (i[2:0] == 3'b000) ? q_reg :                 // AQ
               (i[2:0] == 3'b001) ? q_ram[b] :              // AB
               (i[2:0] == 3'b010) ? q_reg :                 // ZQ
               (i[2:0] == 3'b011) ? q_ram[b] :              // ZB
               (i[2:0] == 3'b100) ? q_ram[a] :              // ZA
               (i[2:0] == 3'b101) ? q_ram[a] :              // DA
               (i[2:0] == 3'b110) ? q_reg : 16'h0000;       // DQ, DZ

assign r_ext = ( (i[5:3] == 3'b001)
               | (i[5:3] == 3'b101)
               | (i[5:3] == 3'b110)) ? ~r_alu : r_alu;

assign s_ext = (i[5:3] == 3'b010) ? ~s_alu : s_alu;
assign sum = {1'b0, r_ext} + {1'b0, s_ext} + {16'h0000, cin};

//
// Carry from alu_f[n]->alu_f[n+1]
//
assign c6  = s_ext[7] ^ r_ext[7] ^ sum[7];         // f_alu[6]->f_alu[7]
assign c7  = s_ext[8] ^ r_ext[8] ^ sum[8];         // f_alu[7]->f_alu[8]
assign c14 = s_ext[15] ^ r_ext[15] ^ sum[15];      // f_alu[14]->f_alu[15]
assign c15 = sum[16];
//
// ALU result
//
assign f_alu = (i[5:3] == 3'b000) ? sum[15:0] :                // ADD
               (i[5:3] == 3'b001) ? sum[15:0] :                // SUBR
               (i[5:3] == 3'b010) ? sum[15:0] :                // SUBS
               (i[5:3] == 3'b011) ? r_ext | s_ext :            // OR
               (i[5:3] == 3'b100) ? r_ext & s_ext :            // AND
               (i[5:3] == 3'b101) ? r_ext & s_ext :            // NOTRS
               (i[5:3] == 3'b110) ? ~r_ext ^ s_ext :           // EXOR
               (i[5:3] == 3'b111) ? ~r_ext ^ s_ext : 16'h0000; // EXNOR

//
// The carry and overflow flags over logical instructions
// are not used by microcode, we can simplify
//
assign c8   = (i[5:3] == 3'b000) ? c7 :                        // ADD
              (i[5:3] == 3'b001) ? c7 :                        // SUBR
              (i[5:3] == 3'b010) ? c7 : cin;                   // SUBS

assign c16  = (i[5:3] == 3'b000) ? c15 :                       // ADD
              (i[5:3] == 3'b001) ? c15 :                       // SUBR
              (i[5:3] == 3'b010) ? c15 : cin;                  // SUBS

assign v8   = (i[5:3] == 3'b000) ? c6 ^ c7 :                   // ADD
              (i[5:3] == 3'b001) ? c6 ^ c7 :                   // SUBR
              (i[5:3] == 3'b010) ? c6 ^ c7 : 1'b0;             // SUBS

assign v16  = (i[5:3] == 3'b000) ? c14 ^ c15 :                 // ADD
              (i[5:3] == 3'b001) ? c14 ^ c15 :                 // SUBR
              (i[5:3] == 3'b010) ? c14 ^ c15 : 1'b0;           // SUBS

assign f7  = f_alu[7];
assign f15 = f_alu[15];
assign zl  = ~|f_alu[7:0];
assign zh  = ~|f_alu[15:8];
//______________________________________________________________________________
//
endmodule
