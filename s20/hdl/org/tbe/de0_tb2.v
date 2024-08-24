//
// Copyright (c) 2024 by 1801BM1@gmail.com
//
// Testbench for the CM-2420 replica, external UNIBUS version
//______________________________________________________________________________
//
`include "../../tbe/config.v"

//______________________________________________________________________________
//
// Primary testbench top module
//
module tb_s20();

reg         clk;        // processor clock
reg         dclo;       // processor reset
reg         aclo;       // power fail notificaton
reg         intr;       //
reg         npr;        //
reg  [7:4]  br;         // interrupt requests
reg  [15:0] di;         //
reg         ssyn;       //
reg         sack;       //
reg         busy;       // bus busy
                        //
wire        init;       // peripheral reset
wire [15:0] do;         // data bus outputs
wire [21:0] a;          // address bus
wire        bs;         // bank 7 select
wire [1:0]  c;          // type of data transfer
wire        isyn;       // interrupt vector sync output
wire        msyn;       // master sync output
wire [7:4]  bg;         // bus grant for interrupt
wire        npg;        // bus non-processor grant
                        //
reg         tty_tx_rdy; // terminal transmitter ready
reg         tty_tx_ie;  // terminal transmitter interrupt enable
reg         tty_rx_ie;  // terminal receiver interrupt enable
                        //
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
   #`SIM_CONFIG_TIME_LIMIT $finish;
end

//_____________________________________________________________________________
//
initial
begin
   tty_tx_ie   = 0;
   tty_rx_ie   = 0;
   tty_tx_rdy  = 1;

   dclo     = 1;
   aclo     = 1;
   intr     = 0;
   npr      = 0;
   br[7:4]  = 4'b0000;
   di[15:0] = 16'o000000;
   ssyn     = 0;
   sack     = 0;
   busy     = 0;
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
   aclo     = 0;
   $display("Processor ACLO and DCLO deasserted");
end

//_____________________________________________________________________________
//
s20 cpu
(
   .pin_clk(clk),                // processor clock
   .pin_init(init),              // peripheral reset
   .pin_dclo(dclo),              // processor reset
   .pin_aclo(aclo),              // power fail notificaton
   .pin_do(do),                  // data bus outputs
   .pin_di(di),                  // data bus inputs
   .pin_a(a),                    // address bus
   .pin_bs(bs),                  // bank 7 select
   .pin_c(c),                    // type of data transfer
   .pin_isyn(isyn),              // interrupt vector sync output
   .pin_msyn(msyn),              // master sync output
   .pin_ssyn(ssyn),              // slave sync input
   .pin_intr(intr),              // interrupt vector transfer
   .pin_br(br),                  // bus request for interrupt
   .pin_bg(bg),                  // bus grant for interrupt
   .pin_npr(npr),                // bus non-processor request
   .pin_npg(npg),                // bus non-processor grant
   .pin_sack(sack),              // bus acknowlegement
   .pin_busy(busy)               // bus busy
);

//_____________________________________________________________________________
//
endmodule

