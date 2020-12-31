// looks like register file - 64 words 2 ports
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

xvcram xram(
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
