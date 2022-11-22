//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
// F-11 asynchronous model with Wishbone frontend bus.
//
//______________________________________________________________________________
//
module f11_wb
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
   //
   // Processor core clock section:
   //    - vm_clk_p     - processor core positive clock, also feeds the wishbone buses
   //    - vm_clk_n     - processor core negative clock, should be vm_clk_p 180 degree phase shifted
   //    - vm_clk_ena   - slow clock simulation strobe, enables clock at vm_clk_p
   //    - vm_clk_slow  - clock mode selector, enables clock slowdown simulation,
   //                     the external I/O cycles is launched with rate of vm_clk_ena
   //
   input          vm_clk_p,      // positive edge clock
   input          vm_clk_n,      // negative edge clock
   input          vm_clk_ena,    // slow clock enable
   input          vm_clk_slow,   // slow clock sim mode
                                 //
   output         vm_init,       // peripheral reset output
   input          vm_dclo,       // processor reset
   input          vm_aclo,       // power fail notificaton
   input          vm_halt,       // halt mode interrupt
   input          vm_evnt,       // timer interrupt requests
   input  [7:4]   vm_virq,       // vectored interrupt request
                                 //
   input          wbm_gnt_i,     // master wishbone granted
   output         wbm_ios_o,     // master wishbone bank I/O select
   output [21:0]  wbm_adr_o,     // master wishbone address
   output [15:0]  wbm_dat_o,     // master wishbone data output
   input  [15:0]  wbm_dat_i,     // master wishbone data input
   output         wbm_cyc_o,     // master wishbone cycle
   output         wbm_we_o,      // master wishbone direction
   output [1:0]   wbm_sel_o,     // master wishbone byte select
   output         wbm_stb_o,     // master wishbone strobe
   input          wbm_ack_i,     // master wishbone acknowledgement
                                 //
   input  [15:0]  wbi_dat_i,     // interrupt vector input
   input          wbi_ack_i,     // interrupt vector acknowledgement
   output         wbi_stb_o,     // interrupt vector strobe
   output         wbi_una_o,     // unaddressed fast input read
                                 //
   output         vm_umap,       // enable dma address translation
   input [1:0]    vm_bsel        // boot mode selector
);

//______________________________________________________________________________
//
wire  mce_p;                     // enable positive (rising) mclk edge
wire  mce_n;                     // enable negative (falling) mclk edge
reg   mclk;                      // master CPU clock
reg   mme0, mme1;                // MMU address translation phases
reg   qrdy;                      // bus ready for transaction
reg   drdy;                      // data ready to complete
                                 //
wire  [15:0] mo;                 // early microbus status/command
reg   [15:0] mc;                 // latched microbus status/command
                                 //
wire  [15:0] m;                  // microinstruction bus
wire  [15:0] ad;                 // shared address/data bus
wire  [15:0] ad_cpu;             // CPU address/data output
wire  [15:0] ad_mmu;             // MMU address/data output
reg   [21:0] wb_adr;             // wishbone output address
reg   [15:0] wb_dat;             // wishbone input data
reg   [1:0]  wb_sel;             //
                                 //
wire         wb_wclr, wb_wset;   //
reg          wb_swait;           //
reg   [5:0]  wb_wcnt;            //
                                 //
reg   wb_ios;                    // I/O bank select
reg   wb_stb;                    //
reg   wb_we;                     //
reg   wb_bcyc;                   // master bus cycle
reg   wb_iako;                   // read interrupt vector
reg   wb_fdin;                   // read fast data input
                                 //
wire  iow_req;                   // data write bus request
wire  ior_req;                   // data read bus request
wire  io_wtbt;                   // write byte request
wire  wb_wdone;                  //
wire  wb_rdone;                  //
wire  wb_idone;                  //
                                 //
wire  [21:16] at_mmu;            // MMU translated address
wire  [2:0] pga;                 // page address for MMU
wire  bs_cpu, bs_mmu, bsio;      // I/O bank select logic
                                 //
wire  doe;                       //
wire  adr_stb;                   // latch bus address
reg   wdat_oe;                   // enable latched data
reg   fdin_oe;                   //
                                 //
wire  umap;                      // upper addresses mapping enable
wire  abort;                     // abort bus cycle (error/timeout)
reg   mc_res;                    // reset control chip/CPU
wire  mr_sel;                    // MMU register selected
wire  csel;                      // control chip selected
                                 //
