transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/UART {C:/Repositories/Pulsar_SDR/UART/TX_UART.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/UART {C:/Repositories/Pulsar_SDR/UART/TX_MODULE.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/UART {C:/Repositories/Pulsar_SDR/UART/TX_FIFO.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/INTERFACE {C:/Repositories/Pulsar_SDR/INTERFACE/QUAD_DECODER.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/INTERFACE {C:/Repositories/Pulsar_SDR/INTERFACE/HEARTBEAT.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/INTERFACE {C:/Repositories/Pulsar_SDR/INTERFACE/DEBOUNCER.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS/DDS_PLL {C:/Repositories/Pulsar_SDR/DDS/DDS_PLL/RECONFIG_STATE_MACHINE.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS/DDS_PLL {C:/Repositories/Pulsar_SDR/DDS/DDS_PLL/DDS_PLL_RECONFIG.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS/DDS_PLL {C:/Repositories/Pulsar_SDR/DDS/DDS_PLL/DDS_PLL.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS/NCO {C:/Repositories/Pulsar_SDR/DDS/NCO/NCO.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS {C:/Repositories/Pulsar_SDR/DDS/QUAD_GEN.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/DDS {C:/Repositories/Pulsar_SDR/DDS/DDS.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/CAT_CMD_GEN {C:/Repositories/Pulsar_SDR/CAT_CMD_GEN/FREQ_CALC.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/CAT_CMD_GEN {C:/Repositories/Pulsar_SDR/CAT_CMD_GEN/CAT_TX_STATE_MACHINE.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/CAT_CMD_GEN {C:/Repositories/Pulsar_SDR/CAT_CMD_GEN/BIN_TO_BCD.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR {C:/Repositories/Pulsar_SDR/sdr_rev_a.v}
vlog -vlog01compat -work work +incdir+C:/Repositories/Pulsar_SDR/db {C:/Repositories/Pulsar_SDR/db/dds_pll_altpll.v}

