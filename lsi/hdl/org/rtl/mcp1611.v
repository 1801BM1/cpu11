//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// MCP-1611 Data Chip model, for debug and simulating only
//______________________________________________________________________________
//
module mcp1611
(
   input          pin_c1,        // clock phase 1
   input          pin_c2,        // clock phase 2
   input          pin_c3,        // clock phase 3
   input          pin_c4,        // clock phase 4
   input          pin_wi,        // wait for ready
   inout [15:0]   pin_m_n,       // microinstruction bus
   inout [15:0]   pin_ad         // address/data bus
);

//______________________________________________________________________________
//
wire  c1;            // internal clocks
wire  c2;            //
wire  c3;            //
wire  c4;            //
                     //
//______________________________________________________________________________
//
reg      inpl;       //
reg      inpl_c4;    //
reg      mo_fa;      //
reg      mo_fa_c4;   //
reg      mo_ad;      //
reg      mo_ad_c4;   //
reg      m_in;       //
reg      m_in_c4;    //
                     //
reg      wr_f0;      //
reg      wr_f0_c4;   //
reg      wr_f1;      //
reg      wr_f1_c4;   //
reg      wr_f2;      //
reg      wr_f2_c4;   //
reg      wr_f3;      //
reg      wr_f3_c4;   //
reg      wr_f4;      //
reg      wr_f4_c4;   //
                     //
wire     st_fx;      //
reg      st_f0;      //
reg      st_f0_c4;   //
reg      st_f1;      //
reg      st_f1_c4;   //
reg      st_f4;      //
reg      st_f4_c4;   //
reg      st_f6;      //
reg      st_f6_c4;   //
                     //
wire        jm15;    //
reg         jump;    // indirect condition code
wire        jbxx;    // for PDP-11 branch opcodes
reg  [10:0] dmi;     // decoded microinstruction
wire [10:0] dmi_pl;  //
reg  [20:0] pl;      // matrix control
wire [20:0] pl_pld;  //
                     //
wire [7:0]  md;      // data multiplexer
reg  [15:0] mu_c4;   //
reg  [15:0] mu;      //
reg  [2:0]  g_c1;    // G register latch
reg  [2:0]  fag;     //
reg         wr_g0;   // write ALU to G
reg         wr_g1;   // write ad[6:4] to G
reg         wr_g2;   // write ad[8:6] to G
                     //
reg         m04rs;   // mir 0&4 reset
reg  [7:0]  psw_c2;  //
reg  [7:0]  psw;     // processor status word
reg  [15:0] dir_c1;  // microinstriction
reg  [15:0] dir;     // microinstriction
reg  [2:0]  g;       // G register
reg  [7:0]  r[0:25]; // general register file
wire [7:0]  ra;      // register file port A
wire [7:0]  rb;      // register file port B
wire [25:0] rsela;   // register select A
wire [25:0] rselb;   // register select B
reg  [25:0] rwra;    // write strobe latch
                     //
reg  [15:0] mi_out;  // microinstruction output
reg  [15:0] dal;     // latched AD input
reg  [15:0] ad_out;  // Q-bus output latch
reg      ad_stb_c4;  //
reg         ad_stb;  //
reg         ad_oe;   //
reg         addr0;   // Q-bus address lsb
reg         mdl_rd;  //
reg         mdh_rd;  //
reg         psw_rd;  //
reg         alu_rd;  //
reg         alu_sh;  //
                     //
reg         f03_wr;  //
reg         f47_wr;  //
reg         fb7z;    //
reg         sb_ext;  // port B sign extension
reg      sb_ext_c4;  //
                     //
wire [7:0]  fa;      // ALU input port A
wire [7:0]  fb;      // ALU input port B
                     //
