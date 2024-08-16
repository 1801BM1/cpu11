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
// - no extra instruction words are used by destination (no E(Rn), @E(Rn))
// - Q-bus is slow and opcode prefetch is not completed before microcode
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
   input          pin_clk,       // processor clock
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
   input          pin_waki,      // window grant request
   output         pin_wrq,       // window grant acknowlegement
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
reg            f1, f2;                 // phase clock generator
reg            virq, halt, evnt;       // interrupt requests
reg            dclo, aclo;             // cold reset, power monitor
reg            aclo_stb;               //
                                       //
reg            ac0;                    // initial ACLO rising edge detected
reg            dble_cnt0;              // double QBUS timeout error counter
reg            dble_cnt1;              //
reg            evnt_fall;              // EVNT  rising edge detector
reg            aclo_fall;              // ACLO falling edge detector
reg            aclo_rise;              // ACLO rising edge detector
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
reg            waki;                   //
wire           ar;                     //
wire           sack;                   //
wire           win_req;                //
reg            wrq;                    //
wire           iako;                   //
reg            iako_out;               //
reg            vec_stb;                //
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
wire           io_rcd1;                //
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
wire           reset;                  //
wire           abort;                  //
wire           mc_res;                 //
wire           mc_stb;                 // mc read phase strobe
wire           mw_stb;                 // mc write phase strobe
wire           pi_stb;                 // peri
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
reg            sa1, sa2;               //
reg            br_iocmd;               // instruction reading to breag in progress
reg            br_ready;               // breg contains valid read instruction
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
reg            get_state, get_sta0;    //
reg            acmp_te, acmp_en;       //
                                       //
wire           din_set, dout_set;      //
reg            din_clr, dout_clr;      //
wire           sync_clr;               //
wire           rcmd_set;               // set command re-fetch request
                                       //
reg   [15:0]   ireg;                   // primary instruction register
reg   [15:0]   breg;                   // prefetch instruction register
reg   [5:0]    ia;                     // microinstuction address register
reg   [2:0]    ri;                     // interrupt acknowlegement register
reg   [2:0]    ix;                     // auxiliary conditions register
                                       //
reg   [11:0]   br;                     // branch processing matrix input register
reg   [15:0]   qr;                     // interrupt processing matrix input register
wire  [9:0]    pli;                    // interrupt priority encode matrix output
wire  [11:0]   pld;                    // preliminary instruction decoder matrix output
wire           plb;                    // branch processing matrix output
                                       //
reg            na0r, na1w;             //
reg   [5:0]    na;                     // microcode next address field
reg   [30:0]   plm;                    // main matrix result register (first stage)
reg   [30:8]   plm_wt;                 //
wire  [30:8]   plr;                    //
wire  [36:0]   pla;                    //
                                       //
reg   [4:0]    plm_rn;                 //
wire  [6:0]    rn_wa;                  //
wire           pc2_wa;                 //
wire           pc2_was;                //
wire  [6:0]    rn_ry;                  //
wire  [6:0]    rn_rx;                  //
wire  [7:0]    wa;                     //
wire  [5:0]    cn_rd;                  //
wire           cn_ry0, cn_ry1;         //
wire           wa_gpr;                 //
wire           wa_reg;                 //
wire           wa_r1, wa_r2;           //
wire           rd_reg;                 //
wire           ra_wa;                  // write address register from ax-bus
wire           ra_wx;                  // write address register from x-bus
reg            ra_fw;                  //
wire           ra_fwn;                 //
wire           ra_fr, ra_fr1;          //
reg            ra_fr2;                 //
wire           rx_gpr, ry_gpr;         //
wire           rx_reg, ry_reg;         //
wire           pc1_rx, pc1_ry;         //
wire           pc2_rx, pc_ry;          //
wire           pc1_wr, pc_wax;         //
wire           pc_wr;                  //
wire           brd_rx, brd_ry;         //
wire           acc_rx, acc_ry;         //
wire           rs_wa, acc_wa;          //
wire           rs_rx, rs_ry;           //
wire           ra_ry;                  //
wire           bir_ry;                 //
wire           cpsw_wa, cpsw_ry;       //
wire           cpsw_stb;               //
wire           ea1_wa, ea2_wa;         //
wire           ea1_rx, ea1_ry;         //
wire           ea2_rx, ea2_ry;         //
wire           ea_ctld;                //
wire           pswt_wa;                //
wire           psw_wa, psw8_wa;        //
wire           psw_rx, psw_ry;         //
wire           psw_stb, pswc_stb;      //
wire           wr_psw;                 //
wire           brd_rql, brd_rqh;       //
wire           qd_swap;                //
wire           qswp, rd2h;             //
reg            qa0;                    //
reg            wr7;                    //
                                       //
wire  [15:0]   const0[5:0];            //
wire  [15:0]   const1[5:0];            //
                                       //
reg   [15:0]   ea22;                   // extended arithmetics register
reg   [15:0]   ear1;                   // extended arithmetics register
reg   [15:0]   ear2;                   // extended arithmetics register
reg   [15:0]   acc;                    // accumulator
reg   [15:0]   sreg;                   // source register
reg   [15:0]   r[6:0];                 // general purpose register files
reg   [15:0]   pc2;                    //
reg   [15:0]   pc1;                    //
reg   [15:0]   pc;                     //
reg   [8:0]    psw;                    //
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
wire  [15:0]   xbo;                    //
wire  [15:0]   x, ax;                  // ALU X (input) and X* (output) bus
wire  [15:0]   y, ay;                  // ALU Y (input) and Y* (output) bus
                                       //
wire           alu_cin;                //
wire           alu_a, alu_b;           // ALU function controls
wire           alu_c, alu_d;           //
wire           alu_e, alu_f;           //
wire           alu_g, alu_h;           //
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
wire           en_rd;                  //
wire           mc_drdy;                //
reg            mc_drdy0, mc_drdy1;     //
reg   [5:0]    alu_st;                 // ALU state machine
reg   [5:0]    iocmd_st;               //
reg   [1:0]    iopc_st;                //
reg   [5:0]    io_st;                  //
reg            buf_res;                //
reg            pc2_res;                // ignore pc2 write
wire           wr1, wr2;               //
wire           rd1, rd2;               //
wire           salu;                   //
wire           rd_end;                 //
wire           ad_rd;                  // external AD pins read enable
wire           alu_wr;                 // ALU write result
wire           brd_wq;                 // buffer data register write from Q-bus
wire           brd_wa;                 // buffer data register write from ALU
wire           to_clr;                 // not assert internal to_rply
                                       //
