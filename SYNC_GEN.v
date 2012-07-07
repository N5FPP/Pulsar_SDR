//=======================================================
//  This code implements a VGA signal generator with a
//  section of the screen configurable to display text
//  with a simple ASCII character RAM
//
//  Five output signals are to be connected to the
//  corresponding pins on a VGA monitor
//
//  Copyright Lee Szuba 2012
//=======================================================

module SYNC_GEN( input        clk,
                 output       h_sync,
                 output       v_sync,
                 output [9:0] h_pos,
                 output [9:0] v_pos,
                 output       blanking);


    //******************** VGA TIMING PARAMETERS ********************

    // VGA 800x600px @ 72Hz
    // 50MHz Pixel Clock
    //
    //               Active  Front Porch  Sync Pulse  Back Porch
    // Horizontal    800     56 Pixels    120 Pixels  64 Pixels
    // Vertical      600     37 Lines     6 Lines     23 Lines
    //
    //
    // SYNC TIMIMG:
    // | Active Region     | Front Porch | Sync    | Back Porch
    // -----------------------------------_________------------

    parameter H_FRONT_PORCH = 56,
              H_BACK_PORCH  = 64,
              H_ACTIVE      = 800,
              HSYNC         = 120,

              V_FRONT_PORCH = 37,
              V_BACK_PORCH  = 23,
              V_ACTIVE      = 600,
              VSYNC         = 6,

              H_MAX = H_FRONT_PORCH + H_BACK_PORCH + H_ACTIVE + HSYNC,
              V_MAX = V_FRONT_PORCH + V_BACK_PORCH + V_ACTIVE + VSYNC,
              HSYNC_START = H_ACTIVE + H_FRONT_PORCH,
              HSYNC_END = H_ACTIVE + H_FRONT_PORCH + HSYNC,
              VSYNC_START = V_ACTIVE + V_FRONT_PORCH,
              VSYNC_END = V_ACTIVE + V_FRONT_PORCH + VSYNC;

    //******************** VGA TIMING PARAMETERS ********************

    reg [10:0] hCount;
    reg [9:0]  vCount;

    reg hSync, vSync;
    reg hEn, vEn;

    //******************** SYNC GENERATION ********************
    // Increment horizontal counter and reset at end
    always @(posedge clk) begin
        if (hCount >= (H_MAX-1)) begin
            hCount <= 0;

            if(vCount >= (V_MAX-1))
                vCount <= 0;
            else
                vCount <= vCount + 1;
        end
        else
            hCount <= hCount + 1;
    end

    // Generate horizontal sync pulses
    always @(posedge clk) begin
        if((hCount < HSYNC_END) && (hCount >= (HSYNC_START-1)))
            hSync <= 1'b0;
        else
            hSync <= 1'b1;
    end

    // Generate vertical sync pulses
    always @(posedge clk) begin
        if((vCount < VSYNC_END) && (vCount >= (VSYNC_START-1)))
            vSync <= 1'b0;
        else
            vSync <= 1'b1;
    end

    // Enable colour outputs when in the horizontal active region
    always @(posedge clk) begin
        if(hCount < H_ACTIVE)
            hEn <= 1'b1;
        else
            hEn <= 1'b0;
    end

    // Enable colour outputs when in the vertical active region
    always @(posedge clk) begin
        if(vCount < V_ACTIVE)
            vEn <= 1'b1;
        else
            vEn <= 1'b0;
    end
    //******************** SYNC GENERATION ********************


    //******************** OUTPUT ASSIGNMENTS ********************
    assign blanking = ~(vEn & hEn);

    assign h_sync = hSync;
    assign v_sync = vSync;

    assign h_pos = hCount[9:0] & ~blanking;
    assign v_pos = vCount[9:0] & ~blanking;
    //******************** OUTPUT ASSIGNMENTS ********************
endmodule