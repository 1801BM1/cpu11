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
   input          pin_mce_p,  // master rising edge
   input          pin_mce_n,  // master falling edge
   input  [15:0]  pin_ad,     // address/data bus
   output [15:0]  pin_m,      // microinstruction bus
   input  [15:0]  pin_mc,     // microinstruction latched status
   input  [12:0]  pin_svc,    // service status word
   input          pin_bra,    // microinstruction branch
   input          pin_rst,    // reset
   output         pin_cs      // chip select
);

//______________________________________________________________________________
//
reg  [15:0] mi;         // MIB input register on clock low phase
reg  [15:0] d;          // data word input register
wire [15:0] da;         //
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
wire [15:0] svc;        // service status word
reg         rni;        // read next instruction
wire        jump;       // jump microinstruction
wire        cjmp;       // conditional jump microinstruction
wire        di_stb;     // data input service word strobe
                        //
reg  [2:0]  pri;        // priority
reg         tbit;       // T-bit
reg         wpsw;       //
reg         wpswt;      //
reg         lplm;       //
reg         sovf;       // stack overflow
                        //
wire [7:0]  dc;         // processor opcode decoder
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
wire        set_sof;    // set stack overflow
wire        set_lplm;   //
wire        set_wpsw;   //
wire        clr_lplm;   //

//______________________________________________________________________________
//
// Microinstruction bus (MIB)
//
always @(posedge pin_clk or posedge pin_rst)
begin
   if (pin_rst)
         mi <= 16'h0000;
   else
      if (pin_mce_n)
         mi <= mc;
end
assign pin_m = mi;

