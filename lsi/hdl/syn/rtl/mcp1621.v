//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// MCP-1621 Control Chip model, syncronous model, for debug and simulating only
//______________________________________________________________________________
//
module mcp1621
(
   input          pin_clk,       // main clock
   input          pin_c1,        // clock phase 1
   input          pin_c2,        // clock phase 2
   input          pin_c3,        // clock phase 3
   input          pin_c4,        // clock phase 4
   input          pin_cond,      // condition taken
   input [17:0]   pin_mi,        // microinstruction bus
   input [4:1]    pin_inrrq,     // interrupt requests
   input          pin_bbusy,     // bus busy
   input          pin_sr_n,      // system reset
   input          pin_ra,        // ready
                                 //
   output [10:0]  pin_lc,        // location counter
   output         pin_nop,       // put NOP on bus
   output         pin_inp,       // input data/ROM
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
wire  c3;            //
wire  c4;            //
                     //
reg   sr;            // system reset latches
reg   wi;            //
wire  sr_wi;         //
                     //
reg   plmq;          //
wire  m16_out;       //
                     //
wire  [10:0] inc;    // counter increment
reg   [10:0] lc;     // location counter
reg   [10:0] rr;     // return register
reg   [15:0] mir;    // microinstruction register
reg   [15:0] mtr;    // microinstruction translation
reg   [2:0] tsr;     // translation status register
                     //
reg   [7:1] irq;     //
wire  [7:5] irq_set; //
wire  [7:5] irq_clr; //
reg   rni;           //
                     //
wire  [19:0] plm;    // microinstruction decoder
                     //
wire  ldtr;          // load translation register
wire  ldmir;         // load microinstruction register
wire  lra;           // load return address
wire  lta;           // load translation address
wire  ldinc;         // load incremented counter
wire  ldja;          // load local counter, low part
wire  ldjb;          // load local counter, high part
wire  ctsr;          // clear translation status register
wire  lrr;           // load return register
                     //
reg   di;            // Q-bus output latches
reg   dout;          //
reg   syn;           //
reg   iak;           //
reg   wrby;          //
                     //
wire  di_clr;        //
reg   di_set;        //
wire  syn_clr;       //
wire  syn_set;       //
wire  iak_set;       //
wire  syn_q1;        //
                     // translation array outputs
wire  ldtsra;        // load translation status
wire  ldtsrb;        // load translation status
wire  plm_lra;       // load return address
wire  plm_lta;       // load translation address
wire  [2:0] tsra;    // translation status
wire  [10:0] pta;    // translation address

//______________________________________________________________________________
//
// External pin assignments
//
assign pin_lc[10:0]  = lc[10:0];
assign pin_nop       = sr;
assign pin_inp       = m16_out;

assign pin_wi     = wi;
assign pin_syn    = syn;
assign pin_di     = di;
assign pin_do     = dout;
assign pin_inrak  = iak;
assign pin_wrby   = wrby;

//______________________________________________________________________________
//
// Internals clocks
//
assign c1 = pin_c1;
assign c3 = pin_c3;
assign c4 = pin_c4;

//______________________________________________________________________________
//
// System reset and wait bus ready
//
assign sr_wi = sr | wi;
always @(posedge pin_clk)
if (c3)
begin
   wi <= pin_sr_n & ((pin_bbusy | pin_ra) & (plm[15] | plm[16])
       | (plm[4] | plm[5]) & (~pin_ra | (plm[4] & ~di)));
   sr <= ~pin_sr_n;
end

//______________________________________________________________________________
//
// Microinstruction decoder
//
always @(posedge pin_clk) if (c1) plmq <= ~sr_wi & m16_out;
assign m16_out = plm[0];
assign lrr = pin_mi[16] & ldmir;
assign inc = lc + 10'h001;

mcp_plc plc
(
   .q(plmq),
   .mir(mir),
   .plm(plm)
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
always @(posedge pin_clk)
if (c1)
begin
   if (sr)
      lc[10:0] <= 11'h001;
   else
      begin
         if (lra | lta | ldinc | ldja)
            lc[7:0]  <= (ldja ? mir[7:0] : 8'h00)
                     | (ldinc ? inc[7:0] : 8'h00)
                     | (lta   ? pta[7:0] : 8'h00)
                     | (lra   ? rr[7:0] : 8'h00);

         if (lra | lta | ldinc | ldmir | ldjb)
            lc[10:8] <= (ldjb ? mir[10:8] : 3'b000)
                     | (ldinc ? inc[10:8] : 3'b000)
                     | (lta   ? pta[10:8] : 3'b000)
                     | (lra   ? rr[10:8] : 3'b000);
      end
   if (lrr)
      rr[10:0] <= lc[10:0] + 10'h001;

   if (ctsr)
      tsr[2:0] <= 3'b000;
   else
      if (ldtsrb)
         tsr[2:0] <= tsra[2:0];

   if (ldtr)  mtr[15:0] <= pin_mi[15:0];
   if (ldmir) mir[15:0] <= pin_mi[15:0];
   if (ldmir | sr) rni <= pin_mi[17];
end

//______________________________________________________________________________
//
assign lra   = (~m16_out & ~sr_wi &  plm_lra) | (plm[3] & ~sr_wi);
assign lta   =  ~m16_out & ~sr_wi & ~plm_lra &  plm_lta;
assign ldinc =  ~m16_out & ~sr_wi & ~plm_lra & ~plm_lta;
assign ldmir = sr | (~m16_out & ~sr_wi);

assign ldja  = ~sr_wi & (plm[1] | plm[2] & pin_cond);
assign ldjb  = ~sr_wi &  plm[1];

assign ldtr   = ~sr_wi & (plm[6] | (plm[8] & (mir[4] | mir[5])));
assign ldtsrb = ~sr_wi & ~m16_out & ldtsra;
assign ctsr   = ~sr_wi & plm[14];

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
   .pta(pta),        // programmable translation address
   .tsr(tsra),       // translation status register
   .lra(plm_lra),    // load return address
   .lta(plm_lta),    // load translation address
   .ltsr(ldtsra)     // load translation status register
);

//______________________________________________________________________________
//
// Interrupts
//
assign irq_set[5] = ~sr_wi & mir[4] & plm[13];
assign irq_clr[5] = ~sr_wi & mir[4] & plm[12];
assign irq_set[6] = ~sr_wi & mir[5] & plm[13];
assign irq_clr[6] = ~sr_wi & mir[5] & plm[12];
assign irq_set[7] = ~sr_wi & mir[6] & plm[13];
assign irq_clr[7] = ~sr_wi & mir[6] & plm[12];

always @(posedge pin_clk)
if (c1)
begin
   irq[4:1] <= pin_inrrq[4:1];
   irq[5] = irq_set[5] | (~irq_clr[5] & irq[5]);
   irq[6] = irq_set[6] | (~irq_clr[6] & irq[6]);
   irq[7] = irq_set[7] | (~irq_clr[7] & irq[7]);
end

//______________________________________________________________________________
//
// Q-bus controls
//
always @(posedge pin_clk)
begin
   if (c3) dout <= plm[5];
   if (c4) wrby <= plm[11] | (~sr_wi & (plm[9] | plm[10]));
end

assign di_clr  = ~sr_wi & ~m16_out & (plm[4] | plm[5]);
assign syn_clr = ~sr_wi & ~m16_out & (plm[5] | plm[4] & (~mir[6] | syn_q1));
assign syn_set = syn | ~sr_wi & (plm[15] | plm[16]);
assign iak_set = iak | ~sr_wi & plm[19];

always @(posedge pin_clk)
if (c1)
begin
   di_set  <= ~sr_wi & ~syn & (plm[17] | plm[18]);
   di  <= ~sr & (di | syn & di_set) & ~di_clr;
   syn <= ~sr & syn_set & ~syn_clr;
   iak <= ~sr & iak_set & ~syn_clr;
end

//
// Q1 flag of IW microinstruction, controls Read-Modify-Write Cycle
//
assign syn_q1 = ~mtr[14] & (mtr[13] | (mtr[12:6] == 7'b0101111));

endmodule
