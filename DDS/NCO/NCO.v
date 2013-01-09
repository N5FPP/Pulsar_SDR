
//=======================================================
//  This code implements a variable frequency synthesizer
//  using an NCO
//
//  Copyright Lee Szuba 2012
//=======================================================


module NCO(
    clk,
    f,
    clkout);

    input         clk;
    input  [31:0] f;
    output        clkout;

    // f = 515396076 gives 6 MHz out
    // with a 32 bit phase accumulator

    // NCO
    reg [31:0] phase_accum;
    always @(posedge clk)
        phase_accum <= phase_accum + f;
    assign clkout = phase_accum[31];

endmodule