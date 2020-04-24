## MicROM Files

These files are deduced from the content read from real MicROMs:
- [581РУ1](/lsi/rom/007.mif) (cloned DEC MCP-1631-07)
- [581РУ2](/lsi/rom/010.mif) (cloned DEC MCP-1631-10)
- [581РУ3](/lsi/rom/015.mif) (cloned DEC MCP-1631-15)

Some srec_cat commands to convert .mif files:

```
srec_cat all.mif -Memory_Initialization_File -unsplit 4 0 3 -fill 0x00 0x0000 0x2000 -byte-swap 4 -o all.rom --VMem 32
```

## Micromachine structure
![Die photo](/lsi/img/cp1600.png)

## ODT/Console microcode

This paragraph contains the description of Online Debugging Tool (ODT)
extracted from "LSI-11 PDP-11/03 Processor Handbook" (c) Digital 1975.

The LSI-11 does not have an internal or external switch register or
control function switch option. In a typical configuration there is
no bus device which responds to address 177570 (the SWR address on PDP-11).
The function of Load Address, Deposit, Examine, Continue, Start/Halt
are implemented with  microcode routines that communicate with an
operator via a serial stream of ASCII characters. For operation, it
requires a serial line interface (e.g., DLV11) at Bus address 177560 and
a device that can interpret and display as well as send ASCII characters
(e.g., LA36).

The HALT or ODT microcode state of the KD11-F can be entered in five
different ways (others are a subset of these), from the RUN state:

- Execution of a LSI-11 HALT instruction
- A double Bus Error (Bus Error trap with SP (R6)
  pointing to nonexistent memory)
- The assertion of a low level on the B_HALT line on the Bus
- As a powerup option
- ASCII break with DLV11 framing error asserting the B_HALT line
  (enabled by jumper of DLV11)

Upon entering the HALT state, the KD11-F responds through the console
device with an ASCII prompt character sequence. The following prompt
sequence is used:

- CR LF nnnnnn CR LF @ (where nnnnnn is the location of the next LSI-11
  instruction to be executed and @ is ODT prompt character).

The following is a list of the command character set and its utilization.
In each example the operator's entry is not underlined, and the KD11-F
response is. Note that in part the character set is a subset of ODT-11.
The input character set is interpreted by the KD11-F only when it is in
the HALT state.

Note also that all commands and characters are echoed by the KD11-F and
that illegal command characters will be echoed and followed by "?"
(ASCII 012<sub>8</sub>) followed by CR (ASCII 015<sub>8</sub>) followed
by LF (ASCII 012<sub>8</sub>) followed by "@" (ASCII 100<sub>8</sub>).
If a valid command character is received when no location is open
(e.g., when having just entered the halt state), the valid command
character will be echoed and followed by a "?", CR, LF, "@". Opening
non-existent locations will have the same response. The console always
prints six numeric characters. However, the user is not required to type
leading zeros for either address or data.

### 1. "/" slash (ASCII 057<sub>8</sub>)

This command is used to open a memory location, general purpose register,
or the processor status word. The "/" command is normally preceded by
a location identifier. Before the contents is typed, the console will
issue a space (ASCII 40<sub>8</sub>) character.
```
@ 001000/ 021525
```
where:
- "@" - KD11F prompt character (ASCII 100<sub>8</sub>)
- "001000" - octal location in address space to be opened
- "/" - command to open and exhibit contents of location
- "012525" - contents of octal location 1000<sub>8</sub>

NOTE
If / used without preceding location identifier, address of last opened
location will be used. This feature can be used to verify the data just
entered in a location.

### 2. "CR" carriage return (ASCII 015<sub>8</sub>)

This command is used to close an open location. If contents of location
are to be changed, CR should be preceded by the new value. If no change
to location is necessary then CR will not alter contents.
```
@ 001000/ 012525 CR LF
@ / 012525
or
@ 001000/ 012525 15126421 CR LF
@ /126421
```
where:
- "CR" - (ASCII 015<sub>8</sub>) used to close location 1000<sub>8</sub>
in both examples. Note that in second example contents of location
1000<sub>8</sub> was changed and that only the last 6 digits entered
were actually placed in location 1000 <sub>8</sub>.

### 3. "LF" line feed (ASCII 012<sub>8</sub>)

