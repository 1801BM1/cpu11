//
// Copyright (c) 2020 by 1801BM1@gmail.com
//
// M4 / LSI-11M synchronous model with Wishbone interfaces
//______________________________________________________________________________
//
module am4_wb
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
   output         wbm_ios_o,     // master wishbone I/O select
   output [15:0]  wbm_adr_o,     // master wishbone address
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
                                 //
   input [1:0]    vm_bsel        // boot mode selector
);

//______________________________________________________________________________
//
reg         init;                // peripheral init
reg         aclo, aclo0;         // power failure request
reg         evnt, evnt0;         // timer interrupt request
reg  [7:0]  irq;                 // interrupt requests
wire [2:0]  iv;                  // interrupt value encoded
                                 //
wire        io_sync;             //
wire        io_dout;             //
wire        io_wtbt;             //
wire        io_iako;             //
wire        io_din;              //
wire        io_rdy;              // primary clock enable
                                 //
wire        io_wait;             //
wire        iow_stb;             //
wire        ior_stb;             //
wire        adr_stb;             //
wire        wb_reset;            //
                                 //
reg  [15:0] dreg_i;              // input data register
reg  [15:0] dreg_o;              // output data register
reg  [15:0] areg;                // address register
reg         aios;                // I/O bank address
                                 //
wire        wb_start;            //
wire        wb_wclr, wb_wset;    //
reg         wb_swait;            //
reg  [5:0]  wb_wcnt;             //
                                 //
reg         wb_cyc;              //
reg         wb_stb;              //
reg         wb_we;               //
reg  [1:0]  wb_sel;              //
reg         wb_iak;              //
wire        wb_wdone,            //
            wb_rdone,            //
            wb_idone;            //
reg         wbm_cont, wbi_cont;  //
reg         sync0, iako0;        //
reg         din0, dout0;         //
                                 //
reg         qt_req;              // Q-bus timer request
reg  [5:0]  qt_cnt;              // Q-bus timer counter
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
// Bus microcode control
//
assign io_sync = ~mcr[38];
assign io_dout =  mcr[37];
assign io_wtbt = ~mcr[36] & mcr[43];
assign io_iako = ~mcr[36] & mcr[40];
assign io_din  = ~mcr[36] & mcr[41];
assign io_wait = mcr[35];

//______________________________________________________________________________
//
// Reset circuits
//
always @(posedge vm_clk_p or posedge vm_dclo)
begin
   if (vm_dclo)
      init <= 1'b1;
   else
      init <= ~clr_init & (set_init | init);
end

assign vm_init = init;
assign mcu_za = cc8 | irq[0] & irq[1];
//______________________________________________________________________________
//
// Microcode ROM instantiation
//
mcrom rom
(
   .clk(vm_clk_p),   // output register clock
   .ena(io_rdy),     // clock enable
   .addr(ma),        // next address to fetch
   .data(mcr)        // micro instruction opcode
);

//______________________________________________________________________________
//
// Initial instruction decode
//
always @(posedge vm_clk_p or posedge init)
begin
   if (init)
      ireg <= 16'h0000;
   else
      if (io_rdy & ir_stb)
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
assign reg_ena  = (mcr[32] & ~mcr[29]) & ~vm_dclo;
assign clr_init = reg_ena & mcr[52:50] == 3'b001;
assign clr_ref  = reg_ena & mcr[52:50] == 3'b010;
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

always @(posedge vm_clk_p or posedge vm_dclo)
begin
   if (vm_dclo)
      cc6 <= 1'b0;
   else
      if (clr_ref)
         cc6 <= 1'b0;
      else
         if (qt_req)
            cc6 <= 1'b1;
end

always @(posedge vm_clk_p) cc7 = aclo0;
always @(posedge vm_clk_p) cc8 = vm_dclo;

//______________________________________________________________________________
//
// Interrupt controller
//
always @(posedge vm_clk_p)
begin
   aclo0 <= vm_aclo;
   if (clr_aclo | vm_dclo)
      aclo <= 1'b0;
   else
      if (vm_aclo & ~aclo0)
         aclo <= 1'b1;
