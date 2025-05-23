//
// Copyright (c) 2014-2025 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module t11
(
   input          pin_clk_p,     // processor clock, rising edge
   input          pin_clk_n,     // processor clock, falling edge
   input          pin_dclo,      // processor reset
   output         pin_bclr_n,    // bus clear
                                 //
   input  [15:0]  pin_ad_in,     // data bus input
   output [15:0]  pin_ad_out,    // address/data bus output
   output [1:0]   pin_sel,       // select output flag
   output [1:0]   pin_wb_n,      // read/write/byte mask
   input          pin_ready,     // bus ready
                                 //
   output         pin_ras_n,     //
   output         pin_cas_n,     //
   output         pin_pi,        // priority input strobe
                                 //
   input          pin_hlt_n,     // supervisor exception requests
   input          pin_pf_n,      // power fail notification
   input          pin_vec_n,     // vectored interrupt request
   input  [3:0]   pin_cp_n,      // coded interrupt priority
   input  [2:0]   pin_bsel       // start address selector
);

//______________________________________________________________________________
//
reg            t1, t2, t4;       // clock generator phases
reg            dclo;             //
reg            reset;            // power-up reset
reg            hwclr;            //
                                 //
wire  [15:0]   da;               // internal A/D bus
reg   [15:0]   dal;              // A/D bus output register
wire           da_stx;           //
wire           da_stl, da_sth;   // low/high byte register strobe
wire           da_rd, da_rx;     // low/high byte register read enable
wire           da0_clr;          // reset lower register bit
wire           da_rst;           //
                                 //
wire           sx_swp;           //
wire           sx_wl, sx_wh;     //
wire           sx_af;            //
wire           sx_da, dx_da;     //
wire  [15:0]   dx;               // data bus X
wire  [15:0]   wx;               // write data bus X
                                 //
wire           sa_hx;            //
reg            sa_ah;            // select low/high address byte
reg            ra0;              // address register lsb
wire  [15:0]   rx;               // register block bus X
wire  [15:0]   ry;               // register block bus Y
reg   [15:13]  mr;               // mode register
reg   [15:0]   r[10:0];          // general purpose register files
wire  [11:0]   rselx;            //
wire  [11:0]   rsely;            //
wire  [7:0]    rsel;             //
wire           rs_s02, rs_d02;   //
wire           rs_s35, rs_d35;   //
                                 //
wire  [15:0]   x;                // ALU bus X
wire  [15:0]   y;                // ALU bus Y
wire  [15:0]   ax;               // ALU half sum
wire  [15:0]   ay;               // ALU half carry
wire  [16:0]   ac;               // ALU carry
wire  [15:0]   af;               // ALU function result
                                 //
wire           ac_in;            //
wire           ax_in;            //
wire           ay_in;            //
wire           fc0;              // insert 1 in alu[7] and alu[15]
wire           fc1;              // byte/word operation flag
wire           fc2;              // insert 0 in alu[7] on right shift
wire           fc3;              // right shift operation flag
wire           fc4;              // insert 0 in alu[15] on right shift
                                 //
wire           alx, aly;         //
wire           alu_rs;           // ALU right shift
wire           alu_x00;          //
wire           alu_x01;          //
wire           alu_x10;          //
wire           alu_x11;          //
wire           alu_y01;          //
wire           alu_y10;          //
wire           alu_y11;          //
                                 //
reg            pr;               // priority input
wire           pr_c0;            // priority input clear
wire           pr_s0, pr_s1;     // priority input sets
wire           pi_lat;           // priority pins input latch
                                 //
reg            pf0, pf1, pf2;    // power fail edge detector
wire           aclo_clr;         //
reg            hlt0, hlt1;       // halt request edge detector
wire           halt_clr;         //
                                 //
reg            aclo;             //
reg            halt;             //
reg   [3:0]    inr;              //
reg            vec;              //
wire           inrq;             //
                                 //
wire           rdy;              //
reg            cas, ras;         //
wire           cas_c0;           //
wire           cas_s0, cas_s1;   //
wire           ras_c0;           //
wire           ras_s0, ras_s1;   //
wire           iordy;            //
                                 //
reg            sm0, sm1;         //
wire           sm1_set, sm1_clr; //
reg            wb0, wb1;         //
wire           wa0;              //
                                 //
wire           bra;              //
wire           rs_wre;           // result write enable
wire           bus_wt;           // bus waiting for ready
                                 //
wire           ra0_clr;          //
wire           ra_stb;           // address register write strobe
                                 //
wire  [15:0]   ri;               //
reg   [15:0]   ir;               // instruction register
reg   [9:0]    m;                // instruction opcode for the matrix
reg   [7:0]    n;                // next microaddress for the matrix
wire  [7:0]    na;               //
wire  [15:6]   mi;               //
wire  [5:0]    sna;              // instruction decode start address
                                 //
