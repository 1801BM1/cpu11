@echo off
rem
rem Setup variables for temp directory and path to PDP-11 simulator
rem
rem set cpu11_tmp=R:\TEMP
rem set cpu11_sim=D:\ECC\PDP11
if "%~1"=="" goto blank
if "%cpu11_tmp%"=="" goto blank_tmp
if "%cpu11_sim%"=="" goto blank_sim

copy %1.mac %cpu11_tmp%\%1.mac >>NUL
echo macro hd2:%1.mac /list:hd2:%1.lst /object:hd2:%1.obj >%cpu11_tmp%\build.com
echo link hd2:%1.obj /execute:hd2:%1.lda /lda >>%cpu11_tmp%\build.com
%cpu11_sim%\pdp11.exe @hd2:build.com
srec_cat %cpu11_tmp%\%1.lda -dec_binary -offset -0173000 -o %cpu11_tmp%\%1.bin -binary
move vt52.log %cpu11_tmp%\vt52.log >>NUL

rem fc /b %cpu11_tmp%\%1.bin original\%1.bin > %cpu11_tmp%\%1.a
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x200 -byte-swap 2 -o %cpu11_tmp%\%1.mem --VMem 16
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x200 -byte-swap 2 -o %cpu11_tmp%\%1.hex -Intel
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x200 -byte-swap 2 -o %cpu11_tmp%\%1.mif -Memory_Initialization_File 16 -obs=2

rem srec_cat boot0.hex -Intel -offset 0x0000 -byte-swap 2 boot1.hex -Intel -offset 0x0200 -byte-swap 2 boot2.hex -Intel -offset 0x0400 -byte-swap 2 boot3.hex -Intel -offset 0x0600 -byte-swap 2 -o boot.hex -Intel -obs=16
@echo on
