//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// LSI-11 asynchronous model, for debug and modelling only
// This file contains the wrapper for MCP-1600 chipset,
// it implements external circuits of the M2/KD-11A processor
// without onboard dynamic memory and its controller.
//______________________________________________________________________________
//
module lsi
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input          pin_virq_n,    // vectored interrupt request
   input          pin_rfrq_n,    // refresh DRAM request
                                 //
   input          pin_dmr_n,     // bus request line
   input          pin_sack_n,    // bus acknowlegement
   input          pin_rply_n,    // transaction reply
   output         pin_dmgo_n,    // bus granted output
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout [15:0]   pin_ad_n,      // inverted address/data bus
   output         pin_dref_n,    // dynamic RAM refresh
   output         pin_sync_n,    // address strobe
   output         pin_wtbt_n,    // write/byte status
   output         pin_dout_n,    // data output strobe
   output         pin_din_n,     // data input strobe
   output         pin_iako_n,    // interrupt vector input
                                 //
   input [1:0]    pin_bsel_n     // boot mode selector
);

//______________________________________________________________________________
//
trireg [21:0] m_n;               // inverted microinstruction bus
wire   [21:0] mc;                // microcode instruction bus
                                 //
                                 //
reg [1:0] ccnt;                  // phase clock generator register
reg c1, c2, c3, c4;              // generated phases
                                 //
                                 // code 010 - not used
wire  mc_clr_init;               // code 011 - deassert peripheral INIT
wire  mc_clr_berr;               // code 012 - clear refresh and bus error
wire  mc_set_rfsh;               // code 013 - set refresh flag
wire  mc_set_init;               // code 014 - assert peripheral INIT
wire  mc_set_fdin;               // code 015 - set fast input flag
wire  mc_clr_aclo;               // code 016 - clear ACLO detector
wire  mc_clr_evnt;               // code 017 - clear event/timer interrupt
                                 //
wire  rply;                      // acknowlegement
wire  sack;                      // system acknowlegement
wire  dmr;                       // direct memory access request
                                 //
reg   sync_c3;                   //
reg   dout_c3;                   //
reg   dout_c2;                   //
reg   rply_c1;                   //
reg   iako_c1;                   //
                                 //
reg   dmr_c1;                    // direct memory access request
reg   dmr_rf;                    // refresh was requested during DMA
reg   sack_c4;                   //
reg   dmgo_c4;                   // direct memory access ack
                                 //
wire  evnt, virq, halt;          // external interrupts
wire  aclo, dclo;                // power status
wire  rfrq;                      // external DRAM refresh request
                                 //
reg   aclo_rq;                   // nACLO falling edge detected
reg   evnt_rq;                   // nEVNT falling edge detected
reg   init_st;                   // nINIT flag
reg   fdin_st;                   // fast data input flag
reg   dref_st;                   // DRAM refresh flag
reg   dref_rq;                   // DRAM refresh request
wire  berr_rq;                   // bus error (timeout) request
reg   berr_st;                   // bus error sticky status
reg   mc_res;                    // microcode reset
reg   [5:0] qtim;                // Q-bus transaction timer
wire  qtim_to;                   // Q-bus timer output
wire  qtim_en;                   // Q-bus time enable
wire  [3:0] fdin;                // fast data input

                                 //
reg   [4:1] m_inrrq;             // interrupt requests
tri1  [15:0] m_ad;               // address/data bus
wire  m_sr_n;                    // system reset
wire  m_wi;                      // wait line
wire  m_bbusy;                   // bus busy
wire  m_ra;                      // reply
wire  m_syn;                     // sync
wire  m_di;                      // data input
wire  m_do;                      // data output
wire  m_inrak;                   // interrupt ack
wire  m_wrby;                    // write byte
                                 //
//______________________________________________________________________________
//
reg   pin_ad_ena;                // External pin wires and controls
wire  pin_init_ena;
wire  pin_ctrl_ena;
wire  [15:0] pin_ad_out;

wire  pin_sync_out;
wire  pin_wtbt_out;
wire  pin_dout_out;
wire  pin_din_out;

//______________________________________________________________________________
//
// Shared Qbus lines
//
assign pin_ad_n   = pin_ad_ena   ? ~pin_ad_out : 16'oZZZZZZ;
assign pin_sync_n = pin_ctrl_ena ? ~pin_sync_out : 1'bZ;
assign pin_wtbt_n = pin_ctrl_ena ? ~pin_wtbt_out : 1'bZ;
assign pin_dout_n = pin_ctrl_ena ? ~pin_dout_out : 1'bZ;
assign pin_din_n  = pin_ctrl_ena ? ~pin_din_out  : 1'bZ;
//
// "Open drain" outputs
//
assign pin_init_n = pin_init_ena ? 1'b0 : 1'bZ;
//
// Other outputs
//
assign pin_dmgo_n = ~dmgo_c4;
assign pin_dref_n = ~dref_st;
assign pin_iako_n = ~iako_c1;

