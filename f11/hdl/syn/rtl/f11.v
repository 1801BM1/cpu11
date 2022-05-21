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
#(parameter
//______________________________________________________________________________
//
// F11_CORE_MMU enables code MMU generation in the dc304 module
// F11_CORE_FPP enables code of FPP MiCROM in the dc303 module
//
   F11_CORE_MMU = 1,
   F11_CORE_FPP = 1
)
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input  [7:4]   pin_virq_n,    // vectored interrupt requests
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout  [15:0]  pin_ad_n,      // inverted address/data bus
   output [21:16] pin_a_n,       // inverted high address bus
   output         pin_umap_n,    // uppaer address mapping
   inout          pin_bs_n,      // bank 7 select
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
   inout          pin_rply_n,    // transaction reply
                                 //
   input [15:2]   pin_fdin_n,    // fast input configuration
   input [1:0]    pin_bsel_n     // boot mode selector
);

//______________________________________________________________________________
//
wire  mce_p;                     // enable positive (rising) mclk edge
wire  mce_n;                     // enable negative (falling) mclk edge
reg   mclk;                      // master CPU clock
reg   mme0, mme1;                // MMU address translation phases
reg   qrdy;                      // qbus ready for transaction
reg   drdy;                      // data ready to complete
wire  qwait;                     // wait Q-bus at mclk high
                                 //
tri1  [15:0] m;                  // microinstruction bus
tri0  [15:0] ad;                 // address/data bus
reg   [15:0] ad_reg;             // output address/data register
tri0  [21:16] a;                 // high address bus
wire  bs_cpu, bs_mmu, bsio;      // I/O bank select logic
reg   bs_reg;                    //
                                 //
wire  doe;                       //
reg   ad_ena;                    // enable address/data bus drivers
wire  ad_stb;                    // latch address/data bus inputs
wire  ad_oe;                     //
                                 //
tri1  umap_n;                    // upper addresses mapping enable
tri1  abort_n;                   // abort bus cycle (error/timeout)
reg   reset;                     // reset control chip/CPU
tri1  mrply_n;                   // MMU access acknowlegement
tri1  csel_n;                    // control chip selected
                                 //
reg   qt_req;                    // Q-bus timer request
reg   [5:0] qt_cnt;              // Q-bus timer counter
                                 //
reg   bus_init;                  // Q-bus init signal
reg   init, dclo, pdclo;         // DCLO logic registers
reg   aclo, aclo0;               //
reg   evnt, evnt0;               //
reg   ctl_err;                   //
reg   bus_err;                   //
reg   bus_cyc;                   //
                                 //
reg   sync, sy_set, sy_clr;      //
reg   din, dout, iako;           //
                                 //
reg   wtbt;                      //
wire  dout_cyc;                  //
wire  din_cyc;                   //
wire  rply;                      //
                                 //
reg   dis_mmu;                   // disable MMU for cycle
wire  ena_odt;                   // ODT adress translation
reg   [17:16] odt_a;             //
                                 //
wire  aclo_clr, evnt_clr;        //
wire  odt_stb, srun;             //
                                 //
wire  svc_oe, fdin_oe;           //
wire  [15:0] svc;                //
wire  [15:0] fdin;               //
reg   [12:4] svc_reg;            //
                                 //
//______________________________________________________________________________
//
// Clock generator
//
always @(posedge pin_clk)
begin
   if (mce_p) mclk <= 1'b1;
   if (mce_n) mclk <= 1'b0;
end

assign mce_n = ~init & mclk & ~qwait;
assign mce_p = init | ~mclk & ~mme0;

assign qwait = ~drdy &  m[12] & ~(m[9] & m[8]) & bus_cyc
             | ~qrdy & ~m[12];

always @(posedge pin_clk)
begin
   mme0 <= ~m[15] & mce_n & ~init;
   mme1 <= mme0 & ~init & abort_n;

   if ((~din & ~dout) | init)
      drdy <= 1'b0;
   else
      if (rply & (din | dout))
         drdy <= 1'b1;
   qrdy <= ~sync | init;