wire           pli_req;                // interrupt module query
wire           pli_ack;                // interrupt module ack
wire           pli_rclr;               //
wire           sd_word;                //
reg            word27;                 //
reg            sm0, sm1, sm2, sm3;     // interrupt module strobes
reg            pli6r;                  //
reg            pli8r;                  //
wire           evnt_ack;               //
wire           aclo_ack;               //
wire           tovf_ack;               //
wire  [5:0]    vsel;                   //
reg   [3:0]    vec;                    //
reg            wcpu;                   //
reg            tbit;                   //
wire           tbit_req;               //
wire           rt_req;                 //
                                       //
reg            dc_b7;                  //
wire           dc_f2;                  //
wire           dc_f8;                  //
wire           dc_i7;                  //
wire           dc_j7;                  //
wire           dc_bi;                  //
wire           dc_fl;                  //
wire           dc_aux;                 //
reg            dc_i9;                  //
reg            dc_i10;                 //
reg            dc_fb;                  //
reg            dc_rtt;                 //
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
wire  [4:1]    ea_px;                  //
reg   [4:0]    ea_ct;                  //
reg   [4:0]    ea_cb;                  //
wire  [4:0]    ea_cts;                 //
reg            ea_1t;                  //
reg            ea_1tm;                 //
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
reg            wait_vdiv;              //
reg            wait_div;               //
reg            zero_div;               //
                                       //
wire  [20:0]   ea_f;                   //
reg            ea_f0r, ea_f4r;         //
reg            ea_fn23r;               //
wire           ea_fn12;                //
wire           ea_f218;                //
wire           ea_enact, ea_ctse;      //
                                       //
wire           eas_dir;                //
wire           eas_left;               //
wire           eas_right;              //
                                       //
wire  [7:0]    rx;                     //
wire  [7:0]    ry;                     //
                                       //
reg            bra;                    //
reg            sb0, sb1;               //
wire           clr_wsta;               //
wire           ws_cend, ws_wait;       //
                                       //
reg   [8:0]    qct_ta;                 //
reg   [8:0]    qct_tb;                 //
wire  [8:0]    qct_ck;                 //
wire           tinit;                  //
wire           tout;                   //
                                       //
//______________________________________________________________________________
//
reg            br_cmdrq;               // breg read cmd request
wire           to_block;               // block timeout false reply
wire           wra;
wire           wtbt, to_rply;

//______________________________________________________________________________
//
// Removed aliases (inherited from schematics)
//
// reg            sd1;
// wire           nrs;
// wire           ea_nin;
// wire           ea_cin;
//
// assign         nrs      = acc[15];
// assign         ea_cin   = alu_cr[15];
// assign         ea_nin   = alu_fr[15];
//
// always @(*)
// begin
//    if (~bra_req & ~ir_stb)
//       sd1 <= 1'b0;
//    else
//       if (~f2 & bra_req)
//          sd1 <= 1'b1;
// end
//
//______________________________________________________________________________
//
assign pin_ad_out    = ad;
assign pin_ad_ena    = ad_oe;
assign pin_init      = init;
assign pin_dmgo      = dmgo_out;
assign pin_wrq       = wrq;
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
assign pin_clko = ~f1;
always @(negedge pin_clk)
begin
   dclo <= pin_dclo;
   f1 <= ~f2;
end

always @(posedge pin_clk)
begin
   if (dclo)            // this code provides
      f2 <= 1'b0;       // correct phase relation
   else                 // f2 starts after f1
      f2 <= f1;
end

assign init = init_out | dclo;
always @(*)
begin
   if (reset | tout)
      init_out <= 1'b0;
   else
      if (pi_stb & plm[13])
         init_out <= 1'b1;
end

always @(*)
begin
   if (f1) aclo <= pin_aclo;

   if (reset)
      ac0 <= 1'b0;
   else
      if (sm2)
         ac0 <= pli[3];
end

assign reset = dclo | (~ac0 & aclo_stb);
assign mc_res = abort | reset;
//______________________________________________________________________________
//
// Interrupt inputs
//
always @(*)
begin
   //
   // This is strange behaviour:
   // INIT does not reset EVNT if latch is active
   //
   if (~pli_req)
      evnt <= pin_evnt;
   else
      if (init) evnt <= 1'b0;

   if (~pli_req) halt <= pin_halt;
   if (~pli_req) virq <= pin_virq;
   if (~((ac0 & pli_req) | (~ac0 & f1))) aclo_stb <= aclo;
end

//______________________________________________________________________________
//
always @(negedge f1) dmr <= pin_dmr;
always @(*) if (f1) waki <= pin_waki;
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
//
// Window access request 160000..163777
//
assign win_req = wra & (~ax[11] | (~rd2 & ~x[11]))
                     & (~ax[12] | (~rd2 & ~x[12]))
                     & ( ay[13] | (~rd2 &  x[13]))
                     & ( ay[14] | (~rd2 &  x[14]))
                     & ( ay[15] | (~rd2 &  x[15]));
always @(*)
begin
   if (mc_res)
      wrq <= 1'b0;
   else
      if (~f1 & waki)
         wrq <= 1'b0;
      else
         if (win_req & ~waki)
            wrq <= 1'b1;
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
always @(negedge f1) iako_out <= iop_iak & din;
always @(*)
begin
   if (iako_out)
      vec_stb <= 1'b1;
   else
      if (f1 & ~iako_out)
         vec_stb <= 1'b0;
end

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

assign sync_set   = bus_free & adr_req & ~wrq;
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
   if (mc_res | to_block | (sync & ~ardy_s0))
      adr_req <= 1'b0;
   else
      if (wra)
         adr_req <= 1'b1;
end

assign to_rply = ~to_clr & ~word27 & tevent & io_qto;
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
assign io_iak     =  plr[24] & plr[23] & plr[22] & plr[21];
assign io_sel     =  plr[24] & ~io_iak & ~io_x001 & plr[21];
assign io_alt     = ~plr[24] & ~io_rcd & ~io_x001 & plr[21];
assign io_wr      = (io_x001 & ~dc_mop1) | (~io_rcd & ~io_iak & plr[23]);
assign io_rd      = (io_x001 & ~dc_mop0) | plr[22];
assign io_in      = io_rcd | (io_rd & ~io_cmd);
assign io_cmd     = ~plr[24] &         & plr[22] & ~plr[21];
assign io_rcd     = ~plr[24] & plr[23] & plr[22] &  plr[21];
assign io_rcd1    = ra_fr2 & na1w;
assign io_x001    = ~plr[23] & ~plr[22] & plr[21];

