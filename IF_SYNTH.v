
//=======================================================
//  This code implements a variable frequency synthesizer
//	 using one of the built in PLLs and decoding logic to
//  created quadrature signals
//  
//  Copyright Lee Szuba 2012
//=======================================================


module IF_SYNTH( input clk,
				 output [3:0] quad_out,
				 input  [8:0] if_freq,
				 input  freq_strobe,
				 output locked );
	// clk
	// Main system clock
	//
	// quad_out
	// Output of quadrature signal to analog switches
	// used to sample radio signal
	// 1-4 demultiplexed signal
	// with one output active at a time
	// and 90 degree out of phase signals at 1/4
	// of the pll clock frequency
	//
	// if_freq
	// Desired if output frequency
	//
	// freq_strobe
	// Input to command the PLL to switch frequencies
	//
	// locked
	// Output signalling the PLL is reconfigured and locked



 	
	// PLL synthesized variable frequency clock
	wire lo_clk_signal;
		  
	wire busy;
	reg pll_reset, write_param, reconfig;
	wire [8:0] data_in;

	wire pll_lock;
	assign locked = (~busy & pll_lock & (!state));

	reg [3:0] state;
	reg strobe_latch;


	always @(posedge clk)
		case(state)
			0: 	begin
					pll_reset <= 1'b0;
					write_param <= 1'b0;
					reconfig <= 1'b0;
					if(freq_strobe)
						begin
							state <= 1;
							//strobe_latch <= 1'b0;
						end
					else
						begin
							state <= 0;
							//strobe_latch <= 1'b0;
						end
				end
			1:  begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b0;
					write_param <= 1'b0;
					reconfig <= 1'b0;
					state <= 2;
				end
			2:	begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b0;
					write_param <= 1'b1;
					reconfig <= 1'b0;
					state <= 3;
				end
			3:	begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b0;
					write_param <= 1'b0;
					reconfig <= 1'b0;
					if(!busy) state <= 4; else state <= 3;
				end
			4:	begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b0;
					write_param <= 1'b0;
					reconfig <= 1'b1;
					state <= 5;
				end
			5:	begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b0;
					write_param <= 1'b0;
					reconfig <= 1'b0;
					if(!busy) state <= 6; else state <= 5;
				end
			6:	begin
					//if(freq_strobe) strobe_latch <= 1'b1;
					pll_reset <= 1'b1;
					write_param <= 1'b0;
					reconfig <= 1'b0;
					state <= 0;
				end
			default: begin
					pll_reset <= 1'b0;
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

	wire [2:0] counter_param = 3'b111; //Nominal division ratio setting
	wire [3:0] counter_type = 4'b0001; //M (loop) counter

	PLL_CONFIG pll_config( 
					.busy(busy),
					.clock(clk), //Main system clock
					.counter_param(counter_param),
					.counter_type(counter_type),
					.data_in(if_freq),
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
	
	// PLL module
	IF_CLK lo_a( 
			  .areset(pll_areset),
			  .configupdate(pll_configupdate),
			  .inclk0(clk), //PLL input clock, main system clock
			  .scanclk(pll_scanclk),
			  .scanclkena(pll_scanclkena),
			  .scandata(pll_scandata),
			  .c0(lo_clk_signal), //PLL output signal
			  .locked(pll_lock),
			  .scandataout(pll_scandataout),
			  .scandone(pll_scandone) );

	
	
	// This code implements a two bit binary counter and
   // a 1-4 demultiplexer used to create intermediate
   // frequencies in the radio receiver
   //
   // The four quadrature signals are created directly to
   // output to the analog switches
	// Note the quadrature generator divides by 4 so the IF
	// clock has to be four times faster than the output
	
	// Binary counter, 2 bits wide
	reg [1:0] counter;
	always @(posedge lo_clk_signal) counter <= counter + 1'b1;
	// 2-4 demultiplexer
	assign quad_out = (1'b1 << counter);
	
endmodule