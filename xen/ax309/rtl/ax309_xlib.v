`include "../../lib/config.v"

module ax309_mem
(
   input [12:0]   addra,
   input          clka,
   input [15:0]   dina,
   input          wea,
   input [1:0]    byteena,
   output [15:0]  douta
);

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

//----------------------------------------------------------------------------
// "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
// "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
//----------------------------------------------------------------------------
// CLK_OUT1____66.667______0.000______50.0______500.000____150.000
// CLK_OUT2____66.667____180.000______50.0______500.000____150.000
//
//----------------------------------------------------------------------------
// "Input Clock   Freq (MHz)    Input Jitter (UI)"
//----------------------------------------------------------------------------
// __primary__________50.000____________0.010

`timescale 1ps/1ps

(* CORE_GENERATION_INFO = "ax3_pll66,clk_wiz_v3_6,{component_name=ax3_pll66,use_phase_alignment=true,use_min_o_jitter=false,use_max_i_jitter=false,use_dyn_phase_shift=false,use_inclk_switchover=false,use_dyn_reconfig=false,feedback_source=FDBK_AUTO,primtype_sel=DCM_SP,num_out_clk=2,clkin1_period=20.0,clkin2_period=20.0,use_power_down=false,use_reset=false,use_locked=true,use_inclk_stopped=false,use_status=false,use_freeze=false,use_clk_valid=false,feedback_type=SINGLE,clock_mgr_type=AUTO,manual_override=false}" *)
module ax3_pll66
 (// Clock in ports
  input         inclk0,
  // Clock out ports
  output        c0,
  output        c1,
  // Status and control signals
  output        locked
 );

  // Input buffering
  //------------------------------------
  IBUFG clkin1_buf(.O (clkin1),.I (inclk0));

  // Clocking primitive
  //------------------------------------

  // Instantiation of the DCM primitive
  //    * Unused inputs are tied off
  //    * Unused outputs are labeled unused
  wire        psdone_unused;
  wire        locked_int;
  wire [7:0]  status_int;
  wire clkfb;
  wire clk0;
  wire clkfx;
  wire clkfx180;

  DCM_SP
  #(.CLKDV_DIVIDE          (2.000),
    .CLKFX_DIVIDE          (3),
    .CLKFX_MULTIPLY        (4),
    .CLKIN_DIVIDE_BY_2     ("FALSE"),
    .CLKIN_PERIOD          (20.0),
    .CLKOUT_PHASE_SHIFT    ("NONE"),
    .CLK_FEEDBACK          ("1X"),
    .DESKEW_ADJUST         ("SYSTEM_SYNCHRONOUS"),
    .PHASE_SHIFT           (0),
    .STARTUP_WAIT          ("FALSE"))
  dcm_sp_inst
    // Input clock
   (.CLKIN                 (clkin1),
    .CLKFB                 (clkfb),
    // Output clocks
    .CLK0                  (clk0),
    .CLK90                 (),
    .CLK180                (),
    .CLK270                (),
    .CLK2X                 (),
    .CLK2X180              (),
    .CLKFX                 (clkfx),
    .CLKFX180              (clkfx180),
    .CLKDV                 (),
    // Ports for dynamic phase shift
    .PSCLK                 (1'b0),
    .PSEN                  (1'b0),
    .PSINCDEC              (1'b0),
    .PSDONE                (),
    // Other control and status signals
    .LOCKED                (locked_int),
    .STATUS                (status_int),
    .RST                   (1'b0),
    // Unused pin- tie low
    .DSSEN                 (1'b0));

    assign locked = locked_int;

  // Output buffering
  //-----------------------------------
  BUFG clkf_buf(.O(clkfb), .I(clk0));
  BUFG clkout1_buf(.O(c0), .I(clkfx));
  BUFG clkout2_buf(.O(c1), .I   (clkfx180));
endmodule