This command is also used to close an open location or GPR (general
purpose register). If entered after a location has been opened, it will
close the open location or GPR and open location +2 or GPR+1. If the
contents of the open location or GPR are to be modified, the new
contents should precede the LF operator.
```
@ 1000/ 012525 LF CR
001002/ 005252 CR LF
@
```
where:
- "LF" - (ASCII 012<sub>8</sub>) used to close location 1000<sub>8</sub>
and open location 1002<sub>8</sub>, if used on the PS, the LF will modify
the PS if the data has been typed, and close it. Then a CR, LF, @ is issued.
If LF is used to advance beyond R7, the register name that is printed is
meaningless but the contents printed is that of R0.

### 4. "^" up arrow (ASCII 136<sub>8</sub>)

The "^" command is also used to close an open location or GPR. if entered
after a location or GPR has been opened, it will close the open location
or GPR and open location -2, or GPR-1. If the contents of the open location
or GPR are to be modified, the new contents should precede the "^" operator.
```
@ 1000/ 012525^ CR LF
000776/ 010101 CR LF
@
```
where:
- "^" - (ASCII 136<sub>8</sub>) used to close location 1000<sub>8</sub>
and open location 776<sub>8</sub>.
- (ASCII 135<sub>8</sub>) up arrow

If used on the PS, the "^" will modify the PS if the data has been typed
and close it, then CR, LF, @ is issued. If "^" is used to decrement below
R0, the register name that is printed is meaningless but the contents is
that of R7.


### 5. "@" at sign (ASCII 100<sub>8</sub>)

The "@" command is used once a location has been opened to open a location
using the contents of the opened location as a pointer. Also the open
location can be optionally modified similar to other commands and if done,
the new contents will be used as the pointer.
```
@ 1000/ 000200 @ CR LF
000200/ 000137 CR LF
```
where:
- "@" - (ASCII 100<sub>8</sub>) used to close open location 1000<sub>8</sub>
  and open location 200<sub>8</sub>.

Note that the "@" command may be used with either GPRs or memory contents.
If used on the PS, the command with modify the PS if data has been typed
and close it, however, the last GPR or memory location contents will be
used as a pointer.

### 6. Back arrow (ASCII 137<sub>8</sub>)

This command is used once a location has been opened to open the location
that is the address of the contents of the open location plus the address
of the open location plus 2. This is useful for relative instructions
where it is desired to determine the effective address.
```
@ 1000/ 000200 _ CR LF
001202/ 002525 CR LF
```
where:

- "_" (ASCII 137<sub>8</sub>) used to close open location 1000<sub>8</sub>
  and open location 1202<sub>8</sub> (sum of contents of location 1000<sub>8</sub>,
  1000<sub>8</sub> and 2).

Note that this command cannot be used if a GPR or the PS is the open location
and if attempted, the command will modify the GPR or PS if data has been typed,
and close the GPR or PS, then a CR, LF, @ will be issued.

### 7. "$" dollar sign (ASCII 044<sub>8</sub>) or R (ASCII 122<sub>8</sub>) internal register
designator

Either command if followed by a register value 0-7 (ASCII 060<sub>8</sub>
-067<sub>8</sub>) will allow that specific general purpose register
to be opened if followed by the / (ASCII 057<sub>8</sub>) command.
```
@ $ n/ 012345 CR LF
@
```
where:
- "$" - register designator. This could also be R. n - octal register 0-7.
- 012345 = contents of GPR n.

Note that the GPRs once opened can be closed with either the CR, LF, "^",
or "@" commands. The "_" command will also close a GPR but will not perform
the relative mode operation.

### 8. "$ s" (ASCII 044<sub>8</sub> ASCII 123<sub>8</sub>) processor status word

By replacing "n" in the above-example with the letter "S" (ASCII 123<sub>8</sub>)
the processor status word will be opened. Again either "$" or "R" (ASCII 122<sub>8</sub>)
is a legal command.
```
@ $ S/ 000200 CR LF
@
```
where:
- "$" - GPR or processor status word designator
- "S" - specifies processor status register, differentiates from GPRs.
- "000200" -  eight bit contents of PSW, bit 7=1, all other bits = 0.

Note that the contents of the PSW can be changed using the CR command
but bit 4 (the T bit) cannot be set using any of the commands.

### 9. "G" (ASCII 107<sub>8</sub>)

The "G" (GO) command is used to start execution of a program at the memory
location typed immediately before the "G".
```
@ 100 G or 100;G
```

The LSI-11 PC(R7) will be loaded with 100<sub>8</sub> and execution will
begin at that location. Before starting execution, a BUS_INIT is issued
for 10 usec followed by 90 usec of idle time. Note that a semicolon
character (ASCII 073<sub>8</sub>) can be used to separate the address
from the G and this is done for PDP-11 ODT compatibility. Since the
console is a character-by-character processor, as soon as the "G"
is typed, the command is processed and a RUBOUT cannot be issued
to cancel the command. If the B_HALT_L line is asserted, execution
does not take place and only the BUS_INIT sequence is done. The machine
returns to console mode and prints the PC followed by CR, LF, @.