//______________________________________________________________________________
//
// Next microinstruction address (NA)
//
assign jump = (mi[15:11] == 5'b00000);
assign cjmp = ~pin_bra & (mi[15:11] == 5'b00001);

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

always @(posedge pin_clk or posedge pin_rst)
begin
   if (pin_rst)
      cs <= 3'b001;
   else
      if (jump & pin_mce_p)
      begin
         cs[0] <= (mi[10:6] == 5'b00000);
         cs[1] <= (mi[10:6] == 5'b00001) && DC303_FPP;
         cs[2] <= (mi[10:6] == 5'b00010) && DC303_FPP;
      end
end
assign pin_cs = (cs[2:0] != 3'b000);

//______________________________________________________________________________
//
always @(posedge pin_clk)
begin
   if (pin_mce_n)
   begin
      if (pri_stb) pri[2:0] <= pin_ad[7:5];
      if (tbit_stb) tbit <= pin_ad[4];
   end
end

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

assign dc[7:0] = {mi[7:4], pin_mc[9], pin_mc[6:4]};
assign pri_stb  = dc_cmp(dc, 4'bxxxx, 4'bx10x);             // transfer prio
assign tbit_stb = dc_cmp(dc, 4'bxxxx, 4'bx1x0);             // transfer tbit
assign tgl_axt  = dc_cmp(dc, 4'bxx0x, 4'bx000);
assign mc_dt    = dc_cmp(dc, 4'bxx10, 4'bx000);             // data to mc
assign na_dt    = dc_cmp(dc, 4'bxxx1, 4'bx000);             // data to na
assign set_sof  = dc_cmp(dc, 4'bxxxx, 4'bx010) & set_soft;  // stack ovf
assign set_lplm = dc_cmp(dc, 4'b000x, 4'b1001) & tbit;
assign clr_lplm = dc_cmp(dc, 4'bxxx1, 4'bx1x0);
assign set_wpsw = dc_cmp(dc, 4'bxx1x, 4'b0100);

always @(posedge pin_clk)
begin
   if (pin_mce_n)
   begin
      if (set_lplm) lplm <= 1'b1;
      if (clr_lplm) lplm <= 1'b0;

      if (set_sof)
         sovf <= 1'b1;
      else
         if (clr_lplm & clr_soft)
            sovf <= 1'b0;
   end
   if (pin_mce_p)
   begin
      if (rni)  set_soft <= 1'b1;
      if (sovf) set_soft <= 1'b0;
      clr_soft <= ~lplm;
   end

   if (pin_mce_n) wpswt <= wpsw;
   if (pin_mce_n & set_wpsw) wpsw <= 1'b1;
   if (pin_rst | pin_mce_p & ~rni & wpswt) wpsw <= 1'b0;

   if (pin_mce_p & (rni | jump))
      axt <= 1'b0;
   else
      if (pin_mce_n & tgl_axt)
         axt <= ~axt;
end

//______________________________________________________________________________
//
// Data input register can be written directly from AD bus on clock high (di_stb),
// or be written with interrupt statuses on clock low (rni))
//
always @(posedge pin_clk or posedge pin_rst)
begin
   if (pin_rst)
      rni <= 1'b1;
   else
      rni <= (ma[8:4] == 5'b00000)
           & ((ma[3:0] == 4'b0000) | cs[2])
           & (cs != 3'b000);
end
assign di_stb = ~pin_mc[13] & ~pin_mc[6] & ~pin_mc[5];

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
assign svc[7:0] = pin_svc[7:0];
assign svc[8]  = pin_svc[8]  & (pri[2:0] < 3'o7);   // IRQ7 masking
assign svc[9]  = pin_svc[9]  & (pri[2:0] < 3'o6);   // IRQ6 masking
assign svc[10] = pin_svc[10] & (pri[2:0] < 3'o5);   // IRQ5 masking
assign svc[11] = pin_svc[11] & (pri[2:0] < 3'o4);   // IRQ4 masking
assign svc[12] = pin_svc[12] & (pri[2:0] < 3'o6);   // EVNT masking
assign svc[13] = sovf;
assign svc[14] = lplm;
assign svc[15] = wpsw;

always @(posedge pin_clk)
begin
   if (pin_mce_n & di_stb) d <= pin_ad;
   if (pin_mce_p & rni) d <= svc;
end

assign da = di_stb ? pin_ad : d;
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

always @(posedge pin_clk or posedge pin_rst)
begin
   if (pin_rst)
   begin
      na_x00 <= 1'b0;
      na_xxx <= 1'b0;
      na_111 <= 1'b0;
      nar <= 9'h000;
   end
   else
      if (pin_mce_n)
      begin
         na_x00 <= (ma[8:3] == 6'b000001) & (ma[1:0] == 2'b00);
         na_xxx <= ma[8:3] == 6'b000001;
         na_111 <= ma[8:0] == 9'b000001111;
         nar <= ma;
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
always @(posedge pin_clk)
begin
   if (pin_mce_p)
   begin
      a_in = {axt, na};
      d_in <= rni ? svc : d;
   end
end

assign ma = (na_dt ? da[8:0] : 9'o777) & ((a_in[8:7] == 2'b00) ? ma_pla : ma_rom);
assign mc = (mc_dt ? da : 16'o177777) & ((a_in[8:7] == 2'b00) ? mc_pla : mc_rom);

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
   .clk(pin_clk),
   .cen(pin_mce_p),
   .a_in({axt, na}),
   .ma(ma_rom0),
   .mc(mc_rom0)
);

defparam rom1.DC303_ROM = 1;
dc_rom rom1
(
   .clk(pin_clk),
   .cen(pin_mce_p),
   .a_in({axt, na}),
   .ma(ma_rom1),
   .mc(mc_rom1)
);

defparam rom2.DC303_ROM = 2;
dc_rom rom2
(
   .clk(pin_clk),
   .cen(pin_mce_p),
   .a_in({axt, na}),
   .ma(ma_rom2),
   .mc(mc_rom2)
);

assign mc_pla = ( cs[0]              ? mc_pla0 : 16'o000000)
              | ((cs[1] & DC303_FPP) ? mc_pla1 : 16'o000000)
              | ((cs[2] & DC303_FPP) ? mc_pla2 : 16'o000000);

assign ma_pla = ( cs[0]              ? ma_pla0 : 9'o000)
              | ((cs[1] & DC303_FPP) ? ma_pla1 : 9'o000)
              | ((cs[2] & DC303_FPP) ? ma_pla2 : 9'o000);

assign mc_rom = ( cs[0]              ? mc_rom0 : 16'o000000)
              | ((cs[1] & DC303_FPP) ? mc_rom1 : 16'o000000)
              | ((cs[2] & DC303_FPP) ? mc_rom2 : 16'o000000);

assign ma_rom = ( cs[0]              ? ma_rom0 : 9'o000)
              | ((cs[1] & DC303_FPP) ? ma_rom1 : 9'o000)
              | ((cs[2] & DC303_FPP) ? ma_rom2 : 9'o000);

//______________________________________________________________________________
//
endmodule
