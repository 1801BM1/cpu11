//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Version of 1801BM2 processor with Q-bus external interface
// All external signal transitions should be synchronzed with pin_clk
// The core does not contain any extra metastability eliminators itself
//
module vm2_qbus
#(parameter
//______________________________________________________________________________
//
// If VM2_CORE_FIX_PREFETCH is nonzero the PC2 prefetch bugfix is applied.
//
// Original 1801BM2 processor contains microcode bug at the following conditions:
// - two operands PDP-11 instruction is being executed
// - source has addressing method @PC (field value 17 octal)
// - destination does not involve PC (dst register field !=7)
// - no extra instruction words are used by destination (no (Rn), @E(Rn))
// - Q-bus is slow and opcode  prefetch is not completed before microcode
// starts source field  processing and fetching the source data (slow RPLY/AR)
//
// At the source operand processing the source address is taken from PC and
// written back to the PC and Q-bus address register unchanged. This writing back
// also rewrites the PC2 register containing the modified prefetch address (PC+2/4).
// Then at the command completion microcode does not restart the prefetch with
// io_cmd code and prefetch continues with wrong address in PC2. The next
// instruction behaviour may become undefined.
//
// Fix just blocks the PC2 write in the affected instructions and prefetch
// address is no corrupted. If zero parameter is specified the model follows
// the original 1801BM2 behaviour (with prefetch bug).
//
   VM2_CORE_FIX_PREFETCH = 0
)
(
   input          pin_clk_p,     // positive edge clock
   input          pin_clk_n,     // negative edge clock
                                 //
   output         pin_init,      // peripheral reset output
   input          pin_dclo,      // processor reset
   input          pin_aclo,      // power fail notificaton
   input          pin_halt,      // halt mode interrupt
   input          pin_evnt,      // timer interrupt requests
   input          pin_virq,      // vectored interrupt request
                                 //
   input          pin_ar,        // address ready
   input          pin_dmr,       // bus grant request
   input          pin_sack,      // bus grant acknowlegement
   input          pin_rply,      // transaction acknowlegement
                                 //
   output         pin_clko,      // internal clock output
   output         pin_dmgo,      // bus grant
   output         pin_sel,       // halt mode access
   output         pin_iako,      // interrupt vector input
                                 //
   input  [15:0]  pin_ad_in,     // data bus input
   output [15:0]  pin_ad_out,    // address/data bus output
   output         pin_ad_ena,    // address/data bus enable
   output         pin_ctrl_ena,  //
                                 //
   output         pin_sync,      // address strobe
   output         pin_wtbt,      // write/byte status
   output         pin_dout,      // data output strobe
   output         pin_din        // data input strobe
);

//______________________________________________________________________________
//
wire           f1;                     // phase clock generator
reg            virq, halt, evnt;       // interrupt requests
reg            dclo, aclo;             // cold reset, power monitor
reg            aclo_stb, aclo_res;     //
                                       //
reg            ac0;                    // initial ACLO rising edge detected
reg            dble_cnt0;              // double QBUS timeout error counter
reg            dble_cnt1;              //
reg            evnt_fall;              // EVNT  rising edge detector
reg            aclo_fall;              // ACLO falling edge detector
reg            aclo_rise;              // ACLO rising edge detector
                                       //
wire           evnt_ack;               // clear system timer request
wire           aclo_ack;               // clear system ACLO requests
wire           tovf_ack;               // clear Q-bus timeout request
                                       //
reg            acok_rq;                // nACLO rise interrupt request
reg            aclo_rq;                // nACLO fall interrupt request
reg            tout_rq;                // bus timeout exception request
reg            dble_rq;                // double bus timeout request
reg            evnt_rq;                // system timer interrupt request
reg            vec_stb;                // vector interrupt acknowlegement
                                       //
wire  [15:0]   ad;                     // internal address/data bus
reg            ad_oe;                  // external AD pins output enable
reg            ct_oe;                  //
                                       //
wire           bus_free;               //
wire           bus_adr;                // address on ad bus strobe
reg            bus_dat;                // data on ad bus strobe
reg            bfree;                  //
                                       //
wire           sel, sel1, sel_alt;     //
reg            sel2;                   //
                                       //
wire           init;                   //
reg            init_out;               //
reg            dmgo_out;               //
wire           dmgo;                   //
reg            dmr;                    //
wire           ar;                     //
wire           sack;                   //
wire           iako;                   //
reg            iako_out;               //
wire           wtbt_out;               //
wire           rplys;                  //
reg            rply;                   //
reg            rply0, rply1;           //
reg            rply2, rply3;           //
reg            din;                    //
reg            dout, dout_s0;          //
reg            sync, sync_s0;          //
reg            ardy, ardy_s0;          //
reg            adr_req;                //
reg            drdy;                   //
reg            sk, skp;                //
wire           sync_clw;               //
wire           sync_set;               //
wire           ua_rply;                //
wire           rdat;                   //
                                       //
wire           io_start;               // start IO transaction
wire           io_rdy;                 //
wire           in_ua;                  //
wire           io_in;                  //
wire           io_wr;                  //
wire           io_rd;                  //
wire           io_sel;                 //
wire           io_iak;                 //
wire           io_alt;                 //
wire           io_x001;                //
wire           io_rcd;                 //
reg            io_rcd1;                //
wire           io_cmd;                 //
reg            io_cmdr;                //
reg            io_rcdr;                //
reg            io_pswr;                //
reg            io_qto;                 // Q-bus timeout timer mode
                                       //
reg            iop_wr;                 //
reg            iop_rd;                 //
reg            iop_in;                 //
reg            iop_rcd;                //
reg            iop_sel;                // halt mode access
reg            iop_iak;                //
reg            iop_una;                // unaddressed access
reg            iop_word;               //
wire           iop_stb;                // IO opcode strobe
                                       //
wire           reset;                  // system reset
wire           abort;                  // abort by bus timeout
wire           mc_res;                 // microcode reset
wire           mc_stb;                 // mc read phase strobe
wire           mw_stb, mw_stb_xt;      // mc write phase strobe
wire           pi_stb, pi_stb_rc;      // peripheral strobe
reg            pi_stb_xt;              //
wire           all_rdy;                //
reg            all_rdy_t0;             //
reg            all_rdy_t1;             //
reg            alu_nrdy;               // ALU not ready
reg            sta_nrdy;               // state not ready
reg            cmd_nrdy;               // instruction completion
wire           pli_nrdy;               // interrupt polling not ready
reg            tim_nrdy0;              //
reg            tim_nrdy1;              //
wire           mc_rdy;                 //
wire           sa1;                    //
reg            in_cmd0, in_cmd1;       //
reg            ir_stb;                 //
wire           bir_stb;                //
wire           bra_req;                //
wire           tevent;                 //
wire           mdfy;                   //
wire           tena;                   //
wire           tovf;                   //
wire           thang;                  //
                                       //
reg            rta_fall;               //
wire           rta, creq;              //
wire           set_cend;               //
reg            clr_cend;               //
wire           wt_state;               //
reg            get_state;              //
reg            acmp_te, acmp_en;       //
                                       //
wire           din_set, dout_set;      //
reg            din_clr, dout_clr;      //
wire           sync_clr;               //
wire           rcmd_set;               //
                                       //
reg   [15:0]   ireg;                   // primary instruction register
reg   [15:0]   breg;                   // prefetch instruction register
reg   [5:0]    ia;                     // microinstuction address register
reg   [2:0]    ri;                     // interrupt acknowlegement register
reg   [2:0]    ix;                     // auxiliary conditions register
                                       //
reg   [11:0]   br;                     // branch processing matrix input register
wire  [15:0]   qri;                    // interrupt processing matrix input aliases
wire  [9:0]    pli;                    // interrupt priority encode matrix output
wire  [11:0]   pld;                    // preliminary instruction decoder matrix output
wire           plb;                    // branch processing matrix output
                                       //
reg            na0r;                   //
wire  [5:0]    na_rc;                  //
reg   [5:0]    na;                     // microcode next address field
reg   [30:0]   plm;                    // main matrix result register (first stage)
reg   [30:8]   plm_wt;                 //
wire  [30:8]   plr;                    //
wire  [36:0]   pla;                    //
                                       //
reg   [4:0]    plm_rn;                 //
wire  [6:0]    rn_wa;                  //
wire           pc2_wa;                 //
wire  [7:0]    wa;                     //
wire           wa_gpr;                 //
wire           wa_reg;                 //
wire           wa_r1, wa_r2;           //
wire           ra_wa;                  // write address register from X*-bus
wire           ra_wx;                  // write address register from X-bus
reg            ra_fw;                  //
wire           ra_fwn;                 //
wire           ra_fr, ra_fr1;          //
wire           pc1_wr, pc_wax;         //
wire           pc_wr;                  //
wire           rs_wa, acc_wa;          //
wire           cpsw_wa;                //
wire           cpsw_stb;               //
wire           ea1_wa, ea2_wa;         //
wire           ea_ctld;                //
wire           pswt_wa;                //
wire           psw_wa, psw8_wa;        //
wire           psw_stb, pswc_stb;      //
wire           wr_psw;                 //
wire           brd_rql, brd_rqh;       //
wire           qd_swap;                //
wire           qswp, rd2h;             //
reg            qa0;                    //
reg            wr7;                    //
                                       //
reg   [15:0]   cmux;                   // constant generator multiplexer
wire  [3:0]    csel;                   // constant generator selector
reg   [15:0]   vmux;                   // vector generator multiplexer
reg   [3:0]    vsel;                   // vector generator selector
                                       //
