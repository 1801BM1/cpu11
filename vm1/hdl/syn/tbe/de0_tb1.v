//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// Testbench for the 1801BM1 replica, native QBUS version
//______________________________________________________________________________
//
`include "config.v"

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
module tb1();
integer i;

reg         clk;        // processor clock
reg         ena;        // enable clock
reg         sp;         // peripheral timer input
reg [1:0]   pa;         // processor number
reg         dclo;       // processor reset
reg         aclo;       // power fail notificaton
reg [3:1]   irq;        // radial interrupt requests
reg         virq;       // vectored interrupt request
                        //
tri1        init;       // peripheral reset
reg         init_reg;   //
                        //
wire [15:0] ad_mux;     //
tri1 [15:0] ad;         // inverted address/data bus
reg  [15:0] ad_reg;     //
reg         ad_oe;      //
                        //
reg         qb_oe;      //
reg         dmgi;       //
wire        dmgo;       // bus granted output
tri1        din;        // data input strobe
tri1        dout;       // data output strobe
tri1        wtbt;       // write/byte status
tri1        sync;       // address strobe
tri1        rply;       // transaction reply
tri1        dmr;        // bus request shared line
tri1        sack;       // bus acknowlegement
tri1        iako;       // interrupt vector input
tri1        bsy;        //
tri1 [2:1]  sel;        //
                        //
reg         din_reg;    //
reg         dout_reg;   //
reg         wtbt_reg;   //
reg         sync_reg;   //
reg         rply_reg;   //
reg         sack_reg;   //
reg         dmr_reg;    //
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
integer     nclk;
//_____________________________________________________________________________
//
assign      ad    = ad_oe     ? (sel_ram ? ~ad_mux : ~ad_reg) : 16'hZZZZ;
assign      din   = qb_oe     ? din_reg   : 1'bZ;
assign      dout  = qb_oe     ? dout_reg  : 1'bZ;
assign      wtbt  = qb_oe     ? wtbt_reg  : 1'bZ;
assign      sync  = qb_oe     ? sync_reg  : 1'bZ;
assign      iako  = 1'bZ;

assign      rply  = rply_reg  ? 1'bZ      : 1'b0;
assign      sack  = sack_reg  ? 1'bZ      : 1'b0;
assign      dmr   = dmr_reg   ? 1'bZ      : 1'b0;

//_____________________________________________________________________________
//
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
   rply_reg = 1'b1;
   addr <= ~ad;
   wflg <= ~wtbt;

   if (~ad < 16'o020000)
   begin
      sel_all = 1'b1;
      sel_ram = 1'b1;
   end

   if (~ad == 16'o177560)
      sel_all = 1'b1;
   if (~ad == 16'o177564)
      sel_all = 1'b1;
   if (~ad == 16'o177566)
      sel_all = 1'b1;
end

always @(posedge sync)
begin
   sel_all  = 1'b0;
   sel_ram  = 1'b0;
end

`ifdef  CONFIG_SIM_DEBUG_IO
always @(posedge din)
begin
   $display("Read  @ %06O, %06O", addr, ~ad);
end

always @(posedge dout)
begin
   $display("Write @ %06O, %06O", addr, ~ad);
end
`endif

always @(posedge din or posedge dout)
begin
@ (negedge clk);
   rply_reg = 1'b1;
@ (posedge clk);
   ad_oe    = 1'b0;
// #2
// rply_reg = 1'b1;
end

always @(negedge din)
begin
   if (~sync)
   begin
//    $display("Read  @ %06O", addr);
      if (addr == 16'o177716)
      begin
         ad_oe    = 1'b1;
         ad_reg   = `CONFIG_SIM_START_ADDRESS;
      end

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
@ (negedge clk);
//@ (posedge clk);
         rply_reg = 1'b0;
         ad_oe    = 1'b1;
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
         virq = 1;
         rply_reg = 1'b0;
      end
   end
end

always @(negedge dout)
begin
// $display("Write @ %06O", addr);
   if (sel_all)
   begin
