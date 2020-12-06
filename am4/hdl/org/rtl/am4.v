//
// Copyright (c) 2020 by 1801BM1@gmail.com
//______________________________________________________________________________
//
module am4
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
   output         pin_init_n,    // peripheral reset (open drain)
   output         pin_dmgo_n,    // bus granted output
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
reg         init;                // peripheral init
wire        dclo;                // hardware reset
reg         aclo, aclo0;         // power failure request
reg         evnt, evnt0;         // timer interrupt request
reg         rfrq, rfrq0;         // refresh request
reg         dref;                //
reg  [7:0]  irq;                 // interrupt requests
wire [2:0]  iv;                  // interrupt value encoded
                                 //
wire [15:0] ad;                  //
wire        io_sync;             //
wire        io_dout;             //
wire        io_wtbt;             //
wire        io_iako;             //
wire        io_rdin;             //
wire        io_din;              //
wire        ct_oe;               //
wire        ad_oe;               //
reg         astb;                //
reg         la0;                 //
wire        astb_clr;            //
                                 //
wire        sync;                //
wire        sync_135;            //
wire        sync_150;            //
wire        sync_210;            //
wire        sync_300;            //
wire [19:0] sync_ph;             //
reg         sync0;               //
                                 //
wire        rply;                //
wire        sack;                //
wire        din;                 //
reg         dmgo, dmgo0;         //
reg         dreq;                //
                                 //
reg         gclk_wait;           // clock generator stop synchronized
wire [9:0]  gclk_ph;             // generator clock phases
wire        gclk;                // generator clock phase 0 ns
wire        gclk_60;             // generator clock phase 60 ns
wire        gclk_105;            // generator clock phase 105 ns
wire        gclk_135;            // generator clock phase 135 ns
                                 //
wire        mclk;                // menory clock
wire        tclk;                // primary transition clock
                                 //
reg         tclk_en, tclk_en0;   //
wire        gclk_en, gclk_en0;   // global clock enable
wire        qt_req, qt_req0;     // Q-bus timer request
                                 //
wire [55:0] mcr;                 // micro instruction register
wire [11:0] ma;                  // micro instruction ROM address
wire [11:0] na;                  // micro instruction next address
wire [11:0] na_op;               // next address/map operation
wire [7:4]  cc;                  // condition codes
reg         cc6, cc7;            //
                                 //
wire        reg_ena;             //
wire        clr_init;            //
wire        clr_ref;             //
wire        clr_aclo;            //
wire        clr_evnt;            //
wire        set_init;            //
wire        set_ref;             //
                                 //
reg         bra_n;               // no branch taken
reg         sext_n;              // sign extension
                                 //
wire        alu_dl, alu_dh;      //
reg  [15:0] alu_d;               // ALU data input mux
wire [15:0] alu_y;               // ALU data output
wire [3:0]  alu_a;               // ALU A port selector
wire [3:0]  alu_b;               // ALU B port selector
wire [8:0]  alu_i;               // ALU instruction
                                 //
wire [3:0]  alu_fc;              // carry output
wire [3:0]  alu_fv;              // arithmetic overflow
wire [3:0]  alu_fn;              // MSB of ALU output
wire [3:0]  alu_fz;              // (F[3:0] == 0) flag output (OC)
wire [4:0]  g_n;                 // carry generate output
wire [4:0]  p_n;                 // carry propagate output
                                 //
wire        alu_f7, alu_f15;     //
wire        alu_c8, alu_c16;     //
wire        alu_v8, alu_v16;     //
tri1        alu_zl, alu_zh;      //
wire [2:0]  alu_cxyz;            //
                                 //
tri1        pq_bit0, pq_bit15;   //
tri1        sh_bit0, sh_bit7;    //
tri1        sh_bit8, sh_bit15;   //
tri1 [2:0]  sh_pr;               //
tri1 [2:0]  sh_pq;               //
                                 //
