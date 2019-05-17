onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tbl/clk
add wave -noupdate /tbl/cpu/c1
add wave -noupdate /tbl/cpu/c2
add wave -noupdate /tbl/cpu/c3
add wave -noupdate /tbl/cpu/c4
add wave -noupdate /tbl/i
add wave -noupdate /tbl/i0
add wave -noupdate /tbl/dclo
add wave -noupdate /tbl/aclo
add wave -noupdate /tbl/evnt
add wave -noupdate /tbl/halt
add wave -noupdate /tbl/virq
add wave -noupdate /tbl/rfrq
add wave -noupdate /tbl/init
add wave -noupdate /tbl/ad_mux
add wave -noupdate /tbl/ad
add wave -noupdate /tbl/ad_reg
add wave -noupdate /tbl/ad_oe
add wave -noupdate /tbl/din
add wave -noupdate /tbl/dout
add wave -noupdate /tbl/wtbt
add wave -noupdate /tbl/sync
add wave -noupdate /tbl/rply
add wave -noupdate /tbl/dmr
add wave -noupdate /tbl/sack
add wave -noupdate /tbl/dmgo
add wave -noupdate /tbl/iako
add wave -noupdate /tbl/dref
add wave -noupdate /tbl/din_iako
add wave -noupdate /tbl/din_sync
add wave -noupdate /tbl/addr
add wave -noupdate /tbl/wflg
add wave -noupdate /tbl/sel_all
add wave -noupdate /tbl/sel_ram
add wave -noupdate /tbl/tty_tx_rdy
add wave -noupdate /tbl/tty_tx_ie
add wave -noupdate /tbl/tty_rx_ie
add wave -noupdate /tbl/ram_read
add wave -noupdate /tbl/ram_write
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {142930 ps} 0}
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
WaveRestoreZoom {0 ps} {942512 ps}
