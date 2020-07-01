onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_gnt_i
add wave -noupdate -expand -group {WB master} -radix octal /tb2/de0_top/cpu/wbm_adr_o
add wave -noupdate -expand -group {WB master} -radix octal /tb2/de0_top/cpu/wbm_dat_i
add wave -noupdate -expand -group {WB master} -radix octal /tb2/de0_top/cpu/wbm_dat_o
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_sel_o
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_cyc_o
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_stb_o
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_ack_i
add wave -noupdate -expand -group {WB master} /tb2/de0_top/cpu/wbm_we_o
add wave -noupdate -expand -group {WB Interrupt} -radix octal /tb2/de0_top/cpu/wbi_dat_i
add wave -noupdate -expand -group {WB Interrupt} /tb2/de0_top/cpu/wbi_ack_i
add wave -noupdate -expand -group {WB Interrupt} /tb2/de0_top/cpu/wbi_stb_o
add wave -noupdate -expand -group {WB Interrupt} /tb2/de0_top/cpu/wbi_una_o
add wave -noupdate -expand -group Pins /tb2/de0_top/cpu/vm_clk_p
add wave -noupdate -expand -group Pins -group Clocks /tb2/de0_top/cpu/vm_clk_n
add wave -noupdate -expand -group Pins -group Clocks /tb2/de0_top/cpu/vm_clk_slow
add wave -noupdate -expand -group Pins -group Clocks /tb2/de0_top/cpu/vm_clk_ena
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_dclo
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_aclo
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_evnt
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_halt
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_init
add wave -noupdate -expand -group Pins -expand -group Intarrupts /tb2/de0_top/cpu/vm_virq
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wb_start
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wio_ia
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wio_rd
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wio_ua
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wio_wo
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wio_wr
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wb_idone
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wb_rdone
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wb_done
add wave -noupdate -group {WB Internals} /tb2/de0_top/cpu/wb_wdone
add wave -noupdate -group Reset /tb2/de0_top/cpu/reset
add wave -noupdate -group Reset /tb2/de0_top/cpu/abort
add wave -noupdate -group Reset /tb2/de0_top/cpu/mc_res
add wave -noupdate -group Reset /tb2/de0_top/cpu/tout
add wave -noupdate -group Reset -group aclo /tb2/de0_top/cpu/aclo_ack
add wave -noupdate -group Reset -group aclo /tb2/de0_top/cpu/aclo_fall
add wave -noupdate -group Reset -group aclo /tb2/de0_top/cpu/aclo_rise
add wave -noupdate -group Reset -group aclo /tb2/de0_top/cpu/ac0
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/aclo_fall
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/aclo_rise
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/halt
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/virq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/tovf
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/tovf_ack
add wave -noupdate -group Interrupt -radix octal -childformat {{{/tb2/de0_top/cpu/pli[9]} -radix octal} {{/tb2/de0_top/cpu/pli[8]} -radix octal} {{/tb2/de0_top/cpu/pli[7]} -radix octal} {{/tb2/de0_top/cpu/pli[6]} -radix octal} {{/tb2/de0_top/cpu/pli[5]} -radix octal} {{/tb2/de0_top/cpu/pli[4]} -radix octal} {{/tb2/de0_top/cpu/pli[3]} -radix octal} {{/tb2/de0_top/cpu/pli[2]} -radix octal} {{/tb2/de0_top/cpu/pli[1]} -radix octal} {{/tb2/de0_top/cpu/pli[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/pli[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pli[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/pli
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/pli_nrdy
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/pli_req
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/pli_ack
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/vec_stb
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/aclo_rq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/acok_rq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/evnt_rq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/tout_rq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/dble_rq
add wave -noupdate -group Interrupt /tb2/de0_top/cpu/vsel
add wave -noupdate -group Timer -radix octal -childformat {{{/tb2/de0_top/cpu/qtim[8]} -radix octal} {{/tb2/de0_top/cpu/qtim[7]} -radix octal} {{/tb2/de0_top/cpu/qtim[6]} -radix octal} {{/tb2/de0_top/cpu/qtim[5]} -radix octal} {{/tb2/de0_top/cpu/qtim[4]} -radix octal} {{/tb2/de0_top/cpu/qtim[3]} -radix octal} {{/tb2/de0_top/cpu/qtim[2]} -radix octal} {{/tb2/de0_top/cpu/qtim[1]} -radix octal} {{/tb2/de0_top/cpu/qtim[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/qtim[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qtim[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/qtim
add wave -noupdate -group Timer /tb2/de0_top/cpu/tout
add wave -noupdate -group Timer /tb2/de0_top/cpu/tena
add wave -noupdate -group Timer /tb2/de0_top/cpu/thang
add wave -noupdate -group Timer /tb2/de0_top/cpu/tevent
add wave -noupdate -group Timer /tb2/de0_top/cpu/to_rply
add wave -noupdate -group Timer /tb2/de0_top/cpu/tovf
add wave -noupdate -group Timer /tb2/de0_top/cpu/word27
add wave -noupdate -group Timer /tb2/de0_top/cpu/init_out
add wave -noupdate -group Timer /tb2/de0_top/cpu/dble_cnt0
add wave -noupdate -group Timer /tb2/de0_top/cpu/dble_cnt1
add wave -noupdate -group Timer /tb2/de0_top/cpu/tend
add wave -noupdate -group Timer /tb2/de0_top/cpu/tabort
add wave -noupdate -group Timer /tb2/de0_top/cpu/tim_nrdy0
add wave -noupdate -group Timer /tb2/de0_top/cpu/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/abort
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/all_rdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/all_rdy_t0
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/all_rdy_t1
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/alu_nrdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/sta_nrdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/cmd_nrdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/pli_nrdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/io_rdy
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/tim_nrdy0
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/sk
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/brd_wq
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/mc_drdy0
add wave -noupdate -group PLM -group Ready /tb2/de0_top/cpu/mc_drdy1
add wave -noupdate -group PLM /tb2/de0_top/cpu/rta
add wave -noupdate -group PLM /tb2/de0_top/cpu/rta_fall
add wave -noupdate -group PLM /tb2/de0_top/cpu/iop_stb
add wave -noupdate -group PLM /tb2/de0_top/cpu/mc_stb
add wave -noupdate -group PLM /tb2/de0_top/cpu/wra
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/na[5]} -radix octal} {{/tb2/de0_top/cpu/na[4]} -radix octal} {{/tb2/de0_top/cpu/na[3]} -radix octal} {{/tb2/de0_top/cpu/na[2]} -radix octal} {{/tb2/de0_top/cpu/na[1]} -radix octal} {{/tb2/de0_top/cpu/na[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/na[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/na[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/na[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/na[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/na[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/na[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/na
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/ia[5]} -radix octal} {{/tb2/de0_top/cpu/ia[4]} -radix octal} {{/tb2/de0_top/cpu/ia[3]} -radix octal} {{/tb2/de0_top/cpu/ia[2]} -radix octal} {{/tb2/de0_top/cpu/ia[1]} -radix octal} {{/tb2/de0_top/cpu/ia[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ia[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ia[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ia[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ia[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ia[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ia[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ia
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/pla[36]} -radix octal} {{/tb2/de0_top/cpu/pla[35]} -radix octal} {{/tb2/de0_top/cpu/pla[34]} -radix octal} {{/tb2/de0_top/cpu/pla[33]} -radix octal} {{/tb2/de0_top/cpu/pla[32]} -radix octal} {{/tb2/de0_top/cpu/pla[31]} -radix octal} {{/tb2/de0_top/cpu/pla[30]} -radix octal} {{/tb2/de0_top/cpu/pla[29]} -radix octal} {{/tb2/de0_top/cpu/pla[28]} -radix octal} {{/tb2/de0_top/cpu/pla[27]} -radix octal} {{/tb2/de0_top/cpu/pla[26]} -radix octal} {{/tb2/de0_top/cpu/pla[25]} -radix octal} {{/tb2/de0_top/cpu/pla[24]} -radix octal} {{/tb2/de0_top/cpu/pla[23]} -radix octal} {{/tb2/de0_top/cpu/pla[22]} -radix octal} {{/tb2/de0_top/cpu/pla[21]} -radix octal} {{/tb2/de0_top/cpu/pla[20]} -radix octal} {{/tb2/de0_top/cpu/pla[19]} -radix octal} {{/tb2/de0_top/cpu/pla[18]} -radix octal} {{/tb2/de0_top/cpu/pla[17]} -radix octal} {{/tb2/de0_top/cpu/pla[16]} -radix octal} {{/tb2/de0_top/cpu/pla[15]} -radix octal} {{/tb2/de0_top/cpu/pla[14]} -radix octal} {{/tb2/de0_top/cpu/pla[13]} -radix octal} {{/tb2/de0_top/cpu/pla[12]} -radix octal} {{/tb2/de0_top/cpu/pla[11]} -radix octal} {{/tb2/de0_top/cpu/pla[10]} -radix octal} {{/tb2/de0_top/cpu/pla[9]} -radix octal} {{/tb2/de0_top/cpu/pla[8]} -radix octal} {{/tb2/de0_top/cpu/pla[7]} -radix octal} {{/tb2/de0_top/cpu/pla[6]} -radix octal} {{/tb2/de0_top/cpu/pla[5]} -radix octal} {{/tb2/de0_top/cpu/pla[4]} -radix octal} {{/tb2/de0_top/cpu/pla[3]} -radix octal} {{/tb2/de0_top/cpu/pla[2]} -radix octal} {{/tb2/de0_top/cpu/pla[1]} -radix octal} {{/tb2/de0_top/cpu/pla[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/pla[36]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[35]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[34]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[33]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[32]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[31]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[30]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[29]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[28]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[27]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[26]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[25]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[24]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[23]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[22]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[21]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[20]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[19]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[18]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[17]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[16]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pla[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/pla
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/plm[30]} -radix octal} {{/tb2/de0_top/cpu/plm[29]} -radix octal} {{/tb2/de0_top/cpu/plm[28]} -radix octal} {{/tb2/de0_top/cpu/plm[27]} -radix octal} {{/tb2/de0_top/cpu/plm[26]} -radix octal} {{/tb2/de0_top/cpu/plm[25]} -radix octal} {{/tb2/de0_top/cpu/plm[24]} -radix octal} {{/tb2/de0_top/cpu/plm[23]} -radix octal} {{/tb2/de0_top/cpu/plm[22]} -radix octal} {{/tb2/de0_top/cpu/plm[21]} -radix octal} {{/tb2/de0_top/cpu/plm[20]} -radix octal} {{/tb2/de0_top/cpu/plm[19]} -radix octal} {{/tb2/de0_top/cpu/plm[18]} -radix octal} {{/tb2/de0_top/cpu/plm[17]} -radix octal} {{/tb2/de0_top/cpu/plm[16]} -radix octal} {{/tb2/de0_top/cpu/plm[15]} -radix octal} {{/tb2/de0_top/cpu/plm[14]} -radix octal} {{/tb2/de0_top/cpu/plm[13]} -radix octal} {{/tb2/de0_top/cpu/plm[12]} -radix octal} {{/tb2/de0_top/cpu/plm[11]} -radix octal} {{/tb2/de0_top/cpu/plm[10]} -radix octal} {{/tb2/de0_top/cpu/plm[9]} -radix octal} {{/tb2/de0_top/cpu/plm[8]} -radix octal} {{/tb2/de0_top/cpu/plm[7]} -radix octal} {{/tb2/de0_top/cpu/plm[6]} -radix octal} {{/tb2/de0_top/cpu/plm[5]} -radix octal} {{/tb2/de0_top/cpu/plm[4]} -radix octal} {{/tb2/de0_top/cpu/plm[3]} -radix octal} {{/tb2/de0_top/cpu/plm[2]} -radix octal} {{/tb2/de0_top/cpu/plm[1]} -radix octal} {{/tb2/de0_top/cpu/plm[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/plm[30]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[29]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[28]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[27]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[26]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[25]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[24]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[23]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[22]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[21]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[20]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[19]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[18]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[17]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[16]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/plm
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/plm_wt[30]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[29]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[28]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[27]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[26]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[25]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[24]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[23]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[22]} -radix octal} {{/tb2/de0_top/cpu/plm_wt[21]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/plm_wt[30]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[29]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[28]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[27]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[26]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[25]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[24]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[23]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[22]} {-height 15 -radix octal} {/tb2/de0_top/cpu/plm_wt[21]} {-height 15 -radix octal}} /tb2/de0_top/cpu/plm_wt
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm13m
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm14m
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm18m
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm19m
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm1m
add wave -noupdate -group PLM -group plxNm /tb2/de0_top/cpu/plm20m
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[21]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/de0_top/cpu/plr[21]}
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/bra
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_aux
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_b7
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_bi
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_f2
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_fb
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_fl
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_i7
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_j7
add wave -noupdate -group PLM -group dc /tb2/de0_top/cpu/dc_rtt
add wave -noupdate -group PLM /tb2/de0_top/cpu/plb
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/pld[11]} -radix octal} {{/tb2/de0_top/cpu/pld[10]} -radix octal} {{/tb2/de0_top/cpu/pld[9]} -radix octal} {{/tb2/de0_top/cpu/pld[8]} -radix octal} {{/tb2/de0_top/cpu/pld[7]} -radix octal} {{/tb2/de0_top/cpu/pld[6]} -radix octal} {{/tb2/de0_top/cpu/pld[5]} -radix octal} {{/tb2/de0_top/cpu/pld[4]} -radix octal} {{/tb2/de0_top/cpu/pld[3]} -radix octal} {{/tb2/de0_top/cpu/pld[2]} -radix octal} {{/tb2/de0_top/cpu/pld[1]} -radix octal} {{/tb2/de0_top/cpu/pld[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/pld[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/pld[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/pld
add wave -noupdate -group PLM /tb2/de0_top/cpu/ix
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/de0_top/cpu/ri[2]} -radix octal} {{/tb2/de0_top/cpu/ri[1]} -radix octal} {{/tb2/de0_top/cpu/ri[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ri[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ri[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ri[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ri
add wave -noupdate -group PLM /tb2/de0_top/cpu/wr2
add wave -noupdate -group PLM /tb2/de0_top/cpu/wr1
add wave -noupdate -group PLM /tb2/de0_top/cpu/pi_stb_rc
add wave -noupdate -group PLM /tb2/de0_top/cpu/pi_stb
add wave -noupdate -group State /tb2/de0_top/cpu/alu_st
add wave -noupdate -group State /tb2/de0_top/cpu/ea_rdy
add wave -noupdate -group State /tb2/de0_top/cpu/io_rdy
add wave -noupdate -group State /tb2/de0_top/cpu/mc_drdy0
add wave -noupdate -group State /tb2/de0_top/cpu/mc_drdy1
add wave -noupdate -group State /tb2/de0_top/cpu/ra_fr
add wave -noupdate -group State /tb2/de0_top/cpu/ra_fr1
add wave -noupdate -group State /tb2/de0_top/cpu/ra_fw
add wave -noupdate -group State /tb2/de0_top/cpu/ra_fwn
add wave -noupdate -group State /tb2/de0_top/cpu/rta
add wave -noupdate -group State /tb2/de0_top/cpu/rta_fall
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/iocmd_st
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/wr2
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/bra_req
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/cmd_nrdy
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/set_cend
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/ir_stb
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/bir_stb
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/iop_stb
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/sk
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/mc_stb
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/buf_res
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/wra
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/io_rcd
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/io_cmd
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/br_cmdrq
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/br_iocmd
add wave -noupdate -group Ircmd /tb2/de0_top/cpu/br_ready
add wave -noupdate -group IOB -group BUS /tb2/de0_top/cpu/adr_req
add wave -noupdate -group IOB /tb2/de0_top/cpu/wr1
add wave -noupdate -group IOB /tb2/de0_top/cpu/wr2
add wave -noupdate -group IOB /tb2/de0_top/cpu/alu_wr
add wave -noupdate -group IOB /tb2/de0_top/cpu/io_start
add wave -noupdate -group IOB /tb2/de0_top/cpu/iop_stb
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_cmd
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_cmdr
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_in
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_wr
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_rd
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_iak
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_sel
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_rcd
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_rcd1
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_rcdr
add wave -noupdate -group IOB -group io /tb2/de0_top/cpu/io_pswr
add wave -noupdate -group IOB -group iop /tb2/de0_top/cpu/iop_una
add wave -noupdate -group IOB -group iop /tb2/de0_top/cpu/rdat
add wave -noupdate -group IOB -group iop /tb2/de0_top/cpu/sk
add wave -noupdate -group IOB -group iop /tb2/de0_top/cpu/iop_in
add wave -noupdate -group IOB -group iop /tb2/de0_top/cpu/iop_rcd
add wave -noupdate -group IOB /tb2/de0_top/cpu/io_st
add wave -noupdate -group IOB /tb2/de0_top/cpu/iopc_st
add wave -noupdate -group IOB /tb2/de0_top/cpu/drdy
add wave -noupdate -group IOB /tb2/de0_top/cpu/brd_wq
add wave -noupdate -group IOB /tb2/de0_top/cpu/brd_wa
add wave -noupdate -group IOB /tb2/de0_top/cpu/alu_wr
add wave -noupdate -group IOB -group TOCLR /tb2/de0_top/cpu/iop_rcd
add wave -noupdate -group IOB -group TOCLR /tb2/de0_top/cpu/word27
add wave -noupdate -group IOB -group TOCLR /tb2/de0_top/cpu/sd_word
add wave -noupdate -group IOB -group TOCLR /tb2/de0_top/cpu/to_block
add wave -noupdate -group IOB -group TOCLR /tb2/de0_top/cpu/to_rply
add wave -noupdate -group Registers /tb2/de0_top/cpu/axy_wh
add wave -noupdate -group Registers -expand -group qreg -radix octal -childformat {{{/tb2/de0_top/cpu/qreg[15]} -radix octal} {{/tb2/de0_top/cpu/qreg[14]} -radix octal} {{/tb2/de0_top/cpu/qreg[13]} -radix octal} {{/tb2/de0_top/cpu/qreg[12]} -radix octal} {{/tb2/de0_top/cpu/qreg[11]} -radix octal} {{/tb2/de0_top/cpu/qreg[10]} -radix octal} {{/tb2/de0_top/cpu/qreg[9]} -radix octal} {{/tb2/de0_top/cpu/qreg[8]} -radix octal} {{/tb2/de0_top/cpu/qreg[7]} -radix octal} {{/tb2/de0_top/cpu/qreg[6]} -radix octal} {{/tb2/de0_top/cpu/qreg[5]} -radix octal} {{/tb2/de0_top/cpu/qreg[4]} -radix octal} {{/tb2/de0_top/cpu/qreg[3]} -radix octal} {{/tb2/de0_top/cpu/qreg[2]} -radix octal} {{/tb2/de0_top/cpu/qreg[1]} -radix octal} {{/tb2/de0_top/cpu/qreg[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/qreg[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/qreg[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/qreg
add wave -noupdate -group Registers -expand -group qreg /tb2/de0_top/cpu/brd_wa
add wave -noupdate -group Registers -expand -group qreg /tb2/de0_top/cpu/brd_wq
add wave -noupdate -group Registers -expand -group areg -radix octal -childformat {{{/tb2/de0_top/cpu/areg[15]} -radix octal} {{/tb2/de0_top/cpu/areg[14]} -radix octal} {{/tb2/de0_top/cpu/areg[13]} -radix octal} {{/tb2/de0_top/cpu/areg[12]} -radix octal} {{/tb2/de0_top/cpu/areg[11]} -radix octal} {{/tb2/de0_top/cpu/areg[10]} -radix octal} {{/tb2/de0_top/cpu/areg[9]} -radix octal} {{/tb2/de0_top/cpu/areg[8]} -radix octal} {{/tb2/de0_top/cpu/areg[7]} -radix octal} {{/tb2/de0_top/cpu/areg[6]} -radix octal} {{/tb2/de0_top/cpu/areg[5]} -radix octal} {{/tb2/de0_top/cpu/areg[4]} -radix octal} {{/tb2/de0_top/cpu/areg[3]} -radix octal} {{/tb2/de0_top/cpu/areg[2]} -radix octal} {{/tb2/de0_top/cpu/areg[1]} -radix octal} {{/tb2/de0_top/cpu/areg[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/areg[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/areg[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/areg
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/ra_wa
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/ra_wx
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/wra
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/acmp_en
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/wr1
add wave -noupdate -group Registers -expand -group areg /tb2/de0_top/cpu/wr2
add wave -noupdate -group Registers -group acc -radix octal /tb2/de0_top/cpu/acc
add wave -noupdate -group Registers -group acc /tb2/de0_top/cpu/acc_wa
add wave -noupdate -group Registers -group acc /tb2/de0_top/cpu/wr2
add wave -noupdate -group Registers -group sreg -radix octal /tb2/de0_top/cpu/sreg
add wave -noupdate -group Registers -group sreg /tb2/de0_top/cpu/rs_wa
add wave -noupdate -group Registers -group sreg -radix octal -childformat {{{/tb2/de0_top/cpu/breg[15]} -radix octal} {{/tb2/de0_top/cpu/breg[14]} -radix octal} {{/tb2/de0_top/cpu/breg[13]} -radix octal} {{/tb2/de0_top/cpu/breg[12]} -radix octal} {{/tb2/de0_top/cpu/breg[11]} -radix octal} {{/tb2/de0_top/cpu/breg[10]} -radix octal} {{/tb2/de0_top/cpu/breg[9]} -radix octal} {{/tb2/de0_top/cpu/breg[8]} -radix octal} {{/tb2/de0_top/cpu/breg[7]} -radix octal} {{/tb2/de0_top/cpu/breg[6]} -radix octal} {{/tb2/de0_top/cpu/breg[5]} -radix octal} {{/tb2/de0_top/cpu/breg[4]} -radix octal} {{/tb2/de0_top/cpu/breg[3]} -radix octal} {{/tb2/de0_top/cpu/breg[2]} -radix octal} {{/tb2/de0_top/cpu/breg[1]} -radix octal} {{/tb2/de0_top/cpu/breg[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/breg[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/breg[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/breg
add wave -noupdate -group Registers -group ireg -radix octal -childformat {{{/tb2/de0_top/cpu/ireg[15]} -radix octal} {{/tb2/de0_top/cpu/ireg[14]} -radix octal} {{/tb2/de0_top/cpu/ireg[13]} -radix octal} {{/tb2/de0_top/cpu/ireg[12]} -radix octal} {{/tb2/de0_top/cpu/ireg[11]} -radix octal} {{/tb2/de0_top/cpu/ireg[10]} -radix octal} {{/tb2/de0_top/cpu/ireg[9]} -radix octal} {{/tb2/de0_top/cpu/ireg[8]} -radix octal} {{/tb2/de0_top/cpu/ireg[7]} -radix octal} {{/tb2/de0_top/cpu/ireg[6]} -radix octal} {{/tb2/de0_top/cpu/ireg[5]} -radix octal} {{/tb2/de0_top/cpu/ireg[4]} -radix octal} {{/tb2/de0_top/cpu/ireg[3]} -radix octal} {{/tb2/de0_top/cpu/ireg[2]} -radix octal} {{/tb2/de0_top/cpu/ireg[1]} -radix octal} {{/tb2/de0_top/cpu/ireg[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ireg[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ireg[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ireg
add wave -noupdate -group Registers -group ireg /tb2/de0_top/cpu/ir_stb
add wave -noupdate -group Registers -group ireg -radix octal /tb2/de0_top/cpu/breg
add wave -noupdate -group Registers -group ireg /tb2/de0_top/cpu/bir_stb
add wave -noupdate -group Registers -radix octal -childformat {{{/tb2/de0_top/cpu/r[6]} -radix octal} {{/tb2/de0_top/cpu/r[5]} -radix octal} {{/tb2/de0_top/cpu/r[4]} -radix octal} {{/tb2/de0_top/cpu/r[3]} -radix octal} {{/tb2/de0_top/cpu/r[2]} -radix octal} {{/tb2/de0_top/cpu/r[1]} -radix octal} {{/tb2/de0_top/cpu/r[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/r[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/r[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/r
add wave -noupdate -group Registers -group pc /tb2/de0_top/cpu/pc_wax
add wave -noupdate -group Registers -group pc /tb2/de0_top/cpu/pc_wr
add wave -noupdate -group Registers -group pc -radix octal /tb2/de0_top/cpu/cpc
add wave -noupdate -group Registers -group pc1 -radix octal /tb2/de0_top/cpu/pc1
add wave -noupdate -group Registers -group pc1 /tb2/de0_top/cpu/pc1_wr
add wave -noupdate -group Registers -group pc1 /tb2/de0_top/cpu/wr2
add wave -noupdate -group Registers -group pc2 -radix octal /tb2/de0_top/cpu/pc2
add wave -noupdate -group Registers -group pc2 /tb2/de0_top/cpu/pc2_wa
add wave -noupdate -group Registers -group pc2 /tb2/de0_top/cpu/pc2_res
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_c
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_c0
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_c1
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_c2
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_n
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_v
add wave -noupdate -group Registers -group psw -group cond /tb2/de0_top/cpu/cond_z
add wave -noupdate -group Registers -group psw -radix octal -childformat {{{/tb2/de0_top/cpu/psw[8]} -radix octal} {{/tb2/de0_top/cpu/psw[7]} -radix octal} {{/tb2/de0_top/cpu/psw[6]} -radix octal} {{/tb2/de0_top/cpu/psw[5]} -radix octal} {{/tb2/de0_top/cpu/psw[4]} -radix octal} {{/tb2/de0_top/cpu/psw[3]} -radix octal} {{/tb2/de0_top/cpu/psw[2]} -radix octal} {{/tb2/de0_top/cpu/psw[1]} -radix octal} {{/tb2/de0_top/cpu/psw[0]} -radix octal}} -expand -subitemconfig {{/tb2/de0_top/cpu/psw[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/psw[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/psw
add wave -noupdate -group Registers -group psw /tb2/de0_top/cpu/psw_stb
add wave -noupdate -group Registers -group psw /tb2/de0_top/cpu/pswc_stb
add wave -noupdate -group Registers -group psw /tb2/de0_top/cpu/psw_wa
add wave -noupdate -group Registers -group psw /tb2/de0_top/cpu/psw8_wa
add wave -noupdate -group Registers -group psw /tb2/de0_top/cpu/pswt_wa
add wave -noupdate -group Registers -group cpsw /tb2/de0_top/cpu/cpsw
add wave -noupdate -group Registers -group cpsw /tb2/de0_top/cpu/cpsw_wa
add wave -noupdate -group Registers -group cpsw /tb2/de0_top/cpu/cpsw_stb
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/xb
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/alu_sh[15]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[14]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[13]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[12]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[11]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[10]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[9]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[8]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[7]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[6]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[5]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[4]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[3]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[2]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[1]} -radix octal} {{/tb2/de0_top/cpu/alu_sh[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/alu_sh[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_sh[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/alu_sh
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/alu_af[15]} -radix octal} {{/tb2/de0_top/cpu/alu_af[14]} -radix octal} {{/tb2/de0_top/cpu/alu_af[13]} -radix octal} {{/tb2/de0_top/cpu/alu_af[12]} -radix octal} {{/tb2/de0_top/cpu/alu_af[11]} -radix octal} {{/tb2/de0_top/cpu/alu_af[10]} -radix octal} {{/tb2/de0_top/cpu/alu_af[9]} -radix octal} {{/tb2/de0_top/cpu/alu_af[8]} -radix octal} {{/tb2/de0_top/cpu/alu_af[7]} -radix octal} {{/tb2/de0_top/cpu/alu_af[6]} -radix octal} {{/tb2/de0_top/cpu/alu_af[5]} -radix octal} {{/tb2/de0_top/cpu/alu_af[4]} -radix octal} {{/tb2/de0_top/cpu/alu_af[3]} -radix octal} {{/tb2/de0_top/cpu/alu_af[2]} -radix octal} {{/tb2/de0_top/cpu/alu_af[1]} -radix octal} {{/tb2/de0_top/cpu/alu_af[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/alu_af[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_af[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/alu_af
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_cf
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_or
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/alu_an[15]} -radix octal} {{/tb2/de0_top/cpu/alu_an[14]} -radix octal} {{/tb2/de0_top/cpu/alu_an[13]} -radix octal} {{/tb2/de0_top/cpu/alu_an[12]} -radix octal} {{/tb2/de0_top/cpu/alu_an[11]} -radix octal} {{/tb2/de0_top/cpu/alu_an[10]} -radix octal} {{/tb2/de0_top/cpu/alu_an[9]} -radix octal} {{/tb2/de0_top/cpu/alu_an[8]} -radix octal} {{/tb2/de0_top/cpu/alu_an[7]} -radix octal} {{/tb2/de0_top/cpu/alu_an[6]} -radix octal} {{/tb2/de0_top/cpu/alu_an[5]} -radix octal} {{/tb2/de0_top/cpu/alu_an[4]} -radix octal} {{/tb2/de0_top/cpu/alu_an[3]} -radix octal} {{/tb2/de0_top/cpu/alu_an[2]} -radix octal} {{/tb2/de0_top/cpu/alu_an[1]} -radix octal} {{/tb2/de0_top/cpu/alu_an[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/alu_an[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_an[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/alu_an
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_a
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_b
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_c
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_d
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_e
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_f
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/de0_top/cpu/alu_g
add wave -noupdate -group ALU -group aluop /tb2/de0_top/cpu/alu_cin
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_cr
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_fr
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/alu_inx[15]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[14]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[13]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[12]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[11]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[10]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[9]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[8]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[7]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[6]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[5]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[4]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[3]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[2]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[1]} -radix octal} {{/tb2/de0_top/cpu/alu_inx[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/alu_inx[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_inx[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/alu_inx
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/alu_iny
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/ax[15]} -radix octal} {{/tb2/de0_top/cpu/ax[14]} -radix octal} {{/tb2/de0_top/cpu/ax[13]} -radix octal} {{/tb2/de0_top/cpu/ax[12]} -radix octal} {{/tb2/de0_top/cpu/ax[11]} -radix octal} {{/tb2/de0_top/cpu/ax[10]} -radix octal} {{/tb2/de0_top/cpu/ax[9]} -radix octal} {{/tb2/de0_top/cpu/ax[8]} -radix octal} {{/tb2/de0_top/cpu/ax[7]} -radix octal} {{/tb2/de0_top/cpu/ax[6]} -radix octal} {{/tb2/de0_top/cpu/ax[5]} -radix octal} {{/tb2/de0_top/cpu/ax[4]} -radix octal} {{/tb2/de0_top/cpu/ax[3]} -radix octal} {{/tb2/de0_top/cpu/ax[2]} -radix octal} {{/tb2/de0_top/cpu/ax[1]} -radix octal} {{/tb2/de0_top/cpu/ax[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ax[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ax[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ax
add wave -noupdate -group ALU -group aluop -radix octal /tb2/de0_top/cpu/x
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/de0_top/cpu/y[15]} -radix octal} {{/tb2/de0_top/cpu/y[14]} -radix octal} {{/tb2/de0_top/cpu/y[13]} -radix octal} {{/tb2/de0_top/cpu/y[12]} -radix octal} {{/tb2/de0_top/cpu/y[11]} -radix octal} {{/tb2/de0_top/cpu/y[10]} -radix octal} {{/tb2/de0_top/cpu/y[9]} -radix octal} {{/tb2/de0_top/cpu/y[8]} -radix octal} {{/tb2/de0_top/cpu/y[7]} -radix octal} {{/tb2/de0_top/cpu/y[6]} -radix octal} {{/tb2/de0_top/cpu/y[5]} -radix octal} {{/tb2/de0_top/cpu/y[4]} -radix octal} {{/tb2/de0_top/cpu/y[3]} -radix octal} {{/tb2/de0_top/cpu/y[2]} -radix octal} {{/tb2/de0_top/cpu/y[1]} -radix octal} {{/tb2/de0_top/cpu/y[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/y[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/y[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/y
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_fr
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_fr1
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_fw
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_fwn
add wave -noupdate -group ALU /tb2/de0_top/cpu/rn_wa
add wave -noupdate -group ALU /tb2/de0_top/cpu/wr1
add wave -noupdate -group ALU /tb2/de0_top/cpu/wr2
add wave -noupdate -group ALU /tb2/de0_top/cpu/wa_r1
add wave -noupdate -group ALU /tb2/de0_top/cpu/wa_r2
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/en_alu_rc
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/mc_drdy_rc
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/mc_drdy0
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/mc_drdy1
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/io_rdy
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/ra_fr
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/ra_fwn
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/rta
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/rta_fall
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/mc_stb
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/io_start
add wave -noupdate -group ALU -group ENALU /tb2/de0_top/cpu/iop_stb
add wave -noupdate -group ALU /tb2/de0_top/cpu/alu_nrdy
add wave -noupdate -group ALU /tb2/de0_top/cpu/alu_wr
add wave -noupdate -group ALU -radix octal -childformat {{{/tb2/de0_top/cpu/alu_st[1]} -radix octal} {{/tb2/de0_top/cpu/alu_st[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/alu_st[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/alu_st[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/alu_st
add wave -noupdate -group ALU /tb2/de0_top/cpu/alu_xb
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_wa
add wave -noupdate -group ALU /tb2/de0_top/cpu/ra_wx
add wave -noupdate -group ALU /tb2/de0_top/cpu/rd2h
add wave -noupdate -group ALU /tb2/de0_top/cpu/plm_rn
add wave -noupdate -group Branch /tb2/de0_top/cpu/mc_stb
add wave -noupdate -group Branch {/tb2/de0_top/cpu/na[5]}
add wave -noupdate -group Branch {/tb2/de0_top/cpu/na[4]}
add wave -noupdate -group Branch /tb2/de0_top/cpu/plb_matrix/p
add wave -noupdate -group Branch -radix octal -childformat {{{/tb2/de0_top/cpu/br[11]} -radix octal} {{/tb2/de0_top/cpu/br[10]} -radix octal} {{/tb2/de0_top/cpu/br[9]} -radix octal} {{/tb2/de0_top/cpu/br[8]} -radix octal} {{/tb2/de0_top/cpu/br[7]} -radix octal} {{/tb2/de0_top/cpu/br[6]} -radix octal} {{/tb2/de0_top/cpu/br[5]} -radix octal} {{/tb2/de0_top/cpu/br[4]} -radix octal} {{/tb2/de0_top/cpu/br[3]} -radix octal} {{/tb2/de0_top/cpu/br[2]} -radix octal} {{/tb2/de0_top/cpu/br[1]} -radix octal} {{/tb2/de0_top/cpu/br[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/br[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/br[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/br
add wave -noupdate -group Branch /tb2/de0_top/cpu/bra_req
add wave -noupdate -group Branch /tb2/de0_top/cpu/bra_stb
add wave -noupdate -group Branch /tb2/de0_top/cpu/bra
add wave -noupdate -group Branch /tb2/de0_top/cpu/plb
add wave -noupdate -group Branch /tb2/de0_top/cpu/ws_cend
add wave -noupdate -group Branch /tb2/de0_top/cpu/ws_wait
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_trdy1
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_trdy0
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_trdy0_clr
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_trdy0_set
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_trdy1_clr
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_rdy
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_nrdy
add wave -noupdate -group EA -group ear1 -radix octal -childformat {{{/tb2/de0_top/cpu/ear1[15]} -radix octal} {{/tb2/de0_top/cpu/ear1[14]} -radix octal} {{/tb2/de0_top/cpu/ear1[13]} -radix octal} {{/tb2/de0_top/cpu/ear1[12]} -radix octal} {{/tb2/de0_top/cpu/ear1[11]} -radix octal} {{/tb2/de0_top/cpu/ear1[10]} -radix octal} {{/tb2/de0_top/cpu/ear1[9]} -radix octal} {{/tb2/de0_top/cpu/ear1[8]} -radix octal} {{/tb2/de0_top/cpu/ear1[7]} -radix octal} {{/tb2/de0_top/cpu/ear1[6]} -radix octal} {{/tb2/de0_top/cpu/ear1[5]} -radix octal} {{/tb2/de0_top/cpu/ear1[4]} -radix octal} {{/tb2/de0_top/cpu/ear1[3]} -radix octal} {{/tb2/de0_top/cpu/ear1[2]} -radix octal} {{/tb2/de0_top/cpu/ear1[1]} -radix octal} {{/tb2/de0_top/cpu/ear1[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ear1[15]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[14]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[13]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[12]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[11]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[10]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[9]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[8]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[7]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[6]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[5]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ear1[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ear1
add wave -noupdate -group EA -group ear1 /tb2/de0_top/cpu/ea1_wa
add wave -noupdate -group EA -group ear2 -radix octal /tb2/de0_top/cpu/ear2
add wave -noupdate -group EA -group ear2 /tb2/de0_top/cpu/ea2_wa
add wave -noupdate -group EA -group ea_ct /tb2/de0_top/cpu/ea_f
add wave -noupdate -group EA -group ea_ct /tb2/de0_top/cpu/ea_ctse
add wave -noupdate -group EA -group ea_ct /tb2/de0_top/cpu/ea_ctld
add wave -noupdate -group EA -group ea_ct /tb2/de0_top/cpu/wr2
add wave -noupdate -group EA -group ea_ct -radix octal -childformat {{{/tb2/de0_top/cpu/ea_ct[4]} -radix octal} {{/tb2/de0_top/cpu/ea_ct[3]} -radix octal} {{/tb2/de0_top/cpu/ea_ct[2]} -radix octal} {{/tb2/de0_top/cpu/ea_ct[1]} -radix octal} {{/tb2/de0_top/cpu/ea_ct[0]} -radix octal}} -subitemconfig {{/tb2/de0_top/cpu/ea_ct[4]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ea_ct[3]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ea_ct[2]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ea_ct[1]} {-height 15 -radix octal} {/tb2/de0_top/cpu/ea_ct[0]} {-height 15 -radix octal}} /tb2/de0_top/cpu/ea_ct
add wave -noupdate -group EA -group ea_ct /tb2/de0_top/cpu/ea_1t
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_div
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_shl
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_shr
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_shr2
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_vdiv
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_mul
add wave -noupdate -group EA /tb2/de0_top/cpu/wait_div
add wave -noupdate -group EA /tb2/de0_top/cpu/zero_div
add wave -noupdate -group EA /tb2/de0_top/cpu/tlz
add wave -noupdate -group EA -radix octal /tb2/de0_top/cpu/xb
add wave -noupdate -group EA /tb2/de0_top/cpu/dc_i7
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_f4r
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_1t
add wave -noupdate -group EA /tb2/de0_top/cpu/ea_1tm
add wave -noupdate -group EA -group alu_sh /tb2/de0_top/cpu/plm20m
add wave -noupdate -group EA -group alu_sh /tb2/de0_top/cpu/plm19m
add wave -noupdate -group EA -group alu_sh /tb2/de0_top/cpu/plm18m
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_ack_o
add wave -noupdate -group {WB RAM} -radix octal /tb2/de0_top/mem/wb_adr_i
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_clk_i
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_cyc_i
add wave -noupdate -group {WB RAM} -radix octal /tb2/de0_top/mem/wb_dat_i
add wave -noupdate -group {WB RAM} -radix octal /tb2/de0_top/mem/wb_dat_o
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_sel_i
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_stb_i
add wave -noupdate -group {WB RAM} /tb2/de0_top/mem/wb_we_i
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
