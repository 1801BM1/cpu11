## Die photo

![Die photo](/vm3/img/vm3a.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, browser might hang):
- [1801BM3 Top metal, 22Kx18K, 607M](http://www.1801bm1.com/files/retro/1801/images/vm3a-met.jpg)
- [1801BM3 Diffusion, 19Kx16K, 397M](http://www.1801bm1.com/files/retro/1801/images/vm3a-dif.jpg)

## 1801BM3
The 1801BM3 is a single-chip microprocessor, was designed in the second half of 1980-th
and had PDP-11 compatible architecture. Notable, it was not an exact clone of one
of the original DEC processors but had its own internal architecture.

The 1801BM3 is the further development of 1801BM1/1801BM2 and is the most performance
microprocessor in the 1801 series, encompasses MMU, and provides an integrating option
for external FPP (dedicated 1801BM4 chip). Its ALU takes 3 clocks per micro-operation,
there is the dedicated PC adder (i.e ALU is not used to update PC), and 1801BM3 is capable
to execute a register-register command only in 3 clocks. The 1801BM3 is not based
on the static design, there is presumably a lower limit of operating frequency about 100kHz.

## Compatibility
The closest DEC model 1801BM3 matches is PDP-11/34, it supports:

- odd address trap
- PSW mapping to 17777776<sub>8</sub>
- mtps and mfps instructions
- ash, ashc, mul, div instructions
- MMU SR0 diagnostics M-bit
- exception on 01<sub>2</sub> and 10<sub>2</sub> CPU mode
- non advancing (Rx)+, @(Rx)+ in case of exception
- fully compatible 11/34 MMU in 18-bit mode
- 22-bit MMU extension (absent in original 11/34)

## Known 1801BM3 incompatible issues
- all reserved SR3 register bits are readonly and read out as ones
- if instuction runs into bus timeout and on exception handling the MMU exception
  occurs, the SR2 contains the address of the next instruction
- special HALT mode is implemented to handle halt instruction and double error
  exceptions in kernel mode, provides ODT functionality with external ROM program

## Models passed the factory tests
The factory tests passed by the asynchronous model in simulation:

- [fkaac0](/vm3/tst/org/fkaac0.mac) - 11/34, basic instructions test
- [fkabd0](/vm3/tst/org/fkabd0.mac) - 11/34, traps and exceptions test
- [fkaca0](/vm3/tst/org/fkaca0.mac) - 11/34, extended instruction set test (EIS)
- [fkthb0](/vm3/tst/org/fkthb0.mac) - memory management unit test (11/34, 18-bit MMU)
- [jkdad0](/vm3/tst/org/jkdad0.mac) - memory management unit test (F11, 22-bit MMU)
- [haltm](/vm3/tst/org/haltm.mac) - halt mode test, 1801BM3 specific

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
- synchronous Verilog HDL model, the frontend bus is Q-Bus, uses single clock to operate, does not
contain latches, and whole model can be synthesized for synchronous FPGAs. This model is intermedate
step for final Wishbone-compatible version.

#### \hdl\wbc
- synchronous Wishbone compatible version of 1801BM3 synchronous core uses a single clock,
is FPGA-optimized, follows the original command execution timings, is intended for SoC building.

#### [\cad\vm3](https://github.com/1801BM1/cad11/tree/master/vm3) (moved to dedicated repo)
- topology in Sprint Layout format
- topology in PCD-2004 pcb format
- schematics in PCD-2004 pcb format
- schematics in pdf (gate level)

## How to simulate
- run "tst\build.bat haltm" to prebuild desired test software image (haltm is a sample)
- run ModelSim simulator
- set "vm3/hdl/org/sim/de0" as working directory in ModelSim (File->Change Directory)
- execute "do run.do" console command
- wait, simulation may take some time till complete
- see the results in waveform and console output

## Implemented resources
- RAM 16Kx16bit at 000000<sub>8</sub> with initialized content from test.mif file
- TTY at 177560<sub>8</sub>, 60<sub>8</sub>/64<sub>8</sub> vector interrupts, 
  tx/rx with cts/rts handshake, 115200/8/N/1, RS-232 levels (board dependent).
- 50Hz system timer interrupt (IRQ2, edge sensitive, vector 100<sub>8</sub>),
  enabled by board switch[0], if timer is enabled the board led[0] lights
- 4x7-segment display, segments attached to output registers at 177714<sub>8</sub>/177716<sub>8</sub>,
  see the test software source for the details
- halt mode debug register, write only at 177710<sub>8</sub>
- switches and buttons can be read from input register at 177714<sub>8</sub>
- board button[0] is reset, short press less than 1 sec causes system reset, 
  long press over 1 second simulates power reset (excluding RAM content)

## Fmax and FPGA resources
- Wishbone compatible 1801BM3 core
- register file and constant generator in flip-flops, no RAM block
- speed optimization chosen
- slow model, worst corner

All results are just approximate estimations by synthesis tools (Quartus/XST) on sample
projects.

| Board   | FPGA             | Family       | Fmax    | LUTs | FFs  | MEM    |
|---------|------------------|--------------|---------|------|------|--------|
| DE0     | EP3C16F484C6N    | Cyclone III  | 99 MHz  | 3397 | 1340 | 1 M9K  |
| DE1     | EP2C20F484C7N    | Cyclone II   | 74 MHz  | 3834 | 1515 | 1 M4K  |
| DE2-115 | EP4CE115F29C7N   | Cyclone IV   | 87 MHz  | 3981 | 1558 | 1 M9K  |
| DE10-LT | 10M50DAF484C7G   | Max 10       | 81 MHz  | 3048 | 1198 | 1 M9K  |
| QC5     | 5CEFA2F23I7N     | Cyclone V    | 105 MHz | 1562 | 1483 | 1 M10K |
| QC10    | 10CL006U256CN8   | Cyclone 10   | 73 MHz  | 3421 | 1423 | 1 M9K  |
| EG4     | EG4S20BG256      | Eagle EG4S20 | 71 MHz  | 3949 | 1221 | 1 M9K  |