reg  [7:0]  c;       // carry chain
reg  [7:0]  ax;      // OR subfunction
reg  [7:0]  ay;      // AND subfunction
reg  [7:0]  alu;     //
reg         alu_sh8; // ALU shift-in flag
reg         alu_c;   // ALU flags
reg         alu_v;   //
reg         alu_z;   //
reg         alu_z_c4;//
reg         alu_n;   //
reg         alu_c8;  //
reg         alu_c4;  //
                     //
//______________________________________________________________________________
//
// Internals clocks
//
assign c1 = pin_c1;
assign c2 = pin_c2;
assign c3 = pin_c3;
assign c4 = pin_c4;

//______________________________________________________________________________
//
always @(*) if (c4) dal[15:0] = pin_ad[15:0];

always @(*)
begin
   if (c4) inpl_c4 <= ~pl[12] & ~pin_wi;
   if (c2) inpl <= inpl_c4;

   if (c4) m_in_c4 <= pl[12] & ~pin_wi;
   if (c1) m_in <= m_in_c4;
   if (c2) m_in <= 1'b0;

   if (c4) mo_fa_c4 <= dmi[8] & ~pin_wi;
   if (c1) mo_fa <= mo_fa_c4;
   if (c2) mo_fa <= 1'b0;

   if (c4) mo_ad_c4 <= (dir[4] | dir[5]) & dmi[7] & ~pin_wi;
   if (c1) mo_ad <= mo_ad_c4;
   if (c2) mo_ad <= 1'b0;
end

//______________________________________________________________________________
//
// Processor status word (PSW)
//
always @(*)
begin
   if (c3) psw[7:0] <= psw_c2[7:0];
   if (c2)
   begin
      if (wr_f4)
      begin
         if (wr_f0) psw_c2[0] <= mu[0];
         if (wr_f1) psw_c2[1] <= mu[1];
         if (wr_f2) psw_c2[2] <= mu[2];
         if (wr_f3) psw_c2[3] <= mu[3];
         psw_c2[7:4] <= mu[7:4];
      end
      else
      begin
         if (st_f0) psw_c2[0] <= alu_c;
         if (st_f1) psw_c2[1] <= alu_v;
         if (st_f1) psw_c2[2] <= alu_z;
         if (st_f1) psw_c2[3] <= alu_n;
         if (st_f4) psw_c2[4] <= alu_c8;
         if (st_f4) psw_c2[5] <= alu_c4;
         if (st_f6) psw_c2[6] <= alu_z;
         if (st_f6) psw_c2[7] <= alu_n;
      end
   end
end

assign st_fx = (psw[0] | ~dmi[1]) & (jump | ~dmi[0]) & ~pin_wi;
always @(*)
begin
   if (c4)
   begin
      st_f0_c4 <= st_fx & ~pl[7] & ~pl[9] & pl[12];
      st_f1_c4 <= st_fx & ~pl[7] & ~pl[8] & pl[12];
      st_f4_c4 <= st_fx & ~pl[9];
      st_f6_c4 <= st_fx & ~pl[8];
   end
   if (c2)
   begin
      st_f0 <= st_f0_c4;
      st_f1 <= st_f1_c4;
      st_f4 <= st_f4_c4;
      st_f6 <= st_f6_c4;
   end
   if (c3)
   begin
      st_f0 <= 1'b0;
      st_f1 <= 1'b0 ;
      st_f4 <= 1'b0 ;
      st_f6 <= 1'b0 ;
   end
end

always @(*)
begin
   if (c4)
   begin
      wr_f0_c4 <= dir[4];
      wr_f1_c4 <= dir[5];
      wr_f2_c4 <= dir[6];
      wr_f3_c4 <= dir[7];
      wr_f4_c4 <= pl[15];
   end
   if (c2)
   begin
      wr_f0 <= wr_f0_c4 & wr_f4_c4;
      wr_f1 <= wr_f1_c4 & wr_f4_c4;
      wr_f2 <= wr_f2_c4 & wr_f4_c4;
      wr_f3 <= wr_f3_c4 & wr_f4_c4;
      wr_f4 <= wr_f4_c4;
   end
   if (c3)
   begin
      wr_f0 <= 1'b0;
      wr_f1 <= 1'b0 ;
      wr_f2 <= 1'b0 ;
      wr_f3 <= 1'b0 ;
      wr_f4 <= 1'b0 ;
   end