reg   qt_req;                    // Q-bus timer request
reg   [5:0] qt_cnt;              // Q-bus timer counter
                                 //
reg   bus_init;                  // Q-bus init signal
reg   init, dclo, pdclo;         // DCLO logic registers
reg   aclo, aclo0;               //
reg   evnt, evnt0;               //
reg   ctl_err;                   //
                                 //
wire  ena_odt;                   // ODT adress translation
reg   [17:16] odt_a;             //
                                 //
wire  aclo_clr, evnt_clr;        //
wire  odt_stb, srun;             //
                                 //
wire  [12:0] svc;                //
wire  [15:0] fdin;               //
reg   [12:4] svc_reg;            //
                                 //
//______________________________________________________________________________
//
// Clock generator
//
always @(posedge vm_clk_p)
begin
   if (mce_p) mclk <= 1'b1;
   if (mce_n) mclk <= 1'b0;
end

assign mce_n = ~init & mclk & qrdy & (drdy | mr_sel & wb_bcyc);
assign mce_p = init | ~mclk & ~mme0;

always @(posedge vm_clk_p)
begin
   mme0 <= ~mc[15] & mce_n & ~init;
   mme1 <= mme0 & ~init;

   if (mce_p)
      qrdy <= mo[12] | (wb_wcnt == 6'o00) | ~vm_clk_slow;
   else
      qrdy <= mc_res | ~wb_swait;

   if (mce_p)
      drdy <= ~(mo[12] & ~(mo[9] & mo[8]) & (wb_bcyc | mo[3] | mo[13]));
   else
      drdy <= qt_req | mc_res | wb_wdone | wb_rdone | wb_idone | mclk & ~mc[12];
end

//______________________________________________________________________________
//
// Initialization curcuits
//
always @(posedge vm_clk_p)
begin
   init <= vm_dclo;
   if (init)
      bus_init <= 1'b0;
   else
      if (mce_n)
         bus_init <= mc[14];
end
assign vm_init = bus_init;

//______________________________________________________________________________
//
// fdin[15:9]   - start address 15:9 (lower bits are zero)
// fdin[8] / E8 set - 1 - start from 173000
//           E8 mis - 0 - start from fdin[15:9]
// fdin[2] / E7 set - 1 - HALT causes exception 10
//           E7 mis - 0 - HALT invokes ODT
//
assign ad = (doe & mclk) ? ad_cpu :
             wdat_oe     ? wb_dat :
             fdin_oe     ? fdin   : ad_mmu;

assign fdin = {wb_dat[15:8], ~init, 4'b0000, wb_dat[2], ~vm_bsel[1:0]};
assign svc = {svc_reg[12:5], ctl_err, ~abort, 1'b0, svc_reg[4], ~dclo };

always @(posedge vm_clk_p or posedge init)
begin
   if (init)
   begin
      wdat_oe <= 1'b0;
      fdin_oe <= 1'b0;
   end
   else
   begin
      wdat_oe <= mclk & ~mce_n & ~mc[3] & (wb_idone | wb_rdone) & ~mr_sel;
      fdin_oe <= mclk & ~mce_n &  mc[3] & wb_idone;
   end
end

always @(posedge vm_clk_p or posedge init)
begin
   if (init)
      dclo <= 1'b1;
   else
      if (mce_p)
         dclo <= pdclo;
end

assign adr_stb = mce_n & ~mc[12] & mc[15] | mme0;
assign ena_odt = mce_n & ~mc[12] & ~m[6] & m[7];

assign bsio =   ena_odt & odt_a[16] & odt_a[17] & bs_cpu
             | ~ena_odt & ((mme0 | mme1) ? bs_mmu : bs_cpu);

always @(posedge vm_clk_p)
begin
   if (odt_stb)
      odt_a[17:16] <= ad_cpu[1:0];
end

//______________________________________________________________________________
//
always @(posedge vm_clk_p)
begin
   if (init)
   begin
      ctl_err <= 1'b0;
      pdclo   <= 1'b1;
   end
   else
      if (mce_n)
      begin
         ctl_err <= ~csel;
         pdclo   <= 1'b0;
      end
end

always @(posedge vm_clk_p or posedge init)
begin
   if (init)
      mc_res <= 1'b1;
   else
   begin
      if (mce_p)
         mc_res <= 1'b0;
      else
         if (abort & ~mclk)
            mc_res <= 1'b1;
         else        // (ctl_err | bus_err)
            if (mce_n & (~csel | qt_req | dclo))
               mc_res <= 1'b1;
   end
end

//______________________________________________________________________________
//
// Interrupts
//
assign srun     = (mc[3:0] == 4'b0001) & mce_n;
assign evnt_clr = (mc[3:0] == 4'b0101) & mce_n;
assign aclo_clr = (mc[3:0] == 4'b0110) & mce_n;
assign odt_stb  = (mc[3:0] == 4'b0111) & mce_n;

always @(posedge vm_clk_p)
begin
   aclo0 <= vm_aclo;
   evnt0 <= vm_evnt;
end

always @(posedge vm_clk_p or posedge init)
begin
   if (init)
      aclo <= 1'b0;
   else
      if (aclo_clr)
         aclo <= 1'b0;
      else
         if (~aclo0 & vm_aclo)
            aclo <= 1'b1;
end

always @(posedge vm_clk_p or posedge bus_init)
begin
   if (bus_init)
      evnt <= 1'b0;
   else
      if (evnt_clr)
         evnt <= 1'b0;
      else
         if (~evnt0 & vm_evnt)
            evnt <= 1'b1;
end

always @(posedge vm_clk_p)
begin
   if (mce_n)
   begin
      svc_reg[12] <= evnt;
      svc_reg[11] <= vm_virq[4];
      svc_reg[10] <= vm_virq[5];
      svc_reg[9]  <= vm_virq[6];
      svc_reg[8]  <= vm_virq[7];
      svc_reg[7]  <= aclo;
      svc_reg[6]  <= 1'b1;
      svc_reg[5]  <= vm_halt;
      svc_reg[4]  <= qt_req;
   end
end

//______________________________________________________________________________
//
// Instantiate chipset components
//
dc302 data
(
   .pin_clk(vm_clk_p),
   .pin_mce_p(mce_p),
   .pin_mce_n(mce_n),
   .pin_ado(ad_cpu),
   .pin_adi(ad),
   .pin_m(m),
   .pin_mo(mo[14:0]),
   .pin_mc(mc),
   .pin_bsi(bsio),
   .pin_bso(bs_cpu),
   .pin_aden(doe),
   .pin_pga(pga)
);

defparam ctl.DC303_FPP = F11_CORE_FPP;
dc303 ctl
(
   .pin_clk(vm_clk_p),
   .pin_mce_p(mce_p),
   .pin_mce_n(mce_n),
   .pin_ad(ad),
   .pin_m(m),
   .pin_mc(mc),
   .pin_svc(svc),
   .pin_bra(mo[11]),
   .pin_rst(mc_res),
   .pin_cs(csel)
);

defparam mmu.DC304_FPP = F11_CORE_FPP;
defparam mmu.DC304_MMU = F11_CORE_MMU;
dc304 mmu
(
   .pin_clk(vm_clk_p),
   .pin_mce_p(mce_p),
   .pin_mce_n(mce_n),
   .pin_ado(ad_mmu),
   .pin_adi(ad),
   .pin_a(at_mmu),
   .pin_m(m[12:4]),
   .pin_mo(mo[12:4]),
   .pin_mc(mc[12:4]),
   .pin_m15(mo[15]),
   .pin_me(umap),
   .pin_ra(mr_sel),
   .pin_de(abort),
   .pin_bsi(bsio),
   .pin_bso(bs_mmu),
   .pin_pga(pga)
);

always @(posedge vm_clk_p) if (mce_p) mc <= mo;

//______________________________________________________________________________
//
// Bus transaction timer
//
always @(posedge vm_clk_p or posedge init)
begin
   if (init)
   begin
      qt_cnt <= 6'b000000;
      qt_req <= 1'b0;
   end
   else
      if ((wbm_stb_o & wbm_gnt_i) | wbi_stb_o)
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
// Wishbone master and interrupt interfaces
//
assign vm_umap    = umap;
assign io_wtbt    = mce_p & wb_bcyc & mo[12] & ~mo[9] & ~mo[8];
assign iow_req    = mce_p & wb_bcyc & mo[12] & ~mo[9];
assign ior_req    = mce_p & wb_bcyc & mo[12] & mo[9] & ~mo[8];

assign wb_wdone   = wb_stb & wbm_ack_i & wb_we;
assign wb_rdone   = wb_stb & wbm_ack_i & ~wb_we;
assign wb_idone   = (wb_iako | wb_fdin) & wbi_ack_i;

assign wbm_ios_o  = wb_ios;
assign wbm_adr_o  = wb_adr;
assign wbm_dat_o  = ad_cpu;
assign wbm_cyc_o  = wb_bcyc;
assign wbm_we_o   = wb_we & ~mr_sel;
assign wbm_stb_o  = ~wb_iako & wb_stb & ~mr_sel;
assign wbm_sel_o  = wb_sel;
assign wbi_stb_o  = wb_iako | wb_fdin;
assign wbi_una_o  = wb_fdin;

assign wb_wset    = mce_p & ~mo[12] & vm_clk_slow & (wb_wcnt != 6'o00);
assign wb_wclr    = mc_res | ~vm_clk_slow | (vm_clk_ena & (wb_wcnt == 6'o01));

//
// Interrupt Wishbone is simplified and has no clock moderator
//
always @(posedge vm_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      wb_iako <= 1'b0;
      wb_fdin <= 1'b0;
   end
   else
   begin
      if (mce_p)
      begin
         if (mo[13])
            wb_iako <= 1'b1;
         if (mo[3])
            wb_fdin <= 1'b1;
      end
      else
         if (wb_idone)
         begin
            wb_iako <= 1'b0;
            wb_fdin <= 1'b0;
         end
   end
end

//
// Wishbone Master state machine
//
always @(posedge vm_clk_p or posedge mc_res)
begin
   if (mc_res)
   begin
      //
      // Master wishbone abort/reset
      //
      wb_swait <= 1'b0;
      wb_wcnt <= 6'o00;
      wb_bcyc <= 1'b0;
      wb_we   <= 1'b0;
      wb_sel  <= 2'b00;
      wb_stb  <= 1'b0;
   end
   else
   begin
      //
      // Clock moderator delays the I/O transaction
      // beginning till counter elapsed
      //
      if (wb_wclr)
         wb_swait <= 1'b0;
      else
         if (wb_wset)
            wb_swait <= 1'b1;

      if (wb_swait)
      begin
         if ((vm_clk_ena | ~vm_clk_slow) & (wb_wcnt != 6'o00))
            wb_wcnt <= wb_wcnt - 6'o01;
      end
      else
      begin
         if (~vm_clk_ena & vm_clk_slow & (wb_wcnt != 6'o77))
            wb_wcnt <= wb_wcnt + 6'o01;
      end
      //
      // Strobe bus address and I/O bank select
      //
      if (adr_stb)
      begin
         wb_adr[15:0]  <= mme0 ? ad_mmu : ad_cpu;
         wb_adr[21:16] <= mme0 ? at_mmu[21:16] :
                          ena_odt ? {4'o00, odt_a[17:16]} : 6'o00;
         wb_ios <= bsio;
      end
      //
      // Strobe bus data receiving registers
      //
      if (wb_idone | wb_rdone)
            wb_dat <= wb_idone ? wbi_dat_i : wbm_dat_i;
      //
      // Wishbone cycle start-end
      //
      if (adr_stb)
      begin
         wb_bcyc <= ~mc[7];
         wb_sel  <= mc[7] ? 2'b00 : 2'b11;
         wb_we   <= 1'b0;
         wb_stb  <= 1'b0;
      end
      else
      begin
         if (wb_wdone | wb_rdone | wb_stb & mr_sel)
         begin
            if (mc[7])
               wb_bcyc <= 1'b0;
            wb_sel  <= 2'b00;
            wb_we   <= 1'b0;
            wb_stb  <= 1'b0;
         end
         if (ior_req)
         begin
            wb_sel  <= 2'b11;
            wb_we   <= 1'b0;
            wb_stb  <= 1'b1;
         end
         else
         if (iow_req)
         begin
            wb_sel[0] <= ~io_wtbt | ~wb_adr[0];
            wb_sel[1] <= ~io_wtbt |  wb_adr[0];
            wb_we   <= 1'b1;
            wb_stb  <= 1'b1;
         end
      end
   end
end

//_____________________________________________________________________________
//
endmodule
