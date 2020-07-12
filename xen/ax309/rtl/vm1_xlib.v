////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995-2013 Xilinx, Inc.  All rights reserved.
////////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: P.20131013
//  \   \         Application: netgen
//  /   /         Filename: vm1_xram.v
// /___/   /\     Timestamp: Sat Feb 02 21:02:22 2019
// \   \  /  \
//  \___\/\___\
//
// Command  : -w -sim -ofmt verilog R:/TEMP/tmp/_cg/vm1_xram.ngc R:/TEMP/tmp/_cg/vm1_xram.v
// Device   : 6slx9ftg256-2
// Input file  : R:/TEMP/tmp/_cg/vm1_xram.ngc
// Output file : R:/TEMP/tmp/_cg/vm1_xram.v
// # of Modules   : 1
// Design Name : vm1_xram
// Xilinx        : D:\Xilinx\14.7\ISE_DS\ISE\
//
// Purpose:
//     This verilog netlist is a verification model and uses simulation
//     primitives which may not represent the true implementation of the
//     device, however the netlist is functionally correct and should not
//     be modified. This file cannot be synthesized and should only be used
//     with supported simulation tools.
//
// Reference:
//     Command Line Tools User Guide, Chapter 23 and Synthesis and Simulation Design Guide, Chapter 6
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/1 ps

module vm1_xram (
  clka, clkb, wea, addra, dina, web, addrb, dinb, douta, doutb
)/* synthesis syn_black_box syn_noprune=1 */;
  input clka;
  input clkb;
  input [1 : 0] wea;
  input [5 : 0] addra;
  input [15 : 0] dina;
  input [1 : 0] web;
  input [5 : 0] addrb;
  input [15 : 0] dinb;
  output [15 : 0] douta;
  output [15 : 0] doutb;

  // synthesis translate_off

  wire N0;
  wire N1;
  wire \NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPADOP<1>_UNCONNECTED ;
  wire \NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPADOP<0>_UNCONNECTED ;
  wire \NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPBDOP<1>_UNCONNECTED ;
  wire \NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPBDOP<0>_UNCONNECTED ;
  VCC   XST_VCC (
    .P(N0)
  );
  GND   XST_GND (
    .G(N1)
  );
  RAMB8BWER #(
    .DATA_WIDTH_A ( 18 ),
    .DATA_WIDTH_B ( 18 ),
    .DOA_REG ( 0 ),
    .DOB_REG ( 0 ),
    .EN_RSTRAM_A ( "FALSE" ),
    .EN_RSTRAM_B ( "FALSE" ),
    .INITP_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_01 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_02 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INITP_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_00 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_01 ( 256'h000000000000001CE0020040001400B8E00A0018FFCE0004000C00080010E006 ),
    .INIT_02 ( 256'h00000008FF0000000010FFBE800000000001FFFFFFCE00000002000000E00000 ),
    .INIT_03 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_04 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_05 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_06 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_07 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_08 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_09 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_0F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_10 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_11 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_12 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_13 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_14 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_15 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_16 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_17 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_18 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_19 ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1A ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1B ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1C ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1D ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1E ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_1F ( 256'h0000000000000000000000000000000000000000000000000000000000000000 ),
    .INIT_A ( 18'h00000 ),
    .INIT_B ( 18'h00000 ),
    .INIT_FILE ( "NONE" ),
    .RAM_MODE ( "TDP" ),
    .RSTTYPE ( "SYNC" ),
    .RST_PRIORITY_A ( "CE" ),
    .RST_PRIORITY_B ( "CE" ),
    .SIM_COLLISION_CHECK ( "ALL" ),
    .SRVAL_A ( 18'h00000 ),
    .SRVAL_B ( 18'h00000 ),
    .WRITE_MODE_A ( "WRITE_FIRST" ),
    .WRITE_MODE_B ( "WRITE_FIRST" ))
  \U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram  (
    .RSTBRST(N1),
    .ENBRDEN(N0),
    .REGCEA(N1),
    .ENAWREN(N0),
    .CLKAWRCLK(clka),
    .CLKBRDCLK(clkb),
    .REGCEBREGCE(N1),
    .RSTA(N1),
    .WEAWEL({wea[1], wea[0]}),
    .DOADO({douta[15], douta[14], douta[13], douta[12], douta[11], douta[10], douta[9], douta[8], douta[7], douta[6], douta[5], douta[4], douta[3],
douta[2], douta[1], douta[0]}),
    .DOPADOP({
\NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPADOP<1>_UNCONNECTED ,
\NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPADOP<0>_UNCONNECTED }),
    .DOPBDOP({
\NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPBDOP<1>_UNCONNECTED ,
\NLW_U0/xst_blk_mem_generator/gnativebmg.native_blk_mem_gen/valid.cstr/ramloop[0].ram.r/s6_init.ram/TRUE_DP.PRIM9.ram_DOPBDOP<0>_UNCONNECTED }),
    .WEBWEU({web[1], web[0]}),
    .ADDRAWRADDR({N1, N1, N1, addra[5], addra[4], addra[3], addra[2], addra[1], addra[0], N1, N1, N1, N1}),
    .DIPBDIP({N1, N1}),
    .DIBDI({dinb[15], dinb[14], dinb[13], dinb[12], dinb[11], dinb[10], dinb[9], dinb[8], dinb[7], dinb[6], dinb[5], dinb[4], dinb[3], dinb[2],
dinb[1], dinb[0]}),
    .DIADI({dina[15], dina[14], dina[13], dina[12], dina[11], dina[10], dina[9], dina[8], dina[7], dina[6], dina[5], dina[4], dina[3], dina[2],
dina[1], dina[0]}),
    .ADDRBRDADDR({N1, N1, N1, addrb[5], addrb[4], addrb[3], addrb[2], addrb[1], addrb[0], N1, N1, N1, N1}),
    .DOBDO({doutb[15], doutb[14], doutb[13], doutb[12], doutb[11], doutb[10], doutb[9], doutb[8], doutb[7], doutb[6], doutb[5], doutb[4], doutb[3],
doutb[2], doutb[1], doutb[0]}),
    .DIPADIP({N1, N1})
  );
// synthesis translate_on
endmodule

module vm1_vcram (
   input [5:0]    address_a,
   input [5:0]    address_b,
   input [1:0]    byteena_a,
   input          clock,
   input [15:0]   data_a,
   input [15:0]   data_b,
   input          wren_a,
   input          wren_b,
   output [15:0]  q_a,
   output [15:0]  q_b
);
wire [1:0] wea;

assign wea[0] = byteena_a[0] & wren_a;
assign wea[1] = byteena_a[1] & wren_a;

vm1_xram xram(
   .clka(clock),
   .clkb(clock),
   .wea(wea),
   .addra(address_a),
   .dina(data_a),
   .web({wren_b, wren_b}),
   .addrb(address_b),
   .dinb(data_b),
   .douta(q_a),
   .doutb(q_b)
);
endmodule