reg  [7:0]  psw;                 // processor status word
reg         psw_xc;              //
reg         psw_c0;              //
wire        psw_c1;              //
wire        psw_c2;              //
wire        psw_v0;              //
wire        psw_z0, psw_z1;      //
wire        psw_wl, psw_wh;      // PSW write strobes
                                 //
reg  [15:0] ireg;                // instruction register
wire        ir_stb;              //
wire [6:0]  ins_ma;              // instruction micriaddress
wire        ins_bf;              // instruction byte flag
                                 //
wire        mcu_za;              // sequencer reset
wire        mcu_me_n;            // sequencer map enable
wire        mcu_re_n;            // sequencer register enable
wire        mcu_fe_n;            // sequencer file enable
reg  [2:0]  mcu_ora;             // sequencer address OR
reg         mcu_tst;             // sequencer test condition
wire [3:0]  mcu_i;               // sequencer instruction
wire [1:0]  mcu_s;               // sequencer selector
wire        mcu_pup;             // sequencer push/pop
wire [2:0]  ma_c;                // micro address carries
                                 //
reg         mcu_bf;              // byte instruction decoded
wire [4:1]  mcbr_f;              // [1] destination is register Rd
                                 // [2] ]source is register Rs
                                 // [3] byte instruction
                                 // [4] no R6/R7
                                 //
wire        ctr_pe_n;            // counter load
wire        ctr_en_n;            // counter enable
reg [7:0]   ctr;                 // counter

//______________________________________________________________________________
//
// Clock generator around digital delay loop
//
am4_delay glkc_dll(
   .clk(pin_clk),
   .inp(gclk),
   .phase(gclk_ph)
);

assign gclk = ~(gclk_135 & ~(gclk & gclk_wait));
assign gclk_60  = gclk_ph[3];
assign gclk_105 = gclk_ph[6];
assign gclk_135 = gclk_ph[8];

assign mclk = ~(gclk & gclk_60);
always @(posedge pin_clk) gclk_wait = ~gclk_en;

assign tclk = mclk | tclk_en | (mcr[38] & mcr[39] & dreq);

assign gclk_en = gclk_en0 & (qt_req | ~astb);
assign gclk_en0 = ~mcr[35] | cc[6] | rply;
always @(posedge mclk) tclk_en0 <= cc[6] ? ~tclk_en0 : 1'b1;
always @(negedge gclk_105 or negedge tclk_en0 or negedge gclk_en0)
begin
   if (~gclk_en0)
      tclk_en <= 1'b1;
   else
      if (~tclk_en0)
         tclk_en <= 1'b0;
      else
         if (~rply)
            tclk_en <= 1'b0;
         else
            case({mcr[39],~mcr[35]})
               2'b00: tclk_en <= 1'b0;
               2'b01: tclk_en <= tclk_en;
               2'b10: tclk_en <= ~tclk_en;
               2'b11: tclk_en <= 1'b1;
            endcase
end

//______________________________________________________________________________
//
// Bus microcode control
//
assign io_iako = ~mcr[36] & mcr[40];
assign io_din  = ~mcr[36] & mcr[41];
assign io_rdin = ~mcr[36] & ~mcr[42];
assign io_wtbt = ~mcr[36] & mcr[43];

//______________________________________________________________________________
//
// Reset circuits
//
assign dclo = ~pin_dclo_n;

always @(posedge pin_clk or posedge dclo)
begin
   if (dclo)
      init <= 1'b1;
   else
      init <= ~clr_init & (set_init | init);
end

assign mcu_za = irq[0] & irq[1];
//______________________________________________________________________________
//
// Microcode ROM instantiation
//
mcrom rom
(
   .clk(tclk),       // output register clock
   .addr(ma[9:0]),   // next address to fetch
   .data(mcr)        // micro instruction opcode
);

//______________________________________________________________________________
//
// Initial instruction decode
//
always @(posedge tclk or posedge init)
begin
   if (init)
      ireg <= 16'h0000;
   else
      if (ir_stb)
         ireg <= alu_d;
