
//=======================================================
//  This code implements a simple heartbeat signal at a
//  configurable frequency to indicate the fpga is active
//
//  Usually it should be output to an LED
//  
//  Copyright Lee Szuba 2012
//=======================================================

module HEARTBEAT( clk, beat_out );
	// Main device clock
	input clk;
	output beat_out;
	
	parameter clk_div = 50000000;
	
	// Binary counter, 32 bits wide
	reg [31:0] counter;
	always @(posedge clk) if(counter==clk_div) counter <= 0; else counter <= counter+1;
	
	// Divide by 2 to give a 50 percent duty cycle
	always @(posedge clk) if(counter==clk_div) beat_out <= ~beat_out;

endmodule