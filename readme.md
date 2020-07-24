## Abstract

This CPU11 repository contains the results of historical PDP-11 microprocessors reverse engineering.

Typically the results include:
- high-resolution photos of decapsulated crystals, both for top metal and diffusion layers
- restored crystal topology in Sprint Layout 6.0 format, can be easily exported to Gerber
- restored topology in PCAD format
- restored gate-level schematics in PCAD and pdf formats
- original asynchronous Verilog-HDL model of processor
- refactoring original Verilog-HDL model to synchronous one to run on real FPGA

There are a few words regarding the reverse engineering process stages:
- sample decapsulating, milling die from the plastic package with CNC, then etching with 104 percents boiling oleum
- serialized photographing of die with a motorized metallurgical microscope, hundreds of shots
- shot stitching, getting the resulting high-resolution panoramic shot
- removing the top metal layer with a polishing
- getting the high-resolution panoramic shot of the diffusion layer
- manual images vectorization - traces, vias, pads, etc.
- gate recognition
- transferring vectorized images to PCB CAD system
- schematic restoration using PCB CAD back annotation
- manual schematic refactoring into human-readable form
- writing the original asynchronous Verilog HDL model, with all schematics specifics
- simulating and debug the original Verilog HDL model, running PDP-11 factory test software on the model
- Verilog HDL model refactoring to get synchronous model, running on real FPGA
- transforming processor-specific bus to standard Wishbone master interface to integrate into SoC

## Processors

- [1801BM1](/vm1) - USSR microprocessor, no DEC prototype, proprietary die design
- [1801BM2](/vm2) - USSR microprocessor, no DEC prototype, proprietary die design
- [1801BM3](/vm3) - USSR microprocessor, no DEC prototype, proprietary die design
- [LSI-11](/lsi) - Soviet 581-series, DEC LSI-11 clone, Western Digital MCP-1600 chipset

## PI-test perfromance

The 1000 signs of Pi calculation test is based on spigot algorithm. The digits are the times in 50Hz ticks.
All models were Wishbone-compatible and run on the DE0 board with the same system configurations, software was
placed into static memory with zero wait states. LSI-11 was running at 80MHz and results are multiplied by 0.8
to match with other ones. There are three variants of the test with various combinations of supported
EIS instructions.

| Model    | Frequency     | no EIS | MUL only | MUL/DIV |
|----------|---------------|--------|----------|---------|
| LSI-11   | 100MHz(80MHz) | 746    | 422      | 284     |
| 1801BM1A | 100MHz        | 586    | ---      | ---     |
| 1801BM1Г | 100MHz        | 588    | 458      | ---     |
| 1801BM2  | 100MHz        | 340    | 190      | 123     |

## Supported FPGA development boards
The synchronous models are planned to be run (and appropriate sample projects to be included in repo) on the following Development Kits:
<<<<<<< HEAD
- [Altera DE0](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364) - Altera Cyclone-III
- [Altera DE1](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=83) - Altera Cyclone-II
- [Altera DE2-115](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=502) - Altera Cyclone-IV
- [Altera DE10-lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=218&No=1021) - Altera Max-10
- [Alinx AX309](http://artofcircuits.com/product/alinx-ax309-spartan-6-fpga-development-board-xc6slx9-2ftg256c) - Xilinx Spartan-6
- [QMTech QC5-core](https://github.com/ChinaQMTECH/QM_CYCLONE_V) - Altera Cyclone-V
- [QMTech QC10-core](https://github.com/ChinaQMTECH/QM_Cyclone10_10CL006) - Altera Cyclone-10LP
- [Lichee Tang Primer](https://tang.sipeed.com/en/) - Anlogic Eagle EG4S20
