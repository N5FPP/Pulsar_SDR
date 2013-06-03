//=======================================================
//  This code implements a software defined radio based
//  on the DEO Nano board
//
//  Copyright Lee Szuba 2012
//=======================================================


module SDR_REV_A(

    // CLOCK
    input CLOCK_50,

    // LED
    output [7:0] LED,

    // KEY
    input [1:0] KEY,

    // SW
    input [3:0] SW,

    // ADC
    output ADC_CS_N,
    output ADC_SADDR,
    output ADC_SCLK,
    input  ADC_SDAT,

    // EPCS
    output EPCS_ASDO,
    input  EPCS_DATA0,
    output EPCS_DCLK,
    output EPCS_NCSO,


    // 2x13 GPIO_2 Header
    inout [12:0] GPIO_2,
    input  [2:0] GPIO_2_IN,

    // GPIO_0
    inout [33:0] A,
    input  [1:0] A_IN,

    // GPIO_1
    inout [33:0] B,
    input  [1:0] B_IN
);


//=======================================================
//  REG/WIRE declarations
//=======================================================

    // Alias the 50 MHz system clock to a signal just in case
    // a PLL is later used to synthesize a faster clock rate
    // in the future
    wire clk = CLOCK_50;

    wire pll_clkin;

    // Clock outputs
    wire [3:0] lo;
    wire lo_direct, nco_clk, pll_clk, lo_lock;
    wire reset, pll_reset, pll_busy;

    // Tuning knob encoder inputs
    wire tune_a, tune_b;
    // Tuning decoder outputs
    wire tune_step, tune_dir;

    // Heartbeat signal
    wire beat, slow_trigger;

    // Center tuning frequency -- 4*LO frequency
    reg [8:0] pll_counter;
    reg [8:0] _pll_counter;
    reg lo_strobe, lo_strobe_rdy;
    reg [31:0] lo_freq;

    // Button signals from debouncer
    wire up_button_press, down_button_press,
         down_pressed, up_pressed;


//=======================================================
//  Human Interface
//=======================================================

    DEBOUNCER freq_up(
        .clk(clk),
        .button(KEY[0]),
        .button_down(up_button_press),
        .button_pressed(up_pressed));

    DEBOUNCER freq_down(
        .clk(clk),
        .button(KEY[1]),
        .button_down(down_button_press),
        .button_pressed(down_pressed));

    // Quadrature decoder and counter for tuning knob
    QUAD_DECODER tuning_knob(
        .clk(clk),
        .a(tune_a),
        .b(tune_b),
        .step(tune_step),
        .dir(tune_dir));

    assign {tune_a, tune_b} = {B[27], B[29]};

    // Generate a simple heartbeat signal on one of the on-
    // board LEDs (LED 7) to indicate the fpga is active
    // Frequency ~= 1Hz
    HEARTBEAT sdr_heartbeat(
        .clk(clk),
        .trigger(slow_trigger),
        .beat(beat));

    assign LED[7] = beat;

//=======================================================
//  Tuning
//=======================================================

    always @(posedge clk) begin
        if (down_pressed || up_pressed)
            pll_counter <= 108;
        else begin
            if (tune_step) begin
                if (tune_dir) pll_counter <= pll_counter + 1;
                else pll_counter <= pll_counter - 1;
            end
        end
    end

    always @(posedge clk) begin
        if ((pll_counter != _pll_counter) && !pll_busy) begin
            lo_strobe_rdy <= 1'b1;
            _pll_counter <= pll_counter;
        end else
            lo_strobe_rdy <= 1'b0;

        lo_strobe <= lo_strobe_rdy;
    end

    DDS lo_synth(
        .clk(clk),
        .reset(reset),
        .pll_reset(pll_reset),
        .update(lo_strobe),
        .counter_data(pll_counter),
        .nco_f(515396076),
        .pll_clkin(pll_clkin),
        .pll_clkout(pll_clk),
        .nco_clkout(nco_clk),
        .quadrature_clk(lo),
        .locked(lo_lock),
        .busy(pll_busy));

    // Quadrature signal output on GPIO-1, pins 0,1,3,5
    assign {B[11], B[9], B[13], B[15]} = lo[3:0];
    // Raw LO out
    assign B[0] = pll_clk;

    reg [1:0] lo_div;
    always @(posedge pll_clk) lo_div <= lo_div + 1;
    assign A[7] = lo_div[1];

    //assign B[1] = nco_clk;
    //assign B[2] = nco_clk;
    assign  pll_clkin = clk;

    //assign LED[4:0] = pll_counter[4:0];
    //assign LED[5]   = pll_busy;
    //assign LED[6]   = lo_lock;


//=======================================================
//  Frequency Calculation
//=======================================================

    FREQ_CALC freq_calc(
        .clk(clk),
        .pll_m(pll_counter),
        .start(lo_strobe),
        .tx_data(/*tx_data*/),
        .tx_fifo_wr(/*tx_fifo_wr*/)
    );

//=======================================================
//  ADC Interface
//=======================================================

    wire [11:0] adc_data;

    SAMPLE_INTERFACE adc_iface(
        // Sample control and data
        .clk(clk),
        .start(1'b0),
        .reset(1'b0), // Hold the state machine in reset for testing
        .done_capture(),

        .read_clk(1'b0),
        .read_address(10'b0),
        .data(),

        // ADC
        .adc_cs_n(ADC_CS_N),
        .adc_saddr(ADC_SADDR),
        .adc_sclk(ADC_SCLK),
        .adc_sdat(ADC_SDAT),

        .adc_data(adc_data)
    );

    //assign LED[5:0] = adc_data[5:0];

//=======================================================
//  RS232 Communication
//=======================================================

    wire tx_fifo_wr, tx_fifo_full, tx_fifo_empty;

    wire [7:0] tx_data;

    TX_MODULE tx_module(
        .clk(clk),
        .data(8'h21),
        .wr_req(beat),
        .fifo_full(tx_fifo_full),
        .fifo_empty(tx_fifo_empty),
        .tx_busy(LED[6]),
        .tx(A[25])
    );

    assign LED[5] = tx_fifo_full;
    assign LED[4] = tx_fifo_empty;

endmodule