assign dout_set   = ~dout_clr & bus_dat;
assign din_set    = ~din_clr &  iop_rd & ~rplys & ~rply3;
assign wtbt       = ~din_clr & ~iop_rd & iop_wr;

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
assign qct_ck[0]  = tena & ~f1;
assign qct_ck[1]  = tena & qct_ta[0];
assign qct_ck[2]  = qct_ck[1] & qct_tb[1];
assign qct_ck[3]  = qct_ck[2] & qct_tb[2];
assign qct_ck[4]  = qct_ck[3] & qct_tb[3];
assign qct_ck[5]  = qct_ck[4] & qct_tb[4];
assign qct_ck[6]  = qct_ck[5] & qct_tb[5];
assign qct_ck[7]  = qct_ck[6] & qct_tb[6];
assign qct_ck[8]  = qct_ck[7] & qct_tb[7];
assign tout  = qct_ta[0] & qct_tb[2] & qct_tb[4] & qct_tb[5];
assign tinit = qct_tb[8] & qct_ck[8];

always @(*)
begin
   if (!tena)
      begin
         qct_ta <= 9'o000;
         qct_tb <= 9'o000;
      end
   else
   begin
      if (qct_ck[0]) qct_ta[0] <= ~qct_tb[0];
      if (qct_ck[1]) qct_ta[1] <= ~qct_tb[1];
      if (qct_ck[2]) qct_ta[2] <= ~qct_tb[2];
      if (qct_ck[3]) qct_ta[3] <= ~qct_tb[3];
      if (qct_ck[4]) qct_ta[4] <= ~qct_tb[4];
      if (qct_ck[5]) qct_ta[5] <= ~qct_tb[5];
      if (qct_ck[6]) qct_ta[6] <= ~qct_tb[6];
      if (qct_ck[7]) qct_ta[7] <= ~qct_tb[7];
      if (qct_ck[8]) qct_ta[8] <= ~qct_tb[8];

      if (~qct_ck[0]) qct_tb[0] <= qct_ta[0];
      if (~qct_ck[1]) qct_tb[1] <= qct_ta[1];
      if (~qct_ck[2]) qct_tb[2] <= qct_ta[2];
      if (~qct_ck[3]) qct_tb[3] <= qct_ta[3];
      if (~qct_ck[4]) qct_tb[4] <= qct_ta[4];
      if (~qct_ck[5]) qct_tb[5] <= qct_ta[5];
      if (~qct_ck[6]) qct_tb[6] <= qct_ta[6];
      if (~qct_ck[7]) qct_tb[7] <= qct_ta[7];
      if (~qct_ck[8]) qct_tb[8] <= qct_ta[8];
   end
end

//______________________________________________________________________________
//
assign adr_eq  = ~acmp_en | (pc1 == areg);
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
always @(*)
begin
   if (bir_stb) breg <= ad;
   if ( ir_stb) ireg <= breg;
end

vm2_pld pld_matrix(.rq(breg), .sp(pld));

