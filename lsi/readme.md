## Die photo

### Data Chip 581ИК1 (cloned MCP-1611)
![Die photo](/lsi/img/581ik1.jpg)

### Control Chip 581ИК2 (cloned MCP-1621)
![Die photo](/lsi/img/581ik2.jpg)

### MicROM 581РУ2 (cloned MCP-1631-010)
![Die photo](/lsi/img/581ru2.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, browser might hang):
- [581ИK1 Top metal, 15Kx15K, 321M](http://www.1801bm1.com/files/retro/581/images/581ik1.jpg)
- [581ИK1 Diffusion, 15Kx15K, 360M](http://www.1801bm1.com/files/retro/581/images/581ik1u.jpg)
- [581ИK2 Top metal, 15Kx15K, 320M](http://www.1801bm1.com/files/retro/581/images/581ik2.jpg)
- [581ИK2 Diffusion, 15Kx15K, 316M](http://www.1801bm1.com/files/retro/581/images/581ik2u.jpg)
- [581РУ2 Top metal, 13Kx12K, 230M](http://www.1801bm1.com/files/retro/581/images/581ru2.jpg)
- [581РУ2 Diffusion, 13Kx12K, 209M](http://www.1801bm1.com/files/retro/581/images/581ru2u.jpg)

## The original DEC LSI-11

The DEC PDP-11/03 computer is based on the LSI-11 chipset. This chipset
was designed by Western Digital in 1974 on contract by DEC, named as
MCP-1600 and encompassed three chips:
- the Control Chip MCP-1621, provides microinstruction address generation
  and controls the external data access and interrupt logic
- the Data Chip MCP-1611, contains register block and 8-bit datapath ALU,
  executes microinstructions conrolled by microinstuction stream fetched
  by Control Chip
- MicROM Chip MCP-1631, is a 512 x 22bit storage for microinstructions,
  up to four MicROM can be installed in the system

The chips were produced by Western Digital and later by DEC with 7u NMOS
process and operated up to 3.3MHz. 

581 series is the Soviet clone of MCP-1600 chipset, produced by VFSD
("Voronezh Factory of Semiconductor Devices" - "Воронежский Завод
Полупроводниковых Приборов") behind the Iron Curtain in the 1980th.

## Micromachine structure
![Micromachine](/lsi/img/cp1600.png)

## Documentation

- [MCP-1600 User Manual](http://www.bitsavers.org/pdf/westernDigital/MCP-1600/MCP-1600_Users_Manual_Oct77.pdf) -
  original vendor documentation, written by Western Digital. This manual is intended
  to be used by those who need a detailed description of the internal operation of the
  MCP1600 Microprocessor Set. Users in this category are usually those who are implementing
  their own microcode structures and thus require a detailed knowledge of the machine.
- [LSI-11 WCS User Guide](http://www.bitsavers.org/pdf/dec/pdp11/1103/EK-KUV11-TM_LSI11_WCS.pdf) -
  original vendor documentation, written by Digital. This manual provides the user
  with all the information required to write, assemble, debug and execute microprograms
  on the LSI-11 utilizing the Writable Control Store (WCS) option (KUV11-AA)
  in conjunction with microprogramming support software.
- [ODT description](/lsi/rom/doc/odt.md) - description of ODT commands
- [MCP-1600 mnemonics](/lsi/rom/doc/mcp1600.pdf) - the MCP-1600 microcode mnemonics
- [Micro Assembler](/lsi/rom/doc/micasm.md) - the Microcode Assembler developed in Python
- [Microcode images](/lsi/rom) - read out microcode binary images
- [Microcode sources](/lsi/rom/src/microm.mic) - disassemled microcode sources

## Asynchronous model passes the DEC factory tests

- [VKAAC0](/lsi/tst/org/vkaac0.mac) - basic instruction set factory test
- [VKABB0](/lsi/tst/org/vkabb0.mac) - extended instruction set factory test
- [VKACC1](/lsi/tst/org/vkacc1.mac) - float instruction set factory test
- [VKADC1](/lsi/tst/org/vkadc1.mac) - traps and interrupts factory test

## Directory structure
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
in an asynchronous original model with precision to half period of high-frequency clock.

#### \hdl\wbc
- synchronous Wishbone compatible version of LSI-11 synchronous core uses a single clock,
is FPGA-optimized, and follows the original command execution timings, is intended for SoC building

#### [\cad\lsi](https://github.com/1801BM1/cad11/tree/master/lsi) (moved to dedicated repo)
- topology in Sprint Layout format
- schematics 581ИК1 in [pdf](https://github.com/1801BM1/cad11/tree/master/lsi/mcp1611a.pdf) (gate level)
- schematics 581ИК2 in [pdf](https://github.com/1801BM1/cad11/tree/master/lsi/mcp1621a.pdf) (gate level)

#### \rom
- MicROM binary images
- MicROM disassemled sources
- tools (Assembler and Disassemler)
- microinstructions cheetsheet

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
- Wishbone compatible LSI-11 core
- register file over flip-flops, MicROM in RAM blocks
- 4 MSB of MicROM are optimized with combinatorial logic
- balanced area/speed optimization chosen
- slow model, worst corner

All results are just approximate estimations by synthesis tools (Quartus/XST/Vivado) on sample
projects.

| Board   | FPGA            | Family      | Fmax    | LUTs | FFs | MEM    |
|---------|-----------------|-------------|---------|------|-----|--------|
| DE0     | EP3C16F484C6N   | Cyclone III | 84 MHz  | 1543 | 401 | 4 M9K  |
| DE1     | EP2C20F484C7N   | Cyclone II  | 63 MHz  | 1567 | 408 | 9 M4K  |
| DE2-115 | EP4CE115F29C7N  | Cyclone IV  | 75 MHz  | 1531 | 393 | 4 M9K  |
| AX309   | XC6SLX9FTG256-2 | Spartan 6   | 69 MHz  | 1330 | 616 | 4 B16  |
| DE10-LT | 10M50DAF484C7G  | Max 10      | 68 MHz  | 1435 | 406 | 4 M9K  |
| QC5     | 5CEFA2F23I7N    | Cyclone V   | 86 MHz  | 1040 | 535 | 4 M10K |