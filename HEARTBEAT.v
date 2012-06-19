
//=======================================================
//  This code implements a simple heartbeat signal at a
//  configurable frequency to indicate the fpga is active
//
//  Usually it should be output to an LED
//  
//  Copyright Lee Szuba 2012
//=======================================================

module HEARTBEAT( input clk,
						output beat_out );
	
	reg beat;
	reg [31:0] counter;
	
	parameter CLK_DIV = 50000000;
	
	always @(posedge clk) if(counter==CLK_DIV) counter <= 0; else counter <= counter+1;
	
	// Divide by 2 to give a 50 percent duty cycle
	always @(posedge clk) if(counter==CLK_DIV) beat <= ~beat;
	
	assign beat_out = beat;

endmodule