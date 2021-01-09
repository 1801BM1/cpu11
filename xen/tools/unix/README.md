# How to compile MACRO-11 files on Unix (Linux, MacOS, FreeBSD)

Download a couple of tools:
  * macro-11 cross-assembler from SimH tools:  https://github.com/simh/simtools
  * obj2bin tool:  https://github.com/AK6DN/obj2bin

In fact, MACRO11 has been ported to Windwos as well (macro11.exe.zip in binary form):
  http://retrocmp.com/tools/macro-11-on-windows

So that RT11 emulator is not neeed to compile MACRO11 code for the absolute binary of ROM.


## How to build macro11

    git clone https://github.com/simh/simtools.git
    cd simtools/crossassemblers/macro11
    make

Optionally, install `macro11` into `/usr/local/bin` (i.e. PATH):

    sudo install -m 755 ./macro11 /usr/local/bin

## How to install obj2bin.pl tool

Simply download the tool:

    curl -o /usr/local/bin/obj2bin.pl https://raw.githubusercontent.com/AK6DN/obj2bin/master/obj2bin.pl
    chmod 755 /usr/local/bin/obj2bin.pl

### SRECORD

Don't forget to install srecord. On Debian/Ubuntu it is present as a DEB package:

    apt-get -y install srecord

## How to compile MACRO11 to ROM (mem files)

    #!/bin/bash
    set -e
    if [ $# -eq 0 ] ; then
        echo "Usage: $0 file.mac" >&2
        exit 1
    fi
    in_fn=$1
    if [ ! -e "$in_fn" ] ; then
        echo "$in_fn: doesn't exist"
        exit 2
    fi
    base_fn=${in_fn%.*}
    # FIXME
    x=`pwd`
    x=${x#*cpu11/}
    CPUID=${x%/tst}

    macro11 -l ${base_fn}.lst -o ${base_fn}.obj $in_fn
    #pclink11 /MAP /EXECUTE:${base_fn}.sav ${base_fn}.obj
    obj2bin.pl --binary --outfile=${base_fn}.lda ${base_fn}.obj
    srec_cat ${base_fn}.lda -dec_binary -o ${base_fn}.bin -binary
    srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ${base_fn}.mem --VMem 16
    srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ${base_fn}.hex -Intel
    srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ${base_fn}.mif -Memory_Initialization_File 16 -obs=2

    mv -f ../../xen/tst/$CPUID.mem{,~}
    mv -f ../../xen/tst/$CPUID.mif{,~}
    cp -p ${base_fn}.mem ../../xen/tst/$CPUID.mem
    cp -p ${base_fn}.mif ../../xen/tst/$CPUID.mif
