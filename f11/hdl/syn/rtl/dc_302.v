//
// Copyright (c) 2014-2021 by 1801BM1@gmail.com
//
// DC302 Data Chip model, for debug and simulating only
//______________________________________________________________________________
//
`timescale 1ns / 100ps

module dc302
(
   input          pin_clk,    // main clock
   inout  [15:0]  pin_ad,     // address/data bus
   output         pin_bso,    // bus select output
   input          pin_bsi,    // bus select input
   input  [15:0]  pin_m,      // microinstruction opcode
   output [14:0]  pin_mo,     // microinstruction early status
   input  [15:0]  pin_mc,     // microinstruction latched status
   output         pin_ad_en   // Quartus workaround
);

//______________________________________________________________________________
//
wire        clk;              // primary clock
                              //
wire        doe, doesc;       // data bus output enable
wire [15:0] d;                // internal data bus
reg  [15:0] dc;               // registered D-mux data
reg  [15:0] di;               // registered input data
wire [15:0] dx;               // data swap and mux
wire [15:0] fx;               // function mux
wire        fx_en, fx_en0;    //
wire        fx_en1, fx_en2;   //
reg  [3:0]  fx_ren;           //
                              //
wire        db_oel, db_oeh;   //
reg  [15:0] bdc;              // binary-decimal correction
wire        bdc_en;           //
wire        pa_en;            //
wire        astb, badr, bsyn; //
reg         bsyn_in, badr_in; //
reg         bcyc;             // in bus cycle
reg         rinit;            // INIT latch
wire        rinit_rc;         //
reg         wtbt, wbyte;      //
reg         d0c;              //
reg         io_a0, io_a0c;    //
reg         io_psw, io_pswc;  //
reg         psw_wb;           // PSW write byte
                              //
reg  [15:0] m;                // microinstruction register
reg  [15:0] ir;               // PDP instruction register
reg         ir_stb;           // instruction register strobe
wire        ir_stb_rc;        //
                              //
reg  [15:0] b;                // ALU input port B
reg  [15:0] ac;               // ALU carries
wire [15:0] af;               // ALU functions
reg  [15:0] afr;              //
wire [16:0] cp;               // previous lane carry
                              //
wire        alu_a, alu_b;     // ALU controls
wire        alu_c, alu_d;     //
wire        alu_e, alu_f;     //
wire        alu_g, alu_h;     //
                              //
reg  [15:0] r[0:15];          // register file
wire [15:0] pa;               // ALU port A bus, read/write
wire [15:0] pb;               // ALU port B bus, read only
                              //
reg  [3:0]  sa;               // port A register select
reg  [3:0]  sb;               // port B register select
                              //
reg  [15:0] as;               // port A register strobes
reg         as6_m0;           // port A register SP strobes
reg         as6_m1;           //
reg         as6_m3;           //
                              //
wire [15:0] bs;               // port B register strobes
wire        bs6_m0;           // port B register SP strobes
wire        bs6_m1;           //
wire        bs6_m3;           //
                              //
reg         ras123c;          //
wire        ras15;            //
wire        ras12, ras13;     //
wire        rbs12, rbs13;     //
wire [1:0]  rsm;              // register select processor model
wire        cm_pro;           // current mode - 00 (kernel)
wire        pm_pro;           // previous mode - 00 (kernel)
                              //
reg         psel;             // PSW selected
wire [69:0] idm;              // matrix output
reg  [69:0] id;               // registered output
wire        mid30;            // carry_in
wire        mid31;            // commit ALU result
wire        mid32;            //
wire        ac_lsb;           //
wire        sext;             // sign extension on port B
reg         swap;             // byte swap on DX-mux
reg         ystk, ystk0;      // yellow stack
                              //
wire        wpsw_zl, wpsw_zh; //
wire        wpsw_n;           //
wire        wpsw_c;           //
wire        wpsw_v;           //
wire        cp_816, cp_715;   //
reg         vf_reg;           //
                              //
wire        as8l, as8h;       //
wire        psw_wl, psw_wh;   //
wire        psw_stb;          //
reg         psw_n, psw_z;     //
reg         psw_v, psw_c;     //
wire [15:0] psw;              //
reg         mbra;             // microinstruction branch
wire        bra;              // PDP instruction branch
                              //
genvar      vi;               // variable for generate

//______________________________________________________________________________
//
// Minimal required registers initalization, otherwise,
// undefined content would prevent simulation.
//
initial
begin
   r[0] = 16'hFFFF;
   r[1] = 16'hFFFF;
   r[2] = 16'hFFFF;
   r[3] = 16'hFFFF;
   r[4] = 16'hFFFF;
   r[5] = 16'hFFFF;
   r[6] = 16'hFFFF;
   r[7] = 16'hFFFF;
   r[8] = 16'hF8FF;
   r[9] = 16'hFFFF;
   r[10] = 16'hFFFF;
   r[11] = 16'hFFFF;
   r[12] = 16'hFFFF;
   r[13] = 16'hFFFF;
   r[14] = 16'hFFFF;
   r[15] = 16'hFFFF;
end

//______________________________________________________________________________
//
assign clk = pin_clk;
wire #1 sim_dclk = clk; // suppress simulation glitches

always @(*) if (~clk) m <= pin_m;

assign doe = clk & (io_psw | (m[15:12] != 4'b1101));
assign pin_bso = doe & (d[15:13] == 3'b111);
assign pin_ad = doe ? d : 16'hZZZZ;
assign pin_ad_en = doe;

//______________________________________________________________________________
//
assign pin_mo[0]  = ir_stb_rc & m[4];  // general purpose outputs
assign pin_mo[1]  = ir_stb_rc & m[5];  // 0101 - clear timer event
assign pin_mo[2]  = ir_stb_rc & m[6];  // 0110 - clear ACLO event
assign pin_mo[3]  = ir_stb_rc & m[7];  // 0111 - ODT address ext load
//
// mo[6:4]  CTRL
//    000      - load PLM register address from return register (affects MC/NA/AXT)
//    001      - load PLM register or MMU control register
//    010      - set stack overflow in Control
//    011      - address conversion for user mode in MMU
//    100      - transfer priority and T-bit to Control
//    101      - transfer priority to Control
//    110      - transfer T-bit to Control
//    111      - no operation
//
assign pin_mo[4]  = ~(idm[21] | idm[22] | idm[25] | astb & ystk);
assign pin_mo[5]  = ~(idm[21] | idm[22] | idm[23] | idm[24]
                    | idm[26] | idm[27] | idm[28] | idm[18] & io_psw);
assign pin_mo[6]  = ~(idm[22] | idm[23] | idm[24] | astb & ystk
                  | astb & ~pm_pro & ~m[4] & ~m[6]
                  | astb & ~cm_pro & ~m[4] & m[6]);

assign pin_mo[7]  = idm[3] | idm[17] | idm[18]  // nSYNC - bus cycle
                  | ~bcyc & m[7] & m[6] & ~m[4]
                  | ~bcyc & ~astb;
//
// mo[12,9,8]
//    000      AWO   - address, write only
//    001      ARW   - address, read-modify-write
//    010      unused
//    011      ARO   - address, read only
//    100      DOUTB - data, write byte
//    101      DOUT  - data, write word
//    110      DIN   - data, read word
//    111      NOP
//
assign pin_mo[8]  = ~( (m[15:10] == 6'b000110)
                     | (m[15:12] == 4'b1101) & ~io_psw
                     | (m[15:10] == 6'b000100) & ~io_psw & wbyte);
assign pin_mo[9]  = ~( (m[15:10] == 6'b000110)
                     | (m[15:10] == 6'b000100) & ~io_psw
                     | (m[15:10] == 6'b000111));
assign pin_mo[12] = ~astb;

assign pin_mo[10] = 1'b1;        // test mode disabled
assign pin_mo[11] = ~mbra;       // microinstruction branch
assign pin_mo[13] = idm[19];     // IAK - interrupt acknowledge
assign pin_mo[14] = rinit_rc;    // peripheral reset

assign astb = (m[15:10] == 6'b000101)  // address for read
            | (m[15:10] == 6'b000110)  // address for write
            | (m[15:10] == 6'b000111); // address for read-write

//______________________________________________________________________________
//
assign bdc_en = clk & (m[15:10] == 6'b110011);
assign pa_en = ~clk | ~bdc_en;

always @(*)
begin
   if (clk)
   begin
      fx_ren[0] <= id[25] & ~io_psw &  m[7] & ~cm_pro;
      fx_ren[1] <= id[25] & ~io_psw &  m[7] & ~cm_pro & psw[15];
      fx_ren[2] <= id[25] & ~io_psw & ~m[7];
      fx_ren[3] <= doe;
   end
end

assign fx_en0 = ~clk & fx_ren[0];
assign fx_en1 = ~clk & fx_ren[1];
assign fx_en2 = ~clk & fx_ren[2];
assign fx_en  = ~clk & fx_ren[3];
assign doesc = fx_ren[3];

always @(negedge clk) bsyn_in <= ~pin_mc[7];
always @(negedge clk) badr_in <= astb;
assign bsyn = bsyn_in & ~clk;
assign badr = badr_in & ~clk & ~sim_dclk;

always @(*)
begin
   if (~clk)
   begin
      if (~bsyn) bcyc <= 1'b0;
      if ( bsyn & badr) bcyc <= 1'b1;

      if (~bsyn) wbyte <= 1'b0;
      if ( bsyn & id[13] & wtbt) wbyte <= 1'b1;

      if (~bsyn) io_psw <= 1'b0;
      if ( bsyn & badr) io_psw <= psel;
   end
end

always @(*) if (clk) psw_wb <= wbyte;
always @(*) if (clk) wtbt <= bcyc & ras15 & ~id[45];
assign db_oel = ~clk & mid31 & (wtbt | ~id[10]);
assign db_oeh = ~clk & mid31 & (wtbt |  id[10] | ~id[13] | (id[12] & ras123c));

always @(*) if (clk) d0c <= d[0];
always @(*)
begin
   if (~clk)
      if (~bsyn)
         io_a0c <= 1'b0;
      else
         if (bsyn & badr)
            io_a0c <= d0c;
end
always @(*) if (clk) io_a0 <= io_a0c;

always @(posedge clk) rinit <= rinit_rc;
assign rinit_rc = ~(idm[3] | idm[18]) & ((idm[21] & m[7]) | rinit);

//______________________________________________________________________________
//
// PSW access, latch virtual or physical address depending on MMU enable
//
always @(*)
begin
   if (pin_mc[15] & clk)   psel <= pin_bsi & (pin_ad[12:1] == 12'hFFF); // latch original
   if (~pin_mc[15] & ~clk) psel <= pin_bsi & (pin_ad[12:1] == 12'hFFF); // latch translated
end

//______________________________________________________________________________
//
always @(*) if (ir_stb & ~clk) ir <= pa;
always @(posedge clk) ir_stb <= ir_stb_rc;
assign ir_stb_rc = (m[15:8] == 8'b00010001)
                 | (m[15:10] == 6'b110101);

//______________________________________________________________________________
//
always @(*) if (~clk) mbra = (m[10:8] == 3'b000) & wpsw_n
                           | (m[10:8] == 3'b001) & wpsw_zl & wpsw_zh
                           | (m[10:8] == 3'b010) & wpsw_c
                           | (m[10:8] == 3'b011) & wpsw_v
                           | (m[10:8] == 3'b100) & psw_n
                           | (m[10:8] == 3'b101) & psw_z
                           | (m[10:8] == 3'b110) & psw_c
                           | (m[10:8] == 3'b111) & ~cm_pro;

assign bra = ~ir[8] ^ ( ~ir[15] &  ir[10] & (psw_n ^ psw_v)
                      |  ir[15] & ~ir[10] & ~ir[9] & psw_n
                      |  ir[15] &  ir[10] & ~ir[9] & psw_v
                      |  ir[15] & ~ir[10] &  ir[9] & psw_z
                      | ~ir[15] &  ir[9]  & psw_z
                      |  ir[15] &  ir[9]  & psw_c);

//______________________________________________________________________________
//
assign ras12 = m[3:0] == 4'b1100;
assign ras13 = m[3:0] == 4'b1101;
assign ras15 = m[3:0] == 4'b1111;
assign rbs12 = m[7:4] == 4'b1100;
assign rbs13 = m[7:4] == 4'b1101;

always @(*)
begin
   if (clk)
   begin
      ras123c <= ras12 | ras13;

      if (ras12)
         sa[3:0] <= {1'b0, ir[8:6]};
      else
         if (ras13)
            sa[3:0] <= {1'b0, ir[2:0]};
         else
            sa[3:0] <= m[3:0];

      if (rbs12)
         sb[3:0] <= {1'b0, ir[8:6]};
      else
         if (rbs13)
            sb[3:0] <= {1'b0, ir[2:0]};
         else
            sb[3:0] <= m[7:4];
   end
end

assign cm_pro = psw[15:14] == 2'b00;
assign pm_pro = psw[13:12] == 2'b00;

assign rsm[0] = (m[15:9] == 7'b1111110) ? psw[12] : psw[14];
assign rsm[1] = (m[15:9] == 7'b1111110) ? psw[13] : psw[15];

always @(*)
begin
   if (clk)
   begin
      as[0]  <= sa[3:0] == 4'b0000;
      as[1]  <= sa[3:0] == 4'b0001;
      as[2]  <= sa[3:0] == 4'b0010;
      as[3]  <= sa[3:0] == 4'b0011;
      as[4]  <= sa[3:0] == 4'b0100;
      as[5]  <= sa[3:0] == 4'b0101;
      as[6]  <= 1'b0;
      as[7]  <= sa[3:0] == 4'b0111;
      as[8]  <= sa[3:0] == 4'b1000;
      as[9]  <= sa[3:0] == 4'b1001;
      as[10] <= sa[3:0] == 4'b1010;
      as[11] <= sa[3:0] == 4'b1011;
      as[12] <= 1'b0;
      as[13] <= 1'b0;
      as[14] <= sa[3:0] == 4'b1110;
      as[15] <= sa[3:0] == 4'b1111;

      as6_m0 = (sa[3:0] == 4'b0110) & (rsm == 2'b00);
      as6_m1 = (sa[3:0] == 4'b0110) & (rsm == 2'b01);
      as6_m3 = (sa[3:0] == 4'b0110) & (rsm == 2'b11);
   end
end

assign pa = (as[0]  ? r[0]  : 16'h0000)
          | (as[1]  ? r[1]  : 16'h0000)
          | (as[2]  ? r[2]  : 16'h0000)
          | (as[3]  ? r[3]  : 16'h0000)
          | (as[4]  ? r[4]  : 16'h0000)
          | (as[5]  ? r[5]  : 16'h0000)
          | (as6_m0 ? r[6]  : 16'h0000)
          | (as6_m1 ? r[12] : 16'h0000)
          | (as6_m3 ? r[13] : 16'h0000)
          | (as[7]  ? r[7]  : 16'h0000)
          | (as[8]  ? r[8]  : 16'h0000)
          | (as[9]  ? r[9]  : 16'h0000)
          | (as[10] ? r[10] : 16'h0000)
          | (as[11] ? r[11] : 16'h0000)
          | (as[14] ? r[14] : 16'h0000)
          | (as[15] ? r[15] : 16'h0000);

assign bs[0]  = (sb[3:0] == 4'b0000) & m[15] & clk;
assign bs[1]  = (sb[3:0] == 4'b0001) & m[15] & clk;
assign bs[2]  = (sb[3:0] == 4'b0010) & m[15] & clk;
assign bs[3]  = (sb[3:0] == 4'b0011) & m[15] & clk;
assign bs[4]  = (sb[3:0] == 4'b0100) & m[15] & clk;
assign bs[5]  = (sb[3:0] == 4'b0101) & m[15] & clk;
assign bs[6]  = 1'b0;
assign bs[7]  = (sb[3:0] == 4'b0111) & m[15] & clk;
assign bs[8]  = (sb[3:0] == 4'b1000) & m[15] & clk;
assign bs[9]  = (sb[3:0] == 4'b1001) & m[15] & clk;
assign bs[10] = (sb[3:0] == 4'b1010) & m[15] & clk;
assign bs[11] = (sb[3:0] == 4'b1011) & m[15] & clk;
assign bs[12] = 1'b0;
assign bs[13] = 1'b0;
assign bs[14] = (sb[3:0] == 4'b1110) & m[15] & clk;
assign bs[15] = (sb[3:0] == 4'b1111) & m[15] & clk;

assign bs6_m0 = (sb[3:0] == 4'b0110) & (rsm == 2'b00) & m[15] & clk;
assign bs6_m1 = (sb[3:0] == 4'b0110) & (rsm == 2'b01) & m[15] & clk;
assign bs6_m3 = (sb[3:0] == 4'b0110) & (rsm == 2'b11) & m[15] & clk;

assign pb = (bs[0]  ? r[0]  : 16'h0000)
          | (bs[1]  ? r[1]  : 16'h0000)
          | (bs[2]  ? r[2]  : 16'h0000)
          | (bs[3]  ? r[3]  : 16'h0000)
          | (bs[4]  ? r[4]  : 16'h0000)
          | (bs[5]  ? r[5]  : 16'h0000)
          | (bs6_m0 ? r[6]  : 16'h0000)
          | (bs6_m1 ? r[12] : 16'h0000)
          | (bs6_m3 ? r[13] : 16'h0000)
          | (bs[7]  ? r[7]  : 16'h0000)
          | (bs[8]  ? r[8]  : 16'h0000)
          | (bs[9]  ? r[9]  : 16'h0000)
          | (bs[10] ? r[10] : 16'h0000)
          | (bs[11] ? r[11] : 16'h0000)
          | (bs[14] ? r[14] : 16'h0000)
          | (bs[15] ? r[15] : 16'h0000)
          | (~m[15] ? {8'h00, m[7:4], m[11:8]} : 16'h0000);

always @(*)if (clk) b[7:0] <= pb[7:0];
always @(*)if (clk) b[15:8] <= sext ? (pb[7] ? 8'hFF : 8'h00) : pb[15:8];

always @(*)
begin
   if (~clk)
   begin
      if (db_oel)
      begin
         if (as[0])  r[0][7:0]  <= d[7:0];
         if (as[1])  r[1][7:0]  <= d[7:0];
         if (as[2])  r[2][7:0]  <= d[7:0];
         if (as[3])  r[3][7:0]  <= d[7:0];
         if (as[4])  r[4][7:0]  <= d[7:0];
         if (as[5])  r[5][7:0]  <= d[7:0];
         if (as6_m0) r[6][7:0]  <= d[7:0];
         if (as6_m1) r[12][7:0] <= d[7:0];
         if (as6_m3) r[13][7:0] <= d[7:0];
         if (as[7])  r[7][7:0]  <= d[7:0];
         if (as8l)
         begin
            r[8][3:0] <= d[3:0];
            r[8][7:5] <= d[7:5];
            if (~psw_wl)
               r[8][4] <= d[4];
         end
         if (as[9])  r[9][7:0]  <= d[7:0];
         if (as[10]) r[10][7:0] <= d[7:0];
         if (as[11]) r[11][7:0] <= d[7:0];
         if (as[14]) r[14][7:0] <= d[7:0];
         if (as[15]) r[15][7:0] <= d[7:0];
      end
      if (db_oeh)
      begin
         if (as[0])  r[0][15:8]  <= d[15:8];
         if (as[1])  r[1][15:8]  <= d[15:8];
         if (as[2])  r[2][15:8]  <= d[15:8];
         if (as[3])  r[3][15:8]  <= d[15:8];
         if (as[4])  r[4][15:8]  <= d[15:8];
         if (as[5])  r[5][15:8]  <= d[15:8];
         if (as6_m0) r[6][15:8]  <= d[15:8];
         if (as6_m1) r[12][15:8] <= d[15:8];
         if (as6_m3) r[13][15:8] <= d[15:8];
         if (as[7])  r[7][15:8]  <= d[15:8];
         if (as8h)   r[8][15:8]  <= {d[15:11], 3'b000};
         if (as[9])  r[9][15:8]  <= d[15:8];
         if (as[10]) r[10][15:8] <= d[15:8];
         if (as[11]) r[11][15:8] <= d[15:8];
         if (as[14]) r[14][15:8] <= d[15:8];
         if (as[15]) r[15][15:8] <= d[15:8];
      end
      if (psw_stb)
      begin
         r[8][0] <= wpsw_c;
         r[8][1] <= wpsw_v;
         r[8][2] <= wpsw_zl & wpsw_zh;
         r[8][3] <= wpsw_n;
      end
   end
end

//______________________________________________________________________________
//
// Processor Status Word
//
always @(*) if (clk) io_pswc <= io_psw;
assign psw_wl = ~clk & id[18] & io_pswc & (~psw_wb | ~io_a0);
assign psw_wh = ~clk & id[18] & io_pswc & (~psw_wb |  io_a0);
assign as8l = as[8] | psw_wl;
assign as8h = as[8] | psw_wh;
assign psw_stb = id[8] & ~io_pswc & doesc;
assign psw = r[8];

always @(*)
begin
   if (clk)
   begin
      psw_n <= psw[3];
      psw_z <= psw[2];
      psw_v <= psw[1];
      psw_c <= psw[0];
   end
end

assign cp_715 = ~id[13] & cp[15] | (~id[6] & ~id[7]) & cp[7];
assign cp_816 = ~id[13] & cp[16] | (~id[6] & ~id[7]) & cp[8];

assign wpsw_n  = (~id[6] & ~id[7]) & dx[7] | ~id[13] & dx[15];
assign wpsw_zl = (dx[7:0] == 8'h00) & (alu_h | ~id[11] | psw_z) | id[9];
assign wpsw_zh = (dx[15:8] == 8'h00) | (~id[6] & ~id[7]);
assign wpsw_c  = alu_h & b[0]
               | (id[14] | id[15] | id[16]) & psw_c
               | mid32 & (wpsw_v ^ wpsw_n)
               | ~alu_h & ~(id[14] | id[15] | id[16]) & ~mid32 & (id[4] ^ cp_816);
assign wpsw_v = (alu_h ? (b[0] ^ wpsw_n) : (cp_715 ^ cp_816)) | id[0] & vf_reg;
always @(posedge clk)
begin
   if (id[0] & ras123c)
      vf_reg <= wpsw_v;
   if (id[23] | id[24])
      vf_reg <= 1'b0;
end

always @(*) if (~clk) ystk <= wpsw_zh & ystk0;
always @(*) if (clk) ystk0 <= as6_m0 & id[20] & sext & pb[7];

//______________________________________________________________________________
//
always @(*) if (clk) dc <= d;
always @(*) if (clk) di <= pin_ad;

assign d[7:0]  = db_oel ? (swap ? dx[15:8] : dx[7:0]) :
                 bdc_en ? bdc[7:0] :
                 pa_en ? pa[7:0] : 8'hZZ;

assign d[15:8] = db_oeh ? (swap ? dx[7:0] : dx[15:8]) :
                 bdc_en ? bdc[15:8] :
                 pa_en ? pa[15:8] : 8'hZZ;

assign dx[4:0]  = fx_en ? fx[4:0]  : di[4:0];
assign dx[11:8] = fx_en ? fx[11:8] : di[11:8];
assign dx[7:5]  = (fx_en | fx_en0) ? fx[7:5] : di[7:5];
assign dx[12]   = (fx_en | fx_en0 | fx_en2) ? fx[12] : di[12];
assign dx[13]   = (fx_en | fx_en1 | fx_en2) ? fx[13] : di[13];
assign dx[14]   = (fx_en | fx_en0) ? fx[14] : di[14];
assign dx[15]   = (fx_en | fx_en1) ? fx[15] : di[15];

assign fx[0]  = fx_en & (cp[0]  ^ af[0]);
assign fx[1]  = fx_en & (cp[1]  ^ af[1]);
assign fx[2]  = fx_en & (cp[2]  ^ af[2]);
assign fx[3]  = fx_en & (cp[3]  ^ af[3]);
assign fx[4]  = fx_en & (cp[4]  ^ af[4]);
assign fx[5]  = fx_en & (cp[5]  ^ af[5]) | fx_en0 & dc[5];
assign fx[6]  = fx_en & (cp[6]  ^ af[6]) | fx_en0 & dc[6];
assign fx[7]  = fx_en & (cp[7]  ^ af[7]) | fx_en0 & dc[7];

assign fx[8]  = fx_en & (cp[8]  ^ af[8]);
assign fx[9]  = fx_en & (cp[9]  ^ af[9]);
assign fx[10] = fx_en & (cp[10] ^ af[10]);
assign fx[11] = fx_en & (cp[11] ^ af[11]);
assign fx[12] = fx_en & (cp[12] ^ af[12]) | fx_en0 & dc[12] | fx_en2 & dc[14];
assign fx[13] = fx_en & (cp[13] ^ af[13]) | fx_en1 & dc[13] | fx_en2 & dc[15];
assign fx[14] = fx_en & (cp[14] ^ af[14]) | fx_en0 & dc[14];
assign fx[15] = fx_en & (cp[15] ^ af[15]) | fx_en1 & dc[15];

always @(*)
begin
if (~clk)
   begin
      bdc[3:0]   <= cp[4]  ? 4'b1111 : 4'b1001;
      bdc[7:4]   <= cp[8]  ? 4'b1111 : 4'b1001;
      bdc[11:8]  <= cp[12] ? 4'b1111 : 4'b1001;
      bdc[15:12] <= cp[16] ? 4'b1111 : 4'b1001;
   end
end

always @(*) if (clk) swap <= (wtbt | id[45]) & (~id[6] & ~id[7]) & io_a0
                           | id[9] | id[10];
//______________________________________________________________________________
//
function cmp
(
   input [7:0] ai,
   input [7:0] mi
);
begin
   casex(ai)
      mi:      cmp = 1'b1;
      default: cmp = 1'b0;
   endcase
end
endfunction

always @(*) if (clk) id <= idm;

assign idm[0]  = cmp(m[15:8], 8'b10001x0x);
assign idm[1]  = cmp(m[15:8], 8'b100000xx);
assign idm[2]  = cmp(m[15:8], 8'b100001xx) & psw[0];
assign idm[3]  = cmp(m[15:8], 8'b00000xxx);
assign idm[4]  = cmp(m[15:8], 8'bx0x1xxxx);
assign idm[5]  = cmp(m[15:8], 8'b10000xxx);
assign idm[6]  = cmp(m[15:8], 8'bxxxxxxx0);
assign idm[7]  = cmp(m[15:8], 8'b0xxxxxxx);
assign idm[8]  = cmp(m[15:8], 8'b1xxxxx0x);
assign idm[9]  = cmp(m[15:8], 8'b111011x0);

assign idm[10] = cmp(m[15:8], 8'b111011x1);
assign idm[11] = cmp(m[15:8], 8'b10xx01xx);
assign idm[12] = cmp(m[15:8], 8'b110000x1);
assign idm[13] = cmp(m[15:8], 8'b1xxxxxx1);
assign idm[14] = cmp(m[15:8], 8'b1x1x10xx);
assign idm[15] = cmp(m[15:8], 8'b11x00xxx);
assign idm[16] = cmp(m[15:8], 8'b1111110x);
assign idm[17] = cmp(m[15:8], 8'b1101xx1x);
assign idm[18] = cmp(m[15:8], 8'b00010000);
assign idm[19] = cmp(m[15:8], 8'b110111xx);

assign idm[20] = cmp(m[15:8], 8'b0100xxxx);
assign idm[21] = cmp(m[15:8], 8'b00010010);
assign idm[22] = cmp(m[15:8], 8'b00010011);
assign idm[23] = cmp(m[15:8], 8'b00010001);
assign idm[24] = cmp(m[15:8], 8'b110101xx);
assign idm[25] = cmp(m[15:8], 8'b110110xx);
assign idm[26] = cmp(m[15:8], 8'b110110xx) & cm_pro;
assign idm[27] = cmp(m[15:8], 8'b110110xx) & ~m[7];
assign idm[28] = cmp(m[15:8], 8'b110110xx) & io_psw;
assign idm[29] = 1'b0;

assign idm[30] = cmp(m[15:8], 8'b1x0000x1);
assign idm[31] = cmp(m[15:8], 8'b0100xxxx);
assign idm[32] = cmp(m[15:8], 8'b1111011x);
assign idm[33] = cmp(m[15:8], 8'b11111110) & bra;
assign idm[34] = cmp(m[15:8], 8'b110001xx) & psw_n;
assign idm[35] = cmp(m[15:8], 8'b10xxx1xx) & psw[0];
assign idm[36] = cmp(m[15:8], 8'b1111010x) & psw[0];
assign idm[37] = cmp(m[15:8], 8'b1111010x) & ~psw[0];
assign idm[38] = cmp(m[15:8], 8'b10001xxx);
assign idm[39] = cmp(m[15:8], 8'b10111xxx);

assign idm[40] = cmp(m[15:8], 8'b100110xx);
assign idm[41] = cmp(m[15:8], 8'b0011xxxx);
assign idm[42] = cmp(m[15:8], 8'b00011x00);
assign idm[43] = cmp(m[15:8], 8'b00010100);
assign idm[44] = cmp(m[15:8], 8'b10110xxx);
assign idm[45] = cmp(m[15:8], 8'b1101xxxx);
assign idm[46] = cmp(m[15:8], 8'b110011xx);
assign idm[47] = cmp(m[15:8], 8'b10100xxx);
assign idm[48] = cmp(m[15:8], 8'b100111xx);
assign idm[49] = cmp(m[15:8], 8'b10010xxx);

assign idm[50] = cmp(m[15:8], 8'b1111110x);
assign idm[51] = cmp(m[15:8], 8'b111100xx);
assign idm[52] = cmp(m[15:8], 8'b111011xx);
assign idm[53] = cmp(m[15:8], 8'b111010xx);
assign idm[54] = cmp(m[15:8], 8'b111001xx);
assign idm[55] = cmp(m[15:8], 8'b110000xx);
assign idm[56] = cmp(m[15:8], 8'b10101xxx);
assign idm[57] = cmp(m[15:8], 8'b0101xxxx);
assign idm[58] = cmp(m[15:8], 8'b0010xxxx);
assign idm[59] = cmp(m[15:8], 8'b000100xx);

assign idm[60] = cmp(m[15:8], 8'b00010101);
assign idm[61] = cmp(m[15:8], 8'b00011x01);
assign idm[62] = cmp(m[15:8], 8'b111000xx);
assign idm[63] = cmp(m[15:8], 8'b0110xxxx);
assign idm[64] = cmp(m[15:8], 8'b111110xx);
assign idm[65] = cmp(m[15:8], 8'b0111xxxx);
assign idm[66] = cmp(m[15:8], 8'b101x10xx);
assign idm[67] = cmp(m[15:8], 8'b110001xx);
assign idm[68] = cmp(m[15:8], 8'b10000xxx);
assign idm[69] = cmp(m[15:8], 8'b110010xx);

assign mid30 = id[35] | id[42] | id[43] | id[46] | id[48] | id[59] | id[66];
assign mid31 = id[31] | id[32] | id[33] | id[34] | id[36] | id[38] | id[39]
             | id[42] | id[43] | id[44] | id[45] | id[46] | id[47] | id[48]
             | id[49] | id[50] | id[52] | id[53] | id[54] | id[55] | id[56]
             | id[57] | id[58] | id[59] | id[60] | id[61] | id[62] | id[63]
             | id[67] | id[68] | id[69];
assign mid32 = id[36] | id[37];

assign sext = clk & (id[30] | id[31] | id[32]);

assign alu_a = id[32] | id[38] | id[39] | id[40] | id[41];
assign alu_b = id[44];
assign alu_c = id[31] | id[32] | id[33] | id[36]
             | id[38] | id[39] | id[46] | id[47];
assign alu_d = id[34] | id[39] | id[40] | id[41] | id[44] | id[48] | id[49];
assign alu_e = id[34] | id[37] | id[40] | id[41]
             | id[42] | id[43] | id[44] | id[45]
             | id[50] | id[51] | id[52] | id[54]
             | id[55] | id[56] | id[57] | id[58]
             | id[59] | id[60] | id[61] | id[63]
             | id[64] | id[65];
assign alu_f = id[31] | id[33] | id[34] | id[36]
             | id[45] | id[46] | id[47] | id[50]
             | id[51] | id[52] | id[53] | id[54]
             | id[55] | id[56] | id[57] | id[58];
assign alu_g = id[31] | id[33] | id[34] | id[36]
             | id[37] | id[39] | id[42] | id[43]
             | id[46] | id[47] | id[48] | id[49]
             | id[53] | id[54] | id[57] | id[59]
             | id[60] | id[61] | id[62];
assign alu_h = id[5];      // ALU B port shifted right
assign ac_lsb = id[42] | id[43];

//______________________________________________________________________________
//
// ALU
//
generate
for (vi=0; vi<16; vi=vi+1)
begin : gen_ac
   always @(*)
   if (clk)
   begin
      ac[vi] <=  b[vi] & ~d[vi] & alu_a
              | ~b[vi] &  d[vi] & alu_b
              |  b[vi] &  d[vi] & alu_c
              |  (vi == 0) & ac_lsb;

      afr[vi] <= ~b[vi] & ~d[vi] & alu_d
               |  b[vi] &  d[vi] & alu_e
               |  b[vi] & ~d[vi] & alu_f
               | ~b[vi] &  d[vi] & alu_g;
   end
end
endgenerate

generate
for (vi=0; vi<7; vi=vi+1)
begin : gen_afl
   assign af[vi] = afr[vi] | ~clk & alu_h & b[vi+1];
end

for (vi=8; vi<15; vi=vi+1)
begin : gen_afh
   assign af[vi] = afr[vi] | ~clk & alu_h & b[vi+1];
end
endgenerate

assign af[7]  = afr[7]  | alu_h & (~id[6] & ~id[7] & id[2]
                                  | b[8] & (id[1] | id[6] | id[7]));
assign af[15] = afr[15] | alu_h & (id[2] | b[15] & id[1]);
assign cp[0] = ~alu_h & (id[4] ^ mid30);

// Look-ahead carry in tetrades
generate
for (vi=0; vi<16; vi=vi+4)
begin : gen_cp
   assign cp[vi+1] = ac[vi+0]
                   | af[vi+0] & cp[vi+0];
   assign cp[vi+2] = ac[vi+1]
                   | af[vi+1] & ac[vi+0]
                   | af[vi+1] & af[vi+0] & cp[vi+0];
   assign cp[vi+3] = ac[vi+2]
                   | af[vi+2] & ac[vi+1]
                   | af[vi+2] & af[vi+1] & ac[vi+0]
                   | af[vi+2] & af[vi+1] & af[vi+0] & cp[vi+0];
   assign cp[vi+4] = ac[vi+3]
                   | af[vi+3] & ac[vi+2]
                   | af[vi+3] & af[vi+2] & ac[vi+1]
                   | af[vi+3] & af[vi+2] & af[vi+1] & ac[vi+0]
                   | af[vi+3] & af[vi+2] & af[vi+1] & af[vi+0] & cp[vi+0];
end
endgenerate

//______________________________________________________________________________
//
endmodule
