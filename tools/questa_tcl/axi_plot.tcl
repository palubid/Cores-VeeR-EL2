# AXI signal definitions

# AXI signal groups
set axi {axi_ar axi_r axi_aw axi_w axi_b}
set axi_read {axi_ar axi_r}

set axi_ar {arvalid arready araddr arid arlen arburst arsize}
set axi_r {rvalid rready rdata rid rlast rresp}
set axi_aw {awvalid awready awaddr awid awlen awburst awsize}
set axi_w {wvalid wready wdata wstrb}
set axi_b {bvalid bready bid bresp}

# AXI plot procedure
proc pltAxi {hpath bus sig_list} {
  foreach sig ${sig_list} {
    add wave -group ${bus} "sim:${hpath}/${sig}"
  }
}