reg   [7:0]    psw;              //
wire           psw_c;            //
wire           psw_v;            //
wire           psw_z;            //
wire           psw_n;            //
                                 //
wire           alu_zf;           //
wire           alu_nf;           //
wire           alu_cf;           //
wire           alu_vf;           //
wire           cf_s1;            //
wire   [1:0]   vf_t;             //
wire   [2:0]   cf_t;             //
                                 //
wire           psw_wc, psw_wf;   // PSW flags write enable
                                 //
wire           dns_s0;           //
wire           dns_s1;           //
wire           dns_s2;           //
reg            t4_dns;           //
wire           st_dns;           //
wire           mi_op, mi_dns;    //
wire           mi_src, mi_dst;   //
reg            mi12_t;           //
                                 //
wire           af_byte;          // ALU byte result
wire  [12:0]   pdc;              // plm output decode
wire  [20:0]   id;               // instruction decode
wire           id_dns;           //
                                 //
wire           ir_stl, ir_sth;   //
wire           plm_stb;          //
reg            plm_rdy;          //
                                 //
wire  [29:0]   pla;              //
reg   [29:0]   plm;              //
wire           plm_cz;           // set na[0] on flag ZF
reg   [6:0]    op;               // used in microcode loops
wire  [15:0]   iop;              //
                                 //
reg            bt2_t;            //
wire  [15:0]   bt;               // boot/restart address
wire           da_s0, da_s1;     //
wire           da_s2, da_s3;     //
wire           da_s4, da_s5;     //
wire           sext;             // sign extension on Y bus
wire           rx_ena;           //
wire           ry_enl, ry_enh;   //
wire           hlt_rx, inr_ry;   //
wire           immed;            //
                                 //
//______________________________________________________________________________
//
// Debug and temporary assignments to supress glitches in model
//
integer i;

initial
begin
   for (i=0; i<11; i = i + 1)
      r[i] = 16'o000000;

   ra0 = 1'b0;
   psw = 8'o000;
end

//______________________________________________________________________________
//
// Reset and clocks
//
always @(posedge pin_clk_p or posedge dclo)
begin
   if (dclo)
   begin
      t1 <= 1'b1;
      t2 <= 1'b0;
      t4 <= 1'b0;
   end
   else
   begin
      t1 <= t4;                     // phase 1
      t2 <= t1;                     // phase 2
      t4 <= t2;                     // phase W
   end
end

//______________________________________________________________________________
//
always @(posedge pin_clk_p)
begin
   dclo <= pin_dclo;

   if (dclo)
      reset <= 1'b1;
   else
      if (t4)
         reset <= 1'b0;

   if (dclo)
      mr[15:13] <= pin_bsel;
end

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      hwclr <= 1'b1;
   else
      if (t1)
         hwclr <= ~iop[12] & (iop[11] | hwclr);
end

assign pin_bclr_n = ~hwclr;

assign bt[2]   = bt2_t;                                           // restart
assign bt[1:0] = 2'b00;                                           // start address
assign bt[8:3] = 6'b000000;                                       // 000 - 140000
assign bt[9]   = mr[15] & mr[14] & ~mr[13];                       // 001 - 100000
assign bt[10]  = mr[15] & mr[14];                                 // 010 - 040000
assign bt[11]  = 1'b0;                                            // 011 - 020000
assign bt[12]  = (mr[15] & mr[14]) | (mr[15] & ~mr[14] & ~mr[13]);// 100 - 010000
assign bt[13]  = (mr[15] & mr[14]) | (~mr[15] & mr[14] & mr[13]); // 101 - 000000
assign bt[14]  = (mr[15] & mr[14]) | (~mr[15] & ~mr[13]);         // 110 - 173000
assign bt[15]  = (mr[15] & mr[14]) | (~mr[15] & ~mr[14]);         // 111 - 172000

//______________________________________________________________________________
//
assign wa0 = iop[0] ? rx[0] : ra0;

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
   begin
      wb0 <= 1'b0;
      wb1 <= 1'b0;
   end
   else
      if (t1)
      begin
         wb0 <= (~wa0 | ~iop[4]) & (iop[8] | iop[10] | iop[15]);
         wb1 <= (wa0 | ~iop[4]) & (iop[8] | iop[10] | iop[15]);
      end
end

//______________________________________________________________________________
//
assign pin_cas_n = ~cas;
assign pin_ras_n = ~ras;
assign rdy = pin_ready;

assign pin_sel[0] = sm0;
assign pin_sel[1] = sm1;
assign pin_wb_n[0] = ~wb0;
assign pin_wb_n[1] = ~wb1;

assign sm1_clr = ~bus_wt;
assign sm1_set = iop[3];

