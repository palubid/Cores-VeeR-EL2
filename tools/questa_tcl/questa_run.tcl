# Questa TCL script to run simulation and plot signals

# Load AXI plot procedure
source $env(RV_ROOT)/tools/questa_tcl/axi_plot.tcl

if {$env(debug) == "1"} { \

# Set up waveform
log -r /*

# Top-level signals
add wave -position end -divider "TOP"
add wave sim:/tb_top/rvtop_wrapper/rst_l
add wave sim:/tb_top/rvtop_wrapper/clk
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/rst_vec

# Trace signals
add wave -position end -divider "TRACE"
add wave sim:/tb_top/trace_rv_i_insn_ip
add wave sim:/tb_top/trace_rv_i_address_ip
add wave sim:/tb_top/trace_rv_i_valid_ip
add wave sim:/tb_top/trace_rv_i_exception_ip
add wave sim:/tb_top/trace_rv_i_ecause_ip
add wave sim:/tb_top/trace_rv_i_interrupt_ip
add wave sim:/tb_top/trace_rv_i_tval_ip

# AXI_LMEM
add wave -position end -divider "AXI_LMEM"
set hpath /tb_top/lmem
foreach bus ${axi} {
  pltAxi ${hpath} "lmem_${bus}" [set ${bus}]
}

# AXI_IMEM
add wave -position end -divider "AXI_IMEM"
set hpath /tb_top/imem
foreach bus ${axi_read} {
  pltAxi ${hpath} "imem_${bus}" [set ${bus}]
}

# VEER_DECODE signals
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

# VEER_ICACHE signals
add wave -position end -divider "VEER"
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[0]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_data_inst/PACKED_1/BANKS_WAY[1]/ECC1/size_512/WAYS/ic_bank_sb_way_data/D
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_rw_addr
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/ic_wr_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/ic_rd_data
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[0]
add wave sim:/tb_top/rvtop_wrapper/rvtop/veer/ifu/mem_ctl/ic_rd_hit[1]
add wave sim:/tb_top/rvtop_wrapper/rvtop/mem/icache/icm/ic_tag_inst/ic_rw_addr_ff

# Waveform configuration
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

# Run simulation
run -all

# Zoom full and show wave window
view wave
wave zoom full

# End of debug block
} else {
  run -all
}