//
// Copyright (C) 1991-2012 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License
// Subscription Agreement, Altera MegaCore Function License
// Agreement, or other applicable license agreement, including,
// without limitation, that your use is for the sole purpose of
// programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the
// applicable agreement for further details.
//
`include "../../lib/config.v"
// synopsys translate_off
`timescale 1ns/10ps
// synopsys translate_on

module  qc5_pll50(

   input wire refclk,
   input wire rst,
   output wire outclk_0,
   output wire outclk_1,
   output wire locked
);

   altera_pll #(
      .fractional_vco_multiplier("false"),
      .reference_clock_frequency("50.0 MHz"),
      .operation_mode("normal"),
      .number_of_clocks(2),
      .output_clock_frequency0("50.000000 MHz"),
      .phase_shift0("0 ps"),
      .duty_cycle0(50),
      .output_clock_frequency1("50.000000 MHz"),
      .phase_shift1("10000 ps"),
      .duty_cycle1(50),
      .output_clock_frequency2("0 MHz"),
      .phase_shift2("0 ps"),
      .duty_cycle2(50),
      .output_clock_frequency3("0 MHz"),
      .phase_shift3("0 ps"),
      .duty_cycle3(50),
      .output_clock_frequency4("0 MHz"),
      .phase_shift4("0 ps"),
      .duty_cycle4(50),
      .output_clock_frequency5("0 MHz"),
      .phase_shift5("0 ps"),
      .duty_cycle5(50),
      .output_clock_frequency6("0 MHz"),
      .phase_shift6("0 ps"),
      .duty_cycle6(50),
      .output_clock_frequency7("0 MHz"),
      .phase_shift7("0 ps"),
      .duty_cycle7(50),
      .output_clock_frequency8("0 MHz"),
      .phase_shift8("0 ps"),
      .duty_cycle8(50),
      .output_clock_frequency9("0 MHz"),
      .phase_shift9("0 ps"),
      .duty_cycle9(50),
      .output_clock_frequency10("0 MHz"),
      .phase_shift10("0 ps"),
      .duty_cycle10(50),
      .output_clock_frequency11("0 MHz"),
      .phase_shift11("0 ps"),
      .duty_cycle11(50),
      .output_clock_frequency12("0 MHz"),
      .phase_shift12("0 ps"),
      .duty_cycle12(50),
      .output_clock_frequency13("0 MHz"),
      .phase_shift13("0 ps"),
      .duty_cycle13(50),
      .output_clock_frequency14("0 MHz"),
      .phase_shift14("0 ps"),
      .duty_cycle14(50),
      .output_clock_frequency15("0 MHz"),
      .phase_shift15("0 ps"),
      .duty_cycle15(50),
      .output_clock_frequency16("0 MHz"),
      .phase_shift16("0 ps"),
      .duty_cycle16(50),
      .output_clock_frequency17("0 MHz"),
      .phase_shift17("0 ps"),
      .duty_cycle17(50),
      .pll_type("General"),
      .pll_subtype("General")
   ) altera_pll_i (
      .rst  (rst),
      .outclk  ({outclk_1, outclk_0}),
      .locked  (locked),
      .fboutclk   ( ),
      .fbclk   (1'b0),
      .refclk  (refclk)
   );
endmodule

module  qc5_pll66(
   input wire refclk,
   input wire rst,
   output wire outclk_0,
   output wire outclk_1,
   output wire locked
);

   altera_pll #(
      .fractional_vco_multiplier("false"),
      .reference_clock_frequency("50.0 MHz"),
      .operation_mode("normal"),
      .number_of_clocks(2),
      .output_clock_frequency0("66.666666 MHz"),
      .phase_shift0("0 ps"),
      .duty_cycle0(50),
      .output_clock_frequency1("66.666666 MHz"),
      .phase_shift1("7500 ps"),
      .duty_cycle1(50),
      .output_clock_frequency2("0 MHz"),
      .phase_shift2("0 ps"),
      .duty_cycle2(50),
      .output_clock_frequency3("0 MHz"),
      .phase_shift3("0 ps"),
      .duty_cycle3(50),
      .output_clock_frequency4("0 MHz"),
      .phase_shift4("0 ps"),
      .duty_cycle4(50),
      .output_clock_frequency5("0 MHz"),
      .phase_shift5("0 ps"),
      .duty_cycle5(50),
      .output_clock_frequency6("0 MHz"),
      .phase_shift6("0 ps"),
      .duty_cycle6(50),
      .output_clock_frequency7("0 MHz"),
      .phase_shift7("0 ps"),
      .duty_cycle7(50),
      .output_clock_frequency8("0 MHz"),
      .phase_shift8("0 ps"),
      .duty_cycle8(50),
      .output_clock_frequency9("0 MHz"),
      .phase_shift9("0 ps"),
      .duty_cycle9(50),
      .output_clock_frequency10("0 MHz"),
      .phase_shift10("0 ps"),
      .duty_cycle10(50),
      .output_clock_frequency11("0 MHz"),
      .phase_shift11("0 ps"),
      .duty_cycle11(50),
      .output_clock_frequency12("0 MHz"),
      .phase_shift12("0 ps"),
      .duty_cycle12(50),
      .output_clock_frequency13("0 MHz"),
      .phase_shift13("0 ps"),
      .duty_cycle13(50),
      .output_clock_frequency14("0 MHz"),
      .phase_shift14("0 ps"),
      .duty_cycle14(50),
      .output_clock_frequency15("0 MHz"),
      .phase_shift15("0 ps"),
      .duty_cycle15(50),
      .output_clock_frequency16("0 MHz"),
      .phase_shift16("0 ps"),
      .duty_cycle16(50),
      .output_clock_frequency17("0 MHz"),
      .phase_shift17("0 ps"),
      .duty_cycle17(50),
      .pll_type("General"),
      .pll_subtype("General")
   ) altera_pll_i (
      .rst  (rst),
      .outclk  ({outclk_1, outclk_0}),
      .locked  (locked),
      .fboutclk   ( ),
      .fbclk   (1'b0),
      .refclk  (refclk)
   );
endmodule

module  qc5_pll75(
   input wire refclk,
   input wire rst,
   output wire outclk_0,
   output wire outclk_1,
   output wire locked
);

   altera_pll #(
      .fractional_vco_multiplier("false"),
      .reference_clock_frequency("50.0 MHz"),
      .operation_mode("normal"),
      .number_of_clocks(2),
      .output_clock_frequency0("75.000000 MHz"),
      .phase_shift0("0 ps"),
      .duty_cycle0(50),
      .output_clock_frequency1("75.000000 MHz"),
      .phase_shift1("6667 ps"),
      .duty_cycle1(50),
      .output_clock_frequency2("0 MHz"),
      .phase_shift2("0 ps"),
      .duty_cycle2(50),
      .output_clock_frequency3("0 MHz"),
      .phase_shift3("0 ps"),
      .duty_cycle3(50),
      .output_clock_frequency4("0 MHz"),
      .phase_shift4("0 ps"),
      .duty_cycle4(50),
      .output_clock_frequency5("0 MHz"),
      .phase_shift5("0 ps"),
      .duty_cycle5(50),
      .output_clock_frequency6("0 MHz"),
      .phase_shift6("0 ps"),
      .duty_cycle6(50),
      .output_clock_frequency7("0 MHz"),
      .phase_shift7("0 ps"),
      .duty_cycle7(50),
      .output_clock_frequency8("0 MHz"),
      .phase_shift8("0 ps"),
      .duty_cycle8(50),
      .output_clock_frequency9("0 MHz"),
      .phase_shift9("0 ps"),
      .duty_cycle9(50),
      .output_clock_frequency10("0 MHz"),
      .phase_shift10("0 ps"),
      .duty_cycle10(50),
      .output_clock_frequency11("0 MHz"),
      .phase_shift11("0 ps"),
      .duty_cycle11(50),
      .output_clock_frequency12("0 MHz"),
      .phase_shift12("0 ps"),
      .duty_cycle12(50),
      .output_clock_frequency13("0 MHz"),
      .phase_shift13("0 ps"),
      .duty_cycle13(50),
      .output_clock_frequency14("0 MHz"),
      .phase_shift14("0 ps"),
      .duty_cycle14(50),
      .output_clock_frequency15("0 MHz"),
      .phase_shift15("0 ps"),
      .duty_cycle15(50),
      .output_clock_frequency16("0 MHz"),
      .phase_shift16("0 ps"),
      .duty_cycle16(50),
      .output_clock_frequency17("0 MHz"),
      .phase_shift17("0 ps"),
      .duty_cycle17(50),
      .pll_type("General"),
      .pll_subtype("General")
   ) altera_pll_i (
      .rst  (rst),
      .outclk  ({outclk_1, outclk_0}),
      .locked  (locked),
      .fboutclk   ( ),
      .fbclk   (1'b0),
      .refclk  (refclk)
   );
endmodule

module  qc5_pll100(
   input wire refclk,
   input wire rst,
   output wire outclk_0,
   output wire outclk_1,
   output wire locked
);

   altera_pll #(
      .fractional_vco_multiplier("false"),
      .reference_clock_frequency("50.0 MHz"),
      .operation_mode("normal"),
      .number_of_clocks(2),
      .output_clock_frequency0("100.000000 MHz"),
      .phase_shift0("0 ps"),
      .duty_cycle0(50),
      .output_clock_frequency1("100.000000 MHz"),
      .phase_shift1("5000 ps"),
      .duty_cycle1(50),
      .output_clock_frequency2("0 MHz"),
      .phase_shift2("0 ps"),
      .duty_cycle2(50),
      .output_clock_frequency3("0 MHz"),
      .phase_shift3("0 ps"),
      .duty_cycle3(50),
      .output_clock_frequency4("0 MHz"),
      .phase_shift4("0 ps"),
      .duty_cycle4(50),
      .output_clock_frequency5("0 MHz"),
      .phase_shift5("0 ps"),
      .duty_cycle5(50),
      .output_clock_frequency6("0 MHz"),
      .phase_shift6("0 ps"),
      .duty_cycle6(50),
      .output_clock_frequency7("0 MHz"),
      .phase_shift7("0 ps"),
      .duty_cycle7(50),
      .output_clock_frequency8("0 MHz"),
      .phase_shift8("0 ps"),
      .duty_cycle8(50),
      .output_clock_frequency9("0 MHz"),
      .phase_shift9("0 ps"),
      .duty_cycle9(50),
      .output_clock_frequency10("0 MHz"),
      .phase_shift10("0 ps"),
      .duty_cycle10(50),
      .output_clock_frequency11("0 MHz"),
      .phase_shift11("0 ps"),
      .duty_cycle11(50),
      .output_clock_frequency12("0 MHz"),
      .phase_shift12("0 ps"),
      .duty_cycle12(50),
      .output_clock_frequency13("0 MHz"),
      .phase_shift13("0 ps"),
      .duty_cycle13(50),
      .output_clock_frequency14("0 MHz"),
      .phase_shift14("0 ps"),
      .duty_cycle14(50),
      .output_clock_frequency15("0 MHz"),
      .phase_shift15("0 ps"),
      .duty_cycle15(50),
      .output_clock_frequency16("0 MHz"),
      .phase_shift16("0 ps"),
      .duty_cycle16(50),
      .output_clock_frequency17("0 MHz"),
      .phase_shift17("0 ps"),
      .duty_cycle17(50),
      .pll_type("General"),
      .pll_subtype("General")
   ) altera_pll_i (
      .rst  (rst),
      .outclk  ({outclk_1, outclk_0}),
      .locked  (locked),
      .fboutclk   ( ),
      .fbclk   (1'b0),
      .refclk  (refclk)
   );
endmodule

// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module qc5_ram16k (
   address,
   byteena,
   clock,
   data,
   rden,
   wren,
   q);

   input [12:0]  address;
   input [1:0]  byteena;
   input   clock;
   input [15:0]  data;
   input   rden;
   input   wren;
   output   [15:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
   tri1  [1:0]  byteena;
   tri1    clock;
   tri1    rden;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

   wire [15:0] sub_wire0;
   wire [15:0] q = sub_wire0[15:0];

   altsyncram  altsyncram_component (
            .address_a (address),
            .byteena_a (byteena),
            .clock0 (clock),
            .data_a (data),
            .rden_a (rden),
            .wren_a (wren),
            .q_a (sub_wire0),
            .aclr0 (1'b0),
            .aclr1 (1'b0),
            .address_b (1'b1),
            .addressstall_a (1'b0),
            .addressstall_b (1'b0),
            .byteena_b (1'b1),
            .clock1 (1'b1),
            .clocken0 (1'b1),
            .clocken1 (1'b1),
            .clocken2 (1'b1),
            .clocken3 (1'b1),
            .data_b (1'b1),
            .eccstatus (),
            .q_b (),
            .rden_b (1'b1),
            .wren_b (1'b0));
   defparam
      altsyncram_component.byte_size = 8,
      altsyncram_component.clock_enable_input_a = "BYPASS",
      altsyncram_component.clock_enable_output_a = "BYPASS",
      altsyncram_component.init_file = `CPU_TEST_FILE,
      altsyncram_component.intended_device_family = "Cyclone V",
      altsyncram_component.lpm_hint = "ENABLE_RUNTIME_MOD=NO",
      altsyncram_component.lpm_type = "altsyncram",
      altsyncram_component.numwords_a = 8192,
      altsyncram_component.operation_mode = "SINGLE_PORT",
      altsyncram_component.outdata_aclr_a = "NONE",
      altsyncram_component.outdata_reg_a = "UNREGISTERED",
      altsyncram_component.power_up_uninitialized = "FALSE",
      altsyncram_component.ram_block_type = "M10K",
      altsyncram_component.read_during_write_mode_port_a = "DONT_CARE",
      altsyncram_component.widthad_a = 13,
      altsyncram_component.width_a = 16,
      altsyncram_component.width_byteena_a = 2;
endmodule

//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16
//
module wbc_mem
(
   input          wb_clk_i,
   input  [15:0]  wb_adr_i,
   input  [15:0]  wb_dat_i,
   output [15:0]  wb_dat_o,
   input          wb_cyc_i,
   input          wb_we_i,
   input  [1:0]   wb_sel_i,
   input          wb_stb_i,
   output         wb_ack_o
);
wire [1:0] ena;
reg  [1:0] ack;

qc5_ram16k ram(
   .address(wb_adr_i[13:1]),
   .byteena(ena),
   .clock(wb_clk_i),
   .data(wb_dat_i),
   .rden(~wb_we_i & wb_cyc_i & wb_stb_i),
   .wren( wb_we_i & wb_cyc_i & wb_stb_i),
   .q(wb_dat_o));

assign ena = wb_we_i ? wb_sel_i : 2'b11;
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end
endmodule
