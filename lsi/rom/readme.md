## MicROM Files

These files are deduced from the content read from real MicROMs:
- [581РУ1](/lsi/rom/007.mif) (cloned DEC MCP-1631-07)
- [581РУ2](/lsi/rom/010.mif) (cloned DEC MCP-1631-10)
- [581РУ3](/lsi/rom/015.mif) (cloned DEC MCP-1631-15)

Some srec_cat commands to convert .mif files:

```
srec_cat a15.mif -Memory_Initialization_File -unsplit 4 0 3 -fill 0x00 0x0000 0x2000 -byte-swap 4 -o all.rom --VMem 32
```

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
- [Micro Assembler](/lsi/rom/doc/micasm.md) - the Microcode Assembler developed in Python
