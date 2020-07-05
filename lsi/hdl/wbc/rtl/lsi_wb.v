//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// LSI-11 synchronous model with Wishbone interfaces
//______________________________________________________________________________
//
module lsi_wb
#(parameter
//______________________________________________________________________________
//
// LSI11_ORIGINAL_MICROM nonzero value means the original DEC Microm
// 1631-10/07/15 conten is used, we can optimize 4 MSBs with ordinal logic
// and save memory blocks
//
   LSI11_ORIGINAL_MICROM = 1
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
   input          vm_virq,       // vectored interrupt request
                                 //
   input          wbm_gnt_i,     // master wishbone granted
   output [15:0]  wbm_adr_o,     // master wishbone address
   output [15:0]  wbm_dat_o,     // master wishbone data output
   input  [15:0]  wbm_dat_i,     // master wishbone data input
   output         wbm_cyc_o,     // master wishbone cycle
   output         wbm_we_o,      // master wishbone direction
   output [1:0]   wbm_sel_o,     // master wishbone byte election
   output         wbm_stb_o,     // master wishbone strobe
   input          wbm_ack_i,     // master wishbone acknowledgement
                                 //
   input  [15:0]  wbi_dat_i,     // interrupt vector input
   input          wbi_ack_i,     // interrupt vector acknowledgement
   output         wbi_stb_o,     // interrupt vector strobe
                                 //
   input [1:0]    vm_bsel        // boot mode selector
);

//______________________________________________________________________________
//
reg   [15:0] wb_adr;             // master wishbone address
reg   [15:0] wb_dat;             // master wishbone data output
reg   [1:0] wb_sel;              // master wishbone byte election
reg   wb_cyc;                    // master wishbone cycle
reg   wb_we;                     // master wishbone direction
reg   wb_stb;                    // master wishbone strobe
reg   wb_iak;                    // interrupt vector strobe
reg   wb_rdy;                    // data read completed
reg   [1:0] wb_ra;               // extended reply
                                 //
wire  wb_wdone;                  //
wire  wb_rdone;                  //
wire  wb_idone;                  //
                                 //
reg   [7:0] wb_wcnt;             // slow clock counter
wire  wb_wset, wb_wclr;          //
                                 //
wire  [21:0] m_rom;              // microcode instructions from 1631
wire  [21:0] m_mux;              // microcode multiplexer
wire  [15:0] m_dat;              // microcode data from 1611
wire  [10:0] m_lc;               //
wire  m_nop;                     // translate NOP while in reset
wire  m_inp;                     // translate data for input
                                 //
wire  m_astb;                    // address strobe
wire  m_dstb;                    // data strobe
wire  [15:0] m_ado;              // data chip output
reg   [15:0] m_adi;              // data chip input
                                 //
                                 // code 010 - not used
wire  mc_clr_init;               // code 011 - deassert peripheral INIT
wire  mc_clr_berr;               // code 012 - clear refresh and bus error
wire  mc_set_init;               // code 014 - assert peripheral INIT
wire  mc_set_fdin;               // code 015 - set fast input flag
wire  mc_clr_aclo;               // code 016 - clear ACLO detector
wire  mc_clr_evnt;               // code 017 - clear event/timer interrupt
                                 //
reg   wcyc_ed;                   // cycle edge detector
reg   aclo_ed;                   // nACLO edge detector
reg   evnt_ed;                   // nEVNT edge detector
                                 //
reg   aclo_rq;                   // nACLO falling edge detected
reg   evnt_rq;                   // nEVNT falling edge detected
reg   init_st;                   // nINIT flag
reg   fdin_st;                   // fast data input flag
reg   berr_rq;                   // bus error (timeout) request
reg   berr_st;                   // bus error sticky status
reg   [5:0] qtim;                // Q-bus transaction timer
wire  qtim_to;                   // Q-bus timer output
wire  qtim_en;                   // Q-bus time enable
wire  [3:0] fdin;                // fast data input
                                 //
wire  [4:1] m_inrrq;             // interrupt requests
reg   m_sr;                      // system reset
wire  m_wi;                      // wait line
wire  m_br;                      // condidion taken
reg   m_bbusy;                   // bus busy
wire  m_ra;                      // reply
wire  m_synr;                    // sync reset
wire  m_syns;                    // sync set
wire  m_dclr;                    // read completed
wire  m_di;                      // data input
wire  m_do;                      // data output
wire  m_iak;                     // interrupt ack
wire  m_wrby;                    // write byte
wire  m_breq;                    // bus request
                                 //
