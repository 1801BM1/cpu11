`timescale 1ns / 1ps

module vm1_tram (
   doa, dia, addra, clka, wea,
   dob, dib, addrb, clkb, web
);
   output [15:0] doa;
   output [15:0] dob;

   input  [15:0] dia;
   input  [15:0] dib;
   input  [5:0] addra;
   input  [5:0] addrb;
   input  [1:0] wea;
   input  [1:0] web;
   input  clka;
   input  clkb;

   EG_LOGIC_BRAM #( .DATA_WIDTH_A(16),
            .DATA_WIDTH_B(16),
            .ADDR_WIDTH_A(6),
            .ADDR_WIDTH_B(6),
            .DATA_DEPTH_A(64),
            .DATA_DEPTH_B(64),
            .BYTE_ENABLE(8),
            .BYTE_A(2),
            .BYTE_B(2),
            .MODE("DP"),
            .REGMODE_A("NOREG"),
            .REGMODE_B("NOREG"),
            .WRITEMODE_A("READBEFOREWRITE"),
            .WRITEMODE_B("READBEFOREWRITE"),
            .RESETMODE("SYNC"),
            .IMPLEMENT("9K(FAST)"),
            .INIT_FILE("../../lib/vm1_reg.mif"),
            .FILL_ALL("NONE"))
         inst(
            .dia(dia),
            .dib(dib),
            .addra(addra),
            .addrb(addrb),
            .cea(1'b1),
            .ceb(1'b1),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clka),
            .clkb(clkb),
            .wea(1'b0),
            .bea(wea),
            .web(1'b0),
            .beb(web),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(doa),
            .dob(dob));
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

vm1_tram tram(
   .clka(clock),
   .clkb(clock),
   .wea(wea),
   .addra(address_a),
   .dia(data_a),
   .web({wren_b, wren_b}),
   .addrb(address_b),
   .dib(data_b),
   .doa(q_a),
   .dob(q_b)
);
endmodule
