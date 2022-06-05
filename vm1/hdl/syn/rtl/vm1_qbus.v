//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Optimizations done:
//    - plr18r is replaced by plr[18]
//    - plr33r is replaced by plr[33]
//    - ustb2 is equal to ~au_alsl
//    - 177702 register data removed
//    - dout_start uses rply_ack[2] instead of rply_ack[1]
//    - slave Qbus interface should be syncronized (or slow) with clk
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
// If VM1_CORE_REG_USES_RAM is nonzero the Register File is implemented
// as library RAM module, the constant and vector generators also use
// this initialized RAM to provide the data. This option is intended to
// be used on FPGA with embedded RAM blocks
//
   VM1_CORE_REG_USES_RAM = 1,
//______________________________________________________________________________
//
// VM1 version select - VM1A or VM1G. VM1G contains another version of
// microcode, supports VE timer interrupt and MUL operation.
// If VM1_CORE_MULG_VERSION is defined an nonzero the VM1G core being generated
//
   VM1_CORE_MULG_VERSION = 0
)
(
   input          pin_clk_p,        // processor clock
   input          pin_clk_n,        // processor clock 180 degree
   input          pin_ena,          // processor clock enable
   input  [1:0]   pin_pa,           // processor number
   input          pin_init_in,      // peripheral reset input
   output         pin_init_out,     // peripheral reset output
                                    //
   input          pin_dclo,         // processor reset
   input          pin_aclo,         // power fail notificaton
   input  [3:1]   pin_irq,          // radial interrupt requests
   input          pin_virq,         // vectored interrupt request
                                    //
   input  [15:0]  pin_ad_in,        // data bus input
   output [15:0]  pin_ad_out,       // address/data bus output
   output         pin_ad_ena,       // address/data bus enable
                                    //
   input          pin_dout_in,      // data output strobe input
   output         pin_dout_out,     // data output strobe output
   input          pin_din_in,       // data input strobe input
   output         pin_din_out,      // data input strobe output
   output         pin_wtbt,         // write/byte status
   output         pin_ctrl_ena,     // enable control outputs
                                    //
   input          pin_sync_in,      // address strobe input
   output         pin_sync_out,     // address strobe output
   output         pin_sync_ena,     // address strobe enable
                                    //
   input          pin_rply_in,      // transaction reply input
   output         pin_rply_out,     // transaction reply output
                                    //
   input          pin_dmr_in,       // bus request shared line
   output         pin_dmr_out,      //
                                    //
   input          pin_sack_in,      // bus acknowlegement
   output         pin_sack_out,     // bus acknowlegement
                                    //
   input          pin_dmgi,         // bus granted input
   output         pin_dmgo,         // bus granted output
   output         pin_iako,         // interrupt vector input
   input          pin_sp,           // peripheral timer input
   output [2:1]   pin_sel,          // register select outputs
   output         pin_bsy           // bus busy flag
);

//______________________________________________________________________________
//
wire  [15:0]   wb_pio_dat_i;        //
wire  [15:0]   wb_cpu_dat_i;        //
                                    //
wire  [33:0]   plx, plx_a, plx_g;   // main microcode matrix output
reg   [33:0]   plr;                 // main matrix result register (last stage)
reg   [33:0]   plm;                 // main matrix result register (first stage)
reg   [14:0]   mj;                  // microcode stage and condition register
reg   [15:0]   ir;                  // instruction register (last stage)
reg   [15:0]   ira;                 // instruction register (first stage)
                                    //
wire  [10:0]   pli, pli_a, pli_g;   // interrupt priority encode matrix output
reg   [19:0]   rq;                  // interrupt request register
reg            aclo;                // ACLO falling edge detectors
reg            acok;                // ACLO raising edge detectors
reg            irq2;                // IRQ2 falling edge detectors
reg            irq3;                // IRQ3 falling edge detectors
reg            uop;                 // undefined operation latch
reg            qbto;                // I/O bus timeout & OAT latch
reg            ivto;                // IAKO bus timeout latch
reg            start_irq;           // raised by 1777x2 register write
wire           tve_irq;             // VE-timer interrupt request (vm1a_pli ignores)
wire           tve_ack;             // VE-timer interrupt acknowledgement
                                    //
wire           exc_uop;             // Undefined opcode found
wire           exc_oat;             // Odd address trap detector
wire           exc_err2;            //
wire           exc_err3;            //
wire           exc_err7;            //
reg   [3:0]    exc_dbl;             // double error detector
                                    //
reg   [5:0]    qbus_timer;          // qbus timeout counter
wire           qbus_tena;           //
reg            qbus_tovf;           // Qbus timer overflow latch
                                    //
                                    //
wire           uop_ack;             // undefined instruction
wire           aclo_ack;            // ACLO timer acknowlegement
wire           irq2_ack;            // IRQ2 timer acknowlegement
wire           irq3_ack;            // IRQ3 timer acknowlegement
reg   [3:0]    vsel;                // vector selection register
reg   [3:0]    plir;                // pli[10:8:6:4] outputs latch
                                    //
wire           ir_stb1;             //
reg            ir_stb2;             // instruction register strobe
wire           ir_clr;              //
wire           ir_set_fc;           //
reg            ir_set;              //
reg            ir_stop;             //
reg            ir_seq;              //
wire           ir_seq_rc;           //
                                    //
wire           pli_req_rc;          // interrupt encoder request
reg            pli_req;             // source and latch
wire           pli_stb;             // interrupt matrix strobe
wire           pli_nrdy;            // interrupt matrix not ready
                                    //
wire           plm_stb_rc;          // plm_register strobe source
reg            plm_stb;             // plm_register strobe latch
                                    //
wire           plm1x_fc;            //
wire           plm2x_fc;            // main matrix result strobes
reg            plm1x, plm2x;        //
reg            plm1x_hl;            //
reg            plm_ena;             //
wire           plm_ena_fc;          //
                                    //
reg   [3:0]    sop_out;             //
wire           sop_up;              //
wire  [7:0]    plop;                //
wire           uplr_stb;            //
reg            mj_stb1, mj_stb2;    //
reg            psw_stb, psw_stbc;   //
reg            psw_mj;              //
                                    //
wire  [3:0]    plm23_fc;            //
reg            plm23_wait;          //
reg            plm23_ichk;          //
                                    //
wire  [3:1]    tplm_rc;             //
reg   [3:1]    tplm;                //
reg   [3:1]    tplmz;               //
reg   [8:6]    plrt;                //
reg   [8:6]    plrtz;               //
                                    //
reg            reset;               // global device hardware reset
reg            abort;               // odd address. bus hang, invalid opcode
reg            mjres;               // reset microcode state machine
reg            mjres_h;             //
                                    //
wire           mjres_rc;            //
wire           reset_rc;            //
wire           abort_rc;            //
reg            abort_tm;            //
                                    //
wire  [15:0]   d;                   // internal data bus
wire  [15:0]   tve_d;               // timer module data output
wire           ad_oe;               // external AD pins output enable
wire           sel177x;             // peripheral block access
reg            sel_00, sel_02,      // peripheral block selectors
               sel_04, sel_06,      //
               sel_10, sel_12,      //
               sel_14, sel_16,      //
               sel_xx;              //
wire           sel_in, sel_out;     //
reg            rply_s2, rply_s3;    // disable rply generation if start_irq active
wire           rply_s1;             //
                                    //
reg            dmr_req;             //
reg            dmr_req_l;           //
wire           dmr_req_rc;          //
wire           dmr_out;             //
wire           iako_out;            //
reg            iako_out_lh;         //
reg            iak_flag;            //
reg   [2:0]    init_out;            //
                                    //