//______________________________________________________________________________
//
// Master and Interrupt Wishbone assignments
//
assign wbm_adr_o[15:0] = wb_adr[15:0];
assign wbm_dat_o[15:0] = wb_dat[15:0];
assign wbm_sel_o[1:0] = wb_sel[1:0];
assign wbm_cyc_o = wb_cyc;
assign wbm_stb_o = wb_stb;
assign wbi_stb_o = wb_iak;
assign wbm_we_o = wb_we;

assign vm_init = init_st;

always @(posedge vm_clk_p)
begin
   if (m_astb) wb_adr = m_ado;
   if (m_dstb) wb_dat = m_ado;

   if (wb_rdone | wb_idone)
   begin
      if (wb_stb)
         m_adi <= fdin_st ? {wbm_dat_i[15:4], fdin} : wbm_dat_i;
      else
         m_adi <= wbi_dat_i;
   end
end

//_____________________________________________________________________________
//
// Wishbone logic
//
assign wb_wdone   = wb_stb & wbm_ack_i & wb_we;
assign wb_rdone   = wb_stb & wbm_ack_i & ~wb_we;
assign wb_idone   = wb_iak & wbi_ack_i;

always @(posedge vm_clk_p or posedge m_sr)
begin
   if (m_sr)
   begin
      wb_cyc <= 1'b0;
      wb_stb <= 1'b0;
      wb_iak <= 1'b0;
      wb_sel <= 2'b11;
      wb_we  <= 1'b0;
      wb_ra  <= 2'b00;
      wb_rdy <= 1'b0;
   end
   else
   begin
      //
      // Cycle starts on the active m_syns
      //
      if (m_syns)
         wb_cyc <= 1'b1;
      //
      // Completes on write or actual data read by data chip
      //
      if (wb_wdone | wb_rdone & m_synr | wb_rdy & m_synr)
         wb_cyc <= 1'b0;
      if (m_syns | m_synr | m_dclr)
         wb_rdy <= 1'b0;
      else
         if (wb_rdone)
            wb_rdy <= 1'b1;
      wb_we <= m_do & ~wbm_ack_i & wb_cyc;
      if (wb_cyc & m_do & m_wrby)
            wb_sel <= wb_adr[0] ? 2'b10 : 2'b01;
      else
            wb_sel <= 2'b11;
      wb_stb <= m_do & ~wb_stb & wb_cyc | m_di | wb_stb & ~(wb_rdone | wb_wdone);
      if (m_iak)
         wb_iak <= 1'b1;
      else
         if (wb_idone)
            wb_iak <= 1'b0;
      //
      // Completion strobe for control chip
      //
      wb_ra[0] <= wb_rdone | wb_rdy & ~m_dclr | wb_wdone | wb_idone;
      wb_ra[1] <= wb_ra[0] & ~(m_synr | wb_rdy & m_dclr);
   end
end

assign m_ra = wb_ra[0] | wb_ra[1];

//_____________________________________________________________________________
//
// Bus moderator - holds the Control chip with m_bbusy signal
//
always @(posedge vm_clk_p or posedge m_sr)
begin
   if (m_sr)
      m_bbusy <= 1'b0;
   else
      if (wb_wset)
         m_bbusy <= vm_clk_slow;
      else
         if (wb_wclr)
            m_bbusy <= 1'b0;
end

