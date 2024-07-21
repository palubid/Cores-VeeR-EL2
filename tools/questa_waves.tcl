#add wave sim:/tb_top/rvtop/veer/core_rst_l
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/rst_vec
add wave sim:/tb_top/trace_rv_i_insn_ip
add wave sim:/tb_top/trace_rv_i_address_ip
add wave sim:/tb_top/trace_rv_i_valid_ip
add wave sim:/tb_top/trace_rv_i_exception_ip
add wave sim:/tb_top/trace_rv_i_ecause_ip
add wave sim:/tb_top/trace_rv_i_interrupt_ip
add wave sim:/tb_top/trace_rv_i_tval_ip

add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[0]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[1]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_rw_addr
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_wr_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/ic_rd_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[0]
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[1]
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_tag_inst/ic_rw_addr_ff
run -all