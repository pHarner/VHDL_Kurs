onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/s_clk_i
add wave -noupdate /tb_top/s_reset_i
add wave -noupdate /tb_top/s_sw_i
add wave -noupdate /tb_top/s_btnu_i
add wave -noupdate /tb_top/s_btnd_i
add wave -noupdate /tb_top/s_btnl_i
add wave -noupdate /tb_top/s_btnr_i
add wave -noupdate /tb_top/s_ss_o
add wave -noupdate /tb_top/s_ss_anode_o
add wave -noupdate /tb_top/DUT/sw_i
add wave -noupdate /tb_top/DUT/ss_o
add wave -noupdate /tb_top/DUT/ss_anode_o
add wave -noupdate /tb_top/DUT/s_pb
add wave -noupdate /tb_top/DUT/s_cntr_1
add wave -noupdate /tb_top/DUT/s_cntr_10
add wave -noupdate /tb_top/DUT/s_cntr_100
add wave -noupdate /tb_top/DUT/s_cntr_1000
add wave -noupdate /tb_top/DUT/s_cntr_hold
add wave -noupdate /tb_top/DUT/s_cntr_reset
add wave -noupdate /tb_top/DUT/s_cntr_up
add wave -noupdate /tb_top/DUT/s_cntr_down
add wave -noupdate /tb_top/DUT/s_cntr_mode
add wave -noupdate /tb_top/DUT/s_cntr_speed
add wave -noupdate /tb_top/DUT/i_io_ctrl/sw_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/pb_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/ss_o
add wave -noupdate /tb_top/DUT/i_io_ctrl/ss_anode_o
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_1_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_10_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_100_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_1000_i
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_mode_o
add wave -noupdate /tb_top/DUT/i_io_ctrl/cntr_speed_o
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_sw_sync
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_pb_sync
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_hold
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_reset
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_up
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_down
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_mode
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_mode_old
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_speed
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_cntr_speed_old
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_ss_anode
add wave -noupdate /tb_top/DUT/i_io_ctrl/s_ss_digit
add wave -noupdate /tb_top/DUT/i_counter/cntr_1_o
add wave -noupdate /tb_top/DUT/i_counter/cntr_10_o
add wave -noupdate /tb_top/DUT/i_counter/cntr_100_o
add wave -noupdate /tb_top/DUT/i_counter/cntr_1000_o
add wave -noupdate /tb_top/DUT/i_counter/cntr_mode_i
add wave -noupdate /tb_top/DUT/i_counter/cntr_speed_i
add wave -noupdate /tb_top/DUT/i_counter/s_counter_period_max
add wave -noupdate /tb_top/DUT/i_counter/s_counter_period_cnt
add wave -noupdate /tb_top/DUT/i_counter/s_counter_en
add wave -noupdate /tb_top/DUT/i_counter/s_counter_max
add wave -noupdate /tb_top/DUT/i_counter/s_counter_1_val
add wave -noupdate /tb_top/DUT/i_counter/s_counter_10_val
add wave -noupdate /tb_top/DUT/i_counter/s_counter_100_val
add wave -noupdate /tb_top/DUT/i_counter/s_counter_1000_val
add wave -noupdate /tb_top/DUT/i_counter/clk_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 300
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
WaveRestoreZoom {1 ns} {3 ns}
