//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// DC304 MMU and Register Chip model, for debug and simulating only
//_____________________________________________________________________________
//
`timescale 1ns / 100ps

module dc304
(
   input          pin_clk,    // main clock
   inout  [15:0]  pin_ad,     // address/data bus
   output [21:16] pin_a,      // high address bus
   output         pin_bso,    // bus select output
   input          pin_bsi,    // bus select input
   input  [12:4]  pin_m,      // microinstruction bus
   inout          pin_m15,    // address conversion flag
   output         pin_me_n,   // mapping enabled
   output         pin_ra_n,   // register access reply
   output         pin_de_n,   // invalid memory access
   input          pin_ez_n    // enable Z-state
);

//______________________________________________________________________________
//
wire        clk;              // primary clock
                              //
reg  [12:4] m;                // microinstuction register
wire [12:4] mi;               // microinstruction bus inputs
reg  [15:0] di;               // data word input register
wire [15:0] d;                // data bus multiplexer
reg  [21:16] a;               // high address lines
reg  [15:13] la;              // page address latch
reg  mi4c, mi5c;              //
reg  mi7c, mi9c;              //
                              //
reg  synct;                   //
wire sync;                    //
wire hoe, doe;                // A/D output enable
wire wl, wh;                  // write from DI register output
wire pae;                     // physical address enable
                              //
wire ez;                      // disable A/D outputs
reg  ezc;                     // latched A/D disable
wire astb, astbc;             // address strobe microinstruction
reg  astbd;                   // address strobe microinstruction
reg  atreq;                   // address translation request
wire di_stb;                  // A/D bus input register strobe (address)
                              //
reg  sa_7572;                 // SR0 address decoded on A/D bus
reg  sa_7574;                 // SR1 address decoded on A/D bus
reg  sa_7576;                 // SR2 address decoded on A/D bus
reg  sa_2516;                 // SR3 address decoded on A/D bus
reg  sa_23xx;                 // kernel set address decoded on A/D bus
reg  sa_76xx;                 // user set address decoded on A/D bus
reg  [5:0] ba;                // latched bus access address VA/PA
wire mr_sel;                  // MMU register access on A/D bus
reg  [3:0] ma;                // MMU register index
                              //
reg trans;                    //
wire rlat_en, rlat;           //
reg [3:0] id;                 //
reg fp_selt;                  //
wire fp_sel;                  //
                              //
wire fa_m765;                 // FPP register index m[7:5]
wire fa_s210;                 // FPP register index ir[2:0] - fsrc/fdst
wire fa_s076;                 // FPP register index ir[7:6] - ac
reg [4:0] fa;                 // FPP register index
                              //
wire en_um;                   // UMAP translate
wire en_as;                   // AS, 22-bit address
wire mmu_en;                  // MMU enable
wire m15;                     // ack MMU address conversion
wire rply;                    // reply MMU register access
wire bso;                     //
reg bsc, bsi;                 //
                              //
reg [7:0] fa_mux;             //
reg fa_amux, fa_bmux, fa0t;   //
reg mi_rst, km_sel;           //
wire sr_rst;                  //
wire w_set;                   // W (dirty page) flag set
reg  w_clr;                   // W (dirty page) flag clear
                              //
wire [15:0] da;               //
wire [15:0] db;               //
reg  [15:0] fpa[0:17];        //
reg  [15:0] fpb[0:17];        //
reg  [15:0] par[0:15];        //
reg  [15:0] pdr[0:15];        //
wire [17:0] fs;               //
wire [15:0] ms;               //
                              //
wire err_stb;                 //
wire sta_stb;                 //
reg  [3:1] tpage;             //
reg  [15:0] sr0;              //
reg  [15:0] sr2;              //
reg  [15:0] sr3;              //
reg  sr0_rw, sr2_rw, sr3_rw;  //
wire sr0_rd, sr2_rd, sr3_rd;  //
                              //
wire derr;                    //
wire abt_ro, req_ro;          // aborted on readonly
wire abt_le, req_le;          // aborted on limit exceeded
wire abt_nr, req_nr;          // aborted on non-resident
reg abt;                      //
                              //
wire ab_sel;                  // A/B register bus selection
reg ma_ena, mb_ena;           //
reg fr_ena;                   //
wire ra_ena, rb_ena;          //
wire rs_ena;                  //
reg st_2376;                  //
                              //
wire [21:6] sa;               // physical address adder
reg  [15:7] pars;             // PAR upper bits latch
wire [14:0] ac;               // adder carries
reg  [6:0] s;                 // adder half summs
reg  [6:0] an;                //
reg  [12:6] sx;               // comparator argument
reg  [12:6] sm;               //
                              //
wire alu_st, lim_up, lim_dn;  //
wire lim_err;                 //
                              //
//______________________________________________________________________________
//
assign clk = pin_clk;         // primary clock
wire #1 sim_dclk = clk;       // suppress simulation glitches

assign mi[12:4] = pin_m[12:4];
always @(*) if (~clk) m[12:4] <= pin_m[12:4];
always @(*) if (clk | di_stb) di <= pin_ad;
always @(*) if (clk) la[15:13] <= pin_ad[15:13];

assign doe =  clk & ~ez & mi[12] & mi[9] & ~mi[8]
                  & (mr_sel | ~synct & (m[6] | m[5])) // MMU/FPP register read
           | ~clk & ~ezc & ~derr & atreq;             // PA address output
assign hoe = doe | err_stb;
assign m15 = clk & astb & mmu_en & ~m[7];
assign rply = clk & mr_sel & mi[12] & (~mi[8] | ~mi[9]);

assign pin_ad[15:13] = hoe ? d[15:13] : 3'oZ;
assign pin_ad[12:0] = doe ? d[12:0] : 13'oZZZZZ;
assign pin_a[21:16] = (doe & ~clk) ? a[21:16] : 6'oZZ;

assign pin_m15  = m15 ? 1'b0 : 1'bz;
assign pin_me_n = en_um ? 1'b0 : 1'bz;
assign pin_ra_n = rply ? 1'b0 : 1'bz;
assign pin_de_n = clk | ~derr;
assign pin_bso   = doe & bso;

//______________________________________________________________________________
//
// Internal bus multiplexer
//
assign d[15:0] = (wh ? {di[15:8], 8'o000} : 16'o000000)
               | (wl ? {8'o000, di[7:0]}  : 16'o000000)
               | (err_stb ? {req_nr, req_le, req_ro, 13'o00000} : 16'o000000)
               | (sr0_rd ? sr0[15:0] : 16'o000000)
               | (sr2_rd ? sr2[15:0] : 16'o000000)
               | (sr3_rd ? sr3[15:0] : 16'o000000)
               | (pae ? {sa[15:6], ba[5:0]} : 16'o000000)
               | (ra_ena ? da : 16'o000000)
               | (rb_ena ? db : 16'o000000);

assign wl = ~clk & ~trans & (id[2] | fa_amux | fa_bmux);
assign wh = ~clk & ~trans & (id[3] | fa_amux | fa_bmux);

//______________________________________________________________________________
//
assign ez = ~pin_ez_n;
always @(*) if (clk) ezc <= ~pin_ez_n;

assign astb = ~mi[12] & m[12] & clk & sim_dclk;
assign astbc = astbd & ~clk;
assign di_stb = ~clk & ezc & astbd;
always @(*) if (clk) astbd <= astb;
always @(*) if (clk) atreq <= astb & mmu_en & ~m[7];

always @(*)
begin
   if (clk)
      trans <= 1'b0;
   else
      if (atreq & rlat_en)
         #5 trans <= 1'b1;
end

assign rlat = clk | (~trans & atreq & ~ezc);
assign rlat_en = rlat & (rs_ena | fr_ena);

//______________________________________________________________________________
//
always @(*)
begin
   if (clk)
   begin
      id[0] = mi[12] & ~mi[9];         // write data
      id[1] = mi[12] & mi[9] & ~mi[8]; // read data
      id[2] = astb
            | mr_sel & mi[12] & ~mi[9] & ~mi[8] & ~ba[0] // write low byte
            | mr_sel & mi[12] & ~mi[9] &  mi[8]          // write word
            | ~synct & mi[12] & ~mi[9] & fp_sel;         // write FPP register
      id[3] = astb
            | mr_sel & mi[12] & ~mi[9] & ~mi[8] &  ba[0] // write high byte
            | mr_sel & mi[12] & ~mi[9] &  mi[8]          // write word
            | ~synct & mi[12] & ~mi[9] & fp_sel;         // write FPP register
   end
end

always @(*) if (clk) mi_rst <= (~mi[4] & ~mi[5] & mi[6] & m[7]) & sim_dclk;
always @(*) if (clk) km_sel <= ~mi[4] | ~mi[5] | mi[6];  // kernel mode
always @(*) if (clk) fp_selt <= ~mr_sel & (m[5] | m[6]); // fpp select
assign sr_rst = ~clk & ~mi9c & mi_rst;
assign fp_sel = fp_selt & mi5c & mi4c;

//______________________________________________________________________________
//
// MMU resister access from the bus transactions (read/write by PDP-11 CPU)
//
always @(*)
begin
   if (clk)
   begin
      mi4c <= mi[4];
      mi5c <= mi[5];
      mi7c <= mi[7];
      mi9c <= mi[9];
   end
end

always @(negedge clk) synct <= ~mi7c;
assign sync = clk | ~mi7c;

always @(*)
begin
   if (~sync)
   begin
      ba[5:0] <= 6'o00;
      sa_7572 <= 1'b0;
      sa_7574 <= 1'b0;
      sa_7576 <= 1'b0;
      sa_2516 <= 1'b0;
      sa_23xx <= 1'b0;
      sa_76xx <= 1'b0;
   end
   else
   begin
      if (astbc)
      begin
         ba[5:0] <= d[5:0];
         sa_7572 <= bsc & (d[12:1] == (13'o17572 >> 1)); // SR0 access
         sa_7574 <= bsc & (d[12:1] == (13'o17574 >> 1)); // SR1 access
         sa_7576 <= bsc & (d[12:1] == (13'o17576 >> 1)); // SR2 access
         sa_2516 <= bsc & (d[12:1] == (13'o12516 >> 1)); // SR3 access
         sa_23xx <= bsc & (d[12:6] == 7'o123) & ~d[4];   // kernel set
         sa_76xx <= bsc & (d[12:6] == 7'o176) & ~d[4];   // user set
      end
   end
end

assign mr_sel = sa_7572 | sa_7574 | sa_7576
              | sa_2516 | sa_23xx | sa_76xx;

assign bso = doe & (~en_as | sa[21:18] == 4'b1111) & (sa[17:13] == 5'b11111);
always @(*) if (clk | di_stb) bsi <= pin_bsi;
always @(*)
begin
   if (wh) bsc <= bsi;
   if (pae) bsc <= bso;
end

//______________________________________________________________________________
//
// Floating point register indices
//
assign fa_m765 = ~m[7] | ~m[6];        // FPP register in m[7:5]
assign fa_s210 = m[7] & m[6] & ~m[5];  // FPP register in ir[2:0] - fsrc/fdst
assign fa_s076 = m[7] & m[6] & m[5];   // FPP register in ir[7:6] - ac

always @(*) if (clk) fa_amux <= mi[4] & ~mi[5] & ~mi[6] &  m[4];
always @(*) if (clk) fa_bmux <= mi[4] & ~mi[5] & ~mi[6] & ~m[4];

always @(*)
begin
   if (~clk)
   begin
      if (fa_amux) fa_mux[7:0] <= da[7:0];
      if (fa_bmux) fa_mux[7:0] <= db[7:0];
   end
end

always @(*)
begin
   if (clk & sim_dclk)
   begin
      fa[0] <= fa0t;
      if (fa_m765) fa[3:1] <= {~m[7], m[6:5]};
      if (fa_s210) fa[3:1] <= fa_mux[2:0];
      if (fa_s076) fa[3:1] <= {1'b0, fa_mux[7:6]};
      fa[4] <= ~m[6];
   end
   if (~clk)
   begin
      if (fa_amux | fa_bmux)
         fa0t <= 1'b0;
      else
         if (fp_sel & ~fa[4] & (id[0] | id[1]))
            fa0t <= ~fa[0];
   end
end

assign fs[0]  = fr_ena & (fa[4:0] == 5'b00000);
assign fs[1]  = fr_ena & (fa[4:0] == 5'b00001);
assign fs[2]  = fr_ena & (fa[4:0] == 5'b00010);
assign fs[3]  = fr_ena & (fa[4:0] == 5'b00011);
assign fs[4]  = fr_ena & (fa[4:0] == 5'b00100);
assign fs[5]  = fr_ena & (fa[4:0] == 5'b00101);
assign fs[6]  = fr_ena & (fa[4:0] == 5'b00110);
assign fs[7]  = fr_ena & (fa[4:0] == 5'b00111);
assign fs[8]  = fr_ena & (fa[4:0] == 5'b01000);
assign fs[9]  = fr_ena & (fa[4:0] == 5'b01001);
assign fs[10] = fr_ena & (fa[4:0] == 5'b01010);
assign fs[11] = fr_ena & (fa[4:0] == 5'b01011);
assign fs[12] = fr_ena & (fa[4:0] == 5'b01100);
assign fs[13] = fr_ena & (fa[4:0] == 5'b01101);
assign fs[14] = fr_ena & (fa[4:0] == 5'b01110);
assign fs[15] = fr_ena & (fa[4:0] == 5'b01111);
assign fs[16] = fr_ena & fa[4] & ~fa[3] & fa[1];
assign fs[17] = fr_ena & fa[4] &  fa[3] & fa[1];

//______________________________________________________________________________
//
// W bit - dirty page logic
//
assign w_set = ~mr_sel & ~derr & ~mi9c & atreq & trans;
always @(*) if (clk) w_clr <= mi[12] & ~mi[9] & mr_sel & (sa_23xx | sa_76xx);

always @(*)
begin
   if (w_set)
   begin
         if (ms[0])  pdr[0][6]  <= 1'b1;
         if (ms[1])  pdr[1][6]  <= 1'b1;
         if (ms[2])  pdr[2][6]  <= 1'b1;
         if (ms[3])  pdr[3][6]  <= 1'b1;
         if (ms[4])  pdr[4][6]  <= 1'b1;
         if (ms[5])  pdr[5][6]  <= 1'b1;
         if (ms[6])  pdr[6][6]  <= 1'b1;
         if (ms[7])  pdr[7][6]  <= 1'b1;
         if (ms[8])  pdr[8][6]  <= 1'b1;
         if (ms[9])  pdr[9][6]  <= 1'b1;
         if (ms[10]) pdr[10][6] <= 1'b1;
         if (ms[11]) pdr[11][6] <= 1'b1;
         if (ms[12]) pdr[12][6] <= 1'b1;
         if (ms[13]) pdr[13][6] <= 1'b1;
         if (ms[14]) pdr[14][6] <= 1'b1;
         if (ms[15]) pdr[15][6] <= 1'b1;
   end
   else
      if (w_clr)
      begin
         if (ms[0])  pdr[0][6]  <= 1'b0;
         if (ms[1])  pdr[1][6]  <= 1'b0;
         if (ms[2])  pdr[2][6]  <= 1'b0;
         if (ms[3])  pdr[3][6]  <= 1'b0;
         if (ms[4])  pdr[4][6]  <= 1'b0;
         if (ms[5])  pdr[5][6]  <= 1'b0;
         if (ms[6])  pdr[6][6]  <= 1'b0;
         if (ms[7])  pdr[7][6]  <= 1'b0;
         if (ms[8])  pdr[8][6]  <= 1'b0;
         if (ms[9])  pdr[9][6]  <= 1'b0;
         if (ms[10]) pdr[10][6] <= 1'b0;
         if (ms[11]) pdr[11][6] <= 1'b0;
         if (ms[12]) pdr[12][6] <= 1'b0;
         if (ms[13]) pdr[13][6] <= 1'b0;
         if (ms[14]) pdr[14][6] <= 1'b0;
         if (ms[15]) pdr[15][6] <= 1'b0;
      end
end

//______________________________________________________________________________
//
// SRx MMU registers write logic
//
assign sr0_rd = clk & sa_7572;
assign sr2_rd = clk & sa_7576;
assign sr3_rd = clk & sa_2516;

always @(*) if (~trans) tpage[3:1] <= d[15:13];
always @(*)
begin
   if (clk)
   begin
      sr0_rw <= sa_7572;
      sr2_rw <= astb & m[5] & ~abt;
      sr3_rw <= sa_2516;
   end
end

always @(*)
begin
   if (clk)
   begin
      sr0[4] <= 1'b0;         // unused bits of SR0
      sr0[12:7] <= 1'b0;
   end
   if (sr_rst)
      sr0[15:0] <= 16'o000000;
   else
   begin
      if (wh & sr0_rw)
         sr0[15:13] <= di[15:13];
      else
         if (err_stb)
            sr0[15:13] <= {req_nr, req_le, req_ro};
      if (wl & sr0_rw)
         sr0[0] <= di[0];
      if (sta_stb)
      begin
         sr0[3:1] <= tpage[3:1];
         sr0[6:5] <= {~km_sel, ~km_sel};
      end
   end
end

always @(*)
begin
   if (wh & sr2_rw & ~trans)
      sr2[15:8] <= di[15:8];
   if (wl & sr2_rw & ~trans)
      sr2[7:0] <= di[7:0];
end

always @(*)
begin
   if (clk)
   begin
      sr3[3:0] <= 4'o00;      // unused bits of SR3
      sr3[15:6] <= 10'o0000;
   end
   if (sr_rst)
      sr3[5:4] <= 2'b00;
   else
      if (wl & sr3_rw)
         sr3[5:4] <= di[5:4];
end

assign mmu_en = sr0[0];
assign abt_ro = sr0[13];
assign abt_le = sr0[14];
assign abt_nr = sr0[15];
assign en_as  = sr3[4];
assign en_um  = sr3[5];

//______________________________________________________________________________
//
// MMU error logic
//
always @(*) if (clk) abt <= abt_ro | abt_le | abt_nr;
assign sta_stb = ~clk & ~abt & atreq;
assign err_stb = ~clk & sta_stb & trans & derr;
assign derr = ~clk & ~ezc & (req_ro | req_le | req_nr);

assign req_nr = atreq & ~db[1];
assign req_ro = atreq & db[1] & ~db[2] & ~mi9c;
assign req_le = atreq & lim_err;

//______________________________________________________________________________
//
// MMU register file indices
//
assign ab_sel = mr_sel ? ba[5] : m[4];
always @(*) if (clk) st_2376 <=  sa_23xx | sa_76xx;
always @(*) if (clk) fr_ena <= ~astb & ~mr_sel;
always @(*) if (clk) ma_ena <= ~astb & (~mr_sel | sa_23xx | sa_76xx) & ab_sel;
always @(*) if (clk) mb_ena <= ~astb & (~mr_sel | sa_23xx | sa_76xx) & ~ab_sel;
assign ra_ena = ma_ena & (~rlat | rlat_en);
assign rb_ena = mb_ena & (~rlat | rlat_en);
assign rs_ena = st_2376 | atreq & ~clk;

always @(*) if (clk) ma[3:0] <= mr_sel ? {sa_23xx, ba[3:1]} : {km_sel, la[15:13]};

assign ms[0]  = rs_ena & (ma[3:0] == 4'b0000);
assign ms[1]  = rs_ena & (ma[3:0] == 4'b0001);
assign ms[2]  = rs_ena & (ma[3:0] == 4'b0010);
assign ms[3]  = rs_ena & (ma[3:0] == 4'b0011);
assign ms[4]  = rs_ena & (ma[3:0] == 4'b0100);
assign ms[5]  = rs_ena & (ma[3:0] == 4'b0101);
assign ms[6]  = rs_ena & (ma[3:0] == 4'b0110);
assign ms[7]  = rs_ena & (ma[3:0] == 4'b0111);
assign ms[8]  = rs_ena & (ma[3:0] == 4'b1000);
assign ms[9]  = rs_ena & (ma[3:0] == 4'b1001);
assign ms[10] = rs_ena & (ma[3:0] == 4'b1010);
assign ms[11] = rs_ena & (ma[3:0] == 4'b1011);
assign ms[12] = rs_ena & (ma[3:0] == 4'b1100);
assign ms[13] = rs_ena & (ma[3:0] == 4'b1101);
assign ms[14] = rs_ena & (ma[3:0] == 4'b1110);
assign ms[15] = rs_ena & (ma[3:0] == 4'b1111);

//______________________________________________________________________________
//
// Minimal required registers initalization, otherwise,
// undefined content would prevent simulation.
//
integer i;

initial
begin
   for (i=0; i<16; i = i + 1)
   begin
      fpa[i]  = 16'h0000;
      fpb[i]  = 16'h0000;
      par[i]  = 16'h0000;
      pdr[i]  = 16'h0000;
   end
   fpa[16] = 16'h0000;
   fpa[17] = 16'h0000;
   fpb[16] = 16'h0000;
   fpb[17] = 16'h0000;
   sr0 = 16'h0000;
end

//______________________________________________________________________________
//
// FPP and MMU register file write
//
always @(*)
begin
   if (wl)
   begin
      if (ra_ena)
      begin
         if (fs[0])  fpa[0][7:0]  <= di[7:0];
         if (fs[1])  fpa[1][7:0]  <= di[7:0];
         if (fs[2])  fpa[2][7:0]  <= di[7:0];
         if (fs[3])  fpa[3][7:0]  <= di[7:0];
         if (fs[4])  fpa[4][7:0]  <= di[7:0];
         if (fs[5])  fpa[5][7:0]  <= di[7:0];
         if (fs[6])  fpa[6][7:0]  <= di[7:0];
         if (fs[7])  fpa[7][7:0]  <= di[7:0];
         if (fs[8])  fpa[8][7:0]  <= di[7:0];
         if (fs[9])  fpa[9][7:0]  <= di[7:0];
         if (fs[10]) fpa[10][7:0] <= di[7:0];
         if (fs[11]) fpa[11][7:0] <= di[7:0];
         if (fs[12]) fpa[12][7:0] <= di[7:0];
         if (fs[13]) fpa[13][7:0] <= di[7:0];
         if (fs[14]) fpa[14][7:0] <= di[7:0];
         if (fs[15]) fpa[15][7:0] <= di[7:0];
         if (fs[16]) fpa[16][7:0] <= di[7:0];
         if (fs[17]) fpa[17][7:0] <= di[7:0];

         if (ms[0])  par[0][7:0]  <= di[7:0];
         if (ms[1])  par[1][7:0]  <= di[7:0];
         if (ms[2])  par[2][7:0]  <= di[7:0];
         if (ms[3])  par[3][7:0]  <= di[7:0];
         if (ms[4])  par[4][7:0]  <= di[7:0];
         if (ms[5])  par[5][7:0]  <= di[7:0];
         if (ms[6])  par[6][7:0]  <= di[7:0];
         if (ms[7])  par[7][7:0]  <= di[7:0];
         if (ms[8])  par[8][7:0]  <= di[7:0];
         if (ms[9])  par[9][7:0]  <= di[7:0];
         if (ms[10]) par[10][7:0] <= di[7:0];
         if (ms[11]) par[11][7:0] <= di[7:0];
         if (ms[12]) par[12][7:0] <= di[7:0];
         if (ms[13]) par[13][7:0] <= di[7:0];
         if (ms[14]) par[14][7:0] <= di[7:0];
         if (ms[15]) par[15][7:0] <= di[7:0];
      end
      if (rb_ena)
      begin
         if (fs[0])  fpb[0][7:0]  <= di[7:0];
         if (fs[1])  fpb[1][7:0]  <= di[7:0];
         if (fs[2])  fpb[2][7:0]  <= di[7:0];
         if (fs[3])  fpb[3][7:0]  <= di[7:0];
         if (fs[4])  fpb[4][7:0]  <= di[7:0];
         if (fs[5])  fpb[5][7:0]  <= di[7:0];
         if (fs[6])  fpb[6][7:0]  <= di[7:0];
         if (fs[7])  fpb[7][7:0]  <= di[7:0];
         if (fs[8])  fpb[8][7:0]  <= di[7:0];
         if (fs[9])  fpb[9][7:0]  <= di[7:0];
         if (fs[10]) fpb[10][7:0] <= di[7:0];
         if (fs[11]) fpb[11][7:0] <= di[7:0];
         if (fs[12]) fpb[12][7:0] <= di[7:0];
         if (fs[13]) fpb[13][7:0] <= di[7:0];
         if (fs[14]) fpb[14][7:0] <= di[7:0];
         if (fs[15]) fpb[15][7:0] <= di[7:0];
         if (fs[16]) fpb[16][7:0] <= di[7:0];
         if (fs[17]) fpb[17][7:0] <= di[7:0];

         if (ms[0])  pdr[0][3:1]  <= di[3:1];
         if (ms[1])  pdr[1][3:1]  <= di[3:1];
         if (ms[2])  pdr[2][3:1]  <= di[3:1];
         if (ms[3])  pdr[3][3:1]  <= di[3:1];
         if (ms[4])  pdr[4][3:1]  <= di[3:1];
         if (ms[5])  pdr[5][3:1]  <= di[3:1];
         if (ms[6])  pdr[6][3:1]  <= di[3:1];
         if (ms[7])  pdr[7][3:1]  <= di[3:1];
         if (ms[8])  pdr[8][3:1]  <= di[3:1];
         if (ms[9])  pdr[9][3:1]  <= di[3:1];
         if (ms[10]) pdr[10][3:1] <= di[3:1];
         if (ms[11]) pdr[11][3:1] <= di[3:1];
         if (ms[12]) pdr[12][3:1] <= di[3:1];
         if (ms[13]) pdr[13][3:1] <= di[3:1];
         if (ms[14]) pdr[14][3:1] <= di[3:1];
         if (ms[15]) pdr[15][3:1] <= di[3:1];
      end
   end
   if (wh)
   begin
      if (ra_ena)
      begin
         if (fs[0])  fpa[0][15:8]  <= di[15:8];
         if (fs[1])  fpa[1][15:8]  <= di[15:8];
         if (fs[2])  fpa[2][15:8]  <= di[15:8];
         if (fs[3])  fpa[3][15:8]  <= di[15:8];
         if (fs[4])  fpa[4][15:8]  <= di[15:8];
         if (fs[5])  fpa[5][15:8]  <= di[15:8];
         if (fs[6])  fpa[6][15:8]  <= di[15:8];
         if (fs[7])  fpa[7][15:8]  <= di[15:8];
         if (fs[8])  fpa[8][15:8]  <= di[15:8];
         if (fs[9])  fpa[9][15:8]  <= di[15:8];
         if (fs[10]) fpa[10][15:8] <= di[15:8];
         if (fs[11]) fpa[11][15:8] <= di[15:8];
         if (fs[12]) fpa[12][15:8] <= di[15:8];
         if (fs[13]) fpa[13][15:8] <= di[15:8];
         if (fs[14]) fpa[14][15:8] <= di[15:8];
         if (fs[15]) fpa[15][15:8] <= di[15:8];
         if (fs[16]) fpa[16][15:8] <= di[15:8];
         if (fs[17]) fpa[17][15:8] <= di[15:8];

         if (ms[0])  par[0][15:8]  <= di[15:8];
         if (ms[1])  par[1][15:8]  <= di[15:8];
         if (ms[2])  par[2][15:8]  <= di[15:8];
         if (ms[3])  par[3][15:8]  <= di[15:8];
         if (ms[4])  par[4][15:8]  <= di[15:8];
         if (ms[5])  par[5][15:8]  <= di[15:8];
         if (ms[6])  par[6][15:8]  <= di[15:8];
         if (ms[7])  par[7][15:8]  <= di[15:8];
         if (ms[8])  par[8][15:8]  <= di[15:8];
         if (ms[9])  par[9][15:8]  <= di[15:8];
         if (ms[10]) par[10][15:8] <= di[15:8];
         if (ms[11]) par[11][15:8] <= di[15:8];
         if (ms[12]) par[12][15:8] <= di[15:8];
         if (ms[13]) par[13][15:8] <= di[15:8];
         if (ms[14]) par[14][15:8] <= di[15:8];
         if (ms[15]) par[15][15:8] <= di[15:8];
      end
      if (rb_ena)
      begin
         if (fs[0])  fpb[0][15:8]  <= di[15:8];
         if (fs[1])  fpb[1][15:8]  <= di[15:8];
         if (fs[2])  fpb[2][15:8]  <= di[15:8];
         if (fs[3])  fpb[3][15:8]  <= di[15:8];
         if (fs[4])  fpb[4][15:8]  <= di[15:8];
         if (fs[5])  fpb[5][15:8]  <= di[15:8];
         if (fs[6])  fpb[6][15:8]  <= di[15:8];
         if (fs[7])  fpb[7][15:8]  <= di[15:8];
         if (fs[8])  fpb[8][15:8]  <= di[15:8];
         if (fs[9])  fpb[9][15:8]  <= di[15:8];
         if (fs[10]) fpb[10][15:8] <= di[15:8];
         if (fs[11]) fpb[11][15:8] <= di[15:8];
         if (fs[12]) fpb[12][15:8] <= di[15:8];
         if (fs[13]) fpb[13][15:8] <= di[15:8];
         if (fs[14]) fpb[14][15:8] <= di[15:8];
         if (fs[15]) fpb[15][15:8] <= di[15:8];
         if (fs[16]) fpb[16][15:8] <= di[15:8];
         if (fs[17]) fpb[17][15:8] <= di[15:8];

         if (ms[0])  pdr[0][14:8]  <= di[14:8];
         if (ms[1])  pdr[1][14:8]  <= di[14:8];
         if (ms[2])  pdr[2][14:8]  <= di[14:8];
         if (ms[3])  pdr[3][14:8]  <= di[14:8];
         if (ms[4])  pdr[4][14:8]  <= di[14:8];
         if (ms[5])  pdr[5][14:8]  <= di[14:8];
         if (ms[6])  pdr[6][14:8]  <= di[14:8];
         if (ms[7])  pdr[7][14:8]  <= di[14:8];
         if (ms[8])  pdr[8][14:8]  <= di[14:8];
         if (ms[9])  pdr[9][14:8]  <= di[14:8];
         if (ms[10]) pdr[10][14:8] <= di[14:8];
         if (ms[11]) pdr[11][14:8] <= di[14:8];
         if (ms[12]) pdr[12][14:8] <= di[14:8];
         if (ms[13]) pdr[13][14:8] <= di[14:8];
         if (ms[14]) pdr[14][14:8] <= di[14:8];
         if (ms[15]) pdr[15][14:8] <= di[14:8];
      end
   end
end

//______________________________________________________________________________
//
// FPP and MMU register file mux
//
assign da = (fs[0]  ? fpa[0]  : 16'o000000)
          | (fs[1]  ? fpa[1]  : 16'o000000)
          | (fs[2]  ? fpa[2]  : 16'o000000)
          | (fs[3]  ? fpa[3]  : 16'o000000)
          | (fs[4]  ? fpa[4]  : 16'o000000)
          | (fs[5]  ? fpa[5]  : 16'o000000)
          | (fs[6]  ? fpa[6]  : 16'o000000)
          | (fs[7]  ? fpa[7]  : 16'o000000)
          | (fs[8]  ? fpa[8]  : 16'o000000)
          | (fs[9]  ? fpa[9]  : 16'o000000)
          | (fs[10] ? fpa[10] : 16'o000000)
          | (fs[11] ? fpa[11] : 16'o000000)
          | (fs[12] ? fpa[12] : 16'o000000)
          | (fs[13] ? fpa[13] : 16'o000000)
          | (fs[14] ? fpa[14] : 16'o000000)
          | (fs[15] ? fpa[15] : 16'o000000)
          | (fs[16] ? fpa[16] : 16'o000000)
          | (fs[17] ? fpa[17] : 16'o000000)
          | (ms[0]  ? par[0]  : 16'o000000)
          | (ms[1]  ? par[1]  : 16'o000000)
          | (ms[2]  ? par[2]  : 16'o000000)
          | (ms[3]  ? par[3]  : 16'o000000)
          | (ms[4]  ? par[4]  : 16'o000000)
          | (ms[5]  ? par[5]  : 16'o000000)
          | (ms[6]  ? par[6]  : 16'o000000)
          | (ms[7]  ? par[7]  : 16'o000000)
          | (ms[8]  ? par[8]  : 16'o000000)
          | (ms[9]  ? par[9]  : 16'o000000)
          | (ms[10] ? par[10] : 16'o000000)
          | (ms[11] ? par[11] : 16'o000000)
          | (ms[12] ? par[12] : 16'o000000)
          | (ms[13] ? par[13] : 16'o000000)
          | (ms[14] ? par[14] : 16'o000000)
          | (ms[15] ? par[15] : 16'o000000)
          | (ra_ena ? {wh ? di[15:8] : 8'o000,
                       wl ? di[7:0]  : 8'o000} : 16'o000000);

assign db = (fs[0]  ? fpb[0]  : 16'o000000)
          | (fs[1]  ? fpb[1]  : 16'o000000)
          | (fs[2]  ? fpb[2]  : 16'o000000)
          | (fs[3]  ? fpb[3]  : 16'o000000)
          | (fs[4]  ? fpb[4]  : 16'o000000)
          | (fs[5]  ? fpb[5]  : 16'o000000)
          | (fs[6]  ? fpb[6]  : 16'o000000)
          | (fs[7]  ? fpb[7]  : 16'o000000)
          | (fs[8]  ? fpb[8]  : 16'o000000)
          | (fs[9]  ? fpb[9]  : 16'o000000)
          | (fs[10] ? fpb[10] : 16'o000000)
          | (fs[11] ? fpb[11] : 16'o000000)
          | (fs[12] ? fpb[12] : 16'o000000)
          | (fs[13] ? fpb[13] : 16'o000000)
          | (fs[14] ? fpb[14] : 16'o000000)
          | (fs[15] ? fpb[15] : 16'o000000)
          | (fs[16] ? fpb[16] : 16'o000000)
          | (fs[17] ? fpb[17] : 16'o000000)
          | (ms[0]  ? pdr[0]  & 16'o077516 : 16'o000000)
          | (ms[1]  ? pdr[1]  & 16'o077516 : 16'o000000)
          | (ms[2]  ? pdr[2]  & 16'o077516 : 16'o000000)
          | (ms[3]  ? pdr[3]  & 16'o077516 : 16'o000000)
          | (ms[4]  ? pdr[4]  & 16'o077516 : 16'o000000)
          | (ms[5]  ? pdr[5]  & 16'o077516 : 16'o000000)
          | (ms[6]  ? pdr[6]  & 16'o077516 : 16'o000000)
          | (ms[7]  ? pdr[7]  & 16'o077516 : 16'o000000)
          | (ms[8]  ? pdr[8]  & 16'o077516 : 16'o000000)
          | (ms[9]  ? pdr[9]  & 16'o077516 : 16'o000000)
          | (ms[10] ? pdr[10] & 16'o077516 : 16'o000000)
          | (ms[11] ? pdr[11] & 16'o077516 : 16'o000000)
          | (ms[12] ? pdr[12] & 16'o077516 : 16'o000000)
          | (ms[13] ? pdr[13] & 16'o077516 : 16'o000000)
          | (ms[14] ? pdr[14] & 16'o077516 : 16'o000000)
          | (ms[15] ? pdr[15] & 16'o077516 : 16'o000000)
          | (rb_ena ? {wh ? di[15:8] : 8'o000,
                       wl ? di[7:0]  : 8'o000} : 16'o000000);

//______________________________________________________________________________
//
// Address adder and comparator
//
assign pae = ~clk & ~derr & trans;
assign alu_st = ~clk & atreq & ~trans;
assign lim_up = alu_st & ~db[3];
assign lim_dn = alu_st & db[3];

always @(*) if (pae) a[21:16] <= sa[21:16];
always @(*) if (alu_st) pars[15:7] <= da[15:7];

assign sa[6]  = s[0];
assign sa[7]  = s[1] ^ ac[0];
assign sa[8]  = s[2] ^ ac[1];
assign sa[9]  = s[3] ^ ac[2];
assign sa[10] = s[4] ^ ac[3];
assign sa[11] = s[5] ^ ac[4];
assign sa[12] = s[6] ^ ac[5];

assign sa[13] = pars[7] ^ ac[6];
assign sa[14] = pars[8] ^ ac[7];
assign sa[15] = pars[9] ^ ac[8];
assign sa[16] = pars[10] ^ ac[9];
assign sa[17] = pars[11] ^ ac[10];
assign sa[18] = (pars[12] ^ ac[11]) & en_as;
assign sa[19] = (pars[13] ^ ac[12]) & en_as;
assign sa[20] = (pars[14] ^ ac[13]) & en_as;
assign sa[21] = (pars[15] ^ ac[14]) & en_as;

always @(*)
begin
   if (clk)
   begin
      s[6:0] <= 7'b0000000;
      an[6:0] <= 7'b0000000;
      sm[12:6] <= 7'b1111111;
      sx[12:6] <= 7'b0000000;
   end
   if (alu_st)
   begin
         s[0] <= da[0] ^ di[6];
         s[1] <= da[1] ^ di[7];
         s[2] <= da[2] ^ di[8];
         s[3] <= da[3] ^ di[9];
         s[4] <= da[4] ^ di[10];
         s[5] <= da[5] ^ di[11];
         s[6] <= da[6] ^ di[12];

         an[0] <= da[0] & di[6];
         an[1] <= da[1] & di[7];
         an[2] <= da[2] & di[8];
         an[3] <= da[3] & di[9];
         an[4] <= da[4] & di[10];
         an[5] <= da[5] & di[11];
         an[6] <= da[6] & di[12];

         sm[6]  <= db[8] ^ di[6];
         sm[7]  <= db[9] ^ di[7];
         sm[8]  <= db[10] ^ di[8];
         sm[9]  <= db[11] ^ di[9];
         sm[10] <= db[12] ^ di[10];
         sm[11] <= db[13] ^ di[11];
         sm[12] <= db[14] ^ di[12];

         sx[6]  <= lim_up & ~db[8] & di[6]   | lim_dn & db[8] & ~di[6];
         sx[7]  <= lim_up & ~db[9] & di[7]   | lim_dn & db[9] & ~di[7];
         sx[8]  <= lim_up & ~db[10] & di[8]  | lim_dn & db[10] & ~di[8];
         sx[9]  <= lim_up & ~db[11] & di[9]  | lim_dn & db[11] & ~di[9];
         sx[10] <= lim_up & ~db[12] & di[10] | lim_dn & db[12] & ~di[10];
         sx[11] <= lim_up & ~db[13] & di[11] | lim_dn & db[13] & ~di[11];
         sx[12] <= lim_up & ~db[14] & di[12] | lim_dn & db[14] & ~di[12];
   end
end

assign ac[0]  = an[0];
assign ac[1]  = ac[0] & s[1] | an[1];
assign ac[2]  = ac[1] & s[2] | an[2];
assign ac[3]  = ac[2] & s[3] | an[3];
assign ac[4]  = ac[3] & s[4] | an[4];
assign ac[5]  = ac[4] & s[5] | an[5];
assign ac[6]  = ac[5] & s[6] | an[6];
assign ac[7]  = ac[6] & pars[7];
assign ac[8]  = ac[7] & pars[8];
assign ac[9]  = ac[8] & pars[9];
assign ac[10] = ac[9] & pars[10];
assign ac[11] = ac[10] & pars[11];
assign ac[12] = ac[11] & pars[12];
assign ac[13] = ac[12] & pars[13];
assign ac[14] = ac[13] & pars[14];

assign lim_err = sx[12]
               | sx[11] & ~sm[12]
               | sx[10] & ~sm[12] & ~sm[11]
               | sx[9]  & ~sm[12] & ~sm[11] & ~sm[10]
               | sx[8]  & ~sm[12] & ~sm[11] & ~sm[10] & ~sm[9]
               | sx[7]  & ~sm[12] & ~sm[11] & ~sm[10] & ~sm[9] & ~sm[8]
               | sx[6]  & ~sm[12] & ~sm[11] & ~sm[10] & ~sm[9] & ~sm[8] & ~sm[7];

//______________________________________________________________________________
//
endmodule
