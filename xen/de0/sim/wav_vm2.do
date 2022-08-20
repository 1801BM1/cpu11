onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_gnt_i
add wave -noupdate -group {WB master} -radix octal /tb1/de0_top/cpu/cpu/wbm_adr_o
add wave -noupdate -group {WB master} -radix octal /tb1/de0_top/cpu/cpu/wbm_dat_i
add wave -noupdate -group {WB master} -radix octal /tb1/de0_top/cpu/cpu/wbm_dat_o
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_sel_o
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_cyc_o
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_stb_o
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_ack_i
add wave -noupdate -group {WB master} /tb1/de0_top/cpu/cpu/wbm_we_o
add wave -noupdate -group {WB Interrupt} -radix octal /tb1/de0_top/cpu/cpu/wbi_dat_i
add wave -noupdate -group {WB Interrupt} /tb1/de0_top/cpu/cpu/wbi_ack_i
add wave -noupdate -group {WB Interrupt} /tb1/de0_top/cpu/cpu/wbi_stb_o
add wave -noupdate -group {WB Interrupt} /tb1/de0_top/cpu/cpu/wbi_una_o
add wave -noupdate -group Pins /tb1/de0_top/cpu/cpu/vm_clk_p
add wave -noupdate -group Pins -group Clocks /tb1/de0_top/cpu/cpu/vm_clk_n
add wave -noupdate -group Pins -group Clocks /tb1/de0_top/cpu/cpu/vm_clk_slow
add wave -noupdate -group Pins -group Clocks /tb1/de0_top/cpu/cpu/vm_clk_ena
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_dclo
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_aclo
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_evnt
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_halt
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_init
add wave -noupdate -group Pins -expand -group Intarrupts /tb1/de0_top/cpu/cpu/vm_virq
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wb_start
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wio_ia
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wio_rd
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wio_ua
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wio_wo
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wio_wr
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wb_idone
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wb_rdone
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wb_done
add wave -noupdate -group {WB Internals} /tb1/de0_top/cpu/cpu/wb_wdone
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/reset
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/abort
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/mc_res
add wave -noupdate -group Reset /tb1/de0_top/cpu/cpu/tout
add wave -noupdate -group Reset -group aclo /tb1/de0_top/cpu/cpu/aclo_ack
add wave -noupdate -group Reset -group aclo /tb1/de0_top/cpu/cpu/aclo_fall
add wave -noupdate -group Reset -group aclo /tb1/de0_top/cpu/cpu/aclo_rise
add wave -noupdate -group Reset -group aclo /tb1/de0_top/cpu/cpu/ac0
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/aclo_fall
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/aclo_rise
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/halt
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/virq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/tovf
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/tovf_ack
add wave -noupdate -group Interrupt -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/pli[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/pli[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/pli[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pli[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/pli
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/pli_nrdy
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/pli_req
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/pli_ack
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/vec_stb
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/aclo_rq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/acok_rq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/evnt_rq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/tout_rq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/dble_rq
add wave -noupdate -group Interrupt /tb1/de0_top/cpu/cpu/vsel
add wave -noupdate -group Timer -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/qtim[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/qtim[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/qtim[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qtim[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/qtim
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tout
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tena
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/thang
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tevent
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/to_rply
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tovf
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/word27
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/init_out
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/dble_cnt0
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/dble_cnt1
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tend
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tabort
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tim_nrdy0
add wave -noupdate -group Timer /tb1/de0_top/cpu/cpu/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/abort
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/all_rdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/alu_nrdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/sta_nrdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/cmd_nrdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/pli_nrdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/io_rdy
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/tim_nrdy0
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/brd_wq
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/mc_drdy0
add wave -noupdate -group PLM -group Ready /tb1/de0_top/cpu/cpu/mc_drdy1
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/rta_fall
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/iop_stb
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/mc_stb
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/wra
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/na[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/na[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/na[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/na[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/na[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/na[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/na[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/na[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/na[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/na[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/na[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/na[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/na
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ia[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/ia[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/ia[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/ia[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ia[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ia[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ia[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ia[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ia[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ia[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ia[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ia[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ia
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/pla[36]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[35]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[34]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[33]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[32]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[31]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[30]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[29]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[28]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[27]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[26]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[25]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[24]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[23]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[22]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[21]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[20]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[19]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[18]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[17]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[16]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/pla[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/pla[36]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[35]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[34]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[33]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[32]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[31]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[30]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[29]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[28]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[27]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[26]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[25]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[24]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[23]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[22]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[21]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[20]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[19]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[18]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[17]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[16]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pla[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/pla
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/plm[30]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[29]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[28]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[27]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[26]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[25]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[24]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[23]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[22]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[21]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[20]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[19]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[18]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[17]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[16]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/plm[30]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[29]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[28]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[27]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[26]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[25]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[24]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[23]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[22]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[21]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[20]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[19]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[18]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[17]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[16]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/plm
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/plm_wt[30]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[29]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[28]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[27]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[26]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[25]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[24]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[23]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[22]} -radix octal} {{/tb1/de0_top/cpu/cpu/plm_wt[21]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/plm_wt[30]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[29]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[28]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[27]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[26]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[25]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[24]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[23]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[22]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/plm_wt[21]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/plm_wt
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm13m
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm14m
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm18m
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm19m
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm1m
add wave -noupdate -group PLM -group plxNm /tb1/de0_top/cpu/cpu/plm20m
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[21]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb1/de0_top/cpu/cpu/plr[21]}
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/bra
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_aux
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_b7
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_bi
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_f2
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_fb
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_fl
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_i7
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_j7
add wave -noupdate -group PLM -group dc /tb1/de0_top/cpu/cpu/dc_rtt
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/plb
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/pld[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/pld[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/pld[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/pld[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/pld
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/ix
add wave -noupdate -group PLM -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ri[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ri[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ri[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ri[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ri[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ri[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ri
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/wr1
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/pi_stb_rc
add wave -noupdate -group PLM /tb1/de0_top/cpu/cpu/pi_stb
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/alu_st
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/ea_rdy
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/io_rdy
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/mc_drdy0
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/mc_drdy1
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/ra_fr
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/ra_fr1
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/ra_fw
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/ra_fwn
add wave -noupdate -group State /tb1/de0_top/cpu/cpu/rta_fall
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/iocmd_st
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/bra_req
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/cmd_nrdy
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/set_cend
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/ir_stb
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/bir_stb
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/iop_stb
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/mc_stb
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/buf_res
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/wra
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/io_rcd
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/io_cmd
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/br_cmdrq
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/br_iocmd
add wave -noupdate -group Ircmd /tb1/de0_top/cpu/cpu/br_ready
add wave -noupdate -group IOB -group BUS /tb1/de0_top/cpu/cpu/adr_req
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/wr1
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/alu_wr
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/io_start
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/iop_stb
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_cmd
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_cmdr
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_in
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_wr
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_rd
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_iak
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_sel
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_rcd
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_rcd1
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_rcdr
add wave -noupdate -group IOB -group io /tb1/de0_top/cpu/cpu/io_pswr
add wave -noupdate -group IOB -group iop /tb1/de0_top/cpu/cpu/iop_una
add wave -noupdate -group IOB -group iop /tb1/de0_top/cpu/cpu/rdat
add wave -noupdate -group IOB -group iop /tb1/de0_top/cpu/cpu/iop_in
add wave -noupdate -group IOB -group iop /tb1/de0_top/cpu/cpu/iop_rcd
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/io_st
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/iopc_st
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/drdy
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/brd_wq
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/brd_wa
add wave -noupdate -group IOB /tb1/de0_top/cpu/cpu/alu_wr
add wave -noupdate -group IOB -group TOCLR /tb1/de0_top/cpu/cpu/iop_rcd
add wave -noupdate -group IOB -group TOCLR /tb1/de0_top/cpu/cpu/word27
add wave -noupdate -group IOB -group TOCLR /tb1/de0_top/cpu/cpu/sd_word
add wave -noupdate -group IOB -group TOCLR /tb1/de0_top/cpu/cpu/to_block
add wave -noupdate -group IOB -group TOCLR /tb1/de0_top/cpu/cpu/to_rply
add wave -noupdate -group Registers /tb1/de0_top/cpu/cpu/axy_wh
add wave -noupdate -group Registers -expand -group qreg -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/qreg[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/qreg[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/qreg[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/qreg[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/qreg
add wave -noupdate -group Registers -expand -group qreg /tb1/de0_top/cpu/cpu/brd_wa
add wave -noupdate -group Registers -expand -group qreg /tb1/de0_top/cpu/cpu/brd_wq
add wave -noupdate -group Registers -expand -group areg -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/areg[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/areg[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/areg[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/areg[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/areg
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/ra_wa
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/ra_wx
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/wra
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/acmp_en
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/wr1
add wave -noupdate -group Registers -expand -group areg /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group Registers -group acc -radix octal /tb1/de0_top/cpu/cpu/acc
add wave -noupdate -group Registers -group acc /tb1/de0_top/cpu/cpu/acc_wa
add wave -noupdate -group Registers -group acc /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group Registers -group sreg -radix octal /tb1/de0_top/cpu/cpu/sreg
add wave -noupdate -group Registers -group sreg /tb1/de0_top/cpu/cpu/rs_wa
add wave -noupdate -group Registers -group sreg -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/breg[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/breg[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/breg[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/breg[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/breg
add wave -noupdate -group Registers -group ireg -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ireg[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ireg[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ireg[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ireg[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ireg
add wave -noupdate -group Registers -group ireg /tb1/de0_top/cpu/cpu/ir_stb
add wave -noupdate -group Registers -group ireg -radix octal /tb1/de0_top/cpu/cpu/breg
add wave -noupdate -group Registers -group ireg /tb1/de0_top/cpu/cpu/bir_stb
add wave -noupdate -group Registers -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/r[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/r[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/r[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/r[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/r
add wave -noupdate -group Registers -group pc /tb1/de0_top/cpu/cpu/pc_wax
add wave -noupdate -group Registers -group pc /tb1/de0_top/cpu/cpu/pc_wr
add wave -noupdate -group Registers -group pc -radix octal /tb1/de0_top/cpu/cpu/cpc
add wave -noupdate -group Registers -group pc1 -radix octal /tb1/de0_top/cpu/cpu/pc1
add wave -noupdate -group Registers -group pc1 /tb1/de0_top/cpu/cpu/pc1_wr
add wave -noupdate -group Registers -group pc1 /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group Registers -group pc2 -radix octal /tb1/de0_top/cpu/cpu/pc2
add wave -noupdate -group Registers -group pc2 /tb1/de0_top/cpu/cpu/pc2_wa
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_c
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_c0
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_c1
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_c2
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_n
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_v
add wave -noupdate -group Registers -group psw -group cond /tb1/de0_top/cpu/cpu/cond_z
add wave -noupdate -group Registers -group psw -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/psw[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/psw[0]} -radix octal}} -expand -subitemconfig {{/tb1/de0_top/cpu/cpu/psw[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/psw[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/psw
add wave -noupdate -group Registers -group psw /tb1/de0_top/cpu/cpu/psw_stb
add wave -noupdate -group Registers -group psw /tb1/de0_top/cpu/cpu/pswc_stb
add wave -noupdate -group Registers -group psw /tb1/de0_top/cpu/cpu/psw_wa
add wave -noupdate -group Registers -group psw /tb1/de0_top/cpu/cpu/psw8_wa
add wave -noupdate -group Registers -group psw /tb1/de0_top/cpu/cpu/pswt_wa
add wave -noupdate -group Registers -group cpsw /tb1/de0_top/cpu/cpu/cpsw
add wave -noupdate -group Registers -group cpsw /tb1/de0_top/cpu/cpu/cpsw_wa
add wave -noupdate -group Registers -group cpsw /tb1/de0_top/cpu/cpu/cpsw_stb
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/xb
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/alu_sh[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_sh[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/alu_sh[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_sh[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/alu_sh
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/alu_af[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_af[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/alu_af[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_af[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/alu_af
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_cf
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_or
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/alu_an[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_an[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/alu_an[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_an[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/alu_an
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_a
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_b
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_c
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_d
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_e
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_f
add wave -noupdate -group ALU -group aluop -group alu_x /tb1/de0_top/cpu/cpu/alu_g
add wave -noupdate -group ALU -group aluop /tb1/de0_top/cpu/cpu/alu_cin
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_cr
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_fr
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/alu_inx[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_inx[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/alu_inx[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_inx[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/alu_inx
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/alu_iny
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ax[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ax[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ax[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ax[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ax
add wave -noupdate -group ALU -group aluop -radix octal /tb1/de0_top/cpu/cpu/x
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/y[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/y[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/y[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/y[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/y
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_fr
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_fr1
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_fw
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_fwn
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/rn_wa
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/wr1
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/wa_r1
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/wa_r2
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/en_alu_rc
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/mc_drdy_rc
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/mc_drdy0
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/mc_drdy1
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/io_rdy
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/ra_fr
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/ra_fwn
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/rta_fall
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/mc_stb
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/io_start
add wave -noupdate -group ALU -group ENALU /tb1/de0_top/cpu/cpu/iop_stb
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/alu_nrdy
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/alu_wr
add wave -noupdate -group ALU -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/alu_st[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/alu_st[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/alu_st[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/alu_st[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/alu_st
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/alu_xb
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_wa
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/ra_wx
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/rd2h
add wave -noupdate -group ALU /tb1/de0_top/cpu/cpu/plm_rn
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/mc_stb
add wave -noupdate -group Branch {/tb1/de0_top/cpu/cpu/na[5]}
add wave -noupdate -group Branch {/tb1/de0_top/cpu/cpu/na[4]}
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/plb_matrix/p
add wave -noupdate -group Branch -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/br[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/br[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/br[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/br[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/br
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/bra_req
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/bra_stb
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/bra
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/plb
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/ws_cend
add wave -noupdate -group Branch /tb1/de0_top/cpu/cpu/ws_wait
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_trdy1
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_trdy0
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_trdy0_clr
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_trdy0_set
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_trdy1_clr
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_rdy
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_nrdy
add wave -noupdate -group EA -group ear1 -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ear1[15]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[14]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[13]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[12]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[11]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[10]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[9]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[8]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[7]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[6]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[5]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ear1[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ear1[15]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[14]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[13]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[12]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[11]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[10]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[9]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[8]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[7]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[6]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[5]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ear1[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ear1
add wave -noupdate -group EA -group ear1 /tb1/de0_top/cpu/cpu/ea1_wa
add wave -noupdate -group EA -group ear2 -radix octal /tb1/de0_top/cpu/cpu/ear2
add wave -noupdate -group EA -group ear2 /tb1/de0_top/cpu/cpu/ea2_wa
add wave -noupdate -group EA -group ea_ct /tb1/de0_top/cpu/cpu/ea_f
add wave -noupdate -group EA -group ea_ct /tb1/de0_top/cpu/cpu/ea_ctse
add wave -noupdate -group EA -group ea_ct /tb1/de0_top/cpu/cpu/ea_ctld
add wave -noupdate -group EA -group ea_ct /tb1/de0_top/cpu/cpu/wr2
add wave -noupdate -group EA -group ea_ct -radix octal -childformat {{{/tb1/de0_top/cpu/cpu/ea_ct[4]} -radix octal} {{/tb1/de0_top/cpu/cpu/ea_ct[3]} -radix octal} {{/tb1/de0_top/cpu/cpu/ea_ct[2]} -radix octal} {{/tb1/de0_top/cpu/cpu/ea_ct[1]} -radix octal} {{/tb1/de0_top/cpu/cpu/ea_ct[0]} -radix octal}} -subitemconfig {{/tb1/de0_top/cpu/cpu/ea_ct[4]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ea_ct[3]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ea_ct[2]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ea_ct[1]} {-height 15 -radix octal} {/tb1/de0_top/cpu/cpu/ea_ct[0]} {-height 15 -radix octal}} /tb1/de0_top/cpu/cpu/ea_ct
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_div
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_shl
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_shr
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_shr2
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_vdiv
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_mul
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/wait_div
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/zero_div
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/tlz
add wave -noupdate -group EA -radix octal /tb1/de0_top/cpu/cpu/xb
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/dc_i7
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_f4r
add wave -noupdate -group EA /tb1/de0_top/cpu/cpu/ea_1tm
add wave -noupdate -group EA -group alu_sh /tb1/de0_top/cpu/cpu/plm20m
add wave -noupdate -group EA -group alu_sh /tb1/de0_top/cpu/cpu/plm19m
add wave -noupdate -group EA -group alu_sh /tb1/de0_top/cpu/cpu/plm18m
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_ack_o
add wave -noupdate -group {WB RAM} -radix octal /tb1/de0_top/cpu/mem/wb_adr_i
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_clk_i
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_cyc_i
add wave -noupdate -group {WB RAM} -radix octal /tb1/de0_top/cpu/mem/wb_dat_i
add wave -noupdate -group {WB RAM} -radix octal /tb1/de0_top/cpu/mem/wb_dat_o
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_sel_i
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_stb_i
add wave -noupdate -group {WB RAM} /tb1/de0_top/cpu/mem/wb_we_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {100930372 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 144
configure wave -valuecolwidth 50
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
WaveRestoreZoom {100850489 ps} {101276227 ps}
