//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16 using Gowin SDPB primitives (16Kbits)
// to instantiate BRAMs
// Ref: UG285E.pdf / 3.2 Single Port Mode
//
module `CONFIG_WBC_MEM
(
   input          wb_clk_i,
   input  [15:0]  wb_adr_i,
   input  [15:0]  wb_dat_i,
   output [15:0]  wb_dat_o,
   input          wb_cyc_i,
   input          wb_we_i,
   input  [1:0]   wb_sel_i,
   input          wb_stb_i,
   output         wb_ack_o
);
wire       ena;
wire [1:0] byteena;
wire [1:0] bsel; // byte select
reg  [1:0] ack; // 1 clock delay to read memory
//    reg [15:0] wb_dat_o; // FIXME

assign byteena = wb_we_i ? wb_sel_i : 2'b00;
assign bsel = wb_we_i ? wb_sel_i : 2'b11; // write selected, read all bytes
assign ena = wb_cyc_i & wb_stb_i;
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i); // ack with 1 cycle delay
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end

`ifdef CONFIG_CPU_AM4
 `define MEM_ADR_H 13
mem16x8k_am4 u_mem16x8k
`endif

`ifdef CONFIG_CPU_LSI
 `define MEM_ADR_H 13
mem16x8k_lsi u_mem16x8k
`endif

`ifdef CONFIG_CPU_VM1
 `define MEM_ADR_H 13
mem16x8k_vm1 u_mem16x8k
`endif

`ifdef CONFIG_CPU_VM2
 `define MEM_ADR_H 13
mem16x8k_vm2 u_mem16x8k
`endif

`ifdef CONFIG_CPU_F11
 `define MEM_ADR_H 14
mem16x16k_f11 u_mem16x16k
`endif

`ifdef CONFIG_CPU_VM3
 `define MEM_ADR_H 14
mem16x16k_vm3 u_mem16x16k
`endif
(
        .dout(wb_dat_o), //output [15:0] dout
        .clk(wb_clk_i), //input clk
        .oce(1'b1), //input oce
        .ce(ena), //input ce
        .reset(1'b0), //input reset
        .wre(wb_we_i), //input wre
        .ad(wb_adr_i[`MEM_ADR_H:1]), //input [12:0] ad
        .din(wb_dat_i) //input [15:0] din
);
endmodule
