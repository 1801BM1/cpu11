@echo off
if "%~1"=="" goto blank
if "%~1"=="all" goto all

call :proj %1
exit

:all
if exist .\vm1 call :proj vm1
if exist .\vm2 call :proj vm2
if exist .\vm3 call :proj vm3
if exist .\lsi call :proj lsi
if exist .\xen call :proj xen
exit

:proj
if exist .\%1\hdl\org\out			rd  .\%1\hdl\org\out /s /q
if exist .\%1\hdl\syn\out 			rd  .\%1\hdl\syn\out /s /q
if exist .\%1\hdl\wbc\out 			rd  .\%1\hdl\wbc\out /s /q
if exist .\%1\tst\out 				rd  .\%1\tst\out /s /q
if %1 equ xen	 				call :xenclr
if %1 equ xen					exit /b
      
call :aclean %1 org de0
call :aclean %1 syn de0
call :aclean %1 wbc de0

del *.qws *.sdo *.vo *.qip *.sft *.wlf *.jdi *.ver *.mem *.xrf *.bak msim_transcript. vm1_run_msim*.do modelsim.ini *.rpt /q /s

for /r "./%~1/hdl" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
exit /b

:aclean
if exist .\%1\hdl\%2\syn\%3\*.jdi 		del .\%1\hdl\%2\syn\%3\*.jdi /s /q
if exist .\%1\hdl\%2\syn\%3\db 			rd  .\%1\hdl\%2\syn\%3\db /s /q
if exist .\%1\hdl\%2\syn\%3\incremental_db 	rd  .\%1\hdl\%2\syn\%3\incremental_db /s /q
if exist .\%1\hdl\%2\syn\%3\greybox_tmp		rd  .\%1\hdl\%2\syn\%3\greybox_tmp /s /q
if not exist .\%1\hdl\%2\sim\%3\	 	exit /b
if exist .\%1\hdl\%2\sim\%3\rtl_work	 	rd  .\%1\hdl\%2\sim\%3\rtl_work /s /q
if exist .\%1\hdl\%2\sim\%3\*.mif		del .\%1\hdl\%2\sim\%3\*.mif /s /q
if exist .\%1\hdl\%2\sim\%3\*.hex		del .\%1\hdl\%2\sim\%3\*.hex /s /q
if exist .\%1\hdl\%2\sim\%3\*rtl_verilog.do	del .\%1\hdl\%2\sim\%3\*rtl_verilog.do /s /q
exit /b

:xclean
if exist .\%1\hdl\%2\syn\%3\work		rd  .\%1\hdl\%2\syn\%3\work /s /q
if exist .\%1\hdl\%2\syn\%3\iseconfig		rd  .\%1\hdl\%2\syn\%3\iseconfig /s /q
if exist .\%1\hdl\%2\syn\%3\ipcore_dir		rd  .\%1\hdl\%2\syn\%3\ipcore_dir /s /q
if exist .\%1\hdl\%2\syn\%3\%3_xdb		rd  .\%1\hdl\%2\syn\%3\%3_xdb /s /q
exit /b

:xenclr
if exist .\xen\tst				del .\xen\tst\*.* /s /q
del *.qws *.sdo *.vo *.qip *.sft *.wlf *.jdi *.ver *.mem *.xrf *.bak msim_transcript. vm1_run_msim*.do modelsim.ini *.rpt /q /s

for /r "./xen/lib" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
call :xen_aclean de0
call :xen_aclean de1
call :xen_aclean de2-115
call :xen_aclean de10-lite
call :xen_aclean qc5
call :xen_aclean qc10
call :xen_tclean eg4
exit /b

:xen_aclean
for /r "./xen/%~1/rtl" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
if exist .\xen\%1\syn\*.jdi 			del .\xen\%1\syn\*.jdi /s /q
if exist .\xen\%1\syn\out 			rd  .\xen\%1\syn\out /s /q
if exist .\xen\%1\syn\db 			rd  .\xen\%1\syn\db /s /q
if exist .\xen\%1\syn\incremental_db		rd  .\xen\%1\syn\incremental_db /s /q
if exist .\xen\%1\syn\greybox_tmp		rd  .\xen\%1\syn\greybox_tmp /s /q
if not exist .\xen\%1\sim\		 	exit /b
if exist .\xen\%1\sim\rtl_work	 		rd  .\xen\%1\sim\rtl_work /s /q
if exist .\xen\%1\sim\*.mif			del .\xen\%1\sim\*.mif /s /q
if exist .\xen\%1\sim\*.hex			del .\xen\%1\sim\*.hex /s /q
if exist .\xen\%1\sim\*rtl_verilog.do		del .\xen\%1\sim\*rtl_verilog.do /s /q
exit /b

:xen_xclean
for /r "./xen/%~1/rtl" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
if exist .\xen\%1\syn\work			rd  .\xen\%1\syn\work /s /q
if exist .\xen\%1\syn\iseconfig			rd  .\xen\%1\syn\iseconfig /s /q
if exist .\xen\%1\syn\ipcore_dir		rd  .\xen\%1\syn\ipcore_dir /s /q
if exist .\xen\%1\syn\%1_xdb			rd  .\xen\%1\syn\%1_xdb /s /q
exit /b

:xen_tclean
for /r "./xen/%~1/rtl" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
if exist .\xen\%1\syn\*.log 			del .\xen\%1\syn\*.log /s /q
if exist .\xen\%1\syn\*.bit 			del .\xen\%1\syn\*.bit /s /q
exit /b

:blank
echo.
echo Windows batch file to clean temporary and result files
echo.
echo Usage: clean project_name
echo Example: clean vm1 - clean only ./vm1 project folder
echo          clean all - clean all project folders
exit
