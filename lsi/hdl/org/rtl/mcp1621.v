//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// MCP-1621 Control Chip model, for debug and simulating only
//______________________________________________________________________________
//
module mcp1621
(
   input          pin_c1,        // clock phase 1
   input          pin_c2,        // clock phase 2
   input          pin_c3,        // clock phase 3
   input          pin_c4,        // clock phase 4
   inout [17:0]   pin_m_n,       // microinstruction bus
                                 //
   input [4:1]    pin_inrrq,     // interrupt requests
   input          pin_bbusy,     // bus busy
   input          pin_comp,      // debug mode
   input          pin_sr_n,      // system reset
   input          pin_ra,        // ready
                                 //
   output         pin_syn,       // cycle sync
   output         pin_di,        // data input
   output         pin_do,        // data output
   output         pin_inrak,     // interrupt ack
   output         pin_wrby,      // write byte
   output         pin_wi         // wait
);

//______________________________________________________________________________
//
wire  c1;            // internal clocks
wire  c2;            //
wire  c3;            //
wire  c4;            //
                     //
reg   sr;            // system reset latches
reg   sr_c4;         //
                     //
reg   wi;            //
reg   wi_c2;         //
reg   wi_c3;         //
reg   plmq;          //
reg   plmq_c4;       //
reg   comp;          //
wire  m16_out;       //
                     //
reg   [10:0] lc;     // location counter
reg   [10:0] lc2;    //
reg   [10:0] rr;     // return register
reg   [10:0] inc;    // counter increment
reg   [15:0] mir;    // microinstruction register
reg   [10:0] lir;    // microinstruction register (lc latch)
reg   [15:0] mtr;    // microinstruction translation
reg   [2:0] tsr;     // translation status register
                     //
reg   [7:1] irq;     //
reg   [7:1] irq_c4;  //
reg   [7:5] irq_set; //
reg   [7:5] irq_clr; //
reg   rni;           //
                     //
wire  [19:0] plm_pl; // microinstruction decoder
reg   [19:0] plm;    // microinstruction decoder, latched on C3
                     //
wire  ldtr;          // load translation register
wire  ldmir;         // load microinstruction register
wire  lra;           // load return address
wire  lta;           // load translation address
wire  ldinc;         // load incremented counter
wire  lrr;           // load return register
wire  ldlca, ldja;   // load local counter, low part
wire  ldlcb, ldjb;   // load local counter, high part
wire  ctsr;          // clear translation status register
                     //
reg   ldtr_c4;       //
reg   lra_c4;        //
reg   lta_c4;        //
reg   ldja_c4;       //
reg   ldjb_c4;       //
reg   ldlca_c4;      //
reg   ldlcb_c4;      //
reg   ldinc_c4;      //
reg   ldmir_c4;      //
reg   lrr_c4;        //
reg   lrr_c1;        //
reg   ctsr_c4;       //
                     //
reg   di_out;        // Q-bus output latches
reg   dou_out;       //
reg   syn_out;       //
reg   iak_out;       //
reg   wrb_out;       //
reg   di;            //
reg   syn;           //
reg   inak;          //
reg   wrby;          //
                     //
reg   di_t0783;      //
reg   di_t0784;      //
reg   di_t0801;      //
reg   syn_clr;       //
reg   syn_c4;        //
reg   inak_c4;       //
wire  syn_q1;        //
                     // translation array outputs
wire  ldtsra;        // load translation status
reg   ldtsrb;        // load translation status
wire  plm_lra;       // load return address
wire  plm_lta;       // load translation address
reg   [2:0] tsra;    // translation status
reg   [10:0] pta;    // translation address
wire  [2:0] plm_tsr; //
wire  [10:0] plm_pta;//

//______________________________________________________________________________
//
// External pin assignments
//
//                   c1          c2          c3          c4
// m[10:0]        in mi/data  out addr    out addr    pre-charge
// m[14:11]       in mi/data     z           z        pre-charge
// m[15]          in mi/data     z           z         in jcond
// m[16]          in lra      pre-charge  disable ROM pre-charge
// m[17]          in rni         z           z        pre-charge
//
// On system reset 0xFFzz microcode is translated - NOP
//
assign pin_m_n[10:0]    = (c2 | c3) ? ~lc[10:0]
                        : ((c1 & sr) ? 11'b000zzzzzzzz : 11'bzzzzzzzzzzz);
