onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbl/clk
add wave -noupdate -expand -group clocks /tbl/cpu/c1
add wave -noupdate -expand -group clocks /tbl/cpu/c2
add wave -noupdate -expand -group clocks /tbl/cpu/c3
add wave -noupdate -expand -group clocks /tbl/cpu/c4
add wave -noupdate -group tbench /tbl/addr
add wave -noupdate -group tbench /tbl/ad_reg
add wave -noupdate -group tbench /tbl/ad_mux
add wave -noupdate -group tbench /tbl/ad_oe
add wave -noupdate -group tbench /tbl/wflg
add wave -noupdate -group tbench /tbl/sel_all
add wave -noupdate -group tbench /tbl/sel_ram
add wave -noupdate -group tbench /tbl/tty_tx_rdy
add wave -noupdate -group tbench /tbl/tty_tx_ie
add wave -noupdate -group tbench /tbl/tty_rx_ie
add wave -noupdate -group tbench /tbl/ram_read
add wave -noupdate -group tbench /tbl/ram_write
add wave -noupdate -group tbench -group qbus /tbl/ad
add wave -noupdate -group tbench -group qbus /tbl/sync
add wave -noupdate -group tbench -group qbus /tbl/rply
add wave -noupdate -group tbench -group qbus /tbl/din
add wave -noupdate -group tbench -group qbus /tbl/dout
add wave -noupdate -group tbench -group qbus /tbl/iako
add wave -noupdate -group tbench -group qbus /tbl/wtbt
add wave -noupdate -group tbench -group qbus -group irqs /tbl/dref
add wave -noupdate -group tbench -group qbus -group irqs /tbl/dclo
add wave -noupdate -group tbench -group qbus -group irqs /tbl/aclo
add wave -noupdate -group tbench -group qbus -group irqs /tbl/evnt
add wave -noupdate -group tbench -group qbus -group irqs /tbl/halt
add wave -noupdate -group tbench -group qbus -group irqs /tbl/virq
add wave -noupdate -group tbench -group qbus -group irqs /tbl/rfrq
add wave -noupdate -group tbench -group qbus -group irqs /tbl/init
add wave -noupdate -group tbench -group qbus -group share /tbl/dmr
add wave -noupdate -group tbench -group qbus -group share /tbl/sack
add wave -noupdate -group tbench -group qbus -group share /tbl/dmgo
add wave -noupdate -group tbench -group qbus -group share /tbl/din_iako
add wave -noupdate -group tbench -group qbus -group share /tbl/din_sync
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_ad
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_bbusy
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_di
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_do
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_inrak
add wave -noupdate -expand -group lsi -group micro -expand /tbl/cpu/m_inrrq
add wave -noupdate -expand -group lsi -group micro -radix octal -childformat {{{/tbl/cpu/m_n[21]} -radix octal} {{/tbl/cpu/m_n[20]} -radix octal} {{/tbl/cpu/m_n[19]} -radix octal} {{/tbl/cpu/m_n[18]} -radix octal} {{/tbl/cpu/m_n[17]} -radix octal} {{/tbl/cpu/m_n[16]} -radix octal} {{/tbl/cpu/m_n[15]} -radix octal} {{/tbl/cpu/m_n[14]} -radix octal} {{/tbl/cpu/m_n[13]} -radix octal} {{/tbl/cpu/m_n[12]} -radix octal} {{/tbl/cpu/m_n[11]} -radix octal} {{/tbl/cpu/m_n[10]} -radix octal} {{/tbl/cpu/m_n[9]} -radix octal} {{/tbl/cpu/m_n[8]} -radix octal} {{/tbl/cpu/m_n[7]} -radix octal} {{/tbl/cpu/m_n[6]} -radix octal} {{/tbl/cpu/m_n[5]} -radix octal} {{/tbl/cpu/m_n[4]} -radix octal} {{/tbl/cpu/m_n[3]} -radix octal} {{/tbl/cpu/m_n[2]} -radix octal} {{/tbl/cpu/m_n[1]} -radix octal} {{/tbl/cpu/m_n[0]} -radix octal}} -expand -subitemconfig {{/tbl/cpu/m_n[21]} {-radix octal} {/tbl/cpu/m_n[20]} {-radix octal} {/tbl/cpu/m_n[19]} {-radix octal} {/tbl/cpu/m_n[18]} {-radix octal} {/tbl/cpu/m_n[17]} {-radix octal} {/tbl/cpu/m_n[16]} {-radix octal} {/tbl/cpu/m_n[15]} {-radix octal} {/tbl/cpu/m_n[14]} {-radix octal} {/tbl/cpu/m_n[13]} {-radix octal} {/tbl/cpu/m_n[12]} {-radix octal} {/tbl/cpu/m_n[11]} {-radix octal} {/tbl/cpu/m_n[10]} {-radix octal} {/tbl/cpu/m_n[9]} {-radix octal} {/tbl/cpu/m_n[8]} {-radix octal} {/tbl/cpu/m_n[7]} {-radix octal} {/tbl/cpu/m_n[6]} {-radix octal} {/tbl/cpu/m_n[5]} {-radix octal} {/tbl/cpu/m_n[4]} {-radix octal} {/tbl/cpu/m_n[3]} {-radix octal} {/tbl/cpu/m_n[2]} {-radix octal} {/tbl/cpu/m_n[1]} {-radix octal} {/tbl/cpu/m_n[0]} {-radix octal}} /tbl/cpu/m_n
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_ra
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_sr_n
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_syn
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_wi
add wave -noupdate -expand -group lsi -group micro /tbl/cpu/m_wrby
add wave -noupdate -expand -group lsi -group pins /tbl/cpu/pin_clk
add wave -noupdate -expand -group lsi -group pins -group qbus -radix octal /tbl/cpu/pin_ad_n
add wave -noupdate -expand -group lsi -group pins -group qbus -radix octal /tbl/cpu/pin_ad_out
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_ad_ena
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_sync_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_rply_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_din_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_dout_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_iako_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_wtbt_n
add wave -noupdate -expand -group lsi -group pins -group qbus /tbl/cpu/pin_dref_n
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_ctrl_ena
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_sync_out
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_din_out
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_dout_out
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_wtbt_out
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_dmgo_n
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_dmr_n
add wave -noupdate -expand -group lsi -group pins -group share /tbl/cpu/pin_sack_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_evnt_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_halt_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_rfrq_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_init_ena
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_init_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_virq_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_bsel
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_dclo_n
add wave -noupdate -expand -group lsi -group pins -group control /tbl/cpu/pin_aclo_n
add wave -noupdate -expand -group lsi -group reset /tbl/cpu/aclo
add wave -noupdate -expand -group lsi -group reset /tbl/cpu/dclo
add wave -noupdate -expand -group lsi -group ints /tbl/cpu/virq
add wave -noupdate -expand -group lsi -group ints /tbl/cpu/evnt
add wave -noupdate -expand -group lsi -group ints /tbl/cpu/evnt_rq
add wave -noupdate -expand -group lsi -group ints /tbl/cpu/aclo_rq
add wave -noupdate -expand -group lsi -group ints /tbl/cpu/berr_rq
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_clr_aclo
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_clr_berr
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_clr_evnt
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_clr_init
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_res
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_set_fdin
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_set_init
add wave -noupdate -expand -group lsi -group mc_ext /tbl/cpu/mc_set_rfsh
add wave -noupdate -expand -group ctrl /tbl/cpu/control/sr
add wave -noupdate -expand -group ctrl /tbl/cpu/control/sr_c1
add wave -noupdate -expand -group ctrl /tbl/cpu/control/sr_c4
add wave -noupdate -expand -group ctrl /tbl/cpu/control/sr_t0074
add wave -noupdate -expand -group ctrl /tbl/cpu/control/sr_t0185
add wave -noupdate -expand -group ctrl /tbl/cpu/control/wi
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {232550 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 252
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
WaveRestoreZoom {0 ps} {2164282 ps}
