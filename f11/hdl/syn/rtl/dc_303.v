//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// DC303 Control Chip model, for debug and simulating only
//
//  - DC303_CS = 0, 23-001C7-AA, rni = ma[8:0] == 9'x000
//  - DC303_CS = 1, 23-002C7-AA, rni = ma[8:0] == 9'x000
//  - DC303_CS = 2, 23-203C7-AA, rni = ma[8:4] == 5'x00
//______________________________________________________________________________
//
`timescale 1ns / 100ps

module dc303
#(parameter DC303_FPP = 1)
(
   input          pin_clk,    // main clock
   input [15:0]   pin_ad,     // address/data bus
   inout [15:0]   pin_m,      // microinstruction bus
   input          pin_rst,    // reset
   output         pin_cs_n    // chip select
);

//______________________________________________________________________________
//
wire        clk;        // primary clock
wire        rst;        // synchronized reset
                        //
wire        moe;        // MIB output enable
reg  [15:0] mi;         // MIB input register on clock low phase
reg  [15:0] d;          // data word input register
reg  [15:0] da;         // data word input for next address workaround
reg  [2:0]  cs;         // chip select
                        //
reg         axt;        // address extension bit
reg  [8:0]  nar;        // next address register
wire [8:0]  na;         // next address mux value
wire [3:0]  clr_na;     // special address na clear
                        //
wire [8:0]  ma;         // address read from ROM matrix
wire [15:0] mc;         // microcode read from ROM matrix
reg  [9:0]  a_in;       // address inputs for ROM/PLA
reg  [15:0] d_in;       // data inputs for ROM/PLA
                        //
wire [8:0]  ma_pla;     // address from PLA
wire [8:0]  ma_pla0;    //
wire [8:0]  ma_pla1;    //
wire [8:0]  ma_pla2;    //
                        //
wire [8:0]  ma_rom;     // address from ROM
wire [8:0]  ma_rom0;    //
wire [8:0]  ma_rom1;    //
wire [8:0]  ma_rom2;    //
                        //
wire [15:0] mc_pla;     // microcode from PLA
wire [15:0] mc_pla0;    //
wire [15:0] mc_pla1;    //
wire [15:0] mc_pla2;    //
                        //
wire [15:0] mc_rom;     // microcode from ROM
wire [15:0] mc_rom0;    //
wire [15:0] mc_rom1;    //
wire [15:0] mc_rom2;    //
                        //
reg         axtt;       //
reg         rnit;       //
wire        rni;        // read next instruction
wire        jump;       // jump microinstruction
wire        cjmp;       // conditional jump microinstruction
wire        di_stb;     // data input service word strobe
                        //
reg  [3:0]  pri_in;     // priority input latch
reg  [2:0]  pri;        // priority
reg         tbit;       // T-bit
reg         wpsw;       //
reg         lplm;       //
reg         sovf;       // stack overflow
                        //
reg  [7:0]  dc;         // processor opcode decoder
wire [4:0]  dcop;       // decoded opcodes
reg         na_x00;     // na == 9'b000001x00
reg         na_xxx;     // na == 9'b000001xxx
reg         na_111;     // na == 9'b000001111
                        //
wire        pri_stb;    // priority register strobe
wire        tbit_stb;   // T-bit strobe
wire        tgl_axt;    // toggle address extension
wire        mc_dt;      // replace microcode with data
wire        na_dt;      // replace next address with data
                        //
reg         set_soft;   //
reg         clr_soft;   //
reg         set_wpswt;  //
wire        set_sof;    // set stack overflow
wire        set_nusd;   // set unknown not used (in chip 0) flag
wire        set_lplm;   //
wire        set_wpsw;   //
wire        clr_lplm;   //

//______________________________________________________________________________
//
// Clocks and Reset
//
assign clk = pin_clk;
assign rst = pin_rst;
assign pin_cs_n = ~(cs[2:0] != 3'b000);

wire #1 sim_dclk  = clk; // suppress simulation glitches

//______________________________________________________________________________
//
// Microinstruction bus (MIB)
//
assign moe = ~clk & (cs != 3'b000);
assign pin_m = moe ? mc : 16'hzzzz;

always @(*) if (~clk) mi <= pin_m;
//______________________________________________________________________________
//
// Next microinstruction address (NA)
//
always @(*) if (~clk) nar <= ma;
assign jump = clk & (mi[15:11] == 5'b00000);
assign cjmp = clk & ~pin_m[11] & (mi[15:11] == 5'b00001);

//
// na[3:0] - reset at dedicated addresses
// na[7:0] - overriden by conditional jump
// na[5:0] - overriden by unconditional jump
// na[8:6] - cleared by unconditional jump
//
assign na[0] = (jump | cjmp) ? mi[0] : (nar[0] & ~clr_na[0]);
assign na[1] = (jump | cjmp) ? mi[1] : (nar[1] & ~clr_na[1]);
assign na[2] = (jump | cjmp) ? mi[2] : (nar[2] & ~clr_na[2]);
assign na[3] = (jump | cjmp) ? mi[3] : (nar[3] & ~clr_na[3]);
assign na[4] = (jump | cjmp) ? mi[4] : nar[4];
assign na[5] = (jump | cjmp) ? mi[5] : nar[5];
assign na[6] = cjmp ? mi[6] : (nar[6] & ~jump);
assign na[7] = cjmp ? mi[7] : (nar[7] & ~jump);
assign na[8] = nar[8] & ~jump;

//______________________________________________________________________________
//
always @(*) if (clk) pri_in[3:0] <= pin_ad[7:4];
always @(*) if (pri_stb) pri[2:0] <= pri_in[3:1];
always @(*) if (tbit_stb) tbit <= pri_in[0];
always @(*) if (clk) dc[7:0] <= {mi[7:4], pin_m[9], pin_m[6:4]};

function dc_cmp
(
   input [7:0] dc,
   input [3:0] mo,
   input [3:0] ms
);
begin
   casex(dc)
      {mo, ms}: dc_cmp = 1'b1;
      default:  dc_cmp = 1'b0;
   endcase
end
endfunction

assign pri_stb  = ~clk & dc_cmp(dc, 4'bxxxx, 4'bx10x);            // transfer prio
assign tbit_stb = ~clk & dc_cmp(dc, 4'bxxxx, 4'bx1x0);            // transfer tbit
assign tgl_axt  = ~clk & dc_cmp(dc, 4'bxx0x, 4'bx000);
assign mc_dt    = ~clk & dc_cmp(dc, 4'bxx10, 4'bx000);            // data to mc
assign na_dt    = ~clk & dc_cmp(dc, 4'bxxx1, 4'bx000);            // data to na
assign set_sof  = ~clk & dc_cmp(dc, 4'bxxxx, 4'bx010) & set_soft; // stack ovf
assign set_nusd = ~clk & dc_cmp(dc, 4'bx1xx, 4'b0100);
assign set_lplm = ~clk & dc_cmp(dc, 4'b000x, 4'b1001) & tbit;
assign set_wpsw = ~clk & dc_cmp(dc, 4'bxx1x, 4'b0100);
assign clr_lplm = ~clk & dc_cmp(dc, 4'bxxx1, 4'bx1x0);

always @(*)
begin
   if (rni)  set_soft <= 1'b1;
   if (sovf) set_soft <= 1'b0;
   if (clk)  clr_soft <= ~lplm;
   if (clk) set_wpswt <= wpsw;

   if (rst)
      cs <= 3'b001;
   else
      if (jump)
      begin
         cs[0] <= (mi[10:6] == 5'b00000);
         cs[1] <= (mi[10:6] == 5'b00001) & DC303_FPP;
         cs[2] <= (mi[10:6] == 5'b00010) & DC303_FPP;
      end

   if (set_lplm)
      lplm <= 1'b1;
   else
      if (clr_lplm)
         lplm <= 1'b0;

   if (set_sof)
      sovf <= 1'b1;
   else
      if (clr_lplm & clr_soft)
         sovf <= 1'b0;

   if (set_wpsw | set_wpswt & rni)
      wpsw <= 1'b1;
   else
      if (~clk)
         wpsw <= 1'b0;

   if (~clk) rnit <= rni;
   if (clk) axtt <= axt;

   if ((cs == 3'b000) | jump | rnit)
      axt <= 1'b0;
   else
      if (~clk & tgl_axt)
         axt <= ~axtt;
end

//______________________________________________________________________________
//
// Data input register can be written directly from AD bus on clock high (di_stb),
// or be written with interrupt statuses on clock low (rni))
//
assign rni = ~clk & (rst | (ma[8:4] == 5'b00000)
                         & ((ma[3:0] == 4'b0000) | cs[2])
                         & (cs != 3'b000));
assign di_stb = clk & ~pin_m[13] & ~pin_m[6] & ~pin_m[5] & sim_dclk;

//
// Internal requests, provided by internal logic
//
// DAL15    - stack overflow
// DAL14    - lplm
// DAL13    - wpsw
//
// External service word, provided by CPU board
//
// DAL12    - timer event request, high level
// DAL11    - IRQ[4], high level
// DAL10    - IRQ[5], high level
// DAL9     - IRQ[6], high level
// DAL8     - IRQ[7], high level
// DAL7     - ACLO (power down), low level
// DAL6     - ground (always asserted)
// DAL5     - HALT request, high level
// DAL4     - Control Chip Error, low level
// DAL3     - MMU requests abort, low level
// DAL2     - parity error, low level
// DAL1     - bus timeout, high level
// DAL0     - DCLO, low level means OK
//
always @(*)
begin
   if (di_stb | rni)
   begin
      d[7:0] <= pin_ad[7:0];
      d[8]  <= pin_ad[8]  & (clk | (pri[2:0] < 3'o7));   // IRQ7 masking
      d[9]  <= pin_ad[9]  & (clk | (pri[2:0] < 3'o6));   // IRQ6 masking
      d[10] <= pin_ad[10] & (clk | (pri[2:0] < 3'o5));   // IRQ5 masking
      d[11] <= pin_ad[11] & (clk | (pri[2:0] < 3'o4));   // IRQ4 masking
      d[12] <= pin_ad[12] & (clk | (pri[2:0] < 3'o6));   // EVNT masking
   end
   if (di_stb)
   begin
      d[13] <= pin_ad[13];
      d[14] <= pin_ad[14];
      d[15] <= pin_ad[15];
   end
   if (rni)
   begin
      d[13] <= sovf;
      d[14] <= lplm;
      d[15] <= wpsw;
   end
   if (di_stb)
      da <= pin_ad;
end

//______________________________________________________________________________
//
// PDP-11 opcode decoder for special microcode addresses
//
function op_cmp
(
   input [9:0] d,
   input [9:0] m
);
begin
   casex(d)
      m:       op_cmp = 1'b1;
      default: op_cmp = 1'b0;
   endcase
end
endfunction

//______________________________________________________________________________
//
// The results of reading Next Address matrix from physical chip (cs=00)
// and following ESPRESSO AB minimization
//
// na  d[15:0]                dcop  na_xxx
//
// 111 0000-00001------ 1000  1     111   na_clr[3]
// 111 0000100--------- 1000  1     111
//
// --- -1-0000---000--- 0100  4,2   xxx   na_clr[2]
// --- --01000---000--- 0100  4,2   xxx
// --- -01-000---000--- 0100  4,2   xxx
// -11 1000110-0-000--- 0100  4,0   111
// -11 -0001100--000--- 0100  4,0   111
// -11 -000110--1000--- 0100  4,0   111
// -11 -000101---000--- 0100  4,0   111
// -11 01110-----000--- 0100  4,0   111
// -11 0111-00---000--- 0100  4,0   111
// -11 0---000011000--- 0100  4,0   111
// -00 ----------000--- 0100  4     x00
//
// --- -1-0000--------- 0010  3,2   xxx   na_clr[1]
// --- --01000--------- 0010  3,2   xxx
// --- -01-000--------- 0010  3,2   xxx
// 1-1 1000110-0------- 0010  0     111
// 1-1 -0001100-------- 0010  0     111
// 1-1 -000110--1------ 0010  0     111
// 1-1 -000101--------- 0010  0     111
// 1-1 01110----------- 0010  0     111
// 1-1 0111-00--------- 0010  0     111
// 1-1 0---000011------ 0010  0     111
//
// --- -1-0------------ 0001  3     xxx   na_clr[0]
// --- --01------------ 0001  3     xxx
// --- -01------------- 0001  3     xxx
//
assign dcop[0] = op_cmp(d[15:6], 10'b1000110100)   // mtps
               | op_cmp(d[15:6], 10'bx0001100xx)   // single operand x06xxx
               | op_cmp(d[15:6], 10'bx0001101x1)   //
               | op_cmp(d[15:6], 10'bx000101xxx)   // single operand x05xxx
               | op_cmp(d[15:6], 10'b01110xxxxx)   // eis
               | op_cmp(d[15:6], 10'b0111100xxx)   // xor
               | op_cmp(d[15:6], 10'b0000000011);  // swab
                                                   //
assign dcop[1] = op_cmp(d[15:6], 10'b0000000001)   // jmp
               | op_cmp(d[15:6], 10'b0000100xxx);  // br
                                                   //
assign dcop[2] = d[11:9] == 3'b000;                // source register mode
assign dcop[4] = d[5:3] == 3'b000;                 // destination register mode
                                                   //
assign dcop[3] = op_cmp(d[15:6], 10'bxx01xxxxxx)   // not x0xxxx and not x7xxxx
               | op_cmp(d[15:6], 10'bx01xxxxxxx)   // normal opcode
               | op_cmp(d[15:6], 10'bx1x0xxxxxx);  //

always @(*)
begin
   if (~clk)
   begin
      na_x00 <= (ma[8:3] == 6'b000001) & (ma[1:0] == 2'b00);
      na_xxx <= ma[8:3] == 6'b000001;
      na_111 <= ma[8:0] == 9'b000001111;
   end
end

assign clr_na[0] = na_xxx & dcop[3];
assign clr_na[1] = na_xxx & dcop[3] & dcop[2]
                 | na_111 & dcop[0];
assign clr_na[2] = na_xxx & dcop[4] & dcop[2] & dcop[3]
                 | na_111 & dcop[4] & dcop[0]
                 | na_x00 & dcop[4];
assign clr_na[3] = na_111 & dcop[1];

//______________________________________________________________________________
//
always @(*)
begin
   if (clk) a_in = {axt, na};
   if (clk) d_in = d;
end

assign ma = rst ? 9'o000 :
            ((na_dt ? da[8:0] : 9'o777) & ((a_in[8:7] == 2'b00) ? ma_pla : ma_rom));

assign mc = rst ? 16'o000000 :
            ((mc_dt ? da : 16'o177777) & ((a_in[8:7] == 2'b00) ? mc_pla : mc_rom));


defparam pla0.DC303_PLA = 0;
dc_pla pla0
(
   .a_in(a_in[6:0]),
   .d_in(d_in),
   .ma(ma_pla0),
   .mc(mc_pla0)
);

defparam pla1.DC303_PLA = 1;
dc_pla pla1
(
   .a_in(a_in[6:0]),
   .d_in(d_in),
   .ma(ma_pla1),
   .mc(mc_pla1)
);

defparam pla2.DC303_PLA = 2;
dc_pla pla2
(
   .a_in(a_in[6:0]),
   .d_in(d_in),
   .ma(ma_pla2),
   .mc(mc_pla2)
);

defparam rom0.DC303_ROM = 0;
dc_rom rom0
(
   .a_in(a_in),
   .ma(ma_rom0),
   .mc(mc_rom0)
);

defparam rom1.DC303_ROM = 1;
dc_rom rom1
(
   .a_in(a_in),
   .ma(ma_rom1),
   .mc(mc_rom1)
);

defparam rom2.DC303_ROM = 2;
dc_rom rom2
(
   .a_in(a_in),
   .ma(ma_rom2),
   .mc(mc_rom2)
);

assign mc_pla = (cs[0] ? mc_pla0 : 16'o000000)
              | (cs[1] ? mc_pla1 : 16'o000000)
              | (cs[2] ? mc_pla2 : 16'o000000);

assign ma_pla = (cs[0] ? ma_pla0 : 9'o000)
              | (cs[1] ? ma_pla1 : 9'o000)
              | (cs[2] ? ma_pla2 : 9'o000);

assign mc_rom = (cs[0] ? mc_rom0 : 16'o000000)
              | (cs[1] ? mc_rom1 : 16'o000000)
              | (cs[2] ? mc_rom2 : 16'o000000);

assign ma_rom = (cs[0] ? ma_rom0 : 9'o000)
              | (cs[1] ? ma_rom1 : 9'o000)
              | (cs[2] ? ma_rom2 : 9'o000);

//______________________________________________________________________________
//
endmodule
