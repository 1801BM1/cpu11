// Byte Write Enable—True Dual Port with Byte-Wide Write Enable (Verilog)
// Read-First mode
// bytewrite_tdp_ram_rf.v
// https://docs.amd.com/r/en-US/ug901-vivado-synthesis/Byte-Write-Enable-Block-RAM

module bytewrite_tdp_ram_rf
    #(
    //--------------------------------------------------------------------------
    parameter NUM_COL = 2,
    parameter COL_WIDTH = 8,
    parameter ADDR_WIDTH = 5,
    // Addr Width in bits : 2 *ADDR_WIDTH = RAM Depth
    parameter DATA_WIDTH = NUM_COL*COL_WIDTH // Data Width in bits
    //----------------------------------------------------------------------
    ) (
        input clka,
        input ena,
        input [NUM_COL-1:0] wea,
        input [ADDR_WIDTH-1:0] addra,
        input [DATA_WIDTH-1:0] dina,
        output reg [DATA_WIDTH-1:0] douta,

        input clkb,
        input enb,
        input [NUM_COL-1:0] web,
        input [ADDR_WIDTH-1:0] addrb,
        input [DATA_WIDTH-1:0] dinb,
        output reg [DATA_WIDTH-1:0] doutb
    );

    // Core Memory
    reg [DATA_WIDTH-1:0] ram_block [(2**ADDR_WIDTH)-1:0];

    integer i;
    // Port-A Operation
    always @ (posedge clka) begin
        if(ena) begin
            for(i=0;i<NUM_COL;i=i+1) begin
                if(wea[i]) begin
                    ram_block[addra][i*COL_WIDTH +: COL_WIDTH] <= dina[i*COL_WIDTH +: COL_WIDTH];
                end
            end
            douta <= ram_block[addra];
        end
    end

    // Port-B Operation:
    always @ (posedge clkb) begin
        if(ena) begin
            for(i=0;i<NUM_COL;i=i+1) begin
                if(web[i]) begin
                    ram_block[addrb][i*COL_WIDTH +: COL_WIDTH] <= dinb[i*COL_WIDTH +: COL_WIDTH];
                end
            end
            doutb <= ram_block[addrb];
        end
    end

endmodule // bytewrite_tdp_ram_rf
