## Die photo

### Data Chip 1811BM1 (cloned DC302)
![Die photo](/f11/img/1811vm1.jpg)

### Control Chip 1811ВУ1 (cloned DC303)
![Die photo](/f11/img/1811vu1.jpg)

### MMU Chip 1811BT1 (cloned DC304)
![Die photo](/f11/img/1811vt1.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, browser might hang):
- [1811BM1 Top metal, 15Kx15K, 103M](http://www.1801bm1.com/files/retro/1811/images/1811vm1.jpg)
- [1811BM1 Diffusion, 15Kx15K, 77M](http://www.1801bm1.com/files/retro/1811/images/1811vm1-diff.jpg)
- [1811BT1 Top metal, 13Kx12K, 123M](http://www.1801bm1.com/files/retro/1811/images/1811vt1.jpg)
- [1811BT1 Diffusion, 13Kx12K, 91M](http://www.1801bm1.com/files/retro/1811/images/1811vt1-diff.jpg)
- [1811ВУ1 Top metal, 15Kx15K, 100M](http://www.1801bm1.com/files/retro/1811/images/1811vu1.jpg)
- [1811ВУ1 Diffusion, 15Kx15K, 73M](http://www.1801bm1.com/files/retro/1811/images/1811vu1-diff.jpg)
- [1811ВУ2 Top metal, 15Kx15K, 91M](http://www.1801bm1.com/files/retro/1811/images/1811vu2.jpg)
- [1811ВУ2 Diffusion, 15Kx15K, 130M](http://www.1801bm1.com/files/retro/1811/images/1811vu2-diff.jpg)
- [1811ВУ3 Top metal, 15Kx15K, 78M](http://www.1801bm1.com/files/retro/1811/images/1811vu3.jpg)
- [1811ВУ3 Diffusion, 15Kx15K, 92M](http://www.1801bm1.com/files/retro/1811/images/1811vu3-diff.jpg)

## The original DEC F-11

"The F-11 (code name: the Fonz) was DEC's second microprocessor design,
and the first to be architected by DEC personnel in 1979. Duane Dickhut
was the project leader, Bill Johnson was lead design engineer for
the Data chip, and Burt Hashizume wrote most of the microcode.
The MMU was designedby Dan Dobberpuhl's consulting company.

The F-11 was substantially more ambitious than the LSI-11. It implemented
the entire PDP-11/34 architecture, including FP11-compatible floating point
and KT11-compatibile memory management. It targeted 3X the performance
of the LSI-11, at almost the same clock rate. It provided physical address
extension out to 22b, the first system to do so after the PDP-11/70.
It implemented the PDP-11 Commercial Instruction Set as an option,
the only other implementation was for the PDP-11/44.

Like the LSI-11, the F-11 was a chip set consisting of three designs,
one of which could be replicated: the Control Chip (up to nine supported),
the Data chip, and the MMU chip. It was implemented in AMI's 6u NMOS
process and operated at 3.6Mhz (280ns microcycle). The DEC PDP-11/23
computer is based on the F-11 "Fonz" chipset" -
[Bob Supnik](http://simh.trailing-edge.com/semi/f11.html).

The 1811 series is the Soviet clone of F-11 chipset, produced by VFSD
("Voronezh Factory of Semiconductor Devices" - "Воронежский Завод
Полупроводниковых Приборов") behind the Iron Curtain in the second
half of 1980th.

- 1811BM1 / DC302 - 7922 gates
- 1811ВУх / ВС303 - ~12600 gates (depends on PLA/ROM content)
- 1811BT1 / DC304 - 10383 gates

## Asynchronous model
Only asynchronous model is presented for the moment, it includes both
MMU and FPP options. This model contains latches and intended
for simulation only. The factory tests passed by the model in simulation:

- [jkdad0](/f11/tst/org/jkdad0.mac) - MMU diagnostics
- [jkdbd0](/f11/tst/org/jkdbd0.mac) - instruction set (BIS/EIS)
- [jkdcb0](/f11/tst/org/jkdcb0.mac) - FPP diagnostics, part 1
- [jkddb0](/f11/tst/org/jkddb0.mac) - FPP diagnostics, part 2

## Directory structure
#### \hdl
- the directory contains HDL-related materials, sources, and sample projects for Quartus and ISE.
There are three models: original asynchronous, refactored synchronous and Wishbone compatible

#### \hdl\org
- asynchronous Verilog HDL model is as close as possible to the original gate-level schematics.
In practice can be used for modeling purposes only, because processor contains latches (note,
it differs from flip-flop), those work in non-reliable fashion on synchronous FPGAs. Nonetheless,
this model is included in the package as a demo of the closest possible approximation 
to the original die. Maybe not synthesizable with some tools, simulation only.

#### \hdl\syn
- synchronous Verilog HDL model, not implemented yet

#### \hdl\wbc
- synchronous Wishbone compatible version of F11, not implemented yet

#### [\cad\f11](https://github.com/1801BM1/cad11/tree/master/f11) (moved to dedicated repo)
- topology in Sprint Layout format
- topology in PCD-2004 pcb format
- schematics in PCD-2004 sch format
- schematics in pdf (gate level)

#### \rom
- MicROM binary images (checked against read from real chips)
- tools (Microcode Disassemler, written in Python)

#### \tst
- test software, including restored factory test sources and ROM images. Build batch should
be run before building FPGA bitstream to include test software image

## How to simulate
- run "tst\build.bat test" to prebuild desired test software image ("test" is a sample)
- run ModelSim simulator
- set "f11/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
- execute "do run.do" console command
- wait, simulation may take some time till complete
- see the results in waveform and console output

## Implemented resources
- RAM 16Kx16bit at 000000<sub>8</sub> with initialized content from test.mif file
- TTY at 177560<sub>8</sub>, 60<sub>8</sub>/64<sub>8</sub> vector interrupts,
  tx/rx with cts/rts handshake, 115200/8/N/1, RS-232 levels (board dependent).
- 50Hz system timer interrupt (IRQ2, edge sensitive, vector 100<sub>8</sub>),
  enabled by board switch[0], if timer is enabled the board led[0] lights
- 4x7-segment display, segments attached to output registers at 177714<sub>8</sub>/177715<sub>8</sub>,
  see the test software source for the details
- switches and buttons can be read from input register at 177714<sub>8</sub>
- board button[0] is reset, short press less than 1 sec causes system reset,
  long press over 1 second simulates power reset (excluding RAM content)
