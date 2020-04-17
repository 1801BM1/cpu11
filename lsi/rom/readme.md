## MicROM Files

These files are deduced from the content read from real MicROMs:
- [581РУ1](/lsi/rom/007.mif) (cloned DEC MCP-1631-07)
- [581РУ2](/lsi/rom/010.mif) (cloned DEC MCP-1631-10)
- [581РУ3](/lsi/rom/015.mif) (cloned DEC MCP-1631-15)

Some srec_cat commands to convert .mif files:

```
srec_cat all.mif -Memory_Initialization_File -unsplit 4 0 3 -fill 0x00 0x0000 0x1800 -byte-swap 4 -o all.rom --VMem 32
```