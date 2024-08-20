#*****************************************************************************************
# Vivado (TM) v2018.3 (64-bit)
#
# qa7.tcl: Tcl script for re-creating project 'qa7'
#
# Generated by Vivado on Fri Jan 08 17:43:51 EET 2021
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
#
# This file contains the Vivado Tcl commands for re-creating the project to the state*
# when this script was generated. In order to re-create the project, please source this
# file in the Vivado Tcl Shell.
#
# * Note that the runs in the created project will be configured the same way as the
#   original project, however they will not be launched automatically. To regenerate the
#   run results please launch the synthesis/implementation runs as needed.
#
#*****************************************************************************************
# NOTE: In order to use this script for source control purposes, please make sure that the
#       following files are added to the source control system:-
#
# 1. This project restoration tcl script (qa7.tcl) that was generated.
#
# 2. The following source(s) files that were local or imported into the original project.
#    (Please see the '$orig_proj_dir' and '$origin_dir' variable setting below at the start of the script)
#
#    "/opt/xilinx/workspace/cpu11/xen/qa7/syn/vm1_xlib.coe"
#    "/opt/xilinx/workspace/cpu11/xen/qa7/syn/ip/xvcram/xvcram.xci"
#    "/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.xdc"
#    "/opt/xilinx/workspace/cpu11/xen/qa7/syn/qa7.srcs/constrs_1/new/qa7_dbg.xdc"
#
# 3. The following remote source files that were added to the original project:-
#
#    "/opt/xilinx/workspace/cpu11/xen/lib/config.v"
#    "/opt/xilinx/workspace/cpu11/xen/qa7/rtl/qa7_xlib.v"
#    "/opt/xilinx/workspace/cpu11/xen/lib/wbc_rst.v"
#    "/opt/xilinx/workspace/cpu11/xen/lib/wbc_uart.v"
#    "/opt/xilinx/workspace/cpu11/xen/lib/wbc_vic.v"
#    "/opt/xilinx/workspace/cpu11/xen/qa7/rtl/qa7_top.v"
#    "/opt/xilinx/workspace/cpu11/xen/tst/f11.mem"
#
#*****************************************************************************************

# Set the reference directory for source file relative paths (by default the value is script directory path)
set origin_dir "."

# Use origin directory path location variable, if specified in the tcl shell
if { [info exists ::origin_dir_loc] } {
  set origin_dir $::origin_dir_loc
}

# Set the project name
set _xil_proj_name_ "qa7-f11"

# Use project name variable, if specified in the tcl shell
if { [info exists ::user_project_name] } {
  set _xil_proj_name_ $::user_project_name
}

variable script_file
set script_file "qa7-f11.tcl"

# Help information for this script
proc print_help {} {
  variable script_file
  puts "\nDescription:"
  puts "Recreate a Vivado project from this script. The created project will be"
  puts "functionally equivalent to the original project for which this script was"
  puts "generated. The script contains commands for creating a project, filesets,"
  puts "runs, adding/importing sources and setting properties on various objects.\n"
  puts "Syntax:"
  puts "$script_file"
  puts "$script_file -tclargs \[--origin_dir <path>\]"
  puts "$script_file -tclargs \[--project_name <name>\]"
  puts "$script_file -tclargs \[--help\]\n"
  puts "Usage:"
  puts "Name                   Description"
  puts "-------------------------------------------------------------------------"
  puts "\[--origin_dir <path>\]  Determine source file paths wrt this path. Default"
  puts "                       origin_dir path value is \".\", otherwise, the value"
  puts "                       that was set with the \"-paths_relative_to\" switch"
  puts "                       when this script was generated.\n"
  puts "\[--project_name <name>\] Create project with the specified name. Default"
  puts "                       name is the name of the project from where this"
  puts "                       script was generated.\n"
  puts "\[--help\]               Print help information for this script"
  puts "-------------------------------------------------------------------------\n"
  exit 0
}

if { $::argc > 0 } {
  for {set i 0} {$i < $::argc} {incr i} {
    set option [string trim [lindex $::argv $i]]
    switch -regexp -- $option {
      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }
      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }
      "--help"         { print_help }
      default {
        if { [regexp {^-} $option] } {
          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"
          return 1
        }
      }
    }
  }
}

# Set the directory path for the original project from where this script was exported
set orig_proj_dir "[file normalize "$origin_dir/syn"]"

# Create project
create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part xc7a35tftg256-1 -force

# Set the directory path for the new project
set proj_dir [get_property directory [current_project]]

