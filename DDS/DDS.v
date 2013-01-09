//=======================================================
//  This code implements a variable frequency synthesizer
//  using a cascaded NCO and PLL
//
//  Copyright Lee Szuba 2012
//=======================================================

module DDS(
    clk,
    reset,
    pll_reset,
    update,
    counter_data,
    nco_f,
    pll_clkin,
    pll_clkout,
    nco_clkout,
    quadrature_clk,
    locked,
    busy);

    input         clk;
    input         reset;
    input         pll_reset;
    input         update;
    input   [8:0] counter_data;
    input  [31:0] nco_f;
    input         pll_clkin;
    output        pll_clkout;
    output        nco_clkout;
    output  [3:0] quadrature_clk;
    output        locked;
    output        busy;


    wire scanclk,
         scandata,
         scanclkena,
         scandataout,
         scandone,
         configupdate,
         pll_areset;

    wire write_param,
         reconfig;

    //reg  [8:0] counter_data; // This is where the data for the counter to be updated is stored
    wire [3:0] counter_type = 4'b0001; // M (loop) counter for now, initially 104
    wire [2:0] counter_param = 3'b111; // Nominal count

    QUAD_GEN quad_gen(
        .clk(pll_clkout),
        .quad_out(quadrature_clk));

    NCO nco(
        .clk(clk),
        .f(nco_f),
        .clkout(nco_clkout));

    RECONFIG_STATE_MACHINE reconfig_state_machine(
        .reset(reset),
        .clk(clk),
        .update(update),
        .busy(busy),
        .write_param(write_param),
        .reconfig(reconfig));

    DDS_PLL_RECONFIG dds_pll_reconfig(
        .clock(clk),
        .counter_param(counter_param),
        .counter_type(counter_type),
        .data_in(counter_data),
        .pll_areset_in(pll_reset),
        .pll_scandataout(scandataout),
        .pll_scandone(scandone),
        .reconfig(reconfig),
        .reset(reset),
        .write_param(write_param),
        .busy(busy),
        .pll_areset(pll_areset),
        .pll_configupdate(configupdate),
        .pll_scanclk(scanclk),
        .pll_scanclkena(scanclkena),
        .pll_scandata(scandata));

    DDS_PLL dds_pll(
        .areset(pll_areset),
        .configupdate(configupdate),
        .inclk0(pll_clkin),
        .scanclk(scanclk),
        .scanclkena(scanclkena),
        .scandata(scandata),
        .c0(pll_clkout),
        .locked(locked),
        .scandataout(scandataout),
        .scandone(scandone));

endmodule