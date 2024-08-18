// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

// Mapping of dp_ram32w module to vm3_mmu
// ---------
module vm3_mmu (
   address_a,
   address_b,
   byteena_a,
   byteena_b,
   clock,
   data_a,
   data_b,
   wren_a,
   wren_b,
   q_a,
   q_b);

   input [4:0]  address_a;
   input [4:0]  address_b;
   input [1:0]  byteena_a;
   input [1:0]  byteena_b;
   input   clock;
   input [15:0]  data_a;
   input [15:0]  data_b;
   input   wren_a;
   input   wren_b;
   output   [15:0]  q_a;
   output   [15:0]  q_b;

   wire   [1:0] _wea;
   wire   [1:0] _web;
   wire    ena;
   wire    enb;

assign _wea[1] = wren_a & byteena_a[1];
assign _wea[0] = wren_a & byteena_a[0];
assign _web[1] = wren_b & byteena_b[1];
assign _web[0] = wren_b & byteena_b[0];
assign ena = byteena_a[1]|byteena_a[0];
assign enb = byteena_b[1]|byteena_b[0];

bytewrite_tdp_ram_rf #(
    .NUM_COL(2),
    .COL_WIDTH(8),
    .ADDR_WIDTH(5))  u_vm3_mmu (
  .clka(clock),       // input wire clka
  .ena(ena),          // input wire ena
  .wea(_wea),         // input wire [1 : 0] wea
  .addra(address_a),  // input wire [4 : 0] addra
  .dina(data_a),      // input wire [15 : 0] dina
  .douta(q_a),        // output wire [15 : 0] douta
  .clkb(clock),       // input wire clkb
  .enb(enb),          // input wire enb
  .web(_web),         // input wire [1 : 0] web
  .addrb(address_b),  // input wire [4 : 0] addrb
  .dinb(data_b),      // input wire [15 : 0] dinb
  .doutb(q_b)         // output wire [15 : 0] doutb
);
endmodule
