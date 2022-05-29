//
// Copyright (c) 2021 by 1801BM1@gmail.com
//
// Testbench for the F-11 replica, external QBUS version
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
reg [15:0] mem [0:16383];
integer i;

always @ (posedge read)
begin
   dout = mem[a[14:1]];
end

always @ (negedge write)
begin
   if (wtbt)
   begin
      if (a[0])
         mem[a[14:1]][15:8] = din[15:8];
      else
         mem[a[14:1]][7:0] = din[7:0];
   end
   else
      mem[a[14:1]] = din;
end

initial
begin
   for (i=0; i<16384; i = i + 1)
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
module tb_f11();
integer i, i0;

reg         clk;        // processor clock
reg         dclo;       // processor reset
reg         aclo;       // power fail notoficaton
reg         evnt;       // timer interrupt requests
reg         halt;       // radial interrupt requests
reg         virq;       // vectored interrupt request
                        //
tri1        init;       // peripheral reset
wire [1:0]  bsel;       //
wire [15:2] fdin;       //
                        //
wire [15:0] adn;        //
wire [15:0] ad_mux;     //
tri1 [15:0] ad;         // inverted address/data bus
tri1 [21:16] a;         // address extension
reg  [15:0] ad_reg;     //
reg         ad_oe;      //
tri1        xrply;      //
                        //
tri1        bs_n;       //
tri1        umap;       //
tri1        din;        // data input strobe
tri1        dout;       // data output strobe
tri1        wtbt;       // write/byte status
tri1        sync;       // address strobe
                        //
reg         rply;       // transaction reply
wire        iako;       // interrupt vector strobe
reg         din_iako;   //
reg         din_sync;   //
reg         in_iako;    //
                        //
reg [15:0]  addr;       //
reg         bsio;       //
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
assign   bsel = `SIM_CONFIG_BOOT_MODE;
assign   fdin[15:2] = ~14'h0000;
assign   ad = ad_oe ? (sel_ram ? ~ad_mux : ~ad_reg) : 16'hZZZZ;
assign   adn = ~ad;
assign   xrply = rply ? 1'bz : 1'b0;

assign   ram_read  = sel_ram & ~din & ~sync;
assign   ram_write = sel_ram & ~dout & ~sync;

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
   bsio <= ~bs_n;
   wflg <= ~wtbt;

   if (bs_n & (~ad < 16'o100000) & (~a == 6'b000000))
   begin
      sel_all = 1'b1;
      sel_ram = 1'b1;
   end

   if (~bs_n & (~ad[12:0] == 13'o17714))  // 7-segment outhex
      sel_all = 1'b1;
   if (~bs_n & (~ad[12:0] == 13'o17715))
      sel_all = 1'b1;
   if (~bs_n & (~ad[12:0] >= 13'o17560) & (~ad[12:0] <= 13'o17567))
      sel_all = 1'b1;
end

always @(posedge sync)
begin
   sel_all  = 1'b0;
   sel_ram  = 1'b0;
end

always @(negedge din)
begin
   din_iako = iako;
   din_sync = sync;

`ifdef  SIM_CONFIG_DEBUG_IO
@(posedge din)
   if (~din_sync)
      $display("Read  @ %06O (%06O)", addr, ~ad);
   else
      if (~din_iako | in_iako)
         $display("Read  @ Vector");
      else
         $display("Read  @ Invalid");
   in_iako = 0;
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
// @ (posedge clk);
#2
   ad_oe    = 1'b0;
   rply     = 1'b1;
end

always @(negedge din)
begin
   if (~sync & bsio)
   begin
      if (addr[12:0] == 13'o17560)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000000 | (tty_rx_ie << 6);
      end

      if (addr[12:0] == 13'o17562)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000000;
      end

      if (addr[12:0] == 13'o17564)
      begin
         ad_oe    = 1'b1;
         ad_reg   = (tty_tx_rdy << 7) | (tty_tx_ie << 6);
      end

      if (addr[12:0] == 13'o17566)
      begin
         ad_oe    = 1'b1;
         ad_reg   = 16'o000000;
      end
   end
   if (~sync)
   begin
      if (sel_all)
      begin
#2
         rply   = 1'b0;
         ad_oe  = 1'b1;
      end
   end
end

always @(negedge iako)
begin
   in_iako = 1;
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
   if (sel_all)
   begin
//@ (negedge clk);
//@ (posedge clk);
#2
      rply = 1'b0;
   end
   if (bsio)
   begin
      if (addr[12:0] == 13'o17560)
      begin
         tty_rx_ie = ~ad[6];
      end

      if (addr[12:0] == 13'o17564)
      begin
         tty_tx_ie = ~ad[6];
         if (tty_tx_rdy & tty_tx_ie)
            virq = 0;
         else
            virq = 1;
      end

      if (addr[12:0] == 13'o17566)
      begin
         tty_tx_rdy = 0;
         virq       = 1;
`ifdef  SIM_CONFIG_DEBUG_TTY
         $display("tty: %06O (%c)", ~ad & 8'o377,
                  ((~ad & 8'o377) > 16'o000037) ? (~ad & 8'o377) : 8'o52);

         if ((~ad & 8'o377) == 16'o000100)
         begin
            $display("ODT invoked, stop");
            $stop;
         end
`endif
      end
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
   for (i=0; i<500; i = i + 1)
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
         clk = 1;
         #(`SIM_CONFIG_CLOCK_HPERIOD);
         clk = 0;
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

   in_iako  = 0;
   dclo     = 0;
   aclo     = 0;
   evnt     = 1;
   virq     = 1;
   halt     = 1;
   ad_reg   = ~16'h0000;
   ad_oe    = 0;
   rply     = 1;

//
// CPU start
//
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
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
`ifdef CONFIG_F11_CORE_MMU
defparam cpu.F11_CORE_MMU = `CONFIG_F11_CORE_MMU;
`endif

`ifdef CONFIG_F11_CORE_FPP
defparam cpu.F11_CORE_FPP = `CONFIG_F11_CORE_FPP;
`endif

f11 cpu
(
   .pin_clk(clk),                // processor clock
   .pin_init_n(init),            // peripheral reset
   .pin_dclo_n(dclo),            // processor reset
   .pin_aclo_n(aclo),            // power fail notoficaton
   .pin_halt_n(halt),            // halt mode request
   .pin_evnt_n(evnt),            // timer interrupt requests
   .pin_virq_n({virq, 3'b111}),  // vectored interrupt request
                                 //
   .pin_ad_n(ad),                // inverted address/data bus
   .pin_sync_n(sync),            // address strobe
   .pin_wtbt_n(wtbt),            // write/byte status
   .pin_dout_n(dout),            // data output strobe
   .pin_din_n(din),              // data input strobe
   .pin_iako_n(iako),            // interrupt vector input
   .pin_rply_n(xrply),           // transaction reply
                                 //
                                 // boot mode 3 - reserved micROM
   .pin_bsel_n(bsel),            // boot mode 0 - 24/26 vector
   .pin_fdin_n(fdin),            // fast input configuration
   .pin_a_n(a),                  //
   .pin_umap_n(umap),            //
   .pin_bs_n(bs_n)               //
);

`ifdef SIM_CONFIG_DEBUG_MC
//_____________________________________________________________________________
//
// MicROM debug decoded log
//

`endif

//_____________________________________________________________________________
//
endmodule