# Set project properties
set obj [current_project]
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "dsa.accelerator_binary_content" -value "bitstream" -objects $obj
set_property -name "dsa.accelerator_binary_format" -value "xclbin2" -objects $obj
set_property -name "dsa.description" -value "Vivado generated DSA" -objects $obj
set_property -name "dsa.dr_bd_base_address" -value "0" -objects $obj
set_property -name "dsa.emu_dir" -value "emu" -objects $obj
set_property -name "dsa.flash_interface_type" -value "bpix16" -objects $obj
set_property -name "dsa.flash_offset_address" -value "0" -objects $obj
set_property -name "dsa.flash_size" -value "1024" -objects $obj
set_property -name "dsa.host_architecture" -value "x86_64" -objects $obj
set_property -name "dsa.host_interface" -value "pcie" -objects $obj
set_property -name "dsa.num_compute_units" -value "60" -objects $obj
set_property -name "dsa.platform_state" -value "pre_synth" -objects $obj
set_property -name "dsa.vendor" -value "xilinx" -objects $obj
set_property -name "dsa.version" -value "0.0" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xc7a35tftg256-1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj
set_property -name "webtalk.activehdl_export_sim" -value "62" -objects $obj
set_property -name "webtalk.ies_export_sim" -value "62" -objects $obj
set_property -name "webtalk.modelsim_export_sim" -value "62" -objects $obj
set_property -name "webtalk.questa_export_sim" -value "62" -objects $obj
set_property -name "webtalk.riviera_export_sim" -value "62" -objects $obj
set_property -name "webtalk.vcs_export_sim" -value "62" -objects $obj
set_property -name "webtalk.xsim_export_sim" -value "62" -objects $obj

# Create 'sources_1' fileset (if not found)
if {[string equal [get_filesets -quiet sources_1] ""]} {
  create_fileset -srcset sources_1
}

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
set files [list \
 [file normalize "${origin_dir}/../lib/config.v"] \
 [file normalize "${origin_dir}/rtl/qa7_xlib.v"] \
 [file normalize "${origin_dir}/../lib/wbc_rst.v"] \
 [file normalize "${origin_dir}/../lib/wbc_uart.v"] \
 [file normalize "${origin_dir}/../lib/wbc_vic.v"] \
 [file normalize "${origin_dir}/rtl/qa7_top.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_302.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_303.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_304.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_fpp.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_pla.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_pla_0.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_pla_1.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_pla_2.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_rom.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/dc_mmu.v"] \
 [file normalize "${origin_dir}/../../f11/hdl/wbc/rtl/f11_wb.v"] \
 [file normalize "${origin_dir}/../lib/wbc_f11.v"] \
 [file normalize "${origin_dir}/../tst/f11.mem"] \
]
add_files -norecurse -fileset $obj $files

set file "$origin_dir/../tst/f11.mem"
set file [file normalize $file]
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "file_type" -value "Memory File" -objects $file_obj

# Set 'sources_1' fileset file properties for local files
# None

# Set 'sources_1' fileset properties
set obj [get_filesets sources_1]
set_property -name "top" -value "qa7_top" -objects $obj
set_property -name "verilog_define" -value \
    "CONFIG_WBC_CPU=wbc_f11" \
    -objects $obj

# Set 'sources_1' fileset object
set obj [get_filesets sources_1]
# Import local files from the original project
set files [list \
 [file normalize "${origin_dir}/syn/ip/xvcram/xvcram.xci" ]\
]
set imported_files [import_files -fileset sources_1 $files]

# Set 'sources_1' fileset file properties for remote files
# None

# Set 'sources_1' fileset file properties for local files
set file "xvcram/xvcram.xci"
set file_obj [get_files -of_objects [get_filesets sources_1] [list "*$file"]]
set_property -name "generate_files_for_reference" -value "0" -objects $file_obj
set_property -name "registered_with_manager" -value "1" -objects $file_obj
if { ![get_property "is_locked" $file_obj] } {
  set_property -name "synth_checkpoint_mode" -value "Singular" -objects $file_obj
}


# Create 'constrs_1' fileset (if not found)
if {[string equal [get_filesets -quiet constrs_1] ""]} {
  create_fileset -constrset constrs_1
}

# Set 'constrs_1' fileset object
set obj [get_filesets constrs_1]

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/syn/qa7.xdc"]"
set file_imported [import_files -fileset constrs_1 [list $file]]
set file "syn/qa7.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Add/Import constrs file and set constrs file properties
set file "[file normalize "$origin_dir/syn/qa7.srcs/constrs_1/new/qa7_dbg.xdc"]"
set file_imported [import_files -fileset constrs_1 [list $file]]
set file "new/qa7_dbg.xdc"
set file_obj [get_files -of_objects [get_filesets constrs_1] [list "*$file"]]
set_property -name "file_type" -value "XDC" -objects $file_obj

# Set 'constrs_1' fileset properties
set obj [get_filesets constrs_1]
set_property -name "target_constrs_file" -value "[get_files *new/qa7_dbg.xdc]" -objects $obj
set_property -name "target_part" -value "xc7a35tftg256-1" -objects $obj
set_property -name "target_ucf" -value "[get_files *new/qa7_dbg.xdc]" -objects $obj

