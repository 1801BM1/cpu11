`timescale 1ps/1ps
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

`ifdef CONFIG_PLL_50
module qk7_pll50

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
wire inclk0_qk7_pll50;
wire clk_in2_qk7_pll50;
  IBUF clkin1_ibufg(.O(inclk0_qk7_pll50), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll50;
  wire        c1_qk7_pll50;
  wire        clk_out3_qk7_pll50;
  wire        clk_out4_qk7_pll50;
  wire        clk_out5_qk7_pll50;
  wire        clk_out6_qk7_pll50;
  wire        clk_out7_qk7_pll50;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll50;
  wire        clkfbout_buf_qk7_pll50;
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
    .CLKFBOUT            (clkfbout_qk7_pll50),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll50),
    .CLKOUT0B            (c1_qk7_pll50),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll50),
    .CLKIN1              (inclk0_qk7_pll50),
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

  BUFG clkf_buf(.O(clkfbout_buf_qk7_pll50), .I(clkfbout_qk7_pll50));
  BUFG clkout1_buf(.O(c0), .I(c0_qk7_pll50));
  BUFG clkout2_buf(.O(c1), .I(c1_qk7_pll50));
endmodule
`endif

`ifdef CONFIG_PLL_66
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

module qk7_pll66

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
wire inclk0_qk7_pll66;
wire clk_in2_qk7_pll66;
  IBUF clkin1_ibufg(.O(inclk0_qk7_pll66), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll66;
  wire        c1_qk7_pll66;
  wire        clk_out3_qk7_pll66;
  wire        clk_out4_qk7_pll66;
  wire        clk_out5_qk7_pll66;
  wire        clk_out6_qk7_pll66;
  wire        clk_out7_qk7_pll66;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll66;
  wire        clkfbout_buf_qk7_pll66;
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
    .CLKFBOUT            (clkfbout_qk7_pll66),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll66),
    .CLKOUT0B            (c1_qk7_pll66),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll66),
    .CLKIN1              (inclk0_qk7_pll66),
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

  BUFG clkf_buf(.O(clkfbout_buf_qk7_pll66), .I(clkfbout_qk7_pll66));
  BUFG clkout1_buf(.O(c0), .I(c0_qk7_pll66));
  BUFG clkout2_buf(.O(c1), .I(c1_qk7_pll66));
endmodule
`endif

`ifdef CONFIG_PLL_75
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

module qk7_pll75

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
wire inclk0_qk7_pll75;
wire clk_in2_qk7_pll75;
  IBUF clkin1_ibufg(.O(inclk0_qk7_pll75), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll75;
  wire        c1_qk7_pll75;
  wire        clk_out3_qk7_pll75;
  wire        clk_out4_qk7_pll75;
  wire        clk_out5_qk7_pll75;
  wire        clk_out6_qk7_pll75;
  wire        clk_out7_qk7_pll75;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll75;
  wire        clkfbout_buf_qk7_pll75;
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
    .CLKFBOUT            (clkfbout_qk7_pll75),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll75),
    .CLKOUT0B            (c1_qk7_pll75),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll75),
    .CLKIN1              (inclk0_qk7_pll75),
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

  BUFG clkf_buf(.O(clkfbout_buf_qk7_pll75), .I(clkfbout_qk7_pll75));
  BUFG clkout1_buf(.O(c0), .I(c0_qk7_pll75));
  BUFG clkout2_buf(.O(c1), .I(c1_qk7_pll75));
endmodule
`endif

`ifdef CONFIG_PLL_100
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

module qk7_pll100

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
wire inclk0_qk7_pll100;
wire clk_in2_qk7_pll100;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll100), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll100;
  wire        c1_qk7_pll100;
  wire        clk_out3_qk7_pll100;
  wire        clk_out4_qk7_pll100;
  wire        clk_out5_qk7_pll100;
  wire        clk_out6_qk7_pll100;
  wire        clk_out7_qk7_pll100;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll100;
  wire        clkfbout_buf_qk7_pll100;
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
    .CLKFBOUT            (clkfbout_qk7_pll100),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll100),
    .CLKOUT0B            (c1_qk7_pll100),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll100),
    .CLKIN1              (inclk0_qk7_pll100),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll100), .I(clkfbout_qk7_pll100));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll100));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll100));
