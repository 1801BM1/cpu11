## Abstract

This CPU11 repository contains the results of historical PDP-11 microprocessors reverse engineering.

Typically the results include:
- high-resolution photos of decapsulated crystals, both for top metal and diffusion layers
- restored crystal topology in Sprint Layout 6.0 format, can be easily exported to Gerber
- restored topology in PCAD format
- restored gate-level schematics in PCAD and pdf formats
- original asynchronous Verilog-HDL model of processor
- refactoring original Verilog-HDL model to synchronous one to run on real FPGA

There are few words regarding the reverse engineering process stages:
- sample decapsulating, milling die from the plastic package with CNC, then etching with 104 percents boiling oleum
- serialized photographing of die with motorized metallurgical microscope, hundreds of shots
- shot stitching, getting the resulting high resolution panoramic shot
- removing the top metal layer with polishing
- getting the high resolution panoramic shot of diffusion layer
- manual images vectorization - traces, vias, pads, etc.
- gate recognition
- transferring vectorized images to PCB CAD system
- schematic restoration using PCB CAD back annotation
- manual schematic refactoring into human-readable form
- writing the original asynchronous Verilog HDL model, with all schematics specifics
- simulating and debug the original Verilog HDL model, running PDP-11 factory test software on the model
- Verilog HDL model refactoring to get synchronous model, running on real FPGA
- transforming original processor bus to standard Wishbone master interface to integrate into SoC

## Processors

- [1801BM1](/vm1) - USSR microprocessor, no DEC prototype, proprietary die design

## Supported FPGA development boards
The synchronous models are planned to be run (and appropriate sample projects to be included in repo) on the following Development Kits:
- [Altera DE0](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364)
- [Altera DE1](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=83)
- [Altera DE2-115](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=502)
- [Alinx AX309](http://artofcircuits.com/product/alinx-ax309-spartan-6-fpga-development-board-xc6slx9-2ftg256c)
