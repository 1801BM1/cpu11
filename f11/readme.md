## Die photo

### Data Chip 1811BM1 (cloned DC302)
![Die photo](/f11/img/1811vm1.jpg)

### Control Chip 1811ВУ1 (cloned DC303)
![Die photo](/f11/img/1811vu1.jpg)

### MMU Chip 1811BT1 (cloned DC304)
![Die photo](/f11/img/1811vt1.jpg)

Links to raw panoramic photos (CAUTION: files are VERY LARGE, browser might hang):
- [1811BM1 Top metal, 15Kx15K, 103M](http://www.1801bm1.com/files/retro/1811/images/1811vm1.jpg)
- [1811BM1 Diffusion, 15Kx15K, 77M](http://www.1801bm1.com/files/retro/1811/images/1811vm1-diff.jpg)
- [1811BT1 Top metal, 13Kx12K, 123M](http://www.1801bm1.com/files/retro/1811/images/1811vt1.jpg)
- [1811BT1 Diffusion, 13Kx12K, 91M](http://www.1801bm1.com/files/retro/1811/images/1811vt1-diff.jpg)
- [1811ВУ1 Top metal, 15Kx15K, 100M](http://www.1801bm1.com/files/retro/1811/images/1811vu1.jpg)
- [1811ВУ1 Diffusion, 15Kx15K, 73M](http://www.1801bm1.com/files/retro/1811/images/1811vu1-diff.jpg)
- [1811ВУ2 Top metal, 15Kx15K, 91M](http://www.1801bm1.com/files/retro/1811/images/1811vu2.jpg)
- [1811ВУ3 Top metal, 15Kx15K, 78M](http://www.1801bm1.com/files/retro/1811/images/1811vu3.jpg)

## The original DEC F-11

"The F-11 (code name: the Fonz) was DEC's second microprocessor design,
and the first to be architected by DEC personnel in 1979. Duane Dickhut
was the project leader, Bill Johnson was lead design engineer for
the Data chip, and Burt Hashizume wrote most of the microcode.
The MMU was designedby Dan Dobberpuhl's consulting company.

The F-11 was substantially more ambitious than the LSI-11. It implemented
the entire PDP-11/34 architecture, including FP11-compatible floating point
and KT11-compatibile memory management. It targeted 3X the performance
of the LSI-11, at almost the same clock rate. It provided physical address
extension out to 22b, the first system to do so after the PDP-11/70.
It implemented the PDP-11 Commercial Instruction Set as an option,
the only other implementation was for the PDP-11/44.

Like the LSI-11, the F-11 was a chip set consisting of three designs,
one of which could be replicated: the Control Chip (up to nine supported),
the Data chip, and the MMU chip. It was implemented in AMI's 6u NMOS
process and operated at 3.6Mhz (280ns microcycle). The DEC PDP-11/23
computer is based on the F-11 "Fonz" chipset" -
[Bob Supnik](http://simh.trailing-edge.com/semi/f11.html).

The 1811 series is the Soviet clone of F-11 chipset, produced by VFSD
("Voronezh Factory of Semiconductor Devices" - "Воронежский Завод
Полупроводниковых Приборов") behind the Iron Curtain in the second
half of 1980th.

## Asynchronous model
Only initial draft of asynchronous model is presented for the moment.
This model contains latches and intended for simulation only.
The factory test jkdbd0 (basic instuctions and interrupts) passed
in simulation.
