## Die photo

![Die photo](/vm1/img/vm1a.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, a browser might hang):
- [1801BM1А Top metal, 19Kx19K, 524M](http://www.1801bm1.com/files/retro/1801/images/vm1a-met.jpg)
- [1801BM1А Diffusion, 12Kx12K, 202M](http://www.1801bm1.com/files/retro/1801/images/vm1a-dif.jpg)
- [1801BM1Г Top metal, 19Kx19K, 525M](http://www.1801bm1.com/files/retro/1801/images/vm1g-met.jpg)
- [1801BM1Г Diffusion, 18Kx18K, 472M](http://www.1801bm1.com/files/retro/1801/images/vm1g-dif.jpg)

## 1801BM1

The 1801BM1 is the single-chip processor designed in early 1980th with PDP-11
compatible architecture. Notable, it is not an exact clone of one of the DEC processors
but has its own original architecture and PLM-based state machine.

It supports PDP-11 basic instruction set and extra instructions SOB and XOR from Extended
Instruction Set (EIS). No MMU is implemented. There were designed and produced two versions
of 1801BM1 - K1801BM1A and K1801BM1Г (Cyrillic letter "Г"), they had the same architecture
but completely different PLM content, implementing different state machines. The goal of this
microprogram refactoring was to add MUL instruction support into K1801BM1Г.

The processor was produced in the 5-micron NMOS process with depletion-mode loads, one metal
and one polycrystalline silicon layer, and self-aligned gates. The 1801BM1A contains 16632 gates,
1801BM1Г - 16646 gates, operates at 5MHz/5V, and provides 625K register-register instructions per
second. The front-end bus is Qbus compatible, the multicore configuration is supported with
up to 4 processors one the same bus. Also there is the built-in timer, 1801BM1Г supported
timer interrupts.

There is no internal ODT implemented, the in-system test and debug are supported
with special HALT mode and external ROM.

## Directory structure
#### \doc
- the very detailed processor [description](/vm1/doc/1801vm1.pdf) (in Russian), including internal
structure and microcode execution, the built-in timer details unveiled, all actual bus diagrams
described. The document has been written on the base of reverse engineering

#### \hdl
- the directory contains HDL-related materials, sources, and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous and Wishbone compatible

#### \hdl\org
- asynchronous Verilog HDL model is as close as possible to the original gate-level schematics.
In practice can be used for modeling purposes only, because processor contains latches (note,
it differs from flip-flop), those work in non-reliable fashion on synchronous FPGAs. Also model
does not contain gate and line delays, in some simulating environment it can be very critical. 
Nonetheless, this model is included in the package as a demo of the closest possible approximation to the original die. Maybe not synthesizable with some tools, simulation only.

#### \hdl\syn
- synchronous Verilog HDL model, the frontend bus is Q-Bus, does not contain latches, and can be
synthesized for synchronous FPGAs. All internal and external timings are precisely the same as
in an asynchronous original model with precision to half period of high-frequency clock. This model
can be used to build the in-socket replacement of real 1801BM1 chip

#### \hdl\wbc
- synchronous Wishbone compatible version of 1801BM1 synchronous core uses a single clock,
is FPGA-optimized, and follows the original command execution timings, is intended for SoC building


#### [\cad\vm1](https://github.com/1801BM1/cad11/tree/master/vm1) (moved to dedicated repo)
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
- set "vm1/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
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
- Wishbone compatible 1801BM1A core
- register file and constant generator in RAM block
- balanced area/speed optimization chosen
- slow model, worst corner

All results are just approximate estimations by synthesis tools (Quartus/XST/Vivado) on sample
projects.

| Board   | FPGA            | Family       | Fmax    | LUTs | FFs | MEM    |
|---------|-----------------|--------------|---------|------|-----|--------|
| DE0     | EP3C16F484C7N   | Cyclone III  | 111 MHz | 1420 | 427 | 1 M9K  |
| DE1     | EP2C20F484C7N   | Cyclone II   | 94 MHz  | 1410 | 464 | 1 M4K  |
| DE2-115 | EP4CE115F29C7N  | Cyclone IV   | 111 MHz | 1370 | 425 | 1 M9K  |
| AX309   | XC6SLX9FTG256-2 | Spartan 6    | 72 MHz  | n/a  | 387 | 1 BR8  |
| DE10-LT | 10M50DAF484C7G  | Max 10       | 82 MHz  | 1373 | 469 | 1 M9K  |
| QC5     | 5CEFA2F23I7N    | Cyclone V    | 131 MHz | 693  | 384 | 1 M10K |
| QC10    | 10CL006U256CN8  | Cyclone 10   | 108 MHz | 1349 | 694 | 1 M9K  |
| EG4     | EG4S20BG256     | Eagle EG4S20 | 95 MHz  | 1810 | 621 | 1 M9K  |