end

//______________________________________________________________________________
//
// Register G
//
always @(*)
begin
   if (c1)
   begin
      if (wr_g0)
         g_c1[2:0] <= fag[2:0];
      if (wr_g1)
         g_c1[2:0] <= dal[6:4];
      if (wr_g2)
         g_c1[2:0] <= dal[8:6];
      if (~wr_g0 & ~wr_g1 & ~wr_g2)
         g_c1[2:0] <= g[2:0];
   end
   if (c2)
      g[2:0] <= g_c1[2:0];
end

always @(*)
begin
   if (c4)
   begin
      fag[2:0] <= fa[2:0];
      wr_g0 <= ~pin_wi & dmi[9];
      wr_g1 <= ~pin_wi & dmi[7] &  dir[4] & ~dir[5];
      wr_g2 <= ~pin_wi & dmi[7] & ~dir[4] &  dir[5];
   end
end

//______________________________________________________________________________
//
// Dual-port register file 26x8
//
assign rsela[0]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b000);
assign rsela[1]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b000);
assign rsela[2]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b001);
assign rsela[3]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b001);
assign rsela[4]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b010);
assign rsela[5]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b010);
assign rsela[6]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b011);
assign rsela[7]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b011);
assign rsela[8]  = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b100);
assign rsela[9]  = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b100);
assign rsela[10] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b101);
assign rsela[11] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b101);

