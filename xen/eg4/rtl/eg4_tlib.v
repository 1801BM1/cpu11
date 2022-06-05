`define  CONFIG_OSC_CLOCK     24000000
`include "../../lib/config.v"

//______________________________________________________________________________
//
// Input frequency:             24.000Mhz
// Clock multiplication factor: 25
// Clock division factor:       1
// Clock information:
//    Clock name  | Frequency    | Phase shift
//    C0          | 50.000000 MHZ   | 0  DEG
//    C1          | 50.000000 MHZ   | 180DEG
//    C2          | 600.000000MHZ   | 0  DEG
//
`timescale 1 ns / 100 fs

module eg4_pll50(refclk,
      reset,
      extlock,
      clk0_out,
      clk1_out,
      clk2_out);

   input refclk;
   input reset;
   output extlock;
   output clk0_out;
   output clk1_out;
   output clk2_out;

   wire clk2_buf;

   EG_LOGIC_BUFG bufg_feedback( .i(clk2_buf), .o(clk2_out) );

   EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
      .DYNCFG("DISABLE"),
      .FIN("24.000"),
      .FEEDBK_MODE("NORMAL"),
      .FEEDBK_PATH("CLKC2_EXT"),
      .STDBY_ENABLE("DISABLE"),
      .PLLRST_ENA("ENABLE"),
      .SYNC_ENABLE("DISABLE"),
      .DERIVE_PLL_CLOCKS("DISABLE"),
      .GEN_BASIC_CLOCK("ENABLE"),
      .GMC_GAIN(2),
      .ICP_CURRENT(9),
      .KVCO(2),
      .LPF_CAPACITOR(1),
      .LPF_RESISTOR(8),
      .REFCLK_DIV(1),
      .FBCLK_DIV(25),
      .CLKC0_ENABLE("ENABLE"),
      .CLKC0_DIV(12),
      .CLKC0_CPHASE(11),
      .CLKC0_FPHASE(0),
      .CLKC1_ENABLE("ENABLE"),
      .CLKC1_DIV(12),
      .CLKC1_CPHASE(5),
      .CLKC1_FPHASE(0),
      .CLKC2_ENABLE("ENABLE"),
      .CLKC2_DIV(1),
      .CLKC2_CPHASE(1),
      .CLKC2_FPHASE(0)  )
   pll_inst (.refclk(refclk),
      .reset(reset),
      .stdby(1'b0),
      .extlock(extlock),
      .psclk(1'b0),
      .psdown(1'b0),
      .psstep(1'b0),
      .psclksel(3'b000),
      .psdone(open),
      .dclk(1'b0),
      .dcs(1'b0),
      .dwe(1'b0),
      .di(8'b00000000),
      .daddr(6'b000000),
      .do({open, open, open, open, open, open, open, open}),
      .fbclk(clk2_out),
      .clkc({open, open, clk2_buf, clk1_out, clk0_out}));
endmodule

//______________________________________________________________________________
//
// Input frequency:             24.000Mhz
// Clock multiplication factor: 25
// Clock division factor:       1
// Clock information:
//    Clock name  | Frequency    | Phase shift
//    C0          | 66.666667 MHZ   | 0  DEG
//    C1          | 66.666667 MHZ   | 180DEG
//    C2          | 600.000000MHZ   | 0  DEG
//
module eg4_pll66(refclk,
      reset,
      extlock,
      clk0_out,
      clk1_out,
      clk2_out);

   input refclk;
   input reset;
   output extlock;
   output clk0_out;
   output clk1_out;
   output clk2_out;

   wire clk2_buf;

   EG_LOGIC_BUFG bufg_feedback( .i(clk2_buf), .o(clk2_out) );

   EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
      .DYNCFG("DISABLE"),
      .FIN("24.000"),
      .FEEDBK_MODE("NORMAL"),
      .FEEDBK_PATH("CLKC2_EXT"),
      .STDBY_ENABLE("DISABLE"),
      .PLLRST_ENA("ENABLE"),
      .SYNC_ENABLE("DISABLE"),
      .DERIVE_PLL_CLOCKS("DISABLE"),
      .GEN_BASIC_CLOCK("DISABLE"),
      .GMC_GAIN(2),
      .ICP_CURRENT(9),
      .KVCO(2),
      .LPF_CAPACITOR(1),
      .LPF_RESISTOR(8),
      .REFCLK_DIV(1),
      .FBCLK_DIV(25),
      .CLKC0_ENABLE("ENABLE"),
      .CLKC0_DIV(9),
      .CLKC0_CPHASE(8),
      .CLKC0_FPHASE(0),
      .CLKC1_ENABLE("ENABLE"),
      .CLKC1_DIV(9),
      .CLKC1_CPHASE(3),
      .CLKC1_FPHASE(4),
      .CLKC2_ENABLE("ENABLE"),
      .CLKC2_DIV(1),
      .CLKC2_CPHASE(1),
      .CLKC2_FPHASE(0)  )
   pll_inst (.refclk(refclk),
      .reset(reset),
      .stdby(1'b0),
      .extlock(extlock),
      .psclk(1'b0),
      .psdown(1'b0),
      .psstep(1'b0),
      .psclksel(3'b000),
      .psdone(open),
      .dclk(1'b0),
      .dcs(1'b0),
      .dwe(1'b0),
      .di(8'b00000000),
      .daddr(6'b000000),
      .do({open, open, open, open, open, open, open, open}),
      .fbclk(clk2_out),
      .clkc({open, open, clk2_buf, clk1_out, clk0_out}));
endmodule

//______________________________________________________________________________
//
// Input frequency:             24.000Mhz
// Clock multiplication factor: 25
// Clock division factor:       1
// Clock information:
//    Clock name  | Frequency    | Phase shift
//    C0          | 75.000000 MHZ   | 0  DEG
//    C1          | 75.000000 MHZ   | 180DEG
//    C2          | 600.000000MHZ   | 0  DEG
//
module eg4_pll75(refclk,
      reset,
      extlock,
      clk0_out,
      clk1_out,
      clk2_out);

   input refclk;
   input reset;
   output extlock;
   output clk0_out;
   output clk1_out;
   output clk2_out;

   wire clk2_buf;

   EG_LOGIC_BUFG bufg_feedback( .i(clk2_buf), .o(clk2_out) );

   EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
      .DYNCFG("DISABLE"),
      .FIN("24.000"),
      .FEEDBK_MODE("NORMAL"),
      .FEEDBK_PATH("CLKC2_EXT"),
      .STDBY_ENABLE("DISABLE"),
      .PLLRST_ENA("ENABLE"),
      .SYNC_ENABLE("DISABLE"),
      .DERIVE_PLL_CLOCKS("DISABLE"),
      .GEN_BASIC_CLOCK("DISABLE"),
      .GMC_GAIN(2),
      .ICP_CURRENT(9),
      .KVCO(2),
      .LPF_CAPACITOR(1),
      .LPF_RESISTOR(8),
      .REFCLK_DIV(1),
      .FBCLK_DIV(25),
      .CLKC0_ENABLE("ENABLE"),
      .CLKC0_DIV(8),
      .CLKC0_CPHASE(7),
      .CLKC0_FPHASE(0),
      .CLKC1_ENABLE("ENABLE"),
      .CLKC1_DIV(8),
      .CLKC1_CPHASE(3),
      .CLKC1_FPHASE(0),
      .CLKC2_ENABLE("ENABLE"),
      .CLKC2_DIV(1),
      .CLKC2_CPHASE(1),
      .CLKC2_FPHASE(0)  )
   pll_inst (.refclk(refclk),
      .reset(reset),
      .stdby(1'b0),
      .extlock(extlock),
      .psclk(1'b0),
      .psdown(1'b0),
      .psstep(1'b0),
      .psclksel(3'b000),
      .psdone(open),
      .dclk(1'b0),
      .dcs(1'b0),
      .dwe(1'b0),
      .di(8'b00000000),
      .daddr(6'b000000),
      .do({open, open, open, open, open, open, open, open}),
      .fbclk(clk2_out),
      .clkc({open, open, clk2_buf, clk1_out, clk0_out}));
endmodule

//______________________________________________________________________________
//
// Input frequency:             24.000Mhz
// Clock multiplication factor: 25
// Clock division factor:       1
// Clock information:
//    Clock name  | Frequency    | Phase shift
//    C0          | 100.000000MHZ   | 0  DEG
//    C1          | 100.000000MHZ   | 180DEG
//    C2          | 600.000000MHZ   | 0  DEG
//
module eg4_pll100(refclk,
      reset,
      extlock,
      clk0_out,
      clk1_out,
      clk2_out);

   input refclk;
   input reset;
   output extlock;
   output clk0_out;
   output clk1_out;
   output clk2_out;

   wire clk2_buf;

   EG_LOGIC_BUFG bufg_feedback( .i(clk2_buf), .o(clk2_out) );

   EG_PHY_PLL #(.DPHASE_SOURCE("DISABLE"),
      .DYNCFG("DISABLE"),
      .FIN("24.000"),
      .FEEDBK_MODE("NORMAL"),
      .FEEDBK_PATH("CLKC2_EXT"),
      .STDBY_ENABLE("DISABLE"),
      .PLLRST_ENA("ENABLE"),
      .SYNC_ENABLE("DISABLE"),
      .DERIVE_PLL_CLOCKS("ENABLE"),
      .GEN_BASIC_CLOCK("ENABLE"),
      .GMC_GAIN(2),
      .ICP_CURRENT(9),
      .KVCO(2),
      .LPF_CAPACITOR(1),
      .LPF_RESISTOR(8),
      .REFCLK_DIV(1),
      .FBCLK_DIV(25),
      .CLKC0_ENABLE("ENABLE"),
      .CLKC0_DIV(6),
      .CLKC0_CPHASE(5),
      .CLKC0_FPHASE(0),
      .CLKC1_ENABLE("ENABLE"),
      .CLKC1_DIV(6),
      .CLKC1_CPHASE(2),
      .CLKC1_FPHASE(0),
      .CLKC2_ENABLE("ENABLE"),
      .CLKC2_DIV(1),
      .CLKC2_CPHASE(1),
      .CLKC2_FPHASE(0)  )
   pll_inst (.refclk(refclk),
      .reset(reset),
      .stdby(1'b0),
      .extlock(extlock),
      .psclk(1'b0),
      .psdown(1'b0),
      .psstep(1'b0),
      .psclksel(3'b000),
      .psdone(open),
      .dclk(1'b0),
      .dcs(1'b0),
      .dwe(1'b0),
      .di(8'b00000000),
      .daddr(6'b000000),
      .do({open, open, open, open, open, open, open, open}),
      .fbclk(clk2_out),
      .clkc({open, open, clk2_buf, clk1_out, clk0_out}));
endmodule

//______________________________________________________________________________
//
module eg4_ram16k ( doa, dia, addra, clka, wea );
   output [15:0] doa;
   input  [15:0] dia;
   input  [12:0] addra;
   input  [1:0] wea;
   input  clka;

   EG_LOGIC_BRAM #( .DATA_WIDTH_A(16),
            .ADDR_WIDTH_A(13),
            .DATA_DEPTH_A(8192),
            .DATA_WIDTH_B(16),
            .ADDR_WIDTH_B(13),
            .DATA_DEPTH_B(8192),
            .BYTE_ENABLE(8),
            .BYTE_A(2),
            .BYTE_B(2),
            .MODE("SP"),
            .REGMODE_A("NOREG"),
            .WRITEMODE_A("WRITETHROUGH"),
            .RESETMODE("SYNC"),
            .IMPLEMENT("32K"),
            .DEBUGGABLE("NO"),
            .PACKABLE("NO"),
            .INIT_FILE(`CPU_TEST_FILE),
            .FILL_ALL("NONE"))
         inst(
            .dia(dia),
            .dib({16{1'b0}}),
            .addra(addra),
            .addrb({13{1'b0}}),
            .cea(1'b1),
            .ceb(1'b0),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clka),
            .clkb(1'b0),
            .wea(1'b0),
            .bea(wea),
            .beb(2'b0),
            .web(1'b0),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(doa),
            .dob());
endmodule

//______________________________________________________________________________
//
module eg4_ram32k ( doa, dia, addra, clka, wea );

   output [15:0] doa;

   input  [15:0] dia;
   input  [13:0] addra;
   input  [1:0] wea;
   input  clka;

   EG_LOGIC_BRAM #( .DATA_WIDTH_A(16),
            .ADDR_WIDTH_A(14),
            .DATA_DEPTH_A(16384),
            .DATA_WIDTH_B(16),
            .ADDR_WIDTH_B(14),
            .DATA_DEPTH_B(16384),
            .BYTE_ENABLE(8),
            .BYTE_A(2),
            .BYTE_B(2),
            .MODE("SP"),
            .REGMODE_A("NOREG"),
            .WRITEMODE_A("NORMAL"),
            .RESETMODE("SYNC"),
            .IMPLEMENT("32K"),
            .DEBUGGABLE("NO"),
            .PACKABLE("NO"),
               .INIT_FILE(`CPU_TEST_FILE),
            .FILL_ALL("NONE"))
         inst(
            .dia(dia),
            .dib({16{1'b0}}),
            .addra(addra),
            .addrb({14{1'b0}}),
            .cea(1'b1),
            .ceb(1'b0),
            .ocea(1'b0),
            .oceb(1'b0),
            .clka(clka),
            .clkb(1'b0),
            .wea(1'b0),
            .bea(wea),
            .web(1'b0),
            .beb(2'b00),
            .rsta(1'b0),
            .rstb(1'b0),
            .doa(doa),
            .dob());
endmodule

//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16
//
module wbc_mem
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
wire [1:0] ena;
reg  [1:0] ack;

eg4_ram16k ram(
   .clka(wb_clk_i),
   .addra(wb_adr_i[13:1]),
   .dia(wb_dat_i),
   .doa(wb_dat_o),
   .wea(ena));

assign ena[0] = wb_cyc_i & wb_stb_i & wb_we_i & wb_sel_i[0];
assign ena[1] = wb_cyc_i & wb_stb_i & wb_we_i & wb_sel_i[1];
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end
endmodule

//______________________________________________________________________________
//
// Initialized RAM block - 16K x 16
//
module wbc_mem_32k
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
wire [1:0] ena;
reg  [1:0] ack;

eg4_ram32k ram(
   .clka(wb_clk_i),
   .addra(wb_adr_i[14:1]),
   .dia(wb_dat_i),
   .doa(wb_dat_o),
   .wea(ena));

assign ena[0] = wb_cyc_i & wb_stb_i & wb_we_i & wb_sel_i[0];
assign ena[1] = wb_cyc_i & wb_stb_i & wb_we_i & wb_sel_i[1];
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end
endmodule