endmodule
`endif

`ifdef CONFIG_PLL_85
//----------------------------------------------------------------------------
// User entered comments
//----------------------------------------------------------------------------
// None
//
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0____85.000______0.000______50.0______186.163____155.540
// ______c1____85.000____180.000______50.0______186.163____155.540
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qk7_pll85

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
wire inclk0_qk7_pll85;
wire clk_in2_qk7_pll85;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll85),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll85;
  wire        c1_qk7_pll85;
  wire        clk_out3_qk7_pll85;
  wire        clk_out4_qk7_pll85;
  wire        clk_out5_qk7_pll85;
  wire        clk_out6_qk7_pll85;
  wire        clk_out7_qk7_pll85;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll85;
  wire        clkfbout_buf_qk7_pll85;
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
    .CLKFBOUT_MULT_F      (17.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll85),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll85),
    .CLKOUT0B            (c1_qk7_pll85),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll85),
    .CLKIN1              (inclk0_qk7_pll85),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll85),
    .I (clkfbout_qk7_pll85));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll85));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll85));

endmodule
`endif

`ifdef CONFIG_PLL_150
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___150.000______0.000______50.0______162.035____164.985
// ______c1___150.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

module qk7_pll150

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
wire inclk0_qk7_pll150;
wire clk_in2_qk7_pll150;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll150), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll150;
  wire        c1_qk7_pll150;
  wire        clk_out3_qk7_pll150;
  wire        clk_out4_qk7_pll150;
  wire        clk_out5_qk7_pll150;
  wire        clk_out6_qk7_pll150;
  wire        clk_out7_qk7_pll150;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll150;
  wire        clkfbout_buf_qk7_pll150;
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
    .CLKFBOUT_MULT_F      (15.000),
    .CLKFBOUT_PHASE       (0.000),
    .CLKFBOUT_USE_FINE_PS ("FALSE"),
    .CLKOUT0_DIVIDE_F     (5.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll150),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll150),
    .CLKOUT0B            (c1_qk7_pll150),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll150),
    .CLKIN1              (inclk0_qk7_pll150),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll150), .I(clkfbout_qk7_pll150));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll150));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll150));
endmodule
`endif

`ifdef CONFIG_PLL_166
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___166.000______0.000______50.0______162.035____164.985
// ______c1___166.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

module qk7_pll166

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
wire inclk0_qk7_pll166;
wire clk_in2_qk7_pll166;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll166), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll166;
  wire        c1_qk7_pll166;
  wire        clk_out3_qk7_pll166;
  wire        clk_out4_qk7_pll166;
  wire        clk_out5_qk7_pll166;
  wire        clk_out6_qk7_pll166;
  wire        clk_out7_qk7_pll166;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll166;
  wire        clkfbout_buf_qk7_pll166;
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
    .CLKOUT0_DIVIDE_F     (6.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll166),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll166),
    .CLKOUT0B            (c1_qk7_pll166),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll166),
    .CLKIN1              (inclk0_qk7_pll166),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll166), .I(clkfbout_qk7_pll166));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll166));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll166));
endmodule
`endif

`ifdef CONFIG_PLL_175
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___175.000______0.000______50.0______162.035____164.985
// ______c1___175.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qk7_pll175

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
wire inclk0_qk7_pll175;
wire clk_in2_qk7_pll175;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll175), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll175;
  wire        c1_qk7_pll175;
  wire        clk_out3_qk7_pll175;
  wire        clk_out4_qk7_pll175;
  wire        clk_out5_qk7_pll175;
  wire        clk_out6_qk7_pll175;
  wire        clk_out7_qk7_pll175;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll175;
  wire        clkfbout_buf_qk7_pll175;
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
    .CLKOUT0_DIVIDE_F     (6.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll175),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll175),
    .CLKOUT0B            (c1_qk7_pll175),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll175),
    .CLKIN1              (inclk0_qk7_pll175),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll175), .I(clkfbout_qk7_pll175));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll175));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll175));
endmodule
`endif

`ifdef CONFIG_PLL_200
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___200.000______0.000______50.0______162.035____164.985
// ______c1___200.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

