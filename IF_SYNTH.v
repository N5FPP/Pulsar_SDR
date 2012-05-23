
//=======================================================
//  This code implements a variable frequency synthesizer
//	 using one of the built in PLLs and decoding logic to
//  created quadrature signals
//  
//  Copyright Lee Szuba 2012
//=======================================================


module IF_SYNTH( clk, quad_out, if_freq, pll_freq_strobe, locked );
	// Main device clock, operating at 50MHz
	input clk;
	
	
	// Output of quadrature signal to analog switches
	// used to sample radio signal
	//
	// 1-4 demultiplexed signal
	// with one output active at a time
	// and 90 degree out of phase signals at 1/4
	// of the pll clock frequency
	output [3:0] quad_out;
	
	
	// 16 bit number representing the input frequency
	// Format of the number still to be decided
	input [15:0] if_freq;
	
	// Input to command the PLL to switch frequencies
	input pll_freq_strobe;
	
	// Signal to show when the PLL is locked to it's
	// target frequency
	output pll_lock;
 	
	// PLL synthesized variable frequency clock
	wire if_clk_signal;
	
	wire pll_areset,
		  pll_configupdate,
		  pll_scanclk,
		  pll_scanclkena,
		  pll_scandata,
		  pll_scandataout,
		  pll_scandone;
		  
	wire busy;
	
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
	always @(posedge if_clk_signal) counter <= counter+1;
	// 2-4 demultiplexer
	assign quad_out = (1 << counter);

	assign locked = (busy & pll_lock);
	
	PLL_CONFIG( 
					busy,
					clk, //Main system clock
					counter_param,
					counter_type,
					data_in,
					data_out,
					pll_areset,
					pll_areset_in,
					pll_configupdate,
					pll_scanclk,
					pll_scanclkena,
					pll_scandata,
					pll_scandataout,
					pll_scandone,
					read_param,
					reconfig,
					reset,
					write_param );
	
	// PLL module
	IF_CLK( 
			  pll_areset,
			  pll_configupdate,
			  clk, //PLL input clock, main system clock
			  pll_scanclk,
			  pll_scanclkena,
			  pllscandata,
			  if_clk_signal, //PLL output signal
			  pll_lock,
			  pll_scandataout,
			  pll_scandone );

	
endmodule