//_____________________________________________________________________________
//
always @(*)
begin
// pin_ad_ena <= ~(sack | dmgo_c4) & ~m_di;
   if (sack | dmgo_c4 | m_di)
      pin_ad_ena <= 1'b0;
   else
      if (~sync_c3 | dout_c3)
         pin_ad_ena <= 1'b1;
end

// assign pin_ad_ena    = ~(sack | dmgo_c4) & ~m_di;
assign pin_init_ena  = init_st;
assign pin_ctrl_ena  = ~(sack | dmgo_c4);
assign pin_ad_out    = m_ad;

assign pin_sync_out  = sync_c3;
assign pin_wtbt_out  = m_wrby;
assign pin_dout_out  = dout_c3;
assign pin_din_out   = m_di;

assign evnt = ~pin_evnt_n;
assign halt = ~pin_halt_n;
assign virq = ~pin_virq_n;
assign aclo = ~pin_aclo_n;
assign dclo = ~pin_dclo_n;
assign rfrq = ~pin_rfrq_n;
assign sack = ~pin_sack_n;
assign rply = ~pin_rply_n;
assign dmr  = ~pin_dmr_n;

assign m_ad = m_di ? (fdin_st ? {12'o0000, fdin} : ~pin_ad_n) : 16'oZZZZ;

assign fdin[0] = ~pin_bsel_n[0]; // fast data input
assign fdin[1] = ~pin_bsel_n[1]; // boot mode
assign fdin[2] = berr_st;        // bus error
assign fdin[3] = aclo | aclo_rq; // power failure

//______________________________________________________________________________
//
// Internal clock generator feeds the C1, C2, C3, C4 clock phases
//
initial ccnt = 2'b00;

always @(posedge pin_clk)
begin
   ccnt <= ccnt + 2'b01;
   c1 <= (ccnt == 2'b00);
   c2 <= (ccnt == 2'b01);
   c3 <= (ccnt == 2'b10);
   c4 <= (ccnt == 2'b11);
end

//_____________________________________________________________________________
//
// Microcode controlled strobes (with M18-M21 extra bits)
//
assign mc = ~m_n;
assign mc_clr_init = c3 & (mc[21:18] == 4'b1001);  // code 011 - deassert INIT
assign mc_clr_berr = c3 & (mc[21:18] == 4'b1010);  // code 012 - clear bus error
assign mc_set_rfsh = c3 & (mc[21:18] == 4'b1011);  // code 013 - set refresh
assign mc_set_init = c3 & (mc[21:18] == 4'b1100);  // code 014 - assert INIT
assign mc_set_fdin = c3 & (mc[21:18] == 4'b1101);  // code 015 - set fast input
assign mc_clr_aclo = c3 & (mc[21:18] == 4'b1110);  // code 016 - clear ACLO
assign mc_clr_evnt = c3 & (mc[21:18] == 4'b1111);  // code 017 - clear event

//_____________________________________________________________________________
//
// Reset, interrupts and exceptions
//
// AC power failure interrupt edge detector
//
always @(posedge aclo or posedge mc_clr_aclo or posedge dclo)
begin
   if (mc_clr_aclo | dclo)
      aclo_rq <= 1'b0;
   else
      aclo_rq <= 1'b1;
end

//
// Periodic timer interrupt edge detector
//
always @(posedge evnt or posedge mc_clr_evnt or posedge dclo)
begin
   if (mc_clr_evnt | dclo)
      evnt_rq <= 1'b0;
   else
      evnt_rq <= 1'b1;
end

//
// Peripheral devices reset, controlled by microcode M18-M21
//
always @(negedge mc_set_init or posedge mc_clr_init or posedge dclo)
begin
   if (dclo)
      init_st= 1'b1;
   else
      if (mc_clr_init)
         init_st <= 1'b0;
      else
         init_st <= 1'b1;
end

//
// Fast input (unaddressed) flag, controlled by microcode M18-M21
//
always @(negedge m_syn or posedge mc_set_fdin)
begin
   if (~m_syn)
      fdin_st <= 1'b0;
   else
      fdin_st <= 1'b1;
end

//
// Refresh flag and request
//
always @(posedge mc_set_rfsh or negedge mc_clr_berr or posedge dclo)
begin
   if (dclo)
      dref_st <= 1'b0;
   else
      if (mc_set_rfsh)
         dref_st <= 1'b1;
      else
         dref_st <= 1'b0;
end

always @(posedge mc_set_rfsh or posedge rfrq or posedge dclo)
begin
   if (mc_set_rfsh | dclo)
      dref_rq <= 1'b0;
   else
      dref_rq <= 1'b1;
end

//
// Processor interrupts register
//
always @(posedge c2 or posedge dclo)
begin
   if (dclo)
      m_inrrq[4:1] <= 4'b0000;
   else
   begin
      m_inrrq[1] <= virq;
      m_inrrq[2] <= evnt_rq;
      m_inrrq[3] <= aclo_rq | halt;
      m_inrrq[4] <= dref_rq;
   end
end

//
// Processor data cycle abort
//
always @(posedge c2 or posedge dclo)
begin
   if (dclo)
      mc_res <= 1'b1;
   else
      mc_res <= berr_rq;
end

assign m_sr_n = ~mc_res;

//_____________________________________________________________________________
//
// Q-bus logic
//
always @(negedge c3 or posedge m_inrak)
begin
   if (m_inrak)
      sync_c3 <= 1'b0;
   else
      sync_c3 <= m_syn | (sync_c3 & rply_c1);
end

always @(negedge c1 or negedge m_di)
begin
   if (~m_di)
      iako_c1 <= 1'b0;
   else
      iako_c1 <= m_inrak;
end

always @(posedge c1 or posedge init_st)
begin
   if (init_st)
      rply_c1 <= 1'b0;
   else
      rply_c1 <= rply;
end

always @(posedge c3 or negedge m_syn)
begin
   if (~m_syn)
      dout_c3 <= 1'b0;
   else
      dout_c3 <= m_do & ~rply_c1;
end

always @(posedge c2 or posedge dclo)
begin
   if (dclo)
      dout_c2 <= 1'b0;
   else
      dout_c2 <= dout_c3;
end

assign m_ra = rply_c1 & (dout_c2 | m_di);

//_____________________________________________________________________________
//
// Q-bus timer
//
always @(posedge init_st or posedge mc_clr_berr or posedge qtim_to)
begin
   if (init_st | mc_clr_berr)
         berr_st <= 1'b0;
   else
      if (qtim_to)
         berr_st <= 1'b1;
end

always @(posedge c3 or negedge qtim_en)
begin
   if (~qtim_en)
      qtim <= 6'b000000;
   else
      if (~qtim_to)
         qtim <= qtim + 6'b000001;
end

assign qtim_to = qtim == 6'b111111;
assign qtim_en = m_di | dout_c2;
assign berr_rq = berr_st & qtim_en & qtim_to;

//_____________________________________________________________________________
//
// Direct memory access request (Q-bus arbitration)
//
always @(posedge c1 or posedge sack or posedge init_st)
begin
   if (init_st)
         dmr_c1 <= 1'b0;
   else
      if (sack)
         dmr_c1 <= 1'b1;
      else
         dmr_c1 <= dmr & ~dmr_rf;
end

//
// This flag is set if refresh request was raised
// while bus was aquired by external agent
//
always @(negedge sack or posedge m_syn)
begin
   if (m_syn)
      dmr_rf <= 1'b0;
   else
      dmr_rf <= dref_rq & dref_st;
end

always @(posedge c4 or negedge dmr_c1)
begin
   if (~dmr_c1)
         sack_c4 <= 1'b0;
   else
         sack_c4 <= sack;
end

always @(posedge c4 or posedge m_syn)
begin
   if (m_syn)
         dmgo_c4 <= 1'b0;
   else
         dmgo_c4 <= sack_c4;
end

assign m_bbusy = dmr_c1 | rply_c1;

//_____________________________________________________________________________
//
mcp1611 data
(
   .pin_c1(c1),
   .pin_c2(c2),
   .pin_c3(c3),
   .pin_c4(c4),
   .pin_m_n(m_n[15:0]),
   .pin_wi(m_wi),
   .pin_ad(m_ad)
);

mcp1621 control
(
   .pin_c1(c1),
   .pin_c2(c2),
   .pin_c3(c3),
   .pin_c4(c4),
   .pin_m_n(m_n[17:0]),
   .pin_wi(m_wi),
   .pin_inrrq(m_inrrq),
   .pin_bbusy(m_bbusy),
   .pin_comp(1'b1),
   .pin_sr_n(m_sr_n),
   .pin_ra(m_ra),
   .pin_syn(m_syn),
   .pin_di(m_di),
   .pin_do(m_do),
   .pin_inrak(m_inrak),
   .pin_wrby(m_wrby)
);

mcp1631 microm
(
   .pin_c1(c1),
   .pin_c2(c2),
   .pin_c3(c3),
   .pin_c4(c4),
   .pin_m_n(m_n)
);

//_____________________________________________________________________________
//
endmodule