# Create 'sim_1' fileset (if not found)
if {[string equal [get_filesets -quiet sim_1] ""]} {
  create_fileset -simset sim_1
}

# Set 'sim_1' fileset object
set obj [get_filesets sim_1]
# Empty (no sources present)

# Set 'sim_1' fileset properties
set obj [get_filesets sim_1]
set_property -name "top" -value "qa7_top" -objects $obj
set_property -name "top_lib" -value "xil_defaultlib" -objects $obj

# Set 'utils_1' fileset object
set obj [get_filesets utils_1]
# Empty (no sources present)

# Set 'utils_1' fileset properties
set obj [get_filesets utils_1]

# Create 'synth_2' run (if not found)
if {[string equal [get_runs -quiet synth_2] ""]} {
    create_run -name synth_2 -part xc7a35tftg256-1 -flow {Vivado Synthesis 2018} -strategy "Vivado Synthesis Defaults" -report_strategy {No Reports} -constrset constrs_1
} else {
  set_property strategy "Vivado Synthesis Defaults" [get_runs synth_2]
  set_property flow "Vivado Synthesis 2018" [get_runs synth_2]
}
set obj [get_runs synth_2]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Synthesis Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'synth_2_synth_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs synth_2] synth_2_synth_report_utilization_0] "" ] } {
  create_report_config -report_name synth_2_synth_report_utilization_0 -report_type report_utilization:1.0 -steps synth_design -runs synth_2
}
set obj [get_report_configs -of_objects [get_runs synth_2] synth_2_synth_report_utilization_0]
if { $obj != "" } {
set_property -name "display_name" -value "synth_2_synth_report_utilization_0" -objects $obj

}
set obj [get_runs synth_2]
set_property -name "part" -value "xc7a35tftg256-1" -objects $obj
set_property -name "strategy" -value "Vivado Synthesis Defaults" -objects $obj

# set the current synth run
current_run -synthesis [get_runs synth_2]

