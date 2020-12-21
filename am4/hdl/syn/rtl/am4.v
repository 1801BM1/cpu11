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
reg         la0;                 //
wire        wadr;                //
                                 //
wire        rply;                //
wire        sack;                //
wire        din;                 //
wire        sync;                //
reg         sync0, din0;         //
                                 //
reg         dmgo, dmgo0;         //
reg         dreq;                //
                                 //
wire        tclk;                // primary transition clock
wire        tena;                // primary clock enable
                                 //
reg         qt_req;              // Q-bus timer request
reg [5:0]   qt_cnt;              // Q-bus timer counter
                                 //
wire [55:0] mcr;                 // micro instruction register
wire [9:0]  ma;                  // micro instruction ROM address
wire [9:0]  na;                  // next address/map operation
wire [7:4]  cc;                  // condition codes
reg         cc6, cc7, cc8;       //
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
wire [15:0] alu_r;               // ALU ram[a] output
wire [3:0]  alu_a;               // ALU A port selector
wire [3:0]  alu_b;               // ALU B port selector
wire [8:0]  alu_i;               // ALU instruction
                                 //
wire        alu_f7, alu_f15;     //
wire        alu_c8, alu_c16;     //
wire        alu_v8, alu_v16;     //
wire        alu_zl, alu_zh;      //
                                 //
wire        sh_bit0, sh_bit7;    //
wire        sh_bit8, sh_bit15;   //
                                 //
wire        qs_out0, qs_out15;   //
wire        sh_out0, sh_out7;    //
wire        sh_out8, sh_out15;   //
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
wire [6:0]  ins_ma;              // instruction micro address
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
// Transition clock and clock enable
//
assign tclk = pin_clk;
assign tena =  cc8 |                            // initial start
              ~wadr                             // wait write address
            & ~(mcr[39] & rply)                 // wait rply done
            &  (~mcr[35] | cc[6] | rply)        // enabled | bus error | ready
            & ~(mcr[38] & mcr[39] & dreq);      // clock stop from bus arbiter

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