end

plm_dec insdec
(
   .ins(ireg),       // PDP-11 instruction opcode
   .bf(ins_bf),      // byte operation flag
   .ad(ins_ma)       // address of microcode
);

assign ir_stb = ~mcr[29] & mcr[31];
//______________________________________________________________________________
//
// Control strobes decoder
//
assign reg_ena  = (mcr[32] & ~mcr[29]) & ~dclo & ~mclk;
assign clr_init = reg_ena & na[8:6] == 3'b001;
assign clr_ref  = reg_ena & na[8:6] == 3'b010;
assign set_ref  = reg_ena & na[8:6] == 3'b011;
assign set_init = reg_ena & na[8:6] == 3'b100;
assign clr_aclo = reg_ena & na[8:6] == 3'b110;
assign clr_evnt = reg_ena & na[8:6] == 3'b111;

//______________________________________________________________________________
//
// Conditional codes cc[7:4]
//
//    cc[4] - counter is 255 (max)
//    cc[5] - interrupt requests status
//    cc[6] - Q-bus timeout status
//    cc[7] - active nACLO
//
assign cc[6] = cc6;
assign cc[7] = cc7;

always @(negedge qt_req or posedge clr_ref or posedge dclo)
begin
   if (dclo)
      cc6 <= 1'b1;
   else
      if (clr_ref)
         cc6 <= 1'b0;
      else
         cc6 <= ~gclk_en;
end

always @(posedge tclk) cc7 = aclo0;

//______________________________________________________________________________
//
// Interrupt controller
//
always @(posedge pin_clk)
begin
   aclo0 <= ~pin_aclo_n;
   if (clr_aclo | dclo)
      aclo <= 1'b0;
   else
      if (~pin_aclo_n & ~aclo0)
         aclo <= 1'b1;
end

always @(posedge pin_clk)
begin
   evnt0 <= ~pin_evnt_n;
   if (clr_evnt | dclo)
      evnt <= 1'b0;
   else
      if (~pin_evnt_n & ~evnt0)
         evnt <= 1'b1;
end

always @(posedge tclk or posedge dclo)
begin
   if (dclo)
      irq <= 8'h00;
   else
   begin
      irq[0] <= cc6;
      irq[1] <= ~irq[0];
      irq[2] <=~pin_virq_n & ~psw[7];
      irq[3] <= evnt & ~psw[7];
      irq[4] <= ~pin_halt_n;
      irq[5] <= aclo;
      irq[6] <= psw[4];
      irq[7] <= rfrq;
   end
end

assign cc[5] = ~(|irq[7:2]);
assign iv[2:0] =  irq[7] ? 3'b000 :
                  irq[6] ? 3'b001 :
                  irq[5] ? 3'b010 :
                  irq[4] ? 3'b011 :
                  irq[3] ? 3'b100 :
                  irq[2] ? 3'b101 : 3'b111;
//______________________________________________________________________________
//
// Bus arbiter
//
always @(negedge gclk_105 or posedge io_rdin or posedge sack)
begin
   if (sack)
      dreq <= 1'b1;
   else
      if (io_rdin)
         dreq <= 1'b0;
      else
         dreq <= ~pin_dmr_n;
end

always @(posedge mclk or negedge dreq)
begin
      if (~dreq)
         dmgo0 <= 1'b0;
      else
         dmgo0 <= ~sack;
end

always @(posedge mclk or posedge sync)
begin
      if (sync)
         dmgo <= 1'b0;
      else
         dmgo <= dmgo0;
end

