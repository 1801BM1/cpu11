#!/bin/bash -xe
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
x=`pwd`
x=${x#*cpu11/}
CPUID=${x%/tst}

macro11 -l ${base_fn}.lst -o ${base_fn}.obj $in_fn
#pclink11 /MAP /EXECUTE:${base_fn}.sav ${base_fn}.obj
obj2bin.pl --binary --outfile=${base_fn}.lda ${base_fn}.obj
case "$CPUID" in
	vm3|f11)
		SZ=0x8000
		;;
	*)
		SZ=0x4000
		;;
esac
srec_cat ${base_fn}.lda -dec_binary -o ${base_fn}.bin -binary
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mem --VMem 16
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.hex -Intel
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mif -Memory_Initialization_File 16 -obs=2

if [ "$base_fn" = "test" ]; then
    # test.{mif,mem} will remain in $CPUID/tst/ to be used by de0_tbl.v (run_iverilog.sh on Unix)
    mkdir -p out
    mv ${base_fn}.mem out/
    exit 0
fi
# else - copy pitest.mem into "release" folder to run on bare-metal
MEM_F=../../xen/tst/$CPUID.mem
MIF_F=../../xen/tst/$CPUID.mif
[ -e "$MEM_F ]  && mv -f $MEM_F{,~}
[ -e "$MIF_F ]  && mv -f $MIM_F{,~}
cp -p ${base_fn}.mem $MEM_F
cp -p ${base_fn}.mif $MIF_F
