#!/bin/bash
#
# Build script for Linux environments by Stanislav Maslovski <stanislav.maslovski@gmail.com>
#
# On Debian, install the "srecord" package:
#    sudo apt install srecord
#
# The RT-11 emulator runs under wine in linux. Please install wine and wine-binfmt:
#    sudo apt install wine wine-binfmt
#
# The wine-binfmt allows launching windows executables directly from the command line.
#
# The last version of the RT-11 emulator can be obtained from https://emulator.pdp-11.org.ru/RT-11/distr/
#    wget https://emulator.pdp-11.org.ru/RT-11/distr/RT-11_Emulator_16.01.2022.rar
#
# Get the file rt11.exe out of archive and place it under a directory in your PATH (in my case, ~/bin/).
# Make it executable. For convenience, I also made a symlink rt11.
#    chmod 755 rt11.exe
#    ln -s rt11.exe rt11
#
# Setup the variables for the temp directory and path to the PDP-11 simulator.

cpu11_tmp=/tmp
cpu11_sim=~/bin/rt11

blank() {
    echo
    echo Batch file to compile and copy built images to project folders
    echo PDP-11 Simulator and original MACRO-11 on RT-11 is used to compile
    echo
    echo Environment variables should be set:
    echo   cpu11_tmp=$cpu11_tmp
    echo   cpu11_sim=$cpu11_sim
    echo
    echo Usage: ./build.sh filename_without_extension
    echo Example: ./build.sh t401
}

blank_tmp() {
    echo
    echo Environment variable cpu11_tmp should be set to temorary folder
}

blank_sim() {
    echo
    echo Environment variable cpu11_sim should be set to RT11 simulator folder
}

test -z $1 && blank && exit 1
test -z $cpu11_tmp && blank_tmp && exit 1
test -z $cpu11_sim && blank_sim && exit 1

cp $1.mac $cpu11_tmp/$1.mac

pushd $cpu11_tmp >/dev/null
echo "macro dk:$1.mac /list:dk:$1.lst /object:dk:$1.obj" > build.com
echo "link dk:$1.obj /execute:dk:$1.lda /lda" >> build.com
$cpu11_sim "@dk:build.com"
popd >/dev/null

srec_cat $cpu11_tmp/${1^^}.LDA -dec_binary -o $cpu11_tmp/$1.bin -binary

mkdir -p out
srec_cat $cpu11_tmp/$1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ./out/test.mem --VMem 16
srec_cat $cpu11_tmp/$1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ./out/test.hex -Intel
srec_cat $cpu11_tmp/$1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o ./out/test.mif -Memory_Initialization_File 16 -obs=2
mkdir -p ../../xen/tst
cp ./out/test.mif ../../xen/tst/vm1.mif
cp ./out/test.mem ../../xen/tst/vm1.mem

exit 0
