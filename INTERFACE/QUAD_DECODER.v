
//=======================================================
//  This code implements a variable frequency synthesizer
//  using an NCO
//
//  Copyright Lee Szuba 2012
//=======================================================


module QUAD_DECODER( input  clk,
                     input  a,
                     input  b,
                     output step,
                     output dir );

    // clk
    // Main system clock
    //
    // a, b
    // Quadrature encoder inputs, unsyncronized
    //
    // step
    // Outputs a pulse on every encoder count
    //
    // dir
    // Indicates direction of encoder



    // Syncronizer
    reg [1:0] a_sync, b_sync;
    always @(posedge clk) a_sync <= {a_sync[0], a};
    always @(posedge clk) b_sync <= {b_sync[0], b};

    wire _a = a_sync[1];
    wire _b = b_sync[1];

    // D flip-flop to create signal delayed by one clock
    reg a_ff, b_ff;
    always @(posedge clk) a_ff <= _a;
    always @(posedge clk) b_ff <= _b;

    // Decoding logic
    assign step = a_ff ^ b_ff ^ _a ^ _b;
    assign dir = b_ff ^ _a;

endmodule