# Create 'impl_3' run (if not found)
if {[string equal [get_runs -quiet impl_3] ""]} {
    create_run -name impl_3 -part xc7a35tftg256-1 -flow {Vivado Implementation 2018} -strategy "Vivado Implementation Defaults" -report_strategy {No Reports} -constrset constrs_1 -parent_run synth_2
} else {
  set_property strategy "Vivado Implementation Defaults" [get_runs impl_3]
  set_property flow "Vivado Implementation 2018" [get_runs impl_3]
}
set obj [get_runs impl_3]
set_property set_report_strategy_name 1 $obj
set_property report_strategy {Vivado Implementation Default Reports} $obj
set_property set_report_strategy_name 0 $obj
# Create 'impl_3_init_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_init_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_init_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps init_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_init_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_init_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_opt_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_opt_report_drc_0] "" ] } {
  create_report_config -report_name impl_3_opt_report_drc_0 -report_type report_drc:1.0 -steps opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_opt_report_drc_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_opt_report_drc_0" -objects $obj

}
# Create 'impl_3_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_opt_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps power_opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_power_opt_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_place_report_io_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_io_0] "" ] } {
  create_report_config -report_name impl_3_place_report_io_0 -report_type report_io:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_io_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_place_report_io_0" -objects $obj

}
# Create 'impl_3_place_report_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_utilization_0] "" ] } {
  create_report_config -report_name impl_3_place_report_utilization_0 -report_type report_utilization:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_utilization_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_place_report_utilization_0" -objects $obj

}
# Create 'impl_3_place_report_control_sets_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_control_sets_0] "" ] } {
  create_report_config -report_name impl_3_place_report_control_sets_0 -report_type report_control_sets:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_control_sets_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_place_report_control_sets_0" -objects $obj

}
# Create 'impl_3_place_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_3_place_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_place_report_incremental_reuse_0" -objects $obj

}
# Create 'impl_3_place_report_incremental_reuse_1' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_incremental_reuse_1] "" ] } {
  create_report_config -report_name impl_3_place_report_incremental_reuse_1 -report_type report_incremental_reuse:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_incremental_reuse_1]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_place_report_incremental_reuse_1" -objects $obj

}
# Create 'impl_3_place_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_place_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps place_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_place_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_place_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_post_place_power_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_post_place_power_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_post_place_power_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_place_power_opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_post_place_power_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_post_place_power_opt_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps phys_opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "is_enabled" -value "0" -objects $obj
set_property -name "display_name" -value "impl_3_phys_opt_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_route_report_drc_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_drc_0] "" ] } {
  create_report_config -report_name impl_3_route_report_drc_0 -report_type report_drc:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_drc_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_drc_0" -objects $obj

}
# Create 'impl_3_route_report_methodology_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_methodology_0] "" ] } {
  create_report_config -report_name impl_3_route_report_methodology_0 -report_type report_methodology:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_methodology_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_methodology_0" -objects $obj

}
# Create 'impl_3_route_report_power_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_power_0] "" ] } {
  create_report_config -report_name impl_3_route_report_power_0 -report_type report_power:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_power_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_power_0" -objects $obj

}
# Create 'impl_3_route_report_route_status_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_route_status_0] "" ] } {
  create_report_config -report_name impl_3_route_report_route_status_0 -report_type report_route_status:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_route_status_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_route_status_0" -objects $obj

}
# Create 'impl_3_route_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_route_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_timing_summary_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_route_report_incremental_reuse_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_incremental_reuse_0] "" ] } {
  create_report_config -report_name impl_3_route_report_incremental_reuse_0 -report_type report_incremental_reuse:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_incremental_reuse_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_incremental_reuse_0" -objects $obj

}
# Create 'impl_3_route_report_clock_utilization_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_clock_utilization_0] "" ] } {
  create_report_config -report_name impl_3_route_report_clock_utilization_0 -report_type report_clock_utilization:1.0 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_clock_utilization_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_clock_utilization_0" -objects $obj

}
# Create 'impl_3_route_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_3_route_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps route_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_route_report_bus_skew_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_route_report_bus_skew_0" -objects $obj

}
# Create 'impl_3_post_route_phys_opt_report_timing_summary_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_post_route_phys_opt_report_timing_summary_0] "" ] } {
  create_report_config -report_name impl_3_post_route_phys_opt_report_timing_summary_0 -report_type report_timing_summary:1.0 -steps post_route_phys_opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_post_route_phys_opt_report_timing_summary_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_post_route_phys_opt_report_timing_summary_0" -objects $obj

}
# Create 'impl_3_post_route_phys_opt_report_bus_skew_0' report (if not found)
if { [ string equal [get_report_configs -of_objects [get_runs impl_3] impl_3_post_route_phys_opt_report_bus_skew_0] "" ] } {
  create_report_config -report_name impl_3_post_route_phys_opt_report_bus_skew_0 -report_type report_bus_skew:1.1 -steps post_route_phys_opt_design -runs impl_3
}
set obj [get_report_configs -of_objects [get_runs impl_3] impl_3_post_route_phys_opt_report_bus_skew_0]
if { $obj != "" } {
set_property -name "display_name" -value "impl_3_post_route_phys_opt_report_bus_skew_0" -objects $obj

}
set obj [get_runs impl_3]
set_property -name "part" -value "xc7a35tftg256-1" -objects $obj
set_property -name "strategy" -value "Vivado Implementation Defaults" -objects $obj
set_property -name "steps.write_bitstream.args.readback_file" -value "0" -objects $obj
set_property -name "steps.write_bitstream.args.verbose" -value "0" -objects $obj

# set the current impl run
current_run -implementation [get_runs impl_3]

puts "INFO: Project created:${_xil_proj_name_}"
set obj [get_dashboards default_dashboard]

# Create 'drc_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "drc_1" ] ] ""]} {
create_dashboard_gadget -name {drc_1} -type drc
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "drc_1" ] ]

# Create 'methodology_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "methodology_1" ] ] ""]} {
create_dashboard_gadget -name {methodology_1} -type methodology
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "methodology_1" ] ]

# Create 'power_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "power_1" ] ] ""]} {
create_dashboard_gadget -name {power_1} -type power
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "power_1" ] ]

# Create 'timing_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "timing_1" ] ] ""]} {
create_dashboard_gadget -name {timing_1} -type timing
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "timing_1" ] ]

# Create 'utilization_1' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "utilization_1" ] ] ""]} {
create_dashboard_gadget -name {utilization_1} -type utilization
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "utilization_1" ] ]
set_property -name "run.step" -value "synth_design" -objects $obj
set_property -name "run.type" -value "synthesis" -objects $obj

# Create 'utilization_2' gadget (if not found)
if {[string equal [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "utilization_2" ] ] ""]} {
create_dashboard_gadget -name {utilization_2} -type utilization
}
set obj [get_dashboard_gadgets -of_objects [get_dashboards default_dashboard] [ list "utilization_2" ] ]

move_dashboard_gadget -name {utilization_1} -row 0 -col 0
move_dashboard_gadget -name {power_1} -row 1 -col 0
move_dashboard_gadget -name {drc_1} -row 2 -col 0
move_dashboard_gadget -name {timing_1} -row 0 -col 1
move_dashboard_gadget -name {utilization_2} -row 1 -col 1
move_dashboard_gadget -name {methodology_1} -row 2 -col 1
# Set current dashboard to 'default_dashboard' 
current_dashboard default_dashboard 
