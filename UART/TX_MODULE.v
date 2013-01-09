//=======================================================
//
//
//  Copyright Lee Szuba 2012
//=======================================================

module TX_MODULE(
    clk,
    data,
    wr_req,
    fifo_full,
    tx );

    input clk;
    input [7:0] data;
    input wr_req;
    output fifo_full;
    output tx;


    reg tx_start, tx_fifo_rd;

    always @(posedge clk) begin
        if(!tx_fifo_empty && !tx_busy && !tx_start) begin
            tx_start <= 1'b1;
            tx_fifo_rd <= 1'b1;
        end else begin
            tx_start <= 1'b0;
            tx_fifo_rd <= 1'b0;
        end
    end

    TX_FIFO tx_fifo(
        .clock(clk),
        .data(data),
        .rdreq(tx_fifo_rd),
        .wrreq(wr_req),
        .empty(tx_fifo_empty),
        .full(fifo_full),
        .q(tx_data)
    );

    TX_UART tx_uart(
        .clk(clk),
        .start(tx_start),
        .data(/*tx_data*/8'h21),
        .busy(tx_busy),
        .tx(RS232_tx)
    );

endmodule