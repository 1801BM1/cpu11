//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Wishbone compatible version of 1801VM2 processor
// has 2 dedicated wishbone interfaces:
//    - master interface, on this one VM2 core performs addressed I/O, the address
//      most significant bit is for sel (high means access to halt mode space)
//    - interrupt vector interface for interrupt acknowlegement and
//      unaddressed read access (wbi_una_o tag is high)
//
module vm2_wb
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
   VM2_CORE_FIX_PREFETCH = 1
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
                                 // adr MSB is halt mode flag
   input          wbm_gnt_i,     // master wishbone granted
   output         wbm_ios_o,     // master wishbone I/O select
   output [16:0]  wbm_adr_o,     // master wishbone address
   output [15:0]  wbm_dat_o,     // master wishbone data output
   input  [15:0]  wbm_dat_i,     // master wishbone data input
   output         wbm_cyc_o,     // master wishbone cycle
   output         wbm_we_o,      // master wishbone direction
   output [1:0]   wbm_sel_o,     // master wishbone byte selection
   output         wbm_stb_o,     // master wishbone strobe
   input          wbm_ack_i,     // master wishbone acknowledgement
                                 //
   input  [15:0]  wbi_dat_i,     // interrupt vector input
   input          wbi_ack_i,     // interrupt vector acknowledgement
   output         wbi_stb_o,     // interrupt vector strobe
   output         wbi_una_o      // unaddressed read access
);

//______________________________________________________________________________
//
reg            virq, halt, evnt;       // interrupt requests
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
reg            sel;                    //
wire           init;                   //
reg            init_out;               //
reg            adr_req;                //
reg            drdy;                   //
reg            rdat;                   //
                                       //
wire           io_start;               // start IO transaction
wire           io_rdy;                 //
wire           io_in;                  // prefetch cmd & read data
wire           io_wr;                  //
wire           io_rd;                  //
wire           io_sel;                 //
wire           io_wri;                 //
wire           io_iak;                 //
wire           io_alt;                 //
wire           io_x001;                //
wire           io_rcd;                 //
reg            io_rcd1;                //
wire           io_rcd1_xt;             //
wire           io_cmd;                 //
reg            io_cmdr;                //
reg            io_rcdr;                //
reg            io_pswr;                //
                                       //
reg            iop_in;                 // prefetch cmd & read data
reg            iop_rcd;                // prefetch cmd
reg            iop_una;                // unaddressed access
wire           iop_stb;                // IO opcode strobe
reg            iop_sta;                //
                                       //
wire           reset;                  // system reset
wire           abort;                  // abort by bus timeout
wire           mc_res;                 // microcode reset
reg            mc_stb;                 // mc read phase strobe
wire           pi_stb_rc;              // peripheral strobe
reg            pi_stb;                 //
wire           all_rdy;                //
reg            alu_nrdy;               // ALU not ready
reg            sta_nrdy;               // branch state not ready
reg            cmd_nrdy;               // instruction completion
wire           pli_nrdy;               // interrupt polling not ready
reg            tim_nrdy0;              // wait abort exception status
reg            tim_nrdy1;              // wait nINIT pulse generation
wire           mc_rdy_rc;              //
reg            br_iocmd;               // instruction read IO in progress
reg            br_ready;               // breg contains valid read instruction
reg            ir_stb;                 //
wire           bir_stb;                //
wire           bra_req;                //
wire           mdfy;                   // write modifies prefetched location
wire           tena;                   // Q-bus timer count enable
wire           tovf;                   // Q-bus timeout interrupt
wire           thang;                  // prefetch was timed out
                                       //
reg            rta_fall;               //
wire           creq;                   //
reg            get_state;              //
wire           wt_state_rc;            //
wire           set_cend_rc;            //
reg            set_cend;               // set command end flag
reg            acmp_en;                // PC address comparator enable
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
wire  [5:0]    na_rc;                  //
reg   [5:0]    na;                     // microcode next address field
reg   [30:0]   plm;                    // main matrix result register (first stage)
reg   [30:21]  plm_wt;                 //
wire  [30:21]  plr;                    //
wire  [36:0]   pla;                    //
                                       //
reg   [4:0]    plm_rn;                 //
wire  [6:0]    rn_wa;                  //
wire           pc2_wa;                 //
wire           wa_pc;                  // program counter selected
wire           wa_r1, wa_r2;           //
wire           ra_wa;                  // write address register from X*-bus
wire           ra_wx;                  // write address register from X-bus
reg            ra_fw;                  //
wire           ra_fwn;                 //
wire           ra_fr, ra_fr1;          //
wire           ra_fr_rc, ra_fwn_rc;    //
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
wire           qswp, rd2h;             //
reg            qa0;                    //
reg            wr7;                    // read command start cycle
                                       //
reg   [15:0]   cmux;                   // constant generator multiplexer
wire  [3:0]    csel;                   // constant generator selector
reg   [7:0]    vmux;                   // vector generator multiplexer
wire  [3:0]    vsel;                   // vector generator selector
                                       //
reg   [15:0]   ea22;                   // extended arithmetics register 2.2
reg   [15:0]   ear1;                   // extended arithmetics register 1
reg   [15:0]   ear2;                   // extended arithmetics register 2
reg   [15:0]   acc;                    // accumulator
reg   [15:0]   sreg;                   // source register
reg   [15:0]   r[6:0];                 // general purpose register files
reg   [15:0]   pc2;                    // prefetch PC pointer
reg   [15:0]   pc1;                    // actual PC pointer
reg   [15:0]   cpc;                    // copy of PC saved for halt mode
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
wire           en_alu_rc;              //
wire           mc_drdy_rc;             //
reg            mc_drdy0, mc_drdy1;     //
reg   [1:0]    alu_st;                 // ALU state machine
reg   [5:0]    iocmd_st;               //
reg   [1:0]    iopc_st;                //
reg   [5:1]    io_st;                  //
reg            buf_res;                //
reg            pc2_res;                // ignore pc2 write
wire           wr1;                    // ALU read args phase strobe
wire           wr2;                    // ALU write result phase strobe
wire           alu_wr;                 // ALU write result
wire           brd_wq;                 // buffer data register write from Q-bus
wire           brd_wa;                 // buffer data register write from ALU
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
reg            dc_iord;                //
reg            dc_iowr;                //
wire           alt_cnst;               //
                                       //