module qk7_pll200

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
wire inclk0_qk7_pll200;
wire clk_in2_qk7_pll200;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll200), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll200;
  wire        c1_qk7_pll200;
  wire        clk_out3_qk7_pll200;
  wire        clk_out4_qk7_pll200;
  wire        clk_out5_qk7_pll200;
  wire        clk_out6_qk7_pll200;
  wire        clk_out7_qk7_pll200;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll200;
  wire        clkfbout_buf_qk7_pll200;
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
    .CLKOUT0_DIVIDE_F     (5.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll200),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll200),
    .CLKOUT0B            (c1_qk7_pll200),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll200),
    .CLKIN1              (inclk0_qk7_pll200),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll200), .I(clkfbout_qk7_pll200));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll200));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll200));
endmodule
`endif

`ifdef CONFIG_PLL_133
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___133.333______0.000______50.0______162.035____164.985
// ______c1___133.333____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010


module qk7_pll133

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
wire inclk0_qk7_pll133;
wire clk_in2_qk7_pll133;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll133), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll133;
  wire        c1_qk7_pll133;
  wire        clk_out3_qk7_pll133;
  wire        clk_out4_qk7_pll133;
  wire        clk_out5_qk7_pll133;
  wire        clk_out6_qk7_pll133;
  wire        clk_out7_qk7_pll133;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll133;
  wire        clkfbout_buf_qk7_pll133;
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
    .CLKOUT0_DIVIDE_F     (7.500),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll133),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll133),
    .CLKOUT0B            (c1_qk7_pll133),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll133),
    .CLKIN1              (inclk0_qk7_pll133),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll133), .I(clkfbout_qk7_pll133));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll133));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll133));
endmodule
`endif

`ifdef CONFIG_PLL_125
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// ______c0___125.000______0.000______50.0______162.035____164.985
// ______c1___125.000____180.000______50.0______162.035____164.985
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010


module qk7_pll125

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
wire inclk0_qk7_pll125;
wire clk_in2_qk7_pll125;
  IBUF clkin1_ibufg(.O (inclk0_qk7_pll125), .I(inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll125;
  wire        c1_qk7_pll125;
  wire        clk_out3_qk7_pll125;
  wire        clk_out4_qk7_pll125;
  wire        clk_out5_qk7_pll125;
  wire        clk_out6_qk7_pll125;
  wire        clk_out7_qk7_pll125;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll125;
  wire        clkfbout_buf_qk7_pll125;
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
    .CLKOUT0_DIVIDE_F     (8.000),
    .CLKOUT0_PHASE        (0.000),
    .CLKOUT0_DUTY_CYCLE   (0.500),
    .CLKOUT0_USE_FINE_PS  ("FALSE"),
    .CLKIN1_PERIOD        (20.000))
  mmcm_adv_inst
    // Output clocks
   (
    .CLKFBOUT            (clkfbout_qk7_pll125),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll125),
    .CLKOUT0B            (c1_qk7_pll125),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll125),
    .CLKIN1              (inclk0_qk7_pll125),
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

  BUFG clkf_buf(.O (clkfbout_buf_qk7_pll125), .I(clkfbout_qk7_pll125));
  BUFG clkout1_buf(.O   (c0), .I(c0_qk7_pll125));
  BUFG clkout2_buf(.O   (c1), .I(c1_qk7_pll125));
endmodule
`endif

`ifdef CONFIG_PLL_90
`timescale 1ps/1ps

module qk7_pll90

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
wire inclk0_qk7_pll90;
wire clk_in2_qk7_pll90;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll90),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll90;
  wire        c1_qk7_pll90;
  wire        clk_out3_qk7_pll90;
  wire        clk_out4_qk7_pll90;
  wire        clk_out5_qk7_pll90;
  wire        clk_out6_qk7_pll90;
  wire        clk_out7_qk7_pll90;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll90;
  wire        clkfbout_buf_qk7_pll90;
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
    .CLKFBOUT_MULT_F      (18.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll90),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll90),
    .CLKOUT0B            (c1_qk7_pll90),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll90),
    .CLKIN1              (inclk0_qk7_pll90),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll90),
    .I (clkfbout_qk7_pll90));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll90));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll90));

endmodule
`endif

`ifdef CONFIG_PLL_95
`timescale 1ps/1ps

