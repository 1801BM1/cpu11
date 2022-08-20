onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Pins -radix octal -childformat {{{/tb2/cpu/core/ad[15]} -radix octal} {{/tb2/cpu/core/ad[14]} -radix octal} {{/tb2/cpu/core/ad[13]} -radix octal} {{/tb2/cpu/core/ad[12]} -radix octal} {{/tb2/cpu/core/ad[11]} -radix octal} {{/tb2/cpu/core/ad[10]} -radix octal} {{/tb2/cpu/core/ad[9]} -radix octal} {{/tb2/cpu/core/ad[8]} -radix octal} {{/tb2/cpu/core/ad[7]} -radix octal} {{/tb2/cpu/core/ad[6]} -radix octal} {{/tb2/cpu/core/ad[5]} -radix octal} {{/tb2/cpu/core/ad[4]} -radix octal} {{/tb2/cpu/core/ad[3]} -radix octal} {{/tb2/cpu/core/ad[2]} -radix octal} {{/tb2/cpu/core/ad[1]} -radix octal} {{/tb2/cpu/core/ad[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ad[15]} {-height 15 -radix octal} {/tb2/cpu/core/ad[14]} {-height 15 -radix octal} {/tb2/cpu/core/ad[13]} {-height 15 -radix octal} {/tb2/cpu/core/ad[12]} {-height 15 -radix octal} {/tb2/cpu/core/ad[11]} {-height 15 -radix octal} {/tb2/cpu/core/ad[10]} {-height 15 -radix octal} {/tb2/cpu/core/ad[9]} {-height 15 -radix octal} {/tb2/cpu/core/ad[8]} {-height 15 -radix octal} {/tb2/cpu/core/ad[7]} {-height 15 -radix octal} {/tb2/cpu/core/ad[6]} {-height 15 -radix octal} {/tb2/cpu/core/ad[5]} {-height 15 -radix octal} {/tb2/cpu/core/ad[4]} {-height 15 -radix octal} {/tb2/cpu/core/ad[3]} {-height 15 -radix octal} {/tb2/cpu/core/ad[2]} {-height 15 -radix octal} {/tb2/cpu/core/ad[1]} {-height 15 -radix octal} {/tb2/cpu/core/ad[0]} {-height 15 -radix octal}} /tb2/cpu/core/ad
add wave -noupdate -expand -group Pins -group adbus /tb2/cpu/core/ad_oe
add wave -noupdate -expand -group Pins -group adbus -radix octal /tb2/cpu/pin_ad_out
add wave -noupdate -expand -group Pins -group adbus -radix octal -childformat {{{/tb2/cpu/pin_ad_n[15]} -radix octal} {{/tb2/cpu/pin_ad_n[14]} -radix octal} {{/tb2/cpu/pin_ad_n[13]} -radix octal} {{/tb2/cpu/pin_ad_n[12]} -radix octal} {{/tb2/cpu/pin_ad_n[11]} -radix octal} {{/tb2/cpu/pin_ad_n[10]} -radix octal} {{/tb2/cpu/pin_ad_n[9]} -radix octal} {{/tb2/cpu/pin_ad_n[8]} -radix octal} {{/tb2/cpu/pin_ad_n[7]} -radix octal} {{/tb2/cpu/pin_ad_n[6]} -radix octal} {{/tb2/cpu/pin_ad_n[5]} -radix octal} {{/tb2/cpu/pin_ad_n[4]} -radix octal} {{/tb2/cpu/pin_ad_n[3]} -radix octal} {{/tb2/cpu/pin_ad_n[2]} -radix octal} {{/tb2/cpu/pin_ad_n[1]} -radix octal} {{/tb2/cpu/pin_ad_n[0]} -radix octal}} -subitemconfig {{/tb2/cpu/pin_ad_n[15]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[14]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[13]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[12]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[11]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[10]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[9]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[8]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[7]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[6]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[5]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[4]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[3]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[2]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[1]} {-height 15 -radix octal} {/tb2/cpu/pin_ad_n[0]} {-height 15 -radix octal}} /tb2/cpu/pin_ad_n
add wave -noupdate -expand -group Pins -group adbus /tb2/cpu/pin_ad_ena
add wave -noupdate -expand -group Pins -group adbus /tb2/cpu/pin_ar_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_sync_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_wtbt_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_din_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_dout_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_iako_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_rply_n
add wave -noupdate -expand -group Pins /tb2/cpu/pin_sel_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_dclo_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_aclo_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_sack_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_evnt_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_halt_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_virq_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_init_n
add wave -noupdate -expand -group Pins -group misc /tb2/cpu/pin_init_ena
add wave -noupdate -expand -group Clock -expand -group phase /tb2/cpu/pin_clk_p
add wave -noupdate -expand -group Clock -group eclk /tb2/clko
add wave -noupdate -expand -group Clock -group eclk /tb2/clk
add wave -noupdate -group Reset /tb2/cpu/core/reset
add wave -noupdate -group Reset /tb2/cpu/core/abort
add wave -noupdate -group Reset /tb2/cpu/core/mc_res
add wave -noupdate -group Reset /tb2/cpu/core/tout
add wave -noupdate -group Reset /tb2/cpu/core/dclo
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo_ack
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo_fall
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo_rise
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo_stb
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/aclo_res
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/ac0
add wave -noupdate -group Interrupt /tb2/cpu/core/aclo_fall
add wave -noupdate -group Interrupt /tb2/cpu/core/aclo_rise
add wave -noupdate -group Interrupt /tb2/cpu/core/halt
add wave -noupdate -group Interrupt /tb2/cpu/core/virq
add wave -noupdate -group Interrupt /tb2/cpu/core/tovf
add wave -noupdate -group Interrupt /tb2/cpu/core/tovf_ack
add wave -noupdate -group Interrupt -radix octal -childformat {{{/tb2/cpu/core/pli[9]} -radix octal} {{/tb2/cpu/core/pli[8]} -radix octal} {{/tb2/cpu/core/pli[7]} -radix octal} {{/tb2/cpu/core/pli[6]} -radix octal} {{/tb2/cpu/core/pli[5]} -radix octal} {{/tb2/cpu/core/pli[4]} -radix octal} {{/tb2/cpu/core/pli[3]} -radix octal} {{/tb2/cpu/core/pli[2]} -radix octal} {{/tb2/cpu/core/pli[1]} -radix octal} {{/tb2/cpu/core/pli[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/pli[9]} {-height 15 -radix octal} {/tb2/cpu/core/pli[8]} {-height 15 -radix octal} {/tb2/cpu/core/pli[7]} {-height 15 -radix octal} {/tb2/cpu/core/pli[6]} {-height 15 -radix octal} {/tb2/cpu/core/pli[5]} {-height 15 -radix octal} {/tb2/cpu/core/pli[4]} {-height 15 -radix octal} {/tb2/cpu/core/pli[3]} {-height 15 -radix octal} {/tb2/cpu/core/pli[2]} {-height 15 -radix octal} {/tb2/cpu/core/pli[1]} {-height 15 -radix octal} {/tb2/cpu/core/pli[0]} {-height 15 -radix octal}} /tb2/cpu/core/pli
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_nrdy
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_req
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_ack
add wave -noupdate -group Interrupt /tb2/cpu/core/vec_stb
add wave -noupdate -group Interrupt /tb2/cpu/core/aclo_rq
add wave -noupdate -group Interrupt /tb2/cpu/core/acok_rq
add wave -noupdate -group Interrupt /tb2/cpu/core/evnt_rq
add wave -noupdate -group Interrupt /tb2/cpu/core/tout_rq
add wave -noupdate -group Interrupt /tb2/cpu/core/dble_rq
add wave -noupdate -group Interrupt /tb2/cpu/core/vsel
add wave -noupdate -group Timer -radix octal -childformat {{{/tb2/cpu/core/qtim[8]} -radix octal} {{/tb2/cpu/core/qtim[7]} -radix octal} {{/tb2/cpu/core/qtim[6]} -radix octal} {{/tb2/cpu/core/qtim[5]} -radix octal} {{/tb2/cpu/core/qtim[4]} -radix octal} {{/tb2/cpu/core/qtim[3]} -radix octal} {{/tb2/cpu/core/qtim[2]} -radix octal} {{/tb2/cpu/core/qtim[1]} -radix octal} {{/tb2/cpu/core/qtim[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/qtim[8]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[7]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[6]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[5]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[4]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[3]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[2]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[1]} {-height 15 -radix octal} {/tb2/cpu/core/qtim[0]} {-height 15 -radix octal}} /tb2/cpu/core/qtim
add wave -noupdate -group Timer /tb2/cpu/core/tout
add wave -noupdate -group Timer /tb2/cpu/core/tena
add wave -noupdate -group Timer /tb2/cpu/core/thang
add wave -noupdate -group Timer /tb2/cpu/core/tevent
add wave -noupdate -group Timer /tb2/cpu/core/to_rply
add wave -noupdate -group Timer /tb2/cpu/core/tovf
add wave -noupdate -group Timer /tb2/cpu/core/word27
add wave -noupdate -group Timer /tb2/cpu/core/init_out
add wave -noupdate -group Timer /tb2/cpu/core/dble_cnt0
add wave -noupdate -group Timer /tb2/cpu/core/dble_cnt1
add wave -noupdate -group Timer /tb2/cpu/core/tend
add wave -noupdate -group Timer /tb2/cpu/core/tabort
add wave -noupdate -group Timer /tb2/cpu/core/tim_nrdy0
add wave -noupdate -group Timer /tb2/cpu/core/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/abort
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/all_rdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/all_rdy_t0
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/all_rdy_t1
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/alu_nrdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/sta_nrdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/cmd_nrdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/pli_nrdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/io_rdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/mc_rdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/tim_nrdy0
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/tim_nrdy1
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/sk
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/brd_wq
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/mc_drdy
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/mc_drdy0
add wave -noupdate -group PLM -group Ready /tb2/cpu/core/mc_drdy1
add wave -noupdate -group PLM /tb2/cpu/core/rta
add wave -noupdate -group PLM /tb2/cpu/core/rta_fall
add wave -noupdate -group PLM /tb2/cpu/core/iop_stb
add wave -noupdate -group PLM /tb2/cpu/core/mc_stb
add wave -noupdate -group PLM /tb2/cpu/core/mw_stb
add wave -noupdate -group PLM /tb2/cpu/core/wra
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/na[5]} -radix octal} {{/tb2/cpu/core/na[4]} -radix octal} {{/tb2/cpu/core/na[3]} -radix octal} {{/tb2/cpu/core/na[2]} -radix octal} {{/tb2/cpu/core/na[1]} -radix octal} {{/tb2/cpu/core/na[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/na[5]} {-height 15 -radix octal} {/tb2/cpu/core/na[4]} {-height 15 -radix octal} {/tb2/cpu/core/na[3]} {-height 15 -radix octal} {/tb2/cpu/core/na[2]} {-height 15 -radix octal} {/tb2/cpu/core/na[1]} {-height 15 -radix octal} {/tb2/cpu/core/na[0]} {-height 15 -radix octal}} /tb2/cpu/core/na
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/ia[5]} -radix octal} {{/tb2/cpu/core/ia[4]} -radix octal} {{/tb2/cpu/core/ia[3]} -radix octal} {{/tb2/cpu/core/ia[2]} -radix octal} {{/tb2/cpu/core/ia[1]} -radix octal} {{/tb2/cpu/core/ia[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ia[5]} {-height 15 -radix octal} {/tb2/cpu/core/ia[4]} {-height 15 -radix octal} {/tb2/cpu/core/ia[3]} {-height 15 -radix octal} {/tb2/cpu/core/ia[2]} {-height 15 -radix octal} {/tb2/cpu/core/ia[1]} {-height 15 -radix octal} {/tb2/cpu/core/ia[0]} {-height 15 -radix octal}} /tb2/cpu/core/ia
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/pla[36]} -radix octal} {{/tb2/cpu/core/pla[35]} -radix octal} {{/tb2/cpu/core/pla[34]} -radix octal} {{/tb2/cpu/core/pla[33]} -radix octal} {{/tb2/cpu/core/pla[32]} -radix octal} {{/tb2/cpu/core/pla[31]} -radix octal} {{/tb2/cpu/core/pla[30]} -radix octal} {{/tb2/cpu/core/pla[29]} -radix octal} {{/tb2/cpu/core/pla[28]} -radix octal} {{/tb2/cpu/core/pla[27]} -radix octal} {{/tb2/cpu/core/pla[26]} -radix octal} {{/tb2/cpu/core/pla[25]} -radix octal} {{/tb2/cpu/core/pla[24]} -radix octal} {{/tb2/cpu/core/pla[23]} -radix octal} {{/tb2/cpu/core/pla[22]} -radix octal} {{/tb2/cpu/core/pla[21]} -radix octal} {{/tb2/cpu/core/pla[20]} -radix octal} {{/tb2/cpu/core/pla[19]} -radix octal} {{/tb2/cpu/core/pla[18]} -radix octal} {{/tb2/cpu/core/pla[17]} -radix octal} {{/tb2/cpu/core/pla[16]} -radix octal} {{/tb2/cpu/core/pla[15]} -radix octal} {{/tb2/cpu/core/pla[14]} -radix octal} {{/tb2/cpu/core/pla[13]} -radix octal} {{/tb2/cpu/core/pla[12]} -radix octal} {{/tb2/cpu/core/pla[11]} -radix octal} {{/tb2/cpu/core/pla[10]} -radix octal} {{/tb2/cpu/core/pla[9]} -radix octal} {{/tb2/cpu/core/pla[8]} -radix octal} {{/tb2/cpu/core/pla[7]} -radix octal} {{/tb2/cpu/core/pla[6]} -radix octal} {{/tb2/cpu/core/pla[5]} -radix octal} {{/tb2/cpu/core/pla[4]} -radix octal} {{/tb2/cpu/core/pla[3]} -radix octal} {{/tb2/cpu/core/pla[2]} -radix octal} {{/tb2/cpu/core/pla[1]} -radix octal} {{/tb2/cpu/core/pla[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/pla[36]} {-height 15 -radix octal} {/tb2/cpu/core/pla[35]} {-height 15 -radix octal} {/tb2/cpu/core/pla[34]} {-height 15 -radix octal} {/tb2/cpu/core/pla[33]} {-height 15 -radix octal} {/tb2/cpu/core/pla[32]} {-height 15 -radix octal} {/tb2/cpu/core/pla[31]} {-height 15 -radix octal} {/tb2/cpu/core/pla[30]} {-height 15 -radix octal} {/tb2/cpu/core/pla[29]} {-height 15 -radix octal} {/tb2/cpu/core/pla[28]} {-height 15 -radix octal} {/tb2/cpu/core/pla[27]} {-height 15 -radix octal} {/tb2/cpu/core/pla[26]} {-height 15 -radix octal} {/tb2/cpu/core/pla[25]} {-height 15 -radix octal} {/tb2/cpu/core/pla[24]} {-height 15 -radix octal} {/tb2/cpu/core/pla[23]} {-height 15 -radix octal} {/tb2/cpu/core/pla[22]} {-height 15 -radix octal} {/tb2/cpu/core/pla[21]} {-height 15 -radix octal} {/tb2/cpu/core/pla[20]} {-height 15 -radix octal} {/tb2/cpu/core/pla[19]} {-height 15 -radix octal} {/tb2/cpu/core/pla[18]} {-height 15 -radix octal} {/tb2/cpu/core/pla[17]} {-height 15 -radix octal} {/tb2/cpu/core/pla[16]} {-height 15 -radix octal} {/tb2/cpu/core/pla[15]} {-height 15 -radix octal} {/tb2/cpu/core/pla[14]} {-height 15 -radix octal} {/tb2/cpu/core/pla[13]} {-height 15 -radix octal} {/tb2/cpu/core/pla[12]} {-height 15 -radix octal} {/tb2/cpu/core/pla[11]} {-height 15 -radix octal} {/tb2/cpu/core/pla[10]} {-height 15 -radix octal} {/tb2/cpu/core/pla[9]} {-height 15 -radix octal} {/tb2/cpu/core/pla[8]} {-height 15 -radix octal} {/tb2/cpu/core/pla[7]} {-height 15 -radix octal} {/tb2/cpu/core/pla[6]} {-height 15 -radix octal} {/tb2/cpu/core/pla[5]} {-height 15 -radix octal} {/tb2/cpu/core/pla[4]} {-height 15 -radix octal} {/tb2/cpu/core/pla[3]} {-height 15 -radix octal} {/tb2/cpu/core/pla[2]} {-height 15 -radix octal} {/tb2/cpu/core/pla[1]} {-height 15 -radix octal} {/tb2/cpu/core/pla[0]} {-height 15 -radix octal}} /tb2/cpu/core/pla
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/plm[30]} -radix octal} {{/tb2/cpu/core/plm[29]} -radix octal} {{/tb2/cpu/core/plm[28]} -radix octal} {{/tb2/cpu/core/plm[27]} -radix octal} {{/tb2/cpu/core/plm[26]} -radix octal} {{/tb2/cpu/core/plm[25]} -radix octal} {{/tb2/cpu/core/plm[24]} -radix octal} {{/tb2/cpu/core/plm[23]} -radix octal} {{/tb2/cpu/core/plm[22]} -radix octal} {{/tb2/cpu/core/plm[21]} -radix octal} {{/tb2/cpu/core/plm[20]} -radix octal} {{/tb2/cpu/core/plm[19]} -radix octal} {{/tb2/cpu/core/plm[18]} -radix octal} {{/tb2/cpu/core/plm[17]} -radix octal} {{/tb2/cpu/core/plm[16]} -radix octal} {{/tb2/cpu/core/plm[15]} -radix octal} {{/tb2/cpu/core/plm[14]} -radix octal} {{/tb2/cpu/core/plm[13]} -radix octal} {{/tb2/cpu/core/plm[12]} -radix octal} {{/tb2/cpu/core/plm[11]} -radix octal} {{/tb2/cpu/core/plm[10]} -radix octal} {{/tb2/cpu/core/plm[9]} -radix octal} {{/tb2/cpu/core/plm[8]} -radix octal} {{/tb2/cpu/core/plm[7]} -radix octal} {{/tb2/cpu/core/plm[6]} -radix octal} {{/tb2/cpu/core/plm[5]} -radix octal} {{/tb2/cpu/core/plm[4]} -radix octal} {{/tb2/cpu/core/plm[3]} -radix octal} {{/tb2/cpu/core/plm[2]} -radix octal} {{/tb2/cpu/core/plm[1]} -radix octal} {{/tb2/cpu/core/plm[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/plm[30]} {-height 15 -radix octal} {/tb2/cpu/core/plm[29]} {-height 15 -radix octal} {/tb2/cpu/core/plm[28]} {-height 15 -radix octal} {/tb2/cpu/core/plm[27]} {-height 15 -radix octal} {/tb2/cpu/core/plm[26]} {-height 15 -radix octal} {/tb2/cpu/core/plm[25]} {-height 15 -radix octal} {/tb2/cpu/core/plm[24]} {-height 15 -radix octal} {/tb2/cpu/core/plm[23]} {-height 15 -radix octal} {/tb2/cpu/core/plm[22]} {-height 15 -radix octal} {/tb2/cpu/core/plm[21]} {-height 15 -radix octal} {/tb2/cpu/core/plm[20]} {-height 15 -radix octal} {/tb2/cpu/core/plm[19]} {-height 15 -radix octal} {/tb2/cpu/core/plm[18]} {-height 15 -radix octal} {/tb2/cpu/core/plm[17]} {-height 15 -radix octal} {/tb2/cpu/core/plm[16]} {-height 15 -radix octal} {/tb2/cpu/core/plm[15]} {-height 15 -radix octal} {/tb2/cpu/core/plm[14]} {-height 15 -radix octal} {/tb2/cpu/core/plm[13]} {-height 15 -radix octal} {/tb2/cpu/core/plm[12]} {-height 15 -radix octal} {/tb2/cpu/core/plm[11]} {-height 15 -radix octal} {/tb2/cpu/core/plm[10]} {-height 15 -radix octal} {/tb2/cpu/core/plm[9]} {-height 15 -radix octal} {/tb2/cpu/core/plm[8]} {-height 15 -radix octal} {/tb2/cpu/core/plm[7]} {-height 15 -radix octal} {/tb2/cpu/core/plm[6]} {-height 15 -radix octal} {/tb2/cpu/core/plm[5]} {-height 15 -radix octal} {/tb2/cpu/core/plm[4]} {-height 15 -radix octal} {/tb2/cpu/core/plm[3]} {-height 15 -radix octal} {/tb2/cpu/core/plm[2]} {-height 15 -radix octal} {/tb2/cpu/core/plm[1]} {-height 15 -radix octal} {/tb2/cpu/core/plm[0]} {-height 15 -radix octal}} /tb2/cpu/core/plm
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/plm_wt[30]} -radix octal} {{/tb2/cpu/core/plm_wt[29]} -radix octal} {{/tb2/cpu/core/plm_wt[28]} -radix octal} {{/tb2/cpu/core/plm_wt[27]} -radix octal} {{/tb2/cpu/core/plm_wt[26]} -radix octal} {{/tb2/cpu/core/plm_wt[25]} -radix octal} {{/tb2/cpu/core/plm_wt[24]} -radix octal} {{/tb2/cpu/core/plm_wt[23]} -radix octal} {{/tb2/cpu/core/plm_wt[22]} -radix octal} {{/tb2/cpu/core/plm_wt[21]} -radix octal}} -subitemconfig {{/tb2/cpu/core/plm_wt[30]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[29]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[28]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[27]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[26]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[25]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[24]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[23]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[22]} {-height 15 -radix octal} {/tb2/cpu/core/plm_wt[21]} {-height 15 -radix octal}} /tb2/cpu/core/plm_wt
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm13m
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm14m
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm18m
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm19m
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm1m
add wave -noupdate -group PLM -group plxNm /tb2/cpu/core/plm20m
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[21]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[24]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[23]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[22]}
add wave -noupdate -group PLM -group plr -radix octal {/tb2/cpu/core/plr[21]}
add wave -noupdate -group PLM -group dc /tb2/cpu/core/bra
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_aux
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_b7
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_bi
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_f2
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_fb
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_fl
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_i7
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_j7
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_mop0
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_mop1
add wave -noupdate -group PLM -group dc /tb2/cpu/core/dc_rtt
add wave -noupdate -group PLM /tb2/cpu/core/plb
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/pld[11]} -radix octal} {{/tb2/cpu/core/pld[10]} -radix octal} {{/tb2/cpu/core/pld[9]} -radix octal} {{/tb2/cpu/core/pld[8]} -radix octal} {{/tb2/cpu/core/pld[7]} -radix octal} {{/tb2/cpu/core/pld[6]} -radix octal} {{/tb2/cpu/core/pld[5]} -radix octal} {{/tb2/cpu/core/pld[4]} -radix octal} {{/tb2/cpu/core/pld[3]} -radix octal} {{/tb2/cpu/core/pld[2]} -radix octal} {{/tb2/cpu/core/pld[1]} -radix octal} {{/tb2/cpu/core/pld[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/pld[11]} {-height 15 -radix octal} {/tb2/cpu/core/pld[10]} {-height 15 -radix octal} {/tb2/cpu/core/pld[9]} {-height 15 -radix octal} {/tb2/cpu/core/pld[8]} {-height 15 -radix octal} {/tb2/cpu/core/pld[7]} {-height 15 -radix octal} {/tb2/cpu/core/pld[6]} {-height 15 -radix octal} {/tb2/cpu/core/pld[5]} {-height 15 -radix octal} {/tb2/cpu/core/pld[4]} {-height 15 -radix octal} {/tb2/cpu/core/pld[3]} {-height 15 -radix octal} {/tb2/cpu/core/pld[2]} {-height 15 -radix octal} {/tb2/cpu/core/pld[1]} {-height 15 -radix octal} {/tb2/cpu/core/pld[0]} {-height 15 -radix octal}} /tb2/cpu/core/pld
add wave -noupdate -group PLM /tb2/cpu/core/ix
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/ri[2]} -radix octal} {{/tb2/cpu/core/ri[1]} -radix octal} {{/tb2/cpu/core/ri[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ri[2]} {-height 15 -radix octal} {/tb2/cpu/core/ri[1]} {-height 15 -radix octal} {/tb2/cpu/core/ri[0]} {-height 15 -radix octal}} /tb2/cpu/core/ri
add wave -noupdate -group PLM /tb2/cpu/core/wr2
add wave -noupdate -group PLM /tb2/cpu/core/wr1
add wave -noupdate -group PLM /tb2/cpu/core/pi_stb_rc
add wave -noupdate -group PLM /tb2/cpu/core/pi_stb
add wave -noupdate -group State /tb2/cpu/core/alu_st
add wave -noupdate -group State /tb2/cpu/core/mc_drdy
add wave -noupdate -group State /tb2/cpu/core/mc_rdy
add wave -noupdate -group State /tb2/cpu/core/ea_rdy
add wave -noupdate -group State /tb2/cpu/core/io_rdy
add wave -noupdate -group State /tb2/cpu/core/mc_drdy0
add wave -noupdate -group State /tb2/cpu/core/mc_drdy1
add wave -noupdate -group State /tb2/cpu/core/ra_fr
add wave -noupdate -group State /tb2/cpu/core/ra_fr1
add wave -noupdate -group State /tb2/cpu/core/ra_fw
add wave -noupdate -group State /tb2/cpu/core/ra_fwn
add wave -noupdate -group State /tb2/cpu/core/rta
add wave -noupdate -group State /tb2/cpu/core/rta_fall
add wave -noupdate -group Ircmd /tb2/cpu/core/iocmd_st
add wave -noupdate -group Ircmd /tb2/cpu/core/wr2
add wave -noupdate -group Ircmd /tb2/cpu/core/bra_req
add wave -noupdate -group Ircmd /tb2/cpu/core/cmd_nrdy
add wave -noupdate -group Ircmd /tb2/cpu/core/set_cend
add wave -noupdate -group Ircmd /tb2/cpu/core/ir_stb
add wave -noupdate -group Ircmd /tb2/cpu/core/bir_stb
add wave -noupdate -group Ircmd /tb2/cpu/core/iop_stb
add wave -noupdate -group Ircmd /tb2/cpu/core/sk
add wave -noupdate -group Ircmd /tb2/cpu/core/mc_stb
add wave -noupdate -group Ircmd /tb2/cpu/core/buf_res
add wave -noupdate -group Ircmd /tb2/cpu/core/wra
add wave -noupdate -group Ircmd /tb2/cpu/core/io_rcd
add wave -noupdate -group Ircmd /tb2/cpu/core/io_cmd
add wave -noupdate -group Ircmd /tb2/cpu/core/br_cmdrq
add wave -noupdate -group Ircmd /tb2/cpu/core/br_iocmd
add wave -noupdate -group Ircmd /tb2/cpu/core/br_ready
add wave -noupdate -group IOB -group BUS -radix octal -childformat {{{/tb2/cpu/core/ad[15]} -radix octal} {{/tb2/cpu/core/ad[14]} -radix octal} {{/tb2/cpu/core/ad[13]} -radix octal} {{/tb2/cpu/core/ad[12]} -radix octal} {{/tb2/cpu/core/ad[11]} -radix octal} {{/tb2/cpu/core/ad[10]} -radix octal} {{/tb2/cpu/core/ad[9]} -radix octal} {{/tb2/cpu/core/ad[8]} -radix octal} {{/tb2/cpu/core/ad[7]} -radix octal} {{/tb2/cpu/core/ad[6]} -radix octal} {{/tb2/cpu/core/ad[5]} -radix octal} {{/tb2/cpu/core/ad[4]} -radix octal} {{/tb2/cpu/core/ad[3]} -radix octal} {{/tb2/cpu/core/ad[2]} -radix octal} {{/tb2/cpu/core/ad[1]} -radix octal} {{/tb2/cpu/core/ad[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ad[15]} {-height 15 -radix octal} {/tb2/cpu/core/ad[14]} {-height 15 -radix octal} {/tb2/cpu/core/ad[13]} {-height 15 -radix octal} {/tb2/cpu/core/ad[12]} {-height 15 -radix octal} {/tb2/cpu/core/ad[11]} {-height 15 -radix octal} {/tb2/cpu/core/ad[10]} {-height 15 -radix octal} {/tb2/cpu/core/ad[9]} {-height 15 -radix octal} {/tb2/cpu/core/ad[8]} {-height 15 -radix octal} {/tb2/cpu/core/ad[7]} {-height 15 -radix octal} {/tb2/cpu/core/ad[6]} {-height 15 -radix octal} {/tb2/cpu/core/ad[5]} {-height 15 -radix octal} {/tb2/cpu/core/ad[4]} {-height 15 -radix octal} {/tb2/cpu/core/ad[3]} {-height 15 -radix octal} {/tb2/cpu/core/ad[2]} {-height 15 -radix octal} {/tb2/cpu/core/ad[1]} {-height 15 -radix octal} {/tb2/cpu/core/ad[0]} {-height 15 -radix octal}} /tb2/cpu/core/ad
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/ad_oe
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/ad_rd
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/bus_adr
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/brd_rqh
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/brd_rql
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/adr_req
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/bus_dat
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/bus_free
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/ardy
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/ardy_s0
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/bfree
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/dmr
add wave -noupdate -group IOB -group BUS /tb2/cpu/core/ct_oe
add wave -noupdate -group IOB -group BUS -radix octal /tb2/cpu/core/pin_ad_in
add wave -noupdate -group IOB -group BUS -radix octal /tb2/cpu/core/pin_ad_out
add wave -noupdate -group IOB /tb2/cpu/core/wr1
add wave -noupdate -group IOB /tb2/cpu/core/wr2
add wave -noupdate -group IOB /tb2/cpu/core/alu_wr
add wave -noupdate -group IOB /tb2/cpu/core/io_start
add wave -noupdate -group IOB /tb2/cpu/core/iop_stb
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_cmd
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_cmdr
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_in
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_wr
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_rd
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_iak
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_sel
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_rcd
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_rcd1
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_rcdr
add wave -noupdate -group IOB -group io /tb2/cpu/core/io_pswr
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_una
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_sel
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_iak
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_rd
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_wr
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_word
add wave -noupdate -group IOB -group iop /tb2/cpu/core/dc_mop0
add wave -noupdate -group IOB -group iop /tb2/cpu/core/dc_mop1
add wave -noupdate -group IOB -group iop /tb2/cpu/core/rdat
add wave -noupdate -group IOB -group iop /tb2/cpu/core/sk
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_in
add wave -noupdate -group IOB -group iop /tb2/cpu/core/iop_rcd
add wave -noupdate -group IOB /tb2/cpu/core/io_st
add wave -noupdate -group IOB /tb2/cpu/core/iopc_st
add wave -noupdate -group IOB /tb2/cpu/core/brd_wq
add wave -noupdate -group IOB {/tb2/cpu/core/iopc_st[1]}
add wave -noupdate -group IOB /tb2/cpu/core/alu_wr
add wave -noupdate -group IOB /tb2/cpu/core/brd_wa
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/din
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/din_clr
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/din_clr_rc
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/din_set
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/in_ua
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/sel1
add wave -noupdate -group IOB -group DIN /tb2/cpu/core/sel2
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/dout
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/dout_clr
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/dout_s0
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/dout_set
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/bus_dat
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/wtbt
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/ardy
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/ardy_s0
add wave -noupdate -group IOB -group DOUT /tb2/cpu/core/drdy
add wave -noupdate -group IOB -group TOCLR /tb2/cpu/core/iop_rcd
add wave -noupdate -group IOB -group TOCLR /tb2/cpu/core/word27
add wave -noupdate -group IOB -group TOCLR /tb2/cpu/core/rd_end
add wave -noupdate -group IOB -group TOCLR /tb2/cpu/core/sd_word
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/to_rply
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/to_block
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/ua_rply
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/irply
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rply
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rply0
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rply1
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rply2
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rply3
add wave -noupdate -group IOB -group RPLY /tb2/cpu/core/rplys
add wave -noupdate -group IOB -group SYNC /tb2/cpu/core/sync
add wave -noupdate -group IOB -group SYNC /tb2/cpu/core/sync_s0
add wave -noupdate -group IOB -group SYNC /tb2/cpu/core/sync_set
add wave -noupdate -group IOB -group SYNC /tb2/cpu/core/sync_clr
add wave -noupdate -group IOB -group SYNC /tb2/cpu/core/sync_clw
add wave -noupdate -group Registers /tb2/cpu/core/axy_wh
add wave -noupdate -group Registers -group qreg -radix octal -childformat {{{/tb2/cpu/core/qreg[15]} -radix octal} {{/tb2/cpu/core/qreg[14]} -radix octal} {{/tb2/cpu/core/qreg[13]} -radix octal} {{/tb2/cpu/core/qreg[12]} -radix octal} {{/tb2/cpu/core/qreg[11]} -radix octal} {{/tb2/cpu/core/qreg[10]} -radix octal} {{/tb2/cpu/core/qreg[9]} -radix octal} {{/tb2/cpu/core/qreg[8]} -radix octal} {{/tb2/cpu/core/qreg[7]} -radix octal} {{/tb2/cpu/core/qreg[6]} -radix octal} {{/tb2/cpu/core/qreg[5]} -radix octal} {{/tb2/cpu/core/qreg[4]} -radix octal} {{/tb2/cpu/core/qreg[3]} -radix octal} {{/tb2/cpu/core/qreg[2]} -radix octal} {{/tb2/cpu/core/qreg[1]} -radix octal} {{/tb2/cpu/core/qreg[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/qreg[15]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[14]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[13]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[12]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[11]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[10]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[9]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[8]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[7]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[6]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[5]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[4]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[3]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[2]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[1]} {-height 15 -radix octal} {/tb2/cpu/core/qreg[0]} {-height 15 -radix octal}} /tb2/cpu/core/qreg
add wave -noupdate -group Registers -group qreg /tb2/cpu/core/brd_wa
add wave -noupdate -group Registers -group qreg /tb2/cpu/core/brd_wq
add wave -noupdate -group Registers -group qreg /tb2/cpu/core/qd_swap
add wave -noupdate -group Registers -group qreg /tb2/cpu/core/brd_rx
add wave -noupdate -group Registers -group qreg /tb2/cpu/core/brd_ry
add wave -noupdate -group Registers -group areg -radix octal -childformat {{{/tb2/cpu/core/areg[15]} -radix octal} {{/tb2/cpu/core/areg[14]} -radix octal} {{/tb2/cpu/core/areg[13]} -radix octal} {{/tb2/cpu/core/areg[12]} -radix octal} {{/tb2/cpu/core/areg[11]} -radix octal} {{/tb2/cpu/core/areg[10]} -radix octal} {{/tb2/cpu/core/areg[9]} -radix octal} {{/tb2/cpu/core/areg[8]} -radix octal} {{/tb2/cpu/core/areg[7]} -radix octal} {{/tb2/cpu/core/areg[6]} -radix octal} {{/tb2/cpu/core/areg[5]} -radix octal} {{/tb2/cpu/core/areg[4]} -radix octal} {{/tb2/cpu/core/areg[3]} -radix octal} {{/tb2/cpu/core/areg[2]} -radix octal} {{/tb2/cpu/core/areg[1]} -radix octal} {{/tb2/cpu/core/areg[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/areg[15]} {-height 15 -radix octal} {/tb2/cpu/core/areg[14]} {-height 15 -radix octal} {/tb2/cpu/core/areg[13]} {-height 15 -radix octal} {/tb2/cpu/core/areg[12]} {-height 15 -radix octal} {/tb2/cpu/core/areg[11]} {-height 15 -radix octal} {/tb2/cpu/core/areg[10]} {-height 15 -radix octal} {/tb2/cpu/core/areg[9]} {-height 15 -radix octal} {/tb2/cpu/core/areg[8]} {-height 15 -radix octal} {/tb2/cpu/core/areg[7]} {-height 15 -radix octal} {/tb2/cpu/core/areg[6]} {-height 15 -radix octal} {/tb2/cpu/core/areg[5]} {-height 15 -radix octal} {/tb2/cpu/core/areg[4]} {-height 15 -radix octal} {/tb2/cpu/core/areg[3]} {-height 15 -radix octal} {/tb2/cpu/core/areg[2]} {-height 15 -radix octal} {/tb2/cpu/core/areg[1]} {-height 15 -radix octal} {/tb2/cpu/core/areg[0]} {-height 15 -radix octal}} /tb2/cpu/core/areg
add wave -noupdate -group Registers -group areg /tb2/cpu/core/ra_wa
add wave -noupdate -group Registers -group areg /tb2/cpu/core/ra_wx
add wave -noupdate -group Registers -group areg /tb2/cpu/core/wra
add wave -noupdate -group Registers -group areg /tb2/cpu/core/acmp_en
add wave -noupdate -group Registers -group areg /tb2/cpu/core/adr_eq
add wave -noupdate -group Registers -group areg /tb2/cpu/core/ra_ry
add wave -noupdate -group Registers -group areg /tb2/cpu/core/wr1
add wave -noupdate -group Registers -group areg /tb2/cpu/core/wr2
add wave -noupdate -group Registers -group acc -radix octal /tb2/cpu/core/acc
add wave -noupdate -group Registers -group acc /tb2/cpu/core/acc_wa
add wave -noupdate -group Registers -group acc /tb2/cpu/core/wr2
add wave -noupdate -group Registers -group acc /tb2/cpu/core/acc_rx
add wave -noupdate -group Registers -group acc /tb2/cpu/core/acc_ry
add wave -noupdate -group Registers -group sreg -radix octal /tb2/cpu/core/sreg
add wave -noupdate -group Registers -group sreg /tb2/cpu/core/rs_wa
add wave -noupdate -group Registers -group sreg -radix octal -childformat {{{/tb2/cpu/core/breg[15]} -radix octal} {{/tb2/cpu/core/breg[14]} -radix octal} {{/tb2/cpu/core/breg[13]} -radix octal} {{/tb2/cpu/core/breg[12]} -radix octal} {{/tb2/cpu/core/breg[11]} -radix octal} {{/tb2/cpu/core/breg[10]} -radix octal} {{/tb2/cpu/core/breg[9]} -radix octal} {{/tb2/cpu/core/breg[8]} -radix octal} {{/tb2/cpu/core/breg[7]} -radix octal} {{/tb2/cpu/core/breg[6]} -radix octal} {{/tb2/cpu/core/breg[5]} -radix octal} {{/tb2/cpu/core/breg[4]} -radix octal} {{/tb2/cpu/core/breg[3]} -radix octal} {{/tb2/cpu/core/breg[2]} -radix octal} {{/tb2/cpu/core/breg[1]} -radix octal} {{/tb2/cpu/core/breg[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/breg[15]} {-height 15 -radix octal} {/tb2/cpu/core/breg[14]} {-height 15 -radix octal} {/tb2/cpu/core/breg[13]} {-height 15 -radix octal} {/tb2/cpu/core/breg[12]} {-height 15 -radix octal} {/tb2/cpu/core/breg[11]} {-height 15 -radix octal} {/tb2/cpu/core/breg[10]} {-height 15 -radix octal} {/tb2/cpu/core/breg[9]} {-height 15 -radix octal} {/tb2/cpu/core/breg[8]} {-height 15 -radix octal} {/tb2/cpu/core/breg[7]} {-height 15 -radix octal} {/tb2/cpu/core/breg[6]} {-height 15 -radix octal} {/tb2/cpu/core/breg[5]} {-height 15 -radix octal} {/tb2/cpu/core/breg[4]} {-height 15 -radix octal} {/tb2/cpu/core/breg[3]} {-height 15 -radix octal} {/tb2/cpu/core/breg[2]} {-height 15 -radix octal} {/tb2/cpu/core/breg[1]} {-height 15 -radix octal} {/tb2/cpu/core/breg[0]} {-height 15 -radix octal}} /tb2/cpu/core/breg
add wave -noupdate -group Registers -group sreg /tb2/cpu/core/rs_rx
add wave -noupdate -group Registers -group sreg /tb2/cpu/core/rs_ry
add wave -noupdate -group Registers -group ireg -radix octal -childformat {{{/tb2/cpu/core/ireg[15]} -radix octal} {{/tb2/cpu/core/ireg[14]} -radix octal} {{/tb2/cpu/core/ireg[13]} -radix octal} {{/tb2/cpu/core/ireg[12]} -radix octal} {{/tb2/cpu/core/ireg[11]} -radix octal} {{/tb2/cpu/core/ireg[10]} -radix octal} {{/tb2/cpu/core/ireg[9]} -radix octal} {{/tb2/cpu/core/ireg[8]} -radix octal} {{/tb2/cpu/core/ireg[7]} -radix octal} {{/tb2/cpu/core/ireg[6]} -radix octal} {{/tb2/cpu/core/ireg[5]} -radix octal} {{/tb2/cpu/core/ireg[4]} -radix octal} {{/tb2/cpu/core/ireg[3]} -radix octal} {{/tb2/cpu/core/ireg[2]} -radix octal} {{/tb2/cpu/core/ireg[1]} -radix octal} {{/tb2/cpu/core/ireg[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ireg[15]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[14]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[13]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[12]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[11]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[10]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[9]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[8]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[7]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[6]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[5]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[4]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[3]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[2]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[1]} {-height 15 -radix octal} {/tb2/cpu/core/ireg[0]} {-height 15 -radix octal}} /tb2/cpu/core/ireg
add wave -noupdate -group Registers -group ireg /tb2/cpu/core/ir_stb
add wave -noupdate -group Registers -group ireg -radix octal /tb2/cpu/core/breg
add wave -noupdate -group Registers -group ireg /tb2/cpu/core/bir_stb
add wave -noupdate -group Registers -radix octal -childformat {{{/tb2/cpu/core/r[6]} -radix octal} {{/tb2/cpu/core/r[5]} -radix octal} {{/tb2/cpu/core/r[4]} -radix octal} {{/tb2/cpu/core/r[3]} -radix octal} {{/tb2/cpu/core/r[2]} -radix octal} {{/tb2/cpu/core/r[1]} -radix octal} {{/tb2/cpu/core/r[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/r[6]} {-height 15 -radix octal} {/tb2/cpu/core/r[5]} {-height 15 -radix octal} {/tb2/cpu/core/r[4]} {-height 15 -radix octal} {/tb2/cpu/core/r[3]} {-height 15 -radix octal} {/tb2/cpu/core/r[2]} {-height 15 -radix octal} {/tb2/cpu/core/r[1]} {-height 15 -radix octal} {/tb2/cpu/core/r[0]} {-height 15 -radix octal}} /tb2/cpu/core/r
add wave -noupdate -group Registers -group pc /tb2/cpu/core/pc_wax
add wave -noupdate -group Registers -group pc /tb2/cpu/core/pc_wr
add wave -noupdate -group Registers -group pc /tb2/cpu/core/pc_ry
add wave -noupdate -group Registers -group pc /tb2/cpu/core/cpc
add wave -noupdate -group Registers -group pc1 -radix octal /tb2/cpu/core/pc1
add wave -noupdate -group Registers -group pc1 /tb2/cpu/core/pc1_rx
add wave -noupdate -group Registers -group pc1 /tb2/cpu/core/pc1_ry
add wave -noupdate -group Registers -group pc1 /tb2/cpu/core/pc1_wr
add wave -noupdate -group Registers -group pc1 /tb2/cpu/core/wr2
add wave -noupdate -group Registers -group pc2 -radix octal /tb2/cpu/core/pc2
add wave -noupdate -group Registers -group pc2 /tb2/cpu/core/pc2_wa
add wave -noupdate -group Registers -group pc2 /tb2/cpu/core/pc2_rx
add wave -noupdate -group Registers /tb2/cpu/core/rn_rx
add wave -noupdate -group Registers /tb2/cpu/core/rn_ry
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_c
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_c0
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_c1
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_c2
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_n
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_v
add wave -noupdate -group Registers -group psw -group cond /tb2/cpu/core/cond_z
add wave -noupdate -group Registers -group psw -radix octal -childformat {{{/tb2/cpu/core/psw[8]} -radix octal} {{/tb2/cpu/core/psw[7]} -radix octal} {{/tb2/cpu/core/psw[6]} -radix octal} {{/tb2/cpu/core/psw[5]} -radix octal} {{/tb2/cpu/core/psw[4]} -radix octal} {{/tb2/cpu/core/psw[3]} -radix octal} {{/tb2/cpu/core/psw[2]} -radix octal} {{/tb2/cpu/core/psw[1]} -radix octal} {{/tb2/cpu/core/psw[0]} -radix octal}} -expand -subitemconfig {{/tb2/cpu/core/psw[8]} {-height 15 -radix octal} {/tb2/cpu/core/psw[7]} {-height 15 -radix octal} {/tb2/cpu/core/psw[6]} {-height 15 -radix octal} {/tb2/cpu/core/psw[5]} {-height 15 -radix octal} {/tb2/cpu/core/psw[4]} {-height 15 -radix octal} {/tb2/cpu/core/psw[3]} {-height 15 -radix octal} {/tb2/cpu/core/psw[2]} {-height 15 -radix octal} {/tb2/cpu/core/psw[1]} {-height 15 -radix octal} {/tb2/cpu/core/psw[0]} {-height 15 -radix octal}} /tb2/cpu/core/psw
add wave -noupdate -group Registers -group psw /tb2/cpu/core/psw_stb
add wave -noupdate -group Registers -group psw /tb2/cpu/core/pswc_stb
add wave -noupdate -group Registers -group psw /tb2/cpu/core/psw_wa
add wave -noupdate -group Registers -group psw /tb2/cpu/core/psw8_wa
add wave -noupdate -group Registers -group psw /tb2/cpu/core/pswt_wa
add wave -noupdate -group Registers -group psw /tb2/cpu/core/psw_rx
add wave -noupdate -group Registers -group psw /tb2/cpu/core/psw_ry
add wave -noupdate -group Registers -group cpsw /tb2/cpu/core/cpsw
add wave -noupdate -group Registers -group cpsw /tb2/cpu/core/cpsw_wa
add wave -noupdate -group Registers -group cpsw /tb2/cpu/core/cpsw_stb
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/xb
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/alu_sh[15]} -radix octal} {{/tb2/cpu/core/alu_sh[14]} -radix octal} {{/tb2/cpu/core/alu_sh[13]} -radix octal} {{/tb2/cpu/core/alu_sh[12]} -radix octal} {{/tb2/cpu/core/alu_sh[11]} -radix octal} {{/tb2/cpu/core/alu_sh[10]} -radix octal} {{/tb2/cpu/core/alu_sh[9]} -radix octal} {{/tb2/cpu/core/alu_sh[8]} -radix octal} {{/tb2/cpu/core/alu_sh[7]} -radix octal} {{/tb2/cpu/core/alu_sh[6]} -radix octal} {{/tb2/cpu/core/alu_sh[5]} -radix octal} {{/tb2/cpu/core/alu_sh[4]} -radix octal} {{/tb2/cpu/core/alu_sh[3]} -radix octal} {{/tb2/cpu/core/alu_sh[2]} -radix octal} {{/tb2/cpu/core/alu_sh[1]} -radix octal} {{/tb2/cpu/core/alu_sh[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/alu_sh[15]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[14]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[13]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[12]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[11]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[10]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[9]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[8]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[7]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[6]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[5]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[4]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[3]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[2]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[1]} {-height 15 -radix octal} {/tb2/cpu/core/alu_sh[0]} {-height 15 -radix octal}} /tb2/cpu/core/alu_sh
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/alu_af[15]} -radix octal} {{/tb2/cpu/core/alu_af[14]} -radix octal} {{/tb2/cpu/core/alu_af[13]} -radix octal} {{/tb2/cpu/core/alu_af[12]} -radix octal} {{/tb2/cpu/core/alu_af[11]} -radix octal} {{/tb2/cpu/core/alu_af[10]} -radix octal} {{/tb2/cpu/core/alu_af[9]} -radix octal} {{/tb2/cpu/core/alu_af[8]} -radix octal} {{/tb2/cpu/core/alu_af[7]} -radix octal} {{/tb2/cpu/core/alu_af[6]} -radix octal} {{/tb2/cpu/core/alu_af[5]} -radix octal} {{/tb2/cpu/core/alu_af[4]} -radix octal} {{/tb2/cpu/core/alu_af[3]} -radix octal} {{/tb2/cpu/core/alu_af[2]} -radix octal} {{/tb2/cpu/core/alu_af[1]} -radix octal} {{/tb2/cpu/core/alu_af[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/alu_af[15]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[14]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[13]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[12]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[11]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[10]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[9]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[8]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[7]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[6]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[5]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[4]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[3]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[2]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[1]} {-height 15 -radix octal} {/tb2/cpu/core/alu_af[0]} {-height 15 -radix octal}} /tb2/cpu/core/alu_af
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_cf
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_or
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/alu_an[15]} -radix octal} {{/tb2/cpu/core/alu_an[14]} -radix octal} {{/tb2/cpu/core/alu_an[13]} -radix octal} {{/tb2/cpu/core/alu_an[12]} -radix octal} {{/tb2/cpu/core/alu_an[11]} -radix octal} {{/tb2/cpu/core/alu_an[10]} -radix octal} {{/tb2/cpu/core/alu_an[9]} -radix octal} {{/tb2/cpu/core/alu_an[8]} -radix octal} {{/tb2/cpu/core/alu_an[7]} -radix octal} {{/tb2/cpu/core/alu_an[6]} -radix octal} {{/tb2/cpu/core/alu_an[5]} -radix octal} {{/tb2/cpu/core/alu_an[4]} -radix octal} {{/tb2/cpu/core/alu_an[3]} -radix octal} {{/tb2/cpu/core/alu_an[2]} -radix octal} {{/tb2/cpu/core/alu_an[1]} -radix octal} {{/tb2/cpu/core/alu_an[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/alu_an[15]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[14]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[13]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[12]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[11]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[10]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[9]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[8]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[7]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[6]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[5]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[4]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[3]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[2]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[1]} {-height 15 -radix octal} {/tb2/cpu/core/alu_an[0]} {-height 15 -radix octal}} /tb2/cpu/core/alu_an
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_a
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_b
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_c
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_d
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_e
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_f
add wave -noupdate -group ALU -group aluop -group alu_x /tb2/cpu/core/alu_g
add wave -noupdate -group ALU -group aluop /tb2/cpu/core/alu_cin
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_cp
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_cr
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_fr
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/alu_inx[15]} -radix octal} {{/tb2/cpu/core/alu_inx[14]} -radix octal} {{/tb2/cpu/core/alu_inx[13]} -radix octal} {{/tb2/cpu/core/alu_inx[12]} -radix octal} {{/tb2/cpu/core/alu_inx[11]} -radix octal} {{/tb2/cpu/core/alu_inx[10]} -radix octal} {{/tb2/cpu/core/alu_inx[9]} -radix octal} {{/tb2/cpu/core/alu_inx[8]} -radix octal} {{/tb2/cpu/core/alu_inx[7]} -radix octal} {{/tb2/cpu/core/alu_inx[6]} -radix octal} {{/tb2/cpu/core/alu_inx[5]} -radix octal} {{/tb2/cpu/core/alu_inx[4]} -radix octal} {{/tb2/cpu/core/alu_inx[3]} -radix octal} {{/tb2/cpu/core/alu_inx[2]} -radix octal} {{/tb2/cpu/core/alu_inx[1]} -radix octal} {{/tb2/cpu/core/alu_inx[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/alu_inx[15]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[14]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[13]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[12]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[11]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[10]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[9]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[8]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[7]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[6]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[5]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[4]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[3]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[2]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[1]} {-height 15 -radix octal} {/tb2/cpu/core/alu_inx[0]} {-height 15 -radix octal}} /tb2/cpu/core/alu_inx
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/alu_iny
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/ax[15]} -radix octal} {{/tb2/cpu/core/ax[14]} -radix octal} {{/tb2/cpu/core/ax[13]} -radix octal} {{/tb2/cpu/core/ax[12]} -radix octal} {{/tb2/cpu/core/ax[11]} -radix octal} {{/tb2/cpu/core/ax[10]} -radix octal} {{/tb2/cpu/core/ax[9]} -radix octal} {{/tb2/cpu/core/ax[8]} -radix octal} {{/tb2/cpu/core/ax[7]} -radix octal} {{/tb2/cpu/core/ax[6]} -radix octal} {{/tb2/cpu/core/ax[5]} -radix octal} {{/tb2/cpu/core/ax[4]} -radix octal} {{/tb2/cpu/core/ax[3]} -radix octal} {{/tb2/cpu/core/ax[2]} -radix octal} {{/tb2/cpu/core/ax[1]} -radix octal} {{/tb2/cpu/core/ax[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ax[15]} {-height 15 -radix octal} {/tb2/cpu/core/ax[14]} {-height 15 -radix octal} {/tb2/cpu/core/ax[13]} {-height 15 -radix octal} {/tb2/cpu/core/ax[12]} {-height 15 -radix octal} {/tb2/cpu/core/ax[11]} {-height 15 -radix octal} {/tb2/cpu/core/ax[10]} {-height 15 -radix octal} {/tb2/cpu/core/ax[9]} {-height 15 -radix octal} {/tb2/cpu/core/ax[8]} {-height 15 -radix octal} {/tb2/cpu/core/ax[7]} {-height 15 -radix octal} {/tb2/cpu/core/ax[6]} {-height 15 -radix octal} {/tb2/cpu/core/ax[5]} {-height 15 -radix octal} {/tb2/cpu/core/ax[4]} {-height 15 -radix octal} {/tb2/cpu/core/ax[3]} {-height 15 -radix octal} {/tb2/cpu/core/ax[2]} {-height 15 -radix octal} {/tb2/cpu/core/ax[1]} {-height 15 -radix octal} {/tb2/cpu/core/ax[0]} {-height 15 -radix octal}} /tb2/cpu/core/ax
add wave -noupdate -group ALU -group aluop -radix octal /tb2/cpu/core/x
add wave -noupdate -group ALU -group aluop -radix octal -childformat {{{/tb2/cpu/core/y[15]} -radix octal} {{/tb2/cpu/core/y[14]} -radix octal} {{/tb2/cpu/core/y[13]} -radix octal} {{/tb2/cpu/core/y[12]} -radix octal} {{/tb2/cpu/core/y[11]} -radix octal} {{/tb2/cpu/core/y[10]} -radix octal} {{/tb2/cpu/core/y[9]} -radix octal} {{/tb2/cpu/core/y[8]} -radix octal} {{/tb2/cpu/core/y[7]} -radix octal} {{/tb2/cpu/core/y[6]} -radix octal} {{/tb2/cpu/core/y[5]} -radix octal} {{/tb2/cpu/core/y[4]} -radix octal} {{/tb2/cpu/core/y[3]} -radix octal} {{/tb2/cpu/core/y[2]} -radix octal} {{/tb2/cpu/core/y[1]} -radix octal} {{/tb2/cpu/core/y[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/y[15]} {-height 15 -radix octal} {/tb2/cpu/core/y[14]} {-height 15 -radix octal} {/tb2/cpu/core/y[13]} {-height 15 -radix octal} {/tb2/cpu/core/y[12]} {-height 15 -radix octal} {/tb2/cpu/core/y[11]} {-height 15 -radix octal} {/tb2/cpu/core/y[10]} {-height 15 -radix octal} {/tb2/cpu/core/y[9]} {-height 15 -radix octal} {/tb2/cpu/core/y[8]} {-height 15 -radix octal} {/tb2/cpu/core/y[7]} {-height 15 -radix octal} {/tb2/cpu/core/y[6]} {-height 15 -radix octal} {/tb2/cpu/core/y[5]} {-height 15 -radix octal} {/tb2/cpu/core/y[4]} {-height 15 -radix octal} {/tb2/cpu/core/y[3]} {-height 15 -radix octal} {/tb2/cpu/core/y[2]} {-height 15 -radix octal} {/tb2/cpu/core/y[1]} {-height 15 -radix octal} {/tb2/cpu/core/y[0]} {-height 15 -radix octal}} /tb2/cpu/core/y
add wave -noupdate -group ALU /tb2/cpu/core/ra_fr
add wave -noupdate -group ALU /tb2/cpu/core/ra_fr1
add wave -noupdate -group ALU /tb2/cpu/core/ra_fw
add wave -noupdate -group ALU /tb2/cpu/core/ra_fwn
add wave -noupdate -group ALU /tb2/cpu/core/rn_wa
add wave -noupdate -group ALU /tb2/cpu/core/wr1
add wave -noupdate -group ALU /tb2/cpu/core/wr2
add wave -noupdate -group ALU /tb2/cpu/core/wa_r1
add wave -noupdate -group ALU /tb2/cpu/core/wa_r2
add wave -noupdate -group ALU /tb2/cpu/core/wa
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/en_alu_rc
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_drdy
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_drdy_rc
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_drdy0
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_drdy1
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_rdy
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/io_rdy
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/ra_fr
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/ra_fwn
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/rta
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/rta_fall
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mc_stb
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/mw_stb
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/io_start
add wave -noupdate -group ALU -group ENALU /tb2/cpu/core/iop_stb
add wave -noupdate -group ALU /tb2/cpu/core/alu_nrdy
add wave -noupdate -group ALU /tb2/cpu/core/alu_wr
add wave -noupdate -group ALU -radix octal -childformat {{{/tb2/cpu/core/alu_st[2]} -radix octal} {{/tb2/cpu/core/alu_st[1]} -radix octal} {{/tb2/cpu/core/alu_st[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/alu_st[2]} {-height 15 -radix octal} {/tb2/cpu/core/alu_st[1]} {-height 15 -radix octal} {/tb2/cpu/core/alu_st[0]} {-height 15 -radix octal}} /tb2/cpu/core/alu_st
add wave -noupdate -group ALU /tb2/cpu/core/alu_xb
add wave -noupdate -group ALU /tb2/cpu/core/ra_wa
add wave -noupdate -group ALU /tb2/cpu/core/ra_wx
add wave -noupdate -group ALU /tb2/cpu/core/rd2h
add wave -noupdate -group ALU /tb2/cpu/core/plm_rn
add wave -noupdate -group Branch /tb2/cpu/core/mc_stb
add wave -noupdate -group Branch {/tb2/cpu/core/na[5]}
add wave -noupdate -group Branch {/tb2/cpu/core/na[4]}
add wave -noupdate -group Branch /tb2/cpu/core/plb_matrix/p
add wave -noupdate -group Branch -radix octal -childformat {{{/tb2/cpu/core/br[11]} -radix octal} {{/tb2/cpu/core/br[10]} -radix octal} {{/tb2/cpu/core/br[9]} -radix octal} {{/tb2/cpu/core/br[8]} -radix octal} {{/tb2/cpu/core/br[7]} -radix octal} {{/tb2/cpu/core/br[6]} -radix octal} {{/tb2/cpu/core/br[5]} -radix octal} {{/tb2/cpu/core/br[4]} -radix octal} {{/tb2/cpu/core/br[3]} -radix octal} {{/tb2/cpu/core/br[2]} -radix octal} {{/tb2/cpu/core/br[1]} -radix octal} {{/tb2/cpu/core/br[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/br[11]} {-height 15 -radix octal} {/tb2/cpu/core/br[10]} {-height 15 -radix octal} {/tb2/cpu/core/br[9]} {-height 15 -radix octal} {/tb2/cpu/core/br[8]} {-height 15 -radix octal} {/tb2/cpu/core/br[7]} {-height 15 -radix octal} {/tb2/cpu/core/br[6]} {-height 15 -radix octal} {/tb2/cpu/core/br[5]} {-height 15 -radix octal} {/tb2/cpu/core/br[4]} {-height 15 -radix octal} {/tb2/cpu/core/br[3]} {-height 15 -radix octal} {/tb2/cpu/core/br[2]} {-height 15 -radix octal} {/tb2/cpu/core/br[1]} {-height 15 -radix octal} {/tb2/cpu/core/br[0]} {-height 15 -radix octal}} /tb2/cpu/core/br
add wave -noupdate -group Branch /tb2/cpu/core/bra_req
add wave -noupdate -group Branch /tb2/cpu/core/bra_stb
add wave -noupdate -group Branch /tb2/cpu/core/bra
add wave -noupdate -group Branch /tb2/cpu/core/plb
add wave -noupdate -group Branch /tb2/cpu/core/ws_cend
add wave -noupdate -group Branch /tb2/cpu/core/ws_wait
add wave -noupdate -group EA /tb2/cpu/core/ea_trdy1
add wave -noupdate -group EA /tb2/cpu/core/ea_trdy0
add wave -noupdate -group EA /tb2/cpu/core/ea_trdy0_clr
add wave -noupdate -group EA /tb2/cpu/core/ea_trdy0_set
add wave -noupdate -group EA /tb2/cpu/core/ea_trdy1_clr
add wave -noupdate -group EA /tb2/cpu/core/ea_rdy
add wave -noupdate -group EA /tb2/cpu/core/ea_nrdy
add wave -noupdate -group EA -group ear1 -radix octal -childformat {{{/tb2/cpu/core/ear1[15]} -radix octal} {{/tb2/cpu/core/ear1[14]} -radix octal} {{/tb2/cpu/core/ear1[13]} -radix octal} {{/tb2/cpu/core/ear1[12]} -radix octal} {{/tb2/cpu/core/ear1[11]} -radix octal} {{/tb2/cpu/core/ear1[10]} -radix octal} {{/tb2/cpu/core/ear1[9]} -radix octal} {{/tb2/cpu/core/ear1[8]} -radix octal} {{/tb2/cpu/core/ear1[7]} -radix octal} {{/tb2/cpu/core/ear1[6]} -radix octal} {{/tb2/cpu/core/ear1[5]} -radix octal} {{/tb2/cpu/core/ear1[4]} -radix octal} {{/tb2/cpu/core/ear1[3]} -radix octal} {{/tb2/cpu/core/ear1[2]} -radix octal} {{/tb2/cpu/core/ear1[1]} -radix octal} {{/tb2/cpu/core/ear1[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ear1[15]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[14]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[13]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[12]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[11]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[10]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[9]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[8]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[7]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[6]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[5]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[4]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[3]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[2]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[1]} {-height 15 -radix octal} {/tb2/cpu/core/ear1[0]} {-height 15 -radix octal}} /tb2/cpu/core/ear1
add wave -noupdate -group EA -group ear1 /tb2/cpu/core/ea1_wa
add wave -noupdate -group EA -group ear2 -radix octal /tb2/cpu/core/ear2
add wave -noupdate -group EA -group ear2 /tb2/cpu/core/ea2_wa
add wave -noupdate -group EA -group ea_ct /tb2/cpu/core/ea_f
add wave -noupdate -group EA -group ea_ct /tb2/cpu/core/ea_ctse
add wave -noupdate -group EA -group ea_ct /tb2/cpu/core/ea_ctld
add wave -noupdate -group EA -group ea_ct /tb2/cpu/core/wr2
add wave -noupdate -group EA -group ea_ct -radix octal -childformat {{{/tb2/cpu/core/ea_ct[4]} -radix octal} {{/tb2/cpu/core/ea_ct[3]} -radix octal} {{/tb2/cpu/core/ea_ct[2]} -radix octal} {{/tb2/cpu/core/ea_ct[1]} -radix octal} {{/tb2/cpu/core/ea_ct[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/ea_ct[4]} {-height 15 -radix octal} {/tb2/cpu/core/ea_ct[3]} {-height 15 -radix octal} {/tb2/cpu/core/ea_ct[2]} {-height 15 -radix octal} {/tb2/cpu/core/ea_ct[1]} {-height 15 -radix octal} {/tb2/cpu/core/ea_ct[0]} {-height 15 -radix octal}} /tb2/cpu/core/ea_ct
add wave -noupdate -group EA -group ea_ct /tb2/cpu/core/ea_1t
add wave -noupdate -group EA /tb2/cpu/core/ea_div
add wave -noupdate -group EA /tb2/cpu/core/ea_shl
add wave -noupdate -group EA /tb2/cpu/core/ea_shr
add wave -noupdate -group EA /tb2/cpu/core/ea_shr2
add wave -noupdate -group EA /tb2/cpu/core/ea_vdiv
add wave -noupdate -group EA /tb2/cpu/core/ea_mul
add wave -noupdate -group EA /tb2/cpu/core/wait_div
add wave -noupdate -group EA /tb2/cpu/core/zero_div
add wave -noupdate -group EA /tb2/cpu/core/tlz
add wave -noupdate -group EA -radix octal /tb2/cpu/core/xb
add wave -noupdate -group EA /tb2/cpu/core/dc_i7
add wave -noupdate -group EA /tb2/cpu/core/ea_f4r
add wave -noupdate -group EA /tb2/cpu/core/ea_1t
add wave -noupdate -group EA /tb2/cpu/core/ea_1tm
add wave -noupdate -group EA -group alu_sh /tb2/cpu/core/plm20m
add wave -noupdate -group EA -group alu_sh /tb2/cpu/core/plm19m
add wave -noupdate -group EA -group alu_sh /tb2/cpu/core/plm18m
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 3} {2391353 ps} 0}
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
WaveRestoreZoom {2328173 ps} {3195413 ps}
