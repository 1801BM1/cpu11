## Module front panel photo

![Board photo](/s20/img/fpanel.jpg)

## CM-2420 processor

CM-2420 ("es-em-twenty-four-twenty") is the processor module of the Soviet mini-computer
CM-1420, this one seems to be the Soviet replica of the DEC PDP-11/44 model built around
the basic logic chips and AMD Am2901 bit-slices. It was in mass production behind
the iron curtain in the 1980ths, more than 80.000 of the CM1420 mini-computer modifications
was produced and delivered by the holding "NPO Electronmash" located in Kyiv.

CM-2420.01 is the most advanced version of the processor:
 - 10 MHz main clock
 - PDP-11 basic instruction set
 - extended instruction set (EIS)
 - FP-11 floating point co-processor
 - MMU with 18/22-bit modes supported
 - UNIBUS interconnection to the peripherals
 - addressing up to 2048K 16-bit words
 - up to 2048K DRAM memory embedded into the module
 - optional 4K 16-bit words shared instruction/data cache

## Processor architecture

![Processor architecture](/s20/img/arch.png)

## Original vendor schematics and description
There are the links to the original manufacturer's CM-2420 gate-level schematics and description
(DjVu format, in Russian).
- [CM-2420.01 technical description](https://1801bm1.com/files/retro/2420/3.055.006-01TO.djvu)
- [CM-2420.01 schematics](https://1801bm1.com/files/retro/2420/3.055.006-O1OP.djvu)
- [CM-2420.xx ROM content](https://1801bm1.com/files/retro/2420/rom/)

## Directory structure
#### \hdl
- the directory contains HDL-related materials, sources, and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous, and Wishbone-compatible

#### \hdl\org
- at asynchronous Verilog HDL model is as close as possible to the original gate-level schematics.
In practice, it can be used for modeling purposes only, because the processor contains latches (note,
it differs from flip-flop), which work in a non-reliable fashion on synchronous FPGAs. Also, the model
does not contain gate and line delays (converted to digital synchronous ones), in some
simulating environments, it can be very critical. Nonetheless, this model is included in the package
as a demo of the closest approximation to the original board schematics. May be not
synthesizable with some tools, simulation only.

#### \rom\boot
- the directory contains the bootloader source code. The bootloader resides at base address
17773000, is split into 4 pages of 512 bytes each, page is selected by jumper settings.

## CM-2420 project status
Initial commit, objectives claim, work in progress
