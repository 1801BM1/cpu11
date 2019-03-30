## Die photo

![Die photo](/vm2/img/vm2a.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, browser might hang):
- [1801BM2 Top metal, 19Kx20K, 546M](http://www.1801bm1.com/files/retro/1801/images/vm2a-met.jpg)
- [1801BM2 Diffusion, 18Kx19K, 487M](http://www.1801bm1.com/files/retro/1801/images/vm2a-dif.jpg)

## 1801BM2

The 1801BM2 is single chip microprocessor, was designed in first half of 1980-th and
had PDP-11 compatible architecture. Notable, it was not an exact clone of one of original
DEC processors, but had its own internal architecture and PLM-based state machine. 

The 1801BM2 is the futher development of 1801BM1, MUL and DIV instructions added, the
two-stage pipeline and instruction prefetch were implemented, the microinstructions
took only one internal clock to complete (1801BM1 required two clock periods per
microinstruction). These features improved the processor performance significantly.

## Original vendor schematics and description
There are the links to original manufacturer's 1801BM2 gate-level schematics and description (djvu, in Russian).
- [1801BM2 Schematics](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_schematics.djvu)
- [1801BM2 Techdocs Volume I](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_description_vol1.djvu)
- [1801BM2 Techdocs Volume II](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_description_vol2.djvu)

## Directory structure
#### \hdl
- the directory contains HDL-related materials, sources and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous and Wishbone compatible

#### \hdl\org
- asynchronous Verilog HDL model, is as close as possible to the original gate-level schematics.
In practice can be used for modeling purposes only, because processor contains latches (note,
it differs from flip-flops), ones work in non-reliable fashion on synchronous FPGAs. Also model
does not contain line delays, in some simulating environment it can be very critical. Nonetheless,
this model is included in package as demo of closest possible approximation to the original die.
May not be synthesizable with some tools, presented for simulation purposes only.

#### \hdl\syn
- synchronous Verilog HDL model, the frontend bus is Q-Bus, removed extra phase clocks, uses only
direct clock and 180 degree shift to operate, does not contain latches and can be synthesized for
synchronous FPGAs. All internal and external timings are exactly the same as in asynchronous
original model with precision to half period of high frequency clock. This model can be used
to build in-board replacement of real 1801BM2 chip. Shared access windows feature is cut.

#### \hdl\wbc
- synchronous Wishbone compatible version of 1801BM2 synchronous core, uses single clock,
FPGA-optimized, follows the original command execution timings, is intended for SoC building.
Not implemented yet, is coming.

#### \cad\vm2    
- topology in Sprint Layout format
- topology in PCD-2004 pcb format
- schematics in PCD-2004 pcb format
- schematics in pdf (gate level)

#### \tst
- test software, including restored factory test sources and ROM images. Build batch should
be run befor building FPGA bitstream to include test software image

## How to simulate
- run "tst\build.bat t401" to prebuild desired test software image (t401 is a sample)
- run ModelSim simulator
- set "vm2/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
- execute "do run.do" console command
- wait, simulation make take some time till complete
- see the results in waveform and console output

