#!/bin/bash -xe
cp -p Disks/rtv53_rl.dsk distribution.dsk
cp -p Disks/empty-rl02.dsk distribution-backup.dsk
cp -p Disks/empty-rl02.dsk rt11os.dsk
cp -p Disks/empty-rl02.dsk empty.dsk
touch lpt.txt
pdp11 initial.ini
mv empty.dsk Disks/empty-formatted.dsk
touch -t 9101011200 HALT.SAV STARTF.COM
rt11dsk a ./rt11os.dsk HALT.SAV >/dev/null
rt11dsk d ./rt11os.dsk STARTF.COM >/dev/null
rt11dsk a ./rt11os.dsk STARTF.COM >/dev/null
rt11dsk l ./rt11os.dsk |egrep -i "START|HALT"