//
// sm1   sm0
//  0     0       read, write, aspi, busnop
//  0     1       fetch or refresh
//  1     0       interrupt acknowkedment
//  1     1       direct memory grant
//
always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
   begin
      sm0 <= 1'b0;
      sm1 <= 1'b0;
   end
   else
   begin
      if (t1)
         sm0 <= iop[6];

      if (t1 & sm1_set)
         sm1 <= 1'b1;

      if (t4 & sm1_clr)
         sm1 <= 1'b0;
   end
end

assign ras_s0 = t2 & sa_hx;
assign ras_s1 = t2 & iop[3];
assign ras_c0 = t4 & cas_c0 | reset;

assign cas_s0 = t1 & ~hwclr & sa_ah;
assign cas_s1 = t1 & ~hwclr & iop[2];
assign cas_c0 = t4 & plm_rdy & (cas | (ras & ~sa_hx)) | reset;

always @(posedge pin_clk_p)
begin
   if (ras_c0)
      ras <= 1'b0;
   else
      if (ras_s0 | ras_s1)
         ras <= 1'b1;

   if (cas_c0 & t4)
      cas <= 1'b0;
   else
      if (cas_s0 | cas_s1)
         cas <= 1'b1;
end

//______________________________________________________________________________
//
// Interrupt requests
//
assign pin_pi = pr;
assign pi_lat = t4 & (iop[2] | iop[9]);

assign pr_s0 = t2 & ~hwclr & cas;
assign pr_s1 = t1 & ~hwclr & sa_ah;
assign pr_c0 = t4 & cas_c0;

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      pr <= 1'b0;
   else
      if (pr_s0 | pr_s1)
         pr <= 1'b1;
      else
         if (pr_c0)
            pr <= 1'b0;
end

always @(posedge pin_clk_p)
begin
   if (reset)
      pf0 <= 1'b0;
   else
      if (pi_lat)
         pf0 <= ~pin_pf_n;

   if (~pi_lat)
      pf1 <= pf0;

   if (~aclo & ~pf1 & pi_lat)
      pf2 <= 1'b1;
   else
      if (reset | aclo_clr)
         pf2 <= 1'b0;

   if (reset | aclo_clr)
      aclo <= 1'b0;
   else
      if (pf1 & pf2 & pi_lat)
         aclo <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   if (reset)
      hlt0 <= 1'b0;
   else
      if (pi_lat)
         hlt0 <= ~pin_hlt_n;

   if (~halt & ~hlt0 & ~pi_lat)
      hlt1 <= 1'b1;
   else
      if (halt_clr)
         hlt1 <= 1'b0;

   if (halt_clr)
      halt <= 1'b0;
   else
      if (hlt0 & hlt1 & ~pi_lat)
         halt <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   if (pi_lat)
   begin
      vec <= ~pin_vec_n;
      inr <= ~pin_cp_n;
   end
end

