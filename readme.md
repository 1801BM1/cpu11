## Abstract1

This CPU11 repository contains the results of historical PDP-11 microprocessors reverse engineering.
Typically the results include:
- high-resolution photoes of decapsulated crystals, both for upper metal and difusion layers
- restored crystal topology in Sprint Layout 6.0 format, can be easily exported to Gerbers
- restored topology in PCAD format
- restored gate-level schematics in PCAD and pdf formats
- original asyncrhonous Verilog-HDL model of processor
- synchronous Verilog-HDL model of processor refactored to run on FPGA

There are few words regarding the reverse engineering process stages:
- sample decapsulating, milling die from the ptastic package with CNC, then etching with 104 percents boiling oleum
- serialized photograping of die with motorized metallurgical microscope, hundreds of shots
- shot stitching, getting the resulting high resolution panoramic shot
- removing the top metal layer with polishing
- getting the high resolution panoramic shot of diffusion layer
- manual images vectorization
- gate recognition
- vectorized images transfer to CAD system
- schematic restoration using CAD back annotation
- manual schematic refactoring into human-readable one
- writing the original asyncronous Verilog HDL model, with all schematics specifics
- original Verilog HDL model simulation an debug, running factory test software
- Verilog HDL model refactoring to get synchronous model, running on real FPGA
- tranforming original processor bus to standard Wihbone
