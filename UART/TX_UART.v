//=======================================================
//  This code implements an RS232 transmitter
//
//  Currently set to 9600-8N1
//
//  Copyright Lee Szuba 2012
//=======================================================


module TX_UART(
    input        clk,
    input        start,
    input  [7:0] data,
    output       busy,
    output       tx
);

    // clk
    // Main system clock
    //
    // start
    // Command to start transmission of byte in data
    //
    // data
    // Byte to be transmitted, LSB first
    //
    // busy
    // Transmitter is currently sending a byte
    // Do not modify data during this time
    // Future versions should incorperate a latch to avoid overwritting during tx
    //
    // tx
    // Transmit output to hardware


    // Baud generator
    // 9600  -> 5208  (Tested)
    //115200 -> 434   (Tested)
    parameter DIV = 434;

    reg [15:0] clk_div;
    reg bit_clk;
    always @(posedge clk) begin
        if((clk_div == 0) | start) begin
            if(!start) bit_clk <= 1;
            else bit_clk <= 0;
            clk_div <= DIV;
        end
        else begin
            bit_clk <= 0;
            clk_div <= clk_div - 1;
        end
    end


    // Transmit byte buffer
    reg [7:0] _data;
    always @(posedge clk) begin
        if(start && (state == IDLE)) _data <= data;
    end


    // Transmitting state machine
    parameter IDLE = 8;
    parameter START = 9;
    parameter STOP = 10;

    parameter MARK = 1'b1;
    parameter SPACE = 1'b0;

    reg [7:0] state;
    always @(posedge clk) begin
        case(state)
            IDLE: // Idle state
                if(start) state <= START;
            START: // Start bit
                if(bit_clk) state <= 0;
            0: // b0
                if(bit_clk) state <= 1;
            1: // b1
                if(bit_clk) state <= 2;
            2: // b2
                if(bit_clk) state <= 3;
            3: // b3
                if(bit_clk) state <= 4;
            4: // b4
                if(bit_clk) state <= 5;
            5: // b5
                if(bit_clk) state <= 6;
            6: // b6
                if(bit_clk) state <= 7;
            7: // b7
                if(bit_clk) state <= STOP;
            STOP: // Stop bit
                if(bit_clk) state <= IDLE;
            default: state <= IDLE;
        endcase
    end

    reg _tx;
    always @(*) begin
        case (state)
            IDLE:    _tx <= MARK;
            START:   _tx <= SPACE;
            STOP:    _tx <= MARK;
            0:       _tx <= _data[0];
            1:       _tx <= _data[1];
            2:       _tx <= _data[2];
            3:       _tx <= _data[3];
            4:       _tx <= _data[4];
            5:       _tx <= _data[5];
            6:       _tx <= _data[6];
            7:       _tx <= _data[7];
            default: _tx <= MARK;
        endcase
    end

    // When not in the idle state, assert busy
    assign busy = ~(state == IDLE);


    // Invert the data signal to match the hardware implementation if required
    assign tx = _tx;
endmodule