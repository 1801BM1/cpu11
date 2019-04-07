//
// Copyright (C) 1991-2012 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License
// Subscription Agreement, Altera MegaCore Function License
// Agreement, or other applicable license agreement, including,
// without limitation, that your use is for the sole purpose of
// programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the
// applicable agreement for further details.
//
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module de0_pll100 (
   inclk0,
   c0,
   c1,
   locked);

   input   inclk0;
   output     c0;
   output     c1;
   output     locked;

   wire [4:0] sub_wire0;
   wire  sub_wire2;
   wire [0:0] sub_wire6 = 1'h0;
   wire [0:0] sub_wire3 = sub_wire0[0:0];
   wire [1:1] sub_wire1 = sub_wire0[1:1];
   wire  c1 = sub_wire1;
   wire  locked = sub_wire2;
   wire  c0 = sub_wire3;
   wire  sub_wire4 = inclk0;
   wire [1:0] sub_wire5 = {sub_wire6, sub_wire4};

   altpll   altpll_component (
            .inclk (sub_wire5),
            .clk (sub_wire0),
            .locked (sub_wire2),
            .activeclock (),
            .areset (1'b0),
            .clkbad (),
            .clkena ({6{1'b1}}),
            .clkloss (),
            .clkswitch (1'b0),
            .configupdate (1'b0),
            .enable0 (),
            .enable1 (),
            .extclk (),
            .extclkena ({4{1'b1}}),
            .fbin (1'b1),
            .fbmimicbidir (),
            .fbout (),
            .fref (),
            .icdrclk (),
            .pfdena (1'b1),
            .phasecounterselect ({4{1'b1}}),
            .phasedone (),
            .phasestep (1'b1),
            .phaseupdown (1'b1),
            .pllena (1'b1),
            .scanaclr (1'b0),
            .scanclk (1'b0),
            .scanclkena (1'b1),
            .scandata (1'b0),
            .scandataout (),
            .scandone (),
            .scanread (1'b0),
            .scanwrite (1'b0),
            .sclkout0 (),
            .sclkout1 (),
            .vcooverrange (),
            .vcounderrange ());
   defparam
      altpll_component.bandwidth_type = "AUTO",
      altpll_component.clk0_divide_by = 1,
      altpll_component.clk0_duty_cycle = 50,
      altpll_component.clk0_multiply_by = 2,
      altpll_component.clk0_phase_shift = "0",
      altpll_component.clk1_divide_by = 1,
      altpll_component.clk1_duty_cycle = 50,
      altpll_component.clk1_multiply_by = 2,
      altpll_component.clk1_phase_shift = "5000",
      altpll_component.compensate_clock = "CLK0",
      altpll_component.inclk0_input_frequency = 20000,
      altpll_component.intended_device_family = "Cyclone III",
      altpll_component.lpm_hint = "CBX_MODULE_PREFIX=de0_pll100",
      altpll_component.lpm_type = "altpll",
      altpll_component.operation_mode = "NORMAL",
      altpll_component.pll_type = "AUTO",
      altpll_component.port_activeclock = "PORT_UNUSED",
      altpll_component.port_areset = "PORT_UNUSED",
      altpll_component.port_clkbad0 = "PORT_UNUSED",
      altpll_component.port_clkbad1 = "PORT_UNUSED",
      altpll_component.port_clkloss = "PORT_UNUSED",
      altpll_component.port_clkswitch = "PORT_UNUSED",
      altpll_component.port_configupdate = "PORT_UNUSED",
      altpll_component.port_fbin = "PORT_UNUSED",
      altpll_component.port_inclk0 = "PORT_USED",
      altpll_component.port_inclk1 = "PORT_UNUSED",
      altpll_component.port_locked = "PORT_USED",
      altpll_component.port_pfdena = "PORT_UNUSED",
      altpll_component.port_phasecounterselect = "PORT_UNUSED",
      altpll_component.port_phasedone = "PORT_UNUSED",
      altpll_component.port_phasestep = "PORT_UNUSED",
      altpll_component.port_phaseupdown = "PORT_UNUSED",
      altpll_component.port_pllena = "PORT_UNUSED",
      altpll_component.port_scanaclr = "PORT_UNUSED",
      altpll_component.port_scanclk = "PORT_UNUSED",
      altpll_component.port_scanclkena = "PORT_UNUSED",
      altpll_component.port_scandata = "PORT_UNUSED",
      altpll_component.port_scandataout = "PORT_UNUSED",
      altpll_component.port_scandone = "PORT_UNUSED",
      altpll_component.port_scanread = "PORT_UNUSED",
      altpll_component.port_scanwrite = "PORT_UNUSED",
      altpll_component.port_clk0 = "PORT_USED",
      altpll_component.port_clk1 = "PORT_USED",
      altpll_component.port_clk2 = "PORT_UNUSED",
      altpll_component.port_clk3 = "PORT_UNUSED",
      altpll_component.port_clk4 = "PORT_UNUSED",
      altpll_component.port_clk5 = "PORT_UNUSED",
      altpll_component.port_clkena0 = "PORT_UNUSED",
      altpll_component.port_clkena1 = "PORT_UNUSED",
      altpll_component.port_clkena2 = "PORT_UNUSED",
      altpll_component.port_clkena3 = "PORT_UNUSED",
      altpll_component.port_clkena4 = "PORT_UNUSED",
      altpll_component.port_clkena5 = "PORT_UNUSED",
      altpll_component.port_extclk0 = "PORT_UNUSED",
      altpll_component.port_extclk1 = "PORT_UNUSED",
      altpll_component.port_extclk2 = "PORT_UNUSED",
      altpll_component.port_extclk3 = "PORT_UNUSED",
      altpll_component.self_reset_on_loss_lock = "OFF",
      altpll_component.width_clock = 5;
endmodule
