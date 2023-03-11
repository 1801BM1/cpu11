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

#### [\cad\vm3](https://github.com/1801BM1/cad11/tree/master/vm3) (moved to dedicated repo)
- topology in Sprint Layout format
- topology in PCD-2004 pcb format
- schematics in PCD-2004 pcb format
- schematics in pdf (gate level)

## Work in Progress

	