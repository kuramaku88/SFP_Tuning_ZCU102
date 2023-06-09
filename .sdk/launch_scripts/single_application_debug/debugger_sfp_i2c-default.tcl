connect -url tcp:127.0.0.1:3121
source C:/Xilinx/vitis/Vitis/2020.1/scripts/vitis/util/zynqmp_utils.tcl
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw E:/Mullai/2020_1/SFP_Tuning/zcu102/export/zcu102/hw/zcu102.xsa -mem-ranges [list {0x80000000 0xbfffffff} {0x400000000 0x5ffffffff} {0x1000000000 0x7fffffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
set mode [expr [mrd -value 0xFF5E0200] & 0xf]
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow E:/Mullai/2020_1/SFP_Tuning/zcu102/export/zcu102/sw/zcu102/boot/fsbl.elf
set bp_51_32_fsbl_bp [bpadd -addr &XFsbl_Exit]
con -block -timeout 60
bpremove $bp_51_32_fsbl_bp
targets -set -nocase -filter {name =~ "*A53*#0"}
rst -processor
dow E:/Mullai/2020_1/SFP_Tuning/sfp_i2c/Debug/sfp_i2c.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A53*#0"}
con
