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

#### [\cad\am4](https://github.com/1801BM1/cad11/tree/master/am4) (moved to dedicated repo)
- partially restored topology and complete schematics in PCAD-2000 format
- schematics in [pdf](https://github.com/1801BM1/cad11/tree/master/am4/m4_r3.pdf)

#### \rom
- read out microcode ROM images
- the microcode fields definition file
- the tool Am2900 M4 meta disassembler written in Phyton
- the universal Am2900 meta assembler written in Phyton, syntax follows AmdAsm80
- the microcode word cheetsheet

#### \tst
- software sources to test PDP-11 instructions and architecture (interrupts, exceptions, etc.)

## M4 project status

The asynchronous M4 processor model passes all the factory tests VKAxxx intended to test
original LSI-11, except the PSW[6:5] keeping on FIS instructions. M4 preserves these bits,
LSI-11 usually returns zeroes on mftp instruction.

The M4 board schematics is updated and Revision 3 seems to be final one.