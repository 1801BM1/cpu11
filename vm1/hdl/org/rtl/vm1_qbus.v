//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Optimizations done:
//    - plr18r is replaced by plr[18]
//    - plr33r is replaced by plr[33]
//    - ustb2 is equal to ~au_alsl
//    - dout_start uses rply_ack[3] instead of rply_ack[1]
//
//______________________________________________________________________________
//
// Version of 1801VM1 processor with Q-bus external interface
// All external signal transitions should be synchronzed with pin_clk
// The core does not contain any extra metastability eliminators itself
//
module vm1_qbus
#(parameter
//______________________________________________________________________________
//
// VM1 version select - VM1A or VM1G. VM1G contains another version of
// microcode, supports VE timer interrupt and MUL operation.
//
   VM1_CORE_MULG_VERSION = 1
)
(
   input          pin_clk,       // processor clock
   input  [1:0]   pin_pa,        // processor number
   input          pin_init_in,   // peripheral reset input
   output         pin_init_out,  // peripheral reset output
                                 //
   input          pin_dclo,      // processor reset
   input          pin_aclo,      // power fail notificaton
   input  [3:1]   pin_irq,       // radial interrupt requests
   input          pin_virq,      // vectored interrupt request
                                 //
   input  [15:0]  pin_ad_in,     // data bus input
   output [15:0]  pin_ad_out,    // address/data bus output
   output         pin_ad_ena,    // address/data bus enable
                                 //
   input          pin_dout_in,   // data output strobe input
   output         pin_dout_out,  // data output strobe output
   input          pin_din_in,    // data input strobe input
   output         pin_din_out,   // data input strobe output
   output         pin_wtbt,      // write/byte status
   output         pin_ctrl_ena,  // enable control outputs
                                 //
   input          pin_sync_in,   // address strobe input
   output         pin_sync_out,  // address strobe output
   output         pin_sync_ena,  // address strobe enable
                                 //
   input          pin_rply_in,   // transaction reply input
   output         pin_rply_out,  // transaction reply output
                                 //
   input          pin_dmr_in,    // bus request shared line
   output         pin_dmr_out,   //
                                 //
   input          pin_sack_in,   // bus acknowlegement
   output         pin_sack_out,  // bus acknowlegement
                                 //
   input          pin_dmgi,      // bus granted input
   output         pin_dmgo,      // bus granted output
   output         pin_iako,      // interrupt vector input
   input          pin_sp,        // peripheral timer input
   output [2:1]   pin_sel,       // register select outputs
   output         pin_bsy        // bus busy flag
);

//______________________________________________________________________________
//
wire           slk;              //
wire  [33:0]   plx,plx_a,plx_g;  // main microcode matrix output
reg   [33:0]   plr;              // main matrix result register (last stage)
reg   [33:0]   plm;              // main matrix result register (first stage)
reg   [14:0]   mj;               // microcode stage and condition register
reg   [14:0]   ma;               // microcode matrix address register
reg   [15:0]   ir;               // instruction register (last stage)
reg   [15:0]   ira;              // instruction register (first stage)
                                 //
wire  [10:0]   pli,pli_a,pli_g;  // interrupt priority encode matrix output
reg   [19:0]   rq;               // interrupt request register
reg            aclo;             // ACLO falling edge detectors
reg            acok;             // ACLO raising edge detectors
reg            irq2;             // IRQ2 falling edge detectors
reg            irq3;             // IRQ3 falling edge detectors
reg            uop;              // undefined operation latch
reg            oat;              // odd address trap latch
reg            ivto;             // IAKO bus timeout latch
reg            start_irq;        // raised by 1777x2 register write
reg            exc_uop;          //
wire           exc_err2;         //
wire           exc_err3;         //
reg            qbus_tovf;        //
wire           exc_oat;          //
wire           exc_err7;         //
reg   [3:0]    exc_dbl;          // double error detector
wire           tve_irq;          // VE-timer interrupt request (vm1a_pli ignores)
wire           tve_ack;          // VE-timer interrupt acknowledgement
                                 //
wire           uop_ack;          // undefined instruction
wire           aclo_ack;         // ACLO timer acknowlegement
wire           irq2_ack;         // IRQ2 timer acknowlegement
wire           irq3_ack;         // IRQ3 timer acknowlegement
reg   [3:0]    vsel;             // vector selection register
reg   [3:0]    plir;             // pli[10:8:6:4] outputs latch
                                 //
wire           ir_stb1;          //
reg            ir_stb2;          // instruction register strobe
wire           ir_clr;           //
reg            ir_set;           //
reg            ir_stop;          //
reg   [3:0]    ir_seq;           //
                                 //
wire           pli_nrdy;         // interrupt matrix not ready
wire           pli_stb;          // priority encoder result strobe
reg            pli_ena;          // priority encoder pre-strobe
reg            pli_lat;          //
reg            pli_ena_h;        //
reg            pli_stb_h;        //
reg            pli_req;          //
wire           plm1x, plm2x;     // main matrix result strobes
reg            plm1x_hl;         //
reg            plm_stb, plm_ena; //
reg            plm_ena_hl;       //
reg   [3:0]    sop_out;          //
wire           sop_up;           //
wire  [3:0]    plm23;            //
wire  [7:0]    plop;             //
wire           uplr_stb;         //
reg            mj_stb1, mj_stb2; //
reg            psw_stb, psw_stbc;//
reg            t5843, psw_mj;    //
                                 //
reg   [3:1]    tplm;             //
reg   [3:1]    tplmz;            //
reg   [8:6]    plrt;             //
reg   [8:6]    plrtz;            //
wire           sim_reset;        // aux reset for reliable simulation
wire           reset;            //
wire           mj_res;           //
reg            mj_res_h;         //
wire           abort;            // odd address. bus hang, invalid opcode
reg   [2:0]    abtos;            // abort one-shot
                                 //
wire  [15:0]   d;                // internal data bus
wire  [15:0]   tve_d;            // timer module data output
wire           ad_rd;            // external AD pins read enable
wire           ad_oe;            // external AD pins output enable
wire           sel177x;          // peripheral block access
reg            sel_00, sel_02,   // peripheral block selectors
               sel_04, sel_06,   //
               sel_10, sel_12,   //
               sel_14, sel_16,   //
               sel_xx;           //
wire           sel_in, sel_out;  //
reg            rply_s2, rply_s3; // disable rply generation if start_irq active
reg            rply_s1;          //
reg   [5:0]    qbus_timer;       // qbus timeout counter
wire           qbus_tena;        //
                                 //
reg            dmr_req;          //
reg            dmr_req_l;        //
wire           dmr_clr;          //
wire           dmr_out;          //
wire           iako_out;         //
reg            iako_out_lh;      //
reg            iak_flag;         //
reg   [2:0]    init_out;         //
                                 //
wire           qbus_done;        //
reg            qbus_done_hl;     //
reg   [3:0]    rply_ack;         //
                                 //
reg            ctrl_oe;          //
wire           oe_set, oe_clr;   //
reg            oe_set_h,oe_clr_h;//
                                 //
wire           qbus_nrdy;        //
reg   [2:0]    qbus_seq;         //
wire           dout_done;        //
wire           dout_start;       //
reg            dout_req;         //
reg            dout_out;         //
reg            dout_out_l;       //
wire           dout_ext;         //
                                 //
wire           din_done;         //
wire           din_start;        //
reg            din_out;          //
reg            din_out_l;        //
                                 //
wire           dmgo_out;         //
wire           qbus_yield;       //
reg            dmgi_in_l;        //
reg            qbus_rmw;         //
reg            qbus_req;         //
reg            qbus_win;         //
reg            qbus_win_h;       //
reg            qbus_own;         //
reg            qbus_flag;        //
reg            sack_out;         //
reg            sync_out;         //
reg            sync_out_h;       //
reg            sync_ena;         //
wire           sync_stb;         //
wire           sync_fedge;       //
reg            qbus_nosr_h;      //
wire           qbus_gnt;         //
reg            qbus_gnt_l;       //
wire           qbus_free;        //
reg            qbus_free_h;      //
                                 //
