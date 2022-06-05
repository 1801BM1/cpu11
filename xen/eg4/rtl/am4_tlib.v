//
// Copyright (c) 2014-2020 by 1801BM1@gmail.com
//
// M4 processor microcode ROM, special version for Anlogic Eagle EG4S20.
// Tang Dynasty IDE does not recognize the inferred ROM correctly
// and we should engage the explicit ROM IP with initialization file.
//______________________________________________________________________________
//
//
module mcrom
(
   input       clk,     // input clock
   input       ena,     // clock enable
   input [9:0] addr,    // instruction address
   output [55:0] data   // output read opcode
);

wire[55:0] q;

//
// Instantiate the ROM IP based on top of BRAM9K
//
EG_LOGIC_BRAM #(
   .DATA_WIDTH_A(56),
   .ADDR_WIDTH_A(10),
   .DATA_DEPTH_A(1024),
   .DATA_WIDTH_B(56),
   .ADDR_WIDTH_B(10),
   .DATA_DEPTH_B(1024),
   .MODE("SP"),
   .REGMODE_A("NOREG"),
   .RESETMODE("SYNC"),
   .IMPLEMENT("9K(FAST)"),
   .DEBUGGABLE("NO"),
   .PACKABLE("NO"),
   .INIT_FILE("../../../am4/rom/mc.mif"),
   .FILL_ALL("NONE"))
   inst(
      .dia({56{1'b0}}),
      .dib({56{1'b0}}),
      .addra(addr),
      .addrb({10{1'b0}}),
      .cea(ena),
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

assign data[55:0] = q[55:0];

endmodule
