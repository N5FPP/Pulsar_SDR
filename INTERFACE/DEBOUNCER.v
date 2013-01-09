
//=======================================================
//  This code implements a push button switch debouncer
//
//  Material taken from fpga4fun.com is copyright of the
//  original creator
//=======================================================

module DEBOUNCER( input clk, button,
				  output button_pressed, button_up, button_down);


	// Use two flipflops to sync the signal into the main
	// clock domain
	// invert button to make button_sync_0 active high
	reg button_sync_0;  always @(posedge clk) button_sync_0 <= ~button;
	reg button_sync_1;  always @(posedge clk) button_sync_1 <= button_sync_0;

	reg [15:0] count;


	// When the push-button is pushed or released, we increment the counter
	// The counter has to be maxed out before we decide that the push-button state has changed
	reg button_state;  // state of the push-button (0 when up, 1 when down)
	wire button_idle = (button_state==button_sync_1);
	wire count_max = &count;

	always @(posedge clk)
		if(button_idle)
	    	count <= 0;
		else
			begin
	    		count <= count + 1'b1;  // something is going on, increment the counter
	    		if(count_max) button_state <= ~button_state;
			end

	assign button_down = ~button_state & ~button_idle & count_max;  // true for one clock cycle when we detect that PB went down
	assign button_up   =  button_state & ~button_idle & count_max;  // true for one clock cycle when we detect that PB went up
	assign button_pressed = button_state;
endmodule