// @ (negedge clk);
// @ (posedge clk);
      rply_reg = 1'b0;
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
`ifdef  CONFIG_SIM_DEBUG_TTY
      $display("tty: %06O (%c))", ~ad, (~ad > 16'o000037) ? (~ad & 8'o377) : 8'o52);
`endif
   end

   if (addr == 16'o177676)
   begin
      $display("Access to shadow register");
      $finish;
   end
end

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
   ena = 1;
   forever
      begin
         clk = 0;
         #(`CONFIG_SIM_CLOCK_HPERIOD);
         clk = 1;
         #(`CONFIG_SIM_CLOCK_HPERIOD);
      end
end

//_____________________________________________________________________________
//
// Simulation time limit (first breakpoint)
//
initial
begin
   #`CONFIG_SIM_TIME_LIMIT $finish;
end

//_____________________________________________________________________________
//
initial
begin
   tty_tx_ie   = 0;
   tty_rx_ie   = 0;
   tty_tx_rdy  = 1;
   virq        = 1;

   sp       = 1;
   pa       = 2'b11;
   dmgi     = 1;
   dclo     = 0;
   aclo     = 0;
   irq      = 3'b111;
   init_reg = 1;
   ad_reg   = ~16'h0000;
   ad_oe    = 0;
   qb_oe    = 0;
   din_reg  = 1;
   dout_reg = 1;
   wtbt_reg = 1;
   sync_reg = 1;
   rply_reg = 1;
   sack_reg = 1;
   dmr_reg  = 1;

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
   aclo     = 1;
   $display("Processor ACLO and DCLO deasserted");
end

//_____________________________________________________________________________
//
vm1 cpu0
(
   .pin_clk_p(clk),           // processor clock
   .pin_clk_n(~clk),          // processor clock
   .pin_ena(ena),             // processor clock enable
   .pin_pa_n(pa),             // processor number
   .pin_init_n(init),         // peripheral reset
   .pin_dclo_n(dclo),         // processor reset
   .pin_aclo_n(aclo),         // power fail notificaton
   .pin_irq_n(irq),           // radial interrupt requests
   .pin_virq_n(virq),         // vectored interrupt request
                              //
   .pin_ad_n(ad),             // inverted address/data bus
   .pin_dout_n(dout),         // data output strobe
   .pin_din_n(din),           // data input strobe
   .pin_wtbt_n(wtbt),         // write/byte status
   .pin_sync_n(sync),         // address strobe
   .pin_rply_n(rply),         // transaction reply
   .pin_dmr_n(dmr),           // bus request shared line
   .pin_sack_n(sack),         // bus acknowlegement
   .pin_dmgi_n(dmgi),         // bus granted input
   .pin_dmgo_n(dmgo),         // bus granted output
   .pin_iako_n(iako),         // interrupt vector input
   .pin_sp_n(sp),             // peripheral timer input
   .pin_sel_n(sel),           // register select outputs
   .pin_bsy_n(bsy)            // bus busy flag
);

`ifdef  CONFIG_SIM_DEBUG_MC

always @ (negedge cpu0.core.sop_up)
begin
#1
   $display("mj(%O, %02O, %02X), ir(%06O)",
      cpu0.core.mj[14:12],
      cpu0.core.mj[11:7],
      cpu0.core.mj[6:0],
      cpu0.core.ir);
end

always @ (posedge clk)
begin
   if (cpu0.core.pli_stb)
   begin
#1
   $display("pli(%O)", cpu0.core.mj[14:12]);
   end
   else
   if (cpu0.core.plm1x)
   begin
#1
   $display("p1x(%O)", cpu0.core.mj[14:12]);
   end
end

reg [8*4:0] opcode;
always @ (posedge cpu0.core.plm_stb)
begin
#1
   $display("plm(%012O)", cpu0.core.plm[33:0]);
end

always @ (posedge cpu0.core.plm_ena)
begin
   case({cpu0.core.plr[17],
         cpu0.core.plr[16],
         cpu0.core.plr[14],
         cpu0.core.plr[13]})
//
//    00x00    1     0     1     0     0     0    ~x|~y ~x&~y  ~(x^y)   x+y
//    00x01    1     0     1     0     0     0      -     -       -      -
//    00x10    1     0     0     0     1     0    ~x|~y  ~x    ~(x&~y)  x&~y
//    00x11    1     0     1     0     0     0      -     -       -      -
//    01x00    0     0     1     0     0     1     x|~y  x&~y    x^y    y-x
//    01x01    0     0     1     0     0     1      -     -       -      -
//    01x10    0     0     1     0     1     0    ~x|~y ~x&~y  ~(x^y)   x^y
//    01x11    0     0     1     0     0     1      -     -       -      -
//    10x00    1     1     1     0     1     0    ~x|y  ~x&~y    ~y      y
//    10x01    1     0     0     0     1     0      1    ~x      ~x      x
//    10x10    1     0     1     0     1     0      1   ~x&~y  ~(x|y)   x|y
//    10x11    1     0     0     0     1     0      1    ~x      ~x      x
//    11x00    0     1     0     1     0     0    ~x|y  ~x&y     x^y    x-y
//    11x01    0     1     0     1     0     0      -     -       -      -
//    11x10    1     1     0     0     1     0    ~x|y   ~x    ~(x&y)   x&y
//    11x11    0     1     0     1     0     0      -     -       -      -
//
      4'b0000: opcode = "x+y ";
      4'b0001: opcode = "x+y ";
      4'b0010: opcode = "x&~y";
      4'b0011: opcode = "x+y ";
      4'b0100: opcode = "y-x ";
      4'b0101: opcode = "y-x ";
      4'b0110: opcode = "x^y ";
      4'b0111: opcode = "y-x ";
      4'b1000: opcode = " y  ";
      4'b1001: opcode = " x  ";
      4'b1010: opcode = "x|y ";
      4'b1011: opcode = " x  ";
      4'b1100: opcode = "x-y ";
      4'b1101: opcode = "x-y ";
      4'b1110: opcode = "x&y ";
      4'b1111: opcode = "x-y ";
      default: opcode = "def ";
   endcase

   $display("\nplr(%012O)->(%02X), op(%02O, %s), x(%02O), y(%02O))",
      cpu0.core.plr[33:0],
      {~cpu0.core.plr[0],
        cpu0.core.plr[5],
        cpu0.core.plr[9],
        cpu0.core.plr[15],
       ~cpu0.core.plr[19],
       ~cpu0.core.plr[24],
       ~cpu0.core.plr[29]},

      {cpu0.core.plr[17],
       cpu0.core.plr[16],
       cpu0.core.plr[14],
       cpu0.core.plr[13]}, opcode,

       cpu0.core.plr[33:30],
       cpu0.core.plr[28:25]);
end

always @ (posedge cpu0.core.au_qstbx)
begin
#1
   if (cpu0.core.au_qstbx)
      $display("X2Q=%06O (X)", cpu0.core.x);
end

always @ (negedge cpu0.core.au_qstbd)
begin
#1
   $display("D2Q=%06O (D)", cpu0.core.qreg);
end

always @ (posedge cpu0.core.au_alsl)
begin
#1
   if (cpu0.core.au_alsl)
   begin
      if (cpu0.core.au_pswx)  $display("PSW=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.au_qsx)   $display("DAT=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[0]) $display("R0=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[1]) $display("R1=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[2]) $display("R2=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[3]) $display("R3=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[4]) $display("R4=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[5]) $display("R5=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[6]) $display("R6=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[7]) $display("R7=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[8]) $display("R8=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[9]) $display("R9=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[10]) $display("R10=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[11]) $display("R11=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[12]) $display("R12=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
      if (cpu0.core.vreg.rsw[13]) $display("R13=%06O (X=%06O, Y=%06O) %s", cpu0.core.x, cpu0.core.xreg, ~cpu0.core.yreg, cpu0.core.au_alsh ? "" : "(byte)");
   end
end


always @ (posedge cpu0.core.au_pswx)
begin
#1
   if (cpu0.core.au_pswx & cpu0.core.au_is0)
      $display("X=PSW (%06O)", cpu0.core.x);
   if (cpu0.core.au_pswx & cpu0.core.au_is1)
      $display("X=swap PSW (%06O)", cpu0.core.x);
end

always @ (posedge cpu0.core.au_pswy)
begin
#2
   if (cpu0.core.au_pswy)
      $display("Y=PSW (%06O)", ~cpu0.core.y);
end

always @ (posedge cpu0.core.au_qsx)
begin
#2
   if (cpu0.core.au_qsx & cpu0.core.au_is0)
      $display("X=DAT (%06O)", cpu0.core.x);
   if (cpu0.core.au_qsx & cpu0.core.au_is1)
      $display("X=swap DAT (%06O)", cpu0.core.x);
end

always @ (posedge cpu0.core.vreg.vc_csel)
begin
#2
   if (cpu0.core.vreg.vc_csel)
      $display("Y=%06O (const)", ~cpu0.core.y);
end

always @ (posedge cpu0.core.vreg.vc_vsel)
begin
#2
   if (cpu0.core.vreg.vc_vsel)
      $display("Y=%06O (vector)", ~cpu0.core.y);
end

always @ (posedge cpu0.core.au_astb)
begin
#2
   if (cpu0.core.au_astb) $display("ADR=%06O", cpu0.core.x);
end

reg [8*11:0] qbusop;
always @ (posedge cpu0.core.uplr_stb)
begin
#1
   case(cpu0.core.plrtz[8:6])
//
// plrt[8] - 1/0 - read/write
// plrt[7] - 1 - read/modify/write
// plrt[6] - 1 - byte operation
//
      4'b000: qbusop = "word write";
      4'b001: qbusop = "byte write";
      4'b010: qbusop = "invalid 2";
      4'b011: qbusop = "invalid 3";
      4'b100: qbusop = "word read";
      4'b101: qbusop = "byte read";
      4'b110: qbusop = "word r/m/w";
      4'b111: qbusop = "byte r/m/w";
      default:;
   endcase
   if (cpu0.core.uplr_stb) $display("QBUS=tplm(%O), plrt(%O), %s", cpu0.core.tplm[3:1], cpu0.core.plrtz[8:6], qbusop);
end
`endif
/*
reg   [17:13]  plr;
reg   [15:0]   x, y, f, c, cpred;
reg            cl, alu_b, alu_c, alu_d, alu_e, alu_x;
reg   [15:0]   nx, ny, oxy, axy, h;

task testxy();
begin
// if (alu_e)
   begin
      x = 16'o000000;
      y = 16'o000000;
      $display("   %b %b %b %b %b", &x, &y, &oxy, &axy, &h);
      x = 16'o000000;
      y = 16'o177777;
      $display("   %b %b %b %b %b", &x, &y, &oxy, &axy, &h);
      x = 16'o177777;
      y = 16'o000000;
      $display("   %b %b %b %b %b", &x, &y, &oxy, &axy, &h);
      x = 16'o177777;
      y = 16'o177777;
      $display("   %b %b %b %b %b", &x, &y, &oxy, &axy, &h);
   end
end
endtask

initial
begin

assign ny      = ~y;
assign nx      = alu_x ? ~x : x;
assign oxy     = ~nx | ~((~plr[17] ? ~ny : 16'o000000) | (alu_b ? ny : 16'o000000));
assign axy     = ~nx & ~(alu_d ? ny  : 16'o000000) & ~(alu_c ? ~ny : 16'o000000);
assign h       = (~oxy & ~axy) | (oxy & axy);

assign cl      = ~plr[16] | (plr[17] & alu_e);
assign alu_b   = plr[17] & (plr[16] | (~plr[13] & ~plr[14]));
assign alu_c   = (~plr[13] & (plr[16] ^ plr[17])) | (~alu_e & ~plr[17]);
assign alu_d   = ~alu_e & plr[16] & plr[17];
assign alu_e   = (~plr[13] & plr[14]) | (~plr[16] & plr[17]);
assign alu_x   =  plr[16] & ~plr[17] & ~alu_e;

assign cpred   = {c[14:0], cl};
assign c       = (cpred & oxy) | (~cpred & axy & oxy);
assign f       = ~(cpred ^ h);

   plr = 5'b00000;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b00001;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b00010;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b00011;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();

   plr = 5'b01000;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b01001;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b01010;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b01011;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();

   plr = 5'b10000;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b10001;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b10010;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b10011;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();

   plr = 5'b11000;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b11001;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b11010;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
   plr = 5'b11011;
   $display("%d%d%d%d %d %d %d %d %d %d",
            plr[17], plr[16], plr[14], plr[13],
            cl, alu_b, alu_c, alu_d, alu_e, alu_x);
   testxy();
end
*/
//_____________________________________________________________________________
//
endmodule

