//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Microinstruction decoder
//
module am29811
(
   input    tst,        // entry for conditional instructions
   input    [3:0] i,    // microcode instruction
                        //
   output   [1:0] s,    // address selector
   output   fe_n,       // file enable
   output   pup,        // push/pop_n
   output   ctl_n,      // counter load
   output   cte_n,      // counter enable
   output   me_n        // map enable
);

reg [6:0] mx;

assign s[1]  = mx[6];    // 00 - pc, 01 - ra
assign s[0]  = mx[5];    // 10 - sp, 11 - di
assign fe_n  = mx[4];    //
assign pup   = mx[3];    // 1/0 - push/pop
assign ctl_n = mx[2];
assign cte_n = mx[1];
assign me_n  = mx[0];

//
// Unconditional commands
//
// 0000:  jz    di, ctl, cte
// 0010:  jmap  di, me
// 1100:  ldct  pc, ctl
// 1110:  cont  pc
// 1111:  jp    di
//
// Conditional commands
//             miss        taken
// 0001:  cjs  pc          di, push
// 0011:  cjp  pc          di
// 0100:  push pc, push    pc, push, ctl
// 0101:  jsrp ra, push    di, push
// 0110:  cjv  pc          di
// 0111:  jrp  ra          di
// 1000:  rfct sp, cte     pc, pop
// 1001:  rpct di, cte     pc
// 1010:  crtn pc          sp, pop
// 1011:  cjpp pc          di, pop
// 1101:  loop sp          pc, pop
//
always @(*)
case(i[3:0])
   4'b0000: mx = 7'b1111001;                       // jz   - jump zero
   4'b0001: mx = ~tst ? 7'b0011111 : 7'b1101111;   // cjs  - cond jsb pl
   4'b0010: mx = 7'b1111110;                       // jmap - jump map
   4'b0011: mx = ~tst ? 7'b0011111 : 7'b1111111;   // cjp  - cond jump pl
   4'b0100: mx = ~tst ? 7'b0001111 : 7'b0001011;   // push - push/cond ld cntr
   4'b0101: mx = ~tst ? 7'b0101111 : 7'b1101111;   // jsrp - cond jsb r/pl
   4'b0110: mx = ~tst ? 7'b0011111 : 7'b1111111;   // cjv  - cond jump vector
   4'b0111: mx = ~tst ? 7'b0111111 : 7'b1111111;   // jrp  - cond jump r/pl
   4'b1000: mx = ~tst ? 7'b1010101 : 7'b0000111;   // rfct - repeat loop, ctr != 0
   4'b1001: mx = ~tst ? 7'b1111101 : 7'b0011111;   // rpct - repeat pl, ctr != 0
   4'b1010: mx = ~tst ? 7'b0010111 : 7'b1000111;   // crtn - cond return
   4'b1011: mx = ~tst ? 7'b0010111 : 7'b1100111;   // cjpp - cond jump pl & pop
   4'b1100: mx = 7'b0011011;                       // ldct - ld cntr & continue
   4'b1101: mx = ~tst ? 7'b1010111 : 7'b0000111;   // loop - test end loop
   4'b1110: mx = 7'b0011111;                       // cont - continue
   4'b1111: mx = 7'b1111111;                       // jp   - jump pl
endcase
endmodule

