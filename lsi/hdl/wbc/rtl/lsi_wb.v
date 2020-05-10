//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// LSI-11 synchronous model with Wishbone interfaces
//______________________________________________________________________________
//
module lsi_wb
(
   input          pin_clk,       // processor clock
   input          pin_dclo_n,    // processor reset
   input          pin_aclo_n,    // power fail notification
   input          pin_halt_n,    // supervisor exception requests
   input          pin_evnt_n,    // timer interrupt requests
   input          pin_virq_n,    // vectored interrupt request
                                 //
   input          pin_rply_n,    // transaction reply
   output         pin_init_n,    // peripheral reset (open drain)
                                 //
   inout [15:0]   pin_ad_n,      // inverted address/data bus
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
wire   [21:0] m_rom;             // microcode instructions from 1631
wire   [21:0] m_mux;             // microcode multiplexer
wire   [15:0] m_dat;             // microcode data from 1611
wire   [10:0] m_lc;              //
wire   m_nop;                    // translate NOP while in reset
wire   m_inp;                    // translate data for input
                                 //
reg [1:0] ccnt;                  // phase clock generator register
reg c1, c4;                      // generated phases
                                 //
                                 // code 010 - not used
wire  mc_clr_init;               // code 011 - deassert peripheral INIT
wire  mc_clr_berr;               // code 012 - clear refresh and bus error
wire  mc_set_init;               // code 014 - assert peripheral INIT
wire  mc_set_fdin;               // code 015 - set fast input flag
wire  mc_clr_aclo;               // code 016 - clear ACLO detector
wire  mc_clr_evnt;               // code 017 - clear event/timer interrupt
                                 //
wire  rply;                      // acknowlegement
wire  sack;                      // system acknowlegement
wire  dmr;                       // direct memory access request
                                 //
wire  sync;                      //
wire  iako;                      //
wire  dout;                      //
reg   rply_c1;                   //
reg   dout_en;                   //
                                 //
wire  evnt, virq, halt;          // external interrupts
wire  aclo, dclo;                // power status
                                 //
reg   sync_ed;                   // m_syn edge detector
reg   aclo_ed;                   // nACLO edge detector
reg   evnt_ed;                   // nEVNT edge detector
                                 //
reg   aclo_rq;                   // nACLO falling edge detected
reg   evnt_rq;                   // nEVNT falling edge detected
reg   init_st;                   // nINIT flag
reg   fdin_st;                   // fast data input flag
reg   berr_rq;                   // bus error (timeout) request
reg   berr_st;                   // bus error sticky status
reg   mc_res;                    // microcode reset
reg   [5:0] qtim;                // Q-bus transaction timer
wire  qtim_to;                   // Q-bus timer output
wire  qtim_en;                   // Q-bus time enable
wire  [3:0] fdin;                // fast data input

                                 //
wire  [4:1] m_inrrq;             // interrupt requests
tri1  [15:0] m_ad;               // address/data bus
wire  m_sr_n;                    // system reset
wire  m_wi;                      // wait line
wire  m_br;                      // condidion taken
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
wire  pin_ad_ena;                // External pin wires and controls
wire  pin_init_ena;
wire  [15:0] pin_ad_out;

//______________________________________________________________________________
//
// Shared Qbus lines
//
assign pin_ad_n   = pin_ad_ena   ? ~pin_ad_out : 16'oZZZZZZ;
assign pin_sync_n = ~sync;
assign pin_wtbt_n = ~m_wrby;
assign pin_dout_n = ~dout;
assign pin_din_n  = ~m_di;
//
// "Open drain" outputs
//
assign pin_init_n = pin_init_ena ? 1'b0 : 1'bZ;
//
// Other outputs
//
assign pin_iako_n = ~iako;

//_____________________________________________________________________________
//
assign pin_ad_ena    = ~m_di;
assign pin_init_ena  = init_st;
assign pin_ad_out    = m_ad;

assign evnt = ~pin_evnt_n;
assign halt = ~pin_halt_n;
assign virq = ~pin_virq_n;
assign aclo = ~pin_aclo_n;
assign dclo = ~pin_dclo_n;
assign rply = ~pin_rply_n;

assign m_ad = m_di ? (fdin_st ? {12'o0000, fdin} : ~pin_ad_n) : 16'oZZZZ;

assign fdin[0] = ~pin_bsel_n[0]; // fast data input
assign fdin[1] = ~pin_bsel_n[1]; // boot mode
assign fdin[2] = berr_st;        // bus error
assign fdin[3] = aclo | aclo_rq; // power failure

//______________________________________________________________________________
//
// Internal clock generator feeds the C1, C4 clock phases
//
initial ccnt = 2'b00;

always @(posedge pin_clk)
begin
   if (ccnt == 2'b01)
      ccnt <= 2'b00;
   else
      ccnt <= ccnt + 2'b01;
   c1 <= (ccnt == 2'b00);
   c4 <= (ccnt == 2'b01);
end

//_____________________________________________________________________________
//
// Microcode controlled strobes (with M18-M21 extra bits)
//
assign mc_clr_init = c4 & (m_mux[21:18] == 4'b1001);  // code 011 - deassert INIT
assign mc_clr_berr = c4 & (m_mux[21:18] == 4'b1010);  // code 012 - clear bus error
assign mc_set_init = c4 & (m_mux[21:18] == 4'b1100);  // code 014 - assert INIT
assign mc_set_fdin = c4 & (m_mux[21:18] == 4'b1101);  // code 015 - set fast input
assign mc_clr_aclo = c4 & (m_mux[21:18] == 4'b1110);  // code 016 - clear ACLO
assign mc_clr_evnt = c4 & (m_mux[21:18] == 4'b1111);  // code 017 - clear event

//_____________________________________________________________________________
//
// Reset, interrupts and exceptions
//
// AC power failure interrupt edge detector
//
always @(posedge pin_clk)
begin
   aclo_ed <= aclo;
   if (mc_clr_aclo | dclo)
      aclo_rq <= 1'b0;
   else
      if (aclo & ~aclo_ed)
         aclo_rq <= 1'b1;
end

//
// Periodic timer interrupt edge detector
//
always @(posedge pin_clk)
begin
   evnt_ed <= evnt;
   if (mc_clr_evnt | dclo)
      evnt_rq <= 1'b0;
   else
      if (evnt & ~evnt_ed)
         evnt_rq <= 1'b1;
end
//
//
// Processor interrupts
//
assign m_inrrq[1] = virq;
assign m_inrrq[2] = evnt_rq;
assign m_inrrq[3] = aclo_rq | halt;
assign m_inrrq[4] = 1'b0;

//
// Peripheral devices reset, controlled by microcode M18-M21
//
always @(posedge pin_clk)
begin
   if (dclo | mc_set_init)
      init_st <= 1'b1;
   else
      if (mc_clr_init)
         init_st <= 1'b0;
end

//
// Fast input (unaddressed) flag, controlled by microcode M18-M21
//
always @(posedge pin_clk)
begin
   sync_ed <= m_syn;
   if (~m_syn & sync_ed)
      fdin_st <= 1'b0;
   else
      if (mc_set_fdin & m_syn)
         fdin_st <= 1'b1;
end

//
// Processor data cycle abort
//
always @(posedge pin_clk)
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
assign sync = ~m_inrak & m_syn;
assign iako =  m_inrak & m_di;
assign dout =  m_do & ~rply_c1 & dout_en;

always @(posedge pin_clk)
begin
   if (init_st)
      rply_c1 <= 1'b0;
   else
      if (c1)
         rply_c1 <= rply;

   if (m_syn ^ sync_ed)
      dout_en <= 1'b1;
   else
      if (dout & rply_c1)
         dout_en <= 1'b0;
end

assign m_ra = rply_c1 & (m_do | m_di);

//_____________________________________________________________________________
//
// Q-bus timer
//
always @(posedge pin_clk)
begin
   if (~qtim_en)
      qtim <= 6'b000000;
   else
      if (c1 & ~qtim_to)
         qtim <= qtim + 6'b000001;

   if (init_st | mc_clr_berr)
         berr_st <= 1'b0;
   else
      if (qtim_to)
         berr_st <= 1'b1;
   berr_rq <= qtim_en & qtim_to;
end

assign qtim_to = qtim == 6'b111111;
assign qtim_en = m_di | m_do;
assign m_bbusy = rply_c1;

//_____________________________________________________________________________
//
assign m_mux[15:0] = m_dat[15:0]
                   | (m_inp ? 16'h0000 : m_rom[15:0])
                   | (m_nop ? 16'hFF00 : 16'h0000);
assign m_mux[21:16] = (m_nop | m_inp) ? 6'h00 : m_rom[21:16];

mcp1611 data
(
   .pin_clk(pin_clk),
   .pin_c1(c1),
   .pin_c4(c4),
   .pin_mi(m_mux[15:0]),
   .pin_mo(m_dat[15:0]),
   .pin_wi(m_wi),
   .pin_cond(m_br),
   .pin_ad(m_ad)
);

mcp1621 control
(
   .pin_clk(pin_clk),
   .pin_c1(c1),
   .pin_c4(c4),
   .pin_lc(m_lc[10:0]),
   .pin_mi(m_mux[17:0]),
   .pin_nop(m_nop),
   .pin_inp(m_inp),
   .pin_cond(m_br),
   .pin_wi(m_wi),
   .pin_inrrq(m_inrrq),
   .pin_bbusy(m_bbusy),
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
   .pin_clk(pin_clk),
   .pin_lc(m_lc[10:0]),
   .pin_lcen(c1),
   .pin_mo(m_rom[21:0])
);

//_____________________________________________________________________________
//
endmodule
