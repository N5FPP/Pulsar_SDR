//=======================================================
//  This code implements a quadrature generator
//  Divides input frequency by 4
//
//  Copyright Lee Szuba 2012
//=======================================================

module QUAD_GEN( input        clk,
                 output [3:0] quad_out );


    // Binary counter, 2 bits wide
    reg [1:0] counter;
    always @(posedge clk) counter <= counter + 1'b1;
    // 2-4 demultiplexer
    assign quad_out = (1'b1 << counter);

endmodule