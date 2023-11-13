//
// Copyright (c) 2021 by 1801BM1@gmail.com
//
// Testbench for the DC302 ALU decoder
//______________________________________________________________________________
//
`include "../../tbe/config.v"

module tb_302();

integer i;
reg   clk;
reg  [15:0] mi;
tri1 [15:0] ad;
tri1 [15:0] m;
reg  ez_n;
tri1 bs;

//______________________________________________________________________________
//
dc302 alu
(
   .pin_clk(clk),       // main clock
   .pin_ad(ad),         // address/data bus
   .pin_m(m),           // microinstruction bus
   .pin_bs(bs),         // bank select
   .pin_ez_n(ez_n)      // enable Z-state
);

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
assign m = clk ? 16'hZZZZ : mi ;

initial
begin
   mi = 16'hFF00;
   clk = 0;
   ez_n = 1;
   alu.r[8] = 16'h0000;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
   clk = 0;

   for (i='h00; i<'h100; i = i + 1)
   begin
         mi[15:8] = i;
#`SIM_CONFIG_CLOCK_HPERIOD;
         clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
         alu.r[8][0] = 0;
         alu.io_psw = 0;
         alu.io_a0 = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;

         $display("%02X00/%d: %d%d%d %d%d%d%d %d %d%d %d %d%d", i, alu.psw[0],
                  alu.alu_a, alu.alu_b, alu.alu_c,
                  alu.alu_d, alu.alu_e, alu.alu_f, alu.alu_g, alu.alu_h,
                  alu.psw_stb, alu.mid31, alu.cp[0],
                  alu.sext, alu.swap);
#`SIM_CONFIG_CLOCK_HPERIOD;
         clk = 0;

         mi[15:8] = i;
#`SIM_CONFIG_CLOCK_HPERIOD;
         clk = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;
         alu.r[8][0] = 1'b1;
         alu.io_psw = 0;
         alu.io_a0 = 1;
#`SIM_CONFIG_CLOCK_HPERIOD;

         $display("%02X00/%d: %d%d%d %d%d%d%d %d %d%d %d %d%d", i, alu.psw[0],
                  alu.alu_a, alu.alu_b, alu.alu_c,
                  alu.alu_d, alu.alu_e, alu.alu_f, alu.alu_g, alu.alu_h,
                  alu.psw_stb, alu.mid31, alu.cp[0],
                  alu.sext, alu.swap);
#`SIM_CONFIG_CLOCK_HPERIOD;
         clk = 0;
   end
   $finish;
end

//_____________________________________________________________________________
//
endmodule
