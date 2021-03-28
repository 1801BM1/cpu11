## Factory test ROM

Factory and some other tests for 1801BM1

Test are adopted to be run within simulation or/and start automatically
after hardware reset. Some minor bugs are fixed. Original factory tests
start at address 200<sub>8</sub>.

Pitest may be configured to calculate specified number of pi digits
(memory limited) and configured to use MUL instruction.

#### \org
Original ROM binaries and restored sources:
- 791323, memory test for MC1201 boards
- 791401, basic PDP-11 instructions test
- 791404, 1801BM1 interrupt test on MC1201.01 board

#### \out
Temporary target folder, images are built with filenames "test.*"
and simulators/bitstream assemblers take image files from here.

## How to setup and build
To compile test sources the RT-11 simulator and original MACRO-11
assembler is used.

The [RT-11 simulator](http://emulator.pdp-11.org.ru/RT-11/distr/) was
written by Dmitry Patronov for Windows platform, and allows to share RT-11
drive with Windows directory. Building batch copies the source file to
shared temporary directory, creates RT-11 build.com batch and executes
simulator application with appropriate commands. The compilation results
can be taken from the same shared directory. ZIP arhive of simulator was used
to compile tests can be downloaded [here](http://www.1801bm1.com/files/utils/rt11_sim.zip)

To setup compilation environment:
- create shared directory, without spaces and ASCII only symbols in name
- create directory for simulator where you wish to install it
- set user environment variables "cpu11_tmp" and "cpu11_sim" to the directories
- download the simulator archive and unpack to created installation folder
- edit CmdLine.cfg file, assign in [HD.ini] section HD2= to the shared folder
- run build.bat test_filename_without_extension
- see the compilation results in /out folder
- if some error occured, see the vt52.log file in shared folder
