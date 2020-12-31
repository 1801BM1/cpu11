`include "../../lib/config.v"

// `define QA7_DISTRIBUTED_RAM 1

`ifdef QA7_DISTRIBUTED_RAM
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
wire [1:0] byteena;
reg [1:0]ack;

qa7_dist_ram ram(
   .addra(wb_adr_i[13:1]),
   .clka(wb_clk_i),
   .dina(wb_dat_i),
   .wea( wb_we_i & wb_cyc_i & wb_stb_i),
   .byteena(byteena),
   .douta(wb_dat_o));

assign byteena = wb_we_i ? wb_sel_i : 2'b00;
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end
endmodule


module qa7_dist_ram
(
   input [12:0]   addra,
   input          clka,
   input [15:0]   dina,
   input          wea,
   input [1:0]    byteena,
   output [15:0]  douta
);

(* ram_style="distributed", RAM_DECOMP="power" *)
reg [15:0]  mem [0:8191];
reg [12:0]  areg;
reg [1:0]   wreg;

always @ (posedge clka)
begin
   areg <= addra;
   wreg[0] <= wea & byteena[0];
   wreg[1] <= wea & byteena[1];

   if (wreg[0])
      mem[areg][7:0] <= dina[7:0];
   if (wreg[1])
      mem[areg][15:8] <= dina[15:8];
end

assign douta = mem[areg];
//
// $readmemh is synthezable in XST
// Use inferred block memory instead core generator
// (work too boring, difficult to change content)
//
initial
begin
   $readmemh(`CPU_TEST_MEMF, mem, 0, 8191);
end

endmodule

