//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Microprogram Sequencer - combination of Am2909 and 29811,
// adopted for M4 project, with configurable micro-address width
//
module am4_seq
#(parameter
   AM4_ADDR_WIDTH = 10
)
(
   input          clk,              // input clock
   input          ena,              // clock enable
                                    //
   input    [3:0] ora,              // address or conditions
   input    [AM4_ADDR_WIDTH-1:0] d, // direct data input
   output   [AM4_ADDR_WIDTH-1:0] y, // data output
                                    //
   input          re_n,             // register input enable
   input          za_n,             // zero address set
                                    //
   input          tst,              // entry for conditional instructions
   input    [3:0] i,                // microcode instruction
   output         ctl_n,            // counter load
   output         cte_n,            // counter enable
   output         me_n              // map enable
);

//______________________________________________________________________________
//
reg  [1:0] sp;                      // stack pointer
reg  [AM4_ADDR_WIDTH-1:0] pc;       // program counter
reg  [AM4_ADDR_WIDTH-1:0] ar;       // address register
reg  [AM4_ADDR_WIDTH-1:0] stk[3:0]; // stack file
wire [AM4_ADDR_WIDTH-1:0] mux;      // multiplexer
                                    //
reg  [6:0] mx;                      //
wire [1:0] s;                       // address mux control
wire fe_n;                          // file enable
wire pup;                           // push/pop_n

//______________________________________________________________________________
//
always @(posedge clk) if (ena)
begin
   //
   // Address register latch
   //
   if (~re_n)
      ar <= d;

   if (~za_n)
      sp <= 2'b11;
   //
   // Stack file operations
   //
   if (~fe_n)
      if (pup)
      begin
         sp <= sp + 2'b01;
         case(sp)
            2'b00: stk[1] <= pc;
            2'b01: stk[2] <= pc;
            2'b10: stk[3] <= pc;
            2'b11: stk[0] <= pc;
         endcase
      end
      else
         sp <= sp - 2'b01;
   //
   // Program counter
   //
   pc <= y + {{(AM4_ADDR_WIDTH-1){1'b0}}, 1'b1};
end

assign mux = ((s == 2'b00) ? pc      : {(AM4_ADDR_WIDTH){1'b0}})
           | ((s == 2'b01) ? ar      : {(AM4_ADDR_WIDTH){1'b0}})
           | ((s == 2'b10) ? stk[sp] : {(AM4_ADDR_WIDTH){1'b0}})
           | ((s == 2'b11) ? d       : {(AM4_ADDR_WIDTH){1'b0}})
           | {{(AM4_ADDR_WIDTH-4){1'b0}}, ora};
assign y = za_n ? mux : {(AM4_ADDR_WIDTH){1'b0}};

//
// Microinstruction decoder
//
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


