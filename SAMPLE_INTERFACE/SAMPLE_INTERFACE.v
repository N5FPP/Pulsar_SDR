module SAMPLE_INTERFACE(
    // Sample control and data
    input  clk,
    input  start,
    input  reset,
    output done_capture,

    input         read_clk,
    input   [9:0] read_address,
    output [15:0] data,

    // ADC
    output adc_cs_n,
    output adc_saddr,
    output adc_sclk,
    input  adc_sdat,

    output [11:0] adc_data
);


//=======================================================
//  State machine
//=======================================================

// State machine states
parameter [3:0] STOPPED      = 4'b0001,
                WAIT_FOR_ADC = 4'b0010,
                WRITE_RAM    = 4'b0100,
                RAM_FULL     = 4'b1000;


reg [3:0] state, next_state;
always @(posedge spi_clk or negedge reset) begin
    if(~reset) state <= STOPPED;
    else       state <= next_state;
end

reg adc_enabled, ram_wen, _done_capture;
always @(*) begin
    next_state   = STOPPED;
    adc_enabled  = 1'b0;
    ram_wen      = 1'b0;
    _done_capture = 1'b0;
    case(state)
        STOPPED: begin
            if(start)             next_state = WAIT_FOR_ADC;
            else                  next_state = STOPPED;
        end
        WAIT_FOR_ADC: begin
            adc_enabled  = 1'b1;
            if(adc_conv_done)     next_state = WRITE_RAM;
            else if(counter_full) next_state = RAM_FULL;
            else                  next_state = WAIT_FOR_ADC;
        end
        WRITE_RAM: begin
            adc_enabled  = 1'b1;
            ram_wen      = 1'b1;
                                  next_state = WAIT_FOR_ADC;
        end
        RAM_FULL: begin
            _done_capture = 1'b1;
                                  next_state = RAM_FULL;
        end
        default:                  next_state = STOPPED;
    endcase
end

assign done_capture = _done_capture;

//=======================================================
//  Address Generation
//=======================================================

// Sample counter holds the current sample number which also represents
// address in RAM
reg [9:0] sample_counter;
always @(posedge spi_clk or negedge reset) begin
    if(~reset)                 sample_counter <= 0;
    else begin
        // Only increment on a write to RAM
        if(state == WRITE_RAM) sample_counter <= sample_counter + 1;
    end
end

// When all of the bits in the counter are 1, the max is reached
assign counter_full = &sample_counter;

//=======================================================
//  Sample RAM
//=======================================================

// 16 x 1024 RAM to hold ADC samples
SAMPLE_RAM sample_ram (
    // FPGA clock domain
    .rdaddress(read_address),
    .rdclock(read_clk),
    .q(data),

    // ADC/SPI clock domain
    .wraddress(sample_counter),
    .wrclock(spi_clk),
    .wren(ram_wen),
    .data({4'h0, adc_data}) // Pad the adc data with four bits to bring it to 16
);

//=======================================================
//  ADC/SPI controller interface
//=======================================================

// Clock generator for ADC
wire spi_clk;
wire spi_clk_n;

SPIPLL spipll1 (
    .inclk0(clk),
    .c0(spi_clk),
    .c1(spi_clk_n)
);

// ADC control unit
wire adc_conv_done;

ADC_CTRL adc1 (
    .iCLK(spi_clk),
    .iCLK_n(spi_clk_n),

    .iEN(/*state != STOPPED*/ 1'b1 ),
    .iCH(3'h0), // Always use channel 0
    .oDATA(adc_data), // 12 bit adc output
    .oDONE(adc_conv_done),

    // ADC pins
    .oDIN(adc_saddr),
    .oCS_n(adc_cs_n),
    .oSCLK(adc_sclk),
    .iDOUT(adc_sdat)
);

endmodule
