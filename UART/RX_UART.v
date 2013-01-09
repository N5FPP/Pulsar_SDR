//=======================================================
//  This code implements an RS232 receiver
//
//  Currently set to 9600-8N1
//  Uses oversampling to sync to the incoming byte
//
//  Copyright Lee Szuba 2012
//=======================================================


module RX_UART( input        clk,
                output       busy,
                output       done,
                output [7:0] data,
                input        rx );

    // clk
    // Main system clock
    //
    // done
    // Indicates a new byte in the data register
    //
    // data
    // Received byte
    //
    // busy
    // Receiver is currently receiving a byte
    //
    // rx
    // Receive input from hardware


    // Baud generator
    parameter DIV = 10; // Change to 651 for actual board

    reg [9:0] clk_div;
    wire bit_clk;
    always @(posedge clk) begin
        if(clk_div == 0) clk_div <= DIV;
        else clk_div <= clk_div - 1;
    end

    assign bit_clk = (clk_div == 0);


    // Syncronizing flip-flops
    wire _rx;
    reg [1:0] sync;
    always @(posedge clk) sync <= {sync[0], ~rx};
    assign _rx = sync[1];


    // Sample clock generator
    reg [2:0] sample_count;
    always @(posedge clk) begin
        if(bit_clk) begin
            if(state == IDLE) sample_count <= 3'b000;
            else sample_count <= sample_count + 3'b001;
        end
    end

    //reg sample_trig_prev;
    //always @(posedge clk) sample_trig_prev <= &sample_count;

    wire sample_trig;
    assign sample_trig = &sample_count & bit_clk;//~sample_trig_prev;


    reg [3:0] oversample;
    wire start_bit;
    always @(posedge clk) begin
        if(bit_clk) oversample <= {_rx, oversample[3:1]};
    end
    assign start_bit = &oversample;


    // Receiving state machine
    parameter IDLE =  4'b0000;
    parameter START = 4'b0001;
    parameter STOP =  4'b0010;

    reg [3:0] state;
    always @(posedge clk) begin
        case(state)
            IDLE:    if(start_bit) state <= START;
            START:   if(sample_trig) state <= 4'b1000;
            4'b1000: if(sample_trig) state <= 4'b1001;
            4'b1001: if(sample_trig) state <= 4'b1010;
            4'b1010: if(sample_trig) state <= 4'b1011;
            4'b1011: if(sample_trig) state <= 4'b1100;
            4'b1100: if(sample_trig) state <= 4'b1101;
            4'b1101: if(sample_trig) state <= 4'b1110;
            4'b1110: if(sample_trig) state <= 4'b1111;
            4'b1111: if(sample_trig) state <= STOP;
            STOP:    if(sample_trig) state <= IDLE;
            default: state <= IDLE;
        endcase
    end


    reg [7:0] _data;
    always @(posedge clk) begin
        if(state[3] && bit_clk && (sample_count == 4'b1111))
            _data <= {_rx,_data[7:1]};
    end
    assign data = _data;


    // Create a pulse when finished
    reg last_busy;
    always @(posedge clk) last_busy <= busy;
    assign done = last_busy & ~busy;


    // When not in the idle state, assert busy
    assign busy = ~(state == IDLE);
endmodule