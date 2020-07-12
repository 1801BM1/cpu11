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

srec_cat %cpu11_tmp%\%1.lda -dec_binary -o %cpu11_tmp%\%1.bin -binary
move vt52.log %cpu11_tmp%\vt52.log >>NUL

if not exist .\out mkdir out
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o .\out\test.mem --VMem 16
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o .\out\test.hex -Intel
srec_cat %cpu11_tmp%\%1.bin -binary -fill 0x00 0x0000 0x4000 -byte-swap 2 -o .\out\test.mif -Memory_Initialization_File 16 -obs=2
if not exist ..\..\xen\tst mkdir ..\..\xen\tst
copy .\out\test.mif ..\..\xen\tst\lsi.mif >> NUL
copy .\out\test.mem ..\..\xen\tst\lsi.mem >> NUL

@echo on
exit

:blank
echo.
echo Batch file to compile and copy built images to project folders
echo PDP-11 Simulator and original MACRO-11 on RT-11 is used to compile
echo.
echo Environment variables should be set:
echo   cpu11_tmp=%cpu11_tmp%
echo   cpu11_sim=%cpu11_sim%
echo.
echo Usage: built filename_without_extension
echo Example: build t401
exit

:blank_tmp
echo.
echo Environment variable cpu11_tmp should be set to temorary folder
exit

:blank_tmp
echo.
echo Environment variable cpu11_sim should be set to RT11 simulator folder
exit
