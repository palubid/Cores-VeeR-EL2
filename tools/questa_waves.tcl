if {$env(debug) == "1"} { \

log -r /*

add wave -position end -divider "TOP"
add wave sim:/tb_top/rvtop_wrapper/rst_l
add wave sim:/tb_top/rvtop_wrapper/clk
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/rst_vec

add wave -position end -divider "TRACE"
add wave sim:/tb_top/trace_rv_i_insn_ip
add wave sim:/tb_top/trace_rv_i_address_ip
add wave sim:/tb_top/trace_rv_i_valid_ip
add wave sim:/tb_top/trace_rv_i_exception_ip
add wave sim:/tb_top/trace_rv_i_ecause_ip
add wave sim:/tb_top/trace_rv_i_interrupt_ip
add wave sim:/tb_top/trace_rv_i_tval_ip

add wave -position end -divider "VEER_DECODE"
add wave -color "orange" sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/npc_r
add wave -color "orange" sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/tlu_flush_path_r 
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/sel_flush_npc_r
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/tlu_flush_path_r_d1
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/sel_hold_npc_r
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/npc_r_d1
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/sel_exu_npc_r
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/exu_npc_r
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/dec/tlu/mpc_reset_run_req

add wave -position end -divider "VEER"
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[0]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[1]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_rw_addr
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_wr_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/ic_rd_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[0]
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[1]
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_tag_inst/ic_rw_addr_ff

configure wave -namecolwidth 450
configure wave -valuecolwidth 200
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 6
configure wave -childrowmargin 4
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns

update

# add schematic  \
#   sim:/tb_top/u_dut/mem_i_inst_i

run -all

view wave
wave zoom full

} else {
  run -all
}