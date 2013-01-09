
//=======================================================
//  This code implements a text lcd driven with a
//  parallel interface
//
//  This module deals with the timing requirements
//
//  Copyright Lee Szuba 2012
//=======================================================

module LCD( input clk,
				input data,
				input strobe,
				input command_sel,
				output busy,
				output LCD_E,
				output LCD_RS,
				output [7:0] LCD_Data);
				
endmodule