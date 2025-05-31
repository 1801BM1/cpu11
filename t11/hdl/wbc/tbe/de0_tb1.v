//
// Copyright (c) 2025 by 1801BM1@gmail.com
//
// Testbench for the T11 replica, native bus version
//______________________________________________________________________________
//
`include "../../tbe/config.v"

module memory
(
   input       [13:0] a,
   input       [15:0] din,
   output reg  [15:0] dout,
   input       [1:0]  wb,
   input              rd
);

reg [15:0] mem [0:8191];
integer i;

always @ (posedge rd) dout = mem[a[13:1]];
always @ (negedge wb[0]) mem[a[13:1]][7:0] = din[7:0];
always @ (negedge wb[1]) mem[a[13:1]][15:8] = din[15:8];

initial
begin
   for (i=0; i<8191; i = i + 1)
   begin
      mem[i] = 16'h0000;
   end
   $readmemh("../../../../tst/out/test.mem", mem);
end
endmodule

//______________________________________________________________________________
//
// Primary testbench top module
//
module tb_t11();

reg         clk;        // processor clock
reg         dclo;       // processor reset
reg         rdy;        //
                        //
wire        bclr;       //
wire        pi;         //
                        //
reg  [1:0]  sm;         //
wire [1:0]  smode;      //
wire [1:0]  wb_n;       //
wire [15:0] dal;        //
wire        cas_n;      //
wire        ras_n;      //
                        //
reg  [15:0] addr;       //
wire [1:0]  wb;         //
wire        rd;         //
wire        ia;         //
                        //
wire        ram_sel;    //
wire        ram_rd;     //
wire [1:0]  ram_wb;     //
wire [15:0] ram_do;     //
wire [15:0] ad_mux;     //
reg  [15:0] ad_reg;     //
wire [15:0] ad_out;     //
                        //
wire        tty_sel;    //
wire        tty_rd;     //
wire        tty_wb;     //
reg         tty_tx_rdy; // terminal transmitter ready
reg         tty_tx_ie;  // terminal transmitter interrupt enable
reg         tty_rx_ie;  // terminal receiver interrupt enable
                        //
wire [2:0]  bsel;       //
wire        vec_sel;    //
wire        vec_wb;     //
reg [7:0]   vec;        //
reg [7:0]   req;        //
reg [3:0]   cp;         //
                        //
integer     i;          //
                        //
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
   #`SIM_CONFIG_TIME_LIMIT $finish;
end

