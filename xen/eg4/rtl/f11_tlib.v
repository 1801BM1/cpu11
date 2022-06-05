//
// Copyright (c) 2014-2022 by 1801BM1@gmail.com
//
//______________________________________________________________________________
//
`timescale 1ns / 1ps

module eg4_mmu (
   doa, dia, addra, clka, wea,
   dob, dib, addrb, clkb, web
);
   output [15:0] doa;
   output [15:0] dob;

   input  [15:0] dia;
   input  [15:0] dib;
   input  [4:0] addra;
   input  [4:0] addrb;
   input  [1:0] wea;
   input  [1:0] web;
   input  clka;
   input  clkb;

   EG_LOGIC_BRAM #( .DATA_WIDTH_A(16),
                    .DATA_WIDTH_B(16),
                    .ADDR_WIDTH_A(5),
                    .ADDR_WIDTH_B(5),
                    .DATA_DEPTH_A(32),
                    .DATA_DEPTH_B(32),
                    .BYTE_ENABLE(8),
                    .BYTE_A(2),
                    .BYTE_B(2),
                    .MODE("DP"),
                    .REGMODE_A("NOREG"),
                    .REGMODE_B("NOREG"),
                    .WRITEMODE_A("NORMAL"),
                    .WRITEMODE_B("NORMAL"),
                    .RESETMODE("SYNC"),
                    .IMPLEMENT("9K(FAST)"),
                    .INIT_FILE("NONE"),
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

module dc_mmu (
   input [4:0]  address_a,
   input [4:0]  address_b,
   input [1:0]  byteena_a,
   input [1:0]  byteena_b,
   input   clock,
   input [15:0]  data_a,
   input [15:0]  data_b,
   input   wren_a,
   input   wren_b,
   output   [15:0]  q_a,
   output   [15:0]  q_b
);
wire [1:0] wea;
wire [1:0] web;

assign wea[0] = byteena_a[0] & wren_a;
assign wea[1] = byteena_a[1] & wren_a;
assign web[0] = byteena_b[0] & wren_b;
assign web[1] = byteena_b[1] & wren_b;

eg4_mmu tmmu(
   .doa(q_a),
   .dia(data_a),
   .addra(address_a),
   .clka(clock),
   .wea(wea),
   .dob(q_b),
   .dib(data_b),
   .addrb(address_b),
   .clkb(clock),
   .web(web)
);
endmodule

//______________________________________________________________________________
//
module eg4_fpp (
   doa, dia, addra, cea, clka, wea
);
   output [15:0] doa;

   input  [15:0] dia;
   input  [5:0] addra;
   input  wea;
   input  cea;
   input  clka;

   EG_LOGIC_BRAM #( .DATA_WIDTH_A(16),
                    .ADDR_WIDTH_A(6),
                    .DATA_DEPTH_A(64),
                    .DATA_WIDTH_B(16),
                    .ADDR_WIDTH_B(6),
                    .DATA_DEPTH_B(64),
                    .MODE("SP"),
                    .REGMODE_A("NOREG"),
                    .WRITEMODE_A("NORMAL"),
                    .RESETMODE("SYNC"),
                    .IMPLEMENT("9K(FAST)"),
                    .DEBUGGABLE("NO"),
                    .PACKABLE("NO"),
                    .INIT_FILE("NONE"),
                    .FILL_ALL("NONE"))
   inst(
                    .dia(dia),
                    .dib({16{1'b0}}),
                    .addra(addra),
                    .addrb({6{1'b0}}),
                    .cea(cea),
                    .ceb(1'b0),
                    .ocea(1'b0),
                    .oceb(1'b0),
                    .clka(clka),
                    .clkb(1'b0),
                    .wea(wea),
                    .web(1'b0),
                    .bea(1'b0),
                    .beb(1'b0),
                    .rsta(1'b0),
                    .rstb(1'b0),
                    .doa(doa),
                    .dob());
endmodule

module dc_fpp(
   input         clock,
   input [5:0]   address,
   input [15:0]  data,
   input         wren,
   input         rden,
   output [15:0] q
);

eg4_fpp fpp(
   .doa(q),
   .dia(data),
   .addra(address),
   .cea(rden | wren),
   .clka(clock),
   .wea(wren)
);
endmodule


//______________________________________________________________________________
//
// MicROM module, (128 + 10) lines x 4 pages x 25-bit words
// 25-bit word provides 9-bit next address in the upper bits,
// the rest is 16-bit microcode opcode
//
module dc_rom
#(parameter
//______________________________________________________________________________
//
// DC303_CS defines ROM content of the DC303 ROM module
//  - DC303_CS = 0, 23-001C7-AA, 000.rom
//  - DC303_CS = 1, 23-002C7-AA, 001.rom
//  - DC303_CS = 2, 23-203C7-AA, 002.rom
//
   DC303_ROM = 0
)
(
   input          clk,
   input          cen,
   input [9:0]    a_in,
   output [8:0]   ma,
   output [15:0]  mc
);

wire [8:0] addr;
wire [24:0] q;

//
// Save memory block for the AX extension, only 10 upper MicROM locations depend on AX
// The lower quarter of memory is not used (addresses are reserved for the PLA mapping)
// and this can be engaged to store unique data for the locations with set AX line
//
assign addr[3:0] = a_in[3:0];
assign addr[8:4] = (a_in[9] & (a_in[6:4] == 3'b111)) ? {3'b000, a_in[8:7]} : a_in[8:4];
assign mc = q[15:0];
assign ma = q[24:16];

//
// Instantiate the ROM IP based on top of BRAM9Km with requested content
//
generate
begin : gen_rom
   if (DC303_ROM == 0)
   begin
      EG_LOGIC_BRAM #(
         .DATA_WIDTH_A(25),
         .ADDR_WIDTH_A(9),
         .DATA_DEPTH_A(512),
         .DATA_WIDTH_B(25),
         .ADDR_WIDTH_B(9),
         .DATA_DEPTH_B(512),
         .MODE("SP"),
         .REGMODE_A("NOREG"),
         .RESETMODE("SYNC"),
         .IMPLEMENT("9K(FAST)"),
         .DEBUGGABLE("NO"),
         .PACKABLE("NO"),
         .INIT_FILE("../../../f11/rom/000.mif"),
         .FILL_ALL("NONE"))
         inst(
            .dia({25{1'b0}}),
            .dib({25{1'b0}}),
            .addra(addr),
            .addrb({9{1'b0}}),
            .cea(cen),
            .ceb(1'b0),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clk),
            .clkb(1'b0),
            .wea(1'b0),
            .web(1'b0),
            .bea(1'b0),
            .beb(1'b0),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(q),
            .dob());
   end
   else
   if (DC303_ROM == 1)
   begin
      EG_LOGIC_BRAM #(
         .DATA_WIDTH_A(25),
         .ADDR_WIDTH_A(9),
         .DATA_DEPTH_A(512),
         .DATA_WIDTH_B(25),
         .ADDR_WIDTH_B(9),
         .DATA_DEPTH_B(512),
         .MODE("SP"),
         .REGMODE_A("NOREG"),
         .RESETMODE("SYNC"),
         .IMPLEMENT("9K(FAST)"),
         .DEBUGGABLE("NO"),
         .PACKABLE("NO"),
         .INIT_FILE("../../../f11/rom/001.mif"),
         .FILL_ALL("NONE"))
         inst(
            .dia({25{1'b0}}),
            .dib({25{1'b0}}),
            .addra(addr),
            .addrb({9{1'b0}}),
            .cea(cen),
            .ceb(1'b0),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clk),
            .clkb(1'b0),
            .wea(1'b0),
            .web(1'b0),
            .bea(1'b0),
            .beb(1'b0),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(q),
            .dob());
   end
   else
   if (DC303_ROM == 2)
   begin
      EG_LOGIC_BRAM #(
         .DATA_WIDTH_A(25),
         .ADDR_WIDTH_A(9),
         .DATA_DEPTH_A(512),
         .DATA_WIDTH_B(25),
         .ADDR_WIDTH_B(9),
         .DATA_DEPTH_B(512),
         .MODE("SP"),
         .REGMODE_A("NOREG"),
         .RESETMODE("SYNC"),
         .IMPLEMENT("9K(FAST)"),
         .DEBUGGABLE("NO"),
         .PACKABLE("NO"),
         .INIT_FILE("../../../f11/rom/002.mif"),
         .FILL_ALL("NONE"))
         inst(
            .dia({25{1'b0}}),
            .dib({25{1'b0}}),
            .addra(addr),
            .addrb({9{1'b0}}),
            .cea(cen),
            .ceb(1'b0),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clk),
            .clkb(1'b0),
            .wea(1'b0),
            .web(1'b0),
            .bea(1'b0),
            .beb(1'b0),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(q),
            .dob());
   end
end
endgenerate
endmodule
