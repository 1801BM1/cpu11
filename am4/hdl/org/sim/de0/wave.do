onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Clock /tb4/cpu/pin_clk
add wave -noupdate -expand -group Clock /tb4/cpu/mclk
add wave -noupdate -expand -group Clock /tb4/cpu/gclk
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_60
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_105
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_135
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_wait
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_en
add wave -noupdate -expand -group Clock /tb4/cpu/gclk_en0
add wave -noupdate -expand -group Clock /tb4/cpu/tclk
add wave -noupdate -expand -group Clock /tb4/cpu/tclk_en
add wave -noupdate -expand -group Clock /tb4/cpu/tclk_en0
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2039775 ps} 0}
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
WaveRestoreZoom {0 ps} {4665040 ps}