module qk7_pll95

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
wire inclk0_qk7_pll95;
wire clk_in2_qk7_pll95;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll95),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll95;
  wire        c1_qk7_pll95;
  wire        clk_out3_qk7_pll95;
  wire        clk_out4_qk7_pll95;
  wire        clk_out5_qk7_pll95;
  wire        clk_out6_qk7_pll95;
  wire        clk_out7_qk7_pll95;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll95;
  wire        clkfbout_buf_qk7_pll95;
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
    .CLKFBOUT_MULT_F      (19.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll95),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll95),
    .CLKOUT0B            (c1_qk7_pll95),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll95),
    .CLKIN1              (inclk0_qk7_pll95),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll95),
    .I (clkfbout_qk7_pll95));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll95));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll95));

endmodule
`endif

`ifdef CONFIG_PLL_105
`timescale 1ps/1ps

module qk7_pll105

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
wire inclk0_qk7_pll105;
wire clk_in2_qk7_pll105;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll105),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll105;
  wire        c1_qk7_pll105;
  wire        clk_out3_qk7_pll105;
  wire        clk_out4_qk7_pll105;
  wire        clk_out5_qk7_pll105;
  wire        clk_out6_qk7_pll105;
  wire        clk_out7_qk7_pll105;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll105;
  wire        clkfbout_buf_qk7_pll105;
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
    .CLKFBOUT_MULT_F      (21.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll105),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll105),
    .CLKOUT0B            (c1_qk7_pll105),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll105),
    .CLKIN1              (inclk0_qk7_pll105),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll105),
    .I (clkfbout_qk7_pll105));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll105));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll105));

endmodule
`endif

`ifdef CONFIG_PLL_110
`timescale 1ps/1ps

module qk7_pll110

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
wire inclk0_qk7_pll110;
wire clk_in2_qk7_pll110;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll110),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll110;
  wire        c1_qk7_pll110;
  wire        clk_out3_qk7_pll110;
  wire        clk_out4_qk7_pll110;
  wire        clk_out5_qk7_pll110;
  wire        clk_out6_qk7_pll110;
  wire        clk_out7_qk7_pll110;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll110;
  wire        clkfbout_buf_qk7_pll110;
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
    .CLKFBOUT_MULT_F      (22.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll110),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll110),
    .CLKOUT0B            (c1_qk7_pll110),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll110),
    .CLKIN1              (inclk0_qk7_pll110),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll110),
    .I (clkfbout_qk7_pll110));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll110));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll110));

endmodule
`endif

`ifdef CONFIG_PLL_115
`timescale 1ps/1ps

module qk7_pll115

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
wire inclk0_qk7_pll115;
wire clk_in2_qk7_pll115;
  IBUF clkin1_ibufg
   (.O (inclk0_qk7_pll115),
    .I (inclk0));

  // Clocking PRIMITIVE
  //------------------------------------

  // Instantiation of the MMCM PRIMITIVE
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused

  wire        c0_qk7_pll115;
  wire        c1_qk7_pll115;
  wire        clk_out3_qk7_pll115;
  wire        clk_out4_qk7_pll115;
  wire        clk_out5_qk7_pll115;
  wire        clk_out6_qk7_pll115;
  wire        clk_out7_qk7_pll115;

  wire [15:0] do_unused;
  wire        drdy_unused;
  wire        psdone_unused;
  wire        locked_int;
  wire        clkfbout_qk7_pll115;
  wire        clkfbout_buf_qk7_pll115;
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
    .CLKFBOUT_MULT_F      (23.000),
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
    .CLKFBOUT            (clkfbout_qk7_pll115),
    .CLKFBOUTB           (clkfboutb_unused),
    .CLKOUT0             (c0_qk7_pll115),
    .CLKOUT0B            (c1_qk7_pll115),
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
    .CLKFBIN             (clkfbout_buf_qk7_pll115),
    .CLKIN1              (inclk0_qk7_pll115),
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

  BUFG clkf_buf
   (.O (clkfbout_buf_qk7_pll115),
    .I (clkfbout_qk7_pll115));

  BUFG clkout1_buf
   (.O   (c0),
    .I   (c0_qk7_pll115));

  BUFG clkout2_buf
   (.O   (c1),
    .I   (c1_qk7_pll115));

endmodule
`endif