end

always @(posedge vm_clk_p)
begin
   evnt0 <= vm_evnt;
   if (clr_evnt | vm_dclo)
      evnt <= 1'b0;
   else
      if (vm_evnt & ~evnt0)
         evnt <= 1'b1;
end

always @(posedge vm_clk_p or posedge vm_dclo)
begin
   if (vm_dclo)
      irq <= 8'h00;
   else
      if (io_rdy)
      begin
         irq[0] <= cc6;
         irq[1] <= ~irq[0];
         irq[2] <= vm_virq & ~psw[7];
         irq[3] <= evnt & ~psw[7];
         irq[4] <= vm_halt;
         irq[5] <= aclo;
         irq[6] <= psw[4];
         irq[7] <= 1'b0;
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
// Microinstruction address sequencer
//
am4_seq seq(
   .clk(vm_clk_p),         // main clock
   .ena(io_rdy),           // clock enable
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
      4'b0100: mcu_ora = {1'b0, vm_bsel};                // boot mode
      4'b0101: mcu_ora = {1'b0, areg[0], mcbr_f[3]};     // byte exchange
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

always @(posedge vm_clk_p) if (~mcu_me_n) mcu_bf = ins_bf;

assign mcbr_f[1] = ireg[5:3] == 3'b000;   // dst mode is not register
assign mcbr_f[2] = ireg[11:9] == 3'b000;  // src mode is not register
assign mcbr_f[3] = mcu_bf;
assign mcbr_f[4] = ~(alu_a[2] & alu_a[1]);

//______________________________________________________________________________
//
// Microcode application counter
//
always @(posedge vm_clk_p)
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

always @(posedge vm_clk_p or posedge init)
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

always @(posedge vm_clk_p or posedge init)
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
   .clk(vm_clk_p),      // ALU clock
   .ena(io_rdy),        // clock enable
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
always @(posedge vm_clk_p or posedge init)
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
         2'b01: alu_d[7:0] = dreg_i[7:0];
         2'b10: alu_d[7:0] = mcr[47:40];
         2'b11: alu_d[7:0] = alu_r[15:8];
         default: alu_d[7:0] = 8'h00;
      endcase
   else
      alu_d[7:0] = 8'h00;

   if (alu_dh)
      case(mcr[34:33])
         2'b00: alu_d[15:8] = ctr[7:0];
         2'b01: alu_d[15:8] = dreg_i[15:8];
         2'b10: alu_d[15:8] = mcr[55:48];
         2'b11: alu_d[15:8] = alu_r[7:0];
         default: alu_d[15:8] = 8'h00;
      endcase
   else
      alu_d[15:8] = 8'h00;
end


//______________________________________________________________________________
//
// Bus transaction timer
//
always @(posedge vm_clk_p or posedge vm_dclo)
begin
   if (vm_dclo)
   begin
      qt_cnt <= 6'b000000;
      qt_req <= 1'b0;
   end
   else
      if ((wbm_stb_o & wbm_gnt_i) | wbi_stb_o)
      begin
         qt_cnt <= qt_cnt + 6'b000001;
         qt_req <= &qt_cnt;
      end
      else
      begin
         qt_cnt <= 6'b000000;
         qt_req <= 1'b0;
      end
end

//______________________________________________________________________________
//
// Clock enable, depending on I/O ready
//
assign io_rdy = cc6 | cc8
              | ~(io_wait & io_sync & ~wbm_cont)
              & ~(io_wait & io_iako & ~wbi_cont);

//______________________________________________________________________________
//
// Wishbone master and interrupt interfaces
//
assign iow_stb    = io_dout & ~dout0;
assign ior_stb    = io_din & ~din0;
assign adr_stb    = io_sync & ~sync0;

