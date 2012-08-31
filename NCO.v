
//=======================================================
//  This code implements a variable frequency synthesizer
//  using an NCO
//  
//  Copyright Lee Szuba 2012
//=======================================================


module IF_SYNTH( input clk,
                 output [3:0] quad_out,
                 input  [8:0] if_freq,
                 input  freq_strobe,
                 output locked );
    // clk
    // Main system clock
    //
    // quad_out
    // Output of quadrature signal to analog switches
    // Note the quadrature generator divides by 4 so the IF
    // clock has to be four times faster than the output
    //
    // if_freq
    // Desired if output frequency
    //
    // freq_strobe
    // Input to command the PLL to switch frequencies
    //
    // locked
    // Output signalling the PLL is reconfigured and locked

    wire lo_clk;
    wire busy, pll_lock;

    // For now we set all the counters to zero and never reconfig
    // so the lo frequency will be whatever it is initially set to
    PLL_AND_RECONFIG(.clk(clk), .busy(busy),
                     .c0(1'b0), .m(1'b0), .n(1'b0),
                     .strobe(1'b0), .pll_reset(1'b0),
                     .lock(pll_lock), .clk_out(lo_clk) );

    assign locked = busy && pll_lock;   

    // This code implements a two bit binary counter and
    // a 1-4 demultiplexer used to create intermediate
    // frequencies in the radio receiver
    
    // Binary counter, 2 bits wide
    reg [1:0] counter;
    always @(posedge lo_clk) counter <= counter + 1'b1;
    // 2-4 demultiplexer
    assign quad_out = (1'b1 << counter);
    
endmodule