reg            reg_csr0_h;       //
reg   [2:0]    reg_csr;          // 177700: control register
reg   [15:0]   reg_vec;          // 177702: start vector register
reg   [7:0]    reg_err;          // 177704: error register
                                 //
reg   [15:0]   psw;              // processor status word
reg   [3:0]    fsel;             //
reg   [15:0]   gpr[0:13];        // gp and special registers array
wire  [15:0]   x;                // X bus
wire  [15:0]   y;                // Y bus
wire  [15:0]   f;                // ALU function inverted output
wire  [15:0]   h;                // half summ
wire  [15:0]   c;                // carry
wire  [15:0]   cpred;            // carry form preceding but
wire           cl;               // inserted least bit carry
                                 //
wire  [1:0]    fmux;             //
wire  [3:0]    flag;             //
wire           fbit7, fbit15;    //
wire  [7:1]    fctl;             //
wire           fbitc;            //
                                 //
wire           alu_b, alu_c;     // ALU function slector
wire           alu_d, alu_e;     //
wire           alu_s, alu_x;     //
                                 //
wire  [15:0]   alu;              // ALU output to X/Y bus
wire  [15:0]   axy;              // AND product
wire  [15:0]   oxy;              // OR product
wire  [6:0]    rs0, rs1;         // register select
wire  [6:0]    rs_wr;            //
                                 //
wire           rs_ena;           //
wire           rs_ena0, rs_ena1; //
                                 //
wire           ustb0;            //
reg            ustb, ustb_h;     //
reg            ustb1, ustb1_h;   //
reg            ustb1_hl;         //
reg            alu_nrdy;         // ALU not ready
reg            alu_nrdy_h;       //
wire           alu_qrdy;         // Qbus data ready
                                 //
wire           au_rsx0, au_rsx1; // general purpose register strobes
wire           au_rsy0, au_rsy1; // general purpose register strobes
wire           au_qsx, au_qsy;   // qbus temporary register
wire           au_pswx, au_pswy; // PSW strobes
wire           au_alsl, au_alsh; // ALU result strobes
wire           au_astb, au_ard;  //
wire           au_qstbx;         //
wire           au_qstbd;         //
wire           au_is0, au_is1;   // ALU X argument strobes
wire           au_vsely;         // vector generator Y enable
wire           au_csely;         // constant generator Y enable
wire           alu_u;            // ALU Y argument strobe
wire           au_mhl0, au_mhl1; //
wire           au_dzl, au_dzh;   //
wire           au_qrdd;          //
reg            au_ta0;           //
                                 //
wire  [7:0]    mhl;              // high/low byte mux
wire  [15:0]   vcd;              // vector/constant data
wire  [15:0]   qrd;              // qbus byte swap data
wire  [15:0]   nx;               //
reg   [15:0]   qreg;             // ALU Q register (Q-bus data)
reg   [15:0]   areg;             // ALU A register (Q-bus address)
reg   [15:0]   xreg;             // ALU X parameter register
reg   [15:0]   yreg;             // ALU Y parameter register


//______________________________________________________________________________
//
// External connection assignments
//
assign slk           = pin_clk;
assign pin_init_out  = init_out[0] | reset;
assign pin_ad_out    = d;
assign pin_ad_ena    = ad_oe;
assign pin_dout_out  = dout_out & dout_out_l;
assign pin_din_out   = din_out;
assign pin_wtbt      = (sync_stb & ~plrt[8]) | (dout_ext & plrt[6]);
assign pin_sync_out  = sync_out;
assign pin_sync_ena  = sync_ena | sync_out;
assign pin_ctrl_ena  = qbus_win | ctrl_oe;
assign pin_rply_out  = (sel_in | sel_out) & (pin_rply_in | ~sel_02 | ~rply_s2);

assign pin_iako      = iako_out_lh;
assign pin_bsy       = sync_out | pin_ctrl_ena;
assign pin_dmr_out   = dmr_out;
assign pin_sack_out  = sack_out;
assign pin_dmgo      = dmgo_out;

assign pin_sel[2]    = sel_14;
assign pin_sel[1]    = sel_16;

//______________________________________________________________________________
//
// Control and glue logic
//
assign ir_clr = ~tplm[3] & ~ir_seq[1] & ~ir_seq[3];
always @(*)
begin
   if (slk)
      ir_seq[0] <= plm23[0] | plm23[3];

   if (mj_res | ir_seq[2])
      ir_seq[1] <= 1'b0;
   else
      if (ir_seq[0])
         ir_seq[1] <= 1'b1;
end
always @(posedge pin_clk)
begin
   ir_seq[2] <= (ir_seq[0] | ir_seq[1]) & ~tplm[1] & ~tplm[3];
   ir_seq[3] <= ~tplm[3] & ~ir_seq[1];
end

assign sop_up = sop_out[3] | (~sop_out[2] & ~sop_out[1]);
always @(*)
begin
   if (~slk)
      plm_ena <= ~sop_out[0] & ~alu_nrdy & ~qbus_nrdy;

   if (plm_stb)
      sop_out[0] <= 1'b0;
   else
      if (mj_res | (slk & plm_ena))
         sop_out[0] <= 1'b1;
   if (~slk)
      sop_out[1] <= sop_out[0];
   if (slk)
      sop_out[2] <= sop_out[1];

   if (slk)
      plm_stb <= ~sop_up;
   if (~slk)
      sop_out[3] <= ir_stop | pli_nrdy | ir_stb2 | mj_res_h | (alu_nrdy_h & (plop[0] | plop[4]));
end

assign ustb0   =  ustb1 | ~ustb_h;
always @(*)
begin
   if (mj_res)
      ustb <= 1'b0;
   else
      if (~slk)
      begin
         if (ustb1)
            ustb <= 1'b0;
         else
         begin
            if (alu_nrdy & alu_qrdy)
               ustb <= 1'b1;
         end
      end

   if ( slk) ustb_h   <= ustb;
   if (~slk) ustb1    <= ustb_h;
   if ( slk) ustb1_h  <= ustb1;
   if (~slk) ustb1_hl <= ustb1_h;
   if ( slk) alu_nrdy_h  <= alu_nrdy;
end

always @(*)
begin
   if (mj_res)
      alu_nrdy <= 1'b0;
   else
      if (slk)
      begin
         if (plm2x) alu_nrdy <= 1'b1;
      end
      else
         if (ustb1_h) alu_nrdy <= 1'b0;
end

assign ir_stb1 = tplm[1] | tplm[3];
always @(*)
begin
   if (mj_res | ir_clr)
      ir_stb2 <= 1'b0;
   else
      if (ir_set)
         ir_stb2 <= 1'b1;

   if (slk)
      ir_set <= plm23[0] | plm23[1] | plm23[3];
end

always @(*)
begin
   if (mj_res | ~reg_csr0_h)
      ir_stop <= 1'b0;
   else
      if (ir_clr & reg_csr[0])
         ir_stop <= 1'b1;
end

