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
  up to four MicROM can be installed in the system.

The chips were produced by Western Digital and later by DEC with 7u NMOS
process and operated up to 3.3MHz. 

581 series is the Soviet clone of MCP-1600 chipset, produced by VFSD
("Voronezh Factory of Semiconductor Devices" - "Воронежский Завод
Полупроводниковых Приборов") behind the Iron Curtain in the 1980th.

## Asynchronous model passes the DEC factory tests
- [VKAAC0](/lsi/tst/org/vkaac0.mac) - basic instruction set factory test
- [VKABB0](/lsi/tst/org/vkabb0.mac) - extended instruction set factory test
- [VKACC1](/lsi/tst/org/vkacc1.mac) - float instruction set factory test
- [VKADC1](/lsi/tst/org/vkadc1.mac) - traps and interrupts factory test