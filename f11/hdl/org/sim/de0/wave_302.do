onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_302/i
add wave -noupdate /tb_302/clk
add wave -noupdate -radix hexadecimal /tb_302/mi
add wave -noupdate -radix hexadecimal /tb_302/ad
add wave -noupdate -radix hexadecimal /tb_302/m
add wave -noupdate /tb_302/ez_n
add wave -noupdate /tb_302/bs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {153 ps} 0}
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
WaveRestoreZoom {6408800 ps} {10504800 ps}
