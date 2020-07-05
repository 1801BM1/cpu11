//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//______________________________________________________________________________
//
// Wishbone compatible version of 1801VM1 processor
// has 3 dedicated wishbone interfaces:
//    - master interface - VM1 core itself
//    - slave interface - VM1 peripheral (1777xx registers)
//    - interrupt vector interface - interrupt acknowlegement
//
module vm1_wb
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
   //
   // Processor core clock section:
   //    - vm_clk_p     - processor core positive clock, also feeds the wishbone buses
   //    - vm_clk_n     - processor core negative clock, should be vm_clk_p 180 degree phase shifted
   //    - vm_clk_ena   - slow clock simulation strobe, enables clock at vm_clk_p
   //    - vm_clk_tve   - VE-timer clock enable strobe, enables clock at vm_clk_p
   //    - vm_clk_slow  - clock mode selector, enables clock slowdown simulation,
   //                     the external I/O cycles is launched with rate of vm_clk_ena
   //
   input          vm_clk_p,         // positive clock
   input          vm_clk_n,         // negative clock
   input          vm_clk_ena,       // slow clock enable
   input          vm_clk_tve,       // VE-timer clock enable
   input          vm_clk_sp,        // external pin SP clock
   input          vm_clk_slow,      // slow clock sim mode
                                    //
   input  [1:0]   vm_pa,            // processor number
   input          vm_init_in,       // peripheral reset input
   output         vm_init_out,      // peripheral reset output
                                    //
   input          vm_dclo,          // processor reset
   input          vm_aclo,          // power fail notificaton
   input  [3:1]   vm_irq,           // radial interrupt requests
   input          vm_virq,          // vectored interrupt request
                                    //
   input          wbm_gnt_i,        // master wishbone granted
   output [15:0]  wbm_adr_o,        // master wishbone address
   output [15:0]  wbm_dat_o,        // master wishbone data output
   input  [15:0]  wbm_dat_i,        // master wishbone data input
   output         wbm_cyc_o,        // master wishbone cycle
   output         wbm_we_o,         // master wishbone direction
   output [1:0]   wbm_sel_o,        // master wishbone byte election
   output         wbm_stb_o,        // master wishbone strobe
   input          wbm_ack_i,        // master wishbone acknowledgement
                                    //
   input  [15:0]  wbi_dat_i,        // interrupt vector input
   output         wbi_stb_o,        // interrupt vector strobe
   input          wbi_ack_i,        // interrupt vector acknowledgement
                                    //
   input  [3:0]   wbs_adr_i,        // slave wishbone address
   input  [15:0]  wbs_dat_i,        // slave wishbone data input
   output [15:0]  wbs_dat_o,        // slave wishbone data output
   input          wbs_cyc_i,        // slave wishbone cycle
   input          wbs_we_i,         // slave wishbone direction
   input          wbs_stb_i,        // slave wishbone strobe
   output         wbs_ack_o,        // slave wishbone acknowledgement
                                    //
   input  [15:0]  vm_reg14,         // register 177714 data
   input  [15:0]  vm_reg16,         // register 177716 data
   output [2:1]   vm_sel            // register select outputs
);

//______________________________________________________________________________
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
reg            start_irq;           // raised by 1777x2 register write (disconnected)
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
reg   [5:0]    bus_timer;           // bus timeout counter
reg            bus_tovf;            // bus timer overflow latch
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
reg   [15:0]   wbs_d;               // slave wishbone data register
wire  [15:0]   tve_d;               // timer module data output
reg            wbs_r, wbs_w;        //
reg            wbs_a;               //
wire           wbs_a_rc;            //
                                    //
reg            wsel_00,             // peripheral register selectors
               wsel_02,             //
               wsel_04;             //
                                    //
reg            iak_flag;            //
reg            iak_vreq;            //
reg   [2:0]    init_out;            //
                                    //
wire           bus_done;            //
reg            bus_done_h;          //
reg            bus_clr;             //
reg            bus_own;             //
reg            bus_req;             //
                                    //