reg            ea_nrdy;                // EA unit internal operations
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
reg            ea_trdy2_clr;           //
                                       //
reg            tlz;                    //
reg            wait_div;               //
reg            zero_div;               //
reg            div_vfr;                // sticky division overflow flag
wire           div_vf;                 // result division overflow flag
                                       //
reg   [4:0]    ea_ct;                  // internal EA phase counter
wire  [4:0]    ea_cta;                 //
reg            ea_1tm, ea_1tc;         // first cycle after counter load
reg  [20:0]    ea_f;                   // counter phases
reg            ea_f0r, ea_f4r;         //
reg            ea_fn23r;               //
reg            ea_fn12;                //
reg            ea_f218;                //
wire           ea_ctse;                //
                                       //
wire           eas_dir;                //
wire           eas_left;               //
wire           eas_right;              //
                                       //
reg            bra;                    //
reg            bra_stb;                //
wire           ws_cend, ws_wait;       //
                                       //
reg   [8:0]    qtim;                   // Q-bus/nINIT timer counter
reg            tend;                   // Q-bus/nINIT timer counting end pulse
reg            tabort;                 // Q-bus false reply strobe
reg            tevent;                 // Q-bus timeout exception request
wire           tout;                   // Q-bus/nINIT timer 1/64 pulses
                                       //
reg            br_cmdrq;               // breg read cmd request
wire           to_block;               // block false reply on timeout
wire           wra;                    //
reg            to_rply;                //
                                       //
//______________________________________________________________________________
//
reg   [16:0]   wb_adr;                 // Wishbone master output address
reg   [15:0]   wb_dat;                 // Wishbone master input data
                                       //
wire           wb_start;               //
wire           wb_wclr, wb_wset;       //
reg            wb_swait;               //
reg   [5:0]    wb_wcnt;                //
                                       //
reg            wb_cyc;                 //
reg            wb_stb;                 //
reg            wb_we;                  //
reg   [1:0]    wb_sel;                 //
reg            wb_una;                 //
reg            wb_iak;                 //
wire           wb_wdone,               //
               wb_rdone,               //
               wb_idone;               //
wire           wb_done;                //
                                       //
wire           wio_ia_rc, wio_ia,      // interrupt acknowledgement
               wio_ua_rc, wio_ua,      // unaddressed read
               wio_wr_rc, wio_wr,      // write operation
               wio_rd_rc, wio_rd,      // read operation
               wio_wo_rc, wio_wo,      // word operation
               wio_dc_rc;              // decoded IO operations
                                       //
reg            wio_ia_xt,              //
               wio_ua_xt,              //
               wio_wr_xt,              //
               wio_rd_xt,              //
               wio_wo_xt;              //
//______________________________________________________________________________
//
// Reset and phase clock generator
//
assign init = init_out | vm_dclo;
assign vm_init = init;

always @(posedge vm_clk_p)
begin
   if (reset | tout)
      init_out <= 1'b0;
   else
      if (pi_stb & plm[13])
         init_out <= 1'b1;
end

always @(posedge vm_clk_p)
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

assign reset = vm_dclo | (~ac0 & vm_aclo);
assign mc_res = abort | reset;
//______________________________________________________________________________
//
// Interrupt inputs latches
//
always @(posedge vm_clk_p)
begin
   evnt <= vm_evnt & ~init;
   halt <= vm_halt;
   virq <= vm_virq;
end

//______________________________________________________________________________
//
// QBus state machine
//
assign creq = wb_cyc | adr_req;

always @(posedge vm_clk_p)
begin
   if (iop_sta | mc_res)
      rta_fall <= 1'b0;
   else
      if (wra)
         rta_fall <= 1'b1;
end

always @(posedge vm_clk_n)
begin
   if (mc_res | to_block | iop_sta)
      adr_req <= 1'b0;
   else
      if (wra)
         adr_req <= 1'b1;
end

always @(posedge vm_clk_n) to_rply <= iop_rcd & ~word27 & tabort & ~to_rply;

