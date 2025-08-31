#!/bin/bash -e
if [ $# -eq 0 ] ; then
	echo "Usage: $0 file.mac" >&2
	exit 1
fi
ROOT=$(realpath $(dirname $0)/../../..)
FN="$1"
# echo "ROOT is $ROOT; EXT_ROOT is $EXT_ROOT; WD is $WD"
PFX=${WD#$EXT_ROOT/}
# echo "PFX is $PFX"
LOCAL_FN=$ROOT/$PFX/$(basename $FN)
LOCAL_OUT_DIR="$ROOT/$PFX/out"
mkdir -p $LOCAL_OUT_DIR
# echo "LOCAL_FN is $LOCAL_FN"
NN=$(basename ${FN%.*})
# echo "NN is $NN"

tmpini=$(mktemp -t XXXXXX.ini)
function atexit()
{
  test -e "$tmpini" && rm -f "$tmpni"
}
trap atexit EXIT TERM INT
RT11=${RT11:-/usr/local/share/rt11}
cp "$RT11/Disks/empty-formatted.dsk" "/dev/shm/work.dsk"
cp $RT11/rt11os.dsk /dev/shm/
# Create STARTF.COM to be executed on start of RT-11
cat <<EOF > /dev/shm/STARTF.COM
SET ERROR NONE
DATE $(date +%d-%b-91 |tr a-z A-Z)
MACRO MT0:$NN.MAC /list:DL1:$NN.LST /object:DL1:$NN.OBJ
PRINT DL1:$NN.LST
LINK DL1:$NN.OBJ /EXE:DL1:$NN.SAV
LINK DL1:$NN.OBJ /EXE:DL1:$NN.LDA /LDA
COPY DL1:$NN.LDA PC:
COPY DL1:$NN.* MT0:
R HALT
EOF
# ^^^
unix2dos /dev/shm/STARTF.COM
rt11dsk a /dev/shm/work.dsk $LOCAL_FN >/dev/null
rt11dsk d /dev/shm/rt11os.dsk STARTF.COM >/dev/null
rt11dsk a /dev/shm/rt11os.dsk /dev/shm/STARTF.COM >/dev/null
> /dev/shm/lpt.txt
> /dev/shm/test.ptp
mkdir -p /tmp/empty/
cp $LOCAL_FN /tmp/empty/
touch -t 9101011200 /tmp/empty/*
dectape -o /tmp/empty/ /dev/shm/test.tap
# Create INI file to run SIMH / pdp11
cat <<EOF >$tmpini
set cpu 11/23+ 256K noidle
set throttle 10%
set console wru=035
set tto 8b
set lpt enable
attach LPT /dev/shm/lpt.txt
set PTP enable
ATTACH PTP /dev/shm/test.ptp
attach TM0 /dev/shm/test.tap
set rl1 writeenabled
set rl1 rl02
attach rl1 -n /dev/shm/work.dsk
set rl0 writeenabled
set rl0 rl02
attach rl0 -n /dev/shm/rt11os.dsk
; EXPECT "MACRO-E-Errors detected:" SEND "PRINT $NN.lst\r"; GO
boot rl0
DETACH TM0
DETACH PTP
EXIT
EOF
# Run SIMH / pdp11
pdp11 $tmpini
# Copy out results
dectape -o /dev/shm/test.tap $LOCAL_OUT_DIR
cp -p /dev/shm/test.ptp $LOCAL_OUT_DIR/
cp -p /dev/shm/lpt.txt $LOCAL_OUT_DIR/$NN.lpt.txt
touch $LOCAL_OUT_DIR/*.*
# exit with 0 (true) of no errors found, else 1 (false)
grep -q "MACRO-E-Errors" /dev/shm/lpt.txt && exit 1
CPUID=${PFX%/*}
case "$CPUID" in
        vm3|f11)
                SZ=0x8000
                ;;
        *)
                SZ=0x4000
                ;;
esac
ls -l $LOCAL_OUT_DIR
base_fn="$LOCAL_OUT_DIR/$NN"
srec_cat $LOCAL_OUT_DIR/$(tr a-z A-Z <<<$NN).LDA -dec_binary -o ${base_fn}.bin -binary
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mem --VMem 16
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.hex -Intel
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mif -Memory_Initialization_File 16 -obs=2

