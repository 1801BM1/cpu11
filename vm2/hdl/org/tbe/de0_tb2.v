//
// Copyright (c) 2014 by 1801BM1@gmail.com
//
// Testbench for the 1801BM2 replica, native QBUS version
//______________________________________________________________________________
//
`include "../../tbe/config.v"

//______________________________________________________________________________
//
module memory
(
   input       [15:0] a,
   input       [15:0] din,
   output reg  [15:0] dout,
   input       wtbt,
   input       read,
   input       write
);
reg [15:0] mem [0:8191];
integer i;

always @ (posedge read)
begin
   dout = mem[a[13:1]];
end

always @ (negedge write)
begin
   if (wtbt)
   begin
      if (a[0])
         mem[a[13:1]][15:8] = din[15:8];
      else
         mem[a[13:1]][7:0] = din[7:0];
   end
   else
      mem[a[13:1]] = din;
end

initial
begin
   for (i=0; i<8191; i = i + 1)
   begin
      mem[i] = 16'h0000;
   end
   $readmemh("..\\..\\..\\..\\tst\\out\\test.mem", mem);
end
endmodule

//______________________________________________________________________________
//
// Primary testbench top module
//
module tb2();
integer i, i0;

wire        clko;       // internal clock
reg         clk;        // processor clock
reg         dclo;       // processor reset
reg         aclo;       // power fail notificaton
reg         evnt;       // timer interrupt requests
reg         halt;       // radial interrupt requests
reg         virq;       // vectored interrupt request
                        //
reg         ar;         //
reg         waki;       //
wire        wrq;        //
tri1        init;       // peripheral reset
                        //
wire [15:0] ad_mux;     //
tri1 [15:0] ad;         // inverted address/data bus
reg  [15:0] ad_reg;     //
reg         ad_oe;      //
                        //
tri1        din;        // data input strobe
tri1        dout;       // data output strobe
tri1        wtbt;       // write/byte status
tri1        sync;       // address strobe
                        //
reg         rply;       // transaction reply
reg         dmr;        // bus request shared line
reg         sack;       // bus acknowlegement
wire        dmgo;       // bus grant output
wire        iako;       // interrupt vector strobe
wire        sel;        //
reg         din_iako;   //
reg         din_sel;    //
reg         din_sync;   //
                        //
reg [15:0]  addr;       //
reg         wflg;       //
reg         sel_all;    //
reg         sel_ram;    //
                        //
reg         tty_tx_rdy; // terminal transmitter ready
reg         tty_tx_ie;  // terminal transmitter interrupt enable
reg         tty_rx_ie;  // terminal receiver interrupt enable
                        //
wire        ram_read, ram_write;

//_____________________________________________________________________________
//
assign      ad    = ad_oe     ? (sel_ram ? ~ad_mux : ~ad_reg) : 16'hZZZZ;

assign      ram_read  = sel_ram & ~din & ~sync;
assign      ram_write = sel_ram & ~dout & ~sync;

memory ram(
   .a(addr),
   .din(~ad),
   .dout(ad_mux),
   .wtbt(~wtbt),
   .read(ram_read),
   .write(ram_write));

always @(negedge sync)
begin
   rply = 1'b1;
   addr <= ~ad;
   wflg <= ~wtbt;

   if (~ad < 16'o040000)
   begin
      sel_all = 1'b1;
      sel_ram = 1'b1;
   end

   if (~ad == 16'o177714)  // 7-segment outhex
      sel_all = 1'b1;
   if (~ad == 16'o177715)
      sel_all = 1'b1;
   if (~ad == 16'o177560)
      sel_all = 1'b1;
   if (~ad == 16'o177564)
      sel_all = 1'b1;
   if (~ad == 16'o177566)
      sel_all = 1'b1;

   if (~sel & (~ad == 16'o000172))
   begin
      $display("Access to halt vector");
      $stop;
   end
end

always @(posedge sync)
begin
   sel_all  = 1'b0;
   sel_ram  = 1'b0;
end

always @(negedge din)
begin
   din_iako = iako;
   din_sel  = sel;
   din_sync = sync;

`ifdef  SIM_CONFIG_DEBUG_IO
@(posedge din)
   if (~din_sync)
      $display("Read  @ %06O (%06O)", addr, ~ad);
   else
      if (~din_sel)
         $display("Read   @ Unadressed");
      else
         if (~din_iako)
            $display("Read  @ Vector");
         else
            $display("Read  @ Invalid");