end

//______________________________________________________________________________
//
// Initialization curcuits
//
always @(posedge pin_clk)
begin
   init <= ~pin_dclo_n;
   if (init)
   begin
      bus_err  <= 1'b0;
      bus_init <= 1'b0;
   end
   else
   begin
      if (mce_n)
      begin
         bus_err  <= qt_req;
         bus_init <= m[14];
      end
   end
end
//______________________________________________________________________________
//
assign pin_a_n  = ad_ena ? ~a : 6'oZZ;
assign pin_ad_n = ad_ena ? ~ad_reg : 16'oZZZZZZ;
assign pin_bs_n = ad_ena ? ~bs_reg : 1'bz;

always @(posedge pin_clk)
begin
   if (ad_stb)
   begin
         ad_reg <= ad;
         bs_reg <= bsio;
   end
end

assign pin_umap_n = umap_n;
assign pin_din_n  = ~din;
assign pin_dout_n = ~dout;
assign pin_iako_n = ~iako;
assign pin_sync_n = ~sync;
assign pin_wtbt_n = ~wtbt;
assign pin_init_n = bus_init ? 1'b0 : 1'bz;
assign pin_rply_n = ~mrply_n ? 1'b0 : 1'bz;

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

assign fdin = {~pin_fdin_n[15:8], ~init, 4'b0000, ~pin_fdin_n[2], pin_bsel_n[1:0]};
assign svc = {3'bzzz, svc_reg[12:5], ctl_err, abort_n, 1'b0, svc_reg[4], ~dclo };

assign fdin_oe = mclk & m[3];
assign svc_oe = ~mclk & ~mme0 & ~mme1;

always @(posedge pin_clk or posedge init)
begin
   if (init)
      dclo <= 1'b1;
   else
      if (mce_p)
         dclo <= pdclo;
end

assign ad_oe = din & mrply_n;
assign ad_stb = mce_n & ~m[12] | mclk & m[12] & ~m[9] & bus_cyc | mme0;
assign ena_odt = mce_n & ~m[12] & dis_mmu;

always @(posedge pin_clk or posedge init)
begin
   if (init)
      dis_mmu <= 1'b0;
   else
      if (mce_p)
         dis_mmu <= ~m[6] & m[7];
end

assign a[16] = ena_odt ? odt_a[16] : 1'bz;
assign a[17] = ena_odt ? odt_a[17] : 1'bz;
assign bsio =  ena_odt & odt_a[16] & odt_a[17] & bs_cpu
             |~ena_odt & (bs_cpu | bs_mmu);

always @(posedge pin_clk)
begin
   if (odt_stb)
      odt_a[17:16] <= ad[1:0];
end
//______________________________________________________________________________
//
assign dout_cyc  = m[12] & ~m[9] & bus_cyc;
assign din_cyc   = m[12] & m[9] & ~m[8] & bus_cyc;

assign rply = qt_req | ~pin_rply_n;

always @(posedge pin_clk)
begin
   if (reset | mce_n)
   begin
      din <= 1'b0;
      dout <= 1'b0;
      iako <= 1'b0;
   end
   else
   begin
      din <= din_cyc & mclk;
      dout <= dout_cyc & mclk;
      iako <= m[13] & mclk;
   end
end


//
// Bus cycle decodig ROM is replaced with equivalent equations
//
always @(posedge pin_clk)
begin
   if (mce_n)
      wtbt <= ~m[9] & ~m[8];
   if (mclk)
      ad_ena <= ~m[12] | ~m[9] & bus_cyc;
end

always @(posedge pin_clk)
begin
   if (init)
   begin
      ctl_err <= 1'b0;
      pdclo   <= 1'b1;
      bus_cyc <= 1'b0;
      sy_set  <= 1'b0;
      sy_clr  <= 1'b0;
   end
   else
      if (mce_n)
      begin
         ctl_err <= csel_n;
         pdclo   <= 1'b0;
         bus_cyc <= ~m[12] | ~m[7];
         sy_set  <= ~m[7];
         sy_clr  <= m[7] & ~rply;
      end
end

always @(posedge pin_clk)
begin
   if (reset | ~bus_cyc & ~rply)
      sync <= 1'b0;
   else
      if (sy_set & mce_p)
         sync <= 1'b1;
      else
         if (sy_clr)
            sync <= 1'b0;
end

always @(posedge pin_clk or posedge init)
begin
   if (init)
      reset <= 1'b1;
   else
   begin
      if (mce_p)
         reset <= 1'b0;
      else
         if (~abort_n)
            reset <= 1'b1;
         else        // (ctl_err | bus_err)
            if (mce_n & (csel_n | qt_req | dclo))
               reset <= 1'b1;
   end
end

//______________________________________________________________________________
//
// Interrupts
//
assign srun     = (m[3:0] == 4'b0001) & mce_n;
assign evnt_clr = (m[3:0] == 4'b0101) & mce_n;
assign aclo_clr = (m[3:0] == 4'b0110) & mce_n;
assign odt_stb  = (m[3:0] == 4'b0111) & mce_n;

always @(posedge pin_clk)
begin
   aclo0 <= ~pin_aclo_n;
   evnt0 <= ~pin_evnt_n;
end

always @(posedge pin_clk or posedge init)
begin
   if (init)
      aclo <= 1'b0;
   else
      if (aclo_clr)
         aclo <= 1'b0;
      else
         if (~aclo0 & ~pin_aclo_n)
            aclo <= 1'b1;
end

always @(posedge pin_clk or posedge bus_init)
begin
   if (bus_init)
      evnt <= 1'b0;
   else
      if (evnt_clr)
         evnt <= 1'b0;
      else
         if (~evnt0 & ~pin_evnt_n)
            evnt <= 1'b1;
end

always @(posedge pin_clk)
begin
   if (mce_n)
   begin
      svc_reg[12] <= evnt;
      svc_reg[11] <= ~pin_virq_n[4];
      svc_reg[10] <= ~pin_virq_n[5];
      svc_reg[9]  <= ~pin_virq_n[6];
      svc_reg[8]  <= ~pin_virq_n[7];
      svc_reg[7]  <= aclo;
      svc_reg[6]  <= 1'b1;
      svc_reg[5]  <= ~pin_halt_n;
      svc_reg[4]  <= qt_req;
   end
end

//______________________________________________________________________________
//
// Bus transaction timer
//
always @(posedge pin_clk or posedge init)
begin
   if (init)
   begin
      qt_cnt <= 6'b000000;
      qt_req <= 1'b0;
   end
   else
      if (din | dout)
      begin
         qt_cnt <= qt_cnt + 6'b000001;
         qt_req <= &qt_cnt | qt_req;
      end
      else
      begin
         qt_cnt <= 6'b000000;
         if (mce_p)
            qt_req <= 1'b0;
      end
end

//______________________________________________________________________________
//
// Instantiate chipset components
//
dc302 data
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(m),
   .pin_bsi(bsio),
   .pin_bso(bs_cpu),
   .pin_ez_n(1'b1),
   .pin_ad_en(doe)
);

defparam ctl0.DC303_FPP = F11_CORE_FPP;
dc303 ctl0
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_m(m),
   .pin_rst(reset),
   .pin_cs_n(csel_n)
);

dc304 mmu
(
   .pin_clk(mclk),
   .pin_ad(ad),
   .pin_a(a),
   .pin_m(m[12:4]),
   .pin_m15(m[15]),
   .pin_me_n(umap_n),
   .pin_ra_n(mrply_n),
   .pin_de_n(abort_n),
   .pin_bsi(bsio),
   .pin_bso(bs_mmu),
   .pin_ez_n(~ena_odt)
);

//_____________________________________________________________________________
//
endmodule
