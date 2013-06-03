//=======================================================
//
//
//  Copyright Lee Szuba 2012
//=======================================================

module TX_MODULE(
    input        clk,
    input  [7:0] data,
    input        wr_req,
    output       fifo_full,
    output       fifo_empty,
    output       tx_busy,
    output       tx
);

// State machine states
parameter [2:0] WAIT = 3'b001,
                READ = 3'b010,
                TX   = 3'b100;

reg [2:0] state, next_state;
always @(posedge clk) begin
    state <= next_state;
end

reg tx_start, rd_req;
always @(*) begin
    next_state = WAIT;
    tx_start   = 1'b0;
    rd_req     = 1'b0;
    case(state)
        WAIT: begin
            if(!fifo_empty && !tx_busy) next_state = READ;
            else                        next_state = WAIT;
        end
        READ: begin
            rd_req   = 1'b1;
                                        next_state = TX;
        end
        TX: begin
            tx_start = 1'b1;
                                        next_state = WAIT;
        end
        default:                        next_state = WAIT;
    endcase
end

TX_FIFO tx_fifo(
    .clock(clk),
    .data(/*data*/8'h21),
    .rdreq(rd_req),
    .wrreq(wr_req),
    .empty(fifo_empty),
    .full(fifo_full),
    .q(tx_data)
);

TX_UART tx_uart(
    .clk(clk),
    .start(tx_start),
    .data(8'h21),
    .busy(tx_busy),
    .tx(tx)
);

endmodule