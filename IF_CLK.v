// megafunction wizard: %ALTPLL%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altpll

// ============================================================
// File Name: IF_CLK.v
// Megafunction Name(s):
// 			altpll


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module IF_CLK (
	areset,
	configupdate,
	inclk0,
	scanclk,
	scanclkena,
	scandata,
	c0,
	locked,
	scandataout,
	scandone);

	input	  areset;
	input	  configupdate;
	input	  inclk0;
	input	  scanclk;
	input	  scanclkena;
	input	  scandata;
	output	  c0;
	output	  locked;
	output	  scandataout;
	output	  scandone;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0	  areset;
	tri0	  configupdate;
	tri0	  scanclkena;
	tri0	  scandata;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

	wire [4:0] sub_wire0;
	wire  sub_wire2;
	wire  sub_wire3;
	wire  sub_wire4;
	wire [0:0] sub_wire7 = 1'h0;
	wire [0:0] sub_wire1 = sub_wire0[0:0];
	wire  c0 = sub_wire1;
	wire  scandataout = sub_wire2;
	wire  scandone = sub_wire3;
	wire  locked = sub_wire4;
	wire  sub_wire5 = inclk0;
	wire [1:0] sub_wire6 = {sub_wire7, sub_wire5};

	altpll	altpll_component (
				.areset (areset),
				.configupdate (configupdate),
				.inclk (sub_wire6),
				.scanclk (scanclk),
				.scanclkena (scanclkena),
				.scandata (scandata),
				.clk (sub_wire0),
				.scandataout (sub_wire2),
				.scandone (sub_wire3),
				.locked (sub_wire4),
				.activeclock (),
				.clkbad (),
				.clkena ({6{1'b1}}),
				.clkloss (),
				.clkswitch (1'b0),
				.enable0 (),
				.enable1 (),
				.extclk (),
				.extclkena ({4{1'b1}}),
				.fbin (1'b1),
				.fbmimicbidir (),
				.fbout (),
				.fref (),
				.icdrclk (),
				.pfdena (1'b1),
				.phasecounterselect ({4{1'b1}}),
				.phasedone (),
				.phasestep (1'b1),
				.phaseupdown (1'b1),
				.pllena (1'b1),
				.scanaclr (1'b0),
				.scanread (1'b0),
				.scanwrite (1'b0),
				.sclkout0 (),
				.sclkout1 (),
				.vcooverrange (),
				.vcounderrange ());
	defparam
		altpll_component.charge_pump_current_bits = 1,
		altpll_component.inclk0_input_frequency = 50000,
		altpll_component.intended_device_family = "Cyclone IV E",
		altpll_component.loop_filter_c_bits = 0,
		altpll_component.loop_filter_r_bits = 27,
		altpll_component.lpm_hint = "CBX_MODULE_PREFIX=IF_CLK",
		altpll_component.lpm_type = "altpll",
		altpll_component.m = 1,
		altpll_component.m_initial = 1,
		altpll_component.m_ph = 0,
		altpll_component.n = 512,
		altpll_component.operation_mode = "NO_COMPENSATION",
		altpll_component.pll_type = "AUTO",
		altpll_component.port_activeclock = "PORT_UNUSED",
		altpll_component.port_areset = "PORT_USED",
		altpll_component.port_clkbad0 = "PORT_UNUSED",
		altpll_component.port_clkbad1 = "PORT_UNUSED",
		altpll_component.port_clkloss = "PORT_UNUSED",
		altpll_component.port_clkswitch = "PORT_UNUSED",
		altpll_component.port_configupdate = "PORT_USED",
		altpll_component.port_fbin = "PORT_UNUSED",
		altpll_component.port_inclk0 = "PORT_USED",
		altpll_component.port_inclk1 = "PORT_UNUSED",
		altpll_component.port_locked = "PORT_USED",
		altpll_component.port_pfdena = "PORT_UNUSED",
		altpll_component.port_phasecounterselect = "PORT_UNUSED",
		altpll_component.port_phasedone = "PORT_UNUSED",
		altpll_component.port_phasestep = "PORT_UNUSED",
		altpll_component.port_phaseupdown = "PORT_UNUSED",
		altpll_component.port_pllena = "PORT_UNUSED",
		altpll_component.port_scanaclr = "PORT_UNUSED",
		altpll_component.port_scanclk = "PORT_USED",
		altpll_component.port_scanclkena = "PORT_USED",
		altpll_component.port_scandata = "PORT_USED",
		altpll_component.port_scandataout = "PORT_USED",
		altpll_component.port_scandone = "PORT_USED",
		altpll_component.port_scanread = "PORT_UNUSED",
		altpll_component.port_scanwrite = "PORT_UNUSED",
		altpll_component.port_clk0 = "PORT_USED",
		altpll_component.port_clk1 = "PORT_UNUSED",
		altpll_component.port_clk2 = "PORT_UNUSED",
		altpll_component.port_clk3 = "PORT_UNUSED",
		altpll_component.port_clk4 = "PORT_UNUSED",
		altpll_component.port_clk5 = "PORT_UNUSED",
		altpll_component.port_clkena0 = "PORT_UNUSED",
		altpll_component.port_clkena1 = "PORT_UNUSED",
		altpll_component.port_clkena2 = "PORT_UNUSED",
		altpll_component.port_clkena3 = "PORT_UNUSED",
		altpll_component.port_clkena4 = "PORT_UNUSED",
		altpll_component.port_clkena5 = "PORT_UNUSED",
		altpll_component.port_extclk0 = "PORT_UNUSED",
		altpll_component.port_extclk1 = "PORT_UNUSED",
		altpll_component.port_extclk2 = "PORT_UNUSED",
		altpll_component.port_extclk3 = "PORT_UNUSED",
		altpll_component.self_reset_on_loss_lock = "OFF",
		altpll_component.vco_post_scale = 1,
		altpll_component.width_clock = 1,
		altpll_component.c0_high = 1,
		altpll_component.c0_initial = 1,
		altpll_component.c0_low = 1,
		altpll_component.c0_mode = "even",
		altpll_component.c0_ph = 0,
		altpll_component.clk0_counter = "c0",
		altpll_component.scan_chain_mif_file = "IF_CLK.mif";


endmodule