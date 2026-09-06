#!/bin/bash -e
WORKDSK=/dev/shm/work.dsk
OSDSK=/dev/shm/rt11os.dsk
TAPE=$(mktemp -t XXXX.tap)
#########################
if [ $# -eq 0 ] ; then
	echo "Usage: $0 file.mac" >&2
	exit 1
fi
FN="$1"
shift
if [ ! -e "$FN" ] ; then
	echo "$FN: doesn't exist" >&2
	exit 2
fi
tmpini=$(mktemp -t XXXXXX.ini)
function atexit()
{
  test -e "$tmpini" && rm -f "$tmpini"
  test -e "$TAPE" && rm -f "$TAPE"
}
trap atexit EXIT TERM INT
#
LOCAL_FN=$(realpath "$FN")
LOCAL_DIR=$(dirname "$LOCAL_FN")
LOCAL_OUT_DIR=$LOCAL_DIR/out
mkdir -p $LOCAL_OUT_DIR
# echo "LOCAL_FN is $LOCAL_FN"
NN=$(basename ${FN%.*})

# Create DEC tape with source
dectape -Io $TAPE
dectape -o "$LOCAL_DIR" $TAPE
### Create STARTF.COM to be executed on start of RT-11
cat <<EOF > /dev/shm/STARTF.COM
SET ERROR NONE
DATE $(date +%d-%b-95 |tr a-z A-Z)
COPY MT0:*.* DL1:
MACRO DL1:$NN.MAC /list:DL1:$NN.LST /object:DL1:$NN.OBJ
LINK DL1:$NN.OBJ /EXE:DL1:$NN.SAV
LINK DL1:$NN.OBJ /EXE:DL1:$NN.LDA /LDA
COPY DL1:$NN.* MT0:
R HALT
EOF
#PRINT DL1:$NN.LST
# COPY DL1:$NN.LDA PC:
### ^^^
RT11=${RT11:-/usr/local/share/rt11}
# copy images to /dev/shm/
cp "$RT11/Disks/empty-formatted.dsk" "$WORKDSK"
cp $RT11/rt11os.dsk "$OSDSK"
# Add files to rt11dsk and work
unix2dos /dev/shm/STARTF.COM >/dev/null
# rt11dsk a "$WORKDSK" $LOCAL_FN >/dev/null
rt11dsk d "$OSDSK" STARTF.COM >/dev/null
rt11dsk a "$OSDSK" /dev/shm/STARTF.COM >/dev/null

# Create INI file to run SIMH / pdp11
cat <<EOF >$tmpini
set cpu 11/23+ 256K noidle
set throttle 10%
set console wru=035
set tto 8b
set rl1 writeenabled
set rl1 rl02
ATTACH rl1 -n $WORKDSK
set rl0 writeenabled
set rl0 rl02
ATTACH rl0 -n $OSDSK
; EXPECT "MACRO-E-Errors detected:" SEND "PRINT $NN.lst\r"; GO
ATTACH TM0 $TAPE
BOOT rl0
DETACH TM0
EXIT
EOF
# Run SIMH / pdp11
pdp11 $tmpini
# Copy out results
dectape -o $TAPE $LOCAL_OUT_DIR
touch $LOCAL_OUT_DIR/*.*
# exit with 0 (true) of no errors found, else 1 (false)
grep -q "MACRO-E-Errors" $LOCAL_OUT_DIR/*.LST && exit 1
if egrep -Eq "vm3|f11" $LOCAL_FN ; then
	SZ=0x8000
else
	SZ=0x4000
fi
ls -l $LOCAL_OUT_DIR
base_fn="$LOCAL_OUT_DIR/$NN"
srec_cat $LOCAL_OUT_DIR/$(tr a-z A-Z <<<$NN).LDA -dec_binary -o ${base_fn}.bin -binary
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mem --VMem 16
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.hex -Intel
srec_cat ${base_fn}.bin -binary -fill 0x00 0x0000 $SZ -byte-swap 2 -o ${base_fn}.mif -Memory_Initialization_File 16 -obs=2

