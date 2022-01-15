## MicROM Files

These files are deduced from the content read from real MicROMs:

- [1811BÓ1](/f11/rom/000.mif) (cloned DC303D 23-001C7 AA)
- [1811BÓ2](/f11/rom/002.mif) (cloned DC303D 23-203C7-AA)
- [1811BÓ3](/f11/rom/001.mif) (cloned DC303D 23-002C7 AA)

Some srec_cat commands to convert .mif files:

```
srec_cat 000.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 000.rom --VMem 32 -obs 32
srec_cat 001.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 001.rom --VMem 32 -obs 32
srec_cat 002.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 002.rom --VMem 32 -obs 32
```
