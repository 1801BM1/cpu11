// 
// Block RAM with Resettable Data Output
// File: rams_sp_rf_rst.v
//---
// https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Single-Port-Block-RAM-with-Resettable-Data-Output-Verilog

module ram_sp_nc
#(
//--------------------------------------------------------------------------
    parameter NUM_COL = 2,  // 2 bytes width
    parameter COL_WIDTH = 8, // 8 bit per byte
    parameter ADDR_WIDTH = 13, // 8KB
// Addr Width in bits : 2 *ADDR_WIDTH = RAM Depth
    parameter DATA_WIDTH = NUM_COL*COL_WIDTH,  // Data Width in bits
    parameter MEMF = "test.mem"
//----------------------------------------------------------------------
)
(
    input                   clk,
    input                   en,
    input [NUM_COL-1:0]     we,
    input [ADDR_WIDTH-1:0]  addr,
    input [DATA_WIDTH-1:0]  din,
    output reg [DATA_WIDTH-1:0] dout
);    

    // core memory
    reg [DATA_WIDTH-1:0] ram [2**ADDR_WIDTH-1:0];
    integer i;


always @(posedge clk)
    begin
        if (en) // optional enable
        begin
            if (we) // write enable
                for(i=0; i < NUM_COL; i=i+1) begin
                    if(we[i]) begin
                        ram[addr][i*COL_WIDTH +: COL_WIDTH] <= din[i*COL_WIDTH +: COL_WIDTH];
                    end
                end
	    else
	        dout <= ram[addr];
        end
    end

    initial
    begin
       $readmemh(MEMF, ram, 0, 2**ADDR_WIDTH-1);
    end

endmodule