assign wb_wset =  vm_clk_slow & ~m_breq & (wb_wcnt != 8'h00);
assign wb_wclr = ~vm_clk_slow | (vm_clk_ena & (wb_wcnt == 8'h01));

always @(posedge vm_clk_p or posedge m_sr)
begin
   if (m_sr)
      wb_wcnt <= 8'h00;
   else
   begin
      if (~vm_clk_slow)
         wb_wcnt <= 8'h00;
      else
         if (m_bbusy & m_breq)
         begin
            if (vm_clk_ena)
               wb_wcnt <= wb_wcnt - 8'h01;
         end
         else
            if (~vm_clk_ena & vm_clk_slow & (wb_wcnt != 8'hFF))
               wb_wcnt <= wb_wcnt + 8'h01;
         end
end

//_____________________________________________________________________________
//
assign fdin[0] = vm_bsel[0];        // fast data input
assign fdin[1] = vm_bsel[1];        // boot mode
assign fdin[2] = berr_st;           // bus error
assign fdin[3] = vm_aclo | aclo_rq; // power failure

//_____________________________________________________________________________
//
// Microcode controlled strobes (with M18-M21 extra bits)
//
assign mc_clr_init = (m_mux[21:18] == 4'b1001);  // code 011 - deassert INIT
assign mc_clr_berr = (m_mux[21:18] == 4'b1010);  // code 012 - clear bus error
assign mc_set_init = (m_mux[21:18] == 4'b1100);  // code 014 - assert INIT
assign mc_set_fdin = (m_mux[21:18] == 4'b1101);  // code 015 - set fast input
assign mc_clr_aclo = (m_mux[21:18] == 4'b1110);  // code 016 - clear ACLO
assign mc_clr_evnt = (m_mux[21:18] == 4'b1111);  // code 017 - clear event

//_____________________________________________________________________________
//
// Reset, interrupts and exceptions
//
// AC power failure interrupt edge detector
//
always @(posedge vm_clk_p)
begin
   aclo_ed <= vm_aclo;
   if (mc_clr_aclo | vm_dclo)
      aclo_rq <= 1'b0;
   else
      if (vm_aclo & ~aclo_ed)
         aclo_rq <= 1'b1;
end

//
// Periodic timer interrupt edge detector
//
always @(posedge vm_clk_p)
begin
   evnt_ed <= vm_evnt;
   if (mc_clr_evnt | vm_dclo)
      evnt_rq <= 1'b0;
   else
      if (vm_evnt & ~evnt_ed)
         evnt_rq <= 1'b1;
end
//
//
// Processor interrupts
//
assign m_inrrq[1] = vm_virq;
assign m_inrrq[2] = evnt_rq;
assign m_inrrq[3] = aclo_rq | vm_halt;
assign m_inrrq[4] = 1'b0;

//
// Peripheral devices reset, controlled by microcode M18-M21
//
always @(posedge vm_clk_p)
begin
   if (vm_dclo | mc_set_init)
      init_st <= 1'b1;
   else
      if (mc_clr_init)
         init_st <= 1'b0;
end

//
// Fast input (unaddressed) flag, controlled by microcode M18-M21
//
always @(posedge vm_clk_p)
begin
   wcyc_ed <= wbm_cyc_o;
   if (~wbm_cyc_o & wcyc_ed)
      fdin_st <= 1'b0;
   else
      if (mc_set_fdin & wbm_cyc_o)
         fdin_st <= 1'b1;
end

//
// Processor data cycle abort
//
always @(posedge vm_clk_p)
begin
   if (vm_dclo)
      m_sr <= 1'b1;
   else
      m_sr <= berr_rq;
end

//_____________________________________________________________________________
//
// Q-bus timer
//
always @(posedge vm_clk_p)
begin
   if (~qtim_en)
      qtim <= 6'b000000;
   else
      if (~qtim_to)
         qtim <= qtim + 6'b000001;

   if (init_st | mc_clr_berr)
         berr_st <= 1'b0;
   else
      if (qtim_to)
         berr_st <= 1'b1;
   berr_rq <= qtim_en & qtim_to;
end

assign qtim_to = qtim == 6'b111111;
assign qtim_en = wbm_gnt_i & (wbm_stb_o | wbi_stb_o);

//_____________________________________________________________________________
//
assign m_mux[15:0] = m_dat[15:0]
                   | (m_inp ? 16'h0000 : m_rom[15:0])
                   | (m_nop ? 16'hFF00 : 16'h0000);
assign m_mux[21:16] = (m_nop | m_inp) ? 6'h00 : m_rom[21:16];

mcp1611 data
(
   .pin_clk_p(vm_clk_p),
   .pin_clk_n(vm_clk_n),
   .pin_mi(m_mux[15:0]),
   .pin_mo(m_dat[15:0]),
   .pin_wi(m_wi),
   .pin_cond(m_br),
   .pin_ado(m_ado),
   .pin_adi(m_adi),
   .pin_astb(m_astb),
   .pin_dstb(m_dstb)
);

mcp1621 control
(
   .pin_clk_p(vm_clk_p),
   .pin_clk_n(vm_clk_n),
   .pin_lc(m_lc[10:0]),
   .pin_mi(m_mux[17:0]),
   .pin_nop(m_nop),
   .pin_inp(m_inp),
   .pin_cond(m_br),
   .pin_wi(m_wi),
   .pin_inrrq(m_inrrq),
   .pin_bbusy(m_bbusy),
   .pin_sr(m_sr),
   .pin_ra(m_ra),
   .pin_synr(m_synr),
   .pin_syns(m_syns),
   .pin_dclr(m_dclr),
   .pin_di(m_di),
   .pin_do(m_do),
   .pin_inrak(m_iak),
   .pin_wrby(m_wrby),
   .pin_breq(m_breq)
);

defparam microm.LSI11_ORIGINAL_MICROM = LSI11_ORIGINAL_MICROM;
mcp1631 microm
(
   .pin_clk(vm_clk_p),
   .pin_lc(m_lc[10:0]),
   .pin_mo(m_rom[21:0])
);

//_____________________________________________________________________________
//
endmodule
