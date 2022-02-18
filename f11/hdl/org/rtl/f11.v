//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// F-11 asynchronous model, for debug and modelling only.
// This file contains the wrapper for F-11 "Fonz" chipset,
// it implements external circuits of the M6/KDF-11Ax (M8186)
// processor, supporting MMU and 22-bit address and micROM
// options (FPP, CIS, etc).
//
// DC302 21-15541-AB Data, 16-bit ALU, etc
// DC303 23-001C7-AA Control, standard instruction set
// DC303 23-002C7-AA Control, FP instruction set, part 1
// DC303 23-003C7-AA Control, FP instruction set, part 2
// DC304 21-15542-01 MMU
//
//______________________________________________________________________________
//
`timescale 1ns / 100ps

module f11
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input  [7:4]   pin_virq_n,    // vectored interrupt requests
                                 //
   input          pin_dmr_n,     // bus request line
   input          pin_sack_n,    // bus acknowlegement
   inout          pin_rply_n,    // transaction reply
   output         pin_dmgo_n,    // bus granted output
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout  [15:0]  pin_ad_n,      // inverted address/data bus
   output [21:16] pin_a_n,       // inverted high address bus
   output         pin_umap_n,    // upper address mapping
   inout          pin_bs_n,      // bank 7 select
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
                                 //
   input [15:2]   pin_fdin_n,    // fast input configuration
   input [1:0]    pin_bsel_n     // boot mode selector
);

//______________________________________________________________________________
//
wire  clk;                       // generator clock
wire  mclk;                      // master CPU clock
wire  mclk_clr_n;                //
                                 //
reg   [10:0] rclk;               //
wire  e33;                       //
wire  e65;                       //
wire  e98;                       //
wire  e130;                      //
wire  e163;                      //
wire  e195;                      //
wire  e293;                      //
wire  e423;                      //
                                 //
reg   clk_restart;               //
reg   clk_stop;                  //
wire  start_a;                   //
                                 //
tri1  [15:0] m;                  // microinstruction bus
tri0  [15:0] ad;                 // address/data bus
reg   [15:0] ad_reg;             // output address/data register
tri0  [21:16] a;                 // high address bus
reg   bs_reg;                    //
tri1  bsio;                      //
wire  sack;                      //
                                 //
wire  doe;                       //
wire  ad_ena;                    // enable address/data bus drivers
wire  ad_stb;                    // latch address/data bus inputs
wire  ad_oe;                     //
                                 //
tri1  umap_n;                    // upper addresses mapping enable
tri1  abort_n;                   // abort bus cycle (error/timeout)
wire  reset;                     // reset control chip/CPU
tri1  mrply_n;                   // MMU access acknowlegement
wire  dmmus_n;                   // MMU data selector
tri1  csel_n;                    // control chip selected
                                 //
wire  dmr;                       //
reg   dmr0, sydmr;               //
                                 //
reg   bus_init;                  //
reg   dcok, init, dinit;         // DCOK input registers
reg   dclo, pdclo;               // DCLO logic registers
reg   aclo;                      //
wire  acok;                      //
                                 //
reg   evnt;                      //
wire  timeout;                   //
wire  par_err;                   //
reg   ctl_err;                   //
reg   bus_err;                   //
reg   bus_cyc;                   //
reg   sync, sy_set, sy_clr;      //
wire  sync_reset;                //
wire  din, dout, iako;           //
reg   dout0, dly_dout;           //
reg   dly_dout1, dly_dout2;      //
                                 //
reg   clk_stut;                  //
reg   wtbt;                      //
reg   bus_ena;                   //
reg   bus_disable;               //
wire  clk_hold;                  //
wire  out_cyc;                   //
wire  din_cyc;                   //
                                 //
wire  com_rep;                   // reply logic
reg   com_rep0;                  //
reg   sync_rep;                  //
reg   rply_restart;              //
reg   restart_end;               //
                                 //
reg   rearb_a, rearb_b;          //
wire  qt_dmgo, qt_tout;          //
reg   dmgo;                      //
reg   dmgo_ena;                  //
wire  dmgo_ena_clr;              //
wire  dmgo_ena_set;              //
                                 //
wire  dma_ena, dma_ena0;         //
reg   dma_ena1, dma_ena2;        //
wire  dma_ena_clr;               //
                                 //
reg   symme;                     //
reg   mmu_str, mmu_str0;         //
reg   mme_hold, mme_hold0;       //
reg   dis_mmu;                   // disable MMU for cycle
wire  ena_odt;                   //
reg   [17:16] odt_a;             //
                                 //
wire  aclo_clr, evnt_clr;        //
wire  odt_stb, srun;             //
                                 //
wire  pre_csel;                  //
reg   svc_oe;                    //
wire  svc_oe_clr;                //
wire  fdin_oe;                   //
wire  [15:0] svc;                //
wire  [15:0] fdin;               //
reg   [12:4] svc_reg;            //
tri1  [15:0] md;                 //
                                 //
//______________________________________________________________________________
//
assign #1 m = md;

initial
begin
   @(posedge clk)
   begin
      rclk <= 11'h7FD;
      clk_stut <= 1'b0;
      mme_hold <= 1'b0;
      symme <= 1'b1;
   end
   @(posedge clk)
   begin
      rclk <= 11'h7FD;
      clk_stut <= 1'b0;
      mme_hold <= 1'b0;
      symme <= 1'b1;
   end
   @(posedge clk)
   begin
      rclk <= 11'h7FD;
      clk_stut <= 1'b0;
      mme_hold <= 1'b0;
      symme <= 1'b1;
   end
end

//______________________________________________________________________________
//
// Clock generator
//
assign clk = pin_clk;
always @(posedge clk)
begin
   rclk[1] <= mclk;
   rclk[3] <= rclk[1];
   rclk[5] <= rclk[3];
end

always @(negedge clk)
begin
   rclk[0] <= mclk;
   rclk[2] <= rclk[1];
end

always @(negedge clk or negedge mclk_clr_n)
begin
   if (~mclk_clr_n)
   begin
      rclk[4]  <= 1'b0;
      rclk[6]  <= 1'b0;
      rclk[7]  <= 1'b0;
      rclk[8]  <= 1'b0;
      rclk[9]  <= 1'b0;
      rclk[10] <= 1'b0;
   end
   else
   begin
      rclk[10] <= rclk[1];
      rclk[4]  <= rclk[10];
      rclk[6]  <= rclk[4];
      rclk[7]  <= rclk[6];
      rclk[8]  <= rclk[7];
      rclk[9]  <= rclk[8];
   end
end

always @(posedge clk) clk_restart <= dma_ena0 & restart_end & ~rply_restart & ~bus_cyc
                                   | dma_ena0 & ~restart_end & rply_restart
                                   | dma_ena0 & rearb_b
                                   | init;
assign mclk = (~e130 | ~e195 | ~start_a | clk_stop)
            & (~mme_hold)
            & (~e130 | clk_stut | ~start_a)
            & (~e195 | ~reset);

assign mclk_clr_n = mclk & ~init;

assign e33  = rclk[0];     // on falling clk edge
assign e65  = rclk[1];     // on rising clk edge
assign e98  = rclk[2];     // on falling clk edge
assign e130 = rclk[3];     // on rising clk edge
assign e163 = rclk[4];     // on falling clk edge
assign e195 = rclk[5];     // on rising clk edge
assign e293 = rclk[7];     // on falling clk edge
assign e423 = rclk[9];     // on falling clk edge

assign pre_csel = e65 & ~e130;
assign start_a = ~init;

always @(posedge e130 or posedge clk_restart)
begin
   if (clk_restart)
      clk_stop <= 1'b0;
   else
      clk_stop <= clk_hold;
end

//______________________________________________________________________________
//
// Initialization curcuits
//
always @(posedge clk) dcok <= pin_dclo_n;
always @(posedge clk) init <= ~dcok;
always @(negedge clk) dinit <= init;

always @(negedge mclk or posedge dinit)
begin
   if (dinit)
   begin
      bus_err  <= 1'b0;
      bus_init <= 1'b0;
   end
   else
   begin
      bus_err  <= timeout;
      bus_init <= m[14];
   end
end
//______________________________________________________________________________
//
assign pin_a_n  = ad_ena ? ~a : 6'oZZ;
assign pin_ad_n = ad_ena ? ~ad_reg : 16'oZZZZZZ;
assign pin_bs_n = ad_ena ? ~bs_reg : 1'bz;

always @(posedge ad_stb)
begin
   ad_reg <= ad;
   bs_reg <= bsio;
end

assign pin_umap_n = umap_n;
assign pin_din_n  = din  ? 1'b0 : 1'bz;
assign pin_dout_n = dout ? 1'b0 : 1'bz;
assign pin_iako_n = iako ? 1'b0 : 1'bz;
assign pin_sync_n = sync ? 1'b0 : 1'bz;
assign pin_wtbt_n = ad_ena ? ~wtbt : 1'bz;
assign pin_dmgo_n = qt_dmgo ? 1'b0 : 1'bz;
assign pin_init_n = bus_init ? 1'b0 : 1'bz;
assign pin_rply_n = (e130 & ~mrply_n) ? 1'b0 : 1'bz;

//______________________________________________________________________________
//
// fdin[15:9]   - start address 15:9 (lower bits are zero)
// fdin[8] / E8 set - 1 - start from 173000
//           E8 mis - 0 - start from fdin[15:9]
// fdin[2] / E7 set - 1 - HALT causes exception 10
//           E7 mis - 0 - HALT invokes ODT
//
assign ad = doe      ? 16'oZZZZZZ :
            ad_oe    ? ~pin_ad_n :
            svc_oe   ? svc   :
            fdin_oe  ? fdin  :
            ~mrply_n ? 16'oZZZZZZ :
                       16'oZZZZZZ;

assign fdin = {~pin_fdin_n[15:8], dcok, 4'b0000, ~pin_fdin_n[2], pin_bsel_n[1:0]};
assign svc = {3'bzzz, svc_reg[12:5], ctl_err, abort_n, par_err, svc_reg[4], ~dclo };

assign fdin_oe = e33 & e130 & m[3];
assign svc_oe_clr = e33 | pdclo;
always @(negedge e65 or negedge abort_n or posedge svc_oe_clr)
begin
   if (~abort_n)
      svc_oe <= 1'b1;
   else
      if (svc_oe_clr)
         svc_oe <= 1'b0;
      else
         svc_oe <= symme;
end

always @(posedge e65 or posedge init)
begin
   if (init)
      dclo <= 1'b1;
   else
      dclo <= pdclo;
end

assign ad_oe = ena_odt | din & (~e130 | mrply_n);
assign ad_stb = e163 | mmu_str;
assign ad_ena = ~bus_disable & bus_ena;

always @(negedge mclk or posedge mmu_str0)
begin
   if (mmu_str0)
      symme <= 1'b1;
   else
      symme <= m[15];
end

always @(posedge clk) mme_hold <= ~symme;
always @(posedge clk or negedge mme_hold)
begin
   if (~mme_hold)
   begin
      mme_hold0 <= 1'b0;
      mmu_str   <= 1'b0;
      mmu_str0  <= 1'b0;
   end
   else
   begin
      mme_hold0 <= mme_hold;
      mmu_str   <= mme_hold0;
      mmu_str0  <= mmu_str;
   end
end

assign md[15] = (e33 & e98 & ~m[12] & dis_mmu) ? 1'b0 : 1'bz;
assign dmmus_n = ~(e33 & e98 & ~m[12] & dis_mmu);
assign ena_odt = dis_mmu & mme_hold;

always @(posedge mclk or posedge init)
begin
   if (init)
      dis_mmu <= 1'b0;
   else
      dis_mmu <= ~m[6] & m[7];
end

assign a[16] = ena_odt ? odt_a[16] : 1'bz;
assign a[17] = ena_odt ? odt_a[17] : 1'bz;
assign bsio = ena_odt ? odt_a[16] & odt_a[17] & ~pin_bs_n : 1'bz;

always @(*) if (odt_stb & mclk) odt_a[17:16] <= ad[1:0];
//______________________________________________________________________________
//
assign dmr = ~pin_dmr_n;
assign sack = ~pin_sack_n;
assign com_rep = timeout | ~pin_rply_n;
assign din  = e163 & din_cyc;
assign dout = e293 & out_cyc & mclk & ~restart_end;
assign iako = e423 & m[13];

always @(negedge clk)
begin
   dmr0 <= dmr;
   sydmr <= dmr0;
end

always @(posedge clk)
begin
   com_rep0 <= com_rep;
   sync_rep <= com_rep0;
   rply_restart <= sync_rep;
   restart_end <= rply_restart;
end

//
// Bus cycle decodig ROM is replaced with equivalent equations
//
always @(*) if (pre_csel) clk_stut <= ~(m[12] & m[9] & m[8] & ~bus_cyc);
always @(*) if (pre_csel) wtbt <= ~m[9] & ~m[8];
always @(posedge e130) bus_ena <= ~m[12] | ~m[9] & bus_cyc;
always @(posedge clk) bus_disable <= ~dma_ena0;

assign out_cyc   = m[12] & ~m[9] & bus_cyc;
assign din_cyc   = m[12] & m[9] & ~m[8] & bus_cyc;
assign clk_hold  = ~m[12] & dma_ena | m[12] & bus_cyc & ~(m[9] & m[8]);

always @(posedge dinit or negedge mclk)
begin
   if (dinit)
   begin
      ctl_err <= 1'b0;
      pdclo   <= 1'b1;
      bus_cyc <= 1'b0;
      sy_set  <= 1'b0;
      sy_clr  <= 1'b0;
   end
   else
   begin
      ctl_err <= csel_n;
      pdclo   <= 1'b0;
      bus_cyc <= ~m[12] | ~m[7];
      sy_set  <= ~m[7];
      sy_clr  <= m[7] & sy_set & ~com_rep;
   end
end

assign sync_reset = ~par_err & reset
                  | ~bus_cyc & ~sync_rep & ~dly_dout2 & restart_end;
always @(posedge e33 or posedge sync_reset)
begin
   if (sync_reset)
      sync <= 1'b0;
   else
      sync <=  sy_set & ~sy_clr
            |  sy_set &  sy_clr & ~sync
            | ~sy_set & ~sy_clr & sync;
end

always @(negedge qt_dmgo or posedge rearb_b)
begin
   if (rearb_b)
      dmgo <= 1'b0;
   else
      dmgo <= 1'b1;
end

assign dmgo_ena_clr = dma_ena1 & ~rearb_a & rearb_b;
assign dmgo_ena_set = init | dmgo;
always @(posedge e65 or posedge dmgo_ena_clr or posedge dmgo_ena_set)
begin
   if (dmgo_ena_set)
      dmgo_ena <= 1'b1;
   else
      if (dmgo_ena_clr)
         dmgo_ena <= 1'b0;
      else
         dmgo_ena <= dma_ena1;
end

always @(posedge clk)
begin
   rearb_a <= dmgo & pin_sync_n & ~sack;
   rearb_b <= rearb_a;
end

assign dma_ena0 = ~dma_ena1;
assign dma_ena = dma_ena1 & dma_ena2;
assign dma_ena_clr = rearb_b & ~sydmr;

always @(negedge mclk or posedge dma_ena_clr)
begin
   if (dma_ena_clr)
      dma_ena1 <= 1'b0;
   else
      if (sydmr & ~bus_cyc)
         dma_ena1 <= ~dma_ena1;
end

always @(negedge e98 or posedge init)
begin
   if (init)
      dma_ena2 <= 1'b0;
   else
      dma_ena2 <= sync_rep;
end

always @(posedge clk) dout0 <= dout;
always @(negedge clk)
begin
   dly_dout <= dout0;
   dly_dout1 <= dly_dout;
   dly_dout2 <= dly_dout1;
end

assign reset = ~e65 & (ctl_err | par_err | bus_err | dclo | ~abort_n);
//______________________________________________________________________________
//
// Interrupts
//
assign srun     = (m[3:0] == 4'b0001) & mclk & e130;
assign evnt_clr = (m[3:0] == 4'b0101) & mclk & e130;
assign aclo_clr = (m[3:0] == 4'b0110) & mclk & e130;
assign odt_stb  = (m[3:0] == 4'b0111) & mclk & e130;
assign par_err  = 1'b0;

assign acok = pin_aclo_n;
always @(negedge acok or posedge aclo_clr or posedge init)
begin
   if (aclo_clr | init)
      aclo <= 1'b0;
   else
      aclo <= 1'b1;
end

assign timeout = e423 & ~qt_tout & (din | dly_dout);
always @(negedge pin_evnt_n or posedge evnt_clr or posedge bus_init)
begin
   if (evnt_clr | bus_init)
      evnt <= 1'b0;
   else
      evnt <= 1'b1;
end

always @(negedge mclk)
begin
   svc_reg[12] <= evnt;
   svc_reg[11] <= ~pin_virq_n[4];
   svc_reg[10] <= ~pin_virq_n[5];
   svc_reg[9]  <= ~pin_virq_n[6];
   svc_reg[8]  <= ~pin_virq_n[7];
   svc_reg[7]  <= aclo;
   svc_reg[6]  <= 1'b1;
   svc_reg[5]  <= ~pin_halt_n;
   svc_reg[4]  <= timeout;
end

//______________________________________________________________________________
//
// Bus timeouts - for transaction and arbitration
//
defparam qbus_to0.DC_PULSE_WIDTH_CLK = 64;
dc_pulse qbus_to0
(
   .clk(clk),
   .reset_n(mclk_clr_n),
   .a_n(1'b0),
   .b(din | dout),
   .q(qt_tout)
);

defparam qbus_to1.DC_PULSE_WIDTH_CLK = 64;
dc_pulse qbus_to1
(
   .clk(clk),
   .reset_n(~sack),
   .a_n(~dmgo_ena),
   .b(sync_rep),
   .q(qt_dmgo)
);

//______________________________________________________________________________
//
// Instantiate chipset components
//
dc302 data
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(md),
   .pin_bs(bsio),
   .pin_ez_n(1'b1),
   .pin_ad_en(doe)
);

defparam ctl0.DC303_CS = 0;
dc303 ctl0
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(md),
   .pin_rst(reset),
   .pin_ez_n(1'b1),
   .pin_cs_n(csel_n)
);

defparam ctl1.DC303_CS = 1;
dc303 ctl1
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(md),
   .pin_rst(reset),
   .pin_ez_n(1'b1),
   .pin_cs_n(csel_n)
);

defparam ctl2.DC303_CS = 2;
dc303 ctl2
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(md),
   .pin_rst(reset),
   .pin_ez_n(1'b1),
   .pin_cs_n(csel_n)
);

dc304 mmu
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_a(a),
   .pin_m(md[12:4]),
   .pin_m15(md[15]),
   .pin_me_n(umap_n),
   .pin_ra_n(mrply_n),
   .pin_de_n(abort_n),
   .pin_bs(bsio),
   .pin_ez_n(dmmus_n)
);

//_____________________________________________________________________________
//
endmodule
