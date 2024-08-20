#!/bin/bash -e
if [ $# -eq 0 ] ; then
    echo "Usage: $0 cpu_model" >&2
    exit 1
fi

tcl_fn=$(mktemp /tmp/build-XXXXX.tcl)
function onexit()
{
    [ -e "$tcl_fn" ] && rm -f "$tcl_fn"
}
trap onexit EXIT

CPUID=$1
XPR="qa7-$CPUID/qa7-$CPUID.xpr"
if [ ! -e "$XPR" ] ; then
    vivado -mode batch -source qa7-$CPUID.tcl
fi
cat <<EOF >$tcl_fn
#-----------------------------------------------------------
# Vivado v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Start of session at: Sat Jan  9 20:55:55 2021
# Process ID: 21884
# Current directory: /opt/xilinx/workspace/cpu11/xen/qa7/syn
# Command line: vivado
# Log file: /opt/xilinx/workspace/cpu11/xen/qa7/syn/vivado.log
# Journal file: /opt/xilinx/workspace/cpu11/xen/qa7/syn/vivado.jou
#-----------------------------------------------------------
# start_gui
open_project /opt/xilinx/workspace/cpu11/xen/qa7/qa7-$CPUID/qa7-$CPUID.xpr
update_compile_order -fileset sources_1
reset_run synth_2
launch_runs synth_2 -jobs 4
wait_on_run synth_2
launch_runs impl_3 -jobs 4
wait_on_run impl_3
launch_runs impl_3 -to_step write_bitstream -jobs 4
wait_on_run impl_3
#-- don't program bitstream yet
close_project
#---
# open_hw
# connect_hw_server
# connect_hw_server
# open_hw_target
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# current_hw_device [get_hw_devices xc7a35t_0]
# refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a35t_0] 0]
# create_hw_cfgmem -hw_device [get_hw_devices xc7a35t_0] -mem_dev [lindex [get_cfgmem_parts {n25q64-1.8v-spi-x1_x2_x4}] 0]
# set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# program_hw_devices [get_hw_devices xc7a35t_0]
# refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
# set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# program_hw_devices [get_hw_devices xc7a35t_0]
# refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
# set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# program_hw_devices [get_hw_devices xc7a35t_0]
# refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
# set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# program_hw_devices [get_hw_devices xc7a35t_0]
# refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
# set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
# set_property PROGRAM.FILE {/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.runs/impl_3/qa7_top.bit} [get_hw_devices xc7a35t_0]
# program_hw_devices [get_hw_devices xc7a35t_0]
# refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
# close_project
EOF
time vivado -mode batch -source $tcl_fn
