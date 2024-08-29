// 
`timescale 1 ns/1 ps
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

  vcram u_vcram(
        .douta(q_a), //output [15:0] douta
        .doutb(q_b), //output [15:0] doutb
        .clka(clock), //input clka
        .ocea(1'b1), //input ocea
        .cea(1'b1), //input cea
        .reseta(1'b0), //input reseta
        .wrea(wea), //input wrea
        .clkb(clock), //input clkb
        .oceb(1'b1), //input oceb
        .ceb(1'b1), //input ceb
        .resetb(1'b0), //input resetb
        .wreb(2'b00), //input wreb
        .ada(address_a), //input [5:0] ada
        .dina(data_a), //input [15:0] dina
        .adb(address_b), //input [5:0] adb
        .dinb(data_b) //input [15:0] dinb
  );
endmodule
