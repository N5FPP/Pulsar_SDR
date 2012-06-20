
//=======================================================
//  This code is template generated by
//  Terasic System Builder
//=======================================================


//=======================================================
//  This code implements a software defined radio based
//  on the DEO Nano board
//
//  Copyright Lee Szuba 2012
//=======================================================


module SDR_REV_A(

		//////////// CLOCK //////////
		CLOCK_50,

		//////////// LED //////////
		LED,

		//////////// KEY //////////
		KEY,

		//////////// SW //////////
		SW,

		//////////// EPCS //////////
		EPCS_ASDO,
		EPCS_DATA0,
		EPCS_DCLK,
		EPCS_NCSO,

		//////////// 2x13 GPIO Header //////////
		GPIO_2,
		GPIO_2_IN,

		//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
		A,
		A_IN,

		//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
		B,
		B_IN
	);

	//=======================================================
	//  PARAMETER declarations
	//=======================================================


	//=======================================================
	//  PORT declarations
	//=======================================================

	//////////// CLOCK //////////
	input 		          		CLOCK_50;

	//////////// LED //////////
	output		     [7:0]		LED;

	//////////// KEY //////////
	input 		     [1:0]		KEY;

	//////////// SW //////////
	input 		     [3:0]		SW;

	//////////// EPCS //////////
	output		          		EPCS_ASDO;
	input 		          		EPCS_DATA0;
	output		          		EPCS_DCLK;
	output		          		EPCS_NCSO;

	//////////// 2x13 GPIO Header //////////
	inout 		    [12:0]		GPIO_2;
	input 		     [2:0]		GPIO_2_IN;

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [33:0]		A;
	input 		     [1:0]		A_IN;

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	inout 		    [33:0]		B;
	input 		     [1:0]		B_IN;


	//=======================================================
	//  REG/WIRE declarations
	//=======================================================

	// Alias the 50 MHz system clock to a signal just in case
	// a PLL is later used to synthesize a faster clock rate
	// in the future
	wire clk = CLOCK_50;

	// Clock outputs
	wire [3:0] l_osc;
	wire lo_lock;

	// Heartbeat signal
	wire beat_out;

	// Outputs to LCD
	wire LCD_E;
	wire LCD_RS;
	wire [7:0] LCD_DATA;

	// Center tuning frequency -- the current PLL frequency
	reg [8:0] tuning;
	reg lo_strobe;
	
	wire up_button_press, down_button_press, down_pressed, up_pressed;
	

	parameter TUNING_STEP = 9'b00010000;

	//=======================================================
	//  Structural coding
	//=======================================================


	// Human interface
	// One button raises the clock frequency, the other
	// lowers it. To be used to tune the device
	// 256 discrete values to start, depending on the tuning
	// range, this may be increased

	DEBOUNCER freq_up( .clk(clk), .button(KEY[0]), .button_down(up_button_press), .button_pressed(up_pressed) );
	DEBOUNCER freq_down( .clk(clk), .button(KEY[1]), .button_down(down_button_press), .button_pressed(down_pressed) );

	assign LED[4] = down_pressed || up_pressed;

	always @(posedge clk)
		begin
			if(up_button_press)
				begin
					tuning <= tuning + TUNING_STEP;
					lo_strobe <= 1'b1;
				end
			else if(down_button_press)
				begin
					tuning <= tuning - TUNING_STEP;
					lo_strobe <= 1'b1;
				end
			else lo_strobe <= 1'b0;
		end //Tuning counter control

	assign LED[3:0] = tuning[8:5];

	// Module to take clock frequency and synthesize
	// quadrature outputs at adjustable frequency
	IF_SYNTH if_synth( .clk(clk), .quad_out(l_osc), .if_freq(tuning),
					   .freq_strobe(lo_strobe), .locked(lo_lock) );

	// Quadrature signal on GPIO-1, pins 0,1,3,5
	assign {B[5], B[3], B[1:0]} = l_osc[3:0];

	// LED 7 indicates the PLL has locked to it's target
	// frequency
	assign LED[6] = lo_lock;
	
	// Generate a simple heartbeat signal on one of the on-
	// board LEDs (LED 0) to indicate the fpga is active
	// Frequency < 1Hz
	HEARTBEAT sdr_heartbeat( .clk(clk), .beat_out(beat_out) );
	assign LED[7] = beat_out;


	/*
	LCD char_lcd( .clk(clk), .data(lcd_send), .strobe(lcd_strobe), .command_sel(lcd_cmd_sel),
					  .busy(lcd_busy), .LCD_E(LCD_E), .LCD_RS(LCD_RS), .LCD_DATA(LCD_DATA) );
	assign B[26] = LCD_E;
	assign B[24] = LCD_RS;
	assign {B[16], B[14], B[18], B[12], B[20], B[10], B[22], B[8]} = LCD_DATA[7:0];
	*/
endmodule