wire           qbus_done;           //
reg   [3:1]    rply_ack;            //
wire           rply_ack_fc;         //
                                    //
reg            iako_oe;             //
wire           oe_set_fc;           //
reg            oe_set;              //
wire           oe_clr_fc;           //
reg            oe_clr;              //
                                    //
wire           qbus_nrdy;           //
reg   [1:0]    qbus_aseq;           // address request sequencer
reg            dout_done;           //
wire           dout_start;          //
reg            dout_req;            //
wire           dout_req_rc;         //
reg            dout_out;            //
reg            dout_out_l;          //
wire           dout_ext;            //
                                    //
wire           din_done;            //
wire           din_start;           //
reg            din_out;             //
reg            din_out_l;           //
                                    //
wire           dmgo_out;            //
wire           qbus_yield;          //
reg            dmgi_in_l;           //
reg            qbus_adr;            //
reg            qbus_req;            //
reg            qbus_win;            //
reg            qbus_win_h;          //
wire           qbus_own;            //
reg            qbus_own_fp;         //
reg            qbus_own_rp;         //
reg            qbus_flag;           //
wire           qbus_flag_rc;        //
reg            sack_out;            //
reg            sync_out;            //
reg            sync_out_h;          //
reg            sync_ena;            //
wire           sync_stb;            //
wire           sync_fedge;          //
reg            qbus_nosr_h;         //
wire           qbus_nosr_rc;        //
wire           qbus_gnt;            //
reg            qbus_gnt_l;          //
wire           qbus_free;           //
reg            qbus_free_h;         //
                                    //
reg   [2:0]    reg_csr;             // 177700: control register
reg   [7:0]    reg_err;             // 177704: error register
                                    //
reg   [3:0]    freg;                //
reg   [15:0]   psw;                 // processor status word
wire  [15:0]   x, xr, xr_ff, xr_rm; // X bus
wire  [15:0]   y, yr, yr_ff, yr_rm; // Y bus
wire  [15:0]   f;                   // ALU function inverted output
wire  [15:0]   h;                   // half summ
wire  [15:0]   c;                   // carry
wire  [15:0]   cpred;               // carry form preceding but
reg            cl;                  // inserted least bit carry
                                    //
wire  [1:0]    fmux;                //
wire  [3:0]    flag;                //
wire           fbit7, fbit15;       //
wire  [7:1]    fctl;                //
wire           fbitc;               //
                                    //
reg            alu_b, alu_c;        // ALU function selector
reg            alu_d, alu_e;        // registered for speed
reg            alu_s, alu_x;        //
                                    //
wire           cl_fc;               //
wire           alu_b_fc;            //
wire           alu_c_fc;            //
wire           alu_d_fc;            //
wire           alu_e_fc;            //
wire           alu_x_fc;            //
wire           alu_s_fc;            //
                                    //
wire  [15:0]   alu;                 // ALU output to X/Y bus
wire  [15:0]   axy;                 // AND product
wire  [15:0]   oxy;                 // OR product
                                    //
reg            ustb, ustb_h;        //
reg            ustb1, ustb1_h;      //
reg            ustb1_hl;            //
                                    //
reg            alu_busy_fp;         // ALU busy (not ready phase shifted)
reg            alu_busy_rp;         //
reg            alu_nrdy;            // ALU not ready
wire           alu_qrdy;            // Qbus data ready
                                    //
reg            au_alsl, au_alsh;    // ALU result strobes
wire           au_qsx, au_qsy;      // qbus temporary register
wire           au_pswx, au_pswy;    // PSW read enable
wire           au_pstbx;            // PSW write strobe
wire           au_astb;             //
wire           au_qstbx;            //
wire           au_qstbd;            //
wire           au_is0, au_is1;      // ALU X argument strobes
wire           au_qrdd;             //
reg            au_ta0;              //
                                    //
reg            au_astb_xa;          // au_astb/au_qstb speed optimizers
reg            au_qstb_xa;          //
reg            au_astb_xu;          //
reg            au_qstb_xu;          //
                                    //
wire  [15:0]   qrd;                 // qbus byte swap data
wire  [15:0]   nx;                  //
reg   [15:0]   qreg;                // ALU Q register (Q-bus data)
reg   [15:0]   areg;                // ALU A register (Q-bus address)
reg   [15:0]   xreg;                // ALU X parameter register
reg   [15:0]   yreg;                // ALU Y parameter register

//______________________________________________________________________________
//
// synopsys translate_off
initial
begin
   plm[33:0]   = 34'o000000000000;
   psw[15:0]   = 16'o000000;
end
// synopsys translate_on
//______________________________________________________________________________
//
// External connection assignments
//
assign wb_pio_dat_i  = pin_ad_in;
assign wb_cpu_dat_i  = pin_ad_in;

assign pin_init_out  = init_out[0] | reset_rc;
assign pin_ad_out    = d;
assign pin_ad_ena    = ad_oe;
assign pin_dout_out  = dout_out & dout_out_l;
assign pin_din_out   = din_out;
assign pin_wtbt      = (sync_stb & ~plrt[8]) | (dout_ext & plrt[6]);
assign pin_sync_out  = sync_out;
assign pin_sync_ena  = sync_ena | sync_out;
assign pin_ctrl_ena  = qbus_win | iako_oe;
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
// assign ir_clr        = ~tplm_rc[3] & ~ir_seq_rc & (tplm[3] | ir_seq);
assign ir_clr           = (~tplm_rc[3] & tplm[3])
                        | (~ir_seq_rc & ir_seq);
//
// tplm1 - instruction prefetch
// tplm3 - instruction fetch
//
assign ir_seq_rc  = ~mjres & ~mjres_rc
                  & (~ir_seq | tplm[1] | tplm[3])
                  & (plm23_wait | ir_seq);
always @(posedge pin_clk_p)
                  ir_seq <= ir_seq_rc;

assign plm_ena_fc = ~sop_out[0] & (mjres | ustb1_h | ~alu_busy_rp) & ~qbus_nrdy;
always @(posedge pin_clk_n)
begin
   plm_ena <= plm_ena_fc;
end

assign sop_up = sop_out[3] | (~sop_out[2] & ~sop_out[1]);
always @(posedge pin_clk_p)
begin
   sop_out[2] <= sop_out[1];

   if (plm_stb_rc)
      sop_out[0] <= 1'b0;
   else
      if (mjres_rc | plm_ena)
         sop_out[0] <= 1'b1;
end

always @(posedge pin_clk_n)
begin
   sop_out[1] <= sop_out[0];
   sop_out[3] <= ir_stop | pli_nrdy | ir_stb2 | mjres_h | (alu_nrdy & (plop[0] | plop[4]));
end

assign plm_stb_rc = ~plm_stb & ~sop_up;
always @(posedge pin_clk_p) plm_stb <= plm_stb_rc;

always @(posedge pin_clk_n or posedge mjres)
begin
   if (mjres)
      ustb <= 1'b0;
   else
   begin
      if (ustb_h)
         ustb <= 1'b0;
      else
         if ((alu_busy_rp | (alu_busy_fp & ~ustb1_h)) & alu_qrdy)
            ustb <= 1'b1;
   end
end

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      ustb_h <= 1'b0;
   else
      ustb_h <= ustb;
end
always @(posedge pin_clk_n) ustb1    <= ustb_h;
always @(posedge pin_clk_p) ustb1_h  <= ustb1;
always @(posedge pin_clk_n) ustb1_hl <= ustb1_h;

