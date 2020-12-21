onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Clock /tb1/de0_top/cpu/cpu/vm_clk_p
add wave -noupdate -group Clock /tb1/de0_top/cpu/cpu/vm_clk_n
add wave -noupdate -group Clock /tb1/de0_top/cpu/cpu/vm_clk_ena
add wave -noupdate -group Clock /tb1/de0_top/cpu/cpu/vm_clk_slow
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_dclo
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_aclo
add wave -noupdate -group Reset -radix octal /tb1/de0_top/cpu/cpu/vm_bsel
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_init
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_evnt
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_halt
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/vm_virq
add wave -noupdate -group {WB Master } -radix octal /tb1/de0_top/cpu/cpu/wbm_adr_o
add wave -noupdate -group {WB Master } -radix octal /tb1/de0_top/cpu/cpu/wbm_dat_o
add wave -noupdate -group {WB Master } -radix octal /tb1/de0_top/cpu/cpu/wbm_dat_i
add wave -noupdate -group {WB Master } /tb1/de0_top/cpu/cpu/wbm_cyc_o
add wave -noupdate -group {WB Master } /tb1/de0_top/cpu/cpu/wbm_stb_o
add wave -noupdate -group {WB Master } /tb1/de0_top/cpu/cpu/wbm_ack_i
add wave -noupdate -group {WB Master } -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/wbm_sel_o[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/wbm_sel_o[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/wbm_sel_o[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/wbm_sel_o[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/wbm_sel_o
add wave -noupdate -group {WB Master } /tb1/de0_top/cpu/cpu/wbm_we_o
add wave -noupdate -group {WB Master } /tb1/de0_top/cpu/cpu/wbm_gnt_i
add wave -noupdate -group {WB Master } -group {WBM internals} /tb1/de0_top/cpu/cpu/wbm_cont
add wave -noupdate -group {WB Master } -group {WBM internals} /tb1/de0_top/cpu/cpu/wb_rdone
add wave -noupdate -group {WB Master } -group {WBM internals} /tb1/de0_top/cpu/cpu/wb_wdone
add wave -noupdate -group {WB Master } -group {WBM internals} /tb1/de0_top/cpu/cpu/wb_wset
add wave -noupdate -group {WB Master } -group {WBM internals} /tb1/de0_top/cpu/cpu/wb_wclr
add wave -noupdate -group {WB Master } -group {WBM internals} -radix octal /tb1/de0_top/cpu/cpu/wb_wcnt
add wave -noupdate -group {WB Master } -group {WBM internals} -radix octal /tb1/de0_top/cpu/cpu/dreg_i
add wave -noupdate -group {WB Master } -group {WBM internals} -radix octal /tb1/de0_top/cpu/cpu/dreg_o
add wave -noupdate -group {WB Master } -group {WBM internals} -radix octal /tb1/de0_top/cpu/cpu/areg
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_rdy
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_wtbt
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_sync
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_din
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_dout
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_iako
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/io_wait
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/ior_stb
add wave -noupdate -group {IO requests} /tb1/de0_top/cpu/cpu/iow_stb
add wave -noupdate -group Sequencer -radix hexadecimal /tb1/de0_top/cpu/cpu/ma
add wave -noupdate -group Sequencer -radix hexadecimal /tb1/de0_top/cpu/cpu/mcr
add wave -noupdate -group Sequencer -radix octal /tb1/de0_top/cpu/cpu/seq/ora
add wave -noupdate -group Sequencer -radix hexadecimal /tb1/de0_top/cpu/cpu/seq/pc
add wave -noupdate -group Sequencer -radix hexadecimal /tb1/de0_top/cpu/cpu/seq/sp
add wave -noupdate -group Sequencer -radix hexadecimal /tb1/de0_top/cpu/cpu/seq/stk
add wave -noupdate -group Sequencer /tb1/de0_top/cpu/cpu/seq/tst
add wave -noupdate -group ALU -radix octal /tb1/de0_top/cpu/cpu/alu/q_reg
add wave -noupdate -group ALU -group Registers -label R15 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[15]}
add wave -noupdate -group ALU -group Registers -label R14 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[14]}
add wave -noupdate -group ALU -group Registers -label R13 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[13]}
add wave -noupdate -group ALU -group Registers -label R12 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[12]}
add wave -noupdate -group ALU -group Registers -label R11 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[11]}
add wave -noupdate -group ALU -group Registers -label R10 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[10]}
add wave -noupdate -group ALU -group Registers -label R9 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[9]}
add wave -noupdate -group ALU -group Registers -label R8 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[8]}
add wave -noupdate -group ALU -group Registers -label R7 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[7]}
add wave -noupdate -group ALU -group Registers -label R6 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[6]}
add wave -noupdate -group ALU -group Registers -label R5 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[5]}
add wave -noupdate -group ALU -group Registers -label R4 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[4]}
add wave -noupdate -group ALU -group Registers -label R3 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[3]}
add wave -noupdate -group ALU -group Registers -label R2 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[2]}
add wave -noupdate -group ALU -group Registers -label R1 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[1]}
add wave -noupdate -group ALU -group Registers -label R0 -radix octal {/tb1/de0_top/cpu/cpu/alu/q_ram[0]}
add wave -noupdate -group ALU -radix octal /tb1/de0_top/cpu/cpu/psw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {109920000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {183809024 ps}