assign inrq = (inr == 4'b0001) & ~psw[7]                          // prio 4 / 70
            | (inr == 4'b0010) & ~psw[7]                          // prio 4 / 64
            | (inr == 4'b0011) & ~psw[7]                          // prio 4 / 60
            | (inr == 4'b0100) & (~psw[5] & ~psw[6] | ~psw[7])    // prio 5 / 134
            | (inr == 4'b0101) & (~psw[5] & ~psw[6] | ~psw[7])    // prio 5 / 130
            | (inr == 4'b0110) & (~psw[5] & ~psw[6] | ~psw[7])    // prio 5 / 124
            | (inr == 4'b0111) & (~psw[5] & ~psw[6] | ~psw[7])    // prio 5 / 120
            | (inr == 4'b1000) & (~psw[6] | ~psw[7])              // prio 6 / 114
            | (inr == 4'b1001) & (~psw[6] | ~psw[7])              // prio 6 / 110
            | (inr == 4'b1010) & (~psw[6] | ~psw[7])              // prio 6 / 104
            | (inr == 4'b1011) & (~psw[6] | ~psw[7])              // prio 6 / 100
            | (inr == 4'b1100) & (~psw[5] | ~psw[6] | ~psw[7])    // prio 7 / 154
            | (inr == 4'b1101) & (~psw[5] | ~psw[6] | ~psw[7])    // prio 7 / 150
            | (inr == 4'b1110) & (~psw[5] | ~psw[6] | ~psw[7])    // prio 7 / 144
            | (inr == 4'b1111) & (~psw[5] | ~psw[6] | ~psw[7]);   // prio 7 / 140

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      bt2_t <= 1'b0;
   else
      if (t4 & iop[14])
         bt2_t <= 1'b1;
end

//______________________________________________________________________________
//
// Data / Address multiplexed bus
//
always @(posedge pin_clk_p)
begin
   if (t1)
   begin
      if (da0_clr)
         dal[0] <= 1'b0;
      else
         if (da_stl)
            dal[0] <= da[0];

      if (da_stl) dal[7:1] <= da[7:1];
      if (da_sth) dal[15:8] <= da[15:8];
   end
end

assign pin_ad_out = dal;

assign da[7:0]  = (dx_da ? x[15:8] : 8'h00) | (sx_da ? x[7:0] : 8'h00);
assign da[15:8] = (dx_da ? x[7:0] : 8'h00) | (sx_da ? x[15:8] : 8'h00);

assign da0_clr = ~fc1 & ~plm[22];
assign da_rst = ~bt2_t;

assign da_stl = da_rst | da_s2 | da_s4;
assign da_sth = da_rst | da_s2 | (da_s4 & ~pdc[10]);

assign dx = (sx_af ? af[15:0] : 16'o000000)
          | (da_rd ? (da_rx ? {pin_ad_in[7:0], pin_ad_in[15:8]} : pin_ad_in) : 16'o000000);

assign sa_hx = iop[0] | iop[15];

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      sa_ah <= 1'b0;
   else
      if (t4)
         sa_ah <= sa_hx;
end

//______________________________________________________________________________
//
// Register block and X/Y buses
//
assign rs_s02 = plm[27] & ~plm[28] & ~plm[29] & ~t4_dns;
assign rs_d02 = plm[27] & ~plm[28] & ~rs_s02;
assign rs_s35 = plm[20] & ~plm[10] & ~plm[12] & ~t4_dns;
assign rs_d35 = plm[20] & ~plm[10] & ~rs_s35;

assign rsel[0] = ~rsel[7] &  plm[29] | rs_d02 & ri[0] | rs_s02 & ri[6];
assign rsel[1] = ~rsel[7] &  plm[28] | rs_d02 & ri[1] | rs_s02 & ri[7];
assign rsel[2] = ~rsel[7] & ~plm[27] | rs_d02 & ri[2] | rs_s02 & ri[8];

assign rsel[3] = ~rsel[6] & ~plm[12] | rs_d35 & ri[0] | rs_s35 & ri[6];
assign rsel[4] = ~rsel[6] & ~plm[10] | rs_d35 & ri[1] | rs_s35 & ri[7];
assign rsel[5] = ~rsel[6] & ~plm[20] | rs_d35 & ri[2] | rs_s35 & ri[8];

assign rsel[6] = plm[20] * ~plm[10];
assign rsel[7] = plm[27] & ~plm[28];

assign rselx[0]  = (rsel[2:0] == 3'b000) & rsel[7];
assign rselx[1]  = (rsel[2:0] == 3'b001) & rsel[7];
assign rselx[2]  = (rsel[2:0] == 3'b010) & rsel[7];
assign rselx[3]  = (rsel[2:0] == 3'b011) & rsel[7];
assign rselx[4]  = (rsel[2:0] == 3'b100) & rsel[7];
assign rselx[5]  = (rsel[2:0] == 3'b101) & rsel[7];
assign rselx[6]  = (rsel[2:0] == 3'b110);
assign rselx[7]  = (rsel[2:0] == 3'b111);
assign rselx[8]  = (rsel[2:0] == 3'b010) & ~rsel[7];
assign rselx[9]  = (rsel[2:0] == 3'b011) & ~rsel[7];
assign rselx[10] = (rsel[2:0] == 3'b100) & ~rsel[7];
assign rselx[11] = (rsel[2:0] == 3'b101) & ~rsel[7];

assign rsely[0]  = (rsel[5:3] == 3'b000) & rsel[6];
assign rsely[1]  = (rsel[5:3] == 3'b001) & rsel[6];
assign rsely[2]  = (rsel[5:3] == 3'b010) & rsel[6];
assign rsely[3]  = (rsel[5:3] == 3'b011) & rsel[6];
assign rsely[4]  = (rsel[5:3] == 3'b100) & rsel[6];
assign rsely[5]  = (rsel[5:3] == 3'b101) & rsel[6];
assign rsely[6]  = (rsel[5:3] == 3'b110);
assign rsely[7]  = (rsel[5:3] == 3'b111);
assign rsely[8]  = (rsel[5:3] == 3'b001) & ~rsel[6];
assign rsely[9]  = (rsel[5:3] == 3'b000) & ~rsel[6];
assign rsely[10] = (rsel[5:3] == 3'b100) & ~rsel[6];
assign rsely[11] = (rsel[5:3] == 3'b101) & ~rsel[6] & ~inr_ry;

assign rx = (rselx[0]  ? r[0]  : 16'o000000)
          | (rselx[1]  ? r[1]  : 16'o000000)
          | (rselx[2]  ? r[2]  : 16'o000000)
          | (rselx[3]  ? r[3]  : 16'o000000)
          | (rselx[4]  ? r[4]  : 16'o000000)
          | (rselx[5]  ? r[5]  : 16'o000000)
          | (rselx[6]  ? r[6]  : 16'o000000)
          | (rselx[7]  ? r[7]  : 16'o000000)
          | (rselx[8]  ? r[8]  : 16'o000000)
          | (rselx[9]  ? r[9]  : 16'o000000)
          | (rselx[10] ? r[10] : 16'o000000)
          | (rselx[11] ? {8'o000, psw} : 16'o000000);


assign ry = (inr_ry ? {10'b00, inr[2], inr[3], ~inr[1], ~inr[0] ,2'b00} : 16'o000)
          | (rsely[0]  ? r[0]  : 16'o000000)
          | (rsely[1]  ? r[1]  : 16'o000000)
          | (rsely[2]  ? r[2]  : 16'o000000)
          | (rsely[3]  ? r[3]  : 16'o000000)
          | (rsely[4]  ? r[4]  : 16'o000000)
          | (rsely[5]  ? r[5]  : 16'o000000)
          | (rsely[6]  ? r[6]  : 16'o000000)
          | (rsely[7]  ? r[7]  : 16'o000000)
          | (rsely[8]  ? r[8]  : 16'o000000)
          | (rsely[9]  ? r[9]  : 16'o000000)
          | (rsely[10] ? r[10] : 16'o000000)
          | (rsely[11] ? {8'o000, psw} : 16'o000000);

always @(posedge pin_clk_p)
begin
   if (sx_wl)
   begin
      if (rselx[0]) r[0][7:0] <= wx[7:0];
      if (rselx[1]) r[1][7:0] <= wx[7:0];
      if (rselx[2]) r[2][7:0] <= wx[7:0];
      if (rselx[3]) r[3][7:0] <= wx[7:0];
      if (rselx[4]) r[4][7:0] <= wx[7:0];
      if (rselx[5]) r[5][7:0] <= wx[7:0];
      if (rselx[6]) r[6][7:0] <= wx[7:0];
      if (rselx[7]) r[7][7:0] <= wx[7:0];
      if (rselx[8]) r[8][7:0] <= wx[7:0];
      if (rselx[9]) r[9][7:0] <= wx[7:0];
      if (rselx[10]) r[10][7:0] <= wx[7:0];
      if (rselx[11]) psw[7:0] <= wx[7:0];
   end

   if (sx_wh)
   begin
      if (rselx[0]) r[0][15:8] <= wx[15:8];
      if (rselx[1]) r[1][15:8] <= wx[15:8];
      if (rselx[2]) r[2][15:8] <= wx[15:8];
      if (rselx[3]) r[3][15:8] <= wx[15:8];
      if (rselx[4]) r[4][15:8] <= wx[15:8];
      if (rselx[5]) r[5][15:8] <= wx[15:8];
      if (rselx[6]) r[6][15:8] <= wx[15:8];
      if (rselx[7]) r[7][15:8] <= wx[15:8];
      if (rselx[8]) r[8][15:8] <= wx[15:8];
      if (rselx[9]) r[9][15:8] <= wx[15:8];
      if (rselx[10]) r[10][15:8] <= wx[15:8];
   end

   if (t4 & psw_wf)
   begin
      if (psw_wc)
         psw[0] <= alu_cf;
      psw[1] <= alu_vf;
      psw[2] <= alu_zf;
      psw[3] <= alu_nf;
   end
end

//______________________________________________________________________________
//
assign ra_stb = (iop[0] | iop[5]) & t1;
assign ra0_clr = ~iop[4] & ~plm[22];

always @(posedge pin_clk_p)
begin
   if (ra0_clr)
      ra0 <= 1'b0;
   else
      if (ra_stb)
         ra0 <= rx[0];
end

assign sx_af = ~da_s0;
assign sx_da = da_stx;
assign dx_da = ~da_s1;
assign da_rd = da_s5 & ~hwclr;
assign da_rx = da_s0 & ~da_s1;
assign da_stx = da_s2 | (da_s1 & da_s0);

assign sx_wl = t4 & rs_wre & ~plm[15];
assign sx_wh = t4 & rs_wre & ~plm[15] & (pdc[2] | ~pdc[12]);

assign sext = ~pdc[0] & ~pdc[1] & plm[17];
assign rx_ena = ~hlt_rx & ~inr_ry;
assign ry_enl = aly;
assign ry_enh = aly & ~pdc[2];

assign halt_clr = hlt_rx;
assign aclo_clr = inr_ry;
assign immed = ~aly;

assign hlt_rx = ~plm[8] & ~plm[10] & plm[12] & plm[14] & plm[16] & plm[18] & ~plm[20];
assign inr_ry = ~plm[8] & plm[10] & ~plm[12] & plm[14] & plm[18];

assign da_s0 = da_s4 | da_s5;
assign da_s1 = ~pdc[12] | ~ra0;
assign da_s2 = pdc[10] | pdc[11];
assign da_s3 = plm[10] & plm[12] & ~plm[16] & plm[18] & ~plm[20];
assign da_s4 = ~plm[14] & ~plm[16] & plm[18] & ~bus_wt;
assign da_s5 =  plm[14] & ~plm[16] & plm[18];

assign bus_wt = ~plm_rdy;
assign iordy = rdy | ~ras;

//______________________________________________________________________________
//
assign fc1 =  plm[8] & ~plm[16];
assign fc0 = ~plm[10] & ~plm[12] & plm[14] & ~plm[16] & ~plm[18] & ~plm[20] & psw_c;
assign fc2 =  plm[10] & ~plm[12] & plm[14] & ~plm[16] & ~plm[18] &  plm[20];
assign fc4 = ~plm[10] &  plm[12] & plm[14] & ~plm[16] & ~plm[18] & ~plm[20];
assign fc3 = ~plm[10] & plm[14] & ~plm[16] & ~plm[18] & ~plm[20];
assign alu_rs = fc3;

assign alx = ~plm[10] | ~plm[12] | ~plm[14] | plm[16] | plm[18] | plm[20] | psw_n;
assign alu_x00 = alx & ~plm[21];
assign alu_x01 = alx & ~plm[17];
assign alu_x10 = alx & ~plm[13];
assign alu_x11 = alx &  plm[19];

assign aly = ~plm[8] | ~plm[14] | ~plm[16] | ~plm[18];
assign alu_y01 = aly & ~plm[24];
assign alu_y10 = aly & ~plm[26];
assign alu_y11 = aly & ~plm[25];

assign ac_in =  plm[9] & ~plm[11]
             | ~plm[9] &  plm[11] & (plm[21] ^ ~psw_c);
assign ax_in = plm[21] | ~aly | pdc[3];
assign ay_in = ay[0] & (pdc[3] | plm[21] | ~aly);

//______________________________________________________________________________
//
// ALU
//
assign ax = (alu_rs  ? {fc4 & x[15], x[15:9], ~fc1 & x[8], x[7:1]} : 16'o000000)
          | (alu_x00 ? ~y & ~x : 16'o000000)
          | (alu_x01 ? ~y &  x : 16'o000000)
          | (alu_x10 ?  y & ~x : 16'o000000)
          | (alu_x11 ?  y &  x : 16'o000000)
          | {fc0, 7'o000, fc1 & (fc0 | (x[7] & fc4)), 7'o000};

assign ay = (alu_y01 ? ~y &  x : 16'o000000)
          | (alu_y10 ?  y & ~x : 16'o000000)
          | (alu_y11 ?  y &  x : 16'o000000)
          | {15'o00000, aly & plm[21] & ~pdc[3]};

assign af = ax ^ ac[15:0];

assign ac[0]  = ~(ac_in ^ ax_in);
assign ac[1]  = ac_in & ax_in & ax[0]
              | ay_in & ax_in;
assign ac[2]  = ac_in & ax[1] & ax[0]
              | ay_in & ax[1]
              | ay[1];
assign ac[3]  = ac_in & ax[2] & ax[1] & ax[0]
              | ay_in & ax[2] & ax[1]
              | ay[1] & ax[2]
              | ay[2];
assign ac[4]  = ac_in & ax[3] & ax[2] & ax[1] & ax[0]
              | ay_in & ax[3] & ax[2] & ax[1]
              | ay[1] & ax[3] & ax[2]
              | ay[2] & ax[3]
              | ay[3];

assign ac[5]  = ac[4] & ax[4]
              | ay[4];
assign ac[6]  = ac[4] & ax[5] & ax[4]
              | ay[4] & ax[5]
              | ay[5];
assign ac[7]  = ac[4] & ax[6] & ax[5] & ax[4]
              | ay[4] & ax[6] & ax[5]
              | ay[5] & ax[6]
              | ay[6];
assign ac[8]  = ac[4] & ax[7] & ax[6] & ax[5] & ax[4]
              | ay[4] & ax[7] & ax[6] & ax[5]
              | ay[5] & ax[7] & ax[6]
              | ay[6] & ax[7]
              | ay[7];

assign ac[9]  = ac[8] & ax[8]
              | ay[8];
assign ac[10] = ac[8] & ax[9] & ax[8]
              | ay[8] & ax[9]
              | ay[9];
assign ac[11] = ac[8] & ax[10] & ax[9] & ax[8]
              | ay[8] & ax[10] & ax[9]
              | ay[9] & ax[10]
              | ay[10];
assign ac[12] = ac[8] & ax[11] & ax[10] & ax[9] & ax[8]
              | ay[8] & ax[11] & ax[10] & ax[9]
              | ay[9] & ax[11] & ax[10]
              | ay[10] & ax[11]
              | ay[11];

assign ac[13] = ac[12] & ax[12]
              | ay[12];
assign ac[14] = ac[12] & ax[13] & ax[12]
              | ay[12] & ax[13]
              | ay[13];
assign ac[15] = ac[12] & ax[14] & ax[13] & ax[12]
              | ay[12] & ax[14] & ax[13]
              | ay[13] & ax[14]
              | ay[14];
assign ac[16] = ac[12] & ax[15] & ax[14] & ax[13] & ax[12]
              | ay[12] & ax[15] & ax[14] & ax[13]
              | ay[13] & ax[15] & ax[14]
              | ay[14] & ax[15]
              | ay[15];

assign wx[15:0] = sx_swp ? {dx[7:0], dx[15:8]} : dx[15:0];

assign x[7:0]  = (rx_ena ? rx[7:0] : 8'o000)
               | (halt_clr ? bt[7:0] : 8'o000)
               | (aclo_clr ? 8'o060 : 8'o000);

assign x[15:8] = (rx_ena ? rx[15:8] : 8'o000)
               | (halt_clr ? bt[15:8] : 8'o000)
               | (aclo_clr ? {3'b000, ~vec, ~inr[0], ~inr[1], ~inr[2], ~inr[3]}: 8'o000);

assign y[7:0]  = (ry_enl ? ry[7:0] : 8'o000)
               | (immed ? {~plm[20], ~plm[10], ~plm[12], ~plm[25],
                           ~plm[24], ~plm[26],  plm[22],  plm[23]} : 8'o000);

assign y[15:8] = (ry_enh ? ry[15:8] : 8'o000)
               | ((sext & y[7]) ? 8'o377 : 8'o000);

//______________________________________________________________________________
//
// Processor status word
//
assign psw_c = psw[0];
assign psw_v = psw[1];
assign psw_z = psw[2];
assign psw_n = psw[3];

assign bra = ~ri[8] ^ ((~ri[15] & ~ri[10] & ~ri[9])
                     | ( ri[15] & ~ri[10] &  ri[9] & psw_z)
                     | ( ri[15] &  ri[10] & ~ri[9] & psw_v)
                     | ( ri[15] & ~ri[10] & ~ri[9] & psw_n)
                     | (~ri[15] &  ri[10] & (psw_n ^ psw_v))
                     | ( ri[15] &  ri[9] & psw_c)
                     | (~ri[15] &  ri[9] & psw_z));

assign alu_nf = af_byte ? af[7] : af[15];
assign alu_vf = (vf_t[0] & (alu_nf ^ alu_cf)) | vf_t[1];
assign alu_cf = (cf_t[0] & psw_wc) | cf_t[2] | cf_t[1];
assign alu_zf = (sx_swp | (af[7:0] == 8'o000)) & (af_byte | (af[15:8] == 8'o000));

assign psw_wf = aly & ~plm[22];
assign psw_wc = plm[23];

assign vf_t[0] = fc2 | fc3;
assign vf_t[1] = ~fc2 & ~fc3 & ((fc1 ? ac[8] : ac[16]) ^ (fc1 ? ac[7] : ac[15]));
assign cf_t[0] = ~fc2 & ~fc3 & ((fc1 ? ac[8] : ac[16]) ^ alu_x00);
assign cf_t[1] = fc2 & (fc1 ? x[7] : x[15]);
assign cf_t[2] = alu_rs & x[0];

//______________________________________________________________________________
//
// Microcode engine
//
t11_plm plm_matrix(.init(reset), .m(m), .n(n), .sp(pla));

always @(posedge pin_clk_p)
begin
   if (t1)
   begin
      n <= na;
      m <= mi[15:6];
   end
end

assign mi[15:12] = mi_op ? ir[15:12] : {3'b000, mi12_t};
assign mi[11:6] = mi_op ? (mi_src ? ir[11:6] : 6'o00) | (mi_dst ? ir[5:0] : 6'o00) :
                          {inrq & ~vec, inrq & vec, aclo, halt, psw[4], ~bt2_t};

//
// The initial micro-instruction address for opcode decode
//
assign sna[0] = id[18] | id[20] | (~pdc[7] & ~id[17] & id[10]);
assign sna[1] = id[19] | id[15] | (id[17] & (id[18] | id[10] | (id[20] & (pdc[8] | id[1]))));
assign sna[2] = id[17] & (pdc[8] | id[18] | id[10] | (id[20] & id[1]));
assign sna[3] = ~id[10] & ~id[18] & ~id[19] & ~id[20];
assign sna[4] = 1'b0;
assign sna[5] = mi_dns;

assign na[5:0] = ~plm[5:0] | (na[7] ? sna : 6'b000000);
assign na[6] = ~plm[6];
assign na[7] = ~plm[7];

always @(posedge pin_clk_p)
begin
   if (t4)
      t4_dns <= mi_dns;

   if (t1)
      if (~bt2_t | da_s2)
         mi12_t <= 1'b0;
      else
         if (id[14] & pdc[9])
            mi12_t <= 1'b1;
end

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
   begin
      op[0] <= 1'b0;
      op[5] <= 1'b0;
   end
   else
      if (plm_stb)
      begin
         plm[0] <= pla[0] & ~plm_cz;
         plm[29:1] <= pla[29:1];

         op[0] <= pla[8];
         op[1] <= pla[10];
         op[2] <= pla[12];
         op[3] <= pla[14];
         op[4] <= pla[16];
         op[5] <= pla[18];
         op[6] <= pla[20];
      end
end

assign pdc[0] = ~plm[9] | ~plm[11];
assign pdc[1] = ~plm[8] |  plm[14] | plm[18] | (plm[13] & ~plm[16]);
assign pdc[2] = ~pdc[0] & ~pdc[1]  & plm[17];
assign pdc[3] =  plm[9] |  plm[11];
                                                                                       // na[5:0]
assign pdc[4] = ~plm[7] & ((plm[3] & plm[4]) | (~plm[1] & plm[2]));                    // xx00xx | xxxx01
assign pdc[5] = ~plm[7] & ~plm[4] & plm[2] & plm[1];                                   // x1x00x
assign pdc[6] = ~plm[7] & ~plm[5] & ~plm[4] & ~plm[3] & ~plm[2] & ~plm[1] & ~plm[0];   // 111111
assign pdc[7] = ~plm[7] & ~plm[5] &  plm[4] &  plm[3] & ~plm[2] &  plm[1] &  plm[0];   // 100100
assign pdc[8] = ~plm[7] & ~plm[5] &  plm[4] &  plm[3] &  plm[2] &  plm[1] &  plm[0];   // 100000
assign pdc[9] = ~plm[7] &  plm[5] &  plm[4] &  plm[3] &  plm[2] &  plm[1] &  plm[0];   // 000000

assign pdc[10] = ~plm[8] & plm[10] & ~plm[12] & plm[14] & plm[18] & ~plm[20];
assign pdc[11] = plm[8] & ~plm[14] & plm[16] & plm[18];
assign pdc[12] = plm[8] & ~plm[16];

assign plm_cz = ~plm[8] & ~plm[14] & plm[16] & ~plm[18] & alu_zf;
assign mi_op = ~pdc[6];
assign mi_src = mi_op & ~mi_dns;
assign mi_dst = mi_op & mi_dns;
assign mi_dns = st_dns ? ~id_dns : t4_dns;
assign st_dns = pdc[4] | (pdc[5] & (id[8] | id[9]));

assign rs_wre = bra | ~plm[10] | ~plm[12] | ~plm[14] | plm[16] | plm[18] | ~plm[20];
assign sx_swp = ~plm[10] & ~plm[12] & plm[14] & ~plm[16] & ~plm[18] & plm[20];
assign af_byte = pdc[12];

assign iop[15] = ~reset & ~pdc[6] & ~iop[13] & ~plm[22];

t11_pio pio_matrix(.op(op), .iop(iop[14:0]));

//______________________________________________________________________________
//
// PLM matrix strobes
//
assign plm_stb = plm_rdy & t4;

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      plm_rdy <= 1'b1;
   else
      if (~t4)
         plm_rdy <= iordy;
end

//______________________________________________________________________________
//
// Instruction register and decoder
//
t11_pid pid_matrix(.ir(ir), .id(id[17:0]));

always @(posedge pin_clk_p)
begin
   if (ir_stl) ir[7:0] <= dx[7:0];
   if (ir_sth) ir[15:8] <= dx[15:8];
end

assign ir_stl = t4 & da_s3 & da_s1;
assign ir_sth = t4 & da_s3;
assign ri = r[10];

assign dns_s0 = pdc[9] & ~id[17];
assign dns_s1 = pdc[9];
assign dns_s2 = pdc[9] & ~id[17] & id[0];

assign id_dns = ~id[16] & (id[17] | ~pdc[8])
              & (~dns_s0 | (~id[3] & ~id[4] & ~id[5] & ~id[10] & ~id[11] & ~id[12]))
              & (~dns_s1 | (~id[8] & ~id[9]))
              & (~dns_s2 | (~id[2] & ~id[6] & ~id[7]));

assign id[18] = id[3] | id[4] | id[5] | id[11] | id[12]; // one operand instruction
assign id[19] = id[8] | id[9];                           // jmp or jsr instruction
assign id[20] = id[2] | id[6] | id[7];                   // two operand instruction

//______________________________________________________________________________
//

endmodule