assign pin_m_n[15:11]   = (c1 & sr) ? 5'h00 : 5'hzz;
assign pin_m_n[16]      = (c3 & m16_out) ? 1'b0 : 1'bz;
assign pin_m_n[17]      = 1'bz;

assign pin_wi     = wi;
assign pin_syn    = syn_out;
assign pin_di     = di_out;
assign pin_do     = dou_out;
assign pin_inrak  = iak_out;
assign pin_wrby   = wrb_out;

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
// System reset strobes
//
always @(*)
begin
   if (c2)
      sr <= ~pin_sr_n;
   if (c1)
      sr_c4 <= 1'b0;
   else
      if (c4)
         sr_c4 <= sr | wi;
end

//______________________________________________________________________________
//
// Wait bus ready and debug
//
always @(*)
begin
   if (c1)
      comp = pin_comp;
   if (c1)
      wi <= 1'b0;
   else
      if (c4)
         wi <= ~sr & ~(wi_c2 & ~wi_c3);
   if (c1)
      wi_c2 <= 1'b1;
   else
      if (c2)
         wi_c2 <= comp | plmq;
   if (c3)
      wi_c3 <= (pin_bbusy | pin_ra) & (plm_pl[15] | plm_pl[16])
             | (plm_pl[4] | plm_pl[5]) & (~pin_ra | (plm_pl[4] & ~di_out));
end

//______________________________________________________________________________
//
// Microinstruction decoder
//
always @(*) if (c3) plm <= plm_pl;
always @(*) if (c4) plmq_c4 <= ~sr_c4 & m16_out;
always @(*) if (c2) plmq <= plmq_c4;

mcp_plc plc
(
   .q(plmq),
   .mir(mir),
   .plm(plm_pl)
);