assign io_iak  = (plr[24:21] == 4'b1111);    // Interrupt acknowlegement
assign io_sel  = (plr[24:21] == 4'b1011)     // Unaddressed read
               | (plr[24:21] == 4'b1101);    //
assign io_rcd  = (plr[24:21] == 4'b0111);    // Read command ahead
assign io_cmd  = (plr[24:21] == 4'b0010)     // Read command
               | (plr[24:21] == 4'b0110);    //
assign io_wri  = (plr[24:21] == 4'b0100)     // Write data
               | (plr[24:21] == 4'b0101);    // Write alt data
assign io_alt  = (plr[24:21] == 4'b0011)     // Read alternating space
               | (plr[24:21] == 4'b0101);    // Write alternating space
assign io_x001 = (plr[24:21] == 4'b0001)     // Operation is defined
               | (plr[24:21] == 4'b1001);    // by dc_mop field

assign io_wr   = (io_x001 & dc_iowr) | io_wri;
assign io_rd   = (io_x001 & dc_iord) | plr[22];
assign io_in   = io_rcd | (io_rd & ~io_cmd);

assign io_rcd1_xt = ra_fr1 & na[1];
always @(posedge vm_clk_p) if (wr1) iop_una <= io_iak | io_sel;
always @(posedge vm_clk_n) if (wr2) io_rcd1 <= io_rcd1_xt;

always @(posedge vm_clk_p)
begin
   if (iop_stb)
      iop_in <= io_in;

   if (to_rply)
      iop_rcd <= 1'b0;
   else
      if (iop_stb)
         iop_rcd <= io_rcd;
end

always @(posedge vm_clk_p)
begin
   if (wb_done)
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

always @(posedge vm_clk_n)
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
   //
   // Q-bus false reply strobe
   //
   if (!tena | tabort | tend)
      tabort <= 1'b0;
   else
      tabort <= ~tim_nrdy1 & qtim[0] & qtim[1] & qtim[4] & qtim[5];
end

always @(posedge vm_clk_p)
   tevent <= tabort & (~iop_rcd | word27);

//______________________________________________________________________________
//
// QBus and INIT timer counter
//
assign tena     = ~reset & (pli_nrdy | (wbm_stb_o & wbm_gnt_i) | wbi_stb_o);
assign tovf     = tevent | thang;
assign pli_nrdy = tend | tim_nrdy0 | tim_nrdy1;

always @(posedge vm_clk_p)
begin
   //
   // tim_nrdy0 is used to stop mcu for waiting
   // Q-bus abort exception status from interrupt unit
   //
   if (reset | pli_arq & ~abort)
      tim_nrdy0 <= 1'b0;
   else
      if (abort)
         tim_nrdy0 <= 1'b1;
end

always @(posedge vm_clk_n)
begin
   //
   // tim_nrdy1 is used to stop mcu for waiting
   // nINIT pusle generating completion
   //
   if (reset | tend)
      tim_nrdy1 <= 1'b0;
   else
      if (pi_stb & plm[13])
         tim_nrdy1 <= 1'b1;
end

//______________________________________________________________________________
//
assign mdfy = acmp_en & (pc1 == areg);
always @(posedge vm_clk_p) acmp_en <= wra & io_wr;

always @(posedge vm_clk_n) if (alu_wr) io_rcdr <= io_rcd;
always @(posedge vm_clk_n) if (alu_wr) io_cmdr <= io_cmd;
always @(posedge vm_clk_p)
begin
   if (mc_res | wb_wdone)
      io_pswr <= 1'b0;
   else
      if (wra & io_wr & ~na[0])
         io_pswr <= 1'b1;
end

//______________________________________________________________________________
//
// Instruction registers - primary and preliminary decoder
//
always @(posedge vm_clk_p)
begin
   if (bir_stb) breg <= wb_dat;
   if (ir_stb)
   begin
      ireg <= breg;
      dc_iord <= pld[4];
      dc_iowr <= pld[3];
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
assign dc_fl  = (ir_stb ? pld[10] : ~dc_fb) & ((ir_stb & dc_bi) | (dc_iord & ~dc_iowr));
assign dc_aux = dc_j7 | br_cmdrq;
assign alt_cnst = (~dc_fb & plm[30]) | (dc_fb & plm[30] & plm[5] & plm[6]);


always @(posedge vm_clk_p)
begin
   if (ir_stb) dc_fb <= ~pld[10];
   if (wr2) dc_b7 <= (ax[15:13] == 3'b111);
end

always @(posedge vm_clk_n)
begin
   if (io_cmdr | (alu_wr & io_cmd))
      br_cmdrq <= 1'b0;
   else
      if (rcmd_set)
         br_cmdrq <= 1'b1;
end

//______________________________________________________________________________
//
// Main microcode state machine
//
assign pi_stb_rc  = ~pla[0] & mc_stb;
always @(posedge vm_clk_p) pi_stb <= pi_stb_rc;
assign all_rdy    = ~mc_res & ~alu_nrdy & (~sta_nrdy | bra_stb)
                  & ~pli_nrdy & ~cmd_nrdy & ~mc_stb;

always @(posedge vm_clk_p) mc_stb <= all_rdy;
always @(posedge vm_clk_n)
begin
   if (mc_res | pi_stb | alu_wr)
      alu_nrdy <= 1'b0;
   else
      if (mc_stb)
         alu_nrdy <= 1'b1;
end

assign mc_rdy_rc  = alu_nrdy & (mc_stb ? pla[0] : plm[0]);
always @(posedge vm_clk_p) set_cend <= set_cend_rc;
always @(posedge vm_clk_n) cmd_nrdy <= ~mc_res & ~ir_stb & (set_cend | cmd_nrdy);
always @(posedge vm_clk_p) sta_nrdy <= ~mc_res & ~bra_stb & (sta_nrdy | wt_state_rc);

//______________________________________________________________________________
//
always @(posedge vm_clk_n)
begin
   if (io_cmd & wra)
      br_iocmd <= 1'b0;
   else
      if (iop_sta)
         br_iocmd <= 1'b1;
end

always @(posedge vm_clk_n)
begin
   if (   reset
        | ~br_iocmd
        | buf_res
        | word27
        | ir_stb)
      br_ready <= 1'b0;
   else
      if (br_iocmd & bir_stb)
         br_ready <= 1'b1;
end

assign bra_req = br_ready & (cmd_nrdy | set_cend_rc & ~ir_stb & ~mc_res);
always @(posedge vm_clk_p)
begin
   if (reset)
      ir_stb <= 1'b0;
   else
      begin
         if (mc_stb & ir_stb)
            ir_stb <= 1'b0;
         else
            if (bra_req)
               ir_stb <= 1'b1;
      end
end

//______________________________________________________________________________
//
// Instructions with two operands and source address mode is @PC
// For this instruction we suppress the pc2 write in source read phase
//
always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p)
begin
   if (reset)
      na[0] <= 1'b1;
   else
      if (abort)
         na[0] <= 1'b0;
      else
         if (mc_stb)
            na[0] <= ~pla[31];

   if (mc_res)
      na[5:1] <= 5'b11111;
   else
      if (mc_stb)
      begin
         na[1] <= ~pla[32];
         na[2] <= ~pla[33];
         na[3] <=  pla[34];
         na[4] <=  pla[35];
         na[5] <=  pla[36];
      end
end

always @(posedge vm_clk_p)
if (wr1)
      plm_wt[30:21] <= plm[30:21];

always @(posedge vm_clk_p)
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
   end

assign plr[21] = wr1 ? ~plm[21] : ~plm_wt[21];
assign plr[22] = wr1 ? ~plm[22] : ~plm_wt[22];
assign plr[23] = wr1 ? ~plm[23] : ~plm_wt[23];
assign plr[24] = wr1 ? ~plm[24] : ~plm_wt[24];
assign plr[30] = wr1 ?  plm[30] :  plm_wt[30];

assign set_cend_rc = mc_stb &  na_rc[0] & pla[25] & ~pla[26];
assign wt_state_rc = mc_stb & ~na_rc[0] & pla[25] & ~pla[26];
//
// ALU operation is modifiable from extended arithmetics unit
//
assign plm1m   = plm[1] | (~plm[25] & ~dc_fb);
assign plm18m  = plm[18] | (~ea_1tc & ea_sh2 & ea_shl);
assign plm19m  = plm[19] & ( ea_1tc | ~ea_shl);
assign plm20m  = plm[20] & ~ea_shr;
assign plm13m  = plm[13] & ~ea_mop0 & ~ea_mop1 & (~ea_div | ~ea_f[1] | (tlz ^ ear1[15]));
assign plm14m  = plm[14]
               & (~acc[15] | ~ea_mul | ~ea_f[0])
               & ((tlz ^ acc[15]) | ~ea_div | ~ea_f[19])
               & (~(tlz ^ ear1[15]) | ~ea_f[1] | ~ea_div | ea_mop0 | (acc[15] ^ ear1[15]))
               & (~ea_div | ea_mop0 | ~ea_f218 | ~ear2[0]);


always @(posedge vm_clk_p)
begin
   //
   // Current microinstruction address latch
   //    - direct branch from preliminary decoder
   //    - next address field
   //
   if (~mc_stb)
      if (ir_stb)
         ia <= {pld[0], pld[8], pld[7], ~pld[6], ~pld[9], ~pld[11]};
      else
         ia <= na;
   //
   // Auxiliary conditions register
   //
   if (~mc_stb) ix[0] <= dc_fl;
   if (~mc_stb) ix[1] <= dc_aux | (bra_stb ? ~plb : bra);
   if (ir_stb) ix[2] <= dc_bi;
   //
   // Interrupt query register
   //
   if (ir_stb & ~dc_i7)
      ri[0] <= 1'b0;
   else
      if (pi_stb)
         ri[0] <= plm[3];
      else
         if (pli_ack)
            ri[0] <= ~pli[1];

   if (ir_stb & psw[8])
      ri[1] <= 1'b1;
   else
      if (pi_stb)
         ri[1] <= plm[2];
      else
         if (pli_ack)
            ri[1] <= ~pli[5];

   if (ir_stb & dc_f2)
      ri[2] <= 1'b1;
   else
      if (pi_stb)
         ri[2] <= plm[1];
      else
         if (pli_ack)
            ri[2] <= pli[4];
end

assign pli_req = mc_stb &  na_rc[1] & pla[28];
assign sd_word = mc_stb & ~na_rc[1] & pla[28];

always @(posedge vm_clk_p)
begin
   if (sd_word)
      word27 <= 1'b1;
   else
      if (mc_res | (wr1 & plm[27]))
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
assign qri[13] = psw[8];            // halt mode flag
assign qri[14] = psw[7];            // interrupt disable flag
assign qri[15] = ac0;               // wait initial nACLO rise

//______________________________________________________________________________
//
// External pin assignments
//
always @(posedge vm_clk_p)
begin
   pli_arq <= abort;
   pli_ack <= ~reset & (pli_arq & ~abort | pli_req);
end

always @(posedge vm_clk_p)
begin
   vec_stb <= wbi_stb_o & ~wbi_una_o;
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
            if (~vm_aclo & aclo_rise)
               acok_rq <= 1'b1;

         if (aclo_ack)
            aclo_rq <= 1'b0;
         else
            if (vm_aclo & aclo_fall)
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

always @(posedge vm_clk_p)
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
   if (~vm_aclo)
      aclo_fall <= 1'b1;
   else
      if (reset | aclo_ack)
         aclo_fall <= 1'b0;
   //
   // nACLO rising edge detector
   //
   if (vm_aclo)
      aclo_rise <= 1'b1;
   else
      if (vm_dclo | aclo_ack)
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

assign tovf_ack = pi_stb & plm[15] & ~pli6r & ~pli8r;
assign aclo_ack = pi_stb & plm[15] & ~pli6r &  pli8r;
assign evnt_ack = pi_stb & plm[15] &  pli6r & ~pli8r;
assign vsel[3:0]  = pli_ack ?
                  {pli[0], ~pli[2], ~pli[7], pli[9]} :
                  {plm[17], plm[18], plm[19], plm[20]};

always @(posedge vm_clk_p)
begin
   if (pli_ack | pi_stb)
      case(vsel)
         4'b0000: vmux <= 8'o030;
         4'b0001: vmux <= 8'o020;
         4'b0010: vmux <= 8'o010;
         4'b0011: vmux <= 8'o014;
         4'b0100: vmux <= 8'o004;
         4'b0101: vmux <= 8'o174;
         4'b0110: vmux <= 8'o000;
         4'b0111: vmux <= 8'o000;
         4'b1000: vmux <= 8'o250;
         4'b1001: vmux <= 8'o024;
         4'b1010: vmux <= 8'o100;
         4'b1011: vmux <= 8'o170;
         4'b1100: vmux <= 8'o034;
         4'b1101: vmux <= 8'o274;
         4'b1110: vmux <= 8'o000;
         4'b1111: vmux <= 8'o000;
         default: vmux <= 8'o000;
      endcase

   if (pli_ack)
      begin
         pli6r <= pli[6];
         pli8r <= pli[8];
      end
end

always @(posedge vm_clk_p)
begin
   if (reset | (plm[15] & pi_stb))
      tbit <= 1'b0;
   else
      if (ir_stb)
         tbit <= psw[4];
end

always @(posedge vm_clk_p)
begin
   if (plm[14] & pi_stb)
      wcpu <= 1'b1;
   else
      if (reset | (plm[15] & pi_stb))
         wcpu <= 1'b0;
end

//______________________________________________________________________________
//
// Branch processing unit
//
vm2_plb  plb_matrix(.rq({na[5], na[4], br}), .sp(plb));

always @(posedge vm_clk_p)
begin
   br[0] <= bir_stb ? wb_dat[8]  : breg[8];
   br[1] <= bir_stb ? wb_dat[9]  : breg[9];
   br[2] <= bir_stb ? wb_dat[10] : breg[10];
   br[3] <= bir_stb ? wb_dat[12] : breg[12];
   br[4] <= bir_stb ? wb_dat[13] : breg[13];
   br[5] <= bir_stb ? wb_dat[14] : breg[14];
   br[6] <= bir_stb ? wb_dat[15] : breg[15];
   br[7] <= ~(wr2 ? (ax[15:13] == 3'b111) : dc_b7);
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

assign ws_cend  = ~sta_nrdy;
assign ws_wait  =  sta_nrdy & wr2;

always @(posedge vm_clk_p)
begin
   if (wr1)
      get_state <= ~na[0] & plm[25] & ~plm[26];
   bra_stb <= bra_req | (wr2 & get_state);

   if (mc_res | mc_stb)
      bra <= 1'b0;
   else
      if (bra_stb & ~plb)
         bra <= 1'b1;
end

//______________________________________________________________________________
//
// Y bus constant and vector generator
//
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
   4'b1100: cmux = {8'o000, vmux};
   4'b1101: cmux = 16'o000024;
   4'b1110: cmux = cpc;                // PC copy access instead const
   4'b1111: cmux = cpc;                // PC copy access instead const
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
   4'b0111: x = (ra_fr1 | word27 & wr1) ? pc2 : pc1;
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

always @(posedge vm_clk_p)
if (wr1)
   begin
      ea22   <= ea_mux;
      alu_fr <= alu_af;
      alu_cr <= alu_cf;
      xb     <= alu_sh;
   end

assign eq1     = (xb[15:0] == 16'o177777);
assign zl      = (xb[7:0]  == 8'o000);
assign zh      = (xb[15:8] == 8'o000);

assign sf_sum  = (alu_cr[14] ^ alu_cr[15]) & ea_mul & ~ea_f0r;
assign axy_wh  = ~(sxt_rxy & sxt_y);
assign qswp    = (plm_rn[4:0] == 5'b01111) & qa0;
assign rd2h    = qswp | ~sf_byte;
assign sxt_rxy = ~qswp & sf_byte;

always @(posedge vm_clk_p)
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
always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p)
begin
   //
   // Write can happen in the same clock for all pc2->pc1->cpc
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
      cpc <= ax;
   else
      if (pc_wr)
      begin
         cpc[7:0] <= pc1_wr ? (pc2_wa ? ax[7:0] : pc2[7:0]) : pc1[7:0];
         cpc[15:8] <= pc1_wr ?
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

always @(posedge vm_clk_p)
begin
   if (ra_wa)
      areg[15:0] <= ax[15:0];
   else
      if (ra_wx)
         areg <= x;

   if (wra)
      sel <= psw[8] ^ io_alt;
   else
      if (mc_res)
         sel <= 1'b1;
end

always @(posedge vm_clk_p)
begin
   if (brd_wa)
   begin
      qreg[7:0] <= ax[7:0];
      if (axy_wh)
         qreg[15:8] <= ax[15:8];
   end
   else
      if (brd_wq)
         qreg  <= qa0 ? {8'o000, wb_dat[15:8]} : wb_dat;
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

always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p)
begin
   if (pswt_wa) psw[4] <= ax[4];
   if (psw_wa) psw[7:5] <= ax[7:5];
   if (psw8_wa) psw[8] <= ax[8];
end

always @(posedge vm_clk_p)
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
always @(posedge vm_clk_p)
if (wr1)
begin
   //
   // Register (breg, cpsw, cpc) is accessed on Y bus, not constant
   //
   plm_rn[4] <= plm[8]  & plm[10] &  plm[11]
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

assign ra_fwn     = plm[2] & plm[3];
assign ra_fwn_rc  = mc_stb ? (~pla[2] & ~pla[3]) : ra_fwn;
assign ra_fr      = ra_fr1 | (plm[2] & ~plm[3]);
assign ra_fr_rc   = mc_stb ? (pla[2] & ~pla[3] & pla[29]) | (~pla[2] & pla[3]) : ra_fr;
assign ra_fr1     = ~plm[2] & plm[3] & plm[29];
always @(posedge vm_clk_p) if (wr2) wr7 <= wa_pc & ~ra_fr1;

assign wa_r1      = plm_rn[4] &  plm_rn[3];
assign wa_r2      = plm_rn[4] & ~plm_rn[3] & ~plm_rn[0];
assign wa_pc      = (plm_rn[3:0] == 4'b0111);

assign cpsw_wa    = wr2 & wa_r2;
assign ea1_wa     = wr2 & (plm_rn[4:0] == 5'b01000);
assign ea2_wa     = wr2 & (plm_rn[4:0] == 5'b01001);
assign ea_ctld    = wr2 & (plm_rn[4:0] == 5'b01010);
assign rs_wa      = wr2 & (plm_rn[4:0] == 5'b01011);
assign psw_wa     = wr2 & (plm_rn[4:0] == 5'b01100);
assign psw8_wa    = wr2 & (plm_rn[4:0] == 5'b01100) &  ~sf_byte;
assign pswt_wa    = wr2 & (plm_rn[4:0] == 5'b01100) & (~sf_byte | (sf_byte & ~na[0]));
assign acc_wa     = wr2 & (plm_rn[4:0] == 5'b01101);
assign brd_wa     = wr2 & (plm_rn[4:0] == 5'b01111);

assign psw_stb    = wr2 & ~plm[25];
assign pswc_stb   = wr2 & ~plm[25] & ~plm[26];
assign wr_psw     = psw_stb | (psw_wa & ~plm[8]);
assign cpsw_stb   = (~psw[7] | ~psw[8]) & ((wr_psw & ~io_pswr) | (wb_wdone & io_pswr));
assign pc_wr      = cpsw_stb | (pc1_wr & (~psw[7] | ~psw[8]) & (io_wr | ~io_pswr));
assign pc1_wr     = (wr2 & wa_pc & ~io_rcdr) | word27 | (wr1 & io_rcdr & ~iopc_st[1]);

assign pc_wax     = wr2 & wa_r1;
assign pc2_wa     = wr2 & wa_pc & ~(pc2_res & ~io_rcd & ~io_cmd);

assign ra_wa      = wr2 & ra_fw;
assign ra_wx      = alu_wr & ra_fr;
assign wra        = (ra_wx | ra_wa) & ~to_block
                  & (plr[21] | plr[22] | plr[23])
                  & (dc_iord | dc_iowr | ~io_x001);

assign rn_wa[0]   = wr2 & (plm_rn[4:0] == 5'b00000);
assign rn_wa[1]   = wr2 & (plm_rn[4:0] == 5'b00001);
assign rn_wa[2]   = wr2 & (plm_rn[4:0] == 5'b00010);
assign rn_wa[3]   = wr2 & (plm_rn[4:0] == 5'b00011);
assign rn_wa[4]   = wr2 & (plm_rn[4:0] == 5'b00100);
assign rn_wa[5]   = wr2 & (plm_rn[4:0] == 5'b00101);
assign rn_wa[6]   = wr2 & (plm_rn[4:0] == 5'b00110);

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

assign ea_mop0    = ea_div & ((ea_f[0] & (tlz ? ~(acc[15] ^ wait_div) : ~acc[15])) | (ea_fn12 & ~wait_div));
assign ea_mop1    = ea_mul & ((ea_f[0] & ~acc[15]) | (~ea_f[0] & ~ear2[0]));
//
// Extended aritmetics internal phase counter,
// decremented every wr2 write cycle
//
always @(posedge vm_clk_p) ea_ct <= ea_cta;
assign ea_cta = ea_ctld ? (ea_ctse ? ax[4:0] : ~ax[4:0]) :
                          ((wr2 & ea_nrdy) ? (ea_ct - 5'b00001) : ea_ct);
//
// The first cycle after EA counter load (ea_ctld)
//
always @(posedge vm_clk_p) if (wr2) ea_1tc <= ea_ctld;
always @(posedge vm_clk_p) if (wr1) ea_1tm <= ea_1tc;

always @(posedge vm_clk_p)
begin
   ea_f[0]  <= (ea_cta == 5'b00000);
   ea_f[1]  <= (ea_cta == 5'b00001);
   ea_f[2]  <= (ea_cta == 5'b00010);
   ea_f[3]  <= (ea_cta == 5'b00011);
   ea_f[4]  <= (ea_cta == 5'b00100);
   ea_f[19] <= (ea_cta == 5'b10011);
   ea_f[20] <= (ea_cta == 5'b10100);

   ea_fn12  <= (ea_cta == 5'b00010) | (ea_cta == 5'b00001);
   ea_f218  <= ~(ea_cta == 5'b10011) & ~(ea_cta == 5'b10100) &
               ~(ea_cta == 5'b00000) & ~(ea_cta == 5'b00001);
end

always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p)
begin
   if (wr2 & ea_fn23r) wait_div <= ~cond_z;
   if (wr2 & ea_1tm)  zero_div <= cond_z;
   if (wr1 & ea_1tc) tlz <= ear1[15];
end

//
// Sticky DIV overflow (V) flag
// Check and store V on every division cycle
//
always @(posedge vm_clk_p)
begin
   if (~ea_ctld & ~(ea_1tc & wr1) & (tlz ^ xb[15]))
      div_vfr <= 1'b1;
   else
      if (ea_ctld)
         div_vfr <= 1'b0;
end
assign div_vf = div_vfr | (tlz ^ xb[15]);

assign ea_mxin = ~ea_shl & ~(alu_af[15] ^ acc[15]);
always @(posedge vm_clk_p) if (wr1 & ea_f[19]) ea_mxinr <= ea_mxin;

assign ea_muls       = ea_ctld & ~ireg[9] & ~ireg[10];
assign ea_rdy        = (ea_trdy0 | ea_trdy0_set) & (~ea_trdy1 | ea_f[0] | ~ireg[10]);
assign ea_trdy0_set  = mc_res | (~wr2 & ((ea_div & ea_f[4]) | (ea_f[1] & (ea_div | ea_mul))));
assign ea_trdy0_clr  = wr2 & (ea_muls | (ea_div & (ea_1tm | ea_f4r)));
assign ea_trdy1_clr  = wr2 & ~ea_ctld & ea_trdy1 & ea_f0r;
always @(posedge vm_clk_n) ea_trdy2_clr <= ea_trdy1_clr;

always @(posedge vm_clk_n)
begin
   if (ea_trdy0_set)
      ea_trdy0 = 1'b1;
   else
      if (ea_trdy0_clr)
         ea_trdy0 = 1'b0;
end

always @(posedge vm_clk_n)
begin
   if (mc_res | ea_trdy1_clr)
      ea_trdy1 <= 1'b0;
   else
      if (ea_ctld)
         ea_trdy1 <= 1'b1;
end

always @(posedge vm_clk_p)
begin
   if (mc_res | ea_trdy2_clr)
      ea_nrdy <= 1'b0;
   else
      if (ea_ctld)
         ea_nrdy <= 1'b1;
end

//______________________________________________________________________________
//
// ALU state machine
//
assign en_alu_rc  = ~alu_st[0]
                  & ((mc_drdy_rc & mc_rdy_rc & io_rdy) | ~ea_rdy)
                  & ((~ra_fr_rc & ~ra_fwn_rc) | (iop_sta | ~rta_fall))
                  | (~ac0 & ~alu_st[0] & mc_stb);

assign alu_wr     = alu_st[0] & ea_rdy;
assign wr1        = alu_st[0];
assign wr2        = alu_st[1];

//
// Internal to_rply is asserted only for prefetch transactions
//
assign bir_stb    = rdat & (~iop_in | iop_rcd);
assign brd_wq     = rdat & ( iop_in | iop_rcd);
assign io_start   = wra | (wr2 & iop_una);

always @(posedge vm_clk_p) alu_st[0] <= en_alu_rc & ~mc_res;
always @(posedge vm_clk_p) alu_st[1] <= alu_st[0] & ~mc_res;

always @(posedge vm_clk_n)
begin
   if (alu_wr)
   begin
      if (word27 | io_cmd)
         iopc_st[0] <= 1'b1;
      else
         if (io_rcd)
            iopc_st[0] <= 1'b0;
   end
   else
   begin
      if (word27 | io_cmdr)
         iopc_st[0] <= 1'b1;
      else
         if (io_rcdr)
            iopc_st[0] <= 1'b0;
   end

   if (alu_wr)
   begin
      if (io_cmd)
         iopc_st[1] <= 1'b1;
      else
         if (~io_rcd)
            iopc_st[1] <= iopc_st[0] | word27 | io_cmd;
   end
   else
   begin
      if (io_cmdr)
         iopc_st[1] <= 1'b1;
      else
         if (~io_rcdr)
            iopc_st[1] <= iopc_st[0] | word27 | io_cmdr;
   end
end

assign mc_drdy_rc = (mc_stb ? pla[27] : ~plm[27]) | mc_drdy1;
always @(posedge vm_clk_n)
begin
   if (iop_sta)
      mc_drdy0 <= 1'b0;
   else
      if (io_start & io_in)
         mc_drdy0 <= 1'b1;

   if (mc_res | ((mc_drdy0 | (io_start & io_in)) & ~iop_sta))
      mc_drdy1 <= 1'b0;
   else
      if (brd_wq)
         mc_drdy1 <= 1'b1;
end

assign io_rdy  = ~io_st[2] | ~io_st[4];
assign iop_stb = (io_st[2] & ~io_st[3] & io_st[5]) | (~io_st[1] & io_start);

always @(posedge vm_clk_p)
begin
   if (mc_res | (wb_done & ~io_st[2]))
      io_st[1] <= 1'b0;
   else
      if (io_start)
         io_st[1] <= 1'b1;

   if (wb_done)
      io_st[3] <= 1'b0;
   else
      if (~io_st[4])
         io_st[3] <= 1'b1;

   io_st[5] <= io_st[4];
end

always @(posedge vm_clk_n)
begin
   if (mc_res | (~io_st[4] & ~io_st[5]))
      io_st[2] <= 1'b0;
   else
      if (io_start & io_st[1])
         io_st[2] <= 1'b1;

   io_st[4] <= io_st[3];
end

assign thang      = ~iocmd_st[2] & iocmd_st[5];
assign abort      = iocmd_st[0] | tevent;
assign to_block   = thang | (io_rcd1 & iocmd_st[5]);
assign rcmd_set   = thang | (buf_res & iocmd_st[4]);

always @(posedge vm_clk_p)
begin
   if (reset)
      iocmd_st[0] <= 1'b0;
   else
      begin
         if (iocmd_st[2] & ~iocmd_st[4])
            iocmd_st[0] <= 1'b0;
         else
            if (rcmd_set)
               iocmd_st[0] <= 1'b1;
      end
end

always @(posedge vm_clk_n)
begin
   iocmd_st[1] <= iocmd_st[0];

   if (wr2 | iocmd_st[0])
      iocmd_st[2] <= 1'b1;
   else
      if (word27 & alu_wr)
         iocmd_st[2] <= 1'b0;

   if (wr2 & io_rcd1_xt)
      iocmd_st[3] <= 1'b1;
   else
      if (~io_rcd1_xt | iocmd_st[0])
         iocmd_st[3] <= 1'b0;
end

always @(negedge iocmd_st[3] or posedge vm_clk_n)
begin
   if (!iocmd_st[3])
      iocmd_st[4] <= 1'b0;
   else
      if (~creq)
         iocmd_st[4] <= 1'b1;
end

always @(posedge vm_clk_p)
begin
   if (wr7 | reset)
      iocmd_st[5] <= 1'b0;
   else
      if (to_rply)
         iocmd_st[5] <= 1'b1;
   //
   // Instruction buffer ready reset
   // We are writing to the prefetched location
   // and should drop prefetched instruction
   //
   if (wr7 | reset)
      buf_res <= 1'b0;
   else
      if (mdfy | to_rply)
         buf_res <= 1'b1;
end

//______________________________________________________________________________
//
// Wishbone master and interrupt interfaces
//
assign wb_start   = (~wb_wset & iop_stb)
                  | (wb_wclr & wb_swait);
assign wb_wdone   = wb_stb & wbm_ack_i &  wb_we;
assign wb_rdone   = wb_stb & (wbm_ack_i | to_rply) & ~wb_we;
assign wb_idone   = wb_iak & wbi_ack_i;
assign wb_done    = mc_res | wb_idone | wb_wdone | (wb_rdone & ~wio_wr_xt);


assign wbm_adr_o  = iop_sta ? {sel, areg[15:0]} : wb_adr;
assign wbm_ios_o  = iop_sta ? &areg[15:13] : &wb_adr[15:13];
assign wbm_dat_o  = qreg;
assign wbm_cyc_o  = wb_cyc;
assign wbm_we_o   = wb_we;
assign wbm_sel_o  = wb_sel;
assign wbm_stb_o  = wb_stb;
assign wbi_stb_o  = wb_iak;
assign wbi_una_o  = wb_una;

assign wio_dc_rc  = (plr[24:21] == 4'b0001)     // operation is defined
                  | (plr[24:21] == 4'b1001);    // by dc_mop field
assign wio_ia_rc  = (plr[24:21] == 4'b1111);    // interrupt acknowlegement
assign wio_ua_rc  = (plr[24:21] == 4'b1011)     // unaddressed read
                  | (plr[24:21] == 4'b1101);    //
assign wio_wr_rc  = (plr[24:21] == 4'b0100)     // write data
                  | (plr[24:21] == 4'b0101)     // write alt data
                  | (wio_dc_rc & dc_iowr);      //
assign wio_rd_rc  = (plr[24:21] == 4'b0111)     // read command ahead
                  | (plr[24:21] == 4'b0010)     // read command
                  | (plr[24:21] == 4'b0110)     //
                  | (plr[24:21] == 4'b1110)     // read-modify-write
                  | (plr[24:21] == 4'b1010)     // read data
                  | (plr[24:21] == 4'b0011)     // Read alternating space
                  | (wio_dc_rc & dc_iord);      //
assign wio_wo_rc  = ~dc_fb | ~plr[30];          // word operation (16-bit)

assign wio_ia = iop_stb ? wio_ia_rc : wio_ia_xt;
assign wio_ua = iop_stb ? wio_ua_rc : wio_ua_xt;
assign wio_wr = iop_stb ? wio_wr_rc : wio_wr_xt;
assign wio_rd = iop_stb ? wio_rd_rc : wio_rd_xt;
assign wio_wo = iop_stb ? wio_wo_rc : wio_wo_xt;

assign wb_wset    = iop_stb & vm_clk_slow & (wb_wcnt != 6'o00);
assign wb_wclr    = reset | ~vm_clk_slow | (vm_clk_ena & (wb_wcnt == 6'o01));

always @(posedge vm_clk_p)
begin
   iop_sta <= iop_stb;
   if (iop_sta)
   begin
      //
      // Store the operation address
      //
      wb_adr[15:0] <= areg[15:0];
      wb_adr[16]   <= sel;
      qa0 <= areg[0] & ~wio_wo_xt & (wio_rd_xt | wio_wr_xt);
   end

   if (wb_wclr)
      wb_swait <= 1'b0;
   else
      if (wb_wset)
         wb_swait <= 1'b1;

   if (reset)
      wb_wcnt <= 6'o00;
   else
      if (wb_swait)
      begin
         if (vm_clk_ena | ~vm_clk_slow)
            wb_wcnt <= wb_wcnt - 6'o01;
      end
      else
      begin
         if (~vm_clk_ena & vm_clk_slow & (wb_wcnt != 6'o77))
            wb_wcnt <= wb_wcnt + 6'o01;
      end

   if (iop_stb)
   begin
      //
      // Store the IO operation opcode
      //
      wio_ia_xt <= wio_ia_rc;
      wio_ua_xt <= wio_ua_rc;
      wio_wr_xt <= wio_wr_rc;
      wio_rd_xt <= wio_rd_rc;
      wio_wo_xt <= wio_wo_rc;
   end
   //
   // Strobe bus data receiving registers
   //
   rdat <= wb_idone | wb_rdone;
   //
   // Store the received data in the buffer
   //
   if (wb_rdone)
      wb_dat <= wbm_dat_i;
   else
      if (wb_idone)
         wb_dat <= wbi_dat_i;

   if (mc_res)
   begin
      //
      // Master wishbone abort/reset
      //
      wb_cyc <= 1'b0;
      wb_we  <= 1'b0;
      wb_sel <= 2'b00;
      wb_stb <= 1'b0;
      wb_iak <= 1'b0;
      wb_una <= 1'b0;
   end
   else
      if (wb_start)
      begin
         //
         // Start master bus read/read-modify write transaction
         //
         if (wio_rd)
         begin
            wb_cyc <= 1'b1;
            wb_we  <= 1'b0;
            wb_sel <= 2'b11;
            wb_stb <= 1'b1;
         end
         if (wio_wr & ~wio_rd)
         begin
            wb_cyc <= 1'b1;
            wb_we  <= 1'b1;
         end
         if (wio_ia | wio_ua)
         begin
            wb_iak <= 1'b1;
            wb_una <= wio_ua;
         end
      end
      else
      begin
         if (wb_wdone | (~wio_wr & wb_rdone))
         begin
            //
            // Write or single read completion
            //
            wb_cyc <= 1'b0;
            wb_we  <= 1'b0;
            wb_sel <= 2'b00;
            wb_stb <= 1'b0;
         end
         else
            if (wb_rdone & wio_wr)
            begin
               //
               // Read cycle of read-modify-write completion
               //
               wb_we  <= 1'b1;
               wb_sel <= 2'b00;
               wb_stb <= 1'b0;
            end

         if (wb_we & (drdy | brd_wa) & ~wb_wdone)
         begin
            wb_sel[0] <= wio_wo | ~wbm_adr_o[0];
            wb_sel[1] <= wio_wo |  wbm_adr_o[0];
            wb_stb <= 1'b1;
         end
         if (wb_idone)
         begin
            wb_iak <= 1'b0;
            wb_una <= 1'b0;
         end
      end
end
//______________________________________________________________________________
//
endmodule