`endif
end

always @(posedge dout)
begin
`ifdef  SIM_CONFIG_DEBUG_IO
   $display("Write @ %06O (%06O)", addr, ~ad);
`endif
end

always @(posedge din or posedge dout)
begin
@ (negedge clk);
@ (posedge clk);
#2
   ad_oe    = 1'b0;
   rply     = 1'b1;
end

always @(negedge din)
begin
   if (~sync)
   begin
      ar = 1;
      if (addr == 16'o177560)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000200 | (tty_rx_ie << 6);
      end

      if (addr == 16'o177564)
      begin
         ad_oe    = 1'b1;
         ad_reg   = (tty_tx_rdy << 7) | (tty_tx_ie << 6);
      end

      if (addr == 16'o177566)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000000;
      end

      if (sel_all)
      begin

      for (i0=0; i0<`SIM_CONFIG_PREFETCH_BUG; i0 = i0 + 1)
      begin
         @ (negedge clk);
         @ (posedge clk);
      end
#2
         rply   = 1'b0;
         ad_oe  = 1'b1;
      end
   end
end

always @(negedge iako)
begin
   if (~din)
   begin
      if (~virq)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000064;
@ (negedge clk);
//@ (posedge clk);
#2
         virq = 1;
         rply = 1'b0;
      end
   end
end

always @(negedge dout)
begin
   ar = 1;
   if (sel_all)
   begin