`else

//______________________________________________________________________________
//
// Initialized RAM block - 8K x 16  using XPM (Xilinx Platform Templats)
// to instantiate BRAMs
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
wire       ena;
wire [1:0] byteena;
reg  [1:0] ack;

assign byteena = wb_we_i ? wb_sel_i : 2'b00;
assign ena = wb_cyc_i & wb_stb_i;
assign wb_ack_o = wb_cyc_i & wb_stb_i & (ack[1] | wb_we_i);
always @ (posedge wb_clk_i)
begin
   ack[0] <= wb_cyc_i & wb_stb_i;
   ack[1] <= wb_cyc_i & ack[0];
end

// xpm_memory_spram: Single Port RAM
// Xilinx Parameterized Macro, version 2018.2
xpm_memory_spram #(
  .ADDR_WIDTH_A(13), // DECIMAL
  .AUTO_SLEEP_TIME(0), // DECIMAL
  .BYTE_WRITE_WIDTH_A(8), // DECIMAL
  .ECC_MODE("no_ecc"), // String
  .MEMORY_INIT_FILE(`CPU_TEST_MEMN), // *.mem filename without path!
  .MEMORY_INIT_PARAM(""), // String
  .MEMORY_OPTIMIZATION("false"), // String
  .MEMORY_PRIMITIVE("auto"), // String
  .MEMORY_SIZE(131072), // DECIMAL in bits
  .MESSAGE_CONTROL(1), // DECIMAL
  .READ_DATA_WIDTH_A(16), // DECIMAL
  .READ_LATENCY_A(1), // DECIMAL
  .READ_RESET_VALUE_A("0"), // String
  .USE_MEM_INIT(1), // DECIMAL
  .WAKEUP_TIME("disable_sleep"), // String
  .WRITE_DATA_WIDTH_A(16), // DECIMAL
  .WRITE_MODE_A("read_first") // String
)
ram (
    .clka(wb_clk_i), // 1-bit input: Clock signal for port A.
    .addra(wb_adr_i[13:1]), // ADDR_WIDTH_A-bit input: Address for port A write and read operations.
    .douta(wb_dat_o), // READ_DATA_WIDTH_A-bit output: Data output for port A read operations.
    .dina(wb_dat_i), // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
    .ena(ena), // 1-bit input: Memory enable signal for port A. Must be high on clock
               // cycles when read or write operations are initiated. Pipelined
               // internally.
    .wea(byteena) // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
                  // data port dina. 1 bit wide when word-wide writes are used. In
                  // byte-wide write configurations, each bit controls the writing one
                  // byte of dina to address addra. For example, to synchronously write
                  // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 16, wea would be
                  // 2'b10.
);
endmodule
`endif


//------------------------------------- PLL section -----------------------------------------------------------
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0____50.000______0.000______50.0______192.113____164.985
// ______c1____50.000____180.000______50.0______192.113____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qa7_pll50

 (// Clock in ports
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output        locked,
  input         inclk0
 );
  // Input buffering
  //------------------------------------
wire inclk0_qa7_pll50;
wire clk_in2_qa7_pll50;
  IBUF clkin1_ibufg(.O(inclk0_qa7_pll50), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qa7_pll50;
  wire        c1_qa7_pll50;
  wire        clk_out3_qa7_pll50;
  wire        clk_out4_qa7_pll50;
  wire        clk_out5_qa7_pll50;
  wire        clk_out6_qa7_pll50;
  wire        clk_out7_qa7_pll50;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qa7_pll50;
  wire        clkfbout_buf_qa7_pll50;
  wire        clkfboutb_unused;
   wire clkout1_unused;
   wire clkout1b_unused;
   wire clkout2_unused;
   wire clkout2b_unused;
   wire clkout3_unused;
   wire clkout3b_unused;
   wire clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (20.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (20.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qa7_pll50),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qa7_pll50),
    .CLKOUT0B            (c1_qa7_pll50),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_qa7_pll50),
    .CLKIN1              (inclk0_qa7_pll50),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------

  BUFG clkf_buf(.O(clkfbout_buf_qa7_pll50), .I(clkfbout_qa7_pll50));
  BUFG clkout1_buf(.O(c0), .I(c0_qa7_pll50));
  BUFG clkout2_buf(.O(c1), .I(c1_qa7_pll50));
endmodule

//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0____66.667______0.000______50.0______178.370____164.985
// ______c1____66.667____180.000______50.0______178.370____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qa7_pll66

 (// Clock in ports
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output        locked,
  input         inclk0
 );
  // Input buffering
  //------------------------------------
wire inclk0_qa7_pll66;
wire clk_in2_qa7_pll66;
  IBUF clkin1_ibufg(.O(inclk0_qa7_pll66), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qa7_pll66;
  wire        c1_qa7_pll66;
  wire        clk_out3_qa7_pll66;
  wire        clk_out4_qa7_pll66;
  wire        clk_out5_qa7_pll66;
  wire        clk_out6_qa7_pll66;
  wire        clk_out7_qa7_pll66;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qa7_pll66;
  wire        clkfbout_buf_qa7_pll66;
  wire        clkfboutb_unused;
   wire clkout1_unused;
   wire clkout1b_unused;
   wire clkout2_unused;
   wire clkout2b_unused;
   wire clkout3_unused;
   wire clkout3b_unused;
   wire clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (20.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (15.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qa7_pll66),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qa7_pll66),
    .CLKOUT0B            (c1_qa7_pll66),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_qa7_pll66),
    .CLKIN1              (inclk0_qa7_pll66),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------

  BUFG clkf_buf(.O(clkfbout_buf_qa7_pll66), .I(clkfbout_qa7_pll66));
  BUFG clkout1_buf(.O(c0), .I(c0_qa7_pll66));
  BUFG clkout2_buf(.O(c1), .I(c1_qa7_pll66));
endmodule

//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0____75.000______0.000______50.0______175.348____160.484
// ______c1____75.000____180.000______50.0______175.348____160.484
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qa7_pll75

 (// Clock in ports
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output        locked,
  input         inclk0
 );
  // Input buffering
  //------------------------------------
wire inclk0_qa7_pll75;
wire clk_in2_qa7_pll75;
  IBUF clkin1_ibufg(.O(inclk0_qa7_pll75), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qa7_pll75;
  wire        c1_qa7_pll75;
  wire        clk_out3_qa7_pll75;
  wire        clk_out4_qa7_pll75;
  wire        clk_out5_qa7_pll75;
  wire        clk_out6_qa7_pll75;
  wire        clk_out7_qa7_pll75;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qa7_pll75;
  wire        clkfbout_buf_qa7_pll75;
  wire        clkfboutb_unused;
   wire clkout1_unused;
   wire clkout1b_unused;
   wire clkout2_unused;
   wire clkout2b_unused;
   wire clkout3_unused;
   wire clkout3b_unused;
   wire clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (19.500),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (13.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qa7_pll75),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qa7_pll75),
    .CLKOUT0B            (c1_qa7_pll75),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_qa7_pll75),
    .CLKIN1              (inclk0_qa7_pll75),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------

  BUFG clkf_buf(.O(clkfbout_buf_qa7_pll75), .I(clkfbout_qa7_pll75));
  BUFG clkout1_buf(.O(c0), .I(c0_qa7_pll75));
  BUFG clkout2_buf(.O(c1), .I(c1_qa7_pll75));
endmodule

//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___100.000______0.000______50.0______162.035____164.985
// ______c1___100.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qa7_pll100

 (// Clock in ports
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output        locked,
  input         inclk0
 );
  // Input buffering
  //------------------------------------
wire inclk0_qa7_pll100;
wire clk_in2_qa7_pll100;
  IBUF clkin1_ibufg(.O (inclk0_qa7_pll100), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qa7_pll100;
  wire        c1_qa7_pll100;
  wire        clk_out3_qa7_pll100;
  wire        clk_out4_qa7_pll100;
  wire        clk_out5_qa7_pll100;
  wire        clk_out6_qa7_pll100;
  wire        clk_out7_qa7_pll100;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qa7_pll100;
  wire        clkfbout_buf_qa7_pll100;
  wire        clkfboutb_unused;
   wire clkout1_unused;
   wire clkout1b_unused;
   wire clkout2_unused;
   wire clkout2b_unused;
   wire clkout3_unused;
   wire clkout3b_unused;
   wire clkout4_unused;
  wire        clkout5_unused;
  wire        clkout6_unused;
  wire        clkfbstopped_unused;
  wire        clkinstopped_unused;

  MMCME2_ADV
  #(.BANDWIDTH            ("OPTIMIZED"),
    .CLKOUT4_CASCADE      ("FALSE"),
    .COMPENSATION         ("ZHOLD"),
    .STARTUP_WAIT         ("FALSE"),
    .DIVCLK_DIVIDE        (1),
    .CLKFBOUT_MULT_F      (20.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (10.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qa7_pll100),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qa7_pll100),
    .CLKOUT0B            (c1_qa7_pll100),
    .CLKOUT1             (clkout1_unused),
    .CLKOUT1B            (clkout1b_unused),
    .CLKOUT2             (clkout2_unused),
    .CLKOUT2B            (clkout2b_unused),
    .CLKOUT3             (clkout3_unused),
    .CLKOUT3B            (clkout3b_unused),
    .CLKOUT4             (clkout4_unused),
    .CLKOUT5             (clkout5_unused),
    .CLKOUT6             (clkout6_unused),
     // Input clock control
    .CLKFBIN             (clkfbout_buf_qa7_pll100),
    .CLKIN1              (inclk0_qa7_pll100),
    .CLKIN2              (1'b0),
     // Tied to always select the primary input clock
    .CLKINSEL            (1'b1),
    // Ports for dynamic reconfiguration
    .DADDR               (7'h0),
    .DCLK                (1'b0),
    .DEN                 (1'b0),
    .DI                  (16'h0),
    .DO                  (do_unused),
    .DRDY                (drdy_unused),
    .DWE                 (1'b0),
    // Ports for dynamic phase shift
    .PSCLK               (1'b0),
    .PSEN                (1'b0),
    .PSINCDEC            (1'b0),
    .PSDONE              (psdone_unused),
    // Other control and status signals
    .LOCKED              (locked_int),
    .CLKINSTOPPED        (clkinstopped_unused),
    .CLKFBSTOPPED        (clkfbstopped_unused),
    .PWRDWN              (1'b0),
    .RST                 (1'b0));

  assign locked = locked_int;
// Clock Monitor clock assigning
//--------------------------------------
 // Output buffering
  //-----------------------------------

  BUFG clkf_buf(.O (clkfbout_buf_qa7_pll100), .I(clkfbout_qa7_pll100));
  BUFG clkout1_buf(.O   (c0), .I(c0_qa7_pll100));
  BUFG clkout2_buf(.O   (c1), .I(c1_qa7_pll100));
endmodule