assign rsela[12] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b111)
                 | (dir[3:0] == 4'b1111);
assign rsela[13] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b111)
                 | (dir[3:0] == 4'b1110);
assign rsela[14] = (dir[3:0] == 4'b0001) & (g[2:0] == 3'b110)
                 | (dir[3:0] == 4'b1101);
assign rsela[15] = (dir[3:0] == 4'b0000) & (g[2:0] == 3'b110)
                 | (dir[3:0] == 4'b1100);

assign rsela[16] = (dir[3:0] == 4'b1011);
assign rsela[17] = (dir[3:0] == 4'b1010);
assign rsela[18] = (dir[3:0] == 4'b1001);
assign rsela[19] = (dir[3:0] == 4'b1000);
assign rsela[20] = (dir[3:0] == 4'b0111);
assign rsela[21] = (dir[3:0] == 4'b0110);
assign rsela[22] = (dir[3:0] == 4'b0101);
assign rsela[23] = (dir[3:0] == 4'b0100);
assign rsela[24] = (dir[3:0] == 4'b0011);
assign rsela[25] = (dir[3:0] == 4'b0010);

assign rselb[0]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b000);
assign rselb[1]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b000);
assign rselb[2]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b001);
assign rselb[3]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b001);
assign rselb[4]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b010);
assign rselb[5]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b010);
assign rselb[6]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b011);
assign rselb[7]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b011);
assign rselb[8]  = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b100);
assign rselb[9]  = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b100);
assign rselb[10] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b101);
assign rselb[11] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b101);

assign rselb[12] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b111)
                 | (dir[7:4] == 4'b1111);
assign rselb[13] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b111)
                 | (dir[7:4] == 4'b1110);
assign rselb[14] = (dir[7:4] == 4'b0001) & (g[2:0] == 3'b110)
                 | (dir[7:4] == 4'b1101);
assign rselb[15] = (dir[7:4] == 4'b0000) & (g[2:0] == 3'b110)
                 | (dir[7:4] == 4'b1100);

assign rselb[16] = (dir[7:4] == 4'b1011);
assign rselb[17] = (dir[7:4] == 4'b1010);
assign rselb[18] = (dir[7:4] == 4'b1001);
assign rselb[19] = (dir[7:4] == 4'b1000);
assign rselb[20] = (dir[7:4] == 4'b0111);
assign rselb[21] = (dir[7:4] == 4'b0110);
assign rselb[22] = (dir[7:4] == 4'b0101);
assign rselb[23] = (dir[7:4] == 4'b0100);
assign rselb[24] = (dir[7:4] == 4'b0011);
assign rselb[25] = (dir[7:4] == 4'b0010);

assign ra = (rsela[0]  ? r[0]  : 8'h00)
          | (rsela[1]  ? r[1]  : 8'h00)
          | (rsela[2]  ? r[2]  : 8'h00)
          | (rsela[3]  ? r[3]  : 8'h00)
          | (rsela[4]  ? r[4]  : 8'h00)
          | (rsela[5]  ? r[5]  : 8'h00)
          | (rsela[6]  ? r[6]  : 8'h00)
          | (rsela[7]  ? r[7]  : 8'h00)
          | (rsela[8]  ? r[8]  : 8'h00)
          | (rsela[9]  ? r[9]  : 8'h00)
          | (rsela[10] ? r[10] : 8'h00)
          | (rsela[11] ? r[11] : 8'h00)
          | (rsela[12] ? r[12] : 8'h00)
          | (rsela[13] ? r[13] : 8'h00)
          | (rsela[14] ? r[14] : 8'h00)
          | (rsela[15] ? r[15] : 8'h00)
          | (rsela[16] ? r[16] : 8'h00)
          | (rsela[17] ? r[17] : 8'h00)
          | (rsela[18] ? r[18] : 8'h00)
          | (rsela[19] ? r[19] : 8'h00)
          | (rsela[20] ? r[20] : 8'h00)
          | (rsela[21] ? r[21] : 8'h00)
          | (rsela[22] ? r[22] : 8'h00)
          | (rsela[23] ? r[23] : 8'h00)
          | (rsela[24] ? r[24] : 8'h00)
          | (rsela[25] ? r[25] : 8'h00);

assign rb = (rselb[0]  ? r[0]  : 8'h00)
          | (rselb[1]  ? r[1]  : 8'h00)
          | (rselb[2]  ? r[2]  : 8'h00)
          | (rselb[3]  ? r[3]  : 8'h00)
          | (rselb[4]  ? r[4]  : 8'h00)
          | (rselb[5]  ? r[5]  : 8'h00)
          | (rselb[6]  ? r[6]  : 8'h00)
          | (rselb[7]  ? r[7]  : 8'h00)
          | (rselb[8]  ? r[8]  : 8'h00)
          | (rselb[9]  ? r[9]  : 8'h00)
          | (rselb[10] ? r[10] : 8'h00)
          | (rselb[11] ? r[11] : 8'h00)
          | (rselb[12] ? r[12] : 8'h00)
          | (rselb[13] ? r[13] : 8'h00)
          | (rselb[14] ? r[14] : 8'h00)
          | (rselb[15] ? r[15] : 8'h00)
          | (rselb[16] ? r[16] : 8'h00)
          | (rselb[17] ? r[17] : 8'h00)
          | (rselb[18] ? r[18] : 8'h00)
          | (rselb[19] ? r[19] : 8'h00)
          | (rselb[20] ? r[20] : 8'h00)
          | (rselb[21] ? r[21] : 8'h00)
          | (rselb[22] ? r[22] : 8'h00)
          | (rselb[23] ? r[23] : 8'h00)
          | (rselb[24] ? r[24] : 8'h00)
          | (rselb[25] ? r[25] : 8'h00);

//
// Ouput ports A/B multiplexers
//
assign fa[7:0] = ra[7:0];
assign fb[7:0] = (~dir[15] ? dir[11:4] : 8'h00)
               | ((dir[15] & ~sb_ext) ? rb[7:0] : 8'h00)
               | ((dir[15] &  sb_ext) ? (fb7z ? 8'h00 : 8'hff) : 8'h00);

always @(*)
begin
   if (c4)
      sb_ext_c4 <= ~pin_wi & ~pl[12] & dmi[10] & dir[4];
   if (c2)
      sb_ext <= sb_ext_c4;
end

//
// Minimal required registers initalization, otherwise,
// undefined content would prevent simulation. Only PDP-11
// registers are reset, because its behaviour depends on software
//
initial
begin
   r[0] = 8'h00;
   r[1] = 8'h00;
   r[2] = 8'h00;
   r[3] = 8'h00;
   r[4] = 8'h00;
   r[5] = 8'h00;
   r[6] = 8'h00;
   r[7] = 8'h00;
   r[8] = 8'h00;
   r[9] = 8'h00;
   r[10] = 8'h00;
   r[11] = 8'h00;
end

//
// Register write strobes
//
always @(*)
begin
   if (c4)
   begin
      f03_wr <= st_fx & ~pl[10] & (~dmi[3] | ~psw[5]);
      f47_wr <= st_fx & ~pl[10] & (~dmi[3] | ~psw[4]);
      fb7z <= ~fb[7];
   end
   if (c3) rwra[25:0] <= rsela[25:0];
   if (c1)
   begin
      if (f03_wr)
      begin
         if (rwra[0]) r[0][3:0] <= md[3:0];
         if (rwra[1]) r[1][3:0] <= md[3:0];
         if (rwra[2]) r[2][3:0] <= md[3:0];
         if (rwra[3]) r[3][3:0] <= md[3:0];
         if (rwra[4]) r[4][3:0] <= md[3:0];
         if (rwra[5]) r[5][3:0] <= md[3:0];
         if (rwra[6]) r[6][3:0] <= md[3:0];
         if (rwra[7]) r[7][3:0] <= md[3:0];
         if (rwra[8]) r[8][3:0] <= md[3:0];
         if (rwra[9]) r[9][3:0] <= md[3:0];
         if (rwra[10]) r[10][3:0] <= md[3:0];
         if (rwra[11]) r[11][3:0] <= md[3:0];
         if (rwra[12]) r[12][3:0] <= md[3:0];
         if (rwra[13]) r[13][3:0] <= md[3:0];
         if (rwra[14]) r[14][3:0] <= md[3:0];
         if (rwra[15]) r[15][3:0] <= md[3:0];
         if (rwra[16]) r[16][3:0] <= md[3:0];
         if (rwra[17]) r[17][3:0] <= md[3:0];
         if (rwra[18]) r[18][3:0] <= md[3:0];
         if (rwra[19]) r[19][3:0] <= md[3:0];
         if (rwra[20]) r[20][3:0] <= md[3:0];
         if (rwra[21]) r[21][3:0] <= md[3:0];
         if (rwra[22]) r[22][3:0] <= md[3:0];
         if (rwra[23]) r[23][3:0] <= md[3:0];
         if (rwra[24]) r[24][3:0] <= md[3:0];
         if (rwra[25]) r[25][3:0] <= md[3:0];
      end
      if (f47_wr)
      begin
         if (rwra[0]) r[0][7:4] <= md[7:4];
         if (rwra[1]) r[1][7:4] <= md[7:4];
         if (rwra[2]) r[2][7:4] <= md[7:4];
         if (rwra[3]) r[3][7:4] <= md[7:4];
         if (rwra[4]) r[4][7:4] <= md[7:4];
         if (rwra[5]) r[5][7:4] <= md[7:4];
         if (rwra[6]) r[6][7:4] <= md[7:4];
         if (rwra[7]) r[7][7:4] <= md[7:4];
         if (rwra[8]) r[8][7:4] <= md[7:4];
         if (rwra[9]) r[9][7:4] <= md[7:4];
         if (rwra[10]) r[10][7:4] <= md[7:4];
         if (rwra[11]) r[11][7:4] <= md[7:4];
         if (rwra[12]) r[12][7:4] <= md[7:4];
         if (rwra[13]) r[13][7:4] <= md[7:4];
         if (rwra[14]) r[14][7:4] <= md[7:4];
         if (rwra[15]) r[15][7:4] <= md[7:4];
         if (rwra[16]) r[16][7:4] <= md[7:4];
         if (rwra[17]) r[17][7:4] <= md[7:4];
         if (rwra[18]) r[18][7:4] <= md[7:4];
         if (rwra[19]) r[19][7:4] <= md[7:4];
         if (rwra[20]) r[20][7:4] <= md[7:4];
         if (rwra[21]) r[21][7:4] <= md[7:4];
         if (rwra[22]) r[22][7:4] <= md[7:4];
         if (rwra[23]) r[23][7:4] <= md[7:4];
         if (rwra[24]) r[24][7:4] <= md[7:4];
         if (rwra[25]) r[25][7:4] <= md[7:4];
      end
   end
end

//______________________________________________________________________________
//
// Output data register
//
always @(*)
begin
   if (c4) mu_c4[15:0] <= {fb[7:0], fa[7:0]};
   if (c1) mu[15:0] <= mu_c4[15:0];
end

assign pin_ad[15:0] = ad_oe ? ad_out[15:0] : 16'hzzzz;
always @(*)
begin
   if (c1)
   begin
      ad_stb <= ad_stb_c4;
      ad_oe <= ad_stb_c4;
      if (ad_stb_c4)
         ad_out[15:0] <= mu_c4[15:0];
   end
   if (c2)
      ad_stb <= 1'b0;
   if (c4)
      ad_stb_c4 <= ~dmi[4] & (dmi[6] | ~pin_wi & dmi[5]);
end

//______________________________________________________________________________
//
// Data multiplexer
//
assign md[7:0] = (psw_rd ? psw[7:0] : 8'h00)
               | (mdl_rd ? dal[7:0] : 8'h00)
               | (mdh_rd ? dal[15:8] : 8'h00)
               | (alu_rd ? alu[7:0] : 8'h00)
               | (alu_sh ? {alu_sh8, alu[7:1]} : 8'h00);

always @(*)
begin
   if (c1)
      if (ad_stb)
         addr0 <= mu_c4[0];
   if (c4)
   begin
      mdl_rd <= ~(pl[19] & ~dir[4] & ~dir[5])
              & ~(pl[19] & dir[5] & (addr0 ^ dir[4]))
              & ~(pl[20] & inpl)
              & (pl[20] | pl[19]);
      mdh_rd <= (pl[19] & ~dir[4] & ~dir[5])
              | (pl[19] & dir[5] & (addr0 ^ dir[4]))
              | (pl[20] & inpl);

      psw_rd <= pl[17];
      alu_rd <= (pl[20:17] == 4'b0000);
      alu_sh <= pl[18];
   end
end

//______________________________________________________________________________
//
// ALU
//
always @(*)
begin
   if (c4)
   begin
      alu_z_c4 <= ~inpl & ~pl[16];
      alu_sh8 <= psw[0] & dmi[2]
               | psw[4] & inpl;
   end
   if (c1)
   begin
      alu_z  <= (md[7:0] == 8'h00) & (alu_z_c4 | psw[6]);
      alu_n  <= md[7];
      alu_c4 <= c[3];
      alu_c8 <= alu_sh ? alu[0] : c[7];
      alu_c  <= alu_sh ? alu[0] : (~c[7] ^ pl[11]);
      alu_v  <= c[6] ^ c[7];
   end
   if (c3)
   begin
      //
      // OR functions
      //
      ax[0] <= fa[0] ? (fb[0] ? pl[6] : pl[5]) : (fb[0] ? pl[4] : pl[3]);
      ax[1] <= fa[1] ? (fb[1] ? pl[6] : pl[5]) : (fb[1] ? pl[4] : pl[3]);
      ax[2] <= fa[2] ? (fb[2] ? pl[6] : pl[5]) : (fb[2] ? pl[4] : pl[3]);
      ax[3] <= fa[3] ? (fb[3] ? pl[6] : pl[5]) : (fb[3] ? pl[4] : pl[3]);
      ax[4] <= fa[4] ? (fb[4] ? pl[6] : pl[5]) : (fb[4] ? pl[4] : pl[3]);
      ax[5] <= fa[5] ? (fb[5] ? pl[6] : pl[5]) : (fb[5] ? pl[4] : pl[3]);
      ax[6] <= fa[6] ? (fb[6] ? pl[6] : pl[5]) : (fb[6] ? pl[4] : pl[3]);
      ax[7] <= fa[7] ? (fb[7] ? pl[6] : pl[5]) : (fb[7] ? pl[4] : pl[3]);
      //
      // AND functions
      //
      ay[0] <= fa[0] ? (fb[0] ? pl[0] : pl[1]) : (fb[0] ? pl[2] : 1'b0);
      ay[1] <= fa[1] ? (fb[1] ? pl[0] : pl[1]) : (fb[1] ? pl[2] : 1'b0);
      ay[2] <= fa[2] ? (fb[2] ? pl[0] : pl[1]) : (fb[2] ? pl[2] : 1'b0);
      ay[3] <= fa[3] ? (fb[3] ? pl[0] : pl[1]) : (fb[3] ? pl[2] : 1'b0);
      ay[4] <= fa[4] ? (fb[4] ? pl[0] : pl[1]) : (fb[4] ? pl[2] : 1'b0);
      ay[5] <= fa[5] ? (fb[5] ? pl[0] : pl[1]) : (fb[5] ? pl[2] : 1'b0);
      ay[6] <= fa[6] ? (fb[6] ? pl[0] : pl[1]) : (fb[6] ? pl[2] : 1'b0);
      ay[7] <= fa[7] ? (fb[7] ? pl[0] : pl[1]) : (fb[7] ? pl[2] : 1'b0);
   end
   if (c4)
   begin
      //
      // Carry chain pl[13] is external carry (+1), pl[14] ic c[0] carry (+2)
      //
      c[0] <= ay[0] | ax[0] & pl[13] | pl[14];
      c[1] <= ay[1] | ax[1] & c[0];
      c[2] <= ay[2] | ax[2] & c[1];
      c[3] <= ay[3] | ax[3] & c[2];
      c[4] <= ay[4] | ax[4] & c[3] & ~dmi[3];
      c[5] <= ay[5] | ax[5] & c[4];
      c[6] <= ay[6] | ax[6] & c[5];
      c[7] <= ay[7] | ax[7] & c[6];
      //
      // Summ output
      //
      alu[0] <= pl[13] ^ ax[0];
      alu[1] <= c[0] ^ ax[1];
      alu[2] <= c[1] ^ ax[2];
      alu[3] <= c[2] ^ ax[3];
      alu[4] <= (c[3] & ~dmi[3]) ^ ax[4];
      alu[5] <= c[4] ^ ax[5];
      alu[6] <= c[5] ^ ax[6];
      alu[7] <= c[6] ^ ax[7];
   end
end

//______________________________________________________________________________
//
// Microinstruction bus and register
//
assign pin_m_n = mi_out;

always @(*)
begin
   if (c4)
      m04rs <= ~pl[12] & ~pin_wi;
   if (c1)
   begin
      dir_c1[15:5] <= m_in ? ~pin_m_n[15:5] : dir[15:5];
      dir_c1[3:1] <= m_in ? ~pin_m_n[3:1] : dir[3:1];
      //
      // Modify microinstruction register for 16-bit ALU operations
      //
      dir_c1[0] <= m04rs ? ~dir[0] : (m_in ? ~pin_m_n[0] : dir[0]);
      dir_c1[4] <= m04rs ? ~dir[4] : (m_in ? ~pin_m_n[4] : dir[4]);
   end
   if (c2)
      dir[15:0] <= dir_c1[15:0];
   if (c1)
   begin
      //
      // Discharge microinstruction bus lines to low
      //
      mi_out[0]  <= (mo_ad & pin_ad[0]  | mo_fa & fa[0]) ? 1'b0 : 1'bz;
      mi_out[1]  <= (mo_ad & pin_ad[1]  | mo_fa & fa[1]) ? 1'b0 : 1'bz;
      mi_out[2]  <= (mo_ad & pin_ad[2]  | mo_fa & fa[2]) ? 1'b0 : 1'bz;
      mi_out[3]  <= (mo_ad & pin_ad[3]  | mo_fa & fa[3]) ? 1'b0 : 1'bz;
      mi_out[4]  <= (mo_ad & pin_ad[4]  | mo_fa & fa[4]) ? 1'b0 : 1'bz;
      mi_out[5]  <= (mo_ad & pin_ad[5]  | mo_fa & fa[5]) ? 1'b0 : 1'bz;
      mi_out[6]  <= (mo_ad & pin_ad[6]  | mo_fa & fa[6]) ? 1'b0 : 1'bz;
      mi_out[7]  <= (mo_ad & pin_ad[7]  | mo_fa & fa[7]) ? 1'b0 : 1'bz;
      mi_out[8]  <= (mo_ad & pin_ad[8]  | mo_fa & fb[0]) ? 1'b0 : 1'bz;
      mi_out[9]  <= (mo_ad & pin_ad[9]  | mo_fa & fb[1]) ? 1'b0 : 1'bz;
      mi_out[10] <= (mo_ad & pin_ad[10] | mo_fa & fb[2]) ? 1'b0 : 1'bz;
      mi_out[11] <= (mo_ad & pin_ad[11] | mo_fa & fb[3]) ? 1'b0 : 1'bz;
      mi_out[12] <= (mo_ad & pin_ad[12] | mo_fa & fb[4]) ? 1'b0 : 1'bz;
      mi_out[13] <= (mo_ad & pin_ad[13] | mo_fa & fb[5]) ? 1'b0 : 1'bz;
      mi_out[14] <= (mo_ad & pin_ad[14] | mo_fa & fb[6]) ? 1'b0 : 1'bz;
      mi_out[15] <= (mo_ad & pin_ad[15] | mo_fa & fb[7]) ? 1'b0 : 1'bz;
   end
   if (c2)
      mi_out[15:0] <= 16'hzzzz;
   if (c4)
      mi_out[15] <= jm15 ? 1'b0 : 1'bz;

end

//______________________________________________________________________________
//
// Decoding jump microinstruction array for 1611 (Data Chip)
//
mcp_plj plj
(
   .inpl(inpl),         // input enable
   .icc(jump),          // indirect condition code
   .psw(psw),           // PSW flags
   .mir(dir[15:8]),     // microinstruction
   .jump(jm15)          // jump condition met
);

//______________________________________________________________________________
//
// PDP-11 conditional branch instruction matrix
// Generates indirect condition code
//
mcp_plb plb
(
   .dal(dal),           // PDP-11 branch opcode
   .psw(psw),           // processor status word
   .jump(jbxx)          // jump taken
);

always @(*) if (c1 & mo_ad) jump <= jbxx;
//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
mcp_pli pli
(
   .inpl(inpl),         // input enable
   .mir(dir[15:8]),     // microinstruction
   .dmi(dmi_pl[10:0])   // decoded output
);

always @(*) if (c3) dmi <= dmi_pl;
//______________________________________________________________________________
//
// Decoding microinstruction array for 1611 (Data Chip)
//
mcp_pld pld
(
   .inpl(inpl),         // input enable
   .psw(psw),           // processor status word
   .mir(dir[15:0]),     // microinstruction
   .pld(pl_pld[20:0])   // matrix output, C3 latch
);

always @(*) if (c3) pl <= pl_pld;
//______________________________________________________________________________
//
endmodule