//______________________________________________________________________________
//
// Bus timeout, 18 is multiplication factor between pin_clk and tclk
//
localparam TCLK_CLK = 18;
defparam qbus_to0.AM4_PULSE_WIDTH_CLK = 64 * TCLK_CLK;
am4_pulse qbus_to0
(
   .clk(pin_clk),
   .reset_n(~gclk_en & ~dclo),
   .a_n(1'b0),
   .b(mcr[35]),
   .q(qt_req0)
);

defparam qbus_to1.AM4_PULSE_WIDTH_CLK = 1 * TCLK_CLK;
am4_pulse qbus_to1
(
   .clk(pin_clk),
   .reset_n(~dclo),
   .a_n(1'b0),
   .b(~qt_req0),
   .q(qt_req)
);

//______________________________________________________________________________
//
assign io_sync = ~mcr[38];
assign io_dout = mcr[37];
assign din = io_rdin | (io_din & sync_135 & ~astb);
assign sync = sync_210;

always @(posedge pin_clk or posedge io_sync)
begin
   if (io_sync)
      sync0 <= 1'b1;
   else
      if (init | ~rply)
         sync0 <= 1'b0;
end

am4_delay sync0_dll
(
   .clk(pin_clk),
   .inp(sync0),
   .phase(sync_ph[9:0])
);

am4_delay sync1_dll
(
   .clk(pin_clk),
   .inp(sync_150),
   .phase(sync_ph[19:10])
);

assign sync_135 = sync_ph[8];
assign sync_150 = sync_ph[9];
assign sync_210 = sync_ph[13];
assign sync_300 = sync_ph[19];

assign astb_clr = sync_150 & sync_300;
always @(posedge pin_clk or posedge dclo or posedge astb_clr)
begin
   if (dclo)
      astb <= 1'b1;
   else
      if (astb_clr)
         astb <= 1'b0;
      else
         astb <= sync0;
end

always @(posedge astb) la0 <= alu_y[0];
//______________________________________________________________________________
//
// Dynamic memory refresh logic
//
always @(posedge pin_clk or posedge dclo)
begin
   if (dclo)
      dref <= 1'b0;
   else
      dref <= ~clr_ref & (set_ref | dref);
end

always @(posedge pin_clk or posedge dclo)
begin
   if (dclo)
   begin
      rfrq <= 1'b0;
      rfrq0 <= 1'b0;
   end
   else
   begin
      rfrq0 <= ~pin_rfrq_n;
      if (~pin_rfrq_n & ~rfrq0)
         rfrq <= 1'b1;
      else
         if (set_ref)
            rfrq <= 1'b0;
   end
end

//______________________________________________________________________________
//
// External pin wires and controls
//
assign rply = ~pin_rply_n;
assign sack = ~pin_sack_n;

assign pin_dmgo_n = ~dmgo;
assign pin_iako_n = ~io_iako;
assign pin_dref_n = ~dref;
assign pin_init_n = init ? 1'b0 : 1'bZ;

assign ct_oe = ~sack & ~dmgo;
assign pin_dout_n = ct_oe ? ~io_dout  : 1'bZ;
assign pin_wtbt_n = ct_oe ? ~io_wtbt  : 1'bZ;
assign pin_sync_n = ct_oe ? ~sync : 1'bZ;
assign pin_din_n  = ct_oe ? ~din : 1'bZ;

assign ad_oe = ~din & ~io_iako & ct_oe;
assign pin_ad_n = ad_oe   ? ~alu_y : 16'oZZZZZZ;
assign ad = ~pin_ad_n;

//______________________________________________________________________________
//
// Microinstruction address sequencer
//
am2909 ma0
(
   .cp(tclk),
   .za_n(~mcu_za),
   .oe_n(1'b0),
   .cin(1'b1),
   .cout(ma_c[0]),
   .ora({1'b0, mcu_ora}),
   .r(na_op[3:0]),
   .d(na_op[3:0]),
   .y(ma[3:0]),
   .s(mcu_s),
   .fe_n(mcu_fe_n),
   .pup(mcu_pup),
   .re_n(mcu_re_n)
);

am2909 ma1
(
   .cp(tclk),
   .za_n(~mcu_za),
   .oe_n(1'b0),
   .cin(ma_c[0]),
   .cout(ma_c[1]),
   .ora(4'b0000),
   .r(na_op[7:4]),
   .d(na_op[7:4]),
   .y(ma[7:4]),
   .s(mcu_s),
   .fe_n(mcu_fe_n),
   .pup(mcu_pup),
   .re_n(mcu_re_n)
);

am2909 ma2
(
   .cp(tclk),
   .za_n(~mcu_za),
   .oe_n(1'b0),
   .cin(ma_c[1]),
   .cout(ma_c[2]),
   .ora(4'b0000),
   .r(na_op[11:8]),
   .d(na_op[11:8]),
   .y(ma[11:8]),
   .s(mcu_s),
   .fe_n(mcu_fe_n),
   .pup(mcu_pup),
   .re_n(mcu_re_n)
);


am29811 ma_seq
(
   .tst(mcu_tst),    // entry for conditional instructions
   .i(mcu_i),        // microcode instruction
   .s(mcu_s),        // address selector
   .fe_n(mcu_fe_n),  // file enable
   .pup(mcu_pup),    // push/pop_n
   .ctl_n(ctr_pe_n), // counter load
   .cte_n(ctr_en_n), // counter enable
   .me_n(mcu_me_n)   // map enable
);

assign na = mcr[55:44];
assign mcu_i = mcr[23:20];
assign mcu_re_n = ~(~mcr[29] & mcr[30]);
assign na_op = mcu_me_n ? na : {na[11:10], ins_ma[6:0] ^ 7'h11, na[2:0]};

//
// Microaddress OR modificators
//
always @(*)
begin
   case({mcr[24],mcr[43:41]})
      4'b0000: mcu_ora = ireg[5:3];                      // destination mode
      4'b0001: mcu_ora = ireg[11:9];                     // source mode
      4'b0010: mcu_ora = {1'b0, mcbr_f[1], mcbr_f[2]};   // dst/src reg mode
      4'b0011: mcu_ora = iv;                             // interrupt vector
      4'b0100: mcu_ora = {1'b0, ~pin_bsel_n};            // boot mode
      4'b0101: mcu_ora = {1'b0, la0, mcbr_f[3]};         // byte exchange
      4'b0110: mcu_ora = {psw_xc, 1'b0, ctr[5]};         // shift CF result
      4'b0111: mcu_ora = {2'b00, mcbr_f[4]};             // not SP/PC
      default: mcu_ora = 3'b000;
   endcase

   case (mcr[27:25])
      3'b000: mcu_tst = psw[0] ^ mcr[28];
      3'b001: mcu_tst = psw[1] ^ mcr[28];
      3'b010: mcu_tst = psw[3] ^ mcr[28];
      3'b011: mcu_tst = psw[2] ^ mcr[28];
      3'b100: mcu_tst = cc[4] ^ mcr[28];
      3'b101: mcu_tst = cc[5] ^ mcr[28];
      3'b110: mcu_tst = cc[6] ^ mcr[28];
      3'b111: mcu_tst = cc[7] ^ mcr[28];
      default: mcu_tst = 1'b0;
   endcase
end

always @(posedge tclk) if (~mcu_me_n) mcu_bf = ins_bf;

assign mcbr_f[1] = ireg[5:3] == 3'b000;   // dst mode is not register
assign mcbr_f[2] = ireg[11:9] == 3'b000;  // src mode is not register
assign mcbr_f[3] = mcu_bf;
assign mcbr_f[4] = ~(alu_a[2] & alu_a[1]);

//______________________________________________________________________________
//
// Microcode application counter
//
always @(posedge tclk)
begin
   if (~ctr_pe_n)
      ctr <= alu_y[7:0];
   else
      if (~ctr_en_n)
         ctr <= ctr + 8'h01;
end

assign cc[4] = ctr == 8'hFF;
//______________________________________________________________________________
//
// Processor status word
//
assign psw_wl = mcr[29];
assign psw_wh = mcr[29] & mcr[30] & mcr[31];

always @(posedge tclk or posedge init)
begin
   if (init)
      psw[7:0] <= 8'h00;
   else
   begin
      if (psw_wl)
      begin
         case (mcr[31:30])
            2'b00: psw[0] <= psw_c0;
            2'b01: psw[0] <= psw_c1;
            2'b10: psw[0] <= psw_c2;
            2'b11: psw[0] <= alu_y[0];
            default: psw[0] <= 1'b0;
         endcase
         case (mcr[31:30])
            2'b00: psw[1] <= psw_v0;
            2'b01: psw[1] <= alu_v16;
            2'b10: psw[1] <= alu_v8;
            2'b11: psw[1] <= alu_y[1];
            default: psw[1] <= 1'b0;
         endcase
         case (mcr[31:30])
            2'b00: psw[2] <= psw_z0;
            2'b01: psw[2] <= psw_z1;
            2'b10: psw[2] <= alu_zl;
            2'b11: psw[2] <= alu_y[2];
            default: psw[2] <= 1'b0;
         endcase
         case (mcr[31:30])
            2'b00: psw[3] <= alu_f15;
            2'b01: psw[3] <= alu_f15;
            2'b10: psw[3] <= alu_f7;
            2'b11: psw[3] <= alu_y[3];
            default: psw[3] <= 1'b0;
         endcase
      end
      if (psw_wh)
         psw[7:4] <= alu_y[7:4];
   end
end

assign psw_c1 = mcr[32] ? psw[0] : alu_c16;
assign psw_c2 = mcr[32] ? psw[0] : alu_c8;

assign psw_z0 = alu_zh & (alu_zl | ireg[15]);
assign psw_z1 = alu_zh & alu_zl;

assign psw_v0 = alu_f15 ^ psw_c0;
always @(*)
begin
   if (~alu_i[8])
      psw_xc <= psw[0];
   else
      case (na[11:10])
         2'b00: psw_xc <= sh_bit15;
         2'b01: psw_xc <= sh_bit8;
         2'b10: psw_xc <= sh_bit0;
         2'b11: psw_xc <= pq_bit0;
         default: psw_xc <= 1'b0;
      endcase
end

always @(posedge tclk or posedge init)
begin
   if (init)
      psw_c0 <= 1'b0;
   else
      psw_c0 <= psw_xc;
end

//______________________________________________________________________________
//
// Bit-slice ALU instantiation
//
am2901 alu0
(
   .cp(tclk),        // ALU clock
   .i(alu_i),        // ALU instruction
   .a(alu_a),        // ALU port A selection
   .b(alu_b),        // ALU port B selection
   .d(alu_d[3:0]),   // ALU data input
   .y(alu_y[3:0]),   // ALU data output
   .oe_n(1'b0),      // output enable
   .cin(mcr[9]),     // carry input
   .ram0(sh_bit0),   // shift line register stack LSB
   .q0(pq_bit0),     // shift line Q-register LSB
   .ram3(sh_pr[0]),  // shift line register stack MSB
   .q3(sh_pq[0]),    // shift line Q-register MSB
   .cout(alu_fc[0]), // carry output
   .ovr(alu_fv[0]),  // arithmetic overflow
   .f3(alu_fn[0]),   // MSB of ALU output
   .zf(alu_fz[0]),   // (F[3:0] == 0) flag output (OC)
   .g_n(g_n[0]),     // carry generate output
   .p_n(p_n[0])      // carry propagate output
);

am2901 alu1
(
   .cp(tclk),        // ALU clock
   .i(alu_i),        // ALU instruction
   .a(alu_a),        // ALU port A selection
   .b(alu_b),        // ALU port B selection
   .d(alu_d[7:4]),   // ALU data input
   .y(alu_y[7:4]),   // ALU data output
   .oe_n(1'b0),      // output enable
   .cin(alu_cxyz[0]),// carry input
   .ram0(sh_pr[0]),  // shift line register stack LSB
   .q0(sh_pq[0]),    // shift line Q-register LSB
   .ram3(sh_bit7),   // shift line register stack MSB
   .q3(sh_pq[1]),    // shift line Q-register MSB
   .cout(alu_fc[1]), // carry output
   .ovr(alu_fv[1]),  // arithmetic overflow
   .f3(alu_fn[1]),   // MSB of ALU output
   .zf(alu_fz[1]),   // (F[3:0] == 0) flag output (OC)
   .g_n(g_n[1]),     // carry generate output
   .p_n(p_n[1])      // carry propagate output
);

am2901 alu2
(
   .cp(tclk),        // ALU clock
   .i(alu_i),        // ALU instruction
   .a(alu_a),        // ALU port A selection
   .b(alu_b),        // ALU port B selection
   .d(alu_d[11:8]),  // ALU data input
   .y(alu_y[11:8]),  // ALU data output
   .oe_n(1'b0),      // output enable
   .cin(alu_cxyz[1]),// carry input
   .ram0(sh_bit8),   // shift line register stack LSB
   .q0(sh_pq[1]),    // shift line Q-register LSB
   .ram3(sh_pr[2]),  // shift line register stack MSB
   .q3(sh_pq[2]),    // shift line Q-register MSB
   .cout(alu_fc[2]), // carry output
   .ovr(alu_fv[2]),  // arithmetic overflow
   .f3(alu_fn[2]),   // MSB of ALU output
   .zf(alu_fz[2]),   // (F[3:0] == 0) flag output (OC)
   .g_n(g_n[2]),     // carry generate output
   .p_n(p_n[2])      // carry propagate output
);

am2901 alu3
(
   .cp(tclk),        // ALU clock
   .i(alu_i),        // ALU instruction
   .a(alu_a),        // ALU port A selection
   .b(alu_b),        // ALU port B selection
   .d(alu_d[15:12]), // ALU data input
   .y(alu_y[15:12]), // ALU data output
   .oe_n(1'b0),      // output enable
   .cin(alu_cxyz[2]),// carry input
   .ram0(sh_pr[2]),  // shift line register stack LSB
   .q0(sh_pq[2]),    // shift line Q-register LSB
   .ram3(sh_bit15),  // shift line register stack MSB
   .q3(pq_bit15),    // shift line Q-register MSB
   .cout(alu_fc[3]), // carry output
   .ovr(alu_fv[3]),  // arithmetic overflow
   .f3(alu_fn[3]),   // MSB of ALU output
   .zf(alu_fz[3]),   // (F[3:0] == 0) flag output (OC)
   .g_n(g_n[3]),     // carry generate output
   .p_n(p_n[3])      // carry propagate output
);

am2902 aluc
(                    // carry look-ahead
   .cin(mcr[9]),     // carry input
   .g_n({1'b1,g_n[2:0]}),
   .p_n({1'b1,p_n[2:0]}),
   .cout(alu_cxyz),  // carry output
   .gout_n(g_n[4]),  // carry generate output
   .pout_n(p_n[4])   // carry propagate output
);

assign alu_zl = alu_fz[0] & alu_fz[1];
assign alu_zh = alu_fz[2] & alu_fz[3];

assign alu_f7 = alu_fn[1];
assign alu_f15 = alu_fn[3];

assign alu_v8 = alu_fv[1];
assign alu_v16 = alu_fv[3];

assign alu_c8 = alu_fc[1];
assign alu_c16 = alu_fc[3];

assign alu_dl = ~(alu_i[5] & mcr[9] & bra_n);
assign alu_dh = ~(alu_i[5] & mcr[9] & sext_n);

//
// Branch on condition - offset generation)
//
always @(*)
begin
   case({ireg[15],ireg[10:8]})
      4'b0000: bra_n = 1'b1;
      4'b0001: bra_n = 1'b0;
      4'b0010: bra_n =  psw[2];
      4'b0011: bra_n = ~psw[2];
      4'b0100: bra_n =  psw[1] ^ psw[3];
      4'b0101: bra_n = ~psw[1] ^ psw[3];
      4'b0110: bra_n =   (psw[1] ^ psw[3]) | psw[2];
      4'b0111: bra_n = ~((psw[1] ^ psw[3]) | psw[2]);
      4'b1000: bra_n =  psw[3];
      4'b1001: bra_n = ~psw[3];
      4'b1010: bra_n =   psw[0] | psw[2];
      4'b1011: bra_n = ~(psw[0] | psw[2]);
      4'b1100: bra_n =  psw[1];
      4'b1101: bra_n = ~psw[1];
      4'b1110: bra_n =  psw[0];
      4'b1111: bra_n = ~psw[0];
      default: bra_n = 1'b1;
   endcase
end
//
// Sign extension
//
always @(posedge tclk or posedge init)
begin
   if (init)
      sext_n <= 1'b1;
   else
      sext_n <= ~alu_f7;
end

//
// ALU operation
//
assign alu_i = mcr[8:0];

//
// ALU port A & B selectors
//
assign alu_a[0] = (mcr[10] ? (mcr[13] ? ireg[6] : ireg[0]) : mcr[12]) | mcr[12];
assign alu_a[1] =  mcr[10] ? (mcr[13] ? ireg[7] : ireg[1]) : mcr[13];
assign alu_a[2] =  mcr[10] ? (mcr[13] ? ireg[8] : ireg[2]) : mcr[14];
assign alu_a[3] =  mcr[10] ? 1'b0 : mcr[15];

assign alu_b[0] = (mcr[11] ? (mcr[17] ? ireg[0] : ireg[6]) : mcr[16]) | mcr[16];
assign alu_b[1] =  mcr[11] ? (mcr[17] ? ireg[1] : ireg[7]) : mcr[17];
assign alu_b[2] =  mcr[11] ? (mcr[17] ? ireg[2] : ireg[8]) : mcr[18];
assign alu_b[3] =  mcr[11] ? 1'b0 : mcr[19];

//
// ALU input data mux
//
always @(*)
begin
   if (alu_dl)
      case(mcr[34:33])
         2'b00: alu_d[7:0] = psw[7:0];
         2'b01: alu_d[7:0] = ad[7:0];
         2'b10: alu_d[7:0] = mcr[47:40];
         2'b11: alu_d[7:0] = alu_y[15:8];
         default: alu_d[7:0] = 8'h00;
      endcase
   else
      alu_d[7:0] = 8'h00;

   if (alu_dh)
      case(mcr[34:33])
         2'b00: alu_d[15:8] = ctr[7:0];
         2'b01: alu_d[15:8] = ad[15:8];
         2'b10: alu_d[15:8] = mcr[55:48];
         2'b11: alu_d[15:8] = alu_y[7:0];
         default: alu_d[15:8] = 8'h00;
      endcase
   else
      alu_d[15:8] = 8'h00;
end

//
// Shift operations chain mux
//
assign sh_bit0  = mcr[46] ? 1'bZ : (mcr[45:44] == 2'b00)
                                 | (mcr[45:44] == 2'b10) & pq_bit15
                                 | (mcr[45:44] == 2'b11) & psw_c0;
assign sh_bit15 = mcr[47] ? 1'bZ : (mcr[45:44] == 2'b00)
                                 | (mcr[45:44] == 2'b01) & (alu_v16 ^ alu_f15)
                                 | (mcr[45:44] == 2'b10) & alu_f15
                                 | (mcr[45:44] == 2'b11);
assign sh_bit8  = mcr[48] ? 1'bZ : sh_bit7;
assign sh_bit7  = mcr[49] ? 1'bZ : sh_bit8;
assign pq_bit0  = mcr[50] ? 1'bZ : 1'b0;
assign pq_bit15 = mcr[51] ? 1'bZ : sh_bit0;
assign sh_bit8  = mcr[52] ? 1'bZ : sh_bit0;
assign sh_bit15 = mcr[53] ? 1'bZ : psw_c0;


//______________________________________________________________________________
//
endmodule

