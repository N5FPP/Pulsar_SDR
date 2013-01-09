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

module VGA( input        clk,
            input        rst,
            output       red,
            output       green,
            output       blue,
            output       h_sync,
            output       v_sync,
            output       blanking,
            input  [6:0] char_data,
            input  [6:0] char_h_addr,
            input  [5:0] char_v_addr,
            input        char_wren
            );

    reg pix;

    //******************** TEXT GENERATION ********************
    // The character memory is indexed by horizontal position
    // then by vertical position.
    //
    // The screen is 80x36 characters (h x v)
    // Each character is 8x16 pixels (h x v)

    wire [9:0] h_pos;
    wire [9:0] v_pos;

    // Here we alias the h_pos and v_pos signals to
    // prevent confusion
    wire [2:0] hCharPos = h_pos[2:0];
    wire [6:0] hChar    = h_pos[9:3];

    wire [3:0] vCharPos = v_pos[3:0];
    wire [5:0] vChar    = v_pos[9:4];

    // Create a wire to take the output from the character RAM
    // That is, the character which is at the current character
    // position
    wire [6:0] character;

    // This wire takes the the byte output from the font ROM
    // where each bit set corresponds to a horizontal pixel
    wire [7:0] charLine;


    // RAM to store a map of the characters on the screen
    // Each character is stored in one location of the 80x36=2880 byte
    // character RAM.
    // Address is 12 bits wide, data is 8 bits wide
    // Total RAM size is 4096 8-bit words (4kB)

    CHAR_RAM char_ram(.clock(clk),
    // Input from external source to update the text on the screen
                      .data(char_data),
                      .wraddress({char_v_addr,char_h_addr}), //***********
                      .wren(char_wren),
    // Output from RAM is an 7-bit address representing an ASCII
    // character in the font ROM
                      .rdaddress({vChar,hChar}),//************************
                      .q(character));

    reg [3:0] vCharPos1, vCharPos2;
    always @(posedge clk) vCharPos1 <= vCharPos;
    always @(posedge clk) vCharPos2 <= vCharPos1;

    // ROM to store a map of each individual character. There is one
    // for every valid 7-bit ASCII value (0-127)
    // Each character is 8x16 pixels or 16 bytes
    // Address is 11 bits wide, data is 8 bits wide
    // Total RAM size is 2048 8-bit words (2kB)

    FONT_ROM font_rom(.address({character,vCharPos2}),
                      .clock(clk), .q(charLine));


    reg [2:0] hCharPos1, hCharPos2, hCharPos3, hCharPos4;
    always @(posedge clk) hCharPos1 <= hCharPos;
    always @(posedge clk) hCharPos2 <= hCharPos1;
    always @(posedge clk) hCharPos3 <= hCharPos2;
    always @(posedge clk) hCharPos4 <= hCharPos3;

    always @(posedge clk) begin
        case (hCharPos4)
            0:       pix = charLine[7];
            1:       pix = charLine[6];
            2:       pix = charLine[5];
            3:       pix = charLine[4];
            4:       pix = charLine[3];
            5:       pix = charLine[2];
            6:       pix = charLine[1];
            7:       pix = charLine[0];
            default: pix = 1'b0;
        endcase 
    end

    //******************** TEXT GENERATION ********************

    //******************** OUTPUT ASSIGNMENTS ********************

    // This module generates the sync signals that go to the monitor
    // 
    SYNC_GEN sync_gen(.clk(clk), .h_sync(h_sync), .v_sync(v_sync),
                      .h_pos(h_pos), .v_pos(v_pos),
                      .blanking(blanking));

    assign red = (~blanking & pix);
    assign green = (~blanking & pix);
    assign blue = (~blanking & pix);

    //******************** OUTPUT ASSIGNMENTS ********************
endmodule