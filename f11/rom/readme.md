srec_cat 000.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 000.rom --VMem 32 -obs 32
srec_cat 001.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 001.rom --VMem 32 -obs 32
srec_cat 002.mif -Memory_Initialization_File -fill 0x00 0x0000 0x200 -byte-swap 4 -o 002.rom --VMem 32 -obs 32