always @(posedge pin_clk_n or posedge mjres)
begin
   if (mjres)
      alu_busy_fp <= 1'b0;
   else
      alu_busy_fp <= alu_busy_rp;
end

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      alu_busy_rp <= 1'b0;
   else
      if (plm2x)
         alu_busy_rp <= 1'b1;
      else
         if (ustb1)
            alu_busy_rp <= 1'b0;
end

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      alu_nrdy <= 1'b0;
   else
      if (plm2x)
         alu_nrdy <= 1'b1;
      else
         if (ustb1_h)
            alu_nrdy <= 1'b0;
end

assign ir_stb1 = tplm[1] | tplm[3];
assign ir_set_fc  = plm23_fc[0] | plm23_fc[1] | plm23_fc[3];
always @(posedge pin_clk_n) ir_set <= ir_set_fc;
always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      ir_stb2 <= 1'b0;
   else
   begin
      if (ir_clr)
         ir_stb2 <= 1'b0;
      else
         if (ir_set)
            ir_stb2 <= 1'b1;
   end
end

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      ir_stop <= 1'b0;
   else
      if (~reg_csr[0])
         ir_stop <= 1'b0;
      else
         if (ir_clr)
            ir_stop <= 1'b1;
end

always @(posedge pin_clk_n or posedge mjres)
begin
   if (mjres)
      tplmz <= 3'b000;
   else
      if (plm_ena_fc)
      begin
         tplmz[1] <= (plm[3:1] == 3'b100);
         tplmz[2] <= (plm[3:1] == 3'b010);
         tplmz[3] <= (plm[3:1] == 3'b011);
      end
end

assign tplm_rc[1] = ~(mjres | mjres_rc | din_done) & ((uplr_stb & tplmz[1]) | tplm[1]);   // instruction early prefetch
assign tplm_rc[2] = ~(mjres | mjres_rc | din_done) & ((uplr_stb & tplmz[2]) | tplm[2]);   // data retrieving
assign tplm_rc[3] = ~(mjres | mjres_rc | din_done) & ((uplr_stb & tplmz[3]) | tplm[3]);   // instruction fetch
always @(posedge pin_clk_p) tplm <= tplm_rc;

always @(posedge pin_clk_p)
begin
//
//    plr[6]   QBUS operation type: byte operation flag
//    plr[7]   QBUS operation type: write flag
//    plr[8]   QBUS operation type: read flag
//                00x - nothing
//                010 - write word
//                011 - write byte
//                100 - read word
//                101 - read byte
//                110 - read-modify-write word
//                111 - read-modify-write byte
//
   plrtz[6] <= plr[6];
   plrtz[7] <= plr[7] & plr[8];
   plrtz[8] <= plr[8];

   //
   // Reset Read Flag after read completion within
   // read-modify-write operations
   //
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
assign qbus_done = (din_done & ~plrt[7]) | dout_done | mjres;
always @(posedge pin_clk_p) iako_out_lh <= iako_out;
assign iako_out   = din_out & iak_flag;
//
// Master processor never asserts DMR_OUT
//
assign dmr_out = dmr_req & (pin_pa != 2'b00);
//
// Reply acknowlegement latches
// (converted to flip-flops approach)
//
assign rply_ack_fc = (pin_rply_in & pin_bsy);
always @(posedge pin_clk_p) rply_ack[1] <= rply_ack_fc;
always @(posedge pin_clk_n) rply_ack[2] <= rply_ack[1];
always @(posedge pin_clk_p) rply_ack[3] <= rply_ack[2];

assign alu_qrdy = (~qbus_adr | plr[23] | (~plr[7] & ~plr[8]))  // wait for areg free
                & (~dout_req | plr[23] | plr[7] | plr[8])      // wait for write complete
                & (plr[10] | (~tplm[2] & ~iak_flag));          // wait for data or vector fetch

always @(posedge pin_clk_p)
begin
   if (uplr_stb)
      qbus_adr <= 1'b1;
   else
      if (mjres | mjres_rc | sync_fedge)
         qbus_adr <= 1'b0;
end

assign dmr_req_rc = ~(~sync_out & qbus_win) & (au_astb | dmr_req);
always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      dmr_req <= 1'b0;
   else
      dmr_req <= dmr_req_rc;
end
always @(posedge pin_clk_n) dmr_req_l <= dmr_req;

assign dout_req_rc = (~plrt[8] & au_qstbx & (dmr_req_rc | qbus_own_rp)) | (~qbus_done & dout_req);
always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      dout_req <= 1'b0;
   else
      dout_req <= dout_req_rc;
end

assign dout_ext   = dout_out | dout_out_l;
assign dout_start = dout_req_rc & qbus_flag_rc & ~rply_ack[2]; // originally ~rply_ack[1]

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      dout_out <= 1'b0;
   else
      if (dout_done)
         dout_out <= 1'b0;
      else
         if (dout_start)
            dout_out <= 1'b1;
end

always @(posedge pin_clk_n)
begin
   dout_done  <= rply_ack[1] & dout_out;
   dout_out_l <= dout_out;
end

assign din_start    = oe_set | (plrt[8] & sync_fedge);
assign din_done     = din_out_l & (rply_ack[3] | rply_ack[2]);
always @(posedge pin_clk_n) din_out_l <= din_out;
always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      din_out <= 1'b0;
   else
      if (din_done)
         din_out <= 1'b0;
      else
         if (din_start)
            din_out <= 1'b1;
end

assign qbus_tena = dout_out | din_out;
assign oe_clr_fc = mjres | (~rply_ack_fc & rply_ack[1] & ~qbus_flag);
assign oe_set_fc = qbus_gnt & iak_flag & ~dmr_req & ~qbus_own;
always @(posedge pin_clk_n)
begin
   if (oe_clr_fc)
      iako_oe <= 1'b0;
   else
      if (oe_set_fc)
         iako_oe <= 1'b1;
   oe_clr <= oe_clr_fc;
   oe_set <= oe_set_fc;
end

assign sync_stb   = qbus_win & (~sync_out_h | ~qbus_win_h);
assign sync_fedge = sync_out & ~sync_ena;
always @(posedge pin_clk_n)
begin
   if (oe_clr_fc)
      qbus_win <= 1'b0;
   else
      if (dmr_req & qbus_gnt)
         qbus_win <= 1'b1;
end
always @(posedge pin_clk_p)
begin
   qbus_win_h <= qbus_win;
   sync_out_h <= sync_out;
end
always @(posedge pin_clk_n)
begin
   sync_out <= qbus_win_h;
   sync_ena <= sync_out_h;
end

assign qbus_yield = ~iako_oe & ~qbus_own & (pin_pa[1:0] == 2'b00) & pin_dmr_in;
assign qbus_free  = ~(pin_dmr_in | pin_sack_in | (pin_pa[1:0] != 2'b00));
assign qbus_gnt   = (qbus_nosr_h | (sync_out_h & ~qbus_win_h))
                  & (qbus_free_h | (dmr_out & sack_out));
assign qbus_nosr_rc = ~pin_rply_in & ~pin_sync_in;

always @(posedge pin_clk_p) qbus_free_h <= qbus_free;
always @(posedge pin_clk_p) qbus_nosr_h <= qbus_nosr_rc;
always @(posedge pin_clk_n) qbus_gnt_l <= qbus_gnt;

assign qbus_own = qbus_own_fp | qbus_own_rp;
always @(posedge pin_clk_p)
begin
   if (qbus_done)
      qbus_own_rp <= 1'b0;
   else
      if (dmr_req_l & qbus_gnt_l)
         qbus_own_rp <= 1'b1;
end
always @(posedge pin_clk_n)
begin
   if (qbus_own_rp)
      qbus_own_fp <= 1'b0;
   else
      if (dmr_req & qbus_gnt)
         qbus_own_fp <= 1'b1;
end

assign qbus_flag_rc = ~qbus_done & (sync_fedge | qbus_flag);
always @(posedge pin_clk_p) qbus_flag <= qbus_flag_rc;

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      sack_out <= 1'b0;
   else
      if (qbus_done)
         sack_out <= 1'b0;
      else
         if (pin_dmgi & (qbus_nosr_rc | (sync_out & ~qbus_win)) & qbus_req)
            sack_out <= 1'b1;
end

always @(posedge pin_clk_n) dmgi_in_l <= pin_dmgi;
assign dmgo_out = qbus_yield | (~qbus_req & dmgi_in_l);
always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      qbus_req <= 1'b0;
   else
      if (qbus_done)
         qbus_req <= 1'b0;
      else
         if (dmr_out & ~pin_dmgi)
            qbus_req <= 1'b1;
end

//______________________________________________________________________________
//
// 1801BM1 can issue preliminary transaction address, so the plm->plr strobe
// should be delayed till current transaction in progess completed
//
assign qbus_nrdy = (qbus_aseq[1] & ~oe_clr) | (au_astb & qbus_aseq[0] & ~oe_clr);
assign uplr_stb  = (au_astb & ~qbus_aseq[0])
                 | (au_astb &  qbus_aseq[0] & oe_clr)
                 | qbus_aseq[1] & oe_clr;

always @(posedge pin_clk_n or posedge mjres)
begin
   if (mjres)
      qbus_aseq <= 2'b00;
   else
   begin
      //
      // Reset the completed request if it is only one
      //
      if (au_astb)
         qbus_aseq[0] <= 1'b1;
      else
         if (oe_clr & ~qbus_aseq[1])
            qbus_aseq[0] <= 1'b0;
      //
      // The third request is impossible - the state machine
      // is suspended by qbus_nrdy
      //
      if (oe_clr)
         qbus_aseq[1] <= 1'b0;
      else
         if (au_astb & qbus_aseq[0])
            qbus_aseq[1] <= 1'b1;
   end
end
//______________________________________________________________________________
//
assign   d        = ((sel_in & sel_00) ? {11'o3777, pin_pa, reg_csr}  : 16'o000000)
                  | ((sel_in & sel_02) ? 16'o177777                   : 16'o000000)
                  | ((sel_in & sel_04) ? {8'o377, reg_err}            : 16'o000000)
                  | ((sel_in & (sel_06 | sel_10 | sel_12)) ? tve_d    : 16'o000000)
                  | (sync_stb          ? areg                         : 16'o000000)
                  | (au_qrdd           ? qrd                          : 16'o000000);

assign   qrd      = au_ta0 ? {qreg[7:0], 8'o000} : (plrt[6] ? {8'o000, qreg[7:0]} : qreg);

assign   sel177x  = (pin_ad_in[15:6] == 10'o1777) & (pin_ad_in[5:4] == pin_pa[1:0]);
assign   sel_in   = sel_xx & pin_din_in;
assign   sel_out  = sel_xx & pin_dout_in;
assign   ad_oe    = sync_stb | dout_ext | ~(sel_16 | sel_14 | ~sel_in);

vm1_timer   timer
(
   .tve_clk(pin_clk_p),
   .tve_ena(pin_ena),
   .tve_reset(pin_init_out | pin_init_in),
   .tve_dclo(pin_dclo),
   .tve_sp(pin_sp),
   .tve_din(wb_pio_dat_i),
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
//
// original 1801BM1 timer has 1/8 input prescaler which is no reset and
// provides bus timeout in a range 56..63 processor clocks. This model
// emulates the average value 60 clocks.
//
// Timeout exception request should be synchronized with raising clk's edge
//
always @(posedge pin_clk_p)
begin
   qbus_tovf <= &qbus_timer[5:2];
end

always @(posedge pin_clk_n or negedge qbus_tena)
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
always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      reg_csr <= 3'b000;
   else
   begin
      //
      // Bit 0 of control register
      //
      if ((plm1x_hl & ~plr[25]) | (ir_set & reg_csr[1]))
         reg_csr[0] <= 1'b1;
      else
         if (sel_out & sel_00)
            reg_csr[0] <= wb_pio_dat_i[0];
      //
      // Bit 1 of control register (controls set of bit 0)
      //
      if (sel_out & sel_00)
         reg_csr[1] <= wb_pio_dat_i[1];
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
               reg_csr[2] <= wb_pio_dat_i[2];
   end
end

//
// Error register at 177704
// Bit 0 is Double Error
// Bit 1 is Undefine Opcode
// Bit 5 is not used (always read as one)
// Bit 6 is Odd Address Trap (is not implmented)
//
always @(posedge pin_clk_p)
begin
   if (reset_rc | ir_set)
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
            reg_err[0] <= wb_pio_dat_i[0];
      //
      // Bit 1 - undefined opcode
      //
      if (exc_uop)
         reg_err[1] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[1] <= wb_pio_dat_i[1];
      //
      // Bit 2 & 3 - unknown error, exceptions not implemented
      //
      if (exc_err2)
         reg_err[2] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[2] <= wb_pio_dat_i[2];

      if (exc_err3)
         reg_err[3] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[3] <= wb_pio_dat_i[3];
      //
      // Bit 4 - qbus timeout
      //
      if (qbus_tovf)
         reg_err[4] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[4] <= wb_pio_dat_i[4];
      //
      // Bit 6 - odd address trap
      //
      if (exc_oat)
         reg_err[6] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[6] <= wb_pio_dat_i[6];
      //
      // Bit 7 - unknown error, no exception
      //
      if (exc_err7)
         reg_err[7] <= 1'b1;
      else
         if (sel_out & sel_04)
            reg_err[7] <= wb_pio_dat_i[7];
   end
   //
   // Double error detectors
   //
   if (~exc_uop)     exc_dbl[0] <= reg_err[1];
   if (~qbus_tovf)   exc_dbl[1] <= reg_err[4];
   if (~exc_oat)     exc_dbl[2] <= reg_err[6];
   if (~exc_err7)    exc_dbl[3] <= reg_err[7];
end

always @(posedge pin_clk_p)
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

assign rply_s1 = sel_02 & sel_out & rply_s3;
always @(posedge pin_clk_n) rply_s3 <= ~rply_s2;
always @(posedge pin_clk_n) rply_s2 <= start_irq;
always @(posedge pin_clk_p)
begin
   //
   // Original circuit contains error
   // The start_irq request is reset by interrupt ack and EMT execution (last one is wrong)
   //
   if (reset | ((vsel[2:0] == 3'b110) & (plr[28:25] == 4'b0010) & ((plr[13] & ~plr[14]) | plr[11])))
      start_irq <= 1'b0;
   else
      if (rply_s1)
         start_irq <= 1'b1;
end

//______________________________________________________________________________
//
// Interrupt controller
//
assign pli = VM1_CORE_MULG_VERSION ? pli_g : pli_a;

vm1g_pli  pli_matrix_g(.rq(rq), .sp(pli_g));
vm1a_pli  pli_matrix_a(.rq(rq), .sp(pli_a));

always @(posedge pin_clk_p)
begin
   rq[0]  <= psw[10];
   rq[1]  <= plir[0];   // pli4r
   rq[2]  <= psw[11];
   rq[3]  <= uop;
   rq[4]  <= psw[7];
   rq[9]  <= qbto;
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

//
// Odd address trap detector is blocked on 1801BM1
//
assign exc_oat  = 1'b0;
assign exc_uop  = plm_ena & plr[12];
assign exc_err2 = plm1x_hl & ~plr[26];
assign exc_err3 = plm1x_hl & ~plr[28];
assign exc_err7 = plm1x_hl & ~plr[30];

always @(posedge pin_clk_p or posedge reset)
begin
   if (reset)
      plir[0] <= 1'b0;
   else
      if (pli_stb)
         plir[0] <= pli[4];
end

always @(posedge pin_clk_p)
begin
   if (pli_stb)
   begin
      plir[1] <= pli[6];
      plir[2] <= pli[8];
      plir[3] <= pli[10];
   end
end
//
// Detector's reset
//
assign aclo_ack = plm1x_hl & ~plr[27] & ~plir[3] & ~plir[2] &  plir[1];
assign uop_ack  = plm1x_hl & ~plr[27] & ~plir[3] & ~plir[2] & ~plir[1];
assign irq2_ack = plm1x_hl & ~plr[27] &  plir[3] &  plir[2] & ~plir[1];
assign irq3_ack = plm1x_hl & ~plr[27] &  plir[3] & ~plir[2] & ~plir[1];
assign tve_ack  = plm1x_hl & ~plr[27] &  plir[3] & ~plir[2] &  plir[1];
//
// ACLO edge detectors
//
always @(posedge pin_clk_p)
begin
   if (reset | aclo_ack)
      aclo <= 1'b0;
   else
      if (~pin_aclo)
         aclo <= 1'b1;

   if (pin_dclo | aclo_ack)
      acok <= 1'b0;
   else
      if (pin_aclo)
         acok <= 1'b1;
end
//
// IRQ2 and IRQ3 falling edge detectors
// Also resettable by internal INIT
//
always @(posedge pin_clk_p)
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
always @(posedge pin_clk_p)
begin
   if (reset | uop_ack)
   begin
      uop  <= 1'b0;
      qbto <= 1'b0;
      ivto <= 1'b0;
   end
   else
   begin
      if (exc_uop) uop <= 1'b1;
      if (qbus_tovf & iako_out) ivto <= 1'b1;
      if (qbus_tovf | exc_oat) qbto <= 1'b1;
   end
end

assign pli_req_rc = plm23_ichk | abort;
assign pli_nrdy = pli_req;
assign pli_stb  = pli_req;

always @(posedge pin_clk_p)
begin
   pli_req <= pli_req_rc;

   if (pli_stb)
      vsel <= {pli[3], ~pli[2], pli[1], pli[0]};
   else
      if (plm1x)
         vsel <= {plr[18], ~plr[20], ~plr[21], ~plr[22]};
end

always @(posedge pin_clk_p or posedge mjres)
begin
   if (mjres)
      iak_flag <= 1'b0;
   else
      if (din_done)
         iak_flag <= 1'b0;
      else
         if (plm_ena & (plr[28:25] == 4'b0010) & (plr[11] | (plr[13] & ~plr[14])) & (vsel == 4'b1111))
            iak_flag <= 1'b1;
end

//______________________________________________________________________________
//
// Reset circuits
//
assign mjres_rc = reset_rc | abort_rc;
assign reset_rc = pin_dclo | (pin_aclo & ~init_out[0] & init_out[2]);
assign abort_rc = (qbus_tovf | exc_oat | exc_uop | abort) & ~abort_tm & ~reset_rc;

always @(posedge pin_clk_p)
begin
   reset    <= reset_rc;
   mjres    <= mjres_rc;
   mjres_h  <= mjres;
   abort    <= abort_rc;
   abort_tm <= abort & ~reset_rc;
end

always @(posedge pin_clk_p)
begin
   if (reset_rc)
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

   init_out[1] <= init_out[0];
   init_out[2] <= init_out[1];
end

//______________________________________________________________________________
//
// Microcode state machine
//
assign plx = VM1_CORE_MULG_VERSION ? plx_g : plx_a;

vm1g_plm  plm_matrix_g(.ir(ir), .mr(mj), .sp(plx_g));
vm1a_plm  plm_matrix_a(.ir(ir), .mr(mj), .sp(plx_a));

assign plm1x_fc = plm_ena_fc & ~plm[12] &  (plm[11] & plm[13]);
assign plm2x_fc = plm_ena_fc & ~plm[12] & ~(plm[11] & plm[13]);

                                                         // irq check  wait IR  start IR     Note
assign plm23_fc[0] = plm_ena_fc & (plm[3:1] == 3'b001);  //    no       yes       no         RTT opcode, wait fetch completion
assign plm23_fc[1] = plm_ena_fc & (plm[3:1] == 3'b011);  //    yes      yes       yes        usual IR fetch
assign plm23_fc[2] = plm_ena_fc & (plm[3:1] == 3'b101);  //    yes      no        no         WAIT opcode, check irq only
assign plm23_fc[3] = plm_ena_fc & (plm[3:1] == 3'b111);  //    yes      yes       no         ~RTT opcode, wait fetch completion
always @(posedge pin_clk_n)
begin
   plm23_wait  <= plm23_fc[0] | plm23_fc[3];
   plm23_ichk  <= plm23_fc[1] | plm23_fc[2] | plm23_fc[3];
end

assign plop[0] = ~plr[22] & ~plr[21] & ~plr[4]; // 000
assign plop[1] = ~plr[22] & ~plr[21] &  plr[4]; // 001
assign plop[2] = ~plr[22] &  plr[21] & ~plr[4]; // 010
assign plop[3] = ~plr[22] &  plr[21] &  plr[4]; // 011
assign plop[4] =  plr[22] & ~plr[21] & ~plr[4]; // 100
assign plop[5] =  plr[22] & ~plr[21] &  plr[4]; // 101
assign plop[6] =  plr[22] &  plr[21] & ~plr[4]; // 110
assign plop[7] =  plr[22] &  plr[21] &  plr[4]; // 111

always @(posedge pin_clk_n)
begin
   plm1x    <= plm1x_fc;
   plm2x    <= plm2x_fc;
   plm1x_hl <= plm1x;

   if (plm_ena)
   begin
      psw_stb  <= ~plop[0] & ~plop[2] & ~plop[7];
      psw_stbc <= ~plop[0] & ~plop[1] & ~plop[2] & ~plop[3] & ~plop[7];
      mj_stb1  <= (plop[7] & ir_stb2) | (~plop[1] & ~plop[5] & ~plop[7]);
      mj_stb2  <= (plop[7] & ir_stb2) | (~plop[1] & ~plop[5] & ~plop[7] & ~plop[3]);
      psw_mj   <=  plop[7] & ir_stb2;
   end
end

//
// Instruction register
//
always @(posedge pin_clk_p)
begin
   if (ir_stb1) ira <= wb_cpu_dat_i;
   if (ir_stb2)
      if (ir_stb1)
         ir <= wb_cpu_dat_i;
      else
         ir <= ira;
end

//______________________________________________________________________________
//
always @(posedge pin_clk_n)
begin
   if (plm_ena_fc) plr <= plm;
end

always @(posedge pin_clk_p)
begin
   //
   // Other bits have no reset facility
   //
   if (plm_stb_rc)
   begin
      //
      // Some of plm is not used here (microcode address directly uses plx instead)
      //
      plm <= plx;
   end
end

//______________________________________________________________________________
//
// Microcode register
//
always @(posedge pin_clk_p or posedge abort)
begin
   //
   // The least bit is reset by abort
   // and set by common reset
   //
   if (abort)
      mj[0] <= 1'b0;
   else
      if (reset)
         mj[0] <= 1'b1;
      else
         if (plm_stb_rc)
            mj[0] <= ~plx[29];
end


always @(posedge pin_clk_p or posedge mjres)
begin
   //
   // Least bits are produced directly from main matrix
   // and have the async reset feature (next microcode address)
   //
   if (mjres)
      mj[6:1] <= 6'b111111;
   else
      if (plm_stb_rc)
      begin
         mj[1] <= ~plx[24];
         mj[2] <= ~plx[19];
         mj[3] <=  plx[15];
         mj[4] <=  plx[9];
         mj[5] <=  plx[5];
         mj[6] <= ~plx[0];
      end
end

always @(posedge pin_clk_p)
begin
   if (ustb1_hl)
   begin
      if (mj_stb1)
      begin
         mj[11] <= psw[4];
         mj[10:8] <= psw_mj ? psw[3:1] : freg[3:1];
      end
      if (mj_stb2)
         mj[7]  <= psw_mj ? psw[0] : freg[0];
   end
end

always @(posedge pin_clk_p or posedge mjres)
begin
   //
   // Bits 14:12 poll the interrupt controller state
   //
   if (mjres)
      mj[14:12] <= 3'b000;
   else
      if (pli_stb)
         mj[14:12] <= {~pli[5], ~pli[7], pli[9]};
      else
         if (plm1x)
            mj[14:12] <= {~plr[14], plr[16], ~plr[17]};
end

//______________________________________________________________________________
//
// ALU result flags and PSW
//
always @(posedge pin_clk_n)
begin
   if (au_alsl)
      freg <= flag;
end

always @(posedge pin_clk_n or posedge reset)
begin
   //
   // Start microcode correctly sets the PSW
   // But simulator can not calculate ALU function
   // correctly if PSW in initially undefined
   //
   // The PSW is written by microcode with 340 value
   // while executing reset sequence
   //
   if (reset)
      psw[15:0] <= {6'o00, pin_pa[1:0], 8'o000};
   else
   begin
      if (au_alsl & au_pstbx)
         psw[7:0] <= x[7:0];
      else
      begin
         //
         // Latch the ALU flag results immediately after ALU completion
         // Rollback to the original PSW logic
         //
         if (psw_stbc & ustb1_hl)
            psw[0] <= freg[0];
         if (psw_stb & ustb1_hl)
            psw[3:1] <= freg[3:1];
//
// This does not work correctly for MUL instruction - result flags are wrong
// due to G-version microcode urges to write flags from ALU bus directly
// (au_pstbx active)
//
//       if (psw_stbc & au_alsl)
//          psw[0] <= flag[0];
//       if (psw_stb & au_alsl)
//          psw[3:1] <= flag[3:1];
//
      end
      if (au_alsh & au_pstbx)
      begin
         psw[9:8] <= pin_pa[1:0];
         psw[15:10] <= x[15:10];
      end
   end
end

//
// ALU general purpose registers
//
assign xr = VM1_CORE_REG_USES_RAM ? xr_rm : xr_ff;
assign yr = VM1_CORE_REG_USES_RAM ? yr_rm : yr_ff;

//
// Implement the Register File with library RAM module
//
vm1_reg_ram vreg_rm(
   .clk_p(pin_clk_p),
   .clk_n(pin_clk_n),
   .reset(reset),
   .plr(plr),
   .xbus_in(x),
   .xbus_out(xr_rm),
   .ybus_out(yr_rm),
   .wstbl(au_alsl),
   .wstbh(au_alsh),
   .ireg(ir),
   .vsel(vsel),
   .pa(pin_pa),
   .carry(psw[0]));

//
// Implement the Register File with Flip-Flops array
// The constant generator can be built in the File
// in some implementations
//
vm1_reg_ff vreg_ff(
   .clk_p(pin_clk_p),
   .clk_n(pin_clk_n),
   .reset(reset),
   .plr(plr),
   .xbus_in(x),
   .xbus_out(xr_ff),
   .ybus_out(yr_ff),
   .wstbl(au_alsl),
   .wstbh(au_alsh),
   .ireg(ir),
   .vsel(vsel),
   .pa(pin_pa),
   .carry(psw[0]));

assign au_pswy = (plr[28:25] == 4'b1000) & ~plr[11] & ~plr[13];
assign au_qsy  = (plr[28:25] == 4'b0000) & ~plr[11] & ~plr[13];
assign au_pswx = (plr[33:30] == 4'b1000);
assign au_qsx  = (plr[33:30] == 4'b0000);

always @(posedge pin_clk_n) au_alsl <= alu_busy_rp & ustb_h;
always @(posedge pin_clk_n) au_alsh <= alu_busy_rp & ustb_h & plr[18];

assign au_is0  = ~(plr[13] & plr[14] & plr[25] & plr[26] & ~plr[27]);
assign au_is1  =  (plr[13] & plr[14] & plr[25] & plr[26] & ~plr[27]);

assign au_qrdd  = dout_ext;
assign au_qstbd = iako_out | tplm[2];

assign au_pstbx = (plr[33:30] == 4'b1000) & plr[20];
//
// Original strobes:
//
// assign au_astb  = (au_alsl & ~(~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]))
//                 | (   ustb &  (~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]));
// assign au_qstbx = (au_alsl & ~(~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8])
//                 | (   ustb &  (~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8]);
//
// Speed-optimized strobes:
//
assign au_astb  = au_astb_xa | (ustb & au_astb_xu);
assign au_qstbx = au_qstb_xa | (ustb & au_qstb_xu);
always @(posedge pin_clk_n)
begin
   au_astb_xa  <= alu_busy_rp & ustb_h & ~(~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]);
   au_qstb_xa  <= alu_busy_rp & ustb_h & ~(~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8];
   au_astb_xu  <= (~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]);
   au_qstb_xu  <= (~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8];
end
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
assign x[15:0] = au_alsl ? (au_alsh ? alu[15:0] : {8'o000, alu[7:0]}) :
               ( xr
               | (au_qsx  ? qreg : 16'o000000)
               | (au_pswx ? psw  : 16'o000000));

assign y[15:0] = ~(yr
               | (au_qsy  ? qreg : 16'o000000)
               | (au_pswy ? psw  : 16'o000000));
//
// ALU qbus register
//
// Note: pin_clk_n has been changed to pin_clk_p to provide
// valid data before nDOUT falling edge, but it reduced the Fmax
//
always @(posedge pin_clk_p)
begin
   if (au_qstbx)
      qreg[7:0] <= x[7:0];
   else
      if (au_qstbd)
         qreg[7:0] <= (au_ta0 ? wb_cpu_dat_i[15:8] : wb_cpu_dat_i[7:0]);

   if (au_qstbx)
      qreg[15:8] <= x[15:8];
   else
      if (au_qstbd)
         qreg[15:8] <= wb_cpu_dat_i[15:8];
end

always @(posedge pin_clk_n)
begin
   if (au_astb)
      areg <= x;
end
//
// Transaction address low bit latch
//
always @(posedge pin_clk_p)
begin
   if (sync_stb)
      au_ta0 <= areg[0] & plrt[6];
end
//______________________________________________________________________________
//
// ALU function unit
//
assign nx  = alu_x ? ~xreg : xreg;
//
// ALU input parameters (from X and Y buses) registers
//
always @(posedge pin_clk_n)
begin
   if (au_is0)
      xreg[15:0] <= x[15:0];
   else
      if (au_is1)
         xreg[15:0] <= {x[7:0], x[15:8]};
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
assign cl_fc      = ~plr[16] | (plr[17] & alu_e_fc);
assign alu_b_fc   = plr[17] & (plr[16] | (~plr[13] & ~plr[14]));
assign alu_c_fc   = (~plr[13] & (plr[16] ^ plr[17])) | (~alu_e_fc & ~plr[17]);
assign alu_d_fc   = ~alu_e_fc & plr[16] & plr[17];
assign alu_e_fc   = (~plr[13] & plr[14]) | (~plr[16] & plr[17]);
assign alu_x_fc   =  plr[16] & ~plr[17] & ~alu_e_fc;
assign alu_s_fc   =  ~plr[13] | ~plr[14] | (plr[25] & plr[26]);

always @(posedge pin_clk_n)
begin
   cl    <= cl_fc;
   alu_b <= alu_b_fc;
   alu_c <= alu_c_fc;
   alu_d <= alu_d_fc;
   alu_e <= alu_e_fc;
   alu_x <= alu_x_fc;
   alu_s <= alu_s_fc;
end
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
assign alu     = ~(alu_s ? f : (plr[27] ? {fbit15, f[15:9], fbit7, f[7:1]} : {f[14:0], fbitc}));

//
// ALU result condition flags
//
assign flag[0] = alu_s ? ~fmux[0] : ~fmux[1];                               // C
assign flag[2] = (~plr[18] | (alu[15:8] == 8'o000)) & (alu[7:0] == 8'o000); // Z
assign flag[3] = plr[18] ? alu[15] : alu[7];                                // N
assign flag[1] = ~(alu_s & alu_e)                                           // V
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
   4'b1110: vmux = 16'o000000;      // start @177704
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
// Register file, flip-flops implementation
//
module vm1_reg_ff
(
   input          clk_p,      //
   input          clk_n,      //
   input          reset,      //
   input  [33:0]  plr,        // control matrix
   input  [15:0]  xbus_in,    // X bus input
   output [15:0]  xbus_out,   // X bus output
   output [15:0]  ybus_out,   // Y bus output
   input          wstbl,      // write strobe low byte
   input          wstbh,      // write strobe high byte
                              //
   input  [15:0]  ireg,       // instruction register
   input  [3:0]   vsel,       // interrupt vector selector
   input  [1:0]   pa,         // processor number
   input          carry       // carry flag
);
wire  vc_vsel, vc_csel;
reg   [3:0]    vc_vreg;
wire  [15:0]   vc_vcd;        // vector/constant data
wire  [13:0]   rs0, rs1, rsw; // register select
reg   [15:0]   gpr[0:13];     // register array

reg   [3:0]    xadr;
reg   [3:0]    yadr;

always @(posedge clk_n)
begin
   xadr <= plr[33:30];
   yadr <= plr[28:25];
end

always @(posedge clk_n)
begin
   vc_vreg <= vsel;
end
assign vc_vsel = (plr[28:25] == 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);
assign vc_csel = (plr[28:25] != 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);

vm1_vgen vgen(
   .ireg(ireg),         // instruction register
   .vsel(vc_vreg),      // vector output selection
   .csel(plr[28:25]),   // constant output selection
   .vena(vc_vsel),      // vector output enable
   .cena(vc_csel),      // constant output enable
   .carry(carry),       // carry flag psw[0]
   .pa(pa),             // processor number
   .value(vc_vcd)       // output vector value
);

assign rs0[0]  = (yadr == 4'b1111) & ~plr[11] & ~plr[13];
assign rs0[1]  = (yadr == 4'b0111) & ~plr[11] & ~plr[13];
assign rs0[2]  = (yadr == 4'b1011) & ~plr[11] & ~plr[13];
assign rs0[3]  = (yadr == 4'b0011) & ~plr[11] & ~plr[13];
assign rs0[4]  = (yadr == 4'b1101) & ~plr[11] & ~plr[13];
assign rs0[5]  = (yadr == 4'b0101) & ~plr[11] & ~plr[13];
assign rs0[6]  = (yadr == 4'b1001) & ~plr[11] & ~plr[13];
assign rs0[7]  = (yadr == 4'b0001) & ~plr[11] & ~plr[13];
assign rs0[8]  = (yadr == 4'b1110) & ~plr[11] & ~plr[13];
assign rs0[9]  = (yadr == 4'b0110) & ~plr[11] & ~plr[13];
assign rs0[10] = (yadr == 4'b1010) & ~plr[11] & ~plr[13];
assign rs0[11] = (yadr == 4'b0010) & ~plr[11] & ~plr[13];
assign rs0[12] = (yadr == 4'b1100) & ~plr[11] & ~plr[13] | (plr[13] & plr[14]);
assign rs0[13] = (yadr == 4'b0100) & ~plr[11] & ~plr[13];

assign rs1[0]  = (xadr == 4'b1111);
assign rs1[1]  = (xadr == 4'b0111);
assign rs1[2]  = (xadr == 4'b1011);
assign rs1[3]  = (xadr == 4'b0011);
assign rs1[4]  = (xadr == 4'b1101);
assign rs1[5]  = (xadr == 4'b0101);
assign rs1[6]  = (xadr == 4'b1001);
assign rs1[7]  = (xadr == 4'b0001);
assign rs1[8]  = (xadr == 4'b1110);
assign rs1[9]  = (xadr == 4'b0110);
assign rs1[10] = (xadr == 4'b1010);
assign rs1[11] = (xadr == 4'b0010);
assign rs1[12] = (xadr == 4'b1100);
assign rs1[13] = (xadr == 4'b0100);

assign rsw[0]  = (xadr == 4'b1111) & plr[20];
assign rsw[1]  = (xadr == 4'b0111) & plr[20];
assign rsw[2]  = (xadr == 4'b1011) & plr[20];
assign rsw[3]  = (xadr == 4'b0011) & plr[20];
assign rsw[4]  = (xadr == 4'b1101) & plr[20];
assign rsw[5]  = (xadr == 4'b0101) & plr[20];
assign rsw[6]  = (xadr == 4'b1001) & plr[20];
assign rsw[7]  = (xadr == 4'b0001) & plr[20];
assign rsw[8]  = (xadr == 4'b1110) & plr[20];
assign rsw[9]  = (xadr == 4'b0110) & plr[20];
assign rsw[10] = (xadr == 4'b1010) & plr[20];
assign rsw[11] = (xadr == 4'b0010) & plr[20];
assign rsw[12] = (xadr == 4'b1100) | ~plr[20];
assign rsw[13] = (xadr == 4'b0100) & plr[20];

assign xbus_out = (rs1[0]  ? gpr[0]  : 16'o000000)
               |  (rs1[1]  ? gpr[1]  : 16'o000000)
               |  (rs1[2]  ? gpr[2]  : 16'o000000)
               |  (rs1[3]  ? gpr[3]  : 16'o000000)
               |  (rs1[4]  ? gpr[4]  : 16'o000000)
               |  (rs1[5]  ? gpr[5]  : 16'o000000)
               |  (rs1[6]  ? gpr[6]  : 16'o000000)
               |  (rs1[7]  ? gpr[7]  : 16'o000000)
               |  (rs1[8]  ? gpr[8]  : 16'o000000)
               |  (rs1[9]  ? gpr[9]  : 16'o000000)
               |  (rs1[10] ? gpr[10] : 16'o000000)
               |  (rs1[11] ? gpr[11] : 16'o000000)
               |  (rs1[12] ? gpr[12] : 16'o000000)
               |  (rs1[13] ? gpr[13] : 16'o000000);


assign ybus_out = (rs0[0]  ? gpr[0]  : 16'o000000)
               |  (rs0[1]  ? gpr[1]  : 16'o000000)
               |  (rs0[2]  ? gpr[2]  : 16'o000000)
               |  (rs0[3]  ? gpr[3]  : 16'o000000)
               |  (rs0[4]  ? gpr[4]  : 16'o000000)
               |  (rs0[5]  ? gpr[5]  : 16'o000000)
               |  (rs0[6]  ? gpr[6]  : 16'o000000)
               |  (rs0[7]  ? gpr[7]  : 16'o000000)
               |  (rs0[8]  ? gpr[8]  : 16'o000000)
               |  (rs0[9]  ? gpr[9]  : 16'o000000)
               |  (rs0[10] ? gpr[10] : 16'o000000)
               |  (rs0[11] ? gpr[11] : 16'o000000)
               |  (rs0[12] ? gpr[12] : 16'o000000)
               |  (rs0[13] ? gpr[13] : 16'o000000)
               |  (vc_vsel ? vc_vcd  : 16'o000000)
               |  (vc_csel ? vc_vcd  : 16'o000000);

always @(posedge clk_n)
begin
   if (wstbl)
   begin
      if (rsw[0])  gpr[0][7:0]  <= xbus_in[7:0];
      if (rsw[1])  gpr[1][7:0]  <= xbus_in[7:0];
      if (rsw[2])  gpr[2][7:0]  <= xbus_in[7:0];
      if (rsw[3])  gpr[3][7:0]  <= xbus_in[7:0];
      if (rsw[4])  gpr[4][7:0]  <= xbus_in[7:0];
      if (rsw[5])  gpr[5][7:0]  <= xbus_in[7:0];
      if (rsw[6])  gpr[6][7:0]  <= xbus_in[7:0];
      if (rsw[7])  gpr[7][7:0]  <= xbus_in[7:0];
      if (rsw[8])  gpr[8][7:0]  <= xbus_in[7:0];
      if (rsw[9])  gpr[9][7:0]  <= xbus_in[7:0];
      if (rsw[10]) gpr[10][7:0] <= xbus_in[7:0];
      if (rsw[11]) gpr[11][7:0] <= xbus_in[7:0];
      if (rsw[12]) gpr[12][7:0] <= xbus_in[7:0];
      if (rsw[13]) gpr[13][7:0] <= xbus_in[7:0];
   end
   if (wstbh)
   begin
      if (rsw[0])  gpr[0][15:8]  <= xbus_in[15:8];
      if (rsw[1])  gpr[1][15:8]  <= xbus_in[15:8];
      if (rsw[2])  gpr[2][15:8]  <= xbus_in[15:8];
      if (rsw[3])  gpr[3][15:8]  <= xbus_in[15:8];
      if (rsw[4])  gpr[4][15:8]  <= xbus_in[15:8];
      if (rsw[5])  gpr[5][15:8]  <= xbus_in[15:8];
      if (rsw[6])  gpr[6][15:8]  <= xbus_in[15:8];
      if (rsw[7])  gpr[7][15:8]  <= xbus_in[15:8];
      if (rsw[8])  gpr[8][15:8]  <= xbus_in[15:8];
      if (rsw[9])  gpr[9][15:8]  <= xbus_in[15:8];
      if (rsw[10]) gpr[10][15:8] <= xbus_in[15:8];
      if (rsw[11]) gpr[11][15:8] <= xbus_in[15:8];
      if (rsw[12]) gpr[12][15:8] <= xbus_in[15:8];
      if (rsw[13]) gpr[13][15:8] <= xbus_in[15:8];
   end
end

// synopsys translate_off
initial
begin
   gpr[0]   = 16'o000000;
   gpr[1]   = 16'o000000;
   gpr[2]   = 16'o000000;
   gpr[3]   = 16'o000000;
   gpr[4]   = 16'o000000;
   gpr[5]   = 16'o000000;
   gpr[6]   = 16'o000000;
   gpr[7]   = 16'o000000;
   gpr[8]   = 16'o000000;
   gpr[9]   = 16'o000000;
   gpr[10]  = 16'o000000;
   gpr[11]  = 16'o000000;
   gpr[12]  = 16'o000000;
   gpr[13]  = 16'o000000;
   gpr[0]   = 16'o000000;
end
// synopsys translate_on
endmodule

//______________________________________________________________________________
//
// Register file, RAM implementation
//
module vm1_reg_ram
(
   input          clk_p,      //
   input          clk_n,      //
   input          reset,      //
   input  [33:0]  plr,        // control matrix
   input  [15:0]  xbus_in,    // X bus input
   output [15:0]  xbus_out,   // X bus output
   output [15:0]  ybus_out,   // Y bus output
   input          wstbl,      // write strobe low byte
   input          wstbh,      // write strobe high byte
                              //
   input  [15:0]  ireg,       // instruction register
   input  [3:0]   vsel,       // interrupt vector selector
   input  [1:0]   pa,         // processor number
   input          carry       // carry flag
);
wire  vc_vsel, vc_csel;
reg   [3:0]    vc_reg;
wire  [15:0]   vc_mux;
wire  [5:0]    xadr;
wire  [5:0]    yadr;
wire           wren;

always @(posedge clk_n)
begin
   vc_reg <= vsel;
end

assign vc_vsel = (plr[28:25] == 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);
assign vc_csel = (plr[28:25] != 4'b0010) & ((plr[13] & ~plr[14]) | plr[11]);

assign   wren      = (wstbl & (plr[32:30] != 3'b000) & plr[20]) | (wstbl & ~plr[20]);
assign   xadr[5:0] = {2'b00, wstbl ? (plr[20] ? plr[33:30] : 4'b1100) : plr[33:30]};
assign   yadr[3:0] =  vc_vsel ? vsel :
                     (vc_csel ? plr[28:25] :
                     ((plr[13] & plr[14]) ? 4'b1100 : ((~plr[11] & ~plr[13]) ? plr[28:25] : 4'b0000)));
assign   yadr[4]   = vc_vsel;
assign   yadr[5]   = vc_csel;

vm1_vcram vm1_vcram_reg(
   .clock(clk_n),
   .address_a(xadr),
   .data_a(xbus_in),
   .q_a(xbus_out),
   .byteena_a({wstbh | ~wstbl, 1'b1}),
   .wren_a(wren),
   .address_b(yadr),
   .data_b(16'o000000),
   .wren_b(1'b0),
   .q_b(vc_mux));

assign ybus_out = vc_mux
                | ((vc_vsel & (vc_reg == 4'b0101))     ? {10'o0000, pa, 4'o00}     : 16'o000000)
                | ((vc_vsel & (vc_reg == 4'b1101))     ? ireg                      : 16'o000000)
                | ((vc_csel & (plr[28:25] == 4'b0000)) ? {12'o0000, ireg[3:0]}     : 16'o000000)
                | ((vc_csel & (plr[28:25] == 4'b0100)) ? {9'o000, ireg[5:0], 1'b0} : 16'o000000)
                | ((vc_csel & (plr[28:25] == 4'b1000)) ?
                                      {ireg[7] ? 7'o177 : 7'o000, ireg[7:0], 1'b0} : 16'o000000)
                | ((vc_csel & (plr[28:25] == 4'b1100)) ? {15'o00000, carry}        : 16'o000000);
endmodule
//______________________________________________________________________________
//
