onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/i_io_ctrl/sw_i(15)
add wave -noupdate /top/sw_db(15)
add wave -noupdate /top/reset_i
add wave -noupdate /top/clk_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {254449 ns} {255451 ns}