reg   [15:0]   ea22;                   // extended arithmetics register 2.2
reg   [15:0]   ear1;                   // extended arithmetics register 1
reg   [15:0]   ear2;                   // extended arithmetics register 2
reg   [15:0]   acc;                    // accumulator
reg   [15:0]   sreg;                   // source register
reg   [15:0]   r[6:0];                 // general purpose register files
reg   [15:0]   pc2;                    // prefetch PC pointer
reg   [15:0]   pc1;                    //
reg   [15:0]   pc;                     //
wire  [8:0]    psw_rc;                 //
reg   [8:0]    psw;                    // PSW
reg   [8:0]    cpsw;                   // PSW copy
reg   [15:0]   qreg;                   // ALU Q register (Q-bus data)
reg   [15:0]   areg;                   // ALU A register (Q-bus address)
                                       //
wire  [15:0]   alu_inx;                // ALU X operand selector
wire  [15:0]   alu_iny;                // ALU Y operand selector
wire  [15:0]   alu_an;                 // ALU operands 'and'
wire  [15:0]   alu_or;                 // ALU operands 'or'
wire  [15:0]   alu_cf;                 // ALU carry
wire  [15:0]   alu_cp;                 //
wire  [15:0]   alu_af;                 // ALU function
wire  [15:0]   alu_sh;                 //
reg   [15:0]   alu_fr;                 // ALU function register
reg   [15:0]   alu_cr;                 // ALU carry register
reg   [15:0]   xb;                     // ALU result register
wire  [15:0]   xbo;                    // byte xchanger output
wire  [15:0]   ax;                     // ALU X* output bus
reg   [15:0]   x;                      // ALU X input multiplexer
reg   [15:0]   y;                      // ALU Y input multiplexer
                                       //
wire           alu_cin;                //
wire           alu_a, alu_b;           // ALU function controls
wire           alu_c, alu_d;           //
wire           alu_e, alu_f;           //
wire           alu_g;                  //
wire           rshift, lshift, nshift; // ALU shifter controls
wire           sh_ci1, sh_ci2, sh_ci3; //
wire           alu_xb;                 //
                                       //
wire           sf_sum;                 //
reg            sf_inv, sf_dir;         //
reg            sf_lr, sf_rr;           //
reg            sf_sub;                 //
reg            sf_byte;                //
reg            sf_xchg;                //
reg            sxt_y;                  //
wire           sxt_rxy;                //
wire           axy_wh;                 //
wire           adr_eq;                 //
                                       //
wire           zl, zh, eq1;            //
wire           ea_22z;                 //
reg            ea_20r;                 //
                                       //
wire           cond_c0;                //
wire           cond_c1;                //
wire           cond_c2;                //
                                       //
wire           cond_c;                 //
wire           cond_v;                 //
wire           cond_z;                 //
wire           cond_n;                 //
                                       //
wire           plm1m;                  //
wire           plm13m;                 //
wire           plm14m;                 //
wire           plm18m;                 //
wire           plm19m;                 //
wire           plm20m;                 //
                                       //
wire           en_alu;                 //
wire           mc_drdy;                //
reg            mc_drdy0, mc_drdy1;     //
reg   [2:0]    alu_st;                 // ALU state machine
reg   [5:0]    iocmd_st;               //
reg   [1:0]    iopc_st;                //
reg   [5:0]    io_st;                  //
reg            buf_res;                //
reg            pc2_res;                // ignore pc2 write
wire           wr1;                    // ALU read args phase strobe
wire           wr2, wr2_xt;            // ALU write result phase strobe
wire           rd_end;                 //
wire           ad_rd;                  // external AD pins read enable
wire           alu_wr;                 // ALU write result
wire           brd_wq;                 // buffer data register write from Q-bus
wire           brd_wa;                 // buffer data register write from ALU
wire           to_clr;                 // not assert internal to_rply
                                       //
reg            pli_arq;                // interrupt query after IO abort
reg            pli_ack;                // interrupt module ack
wire           pli_req;                // interrupt module query
wire           sd_word;                //
reg            word27;                 //
reg            pli6r;                  //
reg            pli8r;                  //
reg            wcpu;                   //
reg            tbit;                   //
                                       //
reg            dc_b7;                  //
wire           dc_f2;                  //
wire           dc_i7;                  //
wire           dc_j7;                  //
wire           dc_bi;                  //
wire           dc_fl;                  //
wire           dc_aux;                 //
reg            dc_fb;                  //
reg            dc_rtt;                 //
reg            dc_aux0;                //
reg            dc_mop0;                //
reg            dc_mop1;                //
wire           alt_cnst;               //
                                       //
wire           ea_nrdy;                //
wire           ea_shr;                 //
wire           ea_vdiv;                //
wire           ea_mxin;                //
reg            ea_mxinr;               //
wire           ea_muls;                //
wire           sh_cin;                 //
wire  [15:0]   ea_mux;                 //
wire           ea_sh2;                 //
wire           ea_shl;                 //
wire           ea_shr2;                //
wire           ea_div;                 //
wire           ea_mul;                 //
wire           ea_mop0, ea_mop1;       //
wire           ea_rdy;                 //
reg            ea_trdy0, ea_trdy1;     //
wire           ea_trdy0_set;           //
wire           ea_trdy0_clr;           //
wire           ea_trdy1_clr;           //
                                       //
reg            tlz;                    //
reg            wait_div;               //
reg            zero_div;               //
reg            div_vfr;                // sticky division overflow flag
wire           div_vf;                 // result division overflow flag
                                       //
reg   [4:0]    ea_ct;                  // internal EA phase counter
reg            ea_1t, ea_1tm;          // first cycle after counter load
wire  [20:0]   ea_f;                   // counter phases
reg            ea_f0r, ea_f4r;         //
reg            ea_fn23r;               //
wire           ea_fn12;                //
wire           ea_f218;                //
wire           ea_ctse;                //
                                       //
wire           eas_dir;                //
wire           eas_left;               //
wire           eas_right;              //
                                       //
reg            bra;                    //
reg            sb0, sb1;               //
wire           clr_wsta;               //
wire           ws_cend, ws_wait;       //
                                       //
reg   [8:0]    qtim;                   // Q-bus/nINIT timer counter
reg            tend;                   // Q-bus/nINIT timer counting end pulse
wire           tout;                   // Q-bus/nINIt timer 1/64 pulses
                                       //
wire           io_clr;                 //
wire           wra;                    //
wire           wtbt, to_rply;          //
                                       //
//______________________________________________________________________________
//
// Extrenal pin assignments
//
assign pin_ad_out    = ad;
assign pin_ad_ena    = ad_oe;
assign pin_init      = init;
assign pin_dmgo      = dmgo_out;
assign pin_sel       = sel;
assign pin_iako      = iako;

assign pin_ctrl_ena  = ct_oe;
assign pin_sync      = sync;
assign pin_wtbt      = wtbt_out;
assign pin_dout      = dout;
assign pin_din       = din;

//______________________________________________________________________________
//
// Reset and phase clock generator
//
assign f1 = pin_clk_p;
assign pin_clko = ~f1;

always @(posedge pin_clk_p)
begin
   dclo <= pin_dclo;
   aclo <= pin_aclo;
end

always @(posedge pin_clk_p) aclo_stb <= aclo;
always @(posedge pin_clk_n) aclo_res <= aclo;

assign init = init_out | dclo;
always @(posedge pin_clk_p)
begin
   if (reset | tout)
      init_out <= 1'b0;
   else
      if (pi_stb_xt & plm[13])
         init_out <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   //
   // ac0 flag is introduced to wait nACLO raise
   // reset will not be deasserted till the nACLO rise
   //
   if (reset)
      ac0 <= 1'b0;
   else
      if (pli_ack)
         ac0 <= pli[3];
end

assign reset = dclo | (~ac0 & aclo_res);
assign mc_res = abort | reset;
//______________________________________________________________________________
//
// Interrupt inputs latches
//
always @(posedge pin_clk_p)
begin
   //
   // This is strange behaviour:
   // INIT does not reset EVNT if latch is active
   //
   evnt <= pin_evnt & init;
   halt <= pin_halt;
   virq <= pin_virq;
end

//______________________________________________________________________________
//
always @(negedge f1) dmr <= pin_dmr;
always @(*) if (f1) dmgo_out <= dmgo;

assign sel_alt = psw[8] ^ io_alt;
assign sel  = (sel2 & bus_adr) | sel1;
assign sel1 = iop_sel & din;
always @(*)
begin
   if (wra)
      sel2 <= sel_alt;
   else
      if (mc_res)
         sel2 <= 1'b1;
end