wire           bus_nrdy;            //
reg   [1:0]    bus_aseq;            // address request sequencer
wire           din_done;            //
wire           dout_done;           //
reg            dout_req;            //
                                    //
reg            wb_uplr;             // transaction internal request
reg   [15:0]   wb_adr;              // wishbone address register
reg   [15:0]   wb_dat;              // wishbone input data register
                                    //
wire           wb_start;            //
wire           wb_wclr, wb_wset;    //
reg            wb_swait;            //
reg   [9:0]    wb_wcnt;             //
reg            wb_cyc;              //
reg            wb_stb;              //
reg            wb_we;               //
reg   [1:0]    wb_sel;              //
wire           wb_wdone,            //
               wb_rdone,            //
               wb_idone;            //
reg            wb_idone_h;          //
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
wire           alu_qrdy;            // bus data ready
                                    //
reg            au_alsl, au_alsh;    // ALU result strobes
wire           au_qsx, au_qsy;      // bus temporary register
wire           au_pswx, au_pswy;    // PSW read enable
wire           au_pstbx;            // PSW write strobe
wire           au_astb;             //
wire           au_qstbx;            //
reg            au_qstbd;            //
wire           au_xswap;            // ALU X argument strobes
reg            au_ta0;              //
                                    //
reg            au_astb_xa;          // au_astb/au_qstb speed optimizers
reg            au_qstb_xa;          //
reg            au_astb_xu;          //
reg            au_qstb_xu;          //
                                    //
wire  [15:0]   nx;                  //
reg   [15:0]   qreg;                // ALU Q register (Q-bus data output)
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
//
//______________________________________________________________________________
//
assign vm_init_out = init_out[0] | reset_rc;
assign wbm_dat_o   = au_ta0 ? {qreg[7:0], 8'o000} : (plrt[6] ? {8'o000, qreg[7:0]} : qreg);
assign wbm_adr_o   = wb_adr;

//______________________________________________________________________________
//
// Control and glue logic
//
assign ir_clr = (~tplm_rc[3] & tplm[3]) | (~ir_seq_rc & ir_seq);
//
// tplm1 - instruction prefetch
// tplm3 - instruction fetch
//
assign ir_seq_rc  = ~mjres & ~mjres_rc
                  & (~ir_seq | tplm[1] | tplm[3])
                  & (plm23_wait | ir_seq);
always @(posedge vm_clk_p)
                  ir_seq <= ir_seq_rc;

assign plm_ena_fc = ~sop_out[0] & (mjres | ustb1_h | ~alu_busy_rp) & ~bus_nrdy;
always @(posedge vm_clk_n)
begin
   plm_ena <= plm_ena_fc;
end

assign sop_up = sop_out[3] | (~sop_out[2] & ~sop_out[1]);
always @(posedge vm_clk_p)
begin
   sop_out[2] <= sop_out[1];

   if (plm_stb_rc)
      sop_out[0] <= 1'b0;
   else
      if (mjres_rc | plm_ena)
         sop_out[0] <= 1'b1;
end

always @(posedge vm_clk_n)
begin
   sop_out[1] <= sop_out[0];
   sop_out[3] <= ir_stop | pli_nrdy | ir_stb2 | mjres_h | (alu_nrdy & (plop[0] | plop[4]));
end

assign plm_stb_rc = ~plm_stb & ~sop_up;
always @(posedge vm_clk_p) plm_stb <= plm_stb_rc;

always @(posedge vm_clk_n or posedge mjres)
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

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      ustb_h <= 1'b0;
   else
      ustb_h <= ustb;
end
always @(posedge vm_clk_n) ustb1    <= ustb_h;
always @(posedge vm_clk_p) ustb1_h  <= ustb1;
always @(posedge vm_clk_n) ustb1_hl <= ustb1_h;

always @(posedge vm_clk_n or posedge mjres)
begin
   if (mjres)
      alu_busy_fp <= 1'b0;
   else
      alu_busy_fp <= alu_busy_rp;
end

