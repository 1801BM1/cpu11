onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb3/cpu/pin_clk
add wave -noupdate -group tb -group tb_qbus -radix octal -childformat {{{/tb3/cpu/pin_ad_n[15]} -radix octal} {{/tb3/cpu/pin_ad_n[14]} -radix octal} {{/tb3/cpu/pin_ad_n[13]} -radix octal} {{/tb3/cpu/pin_ad_n[12]} -radix octal} {{/tb3/cpu/pin_ad_n[11]} -radix octal} {{/tb3/cpu/pin_ad_n[10]} -radix octal} {{/tb3/cpu/pin_ad_n[9]} -radix octal} {{/tb3/cpu/pin_ad_n[8]} -radix octal} {{/tb3/cpu/pin_ad_n[7]} -radix octal} {{/tb3/cpu/pin_ad_n[6]} -radix octal} {{/tb3/cpu/pin_ad_n[5]} -radix octal} {{/tb3/cpu/pin_ad_n[4]} -radix octal} {{/tb3/cpu/pin_ad_n[3]} -radix octal} {{/tb3/cpu/pin_ad_n[2]} -radix octal} {{/tb3/cpu/pin_ad_n[1]} -radix octal} {{/tb3/cpu/pin_ad_n[0]} -radix octal}} -subitemconfig {{/tb3/cpu/pin_ad_n[15]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[14]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[13]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[12]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[11]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[10]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[9]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[8]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[7]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[6]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[5]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[4]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[3]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[2]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[1]} {-height 15 -radix octal} {/tb3/cpu/pin_ad_n[0]} {-height 15 -radix octal}} /tb3/cpu/pin_ad_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_sync_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_din_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_dout_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_rply_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_wtbt_n
add wave -noupdate -group tb -group tb_qbus /tb3/cpu/pin_bs_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_dclo_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_aclo_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_init_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_iako_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_halt_n
add wave -noupdate -group tb -group tb_other -group tb_ints -radix octal /tb3/cpu/pin_virq_n
add wave -noupdate -group tb -group tb_other -group tb_ints /tb3/cpu/pin_evnt_n
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_ssync_n
add wave -noupdate -group tb -group tb_other -group tb_abus -radix octal /tb3/cpu/pin_a_n
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_a_ena
add wave -noupdate -group tb -group tb_other -group tb_abus -radix octal /tb3/cpu/pin_ad_out
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_ad_ena
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_ctrl_ena
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_dmgo_n
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_dmr_n
add wave -noupdate -group tb -group tb_other -group tb_abus /tb3/cpu/pin_sack_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_umap_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_ta_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_wo_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_et_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_drdy_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_hltm_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_sel_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_lin_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_fd_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_fl_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_frdy_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_ftrp_n
add wave -noupdate -group tb -group tb_other -group tb_ctrl /tb3/cpu/pin_ftrp_out
add wave -noupdate -group reset /tb3/cpu/core/abort
add wave -noupdate -group reset /tb3/cpu/core/abort_l
add wave -noupdate -group reset /tb3/cpu/core/abort_lh
add wave -noupdate -group reset /tb3/cpu/core/abort_lhl
add wave -noupdate -group reset /tb3/cpu/core/mc_res
add wave -noupdate -group reset /tb3/cpu/core/mc_res_l
add wave -noupdate -group reset /tb3/cpu/core/dclo
add wave -noupdate -group mc -radix hexadecimal -childformat {{{/tb3/cpu/core/ma[7]} -radix hexadecimal} {{/tb3/cpu/core/ma[6]} -radix hexadecimal} {{/tb3/cpu/core/ma[5]} -radix hexadecimal} {{/tb3/cpu/core/ma[4]} -radix hexadecimal} {{/tb3/cpu/core/ma[3]} -radix hexadecimal} {{/tb3/cpu/core/ma[2]} -radix hexadecimal} {{/tb3/cpu/core/ma[1]} -radix hexadecimal} {{/tb3/cpu/core/ma[0]} -radix hexadecimal}} -subitemconfig {{/tb3/cpu/core/ma[7]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[6]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[5]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[4]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[3]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[2]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[1]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/ma[0]} {-height 15 -radix hexadecimal}} /tb3/cpu/core/ma
add wave -noupdate -group mc -radix hexadecimal -childformat {{{/tb3/cpu/core/na[7]} -radix hexadecimal} {{/tb3/cpu/core/na[6]} -radix hexadecimal} {{/tb3/cpu/core/na[5]} -radix hexadecimal} {{/tb3/cpu/core/na[4]} -radix hexadecimal} {{/tb3/cpu/core/na[3]} -radix hexadecimal} {{/tb3/cpu/core/na[2]} -radix hexadecimal} {{/tb3/cpu/core/na[1]} -radix hexadecimal} {{/tb3/cpu/core/na[0]} -radix hexadecimal}} -subitemconfig {{/tb3/cpu/core/na[7]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[6]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[5]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[4]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[3]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[2]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[1]} {-height 15 -radix hexadecimal} {/tb3/cpu/core/na[0]} {-height 15 -radix hexadecimal}} /tb3/cpu/core/na
add wave -noupdate -group mc /tb3/cpu/core/ma_lat
add wave -noupdate -group mc /tb3/cpu/core/ma_ldr
add wave -noupdate -group mc /tb3/cpu/core/ma_ldr_t
add wave -noupdate -group mc /tb3/cpu/core/m0_clr
add wave -noupdate -group mc /tb3/cpu/core/m0_set
add wave -noupdate -group mc -radix hexadecimal /tb3/cpu/core/m8_in
add wave -noupdate -group qbus /tb3/cpu/core/sync
add wave -noupdate -group qbus /tb3/cpu/core/sync_t
add wave -noupdate -group qbus /tb3/cpu/core/rmsel
add wave -noupdate -group qbus -radix octal /tb3/cpu/core/ad
add wave -noupdate -group qbus -expand -group pa_oe /tb3/cpu/core/pa_oe
add wave -noupdate -group qbus -expand -group pa_oe /tb3/cpu/core/pa_oe_clr
add wave -noupdate -group qbus -expand -group pa_oe /tb3/cpu/core/pa_oe_set
add wave -noupdate -group qbus -expand -group pa_oe /tb3/cpu/core/pa_oe_l
add wave -noupdate -group qbus -expand -group pa_oe /tb3/cpu/core/pa_oe_t
add wave -noupdate -group qbus -expand -group dmr /tb3/cpu/core/bus_free
add wave -noupdate -group qbus -expand -group dmr /tb3/cpu/core/dmr
add wave -noupdate -group qbus -expand -group dmr /tb3/cpu/core/dmr_en
add wave -noupdate -group qbus -expand -group rply /tb3/cpu/core/rply
add wave -noupdate -group qbus -expand -group rply /tb3/cpu/core/rply_in
add wave -noupdate -group qbus -expand -group rply /tb3/cpu/core/irply
add wave -noupdate /tb3/cpu/core/pf_init
add wave -noupdate /tb3/cpu/core/lin_en
add wave -noupdate -radix octal /tb3/cpu/core/pl
add wave -noupdate -radix octal -childformat {{{/tb3/cpu/core/plr[37]} -radix octal} {{/tb3/cpu/core/plr[36]} -radix octal} {{/tb3/cpu/core/plr[35]} -radix octal} {{/tb3/cpu/core/plr[34]} -radix octal} {{/tb3/cpu/core/plr[33]} -radix octal} {{/tb3/cpu/core/plr[32]} -radix octal} {{/tb3/cpu/core/plr[31]} -radix octal} {{/tb3/cpu/core/plr[30]} -radix octal} {{/tb3/cpu/core/plr[29]} -radix octal} {{/tb3/cpu/core/plr[28]} -radix octal} {{/tb3/cpu/core/plr[27]} -radix octal} {{/tb3/cpu/core/plr[26]} -radix octal} {{/tb3/cpu/core/plr[25]} -radix octal} {{/tb3/cpu/core/plr[24]} -radix octal} {{/tb3/cpu/core/plr[23]} -radix octal} {{/tb3/cpu/core/plr[22]} -radix octal} {{/tb3/cpu/core/plr[21]} -radix octal} {{/tb3/cpu/core/plr[20]} -radix octal} {{/tb3/cpu/core/plr[19]} -radix octal} {{/tb3/cpu/core/plr[18]} -radix octal} {{/tb3/cpu/core/plr[17]} -radix octal} {{/tb3/cpu/core/plr[16]} -radix octal} {{/tb3/cpu/core/plr[15]} -radix octal} {{/tb3/cpu/core/plr[14]} -radix octal} {{/tb3/cpu/core/plr[13]} -radix octal} {{/tb3/cpu/core/plr[12]} -radix octal} {{/tb3/cpu/core/plr[11]} -radix octal} {{/tb3/cpu/core/plr[10]} -radix octal} {{/tb3/cpu/core/plr[9]} -radix octal} {{/tb3/cpu/core/plr[8]} -radix octal}} -subitemconfig {{/tb3/cpu/core/plr[37]} {-height 15 -radix octal} {/tb3/cpu/core/plr[36]} {-height 15 -radix octal} {/tb3/cpu/core/plr[35]} {-height 15 -radix octal} {/tb3/cpu/core/plr[34]} {-height 15 -radix octal} {/tb3/cpu/core/plr[33]} {-height 15 -radix octal} {/tb3/cpu/core/plr[32]} {-height 15 -radix octal} {/tb3/cpu/core/plr[31]} {-height 15 -radix octal} {/tb3/cpu/core/plr[30]} {-height 15 -radix octal} {/tb3/cpu/core/plr[29]} {-height 15 -radix octal} {/tb3/cpu/core/plr[28]} {-height 15 -radix octal} {/tb3/cpu/core/plr[27]} {-height 15 -radix octal} {/tb3/cpu/core/plr[26]} {-height 15 -radix octal} {/tb3/cpu/core/plr[25]} {-height 15 -radix octal} {/tb3/cpu/core/plr[24]} {-height 15 -radix octal} {/tb3/cpu/core/plr[23]} {-height 15 -radix octal} {/tb3/cpu/core/plr[22]} {-height 15 -radix octal} {/tb3/cpu/core/plr[21]} {-height 15 -radix octal} {/tb3/cpu/core/plr[20]} {-height 15 -radix octal} {/tb3/cpu/core/plr[19]} {-height 15 -radix octal} {/tb3/cpu/core/plr[18]} {-height 15 -radix octal} {/tb3/cpu/core/plr[17]} {-height 15 -radix octal} {/tb3/cpu/core/plr[16]} {-height 15 -radix octal} {/tb3/cpu/core/plr[15]} {-height 15 -radix octal} {/tb3/cpu/core/plr[14]} {-height 15 -radix octal} {/tb3/cpu/core/plr[13]} {-height 15 -radix octal} {/tb3/cpu/core/plr[12]} {-height 15 -radix octal} {/tb3/cpu/core/plr[11]} {-height 15 -radix octal} {/tb3/cpu/core/plr[10]} {-height 15 -radix octal} {/tb3/cpu/core/plr[9]} {-height 15 -radix octal} {/tb3/cpu/core/plr[8]} {-height 15 -radix octal}} /tb3/cpu/core/plr
add wave -noupdate -radix octal /tb3/cpu/core/plm
add wave -noupdate /tb3/cpu/core/plr_rdy
add wave -noupdate /tb3/cpu/core/plr_lat
add wave -noupdate /tb3/cpu/core/plm_lat
add wave -noupdate /tb3/cpu/core/plr_clr
add wave -noupdate /tb3/cpu/core/plr_lat_t
add wave -noupdate /tb3/cpu/core/plm_lat_t
add wave -noupdate /tb3/cpu/core/plm_en
add wave -noupdate /tb3/cpu/core/plm_en_h
add wave -noupdate /tb3/cpu/core/plm_set0
add wave -noupdate /tb3/cpu/core/plm_set1
add wave -noupdate /tb3/cpu/core/ardy_st
add wave -noupdate /tb3/cpu/core/alu_rdy
add wave -noupdate /tb3/cpu/core/alu_run
add wave -noupdate /tb3/cpu/core/alu_plm
add wave -noupdate /tb3/cpu/core/alu_stb
add wave -noupdate /tb3/cpu/core/alu_ea
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {230548 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 262
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
WaveRestoreZoom {0 ps} {1897242 ps}