//______________________________________________________________________________
//
// Control block registers:
//
//    - location counter
//    - return address register
//    - microinstruction register
//    - translation register
//    - translation status register
//
always @(*)
begin
   if (c2)
      lc2 <= lc[10:0];

   if (c1)
      if (sr)
         lc[10:0] <= 11'h001;
      else
         begin
            lc[7:0]  <= (ldlca ? lc2[7:0] : 8'hff)
                      & (ldja  ? lir[7:0] : 8'hff)
                      & (ldinc ? inc[7:0] : 8'hff)
                      & (lta   ? pta[7:0] : 8'hff)
                      & (lra   ? rr[7:0] : 8'hff);

            lc[10:8] <= (ldlcb ? lc2[10:8] : 3'b111)
                      & (ldjb  ? lir[10:8] : 3'b111)
                      & (ldinc ? inc[10:8] : 3'b111)
                      & (lta   ? pta[10:8] : 3'b111)
                      & (lra   ? rr[10:8] : 3'b111);
         end
      if (c4)
         inc[10:0] <= lc[10:0] + 10'h001;
      if (c2)
         if (lrr)
            rr[10:0] <= inc[10:0];
end

always @(*) if (c1 & ldtr) mtr[15:0] <= ~pin_m_n[15:0];
always @(*) if (c1 & ldmir) mir[15:0] <= ~pin_m_n[15:0];
always @(*) if (c3) lir[10:0] <= mir[10:0];

always @(*)
if (c1)
begin
   if (ctsr)
      tsr[2:0] <= 3'b000;
   else
      if (ldtsrb)
         tsr[2:0] <= tsra[2:0];
end

//______________________________________________________________________________
//
assign lra   = c1 & lra_c4;
assign lta   = c1 & lta_c4;
assign ldja  = c1 & ldja_c4;
assign ldjb  = c1 & ldjb_c4;
assign ldlca = c1 & ldlca_c4;
assign ldlcb = c1 & ldlcb_c4;
assign ldinc = c1 & ldinc_c4;
assign ldmir = c1 & ldmir_c4;
assign lrr   = c2 & lrr_c4 & lrr_c1;
assign ldtr  = c1 & ldtr_c4;
assign ctsr  = c1 & ctsr_c4;

always @(*)
if (c4)
begin
   lra_c4   <= (~m16_out & ~sr_c4 &  plm_lra) | (plm[3] & ~sr_c4);
   lta_c4   <=  ~m16_out & ~sr_c4 & ~plm_lra &  plm_lta;
   ldinc_c4 <=  ~m16_out & ~sr_c4 & ~plm_lra & ~plm_lta;
   ldmir_c4 <= sr | (~m16_out & ~sr_c4);

   ldja_c4  <= ~sr_c4 & (plm[1] | plm[2] & ~pin_m_n[15]);   // load jump condition
   ldjb_c4  <= ~sr_c4 &  plm[1];                            // from m[15] on c4
   ldlca_c4 <=  sr_c4 | ~ldja_c4 & m16_out & ~plm[3];       // keep the register
   ldlcb_c4 <=  sr_c4 | ~ldjb_c4 & m16_out & ~plm[3];       // if no other strobes

   ldtr_c4  <= ~sr_c4 & (plm[6] | (plm[8] & (mir[4] | mir[5])));
   ldtsrb <= ~sr_c4 & ~m16_out & ldtsra;
   ctsr_c4  <= ~sr_c4 & plm[14];

   tsra <= plm_tsr;
   pta  <= plm_pta;
end

always @(*)
begin
   if (c4)
      lrr_c4 <= ~sr_c4 & ~m16_out;
   if (c1)
      lrr_c1 <= ~pin_m_n[16];
end


//______________________________________________________________________________
//
// Translation arrays
//
mcp_pta pla
(
   .rni(rni),        // read next instruction
   .lc(lc),          // location counter
   .tr(mtr),         // translation register high/low
   .ts(tsr),         // translation status
   .irq(irq),        // interrupt requests
   .pta(plm_pta),    // programmable translation address
   .tsr(plm_tsr),    // translation status register
   .lra(plm_lra),    // load return address
   .lta(plm_lta),    // load translation address
   .ltsr(ldtsra)     // load translation status register
);

always @(*)
begin
   if (c1)
   begin
      if (sr)
         rni <= 1'b0;
      else
         if (ldmir)
            rni <= ~pin_m_n[17];
   end
end

assign m16_out = plm_pl[0];
//______________________________________________________________________________
//
// Interrupts
//
always @(*)
begin
   if (c2)
      irq[7:1] <= irq_c4[7:1];
   if (c4)
      irq_c4[4:1] <= pin_inrrq[4:1];

   if (c1)
   begin
      if (irq_set[5])
         irq_c4[5] <= 1'b1;
      else
         if (irq_clr[5])
            irq_c4[5] <= 1'b0;

      if (irq_set[6])
         irq_c4[6] <= 1'b1;
      else
         if (irq_clr[6])
            irq_c4[6] <= 1'b0;

      if (irq_set[7])
         irq_c4[7] <= 1'b1;
      else
         if (irq_clr[7])
            irq_c4[7] <= 1'b0;
   end

   if (c4)
   begin
      irq_set[5] <= ~sr_c4 & mir[4] & plm[13];
      irq_clr[5] <= ~sr_c4 & mir[4] & plm[12];
      irq_set[6] <= ~sr_c4 & mir[5] & plm[13];
      irq_clr[6] <= ~sr_c4 & mir[5] & plm[12];
      irq_set[7] <= ~sr_c4 & mir[6] & plm[13];
      irq_clr[7] <= ~sr_c4 & mir[6] & plm[12];
   end
end

//______________________________________________________________________________
//
// Q-bus controls
//
always @(*)
begin
   if (c2)
   begin
      di_out  <= di;
      syn_out <= syn;
      iak_out <= inak;

      di_t0801 <= ~di_t0783;
   end
   if (c1)
      wrb_out <= wrby;
   if (c4)
   begin
      dou_out <= plm[5];
      wrby <= plm[11] | (~sr_c4 & (plm[9] | plm[10]));
      di_t0783 <= ~sr_c4 & ~syn_out & (plm[17] | plm[18]);
      di_t0784 <= ~sr_c4 & ~m16_out & (plm[4] | plm[5]);
      syn_clr <= ~sr_c4 & ~m16_out & (plm[5] | plm[4] & (~mir[6] | syn_q1));
      syn_c4  <= syn_out | ~sr_c4 & (plm[15] | plm[16]);
      inak_c4 <= iak_out | ~sr_c4 & plm[19];
   end
   if (c1)
   begin
      di   <= ~sr & (di_out | syn_out & ~di_t0801) & ~di_t0784;
      syn  <= ~sr & syn_c4 & ~syn_clr;
      inak <= ~sr & inak_c4 & ~syn_clr;
   end
end
//
// Q1 flag of IW microinstruction, controls Read-Modify-Write Cycle
//
assign syn_q1 = ~mtr[14] & (mtr[13] | (mtr[12:6] == 7'b0101111));

endmodule