assign mcu_za = cc8 | irq[0] & irq[1];
//______________________________________________________________________________
//
// Microcode ROM instantiation
//
mcrom rom
(
   .clk(tclk),       // output register clock
   .ena(tena),       // clock enable
   .addr(ma),        // next address to fetch
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
      if (tena & ir_stb)
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
assign reg_ena  = (mcr[32] & ~mcr[29]) & ~dclo;
assign clr_init = reg_ena & mcr[52:50] == 3'b001;
assign clr_ref  = reg_ena & mcr[52:50] == 3'b010;
assign set_ref  = reg_ena & mcr[52:50] == 3'b011;
assign set_init = reg_ena & mcr[52:50] == 3'b100;
assign clr_aclo = reg_ena & mcr[52:50] == 3'b110;
assign clr_evnt = reg_ena & mcr[52:50] == 3'b111;

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

always @(posedge pin_clk or posedge dclo)
begin
   if (dclo)
      cc6 <= 1'b0;
   else
      if (clr_ref)
         cc6 <= 1'b0;
      else
         if (qt_req)
            cc6 <= 1'b1;
end

always @(posedge tclk) cc7 = aclo0;
always @(posedge tclk) cc8 = dclo;

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
      if (tena)
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
always @(posedge pin_clk)
begin
   if (sack)
      dreq <= 1'b1;
   else
      if (io_rdin)
         dreq <= 1'b0;
      else
         dreq <= ~pin_dmr_n;
end

always @(posedge pin_clk)
begin
      if (~dreq)
         dmgo0 <= 1'b0;
      else
         dmgo0 <= ~sack;
end

always @(posedge pin_clk)
begin
      if (sync)
         dmgo <= 1'b0;
      else
         dmgo <= dmgo0;
end

//______________________________________________________________________________
//
// Bus transaction timer
//
always @(posedge pin_clk or posedge dclo)
begin
   if (dclo)
   begin
      qt_cnt <= 6'b000000;
      qt_req <= 1'b0;
   end
   else
      if (din | io_dout)
      begin
         qt_cnt <= qt_cnt + 6'b000001;
         qt_req <= &qt_cnt & ~rply;
      end
      else
      begin
         qt_cnt <= 6'b000000;
         qt_req <= 1'b0;
      end
end

//______________________________________________________________________________
//
assign io_sync = ~mcr[38];
assign io_dout = mcr[37];
assign din = io_rdin | (io_din & din0);
assign sync = io_sync & sync0;
assign wadr = io_sync & ~sync0 & io_wtbt;

always @(posedge pin_clk)
begin
   if (io_sync)
      sync0 <= 1'b1;
   else
      if (init | ~rply | ~io_sync)
         sync0 <= 1'b0;

   if (io_sync & ~sync0)
      la0 <= alu_y[0];

   din0 <= io_din & sync0;
end

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
am4_seq seq(
   .clk(tclk),             // main clock
   .ena(tena),             // clock enable
   .ora({1'b0, mcu_ora}),  // or conditions
   .d(na),                 // immed address input
   .y(ma),                 // address output
   .re_n(mcu_re_n),        // pipeline register load
   .za_n(~mcu_za),         // set zero address
   .tst(mcu_tst),          // entry for conditional instructions
   .i(mcu_i),              // microcode instruction
   .ctl_n(ctr_pe_n),       // counter load
   .cte_n(ctr_en_n),       // counter enable
   .me_n(mcu_me_n)         // map enable

);

assign mcu_i = mcr[23:20];
assign mcu_re_n = ~(~mcr[29] & mcr[30]);
assign na = mcu_me_n ? mcr[53:44] : {ins_ma[6:0] ^ 7'h11, mcr[46:44]};

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
//
// Microcode uses predefined patters to shift,
// psw_xc always takes the bit being shifted out
//
//             mcr[55:44]
// ASLB  .equ  B#00.10101110.01, 35X, RAMU
// ROLB  .equ  B#00.10101110.11, 35X, RAMU
// ASL   .equ  B#00.11101010.01, 35X, RAMU
// ASHCL .equ  B#00.11101010.10, 35X, RAMQU
// ROL   .equ  B#00.11101010.11, 35X, RAMU
// RORB  .equ  B#01.01010111.00, 35X, RAMD
// ASRB  .equ  B#01.11010101.10, 35X, RAMD
// ROR   .equ  B#10.01010111.00, 35X, RAMD
// ASR   .equ  B#10.11010101.10, 35X, RAMD
// ASHXR .equ  B#11.11010101.01, 35X, RAMQD
// ASHCR .equ  B#11.11010101.10, 35X, RAMQD
//
always @(*)
begin
   if (~alu_i[8])
      psw_xc <= psw[0];
   else
      case (mcr[55:54])
         2'b00: psw_xc <= sh_out15;
         2'b01: psw_xc <= sh_out8;
         2'b10: psw_xc <= sh_out0;
         2'b11: psw_xc <= qs_out0;
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

//
// Shift operations chain mux
//
assign sh_bit0  = (mcr[45:44] == 2'b00)
                | (mcr[45:44] == 2'b10) & qs_out15
                | (mcr[45:44] == 2'b11) & psw_c0;
assign sh_bit15 = ~mcr[47] & ((mcr[45:44] == 2'b00)
                           |  (mcr[45:44] == 2'b01) & (alu_v16 ^ alu_f15)
                           |  (mcr[45:44] == 2'b10) & alu_f15
                           |  (mcr[45:44] == 2'b11))
                | ~mcr[53] & psw_c0;

assign sh_bit7  = sh_out8;
assign sh_bit8  = ~mcr[48] & sh_out7
                | ~mcr[52] & sh_bit0;

//______________________________________________________________________________
//
// Bit-slice ALU instantiation
//
am4_alu alu
(
   .clk(tclk),          // ALU clock
   .ena(tena),          // clock enable
   .i(alu_i),           // ALU instruction
   .a(alu_a),           // ALU port A selection
   .b(alu_b),           // ALU port B selection
   .d(alu_d[15:0]),     // ALU data input
   .y(alu_y[15:0]),     // ALU data output
   .r(alu_r[15:0]),     // ALU ram[a] output
   .cin(mcr[9]),        // carry input
   .c8(alu_c8),         // carry output, LSB
   .c16(alu_c16),       // carry output, MSB
   .v8(alu_v8),         // arithmetic overflow, LSB
   .v16(alu_v16),       // arithmetic overflow, MSB
   .zl(alu_zl),         // zero flag, LSB
   .zh(alu_zh),         // zero flag, MSB
   .f7(alu_f7),         // msb of LSB
   .f15(alu_f15),       // msb of MSB
                        //
   .ram0_i(sh_bit0),    // shift register stack lsb LSB
   .ram0_o(sh_out0),    //
   .ram7_i(sh_bit7),    // shift register stack msb LSB
   .ram7_o(sh_out7),    //
   .ram8_i(sh_bit8),    // shift register stack lsb MSB
   .ram8_o(sh_out8),    //
   .ram15_i(sh_bit15),  // shift register stack msb MSB
   .ram15_o(sh_out15),  //
                        //
   .q0_i(1'b0),         // shift Q-register lsb LSB
   .q0_o(qs_out0),      //
   .q15_i(sh_out0),     // shift Q-register msb MSB
   .q15_o(qs_out15)     //
);

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
         2'b11: alu_d[7:0] = alu_r[15:8];
         default: alu_d[7:0] = 8'h00;
      endcase
   else
      alu_d[7:0] = 8'h00;

   if (alu_dh)
      case(mcr[34:33])
         2'b00: alu_d[15:8] = ctr[7:0];
         2'b01: alu_d[15:8] = ad[15:8];
         2'b10: alu_d[15:8] = mcr[55:48];
         2'b11: alu_d[15:8] = alu_r[7:0];
         default: alu_d[15:8] = 8'h00;
      endcase
   else
      alu_d[15:8] = 8'h00;
end

//______________________________________________________________________________
//
endmodule
