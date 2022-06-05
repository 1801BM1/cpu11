//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// MCP-1631 MicROM model, special version for Anlogic Eagle EG4S20.
// Tang Dynasty IDE does not recognize the inferred ROM correctly
// and we should engage the explicit ROM IP with initialization file.
//______________________________________________________________________________
//
//
module mcp1631
#(parameter
//______________________________________________________________________________
//
// LSI11_ORIGINAL_MICROM nonzero value means the original DEC Microm
// 1631-10/07/15 content is used, we can optimize 4 MSbs with ordinal logic
// and save memory blocks
//
   LSI11_ORIGINAL_MICROM = 1
)
(
   input          pin_clk,       // main clock
   input  [10:0]  pin_lc,        // location counter
   output [21:0]  pin_mo         // microinstruction bus
);
wire[21:0] q;
reg [10:0] lcr;
reg [3:0] ttl;

//
// Instantiate the ROM IP based on top of BRAM9K
//
EG_LOGIC_BRAM #(
   .DATA_WIDTH_A(22),
   .ADDR_WIDTH_A(11),
   .DATA_DEPTH_A(2048),
   .DATA_WIDTH_B(22),
   .ADDR_WIDTH_B(11),
   .DATA_DEPTH_B(2048),
   .MODE("SP"),
   .REGMODE_A("NOREG"),
   .RESETMODE("SYNC"),
   .IMPLEMENT("9K(FAST)"),
   .DEBUGGABLE("NO"),
   .PACKABLE("NO"),
   .INIT_FILE("../../../lsi/rom/all.mif"),
   .FILL_ALL("NONE"))
   inst(
      .dia({22{1'b0}}),
      .dib({22{1'b0}}),
      .addra(pin_lc),
      .addrb({11{1'b0}}),
      .cea(1'b1),
      .ceb(1'b0),
      .ocea(1'b0),
      .oceb(1'b0),
      .clka(pin_clk),
      .clkb(1'b0),
      .wea(1'b0),
      .web(1'b0),
      .bea(1'b0),
      .beb(1'b0),
      .rsta(1'b0),
      .rstb(1'b0),
      .doa(q),
      .dob());

assign pin_mo[17:0] = q[17:0];
assign pin_mo[21:18] = LSI11_ORIGINAL_MICROM ? ttl[3:0] : q[21:18];
always @ (posedge pin_clk) lcr <= pin_lc;

always @(*)
case(lcr)
   11'h022: ttl <= 4'hC;
   11'h025: ttl <= 4'h9;
   11'h10C: ttl <= 4'h9;
   11'h116: ttl <= 4'hE;
   11'h156: ttl <= 4'hD;
   11'h157: ttl <= 4'hD;
   11'h1C2: ttl <= 4'hF;
   11'h322: ttl <= 4'hB;
   11'h327: ttl <= 4'hA;
   11'h32C: ttl <= 4'hA;
   11'h33B: ttl <= 4'h9;
   11'h346: ttl <= 4'hE;
   11'h347: ttl <= 4'hF;
   default: ttl <= 4'h0;
endcase
endmodule