assign dc_f2 = ir_stb
             & (breg[11:9] != 3'b000)
             & ((breg[8:6] == 3'b111) | (breg[11:10] == 2'b11));

assign dc_j7 = ir_stb
             & (breg[8:6] == 3'b111)
             & (breg[14:12] != 3'b000);

assign dc_i7  = ~ir_stb | (breg[2:0] == 3'b111);
assign dc_bi  = pld[5];
assign dc_f8  = ir_stb & psw[8];
assign dc_fl  = ~dc_fb & ((ir_stb & dc_bi) | (~dc_mop0 & dc_mop1));
assign dc_aux = dc_j7 | bra | br_cmdrq;
assign alt_cnst = (~dc_fb & plm[30]) | (dc_fb & plm[30] & plm[5] & plm[6]);

always @(*)
begin
   if (ir_stb)
   begin
      dc_fb   <= ~pld[10];
      dc_mop0 <= ~pld[4];
      dc_mop1 <= ~pld[3];
      dc_rtt  <= ~pld[2];
      dc_i9   <= br[1];
      dc_i10  <= br[2];
   end
   if (wr2) dc_b7  <= (ay[15:13] == 3'b111);
end

always @(*)
begin
   if (io_cmdr)
      br_cmdrq <= 1'b0;
   else
      if (rcmd_set)
         br_cmdrq <= 1'b1;
end
//______________________________________________________________________________
//
// Main microcode state machine
//
assign mc_stb = all_rdy_t0 & all_rdy_t1;
assign pi_stb = ~plm[0] & ~all_rdy_t0 & all_rdy_t1;
assign all_rdy = ~mc_res & ~alu_nrdy & ~sta_nrdy & ~pli_nrdy & ~cmd_nrdy & ~all_rdy_t1;
always @(*)
begin
   if (mc_res)
      all_rdy_t0 <= 1'b0;
   else
      if (f1)
      begin
         if (all_rdy)
            all_rdy_t0 <=  1'b1;
         else
            if (all_rdy_t1)
               all_rdy_t0 <= 1'b0;
      end

   if (~f1)
      all_rdy_t1 <= all_rdy_t0;
end

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

//
// Instructions with two operands and sorces address mode is @PC
// For this instruction we suppress the pc2 write in source read phase
//
always @(*)
begin
   if (mc_res)
      pc2_res <= 1'b0;
   else
      if (ir_stb)
         pc2_res <= (breg[14:12] != 3'o0)    // two ops instructions
                  & (breg[14:12] != 3'o7)    //
                  & (breg[11:6] == 6'o17)    // source is @PC
                  & (breg[5:3] != 3'o6)      // not E(Rn) destination
                  & (breg[5:3] != 3'o7)      // not @E(Rn) destination
                  & (breg[2:0] != 3'o7)      // not PC related destination
                  & (VM2_CORE_FIX_PREFETCH != 0);
end

always @(*)
begin
   if (io_cmd & wra)
      br_iocmd <= 1'b0;
   else
      if (sk)
         br_iocmd <= 1'b1;
end

always @(*)
begin
   if (   reset
        | ~br_iocmd
        | buf_res
        | word27
        | (~f1 & clr_cend))
      br_ready <= 1'b0;
   else
      if (~f1 & br_iocmd & bir_stb)
         br_ready <= 1'b1;
end

assign bra_req = cmd_nrdy & br_ready;
always @(*)
begin
   if (reset)
      ir_stb <= 1'b0;
   else
      if (f1)
      begin
         if (sa1 & clr_cend)
            ir_stb <= 1'b0;
         else
            if (bra_req)
               ir_stb <= 1'b1;
      end
end

always @(*)
begin
   if (all_rdy & ~f2)
      sa1 <= 1'b1;
   else
      if (~mc_stb & ~all_rdy & ~all_rdy_t0)
         sa1 <= 1'b0;

   if (~mc_stb & ~all_rdy & ~all_rdy_t0)
      sa2 <= 1'b0;
   else
      if (f2 & sa1)
         sa2 <= 1'b1;
end

//______________________________________________________________________________
//
// Main microcode matrix
//
vm2_plm plm_matrix(.ir(ireg), .ix(ix), .ri(ri), .ia(ia), .sp(pla));
always @(*)
begin
   if (reset)
      na[0] <= 1'b1;
   else
      if (abort)
         na[0] <= 1'b0;
      else
         if (sa2)
            na[0] <= ~pla[31];

   if (mc_res)
      na[5:1] <= 5'b11111;
   else
   begin
      if (sa2)
      begin
         na[1] <= ~pla[32];
         na[2] <= ~pla[33];
         na[3] <=  pla[34];
         na[4] <=  pla[35];
         na[5] <=  pla[36];
      end
   end

   if (mc_stb)
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

      get_sta0 <= ~na[0] & pla[25] & ~pla[26];
   end

   if (mw_stb)
   begin
      na0r <= na[0];
      na1w <= na[1];
      get_state <= get_sta0;
      plm_wt[30:8] <= plm[30:8];
   end
end

assign plr[8]  = plm_wt[8];
assign plr[25] = plm_wt[25];
assign plr[26] = plm_wt[26];
assign plr[30] = plm_wt[30];

assign plr[21] = (ra_fr & en_alu) ? ~plm[21] : ~plm_wt[21];
assign plr[22] = (ra_fr & en_alu) ? ~plm[22] : ~plm_wt[22];
assign plr[23] = (ra_fr & en_alu) ? ~plm[23] : ~plm_wt[23];
assign plr[24] = (ra_fr & en_alu) ? ~plm[24] : ~plm_wt[24];

assign set_cend =  na[0] & mc_stb & pla[25] & ~pla[26];
assign wt_state = ~na[0] & mc_stb & pla[25] & ~pla[26];
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

always @(*)
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
   // Interrupt acknowlegement register
   //
   if (~dc_i7)
      ri[0] <= 1'b0;
   else
      if (pi_stb)
         ri[0] <= plm[3];
      else
         if (pli_ack)
            ri[0] <= ~pli[1];

   if (dc_f8)
      ri[1] <= 1'b1;
   else
      if (pi_stb)
         ri[1] <= plm[2];
      else
         if (pli_ack)
            ri[1] <= ~pli[5];

   if (dc_f2)
      ri[2] <= 1'b1;
   else
      if (pi_stb)
         ri[2] <= plm[1];
      else
         if (pli_ack)
            ri[2] <= pli[4];
end

assign pli_ack = sm2;
assign pli_req = mc_stb &  na[1] & pla[28];
assign sd_word = mc_stb & ~na[1] & pla[28];
assign pli_rclr = sm2 & sm3;

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
vm2_pli  pli_matrix(.rq(qr), .sp(pli));

always @(*)
begin
   if (pli_req | abort)
      sm0 <= 1'b1;
   else
      if (sm3 | reset)
         sm0 <= 1'b0;

   if (~f2 & sm0 & ~abort)
      sm1 <= 1'b1;
   else
      if (~sm2 & (abort | ~sm0))
         sm1 <= 1'b0;

   if (reset | (f1 & sm3))
      sm2 <= 1'b0;
   else
      if (f1 & sm1 & ~abort & sm0)
         sm2 <= 1'b1;

   if (~f1) sm3 <= sm2;
end

always @(*)
begin
   if (init)
      qr[10]  <= 1'b0;
   else
      if (~sm1)
         if (evnt_ack)
            qr[10]  <= 1'b0;
         else
            if (evnt & evnt_fall)
               qr[10]  <= 1'b1;

   if (reset)
   begin
      qr[0]  <= 1'b0;
      qr[4]  <= 1'b0;
      qr[6]  <= 1'b0;
      qr[8]  <= 1'b0;
      qr[12] <= 1'b0;
      qr[15] <= 1'b0;
   end
   else
      if (~sm1)
      begin
         if (aclo_ack)
            qr[0]  <= 1'b0;
         else
            if (~aclo_stb & aclo_rise)
               qr[0] <= 1'b1;

         if (aclo_ack)
            qr[6]  <= 1'b0;
         else
            if (aclo_stb & aclo_fall)
               qr[6] <= 1'b1;

         if (tovf_ack)
            qr[4]  <= 1'b0;
         else
            if (tovf)
               qr[4] <= 1'b1;

         if (clr_cend)
            qr[8] <= 1'b0;
         else
            if (tovf & dble_cnt1)
               qr[8] <= 1'b1;

         qr[12] <= rt_req;
         qr[15] <= ac0;
      end

   if (~sm1)
   begin
      qr[1]  <= psw[7] & psw[8];
      qr[2]  <= 1'b0;
      qr[3]  <= halt;
      qr[5]  <= virq;
      qr[7]  <= vec_stb;
      qr[9]  <= wcpu;
      qr[11] <= tbit_req;
      qr[13] <= psw[8];
      qr[14] <= psw[7];
   end
end

always @(*)
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
      if (reset | clr_cend)
         dble_cnt0 <= 1'b0;

   if (~tovf)
      dble_cnt1 <= dble_cnt0;
   else
      if (reset)
         dble_cnt1 <= 1'b0;
end

assign tovf_ack = plm[15] & pi_stb & ~pli6r & ~pli8r;
assign aclo_ack = plm[15] & pi_stb & ~pli6r &  pli8r;
assign evnt_ack = plm[15] & pi_stb &  pli6r & ~pli8r;

assign vsel[0] = plm[8] & (vec[2:0] == 3'b000);
assign vsel[1] = plm[8] & (vec[2:0] == 3'b001);
assign vsel[2] = plm[8] & (vec[2:0] == 3'b010);
assign vsel[3] = plm[8] & (vec[2:0] == 3'b011);
assign vsel[4] = plm[8] & (vec[2:0] == 3'b100);
assign vsel[5] = plm[8] & (vec[2:0] == 3'b101);

always @(*)
begin
   if (pli_ack) pli6r <= pli[6];
   if (pli_ack) pli8r <= pli[8];

   if (pli_ack)
   begin
      vec[0] <=  pli[9];
      vec[1] <= ~pli[7];
      vec[2] <= ~pli[2];
      vec[3] <=  pli[0];
   end
   else
      if (pi_stb)
      begin
         vec[0] <= plm[20];
         vec[1] <= plm[19];
         vec[2] <= plm[18];
         vec[3] <= plm[17];
      end
end

assign tbit_req = tbit | psw[4];
assign rt_req = dc_rtt & (tbit | psw[4]);

always @(*)
begin
   if (reset | (plm[15] & pi_stb))
      tbit <= 1'b0;
   else
      if (clr_cend)
         tbit <= psw[4];
end

always @(*)
begin
   if (plm[14] & pi_stb)
      wcpu <= 1'b1;
   else
      if (reset | (plm[15] & pi_stb))
         wcpu <= 1'b0;
end

//______________________________________________________________________________
//
// QBus and INIT timer counter
//
assign pli_nrdy = tinit | tim_nrdy0 | tim_nrdy1;
assign tevent   = ~(~tout | tinit | tim_nrdy1);
assign tena     = ~reset & (pli_nrdy | din | dout);
assign tovf     = (~io_qto & tevent) | thang;

always @(*)
begin
   if (reset | pli_rclr)
      tim_nrdy0 <= 1'b0;
   else
      if (abort)
         tim_nrdy0 <= 1'b1;

   if (reset | (tinit & ~f1))
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

always @(*)
begin
   if (~sb1)
   begin
      br[0] <= breg[8];
      br[1] <= breg[9];
      br[2] <= breg[10];
      br[3] <= breg[12];
      br[4] <= breg[13];
      br[5] <= breg[14];
      br[6] <= breg[15];
      br[7] <= ~dc_b7;
   end
   if (ws_cend)
   begin
      br[8]  <= psw[0];
      br[9]  <= psw[1];
      br[10] <= psw[2];
      br[11] <= psw[3];
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
// ALU mux and constant generator
//
assign const0[0]  = {ireg[7] ? 8'o377 : 8'o000, ireg[6:0], 1'b0};
assign const0[1]  = psw[3] ? 16'o177777 : 16'o000000;
assign const0[2]  = {15'o00000, psw[0]};
assign const0[3]  = 16'o000020;
assign const0[5]  = 16'o000024;
assign const0[4]  = (vsel[0] ? 16'o000030 : 16'o000000)
                  | (vsel[1] ? 16'o000020 : 16'o000000)
                  | (vsel[2] ? 16'o000010 : 16'o000000)
                  | (vsel[3] ? 16'o000014 : 16'o000000)
                  | (vsel[4] ? 16'o000004 : 16'o000000)
                  | (vsel[5] ? 16'o000174 : 16'o000000);

assign const1[0]  = {12'o0000, ireg[3:0]};
assign const1[1]  = {9'o000, ireg[5:0], 1'b0};
assign const1[2]  = alt_cnst ? 16'o000002 : 16'o000001;
assign const1[3]  = 16'o000002;
assign const1[5]  = 16'o000004;
assign const1[4]  = (vsel[0] ? 16'o000250 : 16'o000000)
                  | (vsel[1] ? 16'o000024 : 16'o000000)
                  | (vsel[2] ? 16'o000100 : 16'o000000)
                  | (vsel[3] ? 16'o000170 : 16'o000000)
                  | (vsel[4] ? 16'o000034 : 16'o000000)
                  | (vsel[5] ? 16'o000274 : 16'o000000);

assign y       = (bir_ry               ? breg            : 16'o000000)
               | (ra_ry                ? areg            : 16'o000000)
               | (brd_ry               ? qreg            : 16'o000000)
               | (ea1_ry               ? ear1            : 16'o000000)
               | (ea2_ry               ? ear2            : 16'o000000)
               | (pc_ry                ? pc              : 16'o000000)
               | (pc1_ry               ? pc1             : 16'o000000)
               | (acc_ry               ? acc             : 16'o000000)
               | (rs_ry                ? sreg            : 16'o000000)
               | (rn_ry[0]             ? r[0]            : 16'o000000)
               | (rn_ry[1]             ? r[1]            : 16'o000000)
               | (rn_ry[2]             ? r[2]            : 16'o000000)
               | (rn_ry[3]             ? r[3]            : 16'o000000)
               | (rn_ry[4]             ? r[4]            : 16'o000000)
               | (rn_ry[5]             ? r[5]            : 16'o000000)
               | (rn_ry[6]             ? r[6]            : 16'o000000)
               | (psw_ry               ? {7'o000, psw}   : 16'o000000)
               | (cpsw_ry              ? {7'o000, cpsw}  : 16'o000000)
               | ((cn_ry0        & cn_rd[0]) ? const0[0] : 16'o000000)
               | ((cn_ry0        & cn_rd[1]) ? const0[1] : 16'o000000)
               | ((cn_ry0        & cn_rd[2]) ? const0[2] : 16'o000000)
               | ((cn_ry0        & cn_rd[3]) ? const0[3] : 16'o000000)
               | ((rd1 & ~vec[3] & cn_rd[4]) ? const0[4] : 16'o000000)
               | ((cn_ry0        & cn_rd[5]) ? const0[5] : 16'o000000)
               | ((cn_ry1        & cn_rd[0]) ? const1[0] : 16'o000000)
               | ((cn_ry1        & cn_rd[1]) ? const1[1] : 16'o000000)
               | ((cn_ry1        & cn_rd[2]) ? const1[2] : 16'o000000)
               | ((cn_ry1        & cn_rd[3]) ? const1[3] : 16'o000000)
               | ((rd1 &  vec[3] & cn_rd[4]) ? const1[4] : 16'o000000)
               | ((cn_ry1        & cn_rd[5]) ? const1[5] : 16'o000000);

assign x       = (brd_rx   ? qreg            : 16'o000000)
               | (ea1_rx   ? ear1            : 16'o000000)
               | (ea2_rx   ? ear2            : 16'o000000)
               | (pc1_rx   ? pc1             : 16'o000000)
               | (pc2_rx   ? pc2             : 16'o000000)
               | (acc_rx   ? acc             : 16'o000000)
               | (rs_rx    ? sreg            : 16'o000000)
               | (rn_rx[0] ? r[0]            : 16'o000000)
               | (rn_rx[1] ? r[1]            : 16'o000000)
               | (rn_rx[2] ? r[2]            : 16'o000000)
               | (rn_rx[3] ? r[3]            : 16'o000000)
               | (rn_rx[4] ? r[4]            : 16'o000000)
               | (rn_rx[5] ? r[5]            : 16'o000000)
               | (rn_rx[6] ? r[6]            : 16'o000000)
               | (psw_rx   ? {7'o000, psw}   : 16'o000000);

assign xbo[7:0]   = alu_xb ? xb[15:8] : xb[7:0];
assign xbo[14:8]  = alu_xb ? xb[6:0] : xb[14:8];
assign xbo[15]    = (alu_xb ? xb[7] : (xb[15] & ~sf_sum)) | (sf_sum & alu_cr[15]);

assign ay[7:0]    = (rd2 ? xbo[7:0] : 8'o000);
assign ay[15:8]   = ((sxt_rxy & (ay[7] |  sxt_y)) ? 8'o377 : 8'o000)
                  | (rd2h ? xbo[15:8] : 8'o000);

assign ax[7:0]    = (rd2 ? xbo[7:0] : 8'o000);
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
assign alu_e   =  plm[15] | ~salu;
assign alu_f   =  plm[16] | ~salu;
assign alu_g   = ~plm[15] & plm13m & (plm[17] | plm14m);
assign alu_xb  =  sf_xchg | qswp;

assign alu_cin =  alu_g & (~plm[17] | ~plm14m);
assign sh_ci1  =  nshift | (~plm1m & sh_ci2);
assign sh_ci2  =  nshift | (~plm18m & rshift);
assign sh_ci3  =  plm18m | ~lshift;

assign nshift  =  plm19m &  plm20m;
assign lshift  = ~plm19m &  plm20m;
assign rshift  =  plm19m & ~plm20m;

always @(*)
begin
   if (wr1) ea22   <= ea_mux;
   if (wr1) alu_fr <= alu_af;
   if (wr1) alu_cr <= alu_cf;
   if (wr1) xb     <= alu_sh;
end

assign eq1     = ~rd2 | (xb[15:0] == 16'o177777);
assign zl      = ~rd2 | (xb[7:0]  == 8'o000);
assign zh      = ~rd2 | (xb[15:8] == 8'o000);

assign sf_sum  = (alu_cr[14] ^ alu_cr[15]) & ea_mul & ~ea_f0r;
assign sxt_rxy = rd2 & sf_byte & ~qswp;
assign axy_wh  = ~(sxt_rxy & sxt_y);

always @(*)
if (wr1)
   begin
      sf_dir   <= nshift;
      sf_lr    <= lshift;
      sf_rr    <= rshift;
      sf_inv   <= ~plm[17] & plm14m & ~plm13m;
      sf_sub   <= ~alu_cin;
      sf_byte  <= ~plm1m;
      sf_xchg  <= plm18m & plm19m & plm20m;
      sxt_y    <= plm13m | plm14m | plm[17];
   end

assign cond_n  = sf_byte ? xb[7] : xb[15];

assign cond_z  = zl & sf_byte
               | zh & sf_xchg
               | zl & zh & ~ea_sh2 & ~ea_mul & ~sf_xchg & ~sf_byte
               | zl & zh & ea_22z & (ea_sh2 | ea_mul);

assign cond_v  = ~ea_shr
               & ~ea_mul
               & (ea_vdiv | ~ea_div)
               & (wait_vdiv | ~ea_shl)
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
always @(*)
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

      if (acc_wa) acc[15:8] <= ax[15:8];
      if (rs_wa) sreg[15:8] <= ax[15:8];
      if (pc2_wa) pc2[15:8] <= ax[15:8];
      if (ea1_wa) ear1[15:8] <= ax[15:8];
   end

   if (rn_wa[0]) r[0][7:0] <= ax[7:0];
   if (rn_wa[1]) r[1][7:0] <= ax[7:0];
   if (rn_wa[2]) r[2][7:0] <= ax[7:0];
   if (rn_wa[3]) r[3][7:0] <= ax[7:0];
   if (rn_wa[4]) r[4][7:0] <= ax[7:0];
   if (rn_wa[5]) r[5][7:0] <= ax[7:0];
   if (rn_wa[6]) r[6][7:0] <= ax[7:0];

   if (acc_wa) acc[7:0] <= ax[7:0];
   if (rs_wa) sreg[7:0] <= ax[7:0];
   if (pc2_wa) pc2[7:0] <= ax[7:0];
   if (ea1_wa) ear1[7:0] <= ax[7:0];

   if (pc1_wr) pc1 <= pc2;
   if (pc_wax)
      pc <= ax;
   else
      if (pc_wr) pc <= pc1;

   if (ea1_wa)
      ear2 <= ea22;
   else
   begin
      if (ea2_wa) ear2[7:0] <= ax[7:0];
      if (ea2_wa & axy_wh)
         ear2[15:8] <= ax[15:8];
   end
end

always @(*)
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

always @(*)
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

always @(*)
begin
   if (cpsw_wa)
   begin
      cpsw[7:0] <= ax[7:0];
      if (axy_wh)
         cpsw[8] <= ax[8];
   end
   else
      if (cpsw_stb)
         cpsw <= psw[8:0];

   if (pswt_wa) psw[4] <= ax[4];
   if (psw8_wa) psw[8] <= ax[8];
   if (psw_wa)
   begin
      psw[3:0] <= ax[3:0];
      psw[7:5] <= ax[7:5];
   end
   else
   begin
      if (pswc_stb) psw[0] <= cond_c;
      if (psw_stb)  psw[1] <= cond_v;
      if (psw_stb)  psw[2] <= cond_z;
      if (psw_stb)  psw[3] <= cond_n;
   end
end

assign rx[0]   = (plm[7:5] == 3'b000);
assign rx[1]   = (plm[7:5] == 3'b100);
assign rx[2]   = (plm[7:5] == 3'b010);
assign rx[3]   = (plm[7:5] == 3'b110);
assign rx[4]   = (plm[7:5] == 3'b001);
assign rx[5]   = (plm[7:5] == 3'b101);
assign rx[6]   = (plm[7:5] == 3'b011);
assign rx[7]   = (plm[7:5] == 3'b111);

assign ry[0]   = (plm[12:10] == 3'b000);
assign ry[1]   = (plm[12:10] == 3'b100);
assign ry[2]   = (plm[12:10] == 3'b010);
assign ry[3]   = (plm[12:10] == 3'b110);
assign ry[4]   = (plm[12:10] == 3'b001);
assign ry[5]   = (plm[12:10] == 3'b101);
assign ry[6]   = (plm[12:10] == 3'b011);
assign ry[7]   = (plm[12:10] == 3'b111);

assign rn_wa[6:0] = (wr2 & wa_gpr) ? wa[6:0] : 7'b0000000;
assign pc_wax     =  wr2 & wa_r1;
assign pc2_was    =  wr2 & wa_gpr  & wa[7];
assign pc2_wa     =  pc2_was & ~(pc2_res & ~io_rcd & ~io_cmd);
assign acc_wa     =  wr2 & wa_reg  & wa[5];
assign rs_wa      =  wr2 & wa_reg  & wa[3];
assign ra_wa      =  wr2 & ra_fw;
assign ra_wx      =  alu_wr & ra_fr;
assign wra        =  (ra_wx | ra_wa) & ~to_block
                  & (plr[21] | plr[22] | plr[23])
                  & (~dc_mop0 | ~dc_mop1 | ~io_x001);

assign rn_rx[6:0] = (rd1 & rx_gpr) ? rx[6:0] : 7'b0000000;
assign pc1_rx     =  rd1 & ~ra_fr1 & rx_gpr & rx[7];
assign pc2_rx     =  rd1 &  ra_fr1 & rx_gpr & rx[7];
assign brd_rx     =  rd1 &           rx_reg & rx[7];
assign acc_rx     =  rd1 &           rx_reg & rx[5];
assign rs_rx      =  rd1 &           rx_reg & rx[3];

assign rn_ry[6:0] = (rd1 & ry_gpr) ? ry[6:0] : 7'b0000000;
assign pc_ry      =  rd1 & rd_reg  &  plm[9];
assign cpsw_ry    =  rd1 & rd_reg  & ~plm[9] & ~plm[12];
assign bir_ry     =  rd1 & rd_reg  & ~plm[9] &  plm[12];
assign pc1_ry     =  rd1 & ry_gpr  & ry[7];
assign brd_ry     =  rd1 & ry_reg  & ry[7];
assign ra_ry      =  rd1 & ry_reg  & ry[6];
assign acc_ry     =  rd1 & ry_reg  & ry[5];
assign rs_ry      =  rd1 & ry_reg  & ry[3];

assign rd_reg     =  plm[8] & plm[10] & plm[11];
assign wa_r1      =  plm_rn[4] &  plm_rn[3];
assign wa_r2      =  plm_rn[4] & ~plm_rn[3] & ~plm_rn[0];
assign wa_gpr     = ~plm_rn[3] & ~wa_r2;
assign wa_reg     =  plm_rn[3] & ~wa_r1;

assign cpsw_wa    = wr2 &   wa_r2;
assign ea1_wa     = wr2 &   wa_reg & wa[0];
assign ea2_wa     = wr2 &   wa_reg & wa[1];
assign ea_ctld    = wr2 &   wa_reg & wa[2];
assign psw_wa     = wr2 &   wa_reg & wa[4];
assign psw8_wa    = wr2 &   wa_reg & wa[4] & ~sf_byte;
assign pswt_wa    = wr2 & ((wa_reg & wa[4] &  sf_byte & ~na0r) | psw8_wa);
assign brd_wa     = wr2 &   wa_reg & wa[7];
assign psw_stb    = wr2 &  ~plr[25];
assign pswc_stb   = wr2 &  ~plr[25] & ~plr[26];
assign wr_psw     = psw_stb | (psw_wa & ~plr[8]);
assign cpsw_stb   = (~psw[7] | ~psw[8]) & ((wr_psw & ~io_pswr) | (dout_clr & io_pswr));
assign pc_wr      = cpsw_stb | (pc1_wr & (~psw[7] | ~psw[8]) & (io_wr | (~sync_clw & ~io_pswr)));
assign pc1_wr     = (wr2 & wa_gpr & wa[7] & ~io_rcdr) | word27 | (wr1 & io_rcdr & ~iopc_st[1]);

assign ea1_rx     = rd1 & rx_reg & rx[0];
assign ea1_ry     = rd1 & ry_reg & ry[0];
assign ea2_rx     = rd1 & rx_reg & rx[1];
assign ea2_ry     = rd1 & ry_reg & ry[1];
assign psw_rx     = rd1 & rx_reg & rx[4];
assign psw_ry     = rd1 & ry_reg & ry[4];

assign rx_reg     =  plm[4];
assign rx_gpr     = ~plm[4];
assign ry_reg     = ~plm[8] &  plm[9];
assign ry_gpr     = ~plm[8] & ~plm[9];

assign wa[0]      = (plm_rn[2:0] == 3'b000);
assign wa[1]      = (plm_rn[2:0] == 3'b001);
assign wa[2]      = (plm_rn[2:0] == 3'b010);
assign wa[3]      = (plm_rn[2:0] == 3'b011);
assign wa[4]      = (plm_rn[2:0] == 3'b100);
assign wa[5]      = (plm_rn[2:0] == 3'b101);
assign wa[6]      = (plm_rn[2:0] == 3'b110);
assign wa[7]      = (plm_rn[2:0] == 3'b111);

assign cn_ry0     = rd1 & plm[8] &  plm[9];
assign cn_ry1     = rd1 & plm[8] & ~plm[9];
assign cn_rd[0]   = ry[0] & plm[8];
assign cn_rd[1]   = ry[1] & plm[8];
assign cn_rd[2]   = ry[2] & plm[8];
assign cn_rd[3]   = ry[3] & plm[8];
assign cn_rd[4]   = ry[4] & plm[8] & plm[9];
assign cn_rd[5]   = ry[5] & plm[8];

assign qswp       = wa[7] & wa_reg & qa0;
assign rd2h       = rd2 & (qswp | ~sf_byte);

always @(*)
begin
   if (mw_stb) plm_rn[4] <= rd_reg & ~plm[29] & ~plm[2] & ~plm[3];

   if (mw_stb & ~plm[29] & plm[3])     // store in to accumulator
         plm_rn[3:0] <= 4'b1101;       // in write result phase
   else
      if (mw_stb & (plm[29] | ~plm[3]))
      begin
         plm_rn[0] <= (plm[29] & plm[7]) | (~plm[29] & ~plm[2] & ~plm[3] & plm[12]);
         plm_rn[1] <= (plm[29] & plm[6]) | (~plm[29] & ~plm[2] & ~plm[3] & plm[11]);
         plm_rn[2] <= (plm[29] & plm[5]) | (~plm[29] & ~plm[2] & ~plm[3] & plm[10]);
         plm_rn[3] <= (plm[29] & plm[4]) | (~plm[29] & ~plm[2] & ~plm[3] & plm[9]);
      end
end

always @(*) if (mw_stb) ra_fw <= ra_fwn;
assign ra_fwn = plm[2] & plm[3];
assign ra_fr  =  ra_fr1 | (plm[2] & ~plm[3]);
assign ra_fr1 = ~plm[2] & plm[3] & plm[29];
always @(*) if (mw_stb) ra_fr2 <= ra_fr1;
always @(*) if (wr2) wr7 <= wa_gpr & wa[7] & ~ra_fr2;

//______________________________________________________________________________
//
// Extended arithmetics processing unit
//
assign ea_enact   = ~ea_ctld & ea_nrdy;
assign ea_ctse    = ~acc[5] | ~dc_i10;
assign ea_22z     = ~rd2 | (ea22 == 16'o000000);
assign ea_shr2    = ea_sh2 & acc[5];
assign ea_shr     = ea_nrdy &  acc[5] & dc_i10;
assign ea_shl     = ea_nrdy & ~acc[5] & dc_i10;
assign ea_sh2     = ea_nrdy &  dc_i9 &  dc_i10;
assign ea_div     = ea_nrdy &  dc_i9 & ~dc_i10;
assign ea_mul     = ea_nrdy & ~dc_i9 & ~dc_i10;
assign sh_cin     = (ea_shl | ea_div) ? ear2[15] : psw[0];
assign ea_vdiv    = zero_div
                  | (ea_mxinr ^ alu_fr[15] ^ alu_cr[15])
                  | (ea_mxinr ^ tlz ^ acc[15]);

assign eas_dir    = nshift & ~(ea_div & ea_f[3]);
assign eas_left   = lshift |  (ea_div & ea_f[3]);
assign eas_right  = rshift;

assign ea_px[1]   = (ea_ct[4:1] == 4'b0000);
assign ea_px[2]   = (ea_ct[3:0] == 4'b0010);
assign ea_px[3]   = (ea_ct[3:0] == 4'b0011);
assign ea_px[4]   = (ea_ct[3:0] == 4'b0100);

assign ea_f[0]    = ea_px[1] & ~ea_ct[0];
assign ea_f[1]    = ea_px[1] &  ea_ct[0];
assign ea_f[2]    = ea_px[2] & ~ea_ct[4];
assign ea_f[3]    = ea_px[3] & ~ea_ct[4];
assign ea_f[4]    = (ea_ct == 5'b00100);
assign ea_f[19]   = ea_px[3] &  ea_ct[4];
assign ea_f[20]   = ea_px[4] &  ea_ct[4];

assign ea_fn12    = ea_f[2] | ea_f[1];
assign ea_f218    = ~ea_f[19] & ~ea_f[20] & ~ea_f[0] & ~ea_f[1];
always @(*)
begin
   if (wr1) ea_20r   <= ear2[0];
   if (wr1) ea_fn23r <= ea_f[3] | ea_f[2];
   if (wr1) ea_1tm   <= ea_1t;
   if (wr1) ea_f0r   <= ea_f[0];
   if (ea_ctld)
      ea_f4r <= 1'b0;
   else
      if (wr1) ea_f4r <= ea_f[4];
end

assign ea_mop0    = ea_div  & ((ea_f[0] & (tlz ? ~(acc[15] ^ wait_div) : ~acc[15])) | (ea_fn12 & ~wait_div));
assign ea_mop1    = ea_muls & ((ea_f[0] & ~acc[15]) | (~ea_f[0] & ~ear2[0]));

assign ea_cts[0]  = wr2 | ~ea_enact;
assign ea_cts[1]  = wr2 & (ea_ctld | ea_cb[0]);
assign ea_cts[2]  = wr2 & (ea_ctld | ea_cb[1]) & ea_cts[1];
assign ea_cts[3]  = wr2 & (ea_ctld | ea_cb[2]) & ea_cts[2];
assign ea_cts[4]  = wr2 & (ea_ctld | ea_cb[3]) & ea_cts[3];

always @(*)
begin
   if (ea_ctld)
   begin
      ea_cb[4:0] <= ea_ctse ? ax[4:0] : ~ay[4:0];
      ea_ct[4:0] <= ea_cb[4:0];
   end
   else
   begin
      if (ea_cts[0])
         ea_ct[0] <= ea_cb[0];
      else
         ea_cb[0] <= ~ea_ct[0];

      if (ea_cts[1])
         ea_ct[1] <= ea_cb[1];
      else
         ea_cb[1] <= ~ea_ct[1];

      if (ea_cts[2])
         ea_ct[2] <= ea_cb[2];
      else
         ea_cb[2] <= ~ea_ct[2];

      if (ea_cts[3])
         ea_ct[3] <= ea_cb[3];
      else
         ea_cb[3] <= ~ea_ct[3];

      if (ea_cts[4])
         ea_ct[4] <= ea_cb[4];
      else
         ea_cb[4] <= ~ea_ct[4];
   end
end

always @(*)
begin
   if (wr2 & ea_fn23r) wait_div <= ~cond_z;
   if (wr2 & ea_1tm)  zero_div <= cond_z;
   if (wr1 & ea_1t) tlz <= ear1[15];

   if (rd2 & ~ea_1t & (tlz ^ xb[15]))
      wait_vdiv <= 1'b1;
   else
      if (ea_1t)
         wait_vdiv <= 1'b0;


   if (ea_ctld)
      ea_1t <= 1'b1;
   else
      if (wr2)
         ea_1t <= 1'b0;
end

assign ea_mxin = ~ea_shl & ~(alu_af[15] ^ acc[15]);
always @(*) if (wr1 & ea_f[19]) ea_mxinr <= ea_mxin;

assign ea_muls       = ea_mul & ea_trdy1;
assign ea_rdy        = ea_trdy0 & (~ea_trdy1 | ea_f[0] | ~dc_i10);
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

assign en_rd      = alu_st[0];
assign salu       = alu_st[3];
assign rd_end     = alu_st[1] &  alu_st[2];
assign alu_wr     = alu_st[1] & ~alu_st[2] & ea_rdy;
assign wr2        = alu_st[2] & ~alu_st[1];
assign wr1        = alu_st[4] & ~alu_st[5];
assign mw_stb     = alu_st[3] & ~alu_st[4];
assign rd2        = alu_st[5] & ~alu_st[3];
assign rd1        = wr1 | en_rd;
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
   if (mc_res)
      alu_st[3] <= 1'b0;
   else
      if (f2)
         alu_st[3] <= alu_st[0] & ~alu_st[4];

   if (~f2) alu_st[4] <= alu_st[3];
   if ( f2) alu_st[5] <= alu_st[4];
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
      if (~tevent)
         io_qto <= 1'b1;
end

assign thang      = ~iocmd_st[2] & iocmd_st[5];
assign abort      = iocmd_st[0] | iocmd_st[1] | (tevent & ~io_qto);
assign to_block   = thang | (io_rcd1 & iocmd_st[5]);
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
endmodule
