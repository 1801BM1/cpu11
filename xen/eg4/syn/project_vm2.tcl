import_device eagle_s20.db -package BG256
open_project eg4.al
set_param flow message verbose
elaborate -top eg4
read_adc "eg4.adc"
optimize_rtl
report_area -file "eg4_rtl.area"
read_sdc "eg4.sdc"
export_db "eg4_rtl.db"
set_param gate report verbose
set_param gate opt_timing high
optimize_gate -packarea "eg4_gate.area"
legalize_phy_inst
read_sdc "eg4.sdc"
export_db "eg4_gate.db"
set_param place opt_timing high
place
set_param route opt_timing high
route
report_area -io_info -file "eg4_phy.area"
export_db "eg4_pr.db"
start_timer
report_timing -mode FINAL -net_info -ep_num 3 -path_num 3 -file "eg4_phy.timing"
bitgen -bit "eg4.bit" -version 0X00 -g ucode:00000000000001100000000000000000
