//=======================================================
//  This code implements a simple heartbeat signal at a
//  configurable frequency to indicate the fpga is active
//
//  Usually it should be output to an LED
//
//  Copyright Lee Szuba 2012
//=======================================================

module HEARTBEAT(
	clk,
    trigger,
    beat);

    input clk;
    output trigger;
    output beat;

    reg beat;

    parameter CLK_DIV = 10000000;

    reg [31:0] counter;
    always @(posedge clk) begin
        if(counter == CLK_DIV) counter <= 0;
        else counter <= counter + 1;
    end

    assign trigger = (counter == CLK_DIV) ? 1'b1 : 1'b0;

    // Divide by 2 to give a 50 percent duty cycle
    always @(posedge clk) if(counter == CLK_DIV) beat <= ~beat;

endmodule