assign wb_start   = ~wb_wset & (ior_stb | iow_stb) | (wb_wclr & wb_swait);
assign wb_wdone   = wb_stb & wbm_ack_i & wb_we;
assign wb_rdone   = wb_stb & wbm_ack_i & ~wb_we;
assign wb_idone   = wb_iak & wbi_ack_i;
assign wb_reset   = qt_req | vm_dclo;

assign wbm_ios_o  = aios;
assign wbm_adr_o  = areg;
assign wbm_dat_o  = dreg_o;
assign wbm_cyc_o  = wb_cyc;
assign wbm_we_o   = wb_we;
assign wbm_stb_o  = wb_stb;
assign wbm_sel_o  = wb_sel;
assign wbi_stb_o  = wb_iak;

assign wb_wset    = (ior_stb | iow_stb) & vm_clk_slow & (wb_wcnt != 6'o00);
assign wb_wclr    = wb_reset | ~vm_clk_slow | (vm_clk_ena & (wb_wcnt == 6'o01));

//
// Interrupt Wishbone is simplified and has no clock moderator
//
always @(posedge vm_clk_p)
begin
   iako0 <= io_iako;
   if (~io_iako | wb_reset)
      wbi_cont <= 1'b0;
   else
      if (io_iako & wb_idone)
         wbi_cont <= 1'b1;

   if (~io_iako | wb_idone | wb_reset)
      wb_iak <= 1'b0;
   else
      if (io_iako & ~iako0)
         wb_iak <= 1'b1;
end

//
// Wishbone Master state machine
//
always @(posedge vm_clk_p)
begin
   sync0 <= io_sync & ~vm_dclo;
   dout0 <= io_dout & ~vm_dclo;
   din0  <= io_din  & ~vm_dclo;
   //
   // Store the operation address and data
   //
   if (adr_stb)
      areg <= alu_y;
   if (adr_stb)
      aios <= &alu_y[15:13];
   if (iow_stb)
      dreg_o <= alu_y;
   //
   // Clock moderator delays the I/O transaction
   // beginning till counter elapsed
   //
   if (wb_wclr)
      wb_swait <= 1'b0;
   else
      if (wb_wset)
         wb_swait <= 1'b1;

   if (wb_reset)
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
   //
   // Strobe bus data receiving registers
   //
   if (wb_idone | wb_rdone)
      dreg_i <= io_iako ? wbi_dat_i : wbm_dat_i;

   if (wb_reset | ~io_sync)
   begin
      //
      // Master wishbone abort/reset
      //
      wb_cyc <= 1'b0;
      wb_we  <= 1'b0;
      wb_sel <= 2'b00;
      wb_stb <= 1'b0;
      wbm_cont <= 1'b0;
   end
   else
      if (wb_start)
      begin
         //
         // Start master bus read/read-modify write transaction
         //
         if (ior_stb)
         begin
            wb_cyc <= 1'b1;
            wb_we  <= 1'b0;
            wb_sel <= 2'b11;
            wb_stb <= 1'b1;
            wbm_cont <= 1'b0;
         end
         else
            if (iow_stb)
            begin
               wb_cyc <= 1'b1;
               wb_we  <= 1'b1;
               wb_sel[0] <= ~io_wtbt | ~areg[0];
               wb_sel[1] <= ~io_wtbt |  areg[0];
               wb_stb <= 1'b1;
               wbm_cont <= 1'b0;
            end
      end
      else
      begin
         if (wb_rdone)
         begin
            //
            // Read cycle of read-modify-write completion
            //
            wb_sel <= 2'b00;
            wb_stb <= 1'b0;
            wbm_cont <= 1'b1;
         end
         else
            if (wb_wdone)
            begin
               //
               // Write cycle completion
               //
               wb_cyc <= 1'b0;
               wb_we  <= 1'b0;
               wb_sel <= 2'b00;
               wb_stb <= 1'b0;
               wbm_cont <= 1'b1;
            end
            else
               if (io_sync & ~io_din)
                  wbm_cont <= 1'b0;
      end
end

//______________________________________________________________________________
//
endmodule