always @(posedge vm_clk_p or posedge mjres)
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

always @(posedge vm_clk_p or posedge mjres)
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
always @(posedge vm_clk_n) ir_set <= ir_set_fc;
always @(posedge vm_clk_p or posedge mjres)
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

always @(posedge vm_clk_p or posedge mjres)
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

always @(posedge vm_clk_n or posedge mjres)
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
always @(posedge vm_clk_p) tplm <= tplm_rc;

always @(posedge vm_clk_p)
begin
//
//    plr[6]   bus operation type: byte operation flag
//    plr[7]   bus operation type: write flag
//    plr[8]   bus operation type: read flag
//                00x - nothing
//                010 - write word
//                011 - write byte
//                100 - read word
//                101 - read byte
//                110 - read-modify-write word
//                111 - read-modify-write byte
//
   plrtz[6] <= plr[6];
   plrtz[7] <= plr[7] & plr[8];  // read-modify-write flag
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
// bus logic (the rest of one, needed as glue core to wishbone interface)
//
assign bus_done = (din_done & ~plrt[7]) | dout_done | mjres;
always @(posedge vm_clk_p) bus_done_h <= bus_done;
//
// Wishbone takes address immediately and core does not need to wait areg
//
assign alu_qrdy = (~dout_req | plr[23] |  (plr[7] | plr[8]))   // wait for write complete
                & (plr[10] | (~tplm[2] & ~iak_flag));          // wait for data or vector fetch

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      dout_req <= 1'b0;
   else
      dout_req <= (~plrt[8] & au_qstbx & (bus_own | bus_req)) | (~bus_done & dout_req);
end

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      bus_own <= 1'b0;
   else
   begin
      if (uplr_stb)
         bus_own <= 1'b1;
      else
         if (bus_done)
            bus_own <= 1'b0;
   end
end

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      bus_req <= 1'b0;
   else
   begin
      if (uplr_stb)
         bus_req <= 1'b0;
      else
         if (au_astb)
            bus_req <= 1'b1;
   end
end


assign din_done   = wb_rdone;
assign dout_done  = wb_wdone;
always @(posedge vm_clk_n) bus_clr  <= mjres | bus_done_h;

//______________________________________________________________________________
//
// 1801BM1 can issue preliminary transaction address, so the plm->plr strobe
// should be delayed till current transaction in progess completed
//
assign bus_nrdy = (bus_aseq[1] & ~bus_clr) | (au_astb & bus_aseq[0] & ~bus_clr);
assign uplr_stb  = (au_astb & ~bus_aseq[0])
                 | (au_astb &  bus_aseq[0] & bus_clr)
                 | bus_aseq[1] & bus_clr;

always @(posedge vm_clk_n or posedge mjres)
begin
   if (mjres)
      bus_aseq <= 2'b00;
   else
   begin
      //
      // Reset the completed request if it is only one
      //
      if (au_astb)
         bus_aseq[0] <= 1'b1;
      else
         if (bus_clr & ~bus_aseq[1])
            bus_aseq[0] <= 1'b0;
      //
      // The third request is impossible - the state machine
      // is suspended by bus_nrdy
      //
      if (bus_clr)
         bus_aseq[1] <= 1'b0;
      else
         if (au_astb & bus_aseq[0])
            bus_aseq[1] <= 1'b1;
   end
end