always @(*)
begin
   if (mj_res)
      tplmz <= 3'b000;
   else
      if (plm_ena)
      begin
         tplmz[1] <= (plm[3:1] == 3'b100);
         tplmz[2] <= (plm[3:1] == 3'b010);
         tplmz[3] <= (plm[3:1] == 3'b011);
      end

   if (mj_res | din_done)
      tplm <= 3'b000;
   else
      if (uplr_stb)
      begin
         if (tplmz[1]) tplm[1] <= 1'b1;
         if (tplmz[2]) tplm[2] <= 1'b1;
         if (tplmz[3]) tplm[3] <= 1'b1;
      end
end

always @(*)
begin
   if (slk)
   begin
      plrtz[6] <= plr[6];
      plrtz[7] <= plr[7] & plr[8];
      plrtz[8] <= plr[8];
   end
   if (din_done)
      plrt[8] <= 1'b0;
   else
      if (uplr_stb)
         plrt[8] <= plrtz[8];

   if (uplr_stb)
      plrt[7:6] <= plrtz[7:6];
end
//______________________________________________________________________________
//
// Qbus logic
//
always @(negedge pin_clk) qbus_done_hl <= qbus_done;
assign qbus_done  = (din_done & ~plrt[7]) | dout_done | mj_res;

always @(posedge pin_clk) iako_out_lh <= iako_out;
assign iako_out   = din_out & iak_flag;
//
// Master processor never asserts DMR_OUT
//
assign dmr_out = dmr_req & (pin_pa != 2'b00);
assign dmr_clr = ~sync_out & qbus_win_h;

always @(*)
begin
   if (~slk) rply_ack[0] <= (pin_rply_in & pin_bsy);
   if ( slk) rply_ack[1] <= rply_ack[0];
   if (~slk) rply_ack[2] <= rply_ack[1];
   if ( slk) rply_ack[3] <= rply_ack[2];
end

assign alu_qrdy = ( qbus_rmw | plr[23] | (~plr[7] & ~plr[8]))
                & (~dout_req | plr[23] | plr[7] | plr[8])
                & (plr[10] | (~tplm[2] & ~iak_flag));
always @(*)
begin
   if (uplr_stb)
      qbus_rmw <= 1'b0;
   else
      if (mj_res | sync_fedge)
         qbus_rmw <= 1'b1;
end

always @(*)
begin
   if (mj_res | dmr_clr)
      dmr_req <= 1'b0;
   else
      if (au_astb)
         dmr_req <= 1'b1;
   if (~slk)
      dmr_req_l <= dmr_req;
end

always @(*)
begin
   if (~plrt[8] & au_qstbx & (dmr_req | qbus_own))
      dout_req <= 1'b1;
   else
      if (qbus_done)
         dout_req <= 1'b0;
end

assign dout_ext   = dout_out | dout_out_l;
assign dout_done  = ~dout_start & dout_out_l;
assign dout_start = dout_req & qbus_flag & ~rply_ack[3]; // instead of ~rply_ack[1]
always @(*)
begin
   if (dout_start)
      dout_out <= 1'b1;
   else
      if (mj_res | dout_done)
         dout_out <= 1'b0;

   if (~slk)
      dout_out_l <= dout_out;
end

assign din_start = oe_set_h | (plrt[8] & sync_fedge);
assign din_done  = din_out_l & rply_ack[3];
always @(*)
begin
   if (mj_res | din_done)
      din_out <= 1'b0;
   else
      if (din_start)
         din_out <= 1'b1;

   if (~slk)
      din_out_l <= din_out;
end

assign qbus_tena = dout_out | din_out;
assign oe_clr = mj_res | (~rply_ack[0] & rply_ack[2] & ~qbus_flag);
assign oe_set = qbus_gnt_l & iak_flag & ~dmr_req & ~qbus_own;
always @(*)
begin
   if (oe_clr)
      ctrl_oe <= 1'b0;
   else
      if (oe_set)
         ctrl_oe <= 1'b1;
   if (slk)
   begin
      oe_set_h <= oe_set;
      oe_clr_h <= oe_clr;
   end
end

assign sync_stb   = qbus_win & (~sync_out_h | ~qbus_win_h);
assign sync_fedge = sync_out_h & ~sync_ena;
always @(*)
begin
   if (oe_clr)
      qbus_win <= 1'b0;
   else
      if (dmr_req_l & qbus_gnt_l)
         qbus_win <= 1'b1;

   if (slk)
      qbus_win_h <= qbus_win;
   if (~slk)
      sync_out <= qbus_win_h;
   if (slk)
      sync_out_h <= sync_out;
   if (~slk)
      sync_ena <= sync_out_h;
end

assign qbus_yield = ~ctrl_oe & ~qbus_own & (pin_pa[1:0] == 2'b00) & pin_dmr_in;
assign qbus_free  = ~(pin_dmr_in | pin_sack_in | (pin_pa[1:0] != 2'b00));
assign qbus_gnt   = (qbus_nosr_h | (sync_out_h & ~qbus_win_h))
                  & (qbus_free_h | (dmr_out & sack_out));
always @(*)
begin
   if (slk)
      qbus_free_h <= qbus_free;
   if (slk)
      qbus_nosr_h <= ~pin_rply_in & ~pin_sync_in;
   if (~slk)
      qbus_gnt_l <= qbus_gnt;
end

always @(*)
begin
   if (qbus_done)
      qbus_own <= 1'b0;
   else
      if (dmr_req_l & qbus_gnt_l)
         qbus_own <= 1'b1;
end

always @(*)
begin
   if (qbus_done)
      qbus_flag <= 1'b0;
   else
      if (sync_fedge)
         qbus_flag <= 1'b1;
end

always @(*)
begin
   if (qbus_done)
      sack_out <= 1'b0;
   else
      if (pin_dmgi & (qbus_nosr_h | (sync_out_h & ~qbus_win_h)) & qbus_req)
         sack_out <= 1'b1;
end

assign dmgo_out = qbus_yield | (~qbus_req & dmgi_in_l);
always @(*)
begin
   if (qbus_done)
      qbus_req <= 1'b0;
   else
      if (dmr_out & ~pin_dmgi)
         qbus_req <= 1'b1;

   if (~slk)
      dmgi_in_l <= pin_dmgi;
end

assign qbus_nrdy = qbus_seq[2];
assign uplr_stb  = (au_astb & ~qbus_seq[1]) | (qbus_seq[2] & oe_clr & ~oe_clr_h);
always @(*)
begin
   if (mj_res | (~qbus_seq[2] & oe_clr & ~oe_clr_h))
      qbus_seq[0] <= 1'b0;
   else
      if (au_astb)
         qbus_seq[0] <= 1'b1;

   if (~au_astb)
      qbus_seq[1] <= qbus_seq[0];

   if (mj_res | oe_clr_h)
      qbus_seq[2] <= 1'b0;
   else
      if (au_astb & qbus_seq[1])
         qbus_seq[2] <= 1'b1;
end

//______________________________________________________________________________
//
assign   d        = ((ad_rd)           ? pin_ad_in                   : 16'o000000)
                  | ((sel_in & sel_00) ? {11'o3777, pin_pa, reg_csr} : 16'o000000)
                  | ((sel_in & sel_02) ? 16'o177777                  : 16'o000000)
                  | ((sel_in & sel_04) ? {8'o377, reg_err}           : 16'o000000)
                  | ((sel_in & (sel_06 | sel_10 | sel_12)) ? tve_d   : 16'o000000)
                  | (au_ard            ? areg                        : 16'o000000)
                  | ((au_qrdd & (au_mhl0 | au_mhl1)) ? qrd           : 16'o000000);

assign   qrd      = (au_mhl0 ? (au_dzh ? {8'o000, qreg[7:0]} : qreg) : 16'o000000)
                  | (au_mhl1 ? {qreg[7:0], au_dzl ? 8'o000 : 8'o377} : 16'o000000);

assign   sel177x  = (pin_ad_in[15:6] == 10'o1777) & (pin_ad_in[5:4] == pin_pa[1:0]);
assign   sel_in   = sel_xx & pin_din_in;
assign   sel_out  = sel_xx & pin_dout_in;
assign   ad_rd    = (~sel_xx | sel_14 | sel_16 | ~pin_bsy)
                  & (sel_out | (pin_din_in & pin_bsy));
assign   ad_oe    = sync_stb | dout_ext | ~(sel_16 | sel_14 | ~sel_in);

vm1_timer   timer
(
   .tve_clk(pin_clk),
   .tve_ena(1'b1),
   .tve_reset(reset | pin_init_out | pin_init_in),
   .tve_dclo(pin_dclo),
   .tve_sp(pin_sp),
   .tve_din(d),
   .tve_dout(tve_d),
   .tve_csr_oe(sel_12 & sel_in),
   .tve_cnt_oe(sel_10 & sel_in),
   .tve_lim_oe(sel_06 & sel_in),
   .tve_csr_wr(sel_12 & sel_out),
   .tve_lim_wr(sel_06 & sel_out),
   .tve_irq(tve_irq),
   .tve_ack(tve_ack)
);
//
// Qbus timeout counter
// Timeout exception request should be synchronized with raising clk's edge
//
always @(posedge pin_clk)
begin
   qbus_tovf <= &qbus_timer;
end

always @(negedge pin_clk or negedge qbus_tena)
begin
   if (~qbus_tena)
      qbus_timer <= 6'o00;
   else
      if (~qbus_tovf)
         qbus_timer <= qbus_timer + 6'o01;
end
//
// Control register at 177700
//
always @(*)
begin
   if (reset)
      reg_csr <= 3'b000;
   else
   begin
      //
      // Bit 0 of control register
      //
      if ((plm1x_hl & ~plr[25]) | ((plm23[0] | plm23[1] | plm23[3]) & reg_csr[1]))
         reg_csr[0] <= 1'b1;
      else
         if (sel_out & sel_00)
            reg_csr[0] <= d[0];
      if (slk)
         reg_csr0_h <= reg_csr[0];
      //
      // Bit 1 of control register (controls set of bit 0)
      //
      if (sel_out & sel_00)
         reg_csr[1] <= d[1];
      //
      // Bit 2 of control register (wait state)
      //
      if (plm1x_hl & ~plr[27])
         reg_csr[2] <= 1'b0;
      else
         if (plm1x_hl & ~plr[7])
            reg_csr[2] <= 1'b1;
         else
            if (sel_out & sel_00)
               reg_csr[2] <= d[2];
   end
end

//
// Start vector register at 177702
// Due to there is no start vector write interrupt (disconncted from
// interrupt controller matrix) the start vector register is not used
//
always @(*)
begin
   if (sel_out & sel_02)
      reg_vec <= d;
end
//
// Error register at 177704
// Bit 5 is not used (always read as one)
// Bit 6 is Odd Address Trap (is not implmented)
//
always @(*)
begin
   if (reset | plm23[0] | plm23[1] | plm23[3])
      reg_err <= 8'b00100000;
   else
   begin
      //
      // Bit 0 - double error
      //
      if (  (exc_dbl[0] & exc_uop)
          | (exc_dbl[1] & qbus_tovf)
          | (exc_dbl[2] & exc_oat)
          | (exc_dbl[3] & exc_err7))
         reg_err[0] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[0] <= d[0];
      //
      // Bit 1 - undefined opcode
      //
      if (exc_uop)
         reg_err[1] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[1] <= d[1];
      //
      // Bit 2 & 3 - unknown error, exceptions not implemented
      //
      if (exc_err2)
         reg_err[2] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[2] <= d[2];

      if (exc_err3)
         reg_err[3] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[3] <= d[3];
      //
      // Bit 4 - qbus timeout
      //
      if (qbus_tovf)
         reg_err[4] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[4] <= d[4];
      //
      // Bit 6 - odd address trap
      //
      if (exc_oat)
         reg_err[6] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[6] <= d[6];
      //
      // Bit 7 - unknown error, no exception
      //
      if (exc_err7)
         reg_err[7] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[7] <= d[7];
   end
   //
   // Double error detectors
   //
   if (~exc_uop)     exc_dbl[0] <= reg_err[1];
   if (~qbus_tovf)   exc_dbl[1] <= reg_err[4];
   if (~exc_oat)     exc_dbl[2] <= reg_err[6];
   if (~exc_err7)    exc_dbl[3] <= reg_err[7];
end

always @(*)
begin
   if (~pin_sync_in)
   begin
      sel_xx <= sel177x;
      sel_00 <= sel177x & (pin_ad_in[3:1] == 3'b000);
      sel_02 <= sel177x & (pin_ad_in[3:1] == 3'b001);
      sel_04 <= sel177x & (pin_ad_in[3:1] == 3'b010);
      sel_06 <= sel177x & (pin_ad_in[3:1] == 3'b011);
      sel_10 <= sel177x & (pin_ad_in[3:1] == 3'b100);
      sel_12 <= sel177x & (pin_ad_in[3:1] == 3'b101);
      sel_14 <= sel177x & (pin_ad_in[3:1] == 3'b110);
      sel_16 <= sel177x & (pin_ad_in[3:1] == 3'b111);
   end
end

always @(negedge pin_clk) rply_s3 <= ~rply_s2;
always @(*)
begin
   //
   // Original circuit contains error
   // The start irq request is reset by interrupt ack and EMT execution (last one is wrong)
   //
   if (reset | ((vsel[2:0] == 3'b110) & au_vsely))
      start_irq <= 1'b0;
   else
      if (rply_s1)
         start_irq <= 1'b1;

   if (slk)
      rply_s1 <= sel_02 & sel_out & rply_s3;
   else
      rply_s2 <= start_irq;
end
//______________________________________________________________________________
//
// Interrupt controller
//
assign pli = VM1_CORE_MULG_VERSION ? pli_g : pli_a;

vm1g_pli  pli_matrix_g(.rq(rq), .sp(pli_g));
vm1a_pli  pli_matrix_a(.rq(rq), .sp(pli_a));
//
// vm1_pli  pli_matrix(.rq(rq), .sp(pli));
//
always @(*)
begin
   if (pli_ena)
   begin
      rq[0]  <= psw[10];
      rq[1]  <= plir[0];   // pli4r
      rq[2]  <= psw[11];
      rq[3]  <= uop;
      rq[4]  <= psw[7];
      rq[9]  <= oat;
      rq[10] <= reg_err[0];
      rq[11] <= pin_aclo & aclo;
      rq[12] <= reg_csr[2];
      rq[13] <= ~pin_aclo & acok;
      rq[14] <= pin_irq[1];
      rq[15] <= psw[4];
      rq[16] <= pin_irq[2] & irq2;
      rq[17] <= ivto;
      rq[18] <= pin_irq[3] & irq3;
      //
      // Only master CPU processes vectored interrupts
      // Matrix accepts low level as active (asserted request)
      //
      rq[8]  <= ~(pin_virq & (pin_pa == 2'b00));
      //
      // Not used matrix inputs
      //
      rq[5]  <= 1'b0;
      rq[6]  <= 1'b0;
      rq[7]  <= 1'b0;
      //
      // VE timer interrupt
      //
      rq[19] <= tve_irq;
   end
end

//
// Odd address trap detector is blocked on 1801BM1
//
always @(*) if (slk) exc_uop <= plm[12] & plm_ena;
assign exc_oat  = 1'b0;
assign exc_err2 = plm1x_hl & ~plr[26];
assign exc_err3 = plm1x_hl & ~plr[28];
assign exc_err7 = plm1x_hl & ~plr[30];

always @(*)
begin
   if (reset)
      plir[0] <= 1'b0;
   else
      if (pli_stb)
         plir[0] <= pli[4];

   if (pli_stb)
   begin
      plir[1] <= pli[6];
      plir[2] <= pli[8];
      plir[3] <= pli[10];
   end
end
//
// Detectors reset
//
assign aclo_ack = plm1x_hl & ~plr[27] & ~plir[3] & ~plir[2] &  plir[1];
assign uop_ack  = plm1x_hl & ~plr[27] & ~plir[3] & ~plir[2] & ~plir[1];
assign irq2_ack = plm1x_hl & ~plr[27] &  plir[3] &  plir[2] & ~plir[1];
assign irq3_ack = plm1x_hl & ~plr[27] &  plir[3] & ~plir[2] & ~plir[1];
assign tve_ack  = plm1x_hl & ~plr[27] &  plir[3] & ~plir[2] &  plir[1];
//
// ACLO edge detectors
//
always @(*)
begin
   if (reset | aclo_ack)
   begin
      aclo <= 1'b0;
      acok <= 1'b0;
   end
   else
   begin
      if (pin_aclo)
         acok <= 1'b1;
      else
         aclo <= 1'b1;
   end
end
//
// IRQ2 and IRQ3 falling edge detectors
// Also resettable by internal INIT
//
always @(*)
begin
   if (pin_init_out | pin_init_in)
   begin
      irq2 <= 1'b0;
      irq3 <= 1'b0;
   end
   else
   begin
      if (irq2_ack)
         irq2 <= 1'b0;
      else
         if (~pin_irq[2])
            irq2 <= 1'b1;

      if (irq3_ack)
         irq3 <= 1'b0;
      else
         if (~pin_irq[3])
            irq3 <= 1'b1;
   end
end
//
// Error exception latches
//
always @(*)
begin
   if (reset | uop_ack)
   begin
      uop  <= 1'b0;
      oat  <= 1'b0;
      ivto <= 1'b0;
   end
   else
   begin
      if (exc_uop) uop <= 1'b1;
      if (qbus_tovf | exc_oat) oat <= 1'b1;
      if (qbus_tovf & iako_out) ivto <= 1'b1;
   end
end

always @(*)
begin
   if (pli_stb)
      vsel <= {pli[3], ~pli[2], pli[1], pli[0]};
   else
      if (plm1x)
         vsel <= {plr[18], ~plr[20], ~plr[21], ~plr[22]};
end

assign pli_nrdy = ~pli_stb & ~pli_lat;
assign pli_stb  = ~pli_ena_h & ~pli_lat;
always @(*) if (~slk) pli_ena <= pli_lat | abort;
always @(*)
begin
   if (slk)
   begin
      pli_ena_h <= pli_ena;
      pli_stb_h <= pli_stb;
      pli_req   <= plm23[1] | plm23[2] | plm23[3];
   end
end

always @(*)
begin
   if (pli_req | abort)
      pli_lat <= 1'b0;
   else
      if (reset | (~slk & pli_stb_h))
         pli_lat <= 1'b1;
end

always @(*)
begin
   if (din_done | mj_res)
      iak_flag <= 1'b0;
   else
      if (plm_ena_hl & (plr[28:25] == 4'b0010) & (plr[11] | (plr[13] & ~plr[14])) & (vsel == 4'b1111))
         iak_flag <= 1'b1;
end

//______________________________________________________________________________
//
// Reset circuits
//
assign mj_res = reset | abort;
assign reset  = pin_dclo | (pin_aclo & ~init_out[0] & init_out[2]);
assign abort = ~abtos[2] & ~abtos[1];
assign sim_reset = reset;

always @(*)
begin
   //
   // Simulation init patch: reset added
   //
   if (qbus_tovf | exc_oat | exc_uop | sim_reset)
      abtos[2] <= 1'b0;
   else
      if (abtos[1])
         abtos[2] <= 1'b1;
   if (slk)
      mj_res_h <= mj_res;
end

always @(posedge pin_clk)
begin
   //
   // Simulation init patch: reset added
   //
   abtos[0] <= ~(qbus_tovf | exc_oat | exc_uop) & abtos[2] & ~sim_reset;
   abtos[1] <= ~abtos[0];
end


always @(posedge pin_clk)
begin
   init_out[1] <= init_out[0];
   init_out[2] <= init_out[1];
end

always @(*)
begin
   if (reset)
      init_out[0] <= 1'b0;
   else
      if (plm1x_hl)
      begin
         if (~plr[23])
            init_out[0] <= 1'b0;
         else
            if (~plr[10])
               init_out[0] <= 1'b1;
      end
end

//______________________________________________________________________________
//
// Microcode state machine
//
assign plx = VM1_CORE_MULG_VERSION ? plx_g : plx_a;

vm1g_plm  plm_matrix_g(.ir(ir), .mr(ma), .sp(plx_g));
vm1a_plm  plm_matrix_a(.ir(ir), .mr(ma), .sp(plx_a));
//
// vm1_plm  plm_matrix(.ir(ir), .mr(ma), .sp(plx));
//
assign plm1x = plm_ena & ~plm[12] &  (plm[11] & plm[13]);
assign plm2x = plm_ena & ~plm[12] & ~(plm[11] & plm[13]);
assign plm23[0] = plm_ena & (plm[3:1] == 3'b001);
assign plm23[1] = plm_ena & (plm[3:1] == 3'b011);
assign plm23[2] = plm_ena & (plm[3:1] == 3'b101);
assign plm23[3] = plm_ena & (plm[3:1] == 3'b111);

assign plop[0] = ~plr[22] & ~plr[21] & ~plr[4];
assign plop[1] = ~plr[22] & ~plr[21] &  plr[4];
assign plop[2] = ~plr[22] &  plr[21] & ~plr[4];
assign plop[3] = ~plr[22] &  plr[21] &  plr[4];
assign plop[4] =  plr[22] & ~plr[21] & ~plr[4];
assign plop[5] =  plr[22] & ~plr[21] &  plr[4];
assign plop[6] =  plr[22] &  plr[21] & ~plr[4];
assign plop[7] =  plr[22] &  plr[21] &  plr[4];

always @(*)
begin
   if (sop_up) ma <= mj;
end

always @(*)
begin
   if (plm_ena_hl)
   begin
      mj_stb1  <= (plop[7] & t5843) | (~plop[1] & ~plop[5] & ~plop[7]);
      mj_stb2  <= (plop[7] & t5843) | (~plop[1] & ~plop[5] & ~plop[7] & ~plop[3]);
      psw_mj   <=  plop[7] & t5843;
      psw_stb  <= ~plop[0] & ~plop[2] & ~plop[7];
      psw_stbc <= ~plop[0] & ~plop[1] & ~plop[2] & ~plop[3] & ~plop[7];
   end
   if (~slk) t5843 <= ir_stb2;
end

always @(negedge pin_clk) plm1x_hl <= plm1x;
always @(negedge pin_clk) plm_ena_hl <= plm_ena;

//
// Instruction register
//
always @(posedge pin_clk)
begin
   if (ir_stb1) ira <= d;
   if (ir_stb2)
      if (ir_stb1)
         ir <= d;
      else
         ir <= ira;
end

always @(*)
begin
   //
   // The least bit is reset by abort
   // and set by common reset
   //
   if (abort)
      plm[29] <= 1'b0;
   else
      if (reset)
         plm[29] <= 1'b1;
      else
         if (plm_stb)
            plm[29] <= ~plx[29];

   //
   // Some bits are the next microcode address and have async reset
   //
   if (mj_res)
   begin
      plm[24] <= 1'b1;
      plm[19] <= 1'b1;
      plm[15] <= 1'b1;
      plm[9]  <= 1'b1;
      plm[5]  <= 1'b1;
      plm[0]  <= 1'b1;
   end
   else
      if (plm_stb)
      begin
         plm[24] <= ~plx[24];
         plm[19] <= ~plx[19];
         plm[15] <=  plx[15];
         plm[9]  <=  plx[9];
         plm[5]  <=  plx[5];
         plm[0]  <= ~plx[0];
      end
   //
   // Other bits have no reset facility
   //
   if (plm_stb)
   begin
      plm[33:30] <= plx[33:30];
      plm[28:25] <= plx[28:25];
      plm[23:20] <= plx[23:20];
      plm[18:16] <= plx[18:16];
      plm[14:10] <= plx[14:10];
      plm[8:6]   <= plx[8:6];
      plm[4:1]   <= plx[4:1];
   end
end

always @(*)
begin
   if (plm_ena) plr <= plm;
end

//
// Microcode register
//
always @(*)
begin
   //
   // Bits 14:12 poll the interrupt controller state
   //
   if (mj_res)
      mj[14:12] <= 3'b000;
   else
      if (pli_stb)
         mj[14:12] <= {~pli[5], ~pli[7], pli[9]};
      else
         if (plm1x)
            mj[14:12] <= {~plr[14], plr[16], ~plr[17]};
   //
   // Least bits are produced directly from main matrix
   //
   if (sop_up)
   begin
      mj[0] <= plm[29];
      mj[1] <= plm[24];
      mj[2] <= plm[19];
      mj[3] <= plm[15];
      mj[4] <= plm[9];
      mj[5] <= plm[5];
      mj[6] <= plm[0];
   end
   if (mj_stb1 & ustb1_hl)
   begin
      mj[11] <= psw[4];
      mj[10] <= fsel[3];
      mj[9]  <= fsel[2];
      mj[8]  <= fsel[1];
   end
   if (mj_stb2 & ustb1_hl)
      mj[7]  <= fsel[0];
end

//______________________________________________________________________________
//
// ALU result flags and PSW
//
always @(*)
begin
   if (psw_mj & ustb1_hl)
      fsel <= psw[3:0];
   else
      if (au_alsl)
         fsel <= flag;
end

always @(*)
begin
   //
   // Start microcode correctly sets the PSW
   // But simulator can not calculate ALU function
   // correctly if PSW in initially undefined
   //
   // The PSW is written by microcode with 340 value
   // while executing reset sequence
   //
   if (sim_reset)
      psw[15:0] <= 16'o000000;

   if (au_alsl & au_pswx)
      psw[7:0] <= x[7:0];
   else
   begin
      if (psw_stbc & ustb1_hl)
         psw[0] <= fsel[0];
      if (psw_stb & ustb1_hl)
         psw[3:1] <= fsel[3:1];
   end
   if (au_alsh & au_pswx)
   begin
      psw[9:8] <= pin_pa[1:0];
      psw[15:10] <= x[15:10];
   end
end

//
// ALU general purpose registers
//
assign rs0[0]  = ((plr[32:30] == 3'b111) & rs_ena) | ((plr[27:25] == 3'b111) & rs_ena0);
assign rs0[1]  = ((plr[32:30] == 3'b011) & rs_ena) | ((plr[27:25] == 3'b011) & rs_ena0);
assign rs0[2]  = ((plr[32:30] == 3'b101) & rs_ena) | ((plr[27:25] == 3'b101) & rs_ena0);
assign rs0[3]  = ((plr[32:30] == 3'b001) & rs_ena) | ((plr[27:25] == 3'b001) & rs_ena0);
assign rs0[4]  = ((plr[32:30] == 3'b110) & rs_ena) | ((plr[27:25] == 3'b110) & rs_ena0);
assign rs0[5]  = ((plr[32:30] == 3'b010) & rs_ena) | ((plr[27:25] == 3'b010) & rs_ena0);
assign rs0[6]  = ((plr[32:30] == 3'b100) & rs_ena) | ((plr[27:25] == 3'b100) & rs_ena0)
               | (~plr[20] & au_alsl)
               | ( rs_ena1 & plr[13] & plr[14]);

assign rs1[0]  = (plr[32:30] == 3'b111) & (rs_ena | rs_ena1);
assign rs1[1]  = (plr[32:30] == 3'b011) & (rs_ena | rs_ena1);
assign rs1[2]  = (plr[32:30] == 3'b101) & (rs_ena | rs_ena1);
assign rs1[3]  = (plr[32:30] == 3'b001) & (rs_ena | rs_ena1);
assign rs1[4]  = (plr[32:30] == 3'b110) & (rs_ena | rs_ena1);
assign rs1[5]  = (plr[32:30] == 3'b010) & (rs_ena | rs_ena1);
assign rs1[6]  = (plr[32:30] == 3'b100) & (rs_ena | rs_ena1)
               | (~plr[20] & au_alsl);

assign rs_wr   = rs0 & rs1;
assign rs_ena  = au_alsl & plr[20];
assign rs_ena0 = rs_ena1 & ~plr[13];
assign rs_ena1 = ustb | ~ustb0;

assign au_alsl = alu_nrdy & ustb1_h;
assign au_alsh = au_alsl & plr[18];
assign au_rsy0 = ~(rs_ena1 | alu_u) ?  au_rsx0 :  (~plr[11] & ~plr[13] & ~plr[28]);
assign au_rsy1 = ~(rs_ena1 | alu_u) ? ~au_rsx0 : ((~plr[11] & ~plr[13] &  plr[28]) | (plr[13] & plr[14]));
assign au_rsx0 = (plr[20] | rs_ena1 | alu_u) & ~plr[33];
assign au_rsx1 = ~au_rsx0;
assign au_is0  = alu_u & ~(plr[13] & plr[14] & plr[25] & plr[26] & ~plr[27]);
assign au_is1  = alu_u &  (plr[13] & plr[14] & plr[25] & plr[26] & ~plr[27]);

assign au_qsy  = rs_ena1 & (plr[28:25] == 4'b0000) & ~plr[11] & ~plr[13];
assign au_qsx  = rs_ena1 & (plr[33:30] == 4'b0000);
assign au_pswx = (rs_ena1 | rs_ena) & (plr[33:30] == 4'b1000);
assign au_pswy = (          rs_ena  & (plr[33:30] == 4'b1000))
               | (rs_ena1 & ~plr[11] & ~plr[13] & (plr[28:25] == 4'b1000));

assign au_ard   = sync_stb;
assign au_qrdd  = dout_ext;
assign au_qstbd = iako_out | tplm[2];
assign au_astb  = (au_alsl & ~(~plr[14] & plr[13]) & (~plr[23] & (plr[7] | plr[8])))
                | ( ~ustb0 &  (~plr[14] & plr[13]) & (~plr[23] & (plr[7] | plr[8])));
assign au_qstbx = (au_alsl & ~(~plr[14] & plr[13]) & (~plr[23] & ~plr[7] & ~plr[8]))
                | ( ~ustb0 &  (~plr[14] & plr[13]) & (~plr[23] & ~plr[7] & ~plr[8]));

assign au_mhl0  = (dout_ext | au_qstbd) & ~au_ta0;
assign au_mhl1  = (dout_ext | au_qstbd) &  au_ta0;
assign au_dzl   = au_mhl1 & ~sync_stb & plrt[6];
assign au_dzh   = au_mhl0 & ~sync_stb & plrt[6];

//
// Constant and vector generator
//
assign au_vsely = rs_ena1 & (plr[28:25] == 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);
assign au_csely = rs_ena1 & (plr[28:25] != 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);

vm1_vgen vgen(
   .ireg(ir),           // instruction register
   .svec(reg_vec),      // start vector register
   .vsel(vsel),         // vector output selection
   .csel(plr[28:25]),   // constant output selection
   .vena(au_vsely),     // vector output enable
   .cena(au_csely),     // constant output enable
   .carry(psw[0]),      // carry flag psw[0]
   .pa(pin_pa),         // processor number
   .value(vcd)          // output vector value
);
//
// X bus (12 entries)
//    AU_RSX0  - general purpose regs
//    AU_RSX1  - general purpose regs
//    AU_QSX   - qbus temporary reg
//    AU_PSWX  - PSW
//
//    AU_ALSx  - ALU result strobe     (writeonly)
//    AU_ASTB  - A address register    (readonly)
//    AU_ASTB  - A address register    (readonly)
//    AU_QSTBX - Qbus temporary reg    (readonly)
//    AU_QSTBX - Qbus temporary reg    (readonly)
//    AU_IS0   - ALU X argument        (readonly)
//    AU_IS1   - ALU X argument        (readonly)
//
// Y bus, inverted (9 entries)
//    AU_RSY0  - general purpose regs
//    AU_RSY1  - general purpose regs
//    AU_QSY   - Qbus temporary reg
//    AU_PSWY  - PSW
//
//    AU_ALSx  - ALU result strobe     (writeonly))
//    AU_VSELY - vector generator      (Y-writeonly)
//    AU_CSELY - constant generator    (Y-writeonly)
//    ALU_U    - ALU Y argument        (readonly)
//
assign x[15:0] =   au_alsl ? (au_alsh ? alu[15:0] : {8'o000, alu[7:0]}) :
               ( ((au_rsx1 & (rs1[6:0] == 7'b0000001)) ? gpr[0]  : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b0000010)) ? gpr[2]  : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b0000100)) ? gpr[4]  : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b0001000)) ? gpr[6]  : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b0010000)) ? gpr[8]  : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b0100000)) ? gpr[10] : 16'o000000)
               | ((au_rsx1 & (rs1[6:0] == 7'b1000000)) ? gpr[12] : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0000001)) ? gpr[1]  : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0000010)) ? gpr[3]  : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0000100)) ? gpr[5]  : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0001000)) ? gpr[7]  : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0010000)) ? gpr[9]  : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b0100000)) ? gpr[11] : 16'o000000)
               | ((au_rsx0 & (rs1[6:0] == 7'b1000000)) ? gpr[13] : 16'o000000)
               | (au_qsx                               ? qreg    : 16'o000000)
               | (au_pswx ? {psw[15:10], pin_pa[1:0], psw[7:0]}  : 16'o000000));

assign y[15:0] =   au_alsl ? (au_alsh ? ~alu[15:0] : ~{8'o000, alu[7:0]}) :
               ( ((au_rsy1 & (rs0[6:0] == 7'b0000001)) ? ~gpr[0]  : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b0000010)) ? ~gpr[2]  : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b0000100)) ? ~gpr[4]  : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b0001000)) ? ~gpr[6]  : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b0010000)) ? ~gpr[8]  : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b0100000)) ? ~gpr[10] : 16'o000000)
               | ((au_rsy1 & (rs0[6:0] == 7'b1000000)) ? ~gpr[12] : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0000001)) ? ~gpr[1]  : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0000010)) ? ~gpr[3]  : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0000100)) ? ~gpr[5]  : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0001000)) ? ~gpr[7]  : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0010000)) ? ~gpr[9]  : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b0100000)) ? ~gpr[11] : 16'o000000)
               | ((au_rsy0 & (rs0[6:0] == 7'b1000000)) ? ~gpr[13] : 16'o000000)
               | (au_qsy                               ? ~qreg    : 16'o000000)
               | (au_pswy ? ~{psw[15:10], pin_pa[1:0], psw[7:0]}  : 16'o000000)
               | ((au_vsely | au_csely) ? ~vcd                    : 16'o000000));

always @(negedge pin_clk)
begin
   if (sim_reset)
   begin
      //
      // For accurate simulation only
      //
      gpr[0]   <= 16'o000000;
      gpr[1]   <= 16'o000000;
      gpr[2]   <= 16'o000000;
      gpr[3]   <= 16'o000000;
      gpr[4]   <= 16'o000000;
      gpr[5]   <= 16'o000000;
      gpr[6]   <= 16'o000000;
      gpr[7]   <= 16'o000000;
      gpr[8]   <= 16'o000000;
      gpr[9]   <= 16'o000000;
      gpr[10]  <= 16'o000000;
      gpr[11]  <= 16'o000000;
      gpr[12]  <= 16'o000000;
      gpr[13]  <= 16'o000000;
   end

   if (au_alsl)
   begin
      if (au_rsx1)
      begin
         if (rs_wr[0]) gpr[0][7:0]  <= x[7:0];
         if (rs_wr[1]) gpr[2][7:0]  <= x[7:0];
         if (rs_wr[2]) gpr[4][7:0]  <= x[7:0];
         if (rs_wr[3]) gpr[6][7:0]  <= x[7:0];
         if (rs_wr[4]) gpr[8][7:0]  <= x[7:0];
         if (rs_wr[5]) gpr[10][7:0] <= x[7:0];
         if (rs_wr[6]) gpr[12][7:0] <= x[7:0];
      end
      if (au_rsx0)
      begin
         if (rs_wr[0]) gpr[1][7:0]  <= x[7:0];
         if (rs_wr[1]) gpr[3][7:0]  <= x[7:0];
         if (rs_wr[2]) gpr[5][7:0]  <= x[7:0];
         if (rs_wr[3]) gpr[7][7:0]  <= x[7:0];
         if (rs_wr[4]) gpr[9][7:0]  <= x[7:0];
         if (rs_wr[5]) gpr[11][7:0] <= x[7:0];
         if (rs_wr[6]) gpr[13][7:0] <= x[7:0];
      end
   end
   if (au_alsh)
   begin
      if (au_rsx1)
      begin
         if (rs_wr[0]) gpr[0][15:8]  <= x[15:8];
         if (rs_wr[1]) gpr[2][15:8]  <= x[15:8];
         if (rs_wr[2]) gpr[4][15:8]  <= x[15:8];
         if (rs_wr[3]) gpr[6][15:8]  <= x[15:8];
         if (rs_wr[4]) gpr[8][15:8]  <= x[15:8];
         if (rs_wr[5]) gpr[10][15:8] <= x[15:8];
         if (rs_wr[6]) gpr[12][15:8] <= x[15:8];
      end
      if (au_rsx0)
      begin
         if (rs_wr[0]) gpr[1][15:8]  <= x[15:8];
         if (rs_wr[1]) gpr[3][15:8]  <= x[15:8];
         if (rs_wr[2]) gpr[5][15:8]  <= x[15:8];
         if (rs_wr[3]) gpr[7][15:8]  <= x[15:8];
         if (rs_wr[4]) gpr[9][15:8]  <= x[15:8];
         if (rs_wr[5]) gpr[11][15:8] <= x[15:8];
         if (rs_wr[6]) gpr[13][15:8] <= x[15:8];
      end
   end
end
//
// ALU qbus register
//
assign mhl  = (au_mhl0 ? d[7:0] : 8'o000)
            | (au_mhl1 ? d[15:8] : 8'o000);
always @(*)
begin
   if (au_qstbx)
      qreg[7:0] <= x[7:0];
   else
      if (au_qstbd)
         qreg[7:0] <= mhl[7:0];

   if (au_qstbx)
      qreg[15:8] <= x[15:8];
   else
      if (au_qstbd)
         qreg[15:8] <= d[15:8];
end

always @(*)
begin
   if (au_astb)
      areg <= x;
end
//
// Transaction address low bit lacth
//
always @(*)
begin
   if (qbus_done_hl)
      au_ta0 <= 1'b0;
   else
      if (sync_stb)
         au_ta0 <= d[0] & plrt[6];
end
//______________________________________________________________________________
//
// ALU function unit
//
assign nx  = alu_x ? ~xreg : xreg;
//
// ALU input parameters (from X and Y buses) registers
//
always @(*)
begin
   if (au_is0)
      xreg[15:0] <= x[15:0];
   else
      if (au_is1)
         xreg[15:0] <= {x[7:0], x[15:8]};
   if (alu_u)
         yreg <= y;
end
//
// ALU controls
//
// plr[17:13]  cl  alu_b alu_c alu_d alu_e alu_x   oxy   axy      h     alu
//    00x00    1     0     1     0     0     0    ~x|~y ~x&~y  ~(x^y)   x+y
//    00x01    1     0     1     0     0     0      -     -       -      -
//    00x11    1     0     1     0     0     0      -     -       -      -
//    00x10    1     0     0     0     1     0    ~x|~y  ~x    ~(x&~y)  x&~y
//    01x00    0     0     1     0     0     1     x|~y  x&~y    x^y    y-x
//    01x01    0     0     1     0     0     1      -     -       -      -
//    01x11    0     0     1     0     0     1      -     -       -      -
//    01x10    0     0     1     0     1     0    ~x|~y ~x&~y  ~(x^y)   x^y
//    10x00    1     1     1     0     1     0    ~x|y  ~x&~y    ~y      y
//    10x01    1     0     0     0     1     0      1    ~x      ~x      x
//    10x10    1     0     1     0     1     0      1   ~x&~y  ~(x|y)   x|y
//    10x11    1     0     0     0     1     0      1    ~x      ~x      x
//    11x00    0     1     0     1     0     0    ~x|y  ~x&y     x^y    x-y
//    11x01    0     1     0     1     0     0      -     -       -      -
//    11x11    0     1     0     1     0     0      -     -       -      -
//    11x10    1     1     0     0     1     0    ~x|y   ~x    ~(x&y)   x&y
//
assign cl      = ~plr[16] | (plr[17] & alu_e);
assign alu_b   = plr[17] & (plr[16] | (~plr[13] & ~plr[14]));
assign alu_c   = (~plr[13] & (plr[16] ^ plr[17])) | (~alu_e & ~plr[17]);
assign alu_d   = ~alu_e & plr[16] & plr[17];
assign alu_e   = (~plr[13] & plr[14]) | (~plr[16] & plr[17]);
assign alu_x   =  plr[16] & ~plr[17] & ~alu_e;
assign alu_u   = ~ustb1 & ~au_alsl;

//
// ALU selectable function
//
assign cpred   = {c[14:0], cl};
assign c       = (cpred & oxy) | (~cpred & axy & oxy);
assign h       = (~oxy & ~axy) | (oxy & axy);
assign f       = alu_e ? h : ~(cpred ^ h);

//
// ALU result shifter
//
assign fbit7   = fctl[1] & f[7]
               | fctl[3] & f[8]
               | fctl[7] & c[7]
               | fctl[5] & fbitc;
assign fbit15  = fctl[2] & f[15]
               | fctl[6] & c[15]
               | fctl[4] & fbitc;

assign fctl[1] = ~plr[25] & ~plr[26] & plr[27] & ~plr[18];
assign fctl[2] = ~plr[25] & ~plr[26] & plr[27];
assign fctl[3] =  plr[27] &  plr[18];
assign fctl[4] =  plr[13] & plr[14] & ~plr[25] &  plr[26] & plr[27];
assign fctl[5] =  plr[13] & plr[14] & ~plr[25] &  plr[26] & plr[27] & ~plr[18];
assign fctl[6] =  plr[13] & plr[14] &  plr[25] & ~plr[26] & plr[27];
assign fctl[7] =  plr[13] & plr[14] &  plr[25] & ~plr[26] & plr[27] & ~plr[18];

//
// assign alu_shr = ~alu_s &  plr[27];
// assign alu_shl = ~alu_s & ~plr[27];
//
assign alu_s   =  ~plr[13] | ~plr[14] | (plr[25] & plr[26]);
assign alu     = ~(alu_s ? f : (plr[27] ? {fbit15, f[15:9], fbit7, f[7:1]} : {f[14:0], fbitc}));

//
// ALU result condition flags
//
assign flag[0] = alu_s ? ~fmux[0] : ~fmux[1];                              // C
assign flag[2] = (~plr[18] | (alu[15:8] == 8'o000)) & (alu[7:0] == 8'o000); // Z
assign flag[3] = plr[18] ? alu[15] : alu[7];                                // N
assign flag[1] = ~(alu_s & alu_e)                                          // V
               & ~(((fmux[1] ^ flag[3]) | alu_s) & (plr[18] ? (c[14] ^ ~c[15]) : (c[6] ^ ~c[7])));

assign fmux[0] = cl ?  (alu_e | (plr[18] ? c[15] : c[7]))
                    : ~(alu_e | (plr[18] ? c[15] : c[7]));
assign fmux[1] = (f[0] | ~plr[27]) & (plr[27] | (plr[18] ? f[15] : f[7]));
assign fbitc   = ~(psw[0] & ~plr[25] & plr[26]);
//
// ALU and/or products
//
assign oxy = ~nx | ~((~plr[17] ? ~yreg : 16'o000000) | (alu_b ? yreg : 16'o000000));
assign axy = ~nx & ~(alu_d ? yreg  : 16'o000000) & ~(alu_c ? ~yreg : 16'o000000);
endmodule

//______________________________________________________________________________
//
// Vector address and constant generator
//
module   vm1_vgen
(
   input  [15:0]  ireg,       // instruction register
   input  [15:0]  svec,       // start vector register
   input  [3:0]   vsel,       // vector output selection
   input  [3:0]   csel,       // constant output selection
   input          vena,       // vector output enable
   input          cena,       // constant output enable
   input          carry,      // carry flag psw[0]
   input  [1:0]   pa,         // processor number
   output [15:0]  value       // output vector value
);
reg [15:0]  vmux;             // variable for vector multiplexer
reg [15:0]  cmux;             // variable for constant multiplexer

//
// On schematics vsel is {pli[3], ~pli[2], pli[1], pli[0]}
//
always @(*)
begin
case(vsel)
   4'b0000: vmux = 16'o160006;      // double error
   4'b0001: vmux = 16'o000020;      // IOT instruction
   4'b0010: vmux = 16'o000010;      // reserved opcode
   4'b0011: vmux = 16'o000014;      // T-bit/BPT trap
   4'b0100: vmux = 16'o000004;      // invalid opcode
   4'b0101:                         // or qbus timeout
      case (pa[1:0])                // initial start
         2'b00:  vmux = 16'o177716; // register base
         2'b01:  vmux = 16'o177736; // depends on
         2'b10:  vmux = 16'o177756; // processor number
         2'b11:  vmux = 16'o177776; //
         default:vmux = 16'o177716; //
      endcase                       //
   4'b0110: vmux = 16'o000030;      // EMT instruction
   4'b0111: vmux = 16'o160012;      // int ack timeout
   4'b1000: vmux = 16'o000270;      // IRQ3 falling edge
   4'b1001: vmux = 16'o000024;      // ACLO falling edge
   4'b1010: vmux = 16'o000100;      // IRQ2 falling edge
   4'b1011: vmux = 16'o160002;      // IRQ1 low level/HALT
   4'b1100: vmux = 16'o000034;      // TRAP instruction
   4'b1101: vmux = ireg;            // instruction register
   4'b1110: vmux = svec;            // start @177704
   4'b1111: vmux = 16'o000000;      // unused vector (iako)
   default: vmux = 16'o000000;      //
endcase
end

//
// Constant generator and opcode fields shifter/truncator
//
// On schematics csel is plr[28:25]
//
//    csel0 = 4b'00xx
//    csel1 = 4b'01xx
//    csel2 = 4b'10xx
//    csel3 = 4b'11xx
//    csel4 = 4b'xx00
//    csel5 = 4b'xx01
//    csel6 = 4b'xx10
//    csel7 = 4b'xx11
//
always @(*)
begin
case(csel)
   4'b0000: cmux = {12'o0000, ireg[3:0]};       // csel0 & csel4 (CLx/SEx)
   4'b0001: cmux = 16'o000340;                  // csel0 & csel5 (start PSW constant)
   4'b0010: cmux = 16'o000000;                  // csel0 & csel6 (vector output)
   4'b0011: cmux = 16'o000002;                  // csel0 & csel7
   4'b0100: cmux = {9'o000, ireg[5:0], 1'b0};   // csel1 & csel4 (MARK/SOB)
   4'b0101: cmux = 16'o177716;                  // csel1 & csel5
   4'b0110: cmux = 16'o177777;                  // csel1 & csel6
   4'b0111: cmux = 16'o000001;                  // csel1 & csel7
   4'b1000:                                     //
      begin                                     // csel2 & csel4
         if (ireg[7])                           //
            cmux = {7'o177, ireg[7:0], 1'b0};   // low byte x2   (BR/Bxx)
         else                                   // sign extension
            cmux = {7'o000, ireg[7:0], 1'b0};   // for branches
      end                                       //
   4'b1001: cmux = 16'o100000;                  // csel2 & csel5
   4'b1010: cmux = 16'o177676;                  // csel2 & csel6
   4'b1011: cmux = 16'o000020;                  // csel2 & csel7 (MUL)
   4'b1100: cmux = {15'o00000, carry};          // csel3 & csel4 (ADC/SBC)
   4'b1101: cmux = 16'o177400;                  // csel3 & csel5 (start address AND)
   4'b1110: cmux = 16'o000010;                  // csel3 & csel6
   4'b1111: cmux = 16'o000000;                  // csel3 & csel7 (vector read/vsel)
   default: cmux = 16'o000000;
endcase
end

assign value = (vena ? vmux : 16'o000000)
             | (cena ? cmux : 16'o000000);
endmodule

//______________________________________________________________________________
//