//
// Stop simulation on HALT instruction
// (Shoudl be disabled for halt instruction test)
//
always @(negedge cpu.ir_sth)
begin
   if (~bclr & (cpu.ir == 16'o000000))
   begin
      $display("HALT detected, PC=%06O", cpu.r[7]);
      $finish;
   end
end

//_____________________________________________________________________________
//
initial
begin
   ad_reg = 16'o000000;
   dclo = 1;
   rdy  = 1;
   vec  = 8'o000;
   req  = 8'o000;
   cp   = 4'o00;
   sm   = 11'b00;

//
// CPU start
//
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
   dclo     = 0;
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
@ (negedge clk);
#1
   $display("Processor DCLO deasserted");
end

//_____________________________________________________________________________
//
`ifdef  SIM_CONFIG_DEBUG_IO
always @(negedge rd)
begin
   if (sm == 2'b01)
      $display("Fetch @ %06O, %06O", addr, ad_mux);
   else
      $display("Read  @ %06O, %06O", addr, ad_mux);
end

always @(negedge ia)
begin
   $display("Inta  @ %06O", {dal[15:8], vec});
end

always @(posedge |wb)
begin
   if (wb[0] & wb[1])
      $display("Write @ %06O, %06O", addr, ad_out);
   else
   begin
      if (wb[0] & ~wb[1])
         $display("Write @ %06O, %06O (lsb)", addr, ad_out);
      if (~wb[0] & wb[1])
         $display("Write @ %06O, %06O (msb)", addr, ad_out);
   end
end
`endif

//_____________________________________________________________________________
//
always @(negedge ras_n) addr <= ad_out;
assign ia = ~ras_n & cas_n & (sm == 2'b10);
assign rd = ~ras_n & ~cas_n & pi & wb_n[0] & wb_n[1] & ~sm[1];
assign wb[0] = ~ras_n & ~cas_n & pi & ~wb_n[0] & (sm == 2'b00);
assign wb[1] = ~ras_n & ~cas_n & pi & ~wb_n[1] & (sm == 2'b00);
assign dal = ia ? {8'oZZZ, vec} : rd ? ad_mux : 16'oZZZZZZ;

memory ram(
   .a(addr[13:0]),
   .din(ad_out),
   .dout(ram_do),
   .wb(ram_wb),
   .rd(ram_rd));

assign ram_rd = ram_sel & rd;
assign ram_wb[0] = ram_sel & wb[0];
assign ram_wb[1] = ram_sel & wb[1];
assign ram_sel = ~addr[15] & ~addr[14] & ~bclr;

assign tty_rd = tty_sel & rd;
assign tty_wb = tty_sel & wb[0];
assign tty_sel = (addr[15:3] == 13'o17756) & ~bclr;

assign bsel = `MODE_SELECT_START_ADDR;
assign vec_wb = vec_sel & wb[0];
assign vec_sel = (addr[15:3] == 13'o17770) & ~bclr;

assign ad_mux =  ram_sel ? ram_do : ad_reg;

always @(negedge ras_n or posedge bclr or posedge ras_n)
begin
   if (bclr)
      sm <= 2'b00;
   else
      if (~ras_n)
         sm <= smode;
      else
         sm <= 2'b00;
end

//_____________________________________________________________________________
//
// Serial terminal simulation (Tx only)
//
always @(*)
begin
   if (bclr)
   begin
      tty_tx_ie   <= 0;
      tty_rx_ie   <= 0;
      tty_tx_rdy  <= 1;
   end
end

always @(negedge tty_tx_rdy)
begin
   for (i = 0; i < 256; i = i + 1)
   begin
@ (negedge clk);
@ (posedge clk);
   end
   tty_tx_rdy = 1;
end

always @(*) cp[1] <= tty_tx_rdy & tty_tx_ie;

always @(negedge tty_wb)
begin
   if (addr == 16'o177560)
      tty_rx_ie <= ad_out[6];

   if (addr == 16'o177564)
   begin
      tty_tx_ie <= ad_out[6];
   end

   if (addr == 16'o177566)
   begin
      tty_tx_rdy <= 0;
`ifdef SIM_CONFIG_DEBUG_TTY
      $display("tty: %06O (%c)", ad_out[7:0], (ad_out[7:0] > 8'o37) ? ad_out[7:0] : 8'o52);
`endif
      if (ad_out[7:0] == 8'o100)
      begin
         $display("@ detected, PC=%06O", cpu.r[7]);
         $finish;
      end
   end
end

always @(posedge tty_rd)
begin
   if (addr == 16'o177560)
      ad_reg <= 16'o000200 | (tty_rx_ie << 6);

   if (addr == 16'o177564)
      ad_reg <= (tty_tx_rdy << 7) | (tty_tx_ie << 6);

   if (addr == 16'o177566)
      ad_reg <= 16'o000000;

   if (~tty_sel)
      ad_reg <= 16'o000000;
end

//_____________________________________________________________________________
//
// Interrupt test registers
//
always @(posedge bclr or negedge vec_wb)
begin
   if (bclr)
   begin
      vec <= 8'o000;
      req <= 8'o000;
   end
   else
   begin
      if (addr == 16'o177700)
         req <= ad_out[7:0];
      if (addr == 16'o177702)
         vec <= ad_out[7:0];
   end
end

//_____________________________________________________________________________
//
t11_wb cpu
(
   .vm_clk_p(clk),               // positive processor clock
   .vm_clk_n(~clk),              // negative processor clock
   .vm_clk_ena(1'b1),            // slow clock enable
   .vm_clk_slow(1'b0),           // slow clock sim mode
                                 //
   .vm_init(bclr),               // peripheral reset output
   .vm_dclo(dclo),               // processor reset
   .vm_aclo(req[5]),             // power fail notification
   .vm_halt(req[6]),             // supervisor exception requests
                                 //
   .pin_ad_in(dal),              // bus input
   .pin_ad_out(ad_out),          // bus output
   .pin_sel(smode),              // select output flag
   .pin_wb_n(wb_n),              // read/write low byte
   .pin_ready(rdy | ~cpu.t4),    // bus ready
                                 //
   .pin_ras_n(ras_n),            //
   .pin_cas_n(cas_n),            //
   .pin_pi(pi),                  // priority input strobe
                                 //
   .pin_vec_n(~req[4]),          // vectored interrupt request
   .pin_cp_n(~(req[3:0] | cp)),  // coded interrupt priority
   .vm_bsel(bsel)                //
);

//_____________________________________________________________________________
//
endmodule
