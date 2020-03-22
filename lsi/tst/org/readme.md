## Original DEC hardware diagnostic programs

This folder contains the sources of original DEC diagnostic
software from XXDP+, the sources were OCR-ed and restored from
the listings. All sources are compilable and produce the files
coinciding with original binary ones.

| Test    | Description |
|:--------|:------------|
| VKAAC0 | This program tests the LSI-11 basic instruction set in all modes |
| VKABB0 | This program tests the LSI-11 extended instruction set option (ash, ashc, mul and div) |
| VKACC1 | This program tests the LSI-11 floating instruction set option (fadd, fsub, fmul, and fdiv) |
| VKADC1 | This is a test of all operations and instructions that traps oddities of register SP, interrupts, the reset, and wait instructions |

## DEC absolute loader format

XXDP+ provides test programs as .bic files in paper tape format used by
absolute loader. The format of absolute loader input is that it consists
of an arbitrary number of blocks, each of which has the following format:

| Field        | Size    | Description |
|:-------------|:--------|:------------|
| Leader       |  -      | optional, all bytes 0, clean tape |
| Start marker | 1 byte  | 0x01 value |
| Pad          | 1 byte  | 0x00 value |
| Block length | 2 bytes | block length, including header, checksum is not included, little-endian |
| Load address | 2 bytes | address to load, little-endian |
| Block Data   | N       | program to be loaded |
| Checksum     | 1 byte  | byte to complement summ of all block bytes to zero |

To convert the XXDP .bic files in tape format (DEC absolute
loader format) to raw binary format the srec_cat utility can
be used:

    srec_cat file.bic -dec_binary -o file.bin -binary

All files in this folder are converted to the raw binary format
to be loaded at address 000000.
