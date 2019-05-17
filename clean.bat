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
exit

:proj
if exist .\%1\hdl\org\out			rd  .\%1\hdl\org\out /s /q
if exist .\%1\hdl\syn\out 			rd  .\%1\hdl\syn\out /s /q
if exist .\%1\hdl\wbc\out 			rd  .\%1\hdl\wbc\out /s /q
if exist .\%1\tst\out 				rd  .\%1\tst\out /s /q
      
call :aclean %1 org de0
call :aclean %1 syn de0
call :aclean %1 wbc de0
call :aclean %1 wbc de1
call :aclean %1 wbc de2-115
call :xclean %1 wbc ax309

del *.qws *.sdo *.vo *.qip *.sft *.wlf *.jdi *.ver *.mem *.xrf *.bak msim_transcript. vm1_run_msim*.do modelsim.ini *.rpt /q /s

for /r "./%~1/hdl" %%9 in (*.v) do atxt32 %%9 %%9 -s3 -f
exit /b

:aclean
if exist .\%1\hdl\%2\syn\%3\*.jdi 		rd  .\%1\hdl\%2\syn\%3\*.jdi /s /q
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

:blank
echo.
echo Windows batch file to clean temporary and result files
echo.
echo Usage: clean project_name
echo Example: clean vm1 - clean only ./vm1 project folder
echo          clean all - clean all project folders
exit
