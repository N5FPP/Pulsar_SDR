
//=======================================================
//  This code implements a variable frequency synthesizer
//	 using one of the built in PLLs and decoding logic to
//  created quadrature signals
//
//  Copyright Lee Szuba 2012
//=======================================================

module PLL_AND_RECONFIG( input        clk,
                         output       busy,
						 input  [2:0] m,
						 input  [3:0] n,
                         input        strobe;
                         input        pll_reset,
                         output       lock,
                         output       clk_out );

    parameter N_COUNTER  		= 4'b0000;
    parameter M_COUNTER  		= 4'b0001;
    parameter VCO_PRESCALE      = 4'b0011;
    parameter C0_COUNTER 		= 4'b0100;

    parameter N_M_NOMINAL_COUNT = 3'b111; //9 bits wide, sets counter value
    parameter VCO_POST_SCALE    = 3'b000; //1 bit wide, enables or disables post scale
    parameter C0_HIGH_COUNT     = 3'b000; //8 bits wide, sets counter value
    parameter C0_LOW_COUNT      = 3'b001; //8 bits wide, sets counter value
    parameter C0_BYPASS         = 3'b100; //1 bit wide, sets bypass on c0
    parameter C0_ODD_EVEN       = 3'b101; //1 bit wide, selects odd or even division

    wire reconfig_busy;
    wire [8:0] data_in;

    reg pll_reset,
        write_param,
        reconfig;

    reg [2:0] counter_param;
    reg [3:0] counter_type;
    reg [3:0] state;

    always @(posedge clk)
        case(state)
            0:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    if(strobe & !reconfig_busy) state <= 1;
                    else state <= 0;
                end
            1:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    state <= 2;
                end
            2:  begin
                    write_param <= 1'b1;
                    reconfig <= 1'b0;
                    state <= 3;
                end
            3:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    if(!reconfig_busy) state <= 4; else state <= 3;
                end
            4:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b1;
                    state <= 5;
                end
            5:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    if(!reconfig_busy) state <= 6; else state <= 5;
                end
            6:  begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    state <= 0;
                end
            default: begin
                    write_param <= 1'b0;
                    reconfig <= 1'b0;
                    state <= 0;
                end
        endcase


	wire pll_areset,
		 pll_configupdate,
		 pll_scanclk,
		 pll_scanclkena,
		 pll_scandata,
		 pll_scandataout,
		 pll_scandone;


	PLL_CONFIG pll_config(
					.busy(reconfig_busy),
					.clock(clk), //Main system clock
					.counter_param(counter_param),
					.counter_type(counter_type),
					.data_in(data_in),
					.pll_areset(pll_areset),
					.pll_areset_in(pll_reset), //PLL reset
					.pll_configupdate(pll_configupdate),
					.pll_scanclk(pll_scanclk),
					.pll_scanclkena(pll_scanclkena),
					.pll_scandata(pll_scandata),
					.pll_scandataout(pll_scandataout),
					.pll_scandone(pll_scandone),
					.reconfig(reconfig),
					.write_param(write_param) );

	PLL pll_module(
			  .areset(pll_areset),
			  .configupdate(pll_configupdate),
			  .inclk0(clk), //PLL input clock, main system clock
			  .scanclk(pll_scanclk),
			  .scanclkena(pll_scanclkena),
			  .scandata(pll_scandata),
			  .c0(clk_out), //PLL output signal
			  .locked(lock),
			  .scandataout(pll_scandataout),
			  .scandone(pll_scandone) );


    assign busy = (~reconfig_busy & !state);

endmodule