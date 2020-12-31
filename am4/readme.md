## Board photo

![Board photo](/am4/img/m4a.jpg)

## M4 Processor

M4 is the Soviet replica of the military version LSI-11M by United Technologies Norden Systems Inc.
Originally designed in the first half of 1970th for the avionics was used as the processor for
the aircraft reconnaissance radar module. The massive aluminum heatsink is built-in to PCB
providing operation in the stratosphere.

The M4 processor supports PDP-11 basic instruction set, extended instruction set (EIS), and floating
instruction set (EIS), no MMU is implemented, 32KB of RAM is integrated onboard, refresh is performed
by microcode on periodic requests. The microcode provides the standard built-in DEC ODT.

The processor is built on top of the AMD Am2900 bit-slice series with 56x1K horizontal microcode,
it is running at approximately 4MHz microcode clock frequency and consumes 30W of power. In average
it takes 5 clocks per register-register PDP-11 instructions.

There are some useful references to further readings:
- [Bit-Slice Design: Controllers and ALUs](https://www10.edacafe.com/book/parse_book.php?article=BITSLICE/bitslcP.html)
  by Donnamaie E. White
- [Bit-Slice Microprocessor Design](http://bitsavers.informatik.uni-stuttgart.de/components/amd/Am2900/Mick_Bit-Slice_Microprocessor_Design_1980.pdf)
  by J. Mick and J. Brick
- [AMD meta-assembler manual](http://www.donnamaie.com/2015/Amdasm-80%20Manual-2015%20reduced.pdf)
- [M4 board description (in Russian)](https://www.1801bm1.com/files/retro/M4/doc/mc1280.djvu)

## Processor Architecture
![Processor architecture](/am4/img/arch.jpg)

## Directory structure

#### \hdl
- the directory contains HDL-related materials, sources, and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous, and Wishbone compatible

#### \hdl\org
- asynchronous Verilog HDL model is as close as possible to the original gate-level schematics.
In practice can be used for modeling purposes only, because the processor contains latches (note,
it differs from flip-flop), those work in a non-reliable fashion on synchronous FPGAs. Also model
does not contain gate and line delays (converted to the digital synchronous ones), in some
simulating environments it can be very critical. Nonetheless, this model is included in the package
as a demo of the closest possible approximation to the original board schematics. Maybe not
synthesizable with some tools, simulation only.

#### \hdl\syn
- synchronous Verilog HDL model, microinstruction sequencer and ALUs are refactored to unified units,
the frontend bus is Q-Bus refactored to be synchronous, uses only direct clock to operate,
does not contain latches, and can be synthesized for synchronous FPGAs. All internal and external
timings are precisely the same as in an asynchronous original model with precision to period
of high-frequency clock.

#### \hdl\wbc
- synchronous Wishbone compatible version of M4 processor, is FPGA-optimized, follows the original
command execution timings, is intended for SoC building.

#### [\cad\am4](https://github.com/1801BM1/cad11/tree/master/am4) (moved to dedicated repo)
- partially restored board topology and complete schematics in PCAD-2000 format
- schematics in [pdf](https://github.com/1801BM1/cad11/tree/master/am4/m4_r3.pdf)

#### \rom
- read out microcode ROM images
- the microcode fields definition file
- the tool Am2900 M4 meta disassembler written in Phyton
- the universal Am2900 meta assembler written in Phyton, syntax follows AmdAsm80
- the microcode word cheetsheet

#### \tst
- software sources to test PDP-11 instructions and architecture (interrupts, exceptions, etc.)

## How to simulate
- run "tst\build.bat pitest" to prebuild desired test software image (pitest is a sample)
- run ModelSim simulator
- set "am4/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
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

## M4 project status
Ready to integrate into SoC design. The M4 processor models pass all the factory tests VKAxxx
intended to test original LSI-11, except the PSW[6:5] keeping on FIS instructions. M4 preserves
these bits, LSI-11 usually returns zeroes on mftp instruction.

The M4 board schematics is updated and Revision 3 seems to be final one.

## Fmax and FPGA resources
- Wishbone compatible M4 prociessor core
- speed optimization chosen
- slow model, worst corner

All results are just approximate estimations by synthesis tools (Quartus/XST/Tang Dynasty)
on sample projects (target frequency in .sdc was set to 50MHz, relaxed time-driven P&R)

| Board   | FPGA            | Family       | Fmax    | LUTs | FFs  | MEM     |
|---------|-----------------|--------------|---------|------|------|---------|
| DE0     | EP3C16F484C6N   | Cyclone III  | 66 MHz  | 1270 | 491  | 7 M9K   |
| DE1     | EP2C20F484C7N   | Cyclone II   | 52 MHz  | 1491 | 477  | 14 M4K  |
| DE2-115 | EP4CE115F29C7N  | Cyclone IV   | 60 MHz  | 1598 | 492  | 7 M9K   |
| AX309   | XC6SLX9FTG256-2 | Spartan 6    | 64 MHz  | 927  | 464  | 7 BR8   |
| DE10-LT | 10M50DAF484C7G  | Max 10       | 58 MHz  | 1195 | 470  | 7 M9K   |
| QC5     | 5CEFA2F23I7N    | Cyclone V    | 73 MHz  | 554  | 553  | 6 M10K  |
| QC10    | 10CL006U256CN8  | Cyclone 10   | 55 MHz  | 1193 | 471  | 7 M9K   |
| EG4     | EG4S20BG256     | Eagle EG4S20 | 59 MHz  | 1021 | 392  | 7 M9K   |
| QA7     | XC7A35TFTG256-1 | Artix 7      | 90 MHz  | 631  | 413  | 2 BR    |
