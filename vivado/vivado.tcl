# ------------------------------------------------------------
# Check if PROFPGA is set
# ------------------------------------------------------------
if {![info exists env(PROFPGA)]} {
    error "PROFPGA environment variable is not set - please check your proFPGA software installation"
}
set PROFPGA_ROOT [set env(PROFPGA)]

# ------------------------------------------------------------
# Check if top level is set
# ------------------------------------------------------------
if { ![info exists env(SYNTHESIS_TOP_LEVEL)] } {
    error "SYNTHESIS_TOP_LEVEL environment variable is not set"
}

set SYNTHESIS_TOP [set env(SYNTHESIS_TOP_LEVEL)]

# ------------------------------------------------------------
# Compile Top level files
# ------------------------------------------------------------
if { ${SYNTHESIS_TOP} == "Verilog" } {
  read_verilog -library work ${PROFPGA_ROOT}/hdl/generic_hdl/afifo_core.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/generic_hdl/ethernet_crc.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/generic_hdl/generic_dpram.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/generic_hdl/generic_dpram_separated_ports.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/generic_hdl/timer.v

  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_async_buffer.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_axi_master.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer_uni.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_deserializer.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_devzero.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_regif.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_mux.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_demux.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_ctrl_fsm.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_regfifo.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_router_upstream.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_router.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_rt.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_serializer.v

  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync_ipad.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync_opad.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync_rx.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync_tx.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync_rx2.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_clocksync.v
  read_verilog -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_ctrl.v

################### READING USER FILES ############################################
  source user_design.tcl
  
  read_verilog -library work ../rtl/lim_mmi64.v
  puts "vivado.tcl: INFO: compiling Verilog top level"
} elseif { ${SYNTHESIS_TOP} == "VHDL" } {
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/rtl_templates_log2.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/fpga_wrapper_pkg.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/fpga_wrapper_v7.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/ethernet_crc-e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/ethernet_crc-rtl-a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/timer-e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/timer-rtl-a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/generic_hdl/generic_ram.vhd

  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_stimulate_p.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_pli_p.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_rt_p.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_p.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer_uni_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer_uni_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_buffer_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_deserializer_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_deserializer_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_router_upstream.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_router_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_router_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_rt_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_rt_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_p_muxdemux_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_regfifo.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_regif_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_regif_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_devzero_e.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/mmi64/mmi64_m_devzero_a.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_pkg.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_clocksync.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_ctrl.vhd
  read_vhdl -library work ${PROFPGA_ROOT}/hdl/profpga_user/profpga_sync.vhd
  
################### READING USER FILES ############################################
  source user_design.tcl

  read_vhdl -library work ../rtl/user_mmi64.vhd
  puts "vivado.tcl: INFO: compiling VHDL top level"
} else {
  error "Wrong usage of script"
}

#set_param logicopt.enableBUFGinsertCLK 0
# ------------------------------------------------------------
# Read constraints
# ------------------------------------------------------------
read_xdc ./constraints/user_mmi64.xdc

# ------------------------------------------------------------
# Set Top level
# ------------------------------------------------------------
set TOPLEVEL "user_mmi64"

# ------------------------------------------------------------
# remove previous implementation
# ------------------------------------------------------------
file delete -force output
file delete -force reports

file mkdir output
file mkdir reports

# ------------------------------------------------------------
# synthesize desing
# ------------------------------------------------------------
# Tried -part xc7v2000tflg1925-2 instead of -part xc7v2000t-1flg1925 -> the odd-even sort doesnt't work perfectly but close enough 
synth_design -top ${TOPLEVEL} -keep_equivalent_registers -part xc7v2000tflg1925-2 -include_dirs ${PROFPGA_ROOT}/hdl/generic_hdl -include_dirs ${PROFPGA_ROOT}/hdl/mmi64 -include_dirs ${PROFPGA_ROOT}/hdl/profpga
write_checkpoint -force ./output/${TOPLEVEL}_synthesized.dcp
report_utilization -file ./reports/${TOPLEVEL}_utilization_synth.rpt

#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&If you don't need to use a ILA (i.e. debugging internal signal of the design) => uncomment the following and use the user_mmi64.bit generated by this script &&&&&&&&&&&&&&&&&&&&&&&&&&&&
## ------------------------------------------------------------
## optimize desing
## ------------------------------------------------------------
#opt_design
#write_checkpoint -force ./output/${TOPLEVEL}_optimized.dcp
#report_drc -fail_on error -file ./reports/${TOPLEVEL}_drc_optimized.rpt

## ------------------------------------------------------------
## place desingò
## ------------------------------------------------------------
#place_design
#catch { report_io                    -file ./reports/${TOPLEVEL}_io_placed.rpt }
#catch { report_clock_utilization     -file ./reports/${TOPLEVEL}_clock_utilization_placed.rpt }
#catch { report_utilization           -file ./reports/${TOPLEVEL}_utilization_placed.rpt }
#catch { report_control_sets -verbose -file ./reports/${TOPLEVEL}_control_sets_placed.rpt }
#if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
#  puts "Found setup timing violations => running physical optimization"
#  phys_opt_design
#}

## ------------------------------------------------------------
## route desing
## ------------------------------------------------------------
#route_design
#write_checkpoint -force ./output/${TOPLEVEL}_routed.dcp
#catch { report_drc            -file ./reports/${TOPLEVEL}_drc_routed.rpt }
#catch { report_power          -file ./reports/${TOPLEVEL}_power_routed.rpt }
#catch { report_route_status   -file ./reports/${TOPLEVEL}_route_status_routed.rpt }
#catch { report_timing_summary -file ./reports/${TOPLEVEL}_timing_summary_routed.rpt }
#set_property BITSTREAM.STARTUP.STARTUPCLK Cclk [current_design]
#set_property BITSTREAM.CONFIG.UNUSEDPIN Pullnone [current_design]
#set_property BITSTREAM.CONFIG.PERSIST no [current_design]
#set_property BITSTREAM.STARTUP.MATCH_CYCLE Auto [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS True [current_design]
#write_bitstream -force ./output/${TOPLEVEL}.bit

