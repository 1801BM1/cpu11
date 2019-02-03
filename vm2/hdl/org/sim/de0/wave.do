onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group Clock /tb2/clk
add wave -noupdate -group Clock /tb2/clko
add wave -noupdate -group Clock /tb2/cpu/core/f1
add wave -noupdate -group Clock /tb2/cpu/core/f2
add wave -noupdate -group Pins /tb2/ad_oe
add wave -noupdate -group Pins -radix octal /tb2/ad_reg
add wave -noupdate -group Pins -radix octal -childformat {{{/tb2/ad[15]} -radix octal} {{/tb2/ad[14]} -radix octal} {{/tb2/ad[13]} -radix octal} {{/tb2/ad[12]} -radix octal} {{/tb2/ad[11]} -radix octal} {{/tb2/ad[10]} -radix octal} {{/tb2/ad[9]} -radix octal} {{/tb2/ad[8]} -radix octal} {{/tb2/ad[7]} -radix octal} {{/tb2/ad[6]} -radix octal} {{/tb2/ad[5]} -radix octal} {{/tb2/ad[4]} -radix octal} {{/tb2/ad[3]} -radix octal} {{/tb2/ad[2]} -radix octal} {{/tb2/ad[1]} -radix octal} {{/tb2/ad[0]} -radix octal}} -subitemconfig {{/tb2/ad[15]} {-height 15 -radix octal} {/tb2/ad[14]} {-height 15 -radix octal} {/tb2/ad[13]} {-height 15 -radix octal} {/tb2/ad[12]} {-height 15 -radix octal} {/tb2/ad[11]} {-height 15 -radix octal} {/tb2/ad[10]} {-height 15 -radix octal} {/tb2/ad[9]} {-height 15 -radix octal} {/tb2/ad[8]} {-height 15 -radix octal} {/tb2/ad[7]} {-height 15 -radix octal} {/tb2/ad[6]} {-height 15 -radix octal} {/tb2/ad[5]} {-height 15 -radix octal} {/tb2/ad[4]} {-height 15 -radix octal} {/tb2/ad[3]} {-height 15 -radix octal} {/tb2/ad[2]} {-height 15 -radix octal} {/tb2/ad[1]} {-height 15 -radix octal} {/tb2/ad[0]} {-height 15 -radix octal}} /tb2/ad
add wave -noupdate -group Pins /tb2/sync
add wave -noupdate -group Pins /tb2/wtbt
add wave -noupdate -group Pins /tb2/din
add wave -noupdate -group Pins /tb2/rply
add wave -noupdate -group Pins /tb2/iako
add wave -noupdate -group Pins /tb2/clko
add wave -noupdate -group Pins /tb2/aclo
add wave -noupdate -group Pins /tb2/dclo
add wave -noupdate -group Pins /tb2/init
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
add wave -noupdate -group Reset -group aclo /tb2/cpu/core/ac0
add wave -noupdate -group Interrupt -radix octal -childformat {{{/tb2/cpu/core/qr[15]} -radix octal} {{/tb2/cpu/core/qr[14]} -radix octal} {{/tb2/cpu/core/qr[13]} -radix octal} {{/tb2/cpu/core/qr[12]} -radix octal} {{/tb2/cpu/core/qr[11]} -radix octal} {{/tb2/cpu/core/qr[10]} -radix octal} {{/tb2/cpu/core/qr[9]} -radix octal} {{/tb2/cpu/core/qr[8]} -radix octal} {{/tb2/cpu/core/qr[7]} -radix octal} {{/tb2/cpu/core/qr[6]} -radix octal} {{/tb2/cpu/core/qr[5]} -radix octal} {{/tb2/cpu/core/qr[4]} -radix octal} {{/tb2/cpu/core/qr[3]} -radix octal} {{/tb2/cpu/core/qr[2]} -radix octal} {{/tb2/cpu/core/qr[1]} -radix octal} {{/tb2/cpu/core/qr[0]} -radix octal}} -expand -subitemconfig {{/tb2/cpu/core/qr[15]} {-height 15 -radix octal} {/tb2/cpu/core/qr[14]} {-height 15 -radix octal} {/tb2/cpu/core/qr[13]} {-height 15 -radix octal} {/tb2/cpu/core/qr[12]} {-height 15 -radix octal} {/tb2/cpu/core/qr[11]} {-height 15 -radix octal} {/tb2/cpu/core/qr[10]} {-height 15 -radix octal} {/tb2/cpu/core/qr[9]} {-height 15 -radix octal} {/tb2/cpu/core/qr[8]} {-height 15 -radix octal} {/tb2/cpu/core/qr[7]} {-height 15 -radix octal} {/tb2/cpu/core/qr[6]} {-height 15 -radix octal} {/tb2/cpu/core/qr[5]} {-height 15 -radix octal} {/tb2/cpu/core/qr[4]} {-height 15 -radix octal} {/tb2/cpu/core/qr[3]} {-height 15 -radix octal} {/tb2/cpu/core/qr[2]} {-height 15 -radix octal} {/tb2/cpu/core/qr[1]} {-height 15 -radix octal} {/tb2/cpu/core/qr[0]} {-height 15 -radix octal}} /tb2/cpu/core/qr
add wave -noupdate -group Interrupt /tb2/cpu/core/aclo_fall
add wave -noupdate -group Interrupt /tb2/cpu/core/aclo_rise
add wave -noupdate -group Interrupt /tb2/cpu/core/halt
add wave -noupdate -group Interrupt /tb2/cpu/core/virq
add wave -noupdate -group Interrupt /tb2/cpu/core/tovf
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_ack
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_nrdy
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_rclr
add wave -noupdate -group Interrupt /tb2/cpu/core/pli_req
add wave -noupdate -group Interrupt -radix octal -childformat {{{/tb2/cpu/core/pli[9]} -radix octal} {{/tb2/cpu/core/pli[8]} -radix octal} {{/tb2/cpu/core/pli[7]} -radix octal} {{/tb2/cpu/core/pli[6]} -radix octal} {{/tb2/cpu/core/pli[5]} -radix octal} {{/tb2/cpu/core/pli[4]} -radix octal} {{/tb2/cpu/core/pli[3]} -radix octal} {{/tb2/cpu/core/pli[2]} -radix octal} {{/tb2/cpu/core/pli[1]} -radix octal} {{/tb2/cpu/core/pli[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/pli[9]} {-height 15 -radix octal} {/tb2/cpu/core/pli[8]} {-height 15 -radix octal} {/tb2/cpu/core/pli[7]} {-height 15 -radix octal} {/tb2/cpu/core/pli[6]} {-height 15 -radix octal} {/tb2/cpu/core/pli[5]} {-height 15 -radix octal} {/tb2/cpu/core/pli[4]} {-height 15 -radix octal} {/tb2/cpu/core/pli[3]} {-height 15 -radix octal} {/tb2/cpu/core/pli[2]} {-height 15 -radix octal} {/tb2/cpu/core/pli[1]} {-height 15 -radix octal} {/tb2/cpu/core/pli[0]} {-height 15 -radix octal}} /tb2/cpu/core/pli
add wave -noupdate -group Interrupt /tb2/cpu/core/sm0
add wave -noupdate -group Interrupt /tb2/cpu/core/sm1
add wave -noupdate -group Interrupt /tb2/cpu/core/sm2
add wave -noupdate -group Interrupt /tb2/cpu/core/sm3
add wave -noupdate -group PLM /tb2/cpu/core/all_rdy
add wave -noupdate -group PLM /tb2/cpu/core/all_rdy_t0
add wave -noupdate -group PLM /tb2/cpu/core/all_rdy_t1
add wave -noupdate -group PLM /tb2/cpu/core/bus_nrdy
add wave -noupdate -group PLM /tb2/cpu/core/sta_nrdy
add wave -noupdate -group PLM /tb2/cpu/core/cmd_nrdy
add wave -noupdate -group PLM /tb2/cpu/core/pli_nrdy
add wave -noupdate -group PLM /tb2/cpu/core/mc_stb
add wave -noupdate -group PLM /tb2/cpu/core/mw_stb
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/na[5]} -radix octal} {{/tb2/cpu/core/na[4]} -radix octal} {{/tb2/cpu/core/na[3]} -radix octal} {{/tb2/cpu/core/na[2]} -radix octal} {{/tb2/cpu/core/na[1]} -radix octal} {{/tb2/cpu/core/na[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/na[5]} {-height 15 -radix octal} {/tb2/cpu/core/na[4]} {-height 15 -radix octal} {/tb2/cpu/core/na[3]} {-height 15 -radix octal} {/tb2/cpu/core/na[2]} {-height 15 -radix octal} {/tb2/cpu/core/na[1]} {-height 15 -radix octal} {/tb2/cpu/core/na[0]} {-height 15 -radix octal}} /tb2/cpu/core/na
add wave -noupdate -group PLM -radix octal /tb2/cpu/core/ia
add wave -noupdate -group PLM -radix octal /tb2/cpu/core/pla
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/plm[30]} -radix octal} {{/tb2/cpu/core/plm[29]} -radix octal} {{/tb2/cpu/core/plm[28]} -radix octal} {{/tb2/cpu/core/plm[27]} -radix octal} {{/tb2/cpu/core/plm[26]} -radix octal} {{/tb2/cpu/core/plm[25]} -radix octal} {{/tb2/cpu/core/plm[24]} -radix octal} {{/tb2/cpu/core/plm[23]} -radix octal} {{/tb2/cpu/core/plm[22]} -radix octal} {{/tb2/cpu/core/plm[21]} -radix octal} {{/tb2/cpu/core/plm[20]} -radix octal} {{/tb2/cpu/core/plm[19]} -radix octal} {{/tb2/cpu/core/plm[18]} -radix octal} {{/tb2/cpu/core/plm[17]} -radix octal} {{/tb2/cpu/core/plm[16]} -radix octal} {{/tb2/cpu/core/plm[15]} -radix octal} {{/tb2/cpu/core/plm[14]} -radix octal} {{/tb2/cpu/core/plm[13]} -radix octal} {{/tb2/cpu/core/plm[12]} -radix octal} {{/tb2/cpu/core/plm[11]} -radix octal} {{/tb2/cpu/core/plm[10]} -radix octal} {{/tb2/cpu/core/plm[9]} -radix octal} {{/tb2/cpu/core/plm[8]} -radix octal} {{/tb2/cpu/core/plm[7]} -radix octal} {{/tb2/cpu/core/plm[6]} -radix octal} {{/tb2/cpu/core/plm[5]} -radix octal} {{/tb2/cpu/core/plm[4]} -radix octal} {{/tb2/cpu/core/plm[3]} -radix octal} {{/tb2/cpu/core/plm[2]} -radix octal} {{/tb2/cpu/core/plm[1]} -radix octal} {{/tb2/cpu/core/plm[0]} -radix octal}} -subitemconfig {{/tb2/cpu/core/plm[30]} {-height 15 -radix octal} {/tb2/cpu/core/plm[29]} {-height 15 -radix octal} {/tb2/cpu/core/plm[28]} {-height 15 -radix octal} {/tb2/cpu/core/plm[27]} {-height 15 -radix octal} {/tb2/cpu/core/plm[26]} {-height 15 -radix octal} {/tb2/cpu/core/plm[25]} {-height 15 -radix octal} {/tb2/cpu/core/plm[24]} {-height 15 -radix octal} {/tb2/cpu/core/plm[23]} {-height 15 -radix octal} {/tb2/cpu/core/plm[22]} {-height 15 -radix octal} {/tb2/cpu/core/plm[21]} {-height 15 -radix octal} {/tb2/cpu/core/plm[20]} {-height 15 -radix octal} {/tb2/cpu/core/plm[19]} {-height 15 -radix octal} {/tb2/cpu/core/plm[18]} {-height 15 -radix octal} {/tb2/cpu/core/plm[17]} {-height 15 -radix octal} {/tb2/cpu/core/plm[16]} {-height 15 -radix octal} {/tb2/cpu/core/plm[15]} {-height 15 -radix octal} {/tb2/cpu/core/plm[14]} {-height 15 -radix octal} {/tb2/cpu/core/plm[13]} {-height 15 -radix octal} {/tb2/cpu/core/plm[12]} {-height 15 -radix octal} {/tb2/cpu/core/plm[11]} {-height 15 -radix octal} {/tb2/cpu/core/plm[10]} {-height 15 -radix octal} {/tb2/cpu/core/plm[9]} {-height 15 -radix octal} {/tb2/cpu/core/plm[8]} {-height 15 -radix octal} {/tb2/cpu/core/plm[7]} {-height 15 -radix octal} {/tb2/cpu/core/plm[6]} {-height 15 -radix octal} {/tb2/cpu/core/plm[5]} {-height 15 -radix octal} {/tb2/cpu/core/plm[4]} {-height 15 -radix octal} {/tb2/cpu/core/plm[3]} {-height 15 -radix octal} {/tb2/cpu/core/plm[2]} {-height 15 -radix octal} {/tb2/cpu/core/plm[1]} {-height 15 -radix octal} {/tb2/cpu/core/plm[0]} {-height 15 -radix octal}} /tb2/cpu/core/plm
add wave -noupdate -group PLM /tb2/cpu/core/plm_wt
add wave -noupdate -group PLM -radix octal -childformat {{{/tb2/cpu/core/plr[30]} -radix octal} {{/tb2/cpu/core/plr[29]} -radix octal} {{/tb2/cpu/core/plr[28]} -radix octal} {{/tb2/cpu/core/plr[27]} -radix octal} {{/tb2/cpu/core/plr[26]} -radix octal} {{/tb2/cpu/core/plr[25]} -radix octal} {{/tb2/cpu/core/plr[24]} -radix octal} {{/tb2/cpu/core/plr[23]} -radix octal} {{/tb2/cpu/core/plr[22]} -radix octal} {{/tb2/cpu/core/plr[21]} -radix octal} {{/tb2/cpu/core/plr[20]} -radix octal} {{/tb2/cpu/core/plr[19]} -radix octal} {{/tb2/cpu/core/plr[18]} -radix octal} {{/tb2/cpu/core/plr[17]} -radix octal} {{/tb2/cpu/core/plr[16]} -radix octal} {{/tb2/cpu/core/plr[15]} -radix octal} {{/tb2/cpu/core/plr[14]} -radix octal} {{/tb2/cpu/core/plr[13]} -radix octal} {{/tb2/cpu/core/plr[12]} -radix octal} {{/tb2/cpu/core/plr[11]} -radix octal} {{/tb2/cpu/core/plr[10]} -radix octal} {{/tb2/cpu/core/plr[9]} -radix octal} {{/tb2/cpu/core/plr[8]} -radix octal}} -subitemconfig {{/tb2/cpu/core/plr[30]} {-height 15 -radix octal} {/tb2/cpu/core/plr[29]} {-height 15 -radix octal} {/tb2/cpu/core/plr[28]} {-height 15 -radix octal} {/tb2/cpu/core/plr[27]} {-height 15 -radix octal} {/tb2/cpu/core/plr[26]} {-height 15 -radix octal} {/tb2/cpu/core/plr[25]} {-height 15 -radix octal} {/tb2/cpu/core/plr[24]} {-height 15 -radix octal} {/tb2/cpu/core/plr[23]} {-height 15 -radix octal} {/tb2/cpu/core/plr[22]} {-height 15 -radix octal} {/tb2/cpu/core/plr[21]} {-height 15 -radix octal} {/tb2/cpu/core/plr[20]} {-height 15 -radix octal} {/tb2/cpu/core/plr[19]} {-height 15 -radix octal} {/tb2/cpu/core/plr[18]} {-height 15 -radix octal} {/tb2/cpu/core/plr[17]} {-height 15 -radix octal} {/tb2/cpu/core/plr[16]} {-height 15 -radix octal} {/tb2/cpu/core/plr[15]} {-height 15 -radix octal} {/tb2/cpu/core/plr[14]} {-height 15 -radix octal} {/tb2/cpu/core/plr[13]} {-height 15 -radix octal} {/tb2/cpu/core/plr[12]} {-height 15 -radix octal} {/tb2/cpu/core/plr[11]} {-height 15 -radix octal} {/tb2/cpu/core/plr[10]} {-height 15 -radix octal} {/tb2/cpu/core/plr[9]} {-height 15 -radix octal} {/tb2/cpu/core/plr[8]} {-height 15 -radix octal}} /tb2/cpu/core/plr
add wave -noupdate -group PLM /tb2/cpu/core/plb
add wave -noupdate -group PLM -radix octal /tb2/cpu/core/pld
add wave -noupdate -group PLM /tb2/cpu/core/sa1
add wave -noupdate -group PLM /tb2/cpu/core/sa2
add wave -noupdate -group PLM -radix octal /tb2/cpu/core/ireg
add wave -noupdate -group PLM /tb2/cpu/core/ix
add wave -noupdate -group PLM -radix octal /tb2/cpu/core/ri
add wave -noupdate -group State /tb2/cpu/core/alu_st
add wave -noupdate -group State /tb2/cpu/core/sb0
add wave -noupdate -group State /tb2/cpu/core/sb1
add wave -noupdate -group State /tb2/cpu/core/en_alu
add wave -noupdate -group State /tb2/cpu/core/mc_drdy
add wave -noupdate -group State /tb2/cpu/core/mc_drdy0
add wave -noupdate -group State /tb2/cpu/core/mc_drdy1
add wave -noupdate -group State /tb2/cpu/core/bus_rdy
add wave -noupdate -group State /tb2/cpu/core/io_rdy
add wave -noupdate -group State /tb2/cpu/core/ea_rdy
add wave -noupdate -group State /tb2/cpu/core/ra_fr
add wave -noupdate -group State /tb2/cpu/core/ra_fr1
add wave -noupdate -group State /tb2/cpu/core/ra_fr2
add wave -noupdate -group State /tb2/cpu/core/ra_fw
add wave -noupdate -group State /tb2/cpu/core/ra_fwn
add wave -noupdate -group State /tb2/cpu/core/rta
add wave -noupdate -group State /tb2/cpu/core/rta_fall
add wave -noupdate -group Perstb /tb2/cpu/core/pi_stb
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48091 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 52
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
WaveRestoreZoom {0 ps} {1120208 ps}
