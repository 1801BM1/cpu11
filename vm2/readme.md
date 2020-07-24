## Die photo

![Die photo](/vm2/img/vm2a.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, a browser might hang):
- [1801BM2 Top metal, 19Kx20K, 546M](http://www.1801bm1.com/files/retro/1801/images/vm2a-met.jpg)
- [1801BM2 Diffusion, 18Kx19K, 487M](http://www.1801bm1.com/files/retro/1801/images/vm2a-dif.jpg)

## 1801BM2

The 1801BM2 is a single-chip microprocessor, was designed in the first half of 1980th, and
had PDP-11 compatible architecture. Notable, it was not an exact clone of one of 
DEC processors, but had its own original architecture and PLM-based state machine. 

The 1801BM2 is the further development of 1801BM1, MUL and DIV instructions added, the
two-stage pipeline and instruction prefetch was implemented, the microinstructions
took only one internal clock to complete (1801BM1 required two clock periods per
microinstruction). These features improved the processor performance significantly.

## Original vendor schematics and description
There are the links to the original manufacturer's 1801BM2 gate-level schematics and description (DjVu, in Russian).
- [1801BM2 Schematics](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_schematics.djvu)
- [1801BM2 Techdocs Volume I](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_description_vol1.djvu)
- [1801BM2 Techdocs Volume II](http://www.1801bm1.com/files/retro/1801/vm2/Doc/1801BM2_description_vol2.djvu)

## Directory structure
#### \hdl
- the directory contains HDL-related materials, sources, and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous and Wishbone compatible

#### \hdl\org
- asynchronous Verilog HDL model is as close as possible to the original gate-level schematics.
In practice can be used for modeling purposes only, because processor contains latches (note,
it differs from flip-flops), ones work in non-reliable fashion on synchronous FPGAs. Also model
does not contain line delays, in some simulating environment it can be very critical. Nonetheless,
this model is included in the package as a demo of the closest possible approximation to the original die.
May not be synthesizable with some tools, presented for simulation purposes only.

#### \hdl\syn
- synchronous Verilog HDL model, the frontend bus is Q-Bus, removed extra phase clocks, uses only
direct clock and 180-degree shift one to operate, does not contain latches, and can be synthesized
for synchronous FPGAs. All internal and external timings are precisely the same as in an asynchronous
original model with precision to half period of high-frequency clock. This model can be used
to build the in-board replacement of the real 1801BM2 chip. Shared access windows feature is cut.

#### \hdl\wbc
- synchronous Wishbone compatible version of 1801BM2 synchronous core uses a single clock,
is FPGA-optimized, follows the original command execution timings, is intended for SoC building.

#### [\cad\vm2](https://github.com/1801BM1/cad11/tree/master/vm2) (moved to dedicated repo)
- topology in Sprint Layout format
- topology in PCD-2004 pcb format
- schematics in PCD-2004 pcb format
- schematics in pdf (gate level)

#### \tst
- test software, including restored factory test sources and ROM images. Build batch should
be run before building FPGA bitstream to include test software image

## How to simulate
- run "tst\build.bat t401" to prebuild desired test software image (t401 is a sample)
- run ModelSim simulator
- set "vm2/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
- execute "do run.do" console command
- wait, simulation may take some time till complete
- see the results in waveform and console output

## Implemented resources
- RAM 8Kx16bit at 000000<sub>8</sub> with initialized content from test.mif file
- TTY at 177560<sub>8</sub>, 60<sub>8</sub>/64<sub>8</sub> vector interrupts, 
  tx/rx with cts/rts handshake, 115200/8/N/1, RS-232 levels (board dependent).
- 50Hz system timer interrupt (IRQ2, edge sensitive, vector 100<sub>8</sub>),
  enabled by board switch[0], if timer is enabled the board led[0] lights
- 4x7-segment display, segments attached to output registers at 177714<sub>8</sub>/177715<sub>8</sub>,
  see the test software source for the details
- switches and buttons can be read from input register at 177714<sub>8</sub>
- board button[0] is reset, short press less than 1 sec causes system reset, 
  long press over 1 second simulates power reset (excluding RAM content)

## Fmax and FPGA resources
- Wishbone compatible 1801BM2 core
- register file and constant generator in flip-flops, no RAM block
- speed optimization chosen
- slow model, worst corner

All results are just approximate estimations by synthesis tools (Quartus/XST) on sample
projects.

| Board   | FPGA            | Family      | Fmax    | LUTs | FFs  | MEM    |
|---------|-----------------|-------------|---------|------|------|--------|
| DE0     | EP3C16F484C6N   | Cyclone III | 111 MHz | 1925 | 590  | 0 M9K  |
| DE1     | EP2C20F484C7N   | Cyclone II  | 87 MHz  | 2134 | 684  | 0 M4K  |
| DE2-115 | EP4CE115F29C7N  | Cyclone IV  | 91 MHz  | 1874 | 709  | 0 M9K  |
| AX309   | XC6SLX9FTG256-2 | Spartan 6   | 69 MHz  | 1700 | 797  | 0 BR8  |
| DE10-LT | 10M50DAF484C7G  | Max 10      | 76 MHz  | 1942 | 664  | 0 M9K  |
| QC5     | 5CEFA2F23I7N    | Cyclone V   | 123 MHz | 1033 | 743  | 0 M10K |
| QC10    | 10CL006U256CN8  | Cyclone 10  | 102 MHz | 1917 | 652  | 1 M9K  |