//@ (negedge clk);
//@ (posedge clk);
#2
      rply = 1'b0;
   end

   if (addr == 16'o177560)
   begin
      tty_rx_ie = ~ad[6];
   end

   if (addr == 16'o177564)
   begin
      tty_tx_ie = ~ad[6];
      if (tty_tx_rdy & tty_tx_ie)
         virq = 0;
      else
         virq = 1;
   end

   if (addr == 16'o177566)
   begin
      tty_tx_rdy = 0;
      virq       = 1;
`ifdef  SIM_CONFIG_DEBUG_TTY
      $display("tty: %06O (%c))", ~ad, (~ad > 16'o000037) ? (~ad & 8'o377) : 8'o52);
`endif
   end

   if (addr == 16'o177676)
   begin
      $display("Access to shadow register");
      $stop;
   end
end

always @(negedge sync) ar = 0;
always @(posedge sync) ar = 1;

//_____________________________________________________________________________
//
// Terminal registers simulation
//
always @(negedge init)
begin
   tty_tx_ie   = 0;
   tty_rx_ie   = 0;
   tty_tx_rdy  = 1;
   virq        = 1;
end

always @(negedge tty_tx_rdy)
begin
   for (i=0; i<256; i = i + 1)
   begin
@ (negedge clk);
@ (posedge clk);
   end
   tty_tx_rdy = 1;
   if (tty_tx_ie)
      virq = 0;
end
//_____________________________________________________________________________
//
// Clock generator
//
initial
begin
   forever
      begin
         clk = 0;
         #(`SIM_CONFIG_CLOCK_HPERIOD);
         clk = 1;
         #(`SIM_CONFIG_CLOCK_HPERIOD);
      end
end

//_____________________________________________________________________________
//
// Simulation time limit (first breakpoint)
//
initial
begin
   #`SIM_CONFIG_TIME_LIMIT $stop;
end

//_____________________________________________________________________________
//
initial
begin
   tty_tx_ie   = 0;
   tty_rx_ie   = 0;
   tty_tx_rdy  = 1;

   waki     = 0;
   ar       = 1;
   dclo     = 0;
   aclo     = 0;
   evnt     = 1;
   virq     = 1;
   halt     = 1;
   ad_reg   = ~16'h0000;
   ad_oe    = 0;
   rply     = 1;
   sack     = 1;
   dmr      = 1;

//
// CPU start
//
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
   dclo     = 1;
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
#1
   aclo     = 1;
   $display("Processor ACLO and DCLO deasserted");
end

//_____________________________________________________________________________
//
vm2 cpu
(
   .pin_clk(clk),             // processor clock
   .pin_init_n(init),         // peripheral reset
   .pin_dclo_n(dclo),         // processor reset
   .pin_aclo_n(aclo),         // power fail notificaton
   .pin_halt_n(halt),         // halt mode request
   .pin_evnt_n(evnt),         // timer interrupt requests
   .pin_virq_n(virq),         // vectored interrupt request
                              //
   .pin_ar_n(ar)        ,     // address ready strobe
   .pin_dmr_n(dmr),           // bus request line
   .pin_sack_n(sack),         // bus acknowlegement
   .pin_rply_n(rply),         // transaction reply
                              //
   .pin_waki_n(waki),         // window access granted
   .pin_wrq_n(wrq),           // window access request (open drain)
   .pin_clko(clko),           // internal core clock output
   .pin_dmgo_n(dmgo),         // bus granted output
                              //
   .pin_ad_n(ad),             // inverted address/data bus
   .pin_sel_n(sel),           // register select outputs
   .pin_sync_n(sync),         // address strobe
   .pin_wtbt_n(wtbt),         // write/byte status
   .pin_dout_n(dout),         // data output strobe
   .pin_din_n(din),           // data input strobe
   .pin_iako_n(iako)          // interrupt vector input
);

`ifdef SIM_CONFIG_DEBUG_MC
//_____________________________________________________________________________
//
// PLM debug decoded log
//
reg [3*8:0] type;
reg [4*8:0] word;
reg [5*8:0] wdir;
reg [4*8:0] op;
reg [3*8:0] sh;
reg [4*8:0] qbus;
reg [6*8:0] xr;
reg [6*8:0] yr;
reg [6*8:0] vec;
reg [4*8:0] sta;
reg [5:0] pa;
reg [2:0] pix;
reg [2:0] pri;
reg [5:0] pia;

always @ (posedge cpu.core.mc_stb)
begin
   pix = cpu.core.ix;
   pri = cpu.core.ri;
   pia = cpu.core.ia;
end

always @ (negedge cpu.core.mc_stb)
begin
   if (cpu.core.plm[1])
      word = "word";
   else
      word = "byte";

   vec = "------";
   sta = "----";
   case({cpu.core.plm[0], cpu.core.plm[8]})
      2'b00: type = "se0";
      2'b01: type = "se1";
      2'b10: type = "op2";
      2'b11: type = "op1";
      default: type = "***";
   endcase

   if (cpu.core.plm[0])
   begin
      case({cpu.core.plm[26], cpu.core.plm[25]})
         2'b00: sta = "nzvc";
         2'b01: sta = "nzv-";
         2'b10: sta = cpu.core.na[0] ? "cend" : "wsta";
         default: sta = "****";
      endcase
      case({cpu.core.plm[2], cpu.core.plm[3], cpu.core.plm[29]})
         3'b000: wdir = "   *y";
         3'b001: wdir = "   *x";
         3'b010: wdir = "   ac";
         3'b011: wdir = "f2 *x";
         3'b100: wdir = "-----";
         3'b101: wdir = "fr *x";
         3'b110: wdir = "fw ac";
         3'b111: wdir = "fw *x";
         default: type = "******";
      endcase
      case({cpu.core.plm[13], cpu.core.plm[14], cpu.core.plm[15],
            cpu.core.plm[16], cpu.core.plm[17]})
         5'b00000: op = "   y";
         5'b00001: op = "  ~y";
         5'b01000: op = "  ~x";
         5'b01001: op = "   x";
         5'b10001: op = " x-y";
         5'b11000: op = " y-x";
         5'b11001: op = " x+y";
         5'b10000: op = " x^y";
         5'b10010: op = " x|y";
         5'b10100: op = " x&y";
         5'b10101: op = "x&~y";
         default: op = "****";
      endcase
      case({cpu.core.plm[18], cpu.core.plm[19], cpu.core.plm[20]})
         3'b001: sh = "asl";
         3'b010: sh = "asr";
         3'b011: sh = "---";
         3'b101: sh = "rol";
         3'b110: sh = "ror";
         3'b110: sh = "xch";
         default: sh = "***";
      endcase
      //
      // Inverted IOS opcode (related to original docs)
      //
      case({~cpu.core.plm[21], ~cpu.core.plm[22],
            ~cpu.core.plm[23], ~cpu.core.plm[24]})
         4'b0000: qbus = "----";
         4'b0010: qbus = "wdat";
         4'b0100: qbus = "rcmd";
         4'b0101: qbus = "rdat";
         4'b0111: qbus = " rmw";
         4'b1001: qbus = "dcop";
         4'b1010: qbus = "wsha";
         4'b1100: qbus = "rsha";
         4'b1101: qbus = "runa";
         4'b1110: qbus = "pref";
         4'b1111: qbus = "ivec";
         default: qbus = "****";
      endcase
      case({cpu.core.plm[4], cpu.core.plm[5],
            cpu.core.plm[6], cpu.core.plm[7]})
         4'b0000: xr = "  R0  ";
         4'b0001: xr = "  R1  ";
         4'b0010: xr = "  R2  ";
         4'b0011: xr = "  R3  ";
         4'b0100: xr = "  R4  ";
         4'b0101: xr = "  R5  ";
         4'b0110: xr = "  R6  ";
         4'b0111: xr = "  R7  ";
         4'b1000: xr = "EA_RA1";
         4'b1001: xr = "EA_RA2";
         4'b1010: xr = "EA_CNT";
         4'b1011: xr = " R_SRC";
         4'b1100: xr = "  PSW ";
         4'b1101: xr = "  ACC ";
         4'b1110: xr = " AREG ";
         4'b1111: xr = " QREG ";
         default: xr = "******";
      endcase
      if (cpu.core.plm[8])
      begin
         case({cpu.core.plm[9], cpu.core.plm[10],
               cpu.core.plm[11], cpu.core.plm[12]})
            4'b0000: yr = "  cond";
            4'b0001: yr = "bxxoff";
            4'b0010: yr = "000001";
            4'b0011: yr = "000002";
            4'b0100: yr = "000000";
            4'b0101: yr = "000004";
            4'b0110: yr = "00cpsw";
            4'b0111: yr = "   bir";
            4'b1000: yr = "br_off";
            4'b1001: yr = "signex";
            4'b1010: yr = "00000c";
            4'b1011: yr = "000020";
            4'b1100: yr = "vector";
            4'b1101: yr = "000024";
            4'b1110: yr = "   cpc";
            4'b1111: yr = "   cpc";
            default: yr = "******";
         endcase
         if ({cpu.core.plm[9], cpu.core.plm[10],
               cpu.core.plm[11], cpu.core.plm[12]} == 4'b1100)
         begin
         case(cpu.core.vec[3:0])
            4'b0000: vec = "000030";
            4'b0001: vec = "000020";
            4'b0010: vec = "000010";
            4'b0011: vec = "000014";
            4'b0100: vec = "000004";
            4'b0101: vec = "000174";
            4'b0110: vec = "000000";
            4'b1000: vec = "000250";
            4'b1001: vec = "000024";
            4'b1010: vec = "000100";
            4'b1011: vec = "000170";
            4'b1100: vec = "000034";
            4'b1101: vec = "000274";
            default: vec = "******";
         endcase
         end
      end
      else
         case({cpu.core.plm[9], cpu.core.plm[10],
               cpu.core.plm[11], cpu.core.plm[12]})
            4'b0000: yr = "  R0  ";
            4'b0001: yr = "  R1  ";
            4'b0010: yr = "  R2  ";
            4'b0011: yr = "  R3  ";
            4'b0100: yr = "  R4  ";
            4'b0101: yr = "  R5  ";
            4'b0110: yr = "  R6  ";
            4'b0111: yr = "  R7  ";
            4'b1000: yr = "EA_RA1";
            4'b1001: yr = "EA_RA2";
            4'b1010: yr = "EA_CNT";
            4'b1011: yr = " R_SRC";
            4'b1100: yr = "  PSW ";
            4'b1101: yr = "  ACC ";
            4'b1110: yr = " AREG ";
            4'b1111: yr = " QREG ";
            default: yr = "******";
         endcase
   end
   else
   begin
      qbus =" n/a";
      wdir =" n/a";
      op  =" n/a";
      sh = "n/a";
      xr = " n/a";
      yr = " n/a";
   end
   $display("plm[%02O->%02O] %s %s %s %s %s %s %s %s %s %s %06O %06O %06O ir:%06O %1O %1O %02O",
            pa, cpu.core.na, type, word, wdir, sta, xr, yr, vec, op, sh, qbus,
            cpu.core.pc, cpu.core.pc1, cpu.core.pc2,
            cpu.core.ireg, pix, pri, pia);
   pa = cpu.core.na;
end
`endif

//_____________________________________________________________________________
//
endmodule
