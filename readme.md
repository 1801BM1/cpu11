## Abstract

This CPU11 repository contains the results of historical PDP-11 microprocessors reverse engineering.

Typically the results include:
- high-resolution photos of decapsulated crystals, both for top metal and diffusion layers
- restored crystal topology in Sprint Layout 6.0 format, can be easily exported to Gerber
- restored topology in PCAD format
- restored gate-level schematics in PCAD and pdf formats
- original asynchronous Verilog-HDL model of processor
- refactored original Verilog-HDL model to synchronous one to run on real FPGA

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
- writing the original asynchronous Verilog HDL model, with all original schematics specifics
- simulating and debug the original Verilog HDL model, running PDP-11 factory test software on the model
- Verilog HDL model refactoring to get synchronous model, running on real FPGA
- transforming processor-specific bus to standard Wishbone master interface to integrate into SoC

## Processors

- [1801BM1](/vm1) - USSR microprocessor, no DEC prototype, proprietary die design
- [1801BM2](/vm2) - USSR microprocessor, no DEC prototype, proprietary die design
- [1801BM3](/vm3) - USSR microprocessor, no DEC prototype, proprietary die design
- [LSI-11](/lsi) - Soviet 581-series, DEC LSI-11 clone, Western Digital MCP-1600 chipset
- [F-11](/f11) - Soviet 1811-series, DEC F-11 clone, DEC DC302/DC303/DC304 "Fonz" chipset
- [M4](/am4) - Soviet replica of military LSI-11M, AMD Am2900 bit-slices

## PI-test performance

The 1000 signs of Pi calculation test is based on spigot algorithm. The digits are the times in 50Hz ticks.
All models were Wishbone-compatible and run on the DE0 board with the same system configurations, software was
placed into static memory with zero wait states. LSI-11 was running at 80MHz and results are multiplied by 0.8
to match with other ones. M4 was running at 50MHz and results are multiplied by 0.5. There are three variants
of the test with various combinations of supported EIS instructions.

| Model    | Frequency     | no EIS | MUL only | MUL/DIV | cpm |
|----------|---------------|--------|----------|---------|-----|
| LSI-11   | 100MHz(80MHz) | 746    | 422      | 284     |  x1 |
| F-11     | 100MHz        | 693    | 429      | 323     |  x2 |
| 1801BM1A | 100MHz        | 586    | ---      | ---     |  x2 |
| 1801BM1Г | 100MHz        | 588    | 458      | ---     |  x2 |
| M4       | 100MHz(50MHz) | 532    | 275      | 154     |  x1 |
| 1801BM2  | 100MHz        | 340    | 190      | 123     |  x2 |

Notes: "cpm" means core clocks per microinstruction, how many clocks model takes to execute single microcode
instruction. For LSI-11 the four phases c1-c4 were refactored to the single core clock, for F-11 four phases
were refactored to two core clocks. In addition the 1801ВМ2 performs the instruction prefetch gaining some boost.

## Icarus Verilog

Icarus Verilog is an implementation of the Verilog hardware description language compiler that generates
netlists in the desired format (EDIF). It supports the 1995, 2001 and 2005 versions of the Verilog standard,
portions of SystemVerilog, and some extensions.

There are builds of Icarus Verilog for Windows available on [site](https://bleyer.org/icarus/).
We would recommend installing `iverilog` version 12. However version 10 should be sufficient as 
it comes as part of Ubuntu 20.04 LTS distribution.

There are `run_iverilog.sh` scripts added per each CPU model.

All scripts have similar structure:
 * run `iverilog` for specified top-level module and create `*.vvp` file
 * execute compiled representation by `vvp` command:

For example, LSI CPU has following script:

    iverilog -c iverilog.cf -o tb_lsi.vvp -s tbl
    vvp -n -v ./tb_lsi.vvp

The `iverilog.cf` file contains list of Verilog files to be added to desing (to be compiled and simulated).

## Supported FPGA development boards

The synchronous models are planned to be run (and appropriate sample projects to be included in repo) on the following Development Kits:
- [Altera DE0](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=364) - Altera Cyclone-III
- [Altera DE1](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=83) - Altera Cyclone-II
- [Altera DE2-115](http://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=139&No=502) - Altera Cyclone-IV
- [Altera DE10-lite](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=218&No=1021) - Altera Max-10
- [Alinx AX309](http://artofcircuits.com/product/alinx-ax309-spartan-6-fpga-development-board-xc6slx9-2ftg256c) - Xilinx Spartan-6
- [QMTech QC5-core](https://github.com/ChinaQMTECH/QM_CYCLONE_V) - Altera Cyclone-V
- [QMTech QC10-core](https://github.com/ChinaQMTECH/QM_Cyclone10_10CL006) - Altera Cyclone-10LP
- [QMTech QA7-core](https://github.com/ChinaQMTECH/QM_XC7A35T_DDR3) - Xilinx Artix-7
- [Lichee Tang Primer](https://tang.sipeed.com/en/) - Anlogic Eagle EG4S20