//______________________________________________________________________________
//
// Internal multiplexed address/data bus
//
assign ad   = (ad_rd ?  pin_ad_in : 16'o000000)
            | (bus_adr ? areg : 16'o000000)
            | (brd_rql ? {8'o000, qreg[7:0]} : 16'o000000)
            | (brd_rqh ? {qreg[15:8], 8'o000} : 16'o000000);

always @(*)
begin
   if (din | sack)
      ad_oe <= 1'b0;
   else
      if (~din & ~sack & ~f1)
         ad_oe <= 1'b1;
end

always @(*)
begin
   if (sack)
      ct_oe <= 1'b0;
   else
      if (~f1 & ~sack & bfree)
         ct_oe <= 1'b1;
end

//______________________________________________________________________________
//
// QBus state machine
//
assign ar   = pin_ar;
assign sack = pin_sack;

assign iako = iop_iak & din & iako_out;
always @(posedge pin_clk_n) iako_out <= iop_iak & din;
always @(posedge pin_clk_p) vec_stb <= iako_out;

assign wtbt_out =  (bus_adr & wtbt) | (bus_dat & ~iop_word);

always @(*)
begin
   if (mc_res | din_clr | ~ct_oe)
      din <= 1'b0;
   else
      if (din_set)
         din <= 1'b1;
end

always @(*)
begin
   if (mc_res)
      dout_s0 <= 1'b0;
   else
      if (~f1 & dout_clr)
         dout_s0 <= 1'b0;
      else
         if (~f1 & dout_set)
            dout_s0 <= 1'b1;

   if (~dout_s0)
      dout <= 1'b0;
   else
      if (f1 & ~mc_res)
         dout <= 1'b1;
end

assign rta        = sync & ~ardy;
assign creq       = sync_s0 | adr_req;
assign dmgo       = dmr & ~ct_oe & ~sync_s0 & ~in_ua;
assign bus_free   = bfree & ~dmr & ct_oe;
assign bus_adr    = (~sync | ~ardy_s0) & (sync_s0 | sync_set);

assign brd_rqh    = bus_dat & (iop_word |  qa0);
assign brd_rql    = bus_dat & (iop_word | ~qa0);
assign qd_swap    = qa0;

always @(*)
begin
   if (rta | mc_res)
      rta_fall <= 1'b0;
   else
      if (wra)
         rta_fall <= 1'b1;
end

always @(*)
begin
   if (sync_clr)
      qa0 <= 1'b0;
   else
      if (bus_adr)
         qa0 <= ad[0] & ~iop_word;
end

always @(*)
begin
   if (mc_res)
      bus_dat <= 1'b0;
   else
      if (f1 & dout_clr)
         bus_dat <= 1'b0;
      else
         if (f1 & (~rply & ardy & drdy & (wtbt | dout_clr)))
            bus_dat <= 1'b1;
end

assign sync_set   = bus_free & adr_req;
assign sync_clw   = (wtbt | dout_clr) & sync_clr;
assign sync_clr   = mc_res | (~iop_wr & ~rply3 & rply2);

always @(*)
begin
   if (~ct_oe | sync_clr)
      sync_s0 <= 1'b0;
   else
      if (f1 & sync_set)
         sync_s0 <= 1'b1;

   if (~f1)
      sync <= sync_s0;
end

always @(*)
begin
   if (f1 & ~sync)
      ardy_s0 <= 1'b0;
   else
      if (f1 & sync & ar)
         ardy_s0 <= 1'b1;

   if (~f1)
      ardy <= ardy_s0;
end

always @(*)
begin
   if (mc_res | io_clr | (sync & ~ardy_s0))
      adr_req <= 1'b0;
   else
      if (wra)
         adr_req <= 1'b1;
end

assign to_rply = ~to_clr & ~word27 & ~tevent & io_qto;
assign ua_rply = (din | dout) & sel1;
always @(*)
begin
   if (~f1)
      rply <= pin_rply | to_rply | ua_rply;

   if (~f1)
      bfree <= ~sync & ~ar & (ardy | ~rply);

end

assign rdat       = iop_rd & rply0 & ~rply2;
assign rplys      = ~in_ua & (~sync_s0 | ~ardy_s0);
assign in_ua      = (iop_sel | iop_iak) & (din | (~adr_req & bus_free));

assign io_iak     = (plr[24:21] == 4'b1111);    // Interrupt acknowlegement
assign io_sel     = (plr[24:21] == 4'b1011)     // Unaddressed read
                  | (plr[24:21] == 4'b1101);    //
assign io_rcd     = (plr[24:21] == 4'b0111);    // Read command ahead
assign io_cmd     = (plr[24:21] == 4'b0010)     // Read command
                  | (plr[24:21] == 4'b0110);    //
assign io_alt     = (plr[24:21] == 4'b0011)     // Read alternating space
                  | (plr[24:21] == 4'b0101);    // Write alternating space
assign io_x001    = (plr[24:21] == 4'b0001)     // Operation is defined
                  | (plr[24:21] == 4'b1001);    // by dc_mop field

assign io_wr      = (io_x001 & ~dc_mop1) | (~io_rcd & ~io_iak & plr[23]);
assign io_rd      = (io_x001 & ~dc_mop0) | plr[22];
assign io_in      = io_rcd | (io_rd & ~io_cmd);

assign dout_set   = ~dout_clr & bus_dat;
assign din_set    = ~din_clr &  iop_rd & ~rplys & ~rply3;
assign wtbt       = ~din_clr & ~iop_rd & iop_wr;

always @(*) if (wr2) io_rcd1 <= ra_fr1 & na[1];
always @(*)
begin
   if (dout_clr)
      iop_wr <= 1'b0;
   else
      if (iop_stb)
         iop_wr <= io_wr;

   if (din_clr)
      iop_rd <= 1'b0;
   else
      if (iop_stb)
         iop_rd <= io_rd;

   if (iop_stb)
      iop_word <= ~dc_fb | ~plr[30];

   if (mw_stb)
      iop_una = io_iak | io_sel;

   if (sync_clr)
   begin
      iop_iak <= 1'b0;
      iop_sel <= 1'b0;
   end
   else
      if (iop_stb)
      begin
         iop_iak <= io_iak;
         iop_sel <= io_sel;
      end

end

always @(*)
begin
   if (rply3 | ~rply1)
      dout_clr <= 1'b0;
   else
      if (wtbt)
         dout_clr <= 1'b1;

   if (rply3 | ~rply2 | rdat)
      din_clr <= 1'b0;
   else
      if (iop_rd)
         din_clr <= 1'b1;
end

always @(*)
begin
   if (rply3)
      rply0 <= 1'b0;
   else
      if (f1)
         rply0 <= rply & ~rplys;

   if (~f1) rply1 <= rply0;
   if (~f1) rply3 <= rply2;

   if (f1)
      if (rply1)
         rply2 <= 1'b1;
      else
         if (~rply & ~rply1)
            rply2 <= 1'b0;
end

always @(*)
begin
   if (sync_clr)
      drdy <= 1'b0;
   else
      if (brd_wa)
         drdy <= 1'b1;

end

//______________________________________________________________________________
//
// Q-bus timer, also involved in INIT command pulse timing
//
assign tout = qtim[0] & qtim[2] & qtim[4] & qtim[5];

always @(posedge pin_clk_n)
begin
   if (!tena)
      qtim <= 9'o000;
   else
      qtim <= qtim + 9'o001;
   //
   // Single shot pulse at the timer counting ends
   //
   if (!tena | tend)
      tend <= 1'b0;
   else
      tend <= (qtim == 9'o776);
end

//______________________________________________________________________________
//
assign adr_eq  = ~acmp_en | (pc == areg);
assign mdfy = acmp_en & ~acmp_te & adr_eq;
always @(*)
begin
   if (alu_wr) io_rcdr <= io_rcd;
   if (alu_wr) io_cmdr <= io_cmd;

   if (reset)
      acmp_te <= 1'b0;
   else
      if (~f1 & acmp_en)
         acmp_te <= 1'b0;
      else
         if (~f1 & wra & io_wr)
            acmp_te <= 1'b1;
      if (f1) acmp_en <= acmp_te;

   if (reset | sync_clw)
      io_pswr <= 1'b0;
   else
      if (wra & io_wr & ~na0r)
         io_pswr <= 1'b1;
end

//______________________________________________________________________________
//
// Instruction registers - primary and preliminary decoder
//
always @(posedge pin_clk_p)
begin
   if (bir_stb) breg <= ad;
   if (ir_stb)
   begin
      ireg <= breg;
      dc_mop0 <= ~pld[4];
      dc_mop1 <= ~pld[3];
      dc_rtt  <= ~pld[2];
   end
end

vm2_pld pld_matrix(.rq(breg), .sp(pld));

assign dc_f2 = (breg[11:9] != 3'b000)
             & ((breg[8:6] == 3'b111) | (breg[11:10] == 2'b11));

assign dc_j7 = ir_stb
             & (breg[8:6] == 3'b111)
             & (breg[14:12] != 3'b000);

assign dc_i7  = (breg[2:0] == 3'b111);
assign dc_bi  = pld[5];
assign dc_fl  = ~dc_fb & ((ir_stb & dc_bi) | (~dc_mop0 & dc_mop1));
assign dc_aux = dc_j7 | bra | dc_aux0;
assign alt_cnst = (~dc_fb & plm[30]) | (dc_fb & plm[30] & plm[5] & plm[6]);

always @(*)
begin
   if (ir_stb) dc_fb <= ~pld[10];
   if (wr2) dc_b7 <= (ax[15:13] == 3'b111);
end

always @(*)
begin
   if (io_cmdr)
      dc_aux0 <= 1'b0;
   else
      if (rcmd_set)
         dc_aux0 <= 1'b1;
end

//______________________________________________________________________________
//
// Main microcode state machine
//
assign sa1        = all_rdy_t0;
assign mc_stb     = all_rdy_t0 & all_rdy_t1;
assign pi_stb     = ~plm[0] & ~all_rdy_t0 & all_rdy_t1;
assign pi_stb_rc  = ~pla[0] & mc_stb;
always @(posedge pin_clk_p) pi_stb_xt <= pi_stb_rc;
assign all_rdy = ~mc_res & ~alu_nrdy & ~sta_nrdy & ~pli_nrdy & ~cmd_nrdy & ~all_rdy_t1;

always @(posedge pin_clk_p) all_rdy_t0 <= all_rdy;
always @(negedge pin_clk_p) all_rdy_t1 <= all_rdy_t0;

always @(*)
begin
   if (mc_res | clr_wsta)
      sta_nrdy <= 1'b0;
   else
      if (wt_state)
         sta_nrdy <= 1'b1;
end

always @(*)
begin
   if (mc_res | pi_stb | alu_wr)
      alu_nrdy <= 1'b0;
   else
      if (mc_stb)
         alu_nrdy <= 1'b1;
end
assign mc_rdy = alu_nrdy & plm[0];

always @(*) if (~f1) clr_cend <= ir_stb;
always @(*)
begin
   if (mc_res | clr_cend)
      cmd_nrdy <= 1'b0;
   else
      if (set_cend)
         cmd_nrdy <= 1'b1;
end

//______________________________________________________________________________
//
always @(*)
begin
   if (io_cmd & wra)
      in_cmd0 <= 1'b0;
   else
      if (sk)
         in_cmd0 <= 1'b1;
end

always @(*)
begin
   if (   reset
        | ~in_cmd0
        | buf_res
        | word27
        | (~f1 & clr_cend))
      in_cmd1 <= 1'b0;
   else
      if (~f1 & in_cmd0 & bir_stb)
         in_cmd1 <= 1'b1;
end

assign bra_req = cmd_nrdy & in_cmd1;
always @(posedge pin_clk_p)
begin
   if (reset)
      ir_stb <= 1'b0;
   else
      begin
         if (sa1 & ir_stb)
            ir_stb <= 1'b0;
         else
            if (bra_req)
               ir_stb <= 1'b1;
      end
end

//______________________________________________________________________________
//
// Instructions with two operands and sources address mode is @PC
// For this instruction we suppress the pc2 write in source read phase
//
always @(*)
begin
   if (mc_res)
      pc2_res <= 1'b0;
   else
      if (ir_stb)
         pc2_res =  (breg[14:12] != 3'o0)    // two ops instructions
                  & (breg[14:12] != 3'o7)    //
                  & (breg[11:6] == 6'o17)    // source is @PC
                  & (breg[5:3] != 3'o6)      // not E(Rn) destination
                  & (breg[5:3] != 3'o7)      // not @E(Rn) destination
                  & (breg[2:0] != 3'o7)      // not PC related destination
                  & (VM2_CORE_FIX_PREFETCH != 0);
end

//______________________________________________________________________________
//
// Main microcode matrix
//
vm2_plm plm_matrix(.ir(ireg), .ix(ix), .ri(ri), .ia(ia), .sp(pla));

assign na_rc[0] = reset  | ~pla[31] & ~abort;
assign na_rc[1] = mc_res | ~pla[32];
assign na_rc[2] = mc_res | ~pla[33];
assign na_rc[3] = mc_res |  pla[34];
assign na_rc[4] = mc_res |  pla[35];
assign na_rc[5] = mc_res |  pla[36];

always @(posedge pin_clk_p)
begin
   if (reset)
      na[0] <= 1'b1;
   else
      if (abort)
         na[0] <= 1'b0;
      else
         if (sa1)
            na[0] <= ~pla[31];

   if (mc_res)
      na[5:1] <= 5'b11111;
   else
      if (sa1)
      begin
         na[1] <= ~pla[32];
         na[2] <= ~pla[33];
         na[3] <=  pla[34];
         na[4] <=  pla[35];
         na[5] <=  pla[36];
      end
end

always @(posedge pin_clk_n)
if (mw_stb)
   begin
      na0r <= na[0];
      get_state <= ~na[0] & plm[25] & ~plm[26];

      plm_wt[8]  <= plm[8];
      plm_wt[21] <= plm[21];
      plm_wt[22] <= plm[22];
      plm_wt[23] <= plm[23];
      plm_wt[24] <= plm[24];
      plm_wt[25] <= plm[25];
      plm_wt[26] <= plm[26];
      plm_wt[30] <= plm[30];
   end

always @(posedge pin_clk_p)
begin
   if (sa1)
   begin
      plm[0]   <=  pla[0];
      plm[1]   <= ~pla[1];
      plm[2]   <= ~pla[2];
      plm[3]   <= ~pla[3];
      plm[4]   <= ~pla[4];
      plm[5]   <= ~pla[5];
      plm[6]   <= ~pla[6];
      plm[7]   <= ~pla[7];
      plm[8]   <= ~pla[8];
      plm[9]   <= ~pla[9];
      plm[10]  <= ~pla[10];
      plm[11]  <= ~pla[11];
      plm[12]  <= ~pla[12];
      plm[13]  <= ~pla[13];
      plm[14]  <= ~pla[14];
      plm[15]  <= ~pla[15];
      plm[16]  <= ~pla[16];
      plm[17]  <= ~pla[17];
      plm[18]  <= ~pla[18];
      plm[19]  <=  pla[19];
      plm[20]  <=  pla[20];
      plm[21]  <=  pla[21];
      plm[22]  <=  pla[22];
      plm[23]  <=  pla[23];
      plm[24]  <=  pla[24];
      plm[25]  <=  pla[25];
      plm[26]  <=  pla[26];
      plm[27]  <= ~pla[27];
      plm[28]  <=  pla[28];
      plm[29]  <=  pla[29];
      plm[30]  <= ~pla[30];
   end
end

assign plr[8]  = plm_wt[8];
assign plr[25] = plm_wt[25];
assign plr[26] = plm_wt[26];
assign plr[30] = plm_wt[30];

assign plr[21] = (ra_fr & en_alu | mw_stb) ? ~plm[21] : ~plm_wt[21];
assign plr[22] = (ra_fr & en_alu | mw_stb) ? ~plm[22] : ~plm_wt[22];
assign plr[23] = (ra_fr & en_alu | mw_stb) ? ~plm[23] : ~plm_wt[23];
assign plr[24] = (ra_fr & en_alu | mw_stb) ? ~plm[24] : ~plm_wt[24];

assign set_cend =  na_rc[0] & mc_stb & pla[25] & ~pla[26];
assign wt_state = ~na_rc[0] & mc_stb & pla[25] & ~pla[26];
//
// ALU operation is modifiable from extended arithmetics unit
//
assign plm1m   = plm[1] | (~plm[25] & ~dc_fb);
assign plm18m  = plm[18] | (~ea_1t & ea_sh2 & ea_shl);
assign plm19m  = plm[19] & ( ea_1t | ~ea_shl);
assign plm20m  = plm[20] & ~ea_shr;
assign plm13m  = plm[13] & ~ea_mop0 & ~ea_mop1 & (~ea_div | ~ea_f[1] | (tlz ^ ear1[15]));
assign plm14m  = plm[14]
               & (~acc[15] | ~ea_muls | ~ea_f[0])
               & ((tlz ^ acc[15]) | ~ea_div | ~ea_f[19])
               & (~(tlz ^ ear1[15]) | ~ea_f[1] | ~ea_div | ea_mop0 | (acc[15] ^ ear1[15]))
               & (~ea_div | ea_mop0 | ~ea_f218 | ~ear2[0]);


always @(posedge pin_clk_p)
begin
   //
   // Current microinstruction address latch
   //    - direct branch from preliminary decoder
   //    - next address field
   //
   if (~sa1)
      if (ir_stb)
         ia <= {pld[0], pld[8], pld[7], ~pld[6], ~pld[9], ~pld[11]};
      else
         ia <= na;
   //
   // Auxiliary conditions register
   //
   if (~sa1) ix[0] <= dc_fl;
   if (~sa1) ix[1] <= dc_aux;
   if (ir_stb) ix[2] <= dc_bi;
   //
   // Interrupt query register
   //
   if (ir_stb & ~dc_i7)
      ri[0] <= 1'b0;
   else
      if (pi_stb_xt)
         ri[0] <= plm[3];
      else
         if (pli_ack)
            ri[0] <= ~pli[1];

   if (ir_stb & psw[8])
      ri[1] <= 1'b1;
   else
      if (pi_stb_xt)
         ri[1] <= plm[2];
      else
         if (pli_ack)
            ri[1] <= ~pli[5];

   if (ir_stb & dc_f2)
      ri[2] <= 1'b1;
   else
      if (pi_stb_xt)
         ri[2] <= plm[1];
      else
         if (pli_ack)
            ri[2] <= pli[4];
end

assign pli_req = mc_stb &  na_rc[1] & pla[28];
assign sd_word = mc_stb & ~na_rc[1] & pla[28];

always @(*)
begin
   if (sd_word)
      word27 <= 1'b1;
   else
      if (mc_res | (rd_end & plm[27]))
         word27 <= 1'b0;
end
//______________________________________________________________________________
//
// Interrupt processing unit
//
vm2_pli pli_matrix(.rq(qri), .sp(pli));

assign qri[0]  = acok_rq;           // nACLO rise interrupt request
assign qri[1]  = psw[7] & psw[8];   // halt mode interrupt disable
assign qri[2]  = 1'b0;              // reserved entry
assign qri[3]  = halt;              // external halt mode interrupt
assign qri[4]  = tout_rq;           // bus timeout exception request
assign qri[5]  = virq;              // external vectored interrupt
assign qri[6]  = aclo_rq;           // nACLO fall interrupt request
assign qri[7]  = vec_stb;           // vectored interrupt ack
assign qri[8]  = dble_rq;           // double bus timeout exception
assign qri[9]  = wcpu;              // WAIT instruction execution
assign qri[10] = evnt_rq;           // system timer interrupt request
assign qri[11] = tbit | psw[4];     // T-bit step trap request
assign qri[12] = dc_rtt & (tbit | psw[4]);
assign qri[13] = psw[8];            // halp mode flag
assign qri[14] = psw[7];            // interrupt disable flag
assign qri[15] = ac0;               // wait initial nACLO rise

always @(posedge pin_clk_p)
begin
   pli_arq <= abort;
   pli_ack <= ~reset & (pli_arq & ~abort | pli_req);
end

always @(posedge pin_clk_p)
begin
   //
   // Interrupt requests acknowlegement and reset
   //
   if (reset)
   begin
      acok_rq <= 1'b0;
      tout_rq <= 1'b0;
      aclo_rq <= 1'b0;
      dble_rq <= 1'b0;
   end
   else
      begin
         if (aclo_ack)
            acok_rq <= 1'b0;
         else
            if (~aclo_stb & aclo_rise)
               acok_rq <= 1'b1;

         if (aclo_ack)
            aclo_rq <= 1'b0;
         else
            if (aclo_stb & aclo_fall)
               aclo_rq <= 1'b1;

         if (tovf_ack)
            tout_rq <= 1'b0;
         else
            if (tovf)
               tout_rq <= 1'b1;

         if (ir_stb)
            dble_rq <= 1'b0;
         else
            if (tovf & dble_cnt1)
               dble_rq <= 1'b1;
      end

   if (init | evnt_ack)
      evnt_rq  <= 1'b0;
   else
      if (evnt & evnt_fall)
         evnt_rq  <= 1'b1;
end

always @(posedge pin_clk_p)
begin
   //
   // nEVNT falling edge detector
   //
   if (~evnt)
      evnt_fall <= 1'b1;
   else
      if (init | evnt_ack)
         evnt_fall <= 1'b0;
   //
   // nACLO falling edge detector
   //
   if (~aclo_stb)
      aclo_fall <= 1'b1;
   else
      if (reset | aclo_ack)
         aclo_fall <= 1'b0;
   //
   // nACLO rising edge detector
   //
   if (aclo_stb)
      aclo_rise <= 1'b1;
   else
      if (dclo | aclo_ack)
         aclo_rise <= 1'b0;
   //
   // Double QBUS timeout error counter
   //
   if (tovf)
      dble_cnt0 <= 1'b1;
   else
      if (reset | ir_stb)
         dble_cnt0 <= 1'b0;

   if (~tovf)
      dble_cnt1 <= dble_cnt0;
   else
      if (reset)
         dble_cnt1 <= 1'b0;
end

assign tovf_ack = pi_stb_xt & plm[15] & ~pli6r & ~pli8r;
assign aclo_ack = pi_stb_xt & plm[15] & ~pli6r &  pli8r;
assign evnt_ack = pi_stb_xt & plm[15] &  pli6r & ~pli8r;

always @(posedge pin_clk_p)
begin
   if (pli_ack)
   begin
      pli6r <= pli[6];
      pli8r <= pli[8];

      vsel[0] <=  pli[9];
      vsel[1] <= ~pli[7];
      vsel[2] <= ~pli[2];
      vsel[3] <=  pli[0];
   end
   else
      if (pi_stb_xt)
      begin
         vsel[0] <= plm[20];
         vsel[1] <= plm[19];
         vsel[2] <= plm[18];
         vsel[3] <= plm[17];
      end
end

always @(posedge pin_clk_p)
begin
   if (reset | (plm[15] & pi_stb_xt))
      tbit <= 1'b0;
   else
      if (ir_stb)
         tbit <= psw[4];
end

always @(posedge pin_clk_p)
begin
   if (plm[14] & pi_stb_xt)
      wcpu <= 1'b1;
   else
      if (reset | (plm[15] & pi_stb_xt))
         wcpu <= 1'b0;
end

//______________________________________________________________________________
//
// QBus and INIT timer counter
//
assign pli_nrdy = tend | tim_nrdy0 | tim_nrdy1;
assign tevent   = ~tout | tend | tim_nrdy1;
assign tena     = ~reset & (pli_nrdy | din | dout);
assign tovf     = (~io_qto & ~tevent) | thang;

always @(*)
begin
   if (reset | pli_ack)
      tim_nrdy0 <= 1'b0;
   else
      if (abort)
         tim_nrdy0 <= 1'b1;

   if (reset | (tend & ~f1))
      tim_nrdy1 <= 1'b0;
   else
      if (pi_stb & plm[13])
         tim_nrdy1 <= 1'b1;
end

//______________________________________________________________________________
//
// Branch processing unit
//
vm2_plb  plb_matrix(.rq({na[5], na[4], br}), .sp(plb));

always @(posedge pin_clk_p)
begin
   if (~sb1)
   begin
      br[0] <= bir_stb ? ad[8]  : breg[8];
      br[1] <= bir_stb ? ad[9]  : breg[9];
      br[2] <= bir_stb ? ad[10] : breg[10];
      br[3] <= bir_stb ? ad[12] : breg[12];
      br[4] <= bir_stb ? ad[13] : breg[13];
      br[5] <= bir_stb ? ad[14] : breg[14];
      br[6] <= bir_stb ? ad[15] : breg[15];
      br[7] <= ~dc_b7;
   end
   if (ws_cend)
   begin
      br[8]  <= psw_rc[0];
      br[9]  <= psw_rc[1];
      br[10] <= psw_rc[2];
      br[11] <= psw_rc[3];
   end
   else
   if (ws_wait)
      begin
         br[8]  <= cond_c;
         br[9]  <= cond_v;
         br[10] <= cond_z;
         br[11] <= cond_n;
      end
end

assign ws_cend  = ~sb1 & ~sta_nrdy;
assign ws_wait  = wr2 & ~sb1 & ~ws_cend;
assign clr_wsta = ~sb0 & sb1;
always @(*)
begin
   if (mc_res)
      sb0 <= 1'b0;
   else
      if (~f1 & sb1)
         sb0 <= 1'b0;
      else
         if (bra_req | (wr2 & get_state))
            sb0 <= 1'b1;

   if (f1) sb1 <= sb0;

   if (mc_res | mc_stb)
      bra <= 1'b0;
   else
      if (clr_wsta & ~plb)
         bra <= 1'b1;
end

//______________________________________________________________________________
//
// Y bus constant and vector generator
//
always @(*)
case(vsel)
   4'b0000: vmux = 16'o000030;
   4'b0001: vmux = 16'o000020;
   4'b0010: vmux = 16'o000010;
   4'b0011: vmux = 16'o000014;
   4'b0100: vmux = 16'o000004;
   4'b0101: vmux = 16'o000174;
   4'b0110: vmux = 16'o000000;
   4'b0111: vmux = 16'o000000;
   4'b1000: vmux = 16'o000250;
   4'b1001: vmux = 16'o000024;
   4'b1010: vmux = 16'o000100;
   4'b1011: vmux = 16'o000170;
   4'b1100: vmux = 16'o000034;
   4'b1101: vmux = 16'o000274;
   4'b1110: vmux = 16'o000000;
   4'b1111: vmux = 16'o000000;
   default: vmux = 16'o000000;
endcase

assign csel[0] = plm[12];
assign csel[1] = plm[11];
assign csel[2] = plm[10];
assign csel[3] = plm[9];

always @(*)
case(csel)
   4'b0000: cmux = {12'o0000, ireg[3:0]};
   4'b0001: cmux = {9'o000, ireg[5:0], 1'b0};
   4'b0010: cmux = alt_cnst ? 16'o000002 : 16'o000001;
   4'b0011: cmux = 16'o000002;
   4'b0100: cmux = 16'o000000;
   4'b0101: cmux = 16'o000004;
   4'b0110: cmux = {7'o000, cpsw};     // PSW copy access
   4'b0111: cmux = breg;               // buffered data access
   4'b1000: cmux = {ireg[7] ? 8'o377 : 8'o000, ireg[6:0], 1'b0};
   4'b1001: cmux = psw[3] ? 16'o177777 : 16'o000000;
   4'b1010: cmux = {15'o00000, psw[0]};
   4'b1011: cmux = 16'o000020;
   4'b1100: cmux = vmux;
   4'b1101: cmux = 16'o000024;
   4'b1110: cmux = pc;                 // PC access instead const
   4'b1111: cmux = pc;                 // PC access instead const
   default: cmux = 16'o000000;
endcase

//______________________________________________________________________________
//
// Input X and Y ALU bus muxes
//
always @(*)
case({plm[4], plm[5], plm[6], plm[7]})
   4'b0000: x = r[0];               // register index 0
   4'b0001: x = r[1];               // register index 1
   4'b0010: x = r[2];               // register index 2
   4'b0011: x = r[3];               // register index 3
   4'b0100: x = r[4];               // register index 4
   4'b0101: x = r[5];               // register index 5
   4'b0110: x = r[6];               // register index 6
   4'b0111: x = ra_fr1 ? pc2 : pc1; // register index 7
   4'b1000: x = ear1;               // register index 8
   4'b1001: x = ear2;               // register index 9
   4'b1010: x = 16'o000000;         // eq_cnt, not muxed
   4'b1011: x = sreg;               // register index 11
   4'b1100: x = {7'o000, psw};      // register index 12
   4'b1101: x = acc;                // register index 13
   4'b1110: x = 16'o000000;         // areg, not muxed
   4'b1111: x = qreg;               // register index 15
   default: x = 16'o000000;
endcase

always @(*)
if (plm[8])
   y = cmux;
else
   case({plm[9],plm[10],plm[11],plm[12]})
      4'b0000: y = r[0];            // register index 0
      4'b0001: y = r[1];            // register index 1
      4'b0010: y = r[2];            // register index 2
      4'b0011: y = r[3];            // register index 3
      4'b0100: y = r[4];            // register index 4
      4'b0101: y = r[5];            // register index 5
      4'b0110: y = r[6];            // register index 6
      4'b0111: y = pc1;             // register index 7
      4'b1000: y = ear1;            // register index 8
      4'b1001: y = ear2;            // register index 9
      4'b1010: y = 16'o000000;      // eq_cnt, not muxed
      4'b1011: y = sreg;            // register index 11
      4'b1100: y = {7'o000, psw};   // register index 12
      4'b1101: y = acc;             // register index 13
      4'b1110: y = areg;            // register index 14
      4'b1111: y = qreg;            // register index 15
      default: y = 16'o000000;
   endcase

//______________________________________________________________________________
//
assign xbo[7:0]   = alu_xb ? xb[15:8] : xb[7:0];
assign xbo[14:8]  = alu_xb ? xb[6:0] : xb[14:8];
assign xbo[15]    = (alu_xb ? xb[7] : (xb[15] & ~sf_sum)) | (sf_sum & alu_cr[15]);

assign ax[7:0]    = xbo[7:0];
assign ax[15:8]   = ((sxt_rxy & (~ax[7] | sxt_y)) ? 8'o000 : 8'o377)
                  & (rd2h ? xbo[15:8] : 8'o377);

//______________________________________________________________________________
//
// ALU
//
assign alu_inx = (alu_a ?  x : 16'o000000) | (alu_b ? ~x : 16'o000000);
assign alu_iny = (alu_c ?  y : 16'o000000) | (alu_d ? ~y : 16'o000000);

assign alu_or  = alu_e ? 16'o000000 : (alu_inx | alu_iny);
assign alu_an  = alu_f ? 16'o000000 : (alu_inx & alu_iny);
assign alu_cp  = {alu_cf[14:0], alu_cin};
assign alu_cf  = alu_g ? (alu_cp & alu_or) | alu_an : 16'o000000;
assign alu_af  = alu_cp ^ (alu_an ^ alu_or);

assign alu_sh[6:0]   = (nshift ? alu_af[6:0] : 7'o000)
                     | (rshift ? alu_af[7:1] : 7'o000)
                     | (lshift ? {alu_af[5:0], sh_cin & sh_ci3} : 7'o000);

assign alu_sh[7]     = sh_ci1 & alu_af[7]
                     | rshift & (plm1m ? alu_af[8] : (~sh_ci2 & sh_cin))
                     | lshift & alu_af[6];

assign alu_sh[14:8]  = (nshift ? alu_af[14:8] : 7'o000)
                     | (rshift ? alu_af[15:9] : 7'o000)
                     | (lshift ? alu_af[13:7] : 7'o000);

assign alu_sh[15]    = sh_ci2 & alu_af[15]
                     | rshift & sh_cin & ~sh_ci2
                     | lshift & alu_af[14];

assign ea_mux        = (eas_dir   ? ear2[15:0]              : 16'o000000)
                     | (eas_left  ? {ear2[14:0], ea_mxin}   : 16'o000000)
                     | (eas_right ? {alu_af[0], ear2[15:1]} : 16'o000000);

assign alu_a   = (plm13m  |  plm14m) & ~alu_b;
assign alu_b   = ~plm[17] &  plm14m;
assign alu_c   = (plm13m  | ~plm14m) & ~alu_d;
assign alu_d   =  plm[17] & ~plm14m;
assign alu_e   =  plm[15];
assign alu_f   =  plm[16];
assign alu_g   = ~plm[15] & plm13m & (plm[17] | plm14m);
assign alu_xb  =  sf_xchg | qswp;

assign alu_cin =  alu_g & (~plm[17] | ~plm14m);
assign sh_ci1  =  nshift | (~plm1m & sh_ci2);
assign sh_ci2  =  nshift | (~plm18m & rshift);
assign sh_ci3  =  plm18m | ~lshift;

assign nshift  =  plm19m &  plm20m;
assign lshift  = ~plm19m &  plm20m;
assign rshift  =  plm19m & ~plm20m;

always @(posedge pin_clk_p)
begin
   if (wr1) ea22   <= ea_mux;
   if (wr1) alu_fr <= alu_af;
   if (wr1) alu_cr <= alu_cf;
   if (wr1) xb     <= alu_sh;
end

assign eq1     = (xb[15:0] == 16'o177777);
assign zl      = (xb[7:0]  == 8'o000);
assign zh      = (xb[15:8] == 8'o000);

assign sf_sum  = (alu_cr[14] ^ alu_cr[15]) & ea_mul & ~ea_f0r;
assign sxt_rxy = sf_byte & ~qswp;
assign axy_wh  = ~(sxt_rxy & sxt_y);

always @(posedge pin_clk_p)
if (wr1)
   begin
      sf_dir  <= nshift;
      sf_lr   <= lshift;
      sf_rr   <= rshift;
      sf_inv  <= ~plm[17] & plm14m & ~plm13m;
      sf_sub  <= ~alu_cin;
      sf_byte <= ~plm1m;
      sf_xchg <= plm18m & plm19m & plm20m;
      sxt_y   <= plm13m | plm14m | plm[17];
   end

assign cond_n  = sf_byte ? xb[7] : xb[15];

assign cond_z  = zl & sf_byte
               | zh & sf_xchg
               | zl & zh & ~ea_sh2 & ~ea_mul & ~sf_xchg & ~sf_byte
               | zl & zh & ea_22z & (ea_sh2 | ea_mul);

assign cond_v  = ~ea_shr
               & ~ea_mul
               & (ea_vdiv | ~ea_div)
               & (div_vf | ~ea_shl)
               & (ea_div | ea_shl |
                 ( ((alu_cr[6]  ^ alu_cr[7] ) | ~sf_dir | ~sf_byte)
                 & ((alu_cr[14] ^ alu_cr[15]) | ~sf_dir |  sf_byte)
                 & (sf_dir | (cond_n ^ cond_c0))));

assign cond_c  = (zero_div | ~ea_div)
               & ((~sf_sub ^ cond_c0) | sf_inv | ea_mul)
               & cond_c1
               & cond_c2;

assign cond_c0 = (~sf_lr  |  sf_byte | alu_fr[15])
               & (~sf_lr  | ~sf_byte | alu_fr[7])
               & (~sf_rr  |  ea_shr2 | alu_fr[0])
               & (~sf_dir | ~sf_byte | alu_cr[7])
               & (~sf_dir |  sf_byte | alu_cr[15] | ea_mul | ea_div);

assign cond_c1 = ~ea_mul | ((~eq1 | ~ea22[15]) & (~zh | ~zl | ea22[15]));
assign cond_c2 = ~ea_shr2 | ea_20r;

//______________________________________________________________________________
//
// Register unit
//
always @(posedge pin_clk_p)
begin
   if (axy_wh)
   begin
      if (rn_wa[0]) r[0][15:8] <= ax[15:8];
      if (rn_wa[1]) r[1][15:8] <= ax[15:8];
      if (rn_wa[2]) r[2][15:8] <= ax[15:8];
      if (rn_wa[3]) r[3][15:8] <= ax[15:8];
      if (rn_wa[4]) r[4][15:8] <= ax[15:8];
      if (rn_wa[5]) r[5][15:8] <= ax[15:8];
      if (rn_wa[6]) r[6][15:8] <= ax[15:8];
   end

   if (rn_wa[0]) r[0][7:0] <= ax[7:0];
   if (rn_wa[1]) r[1][7:0] <= ax[7:0];
   if (rn_wa[2]) r[2][7:0] <= ax[7:0];
   if (rn_wa[3]) r[3][7:0] <= ax[7:0];
   if (rn_wa[4]) r[4][7:0] <= ax[7:0];
   if (rn_wa[5]) r[5][7:0] <= ax[7:0];
   if (rn_wa[6]) r[6][7:0] <= ax[7:0];
end

always @(posedge pin_clk_p)
begin
   //
   // Write can happen in the same clock for all pc2->pc1->pc
   // So we should implement the correct register write chain
   //
   if (pc2_wa)
   begin
      pc2[7:0] <= ax[7:0];
      if (axy_wh) pc2[15:8] <= ax[15:8];
   end
   if (pc1_wr)
   begin
      pc1[7:0] <= pc2_wa ? ax[7:0] : pc2[7:0];
      pc1[15:8] <= pc2_wa ? (axy_wh ? ax[15:8] : pc2[15:8]) : pc2[15:8];
   end
   if (pc_wax)
      pc <= ax;
   else
      if (pc_wr)
      begin
         pc[7:0] <= pc1_wr ? (pc2_wa ? ax[7:0] : pc2[7:0]) : pc1[7:0];
         pc[15:8] <= pc1_wr ?
            (pc2_wa ? (axy_wh ? ax[15:8] : pc2[15:8]) : pc2[15:8]) : pc1[15:8];
      end

   if (axy_wh)
   begin
      if (acc_wa) acc[15:8] <= ax[15:8];
      if (ea1_wa) ear1[15:8] <= ax[15:8];
      if (rs_wa) sreg[15:8] <= ax[15:8];
   end

   if (acc_wa) acc[7:0] <= ax[7:0];
   if (ea1_wa) ear1[7:0] <= ax[7:0];
   if (rs_wa) sreg[7:0] <= ax[7:0];

   if (ea1_wa)
      ear2 <= ea22;
   else
   begin
      if (ea2_wa) ear2[7:0] <= ax[7:0];
      if (ea2_wa & axy_wh)
         ear2[15:8] <= ax[15:8];
   end
end

always @(posedge pin_clk_p)
begin
   if (ra_wa)
   begin
      areg[7:0] <= ax[7:0];
      if (axy_wh)
         areg[15:8] <= ax[15:8];
   end
   else
      if (ra_wx)
         areg <= x;
end

always @(posedge pin_clk_p)
begin
   if (brd_wa)
   begin
      qreg[7:0] <= ax[7:0];
      if (axy_wh)
         qreg[15:8] <= ax[15:8];
   end
   else
      if (brd_wq)
         qreg  <= qd_swap ? {8'o000, ad[15:8]} : ad;
end

//______________________________________________________________________________
//
// PSW and PSW copy
//
assign psw_rc[0] = psw_wa  & ax[0] | ~psw_wa  & pswc_stb & cond_c | ~psw_wa & ~pswc_stb & psw[0];
assign psw_rc[1] = psw_wa  & ax[1] | ~psw_wa  & psw_stb  & cond_v | ~psw_wa & ~psw_stb  & psw[1];
assign psw_rc[2] = psw_wa  & ax[2] | ~psw_wa  & psw_stb  & cond_z | ~psw_wa & ~psw_stb  & psw[2];
assign psw_rc[3] = psw_wa  & ax[3] | ~psw_wa  & psw_stb  & cond_n | ~psw_wa & ~psw_stb  & psw[3];
assign psw_rc[4] = pswt_wa & ax[4] | ~pswt_wa & psw[4];
assign psw_rc[5] = psw_wa  & ax[5] | ~psw_wa  & psw[5];
assign psw_rc[6] = psw_wa  & ax[6] | ~psw_wa  & psw[6];
assign psw_rc[7] = psw_wa  & ax[7] | ~psw_wa  & psw[7];
assign psw_rc[8] = psw8_wa & ax[8] | ~psw8_wa & psw[8];

always @(posedge pin_clk_p)
begin
   if (cpsw_wa)
   begin
      cpsw[7:0] <= ax[7:0];
      if (axy_wh)
         cpsw[8] <= ax[8];
   end
   else
      if (cpsw_stb)
         cpsw[8:0] <= psw_rc[8:0];
end

always @(posedge pin_clk_p)
begin
   if (pswt_wa) psw[4] <= ax[4];
   if (psw_wa) psw[7:5] <= ax[7:5];
   if (psw8_wa) psw[8] <= ax[8];
end

always @(posedge pin_clk_p)
begin
   if (psw_wa)
      psw[3:0] <= ax[3:0];
   else
   begin
      if (pswc_stb) psw[0] <= cond_c;
      if (psw_stb)  psw[1] <= cond_v;
      if (psw_stb)  psw[2] <= cond_z;
      if (psw_stb)  psw[3] <= cond_n;
   end
end

//______________________________________________________________________________
//
assign rn_wa[6:0] = (wr2 & wa_gpr) ? wa[6:0] : 7'b0000000;
assign pc_wax     =  wr2 & wa_r1;
assign pc2_wa     =  wr2 & wa_gpr & wa[7] & ~(pc2_res & ~io_rcd & ~io_cmd);
assign acc_wa     =  wr2 & wa_reg & wa[5];
assign rs_wa      =  wr2 & wa_reg & wa[3];
assign ra_wa      =  wr2 & ra_fw;
assign ra_wx      =  alu_wr & ra_fr;
assign wra        =  (ra_wx | ra_wa) & ~io_clr
                  & (plr[21] | plr[22] | plr[23])
                  & (~dc_mop0 | ~dc_mop1 | ~io_x001);
//______________________________________________________________________________
//
always @(posedge pin_clk_p)
if (mw_stb_xt)
begin
   //
   // Register (breg, cpsw, pc) is accessed on Y bus, not constant
   //
   plm_rn[4] <= plm[8] & plm[10] & plm[11]
               & ~plm[29] & ~plm[2] & ~plm[3];

   if (~plm[29] & plm[3])        // store in to accumulator
      plm_rn[3:0] <= 4'b1101;    // at write result phase
   else
      begin
         plm_rn[0] <= plm[29] ? plm[7] : ~plm[2] & plm[12];
         plm_rn[1] <= plm[29] ? plm[6] : ~plm[2] & plm[11];
         plm_rn[2] <= plm[29] ? plm[5] : ~plm[2] & plm[10];
         plm_rn[3] <= plm[29] ? plm[4] : ~plm[2] & plm[9];
      end
   ra_fw <= ra_fwn;
end

assign ra_fwn = plm[2] & plm[3];
assign ra_fr  =  ra_fr1 | (plm[2] & ~plm[3]);
assign ra_fr1 = ~plm[2] & plm[3] & plm[29];
always @(*) if (wr2) wr7 <= wa_gpr & wa[7] & ~ra_fr1;

assign wa_r1      =  plm_rn[3] &  plm_rn[4];
assign wa_r2      = ~plm_rn[3] &  plm_rn[4] & ~plm_rn[0];
assign wa_gpr     = ~plm_rn[3] & ~plm_rn[4]
                  | ~plm_rn[3] &  plm_rn[0];
assign wa_reg     =  plm_rn[3] & ~plm_rn[4];

assign cpsw_wa    = wr2 &  wa_r2;
assign ea1_wa     = wr2 &  wa_reg & wa[0];
assign ea2_wa     = wr2 &  wa_reg & wa[1];
assign ea_ctld    = wr2 &  wa_reg & wa[2];
assign psw_wa     = wr2 &  wa_reg & wa[4];
assign psw8_wa    = wr2 &  wa_reg & wa[4] & ~sf_byte;
assign pswt_wa    = wr2 &  wa_reg & wa[4] & ((sf_byte & ~na0r) | ~sf_byte);
assign brd_wa     = wr2 &  wa_reg & wa[7];
assign psw_stb    = wr2 & ~plr[25];
assign pswc_stb   = wr2 & ~plr[25] & ~plr[26];
assign wr_psw     = psw_stb | (psw_wa & ~plr[8]);
assign cpsw_stb   = (~psw[7] | ~psw[8]) & ((wr_psw & ~io_pswr) | (dout_clr & io_pswr));
assign pc_wr      = cpsw_stb | (pc1_wr & (~psw[7] | ~psw[8]) & (io_wr | (~sync_clw & ~io_pswr)));
assign pc1_wr     = (wr2 & wa_gpr & wa[7] & ~io_rcdr) | word27 | (wr1 & io_rcdr & ~iopc_st[1]);

assign wa[0]      = (plm_rn[2:0] == 3'b000);
assign wa[1]      = (plm_rn[2:0] == 3'b001);
assign wa[2]      = (plm_rn[2:0] == 3'b010);
assign wa[3]      = (plm_rn[2:0] == 3'b011);
assign wa[4]      = (plm_rn[2:0] == 3'b100);
assign wa[5]      = (plm_rn[2:0] == 3'b101);
assign wa[6]      = (plm_rn[2:0] == 3'b110);
assign wa[7]      = (plm_rn[2:0] == 3'b111);

assign qswp       = wa[7] & wa_reg & qa0;
assign rd2h       = qswp | ~sf_byte;

//______________________________________________________________________________
//
// Extended arithmetics processing unit
//
assign ea_ctse    = ~acc[5] | ~ireg[10];
assign ea_22z     = (ea22 == 16'o000000);
assign ea_shr2    = ea_sh2 & acc[5];
assign ea_shr     = ea_nrdy &  acc[5] & ireg[10];
assign ea_shl     = ea_nrdy & ~acc[5] & ireg[10];
assign ea_sh2     = ea_nrdy &  ireg[9] &  ireg[10];
assign ea_div     = ea_nrdy &  ireg[9] & ~ireg[10];
assign ea_mul     = ea_nrdy & ~ireg[9] & ~ireg[10];
assign sh_cin     = (ea_shl | ea_div) ? ear2[15] : psw[0];
assign ea_vdiv    = zero_div
                  | (ea_mxinr ^ alu_fr[15] ^ alu_cr[15])
                  | (ea_mxinr ^ tlz ^ acc[15]);

assign eas_dir    = nshift & ~(ea_div & ea_f[3]);
assign eas_left   = lshift |  (ea_div & ea_f[3]);
assign eas_right  = rshift;

assign ea_mop0    = ea_div  & ((ea_f[0] & (tlz ? ~(acc[15] ^ wait_div) : ~acc[15])) | (ea_fn12 & ~wait_div));
assign ea_mop1    = ea_muls & ((ea_f[0] & ~acc[15]) | (~ea_f[0] & ~ear2[0]));
//
// Extended aritmetics internal phase counter,
// decremented every wr2 write cycle
//
always @(posedge pin_clk_p)
begin
   if (ea_ctld)
      ea_ct[4:0] <= ea_ctse ? ax[4:0] : ~ax[4:0];
   else
      if (wr2 & ea_nrdy)
         ea_ct <= ea_ct - 5'b00001;
end
//
// The first cycle after EA counter load
//
always @(posedge pin_clk_n) if (wr2_xt) ea_1t <= wa_reg & wa[2];
always @(posedge pin_clk_p) if (wr1) ea_1tm <= ea_1t;

assign ea_f[0]    = (ea_ct == 5'b00000);
assign ea_f[1]    = (ea_ct == 5'b00001);
assign ea_f[2]    = (ea_ct == 5'b00010);
assign ea_f[3]    = (ea_ct == 5'b00011);
assign ea_f[4]    = (ea_ct == 5'b00100);
assign ea_f[19]   = (ea_ct == 5'b10011);
assign ea_f[20]   = (ea_ct == 5'b10100);

assign ea_fn12    = ea_f[2] | ea_f[1];                               // phases 2:1
assign ea_f218    = ~ea_f[19] & ~ea_f[20] & ~ea_f[0] & ~ea_f[1];     // phases 21,18:2

always @(posedge pin_clk_p)
begin
   if (wr1)
   begin
      ea_20r   <= ear2[0];
      ea_fn23r <= ea_f[3] | ea_f[2];
      ea_f0r   <= ea_f[0];
   end
   if (ea_ctld)
      ea_f4r <= 1'b0;
   else
      if (wr1) ea_f4r <= ea_f[4];
end

always @(posedge pin_clk_p)
begin
   if (wr2 & ea_fn23r) wait_div <= ~cond_z;
   if (wr2 & ea_1tm)  zero_div <= cond_z;
   if (wr1 & ea_1t) tlz <= ear1[15];
end

//
// Sticky DIV overflow (V) flag
// Check and store V on every division cycle
//
always @(posedge pin_clk_p)
begin
   if (~ea_1t & (tlz ^ xb[15]))
      div_vfr <= 1'b1;
   else
      if (ea_1t)
         div_vfr <= 1'b0;
end
assign div_vf = div_vfr | (tlz ^ xb[15]);

assign ea_mxin = ~ea_shl & ~(alu_af[15] ^ acc[15]);
always @(posedge pin_clk_p) if (wr1 & ea_f[19]) ea_mxinr <= ea_mxin;

assign ea_muls       = ea_mul & ea_trdy1;
assign ea_rdy        = ea_trdy0 & (~ea_trdy1 | ea_f[0] | ~ireg[10]);
assign ea_nrdy       = ea_trdy1 | ea_trdy1_clr;
assign ea_trdy0_set  = mc_res | (~wr2 & ((ea_div & ea_f[4]) | (ea_f[1] & (ea_div | ea_muls))));
assign ea_trdy0_clr  = wr2 & ((ea_muls & ea_1t) | (ea_div & (ea_1tm | ea_f4r)));
assign ea_trdy1_clr  = wr2 & ~ea_ctld & ea_nrdy & ea_f0r;

always @(*)
begin
   if (ea_trdy0_set)
      ea_trdy0 = 1'b1;
   else
      if (ea_trdy0_clr)
         ea_trdy0 = 1'b0;

   if (mc_res | ea_trdy1_clr)
      ea_trdy1 <= 1'b0;
   else
      if (ea_ctld)
         ea_trdy1 <= 1'b1;
end
//______________________________________________________________________________
//
// ALU state machine
//
assign en_alu     = ((mc_drdy & mc_rdy & io_rdy) | ~ea_rdy) & ~alu_st[1]
                  & ((~ra_fr & ~ra_fwn) | (~rta & ~rta_fall));

assign rd_end     = alu_st[1] &  alu_st[2];
assign alu_wr     = alu_st[1] & ~alu_st[2] & ea_rdy;
assign wr2        = alu_st[2] & ~alu_st[1];
assign wr2_xt     = alu_st[2];
assign mw_stb     = alu_st[0] & ~alu_st[1];
assign mw_stb_xt  = alu_st[0] & ~alu_st[2];
assign wr1        = alu_st[1] & ~alu_st[2];
assign ad_rd      = bir_stb | brd_wq | rdat;

//
// Internal to_reply is asserted only for prefetch transactions
//
assign to_clr     = ~to_rply & ~iop_rcd;
assign bir_stb    = rdat & (~iop_in | iop_rcd);
assign brd_wq     = rdat & ( iop_in | iop_rcd);
assign io_start   = wra | (wr2 & iop_una);

always @(*)
begin
   if (mc_res)
      alu_st[0] <= 1'b0;
   else
      if (f1) alu_st[0] <= en_alu;

   if (~f1) alu_st[1] <= alu_st[0];

   if (mc_res)
      alu_st[2] <= 1'b0;
   else
      if (f1) alu_st[2] <= alu_st[1];
end

always @(*)
begin
   if (sync_clr)
      iop_in <= 1'b0;
   else
      if (iop_stb & io_in)
         iop_in <= 1'b1;

   if (sync_clr | to_rply)
      iop_rcd <= 1'b0;
   else
      if (iop_stb & io_rcd)
         iop_rcd <= 1'b1;

   if (word27 | io_cmdr)
      iopc_st[0] <= 1'b1;
   else
      if (io_rcdr & ~word27)
         iopc_st[0] <= 1'b0;

   if (io_cmdr)
      iopc_st[1] <= 1'b1;
   else
      if (~io_rcdr)
         iopc_st[1] <= iopc_st[0];
end

assign mc_drdy = ~plm[27] | mc_drdy1;
always @(*)
begin
   if (sk)
      mc_drdy0 <= 1'b0;
   else
      if (io_start & io_in)
         mc_drdy0 <= 1'b1;

   if (mc_res | mc_drdy0)
      mc_drdy1 <= 1'b0;
   else
      if (~f1 & brd_wq)
         mc_drdy1 <= 1'b1;
end

assign io_rdy  = ~io_st[2] | ~io_st[4];
assign iop_stb = (io_st[2] & ~io_st[4] & io_st[5]) | (~io_st[1] & io_start);

always @(*)
begin
   if (mc_res | (sync_clr & ~io_st[2]))
      io_st[0] <= 1'b0;
   else
      if (io_start)
         io_st[0] <= 1'b1;

   if (~io_start)
      io_st[1] <= io_st[0];

   if (mc_res | (~io_st[4] & ~io_st[5]))
      io_st[2] <= 1'b0;
   else
      if (io_start & io_st[1])
         io_st[2] <= 1'b1;

   if (sync_clr)
      io_st[3] <= 1'b0;
   else
      if (f1 & ~io_st[4])
         io_st[3] <= 1'b1;

   if (~f1) io_st[4] <= io_st[3];
   if ( f1) io_st[5] <= io_st[4];
end

always @(*)
begin
   if (iop_stb)
      skp <= 1'b1;
   else
      if (~f1 & sk)
         skp <= 1'b0;

   if (f1) sk <= skp;
end

always @(*)
begin
   if (to_clr | word27)
      io_qto <= 1'b0;
   else
      if (tevent)
         io_qto <= 1'b1;
end

assign thang      = ~iocmd_st[2] & iocmd_st[5];
assign abort      = ~iocmd_st[0] & ~iocmd_st[1] & ~tevent & ~io_qto;
assign io_clr     = thang | (io_rcd1 & iocmd_st[5]);
assign rcmd_set   = thang | (buf_res & iocmd_st[4]);

always @(*)
begin
   if (reset)
      iocmd_st[0] <= 1'b0;
   else
      if (f1)
      begin
         if (iocmd_st[2] & ~iocmd_st[4])
            iocmd_st[0] <= 1'b0;
         else
            if (rcmd_set)
               iocmd_st[0] <= 1'b1;
      end

   if (~f1) iocmd_st[1] <= iocmd_st[0];

   if (wr2 | (~f1 & iocmd_st[0]))
      iocmd_st[2] <= 1'b1;
   else
      if (word27 & alu_wr)
         iocmd_st[2] <= 1'b0;

   if (wr2 & io_rcd1)
      iocmd_st[3] <= 1'b1;
   else
      if (~io_rcd1 | (~f1 & iocmd_st[0]))
      iocmd_st[3] <= 1'b0;

   if (~iocmd_st[3])
      iocmd_st[4] <= 1'b0;
   else
      if (~f1 & iocmd_st[3] & ~creq)
         iocmd_st[4] <= 1'b1;

   if (wr7 | reset)
      iocmd_st[5] <= 1'b0;
   else
      if (to_rply)
         iocmd_st[5] <= 1'b1;

   if (wr7 | reset)
      buf_res <= 1'b0;
   else
      if (mdfy | to_rply)
         buf_res <= 1'b1;
end

//______________________________________________________________________________
//
// Input bus X register indices for phase read 1
// For debug purposes only, for diagram synchronizing
//
// Index 10 is for ea_cnt, no read to bus X implemented in original core
// Index 14 is for areg, no read to bus X implemented in original core
//
wire [6:0]  rn_rx, rn_ry;
wire        pc1_rx, pc1_ry;
wire        pc2_rx, ra_ry;
wire        ea1_rx, ea1_ry;
wire        ea2_rx, ea2_ry;
wire        rs_rx, rs_ry;
wire        psw_rx, psw_ry;
wire        acc_rx, acc_ry;
wire        brd_rx, brd_ry;
wire        cpsw_ry;
wire        bir_ry;
wire        pc_ry;

assign rn_rx[0]   = (plm[7:4] == 4'b0000);            // register index 0
assign rn_rx[1]   = (plm[7:4] == 4'b1000);            // register index 1
assign rn_rx[2]   = (plm[7:4] == 4'b0100);            // register index 2
assign rn_rx[3]   = (plm[7:4] == 4'b1100);            // register index 3
assign rn_rx[4]   = (plm[7:4] == 4'b0010);            // register index 4
assign rn_rx[5]   = (plm[7:4] == 4'b1010);            // register index 5
assign rn_rx[6]   = (plm[7:4] == 4'b0110);            // register index 6
                                                      //
assign pc1_rx     = (plm[7:4] == 4'b1110) & ~ra_fr1;  // register index 7
assign pc2_rx     = (plm[7:4] == 4'b1110) &  ra_fr1;  // register index 7
assign ea1_rx     = (plm[7:4] == 4'b0001);            // register index 8
assign ea2_rx     = (plm[7:4] == 4'b1001);            // register index 9
assign rs_rx      = (plm[7:4] == 4'b1101);            // register index 11
assign psw_rx     = (plm[7:4] == 4'b0011);            // register index 12
assign acc_rx     = (plm[7:4] == 4'b1011);            // register index 13
assign brd_rx     = (plm[7:4] == 4'b1111);            // register index 15

//______________________________________________________________________________
//
// Input bus Y register indices for phase read 1
// For debug purposes only, for diagram synchronizing
//
// Index 10 is for ea_cnt, no read to bus X implemented in original core
// plm[8] == 0 indicates operations with two operands
// plm[8] == 1 indicates operations with constant
//
assign rn_ry[0]   = (plm[12:8] == 5'b00000);          // register index 0
assign rn_ry[1]   = (plm[12:8] == 5'b10000);          // register index 1
assign rn_ry[2]   = (plm[12:8] == 5'b01000);          // register index 2
assign rn_ry[3]   = (plm[12:8] == 5'b11000);          // register index 3
assign rn_ry[4]   = (plm[12:8] == 5'b00100);          // register index 4
assign rn_ry[5]   = (plm[12:8] == 5'b10100);          // register index 5
assign rn_ry[6]   = (plm[12:8] == 5'b01100);          // register index 6
                                                      //
assign pc1_ry     = (plm[12:8] == 5'b11100);          // register index 7
assign ea1_ry     = (plm[12:8] == 5'b00010);          // register index 8
assign ea2_ry     = (plm[12:8] == 5'b10010);          // register index 9
assign rs_ry      = (plm[12:8] == 5'b11010);          // register index 11
assign psw_ry     = (plm[12:8] == 5'b00110);          // register index 12
assign acc_ry     = (plm[12:8] == 5'b10110);          // register index 13
assign ra_ry      = (plm[12:8] == 5'b01110);          // register index 14
assign brd_ry     = (plm[12:8] == 5'b11110);          // register index 15
                                                      //
assign cpsw_ry    = (plm[12:8] == 5'b01101);          // constant index 6
assign bir_ry     = (plm[12:8] == 5'b11101);          // constant index 7
assign pc_ry      = (plm[12:8] == 5'b01111)           // constant index 14
                  | (plm[12:8] == 5'b11111);          // constant index 15

//______________________________________________________________________________
//
endmodule
