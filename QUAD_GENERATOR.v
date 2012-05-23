
//=======================================================
//  This code implements a two bit binary counter and
//	 a 1-4 demultiplexer used to create intermediate
//  frequencies in the radio receiver
//
//  The four quadrature signals are created directly to
//  output to the analog switches
//  
//  Copyright Lee Szuba 2012
//=======================================================


module QUAD_GENERATOR( if_clk, quad_out );
	// Clock input should be variable frequency,
	// with a max of 200MHz for 50MHz output
	input if_clk;
	
	// Output is a 1-4 demultiplexed signal
	// with one output active at a time
	// and 90 degree out of phase signals
	output [3:0] quad_out;

	// Binary counter, 2 bits wide
	reg [1:0] counter;
	always @(posedge if_clk) counter <= counter+1;

	// Shift a 1 across the output based on the value of the counter
	assign quad_out = (1 << counter);
endmodule