//______________________________________________________________________________
//
assign vm_sel[2] = wbs_stb_i & (wbs_adr_i[3:1] == 3'b110) & wbs_a;  // 177714
assign vm_sel[1] = wbs_stb_i & (wbs_adr_i[3:1] == 3'b111) & wbs_a;  // 177716

always @(posedge vm_clk_p)
begin
   wsel_00 <= wbs_we_i & wbs_stb_i & wbs_cyc_i & (wbs_adr_i[3:1] == 3'b000);
   wsel_02 <= wbs_we_i & wbs_stb_i & wbs_cyc_i & (wbs_adr_i[3:1] == 3'b001);
   wsel_04 <= wbs_we_i & wbs_stb_i & wbs_cyc_i & (wbs_adr_i[3:1] == 3'b010);
end

assign wbs_dat_o = wbs_d;
assign wbs_ack_o = wbs_a;
//
// Register 177702 does not generate reply if start_irq is active
//
assign wbs_a_rc = wbs_cyc_i & wbs_stb_i & ~((wbs_adr_i[3:1] == 3'b001) & start_irq)
                & ((~wbs_we_i & ~wbs_r) | (wbs_we_i & ~wbs_w));

always @(posedge vm_clk_p)
begin
   wbs_a <= wbs_a_rc;
   wbs_r <= wbs_cyc_i & ((wbs_stb_i & ~wbs_we_i) | wbs_r);
   wbs_w <= wbs_cyc_i & ((wbs_stb_i & wbs_we_i)  | wbs_w);

   if (wbs_stb_i & ~wbs_we_i)
      case(wbs_adr_i[3:1])
         3'b000:  wbs_d <= {11'o3777, vm_pa, reg_csr};   // 177700
         3'b001:  wbs_d <= 16'o177777;                   // 177702
         3'b010:  wbs_d <= {8'o377, reg_err};            // 177704
         3'b011:  wbs_d <= tve_d;                        // 177706
         3'b100:  wbs_d <= tve_d;                        // 177710
         3'b101:  wbs_d <= tve_d;                        // 177712
         3'b110:  wbs_d <= vm_reg14;                     // 177714
         3'b111:  wbs_d <= vm_reg16;                     // 177716
         default: wbs_d <= 16'o000000;
      endcase
end

vm1_timer   timer
(
   .tve_clk(vm_clk_p),
   .tve_ena(vm_clk_tve),
   .tve_reset(vm_init_out | vm_init_in),
   .tve_dclo(vm_dclo),
   .tve_sp(vm_clk_sp),
   .tve_din(wbs_dat_i),
   .tve_dout(tve_d),
   .tve_csr_oe(wbs_adr_i[3:1] == 3'b101),
   .tve_cnt_oe(wbs_adr_i[3:1] == 3'b100),
   .tve_lim_oe(wbs_adr_i[3:1] == 3'b011),
   .tve_csr_wr((wbs_adr_i[3:1] == 3'b101) & wbs_we_i & wbs_a),
   .tve_lim_wr((wbs_adr_i[3:1] == 3'b011) & wbs_we_i & wbs_a),
   .tve_irq(tve_irq),
   .tve_ack(tve_ack)
);
//______________________________________________________________________________
//
// Bus transacion timeout counter
//
// original 1801BM1 timer has 1/8 input prescaler which is no reset and
// provides bus timeout in a range 56..63 processor clocks. This model
// emulates the average value 60 clocks.
//
// Timeout exception request should be synchronized with raising clk's edge
//
always @(posedge vm_clk_p)
begin
   bus_tovf <= &bus_timer[5:2];
end

always @(posedge vm_clk_n)
begin
   if (~((wbm_stb_o & wbm_gnt_i) | wbi_stb_o))
      bus_timer <= 6'o00;
   else
      if (~bus_tovf)
         bus_timer <= bus_timer + 6'o01;
end
//
// Control register at 177700
//
always @(posedge vm_clk_p or posedge reset)
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
         if (wsel_00)
            reg_csr[0] <= wbs_dat_i[0];
      //
      // Bit 1 of control register (controls set of bit 0)
      //
      if (wsel_00)
         reg_csr[1] <= wbs_dat_i[1];
      //
      // Bit 2 of control register (wait state)
      //
      if (plm1x_hl & ~plr[27])
         reg_csr[2] <= 1'b0;
      else
         if (plm1x_hl & ~plr[7])
            reg_csr[2] <= 1'b1;
         else
            if (wsel_00)
               reg_csr[2] <= wbs_dat_i[2];
   end
end

//
// Error register at 177704
// Bit 0 is Double Error
// Bit 1 is Undefine Opcode
// Bit 5 is not used (always read as one)
// Bit 6 is Odd Address Trap (is not implmented)
//
always @(posedge vm_clk_p)
begin
   if (reset_rc | ir_set)
      reg_err <= 8'b00100000;
   else
   begin
      //
      // Bit 0 - double error
      //
      if (  (exc_dbl[0] & exc_uop)
          | (exc_dbl[1] & bus_tovf)
          | (exc_dbl[2] & exc_oat)
          | (exc_dbl[3] & exc_err7))
         reg_err[0] <= 1'b1;
      else
         if (wsel_04)
            reg_err[0] <= wbs_dat_i[0];
      //
      // Bit 1 - undefined opcode
      //
      if (exc_uop)
         reg_err[1] <= 1'b1;
      else
         if (wsel_04)
            reg_err[1] <= wbs_dat_i[1];
      //
      // Bit 2 & 3 - unknown error, exceptions not implemented
      //
      if (exc_err2)
         reg_err[2] <= 1'b1;
      else
         if (wsel_04)
            reg_err[2] <= wbs_dat_i[2];

      if (exc_err3)
         reg_err[3] <= 1'b1;
      else
         if (wsel_04)
            reg_err[3] <= wbs_dat_i[3];
      //
      // Bit 4 - bus timeout
      //
      if (bus_tovf)
         reg_err[4] <= 1'b1;
      else
         if (wsel_04)
            reg_err[4] <= wbs_dat_i[4];
      //
      // Bit 6 - odd address trap
      //
      if (exc_oat)
         reg_err[6] <= 1'b1;
      else
         if (wsel_04)
            reg_err[6] <= wbs_dat_i[6];
      //
      // Bit 7 - unknown error, no exception
      //
      if (exc_err7)
         reg_err[7] <= 1'b1;
      else
         if (wsel_04)
            reg_err[7] <= wbs_dat_i[7];
   end
   //
   // Double error detectors
   //
   if (~exc_uop)     exc_dbl[0] <= reg_err[1];
   if (~bus_tovf)    exc_dbl[1] <= reg_err[4];
   if (~exc_oat)     exc_dbl[2] <= reg_err[6];
   if (~exc_err7)    exc_dbl[3] <= reg_err[7];
end

always @(posedge vm_clk_p)
begin
   //
   // Original circuit contains error
   // The start_irq request is reset by interrupt ack and EMT execution (last one is wrong)
   //
   if (reset | ((vsel[2:0] == 3'b110) & (plr[28:25] == 4'b0010) & ((plr[13] & ~plr[14]) | plr[11])))
      start_irq <= 1'b0;
   else
      if (wsel_02)
         start_irq <= 1'b1;
end

//______________________________________________________________________________
//
// Interrupt controller
//
assign pli = VM1_CORE_MULG_VERSION ? pli_g : pli_a;

vm1g_pli  pli_matrix_g(.rq(rq), .sp(pli_g));
vm1a_pli  pli_matrix_a(.rq(rq), .sp(pli_a));

always @(posedge vm_clk_p)
begin
   rq[0]  <= psw[10];
   rq[1]  <= plir[0];   // pli4r
   rq[2]  <= psw[11];
   rq[3]  <= uop;
   rq[4]  <= psw[7];
   rq[9]  <= qbto;
   rq[10] <= reg_err[0];
   rq[11] <= vm_aclo & aclo;
   rq[12] <= reg_csr[2];
   rq[13] <= ~vm_aclo & acok;
   rq[14] <= vm_irq[1];
   rq[15] <= psw[4];
   rq[16] <= vm_irq[2] & irq2;
   rq[17] <= ivto;
   rq[18] <= vm_irq[3] & irq3;
   //
   // Only master CPU processes vectored interrupts
   // Matrix accepts low level as active (asserted request)
   //
   rq[8]  <= ~(vm_virq & (vm_pa == 2'b00));
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

always @(posedge vm_clk_p or posedge reset)
begin
   if (reset)
      plir[0] <= 1'b0;
   else
      if (pli_stb)
         plir[0] <= pli[4];
end

always @(posedge vm_clk_p)
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
always @(posedge vm_clk_p)
begin
   if (reset | aclo_ack)
      aclo <= 1'b0;
   else
      if (~vm_aclo)
         aclo <= 1'b1;

   if (vm_dclo | aclo_ack)
      acok <= 1'b0;
   else
      if (vm_aclo)
         acok <= 1'b1;
end
//
// IRQ2 and IRQ3 falling edge detectors
// Also resettable by internal INIT
//
always @(posedge vm_clk_p)
begin
   if (vm_init_out | vm_init_in)
   begin
      irq2 <= 1'b0;
      irq3 <= 1'b0;
   end
   else
   begin
      if (irq2_ack)
         irq2 <= 1'b0;
      else
         if (~vm_irq[2])
            irq2 <= 1'b1;

      if (irq3_ack)
         irq3 <= 1'b0;
      else
         if (~vm_irq[3])
            irq3 <= 1'b1;
   end
end
//
// Error exception latches
//
always @(posedge vm_clk_p)
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
      if (bus_tovf & iak_flag) ivto <= 1'b1;
      if (bus_tovf | exc_oat) qbto <= 1'b1;
   end
end

assign pli_req_rc = plm23_ichk | abort;
assign pli_nrdy = pli_req;
assign pli_stb  = pli_req;

always @(posedge vm_clk_p)
begin
   pli_req <= pli_req_rc;

   if (pli_stb)
      vsel <= {pli[3], ~pli[2], pli[1], pli[0]};
   else
      if (plm1x)
         vsel <= {plr[18], ~plr[20], ~plr[21], ~plr[22]};
end

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      iak_flag <= 1'b0;
   else
      if (wb_idone_h)
         iak_flag <= 1'b0;
      else
         if (plm_ena & (plr[28:25] == 4'b0010) & (plr[11] | (plr[13] & ~plr[14])) & (vsel == 4'b1111))
            iak_flag <= 1'b1;
end

always @(posedge vm_clk_p or posedge mjres)
begin
   if (mjres)
      iak_vreq <= 1'b0;
   else
      if (wb_idone)
         iak_vreq <= 1'b0;
      else
         if (iak_flag & ~wb_idone_h & ~wbm_cyc_o & (bus_aseq == 2'b00))
            iak_vreq <= 1'b1;
end

//______________________________________________________________________________
//
// Reset circuits
//
assign mjres_rc = reset_rc | abort_rc;
assign reset_rc = vm_dclo | (vm_aclo & ~init_out[0] & init_out[2]);
assign abort_rc = (bus_tovf | exc_oat | exc_uop | abort) & ~abort_tm & ~reset_rc;

always @(posedge vm_clk_p)
begin
   reset    <= reset_rc;
   mjres    <= mjres_rc;
   mjres_h  <= mjres;
   abort    <= abort_rc;
   abort_tm <= abort & ~reset_rc;
end

always @(posedge vm_clk_p)
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
always @(posedge vm_clk_n)
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

always @(posedge vm_clk_n)
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
always @(posedge vm_clk_p)
begin
   if (ir_stb1) ira <= wbm_dat_i;
   if (ir_stb2)
      if (ir_stb1)
         ir <= wbm_dat_i;
      else
         ir <= ira;
end

//______________________________________________________________________________
//
always @(posedge vm_clk_n)
begin
   if (plm_ena_fc) plr <= plm;
end

always @(posedge vm_clk_p)
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
always @(posedge vm_clk_p or posedge abort)
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


always @(posedge vm_clk_p or posedge mjres)
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

always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p or posedge mjres)
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
always @(posedge vm_clk_n)
begin
   if (au_alsl)
      freg <= flag;
end

always @(posedge vm_clk_n or posedge reset)
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
      psw[15:0] <= {6'o00, vm_pa[1:0], 8'o000};
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
         psw[9:8] <= vm_pa[1:0];
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
   .clk_p(vm_clk_p),
   .clk_n(vm_clk_n),
   .reset(reset),
   .plr(plr),
   .xbus_in(x),
   .xbus_out(xr_rm),
   .ybus_out(yr_rm),
   .wstbl(au_alsl),
   .wstbh(au_alsh),
   .ireg(ir),
   .vsel(vsel),
   .pa(vm_pa),
   .carry(psw[0]));

//
// Implement the Register File with Flip-Flops array
// The constant generator can be built in the File
// in some implementations
//
vm1_reg_ff vreg_ff(
   .clk_p(vm_clk_p),
   .clk_n(vm_clk_n),
   .reset(reset),
   .plr(plr),
   .xbus_in(x),
   .xbus_out(xr_ff),
   .ybus_out(yr_ff),
   .wstbl(au_alsl),
   .wstbh(au_alsh),
   .ireg(ir),
   .vsel(vsel),
   .pa(vm_pa),
   .carry(psw[0]));

assign au_pswy = (plr[28:25] == 4'b1000) & ~plr[11] & ~plr[13];
assign au_qsy  = (plr[28:25] == 4'b0000) & ~plr[11] & ~plr[13];
assign au_pswx = (plr[33:30] == 4'b1000);
assign au_qsx  = (plr[33:30] == 4'b0000);

always @(posedge vm_clk_n) au_alsl <= alu_busy_rp & ustb_h;
always @(posedge vm_clk_n) au_alsh <= alu_busy_rp & ustb_h & plr[18];

assign au_xswap =  plr[13] & plr[14] & plr[25] & plr[26] & ~plr[27];
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
always @(posedge vm_clk_n)
begin
   au_astb_xa <= alu_busy_rp & ustb_h & ~(~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]);
   au_qstb_xa <= alu_busy_rp & ustb_h & ~(~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8];
   au_astb_xu <= (~plr[14] & plr[13]) & ~plr[23] & (plr[7] | plr[8]);
   au_qstb_xu <= (~plr[14] & plr[13]) & ~plr[23] & ~plr[7] & ~plr[8];
end
//
// X bus (12 entries)
//    AU_RSX0  - general purpose regs
//    AU_RSX1  - general purpose regs
//    AU_QSX   - bus temporary reg
//    AU_PSWX  - PSW
//
//    AU_ALSx  - ALU result strobe     (writeonly)
//    AU_ASTB  - A address register    (readonly)
//    AU_ASTB  - A address register    (readonly)
//    AU_QSTBX - bus temporary reg     (readonly)
//    AU_QSTBX - bus temporary reg     (readonly)
//    AU_IS0   - ALU X argument        (readonly)
//    AU_IS1   - ALU X argument        (readonly)
//
// Y bus, inverted (9 entries)
//    AU_RSY0  - general purpose regs
//    AU_RSY1  - general purpose regs
//    AU_QSY   - bus temporary reg
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
// ALU bus register
//
always @(posedge vm_clk_n)
begin
   if (au_qstbx)
      qreg[15:0] <= x[15:0];
   else
      if (au_qstbd)
      begin
         qreg[7:0] <= ((au_ta0 & ~wb_idone_h) ? wb_dat[15:8] : wb_dat[7:0]);
         qreg[15:8] <= wb_dat[15:8];
      end

   if (au_astb)
      areg <= x;
end

//
// Transaction address low bit latch
//
always @(posedge vm_clk_p)
begin
   wb_uplr <= uplr_stb;
   if (wb_uplr)
   begin
      wb_adr <= areg;
      au_ta0 <= areg[0] & plrt[6];
   end
end

assign wb_start   = (~wb_wset & wb_uplr)
                  | (wb_wclr & wb_swait);
assign wb_wdone   = wb_stb & wbm_ack_i &  wb_we;
assign wb_rdone   = wb_stb & wbm_ack_i & ~wb_we;
assign wb_idone   = wbi_stb_o & wbi_ack_i;

assign wbm_cyc_o  = wb_cyc;
assign wbm_we_o   = wb_we;
assign wbm_sel_o  = wb_sel;
assign wbm_stb_o  = wb_stb;
assign wbi_stb_o  = iak_vreq & ~wbm_cyc_o & (bus_aseq == 2'b00);

assign wb_wset     = wb_uplr & vm_clk_slow & (wb_wcnt != 10'o0000);
assign wb_wclr    = reset | ~vm_clk_slow | (vm_clk_ena & (wb_wcnt == 10'o0001));

always @(posedge vm_clk_p)
begin
   au_qstbd    <= wb_idone | (wb_rdone & tplm[2]);
   wb_idone_h  <= wb_idone;

   if (wb_wclr)
      wb_swait <= 1'b0;
   else
      if (wb_wset)
         wb_swait <= 1'b1;

   if (reset)
      wb_wcnt <= 10'o0000;
   else
      if (wb_swait)
      begin
         if (vm_clk_ena | ~vm_clk_slow)
            wb_wcnt <= wb_wcnt - 10'o0001;
      end
      else
      begin
         if (~vm_clk_ena & vm_clk_slow)
            wb_wcnt <= wb_wcnt + 10'o0001;
      end

   if (wb_rdone)
      wb_dat <= wbm_dat_i;
   else
      if (wb_idone)
         wb_dat <= wbi_dat_i;
   //
   //    plr[6]   bus transaction type: byte operation flag
   //    plr[7]   bus transaction type: write flag
   //    plr[8]   bus transaction type: read flag
   //                00x - nothing
   //                010 - write word
   //                011 - write byte
   //                100 - read word
   //                101 - read byte
   //                110 - read-modify-write word
   //                111 - read-modify-write byte
   //
   if (mjres)
   begin
      //
      // Master wishbone abort/reset
      //
      wb_cyc <= 1'b0;
      wb_we  <= 1'b0;
      wb_sel <= 2'b00;
      wb_stb <= 1'b0;
   end
   else
      if (wb_start)
      begin
         //
         // Start master bus transaction
         //
         wb_cyc    <= 1'b1;
         wb_we     <= ~plrt[8] & ~plrt[7];
         wb_sel[0] <= plrt[8] | ~plrt[6] | (wb_uplr ? ~areg[0] : ~au_ta0);
         wb_sel[1] <= plrt[8] | ~plrt[6] | (wb_uplr ?  areg[0] :  au_ta0);
         wb_stb    <= plrt[8] | (plrt[7] & dout_req);
      end
      else
      begin
         if (wb_wdone | (~plrt[7] & wb_rdone))
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
            if (wb_rdone & plrt[7])
            begin
               //
               // Read cycle of read-modify-write completion
               //
               wb_we     <= 1'b1;
               wb_sel[0] <= ~plrt[6] | ~au_ta0;
               wb_sel[1] <= ~plrt[6] |  au_ta0;
               wb_stb    <= 1'b0;
            end
            else
            begin
               if (wb_we & dout_req)
                  wb_stb <= 1'b1;
            end
      end
end

//______________________________________________________________________________
//
// ALU function unit
//
assign nx  = alu_x ? ~xreg : xreg;
//
// ALU input parameters (from X and Y buses) registers
//
always @(posedge vm_clk_n)
begin
   xreg[15:0] <= au_xswap ? {x[7:0], x[15:8]} : x[15:0];
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

always @(posedge vm_clk_n)
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
   4'b0101:                         // or bus timeout
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

assign wren      = (wstbl & (plr[32:30] != 3'b000) & plr[20]) | (wstbl & ~plr[20]);
assign xadr[5:0] = {2'b00, wstbl ? (plr[20] ? plr[33:30] : 4'b1100) : plr[33:30]};
assign yadr[3:0] = (vc_vsel                        ? vsel       : 4'b0000)
                 | (vc_csel                        ? plr[28:25] : 4'b0000)
                 | ((plr[13] & plr[14] & ~plr[11]) ? 4'b1100    : 4'b0000)
                 | ((~plr[11] & ~plr[13])          ? plr[28:25] : 4'b0000);
assign yadr[4]   = vc_vsel;
assign yadr[5]   = vc_csel;

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