### 10. "P" (ASCII 120<sub>8</sub>)

The "P" (Proceed) command is used to continue or resume execution at the
location pointed to by the current contents of the PC(R7).
```
@ P or ;P
```
If the B_HALT_L line is asserted the INIT line will not be asserted,
a single instruction will be executed, and the machine will return
to console mode. It will print the contents of the PC followed by
a CR,LF,@. In this fashion, it is possible to single instruction step
through a user program.

The semicolon is accepted for PDP-11 ODT compatibility. If the semicolon
character is received during any character sequence, the console ignores it.

### 11. "M" (ASCII 115<sub>8</sub>)

The "M" (Maintenance) command is used for maintenance purposes and
prints the contents of an internal CPU register. This data reflects
how the machine got to the console mode.
```
@ M 000213 CR LF
@
```
The console prints six characters and then returns to command mode
by printing CR, LF, @.

The last octal digit is the only number of significance and is encoded
as follows. The value specifies how the machine got to the console mode.

- 0 - Halt instruction or B_HALT line
- 1 - Bus Error occurred while getting device interrupt vector
- 2 - Bus Error occurred while doing memory refresh
- 3 - Double Bus Error occurred (stack was non-existent value)
- 4 - Non-existent Micro-PC address occurred on internal CPU bus

In the above example, the last octal digit is a "3", which indicates
a Double Bus Error occurred.

### 12. "RO" RUBOUT (ASCII 177<sub>8</sub>)

While RUBOUT is not truly a command, the console does support this
character. When typing in either address or data, the user can type
RUBOUT to erase the previously typed character and the console will
respond with a "\" (Backslash-ASCII 134<sub>8</sub>) for every
typed RUBOUT.
```
@ 000100/ 077777 123457 (RUBOUT) \ 6 CR LF
@ 000100/ 123456
```
In the above example, the user typed a "7" while entering new data
and then typed RUBOUT. The console responded with a and then the user
typed a "6" and CR. Then the user opens the same location and the new
data reflects the RUBOUT. Note that if RUBOUT is issued repeatedly,
only numerical characters are erased and it is not possible to terminate
the present mode the console is in. If more than six RUBOUTS are
consecutively typed, and then a valid location closing command is typed,
the open location will be modified with all zeroes.

The RUBOUT command cannot be used while entering a register number,
R2 \ 4 / 012345 will not open register R4, however the RUBOUT command
will cause ODT to revert to memory mode and open location 4.

### 13. "L" (ASCII 114<sub>8</sub>)

The "L" (Boot Loader) command will cause the processor to self-size
memory and then load from the specified device a program that is
in Bootstrap Loader Format (e.g.-Absolute Loader). The device is
specified by typing in the address of the input control and status
register immediately before the "L".
```
@ 177560L
```
First memory is sized, starting at 28K and the device address
(177560<sub>8</sub>) is placed in the last location for Absolute Loader
compatibility. Then the program will be loaded by setting the "GO"
bit in address 177560<sub>8</sub> and reading a byte of data from
177562<sub>8</sub>.

The loading begins at the address specified in the Bootstrap loader
format. The loading is terminated when address XXX775<sub>8</sub>
has been loaded and execution automatically begins at XXX774<sub>8</sub>.
It is up to the program being loaded to halt the processor if that
is desired. In the case of the Absolute Loader, the processor will
halt and the console will print XXX500<sub>8</sub> (the current PC)
followed by CR,LF,@. (XXX = 017 for 4K memory; XXX = 157 for 28K memory).

When loading a program using the "L" command, the B_HALT_L line
is ignored. If a timeout error occurs, the console will terminate
the load and print ?, CR, LF, @.

Any device address may be used as long as it is software compatible
with the DLV11. If no address is typed, address 0 will be used.

### 14. "CONTROL-SHIFT-S" (ASCII 23)

This command is used for manufacturing test purposes and is not
a normal user command. It is briefly described here so that in case
a user accidentally types this character, he will understand
the machine response. If this character is typed, ODT expects
two more characters. It uses these two characters as a 16-bit
binary address and starting at that address, dumps five locations
in binary format to the serial line.

It is recommended that if this mode is inadvertently entered,
two characters such as a NULL (0) and @ (ASCII 100<sub>8</sub>)
be typed to specify an address in order to terminate this mode.
Once completed, ODT will issue a CR, LF, @.
