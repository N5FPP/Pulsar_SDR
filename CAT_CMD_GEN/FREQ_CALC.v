//=======================================================
//  This code implements a variable frequency synthesizer
//  using a cascaded NCO and PLL
//
//  Copyright Lee Szuba 2012
//=======================================================

// Output:
// Send 'FA0'
// Send 10 digits
// Send ';'

// Writing to FIFO:
// Set data
// Assert write
// Deassert write

// Steps:
// Calculate frequency
// Convert to BCD
// Convert to ASCII
// Place in transmit buffer

module FREQ_CALC(
    clk,
    pll_m,
    start,
    tx_data,
    tx_fifo_wr );

    input         clk;
    input   [8:0] pll_m;
    input         start;
    output  [7:0] tx_data;
    output        tx_fifo_wr;

    parameter REF_FREQ = 50_000_000;
    parameter PLL_N = 9;
    parameter PLL_C = 6;
    parameter PLL_K = 2;
    parameter DIV_CONST = REF_FREQ/(PLL_N*PLL_K*PLL_C);

    wire [31:0] freq;
    assign freq = pll_m*DIV_CONST;

    wire [39:0] freq_bcd;
    wire bcd_conv_done;
    BIN_TO_BCD freq_bcd_conv(
        .clk_i(clk),
        .ce_i(1'b1),
        .rst_i(bcd_conv_done),
        .start_i(start),
        .dat_binary_i(freq),
        .dat_bcd_o(freq_bcd),
        .done_o(bcd_conv_done)
    );

    CAT_TX_STATE_MACHINE cat_tx(
        .clock(clk),
        .start(bcd_conv_done),
        .bcd_in(freq_bcd),
        .done(),
        .tx_wr(tx_fifo_wr),
        .data(tx_data)
    );

endmodule