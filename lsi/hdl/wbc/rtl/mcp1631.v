//
// Copyright (c) 2014-2019 by 1801BM1@gmail.com
//
// MCP-1631 MicROM model, for debug and simulating only
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

//______________________________________________________________________________
//
// Memory array and its inititialization with 1631-10/07/15 content
// Special embedded memory depth control attribute:
//
`ifdef LSI11_DEPTH_MICROM
//
// Special embedded memory depth control attribute:
//
// `define LSI11_DEPTH_MICROM  (* max_depth = 1024 *)
//
// It should be globally defined as Verilog macro in synthesis
// tool settings (Quartus/ISE) if supported by FPGA family/tool
//
`LSI11_DEPTH_MICROM
`endif
reg [21:0] rom [0:2047];
reg [21:0] q;
reg [10:0] lcr;
reg [3:0] ttl;

initial
begin
//
// The filename for MicROM content might be explicitly
// specified in synthesys/simulating tool settings
//
`ifdef LSI11_FILE_MICROM
   $readmemb(`LSI11_FILE_MICROM, rom);
`else
   $readmemb("../../../../rom/all_22b.rom", rom);
`endif
end

assign pin_mo[17:0] = q[17:0];
assign pin_mo[21:18] = LSI11_ORIGINAL_MICROM ? ttl[3:0] : q[21:18];

always @ (posedge pin_clk) q <= rom[pin_lc];
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
