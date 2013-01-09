
module CAT_TX_STATE_MACHINE (
    clock,
    start,
    bcd_in,
    done,
    tx_wr,
    data);

    input         clock;
    input         start;
    input  [39:0] bcd_in;
    output        done;
    output        tx_wr;
    output  [7:0] data;

    reg done;
	 reg  [7:0] data;
    reg [15:0] fstate;
    reg [15:0] reg_fstate;

    parameter IDLE=0,TX_F=1,TX_A=2,TX_0=3,DIG_9=4,
              DIG_8=5,DIG_7=6,DIG_6=7,DIG_5=8,
              DIG_4=9,DIG_3=10,DIG_2=11,DIG_1=12,
              DIG_0=13,TX_SEMICOLON=14,DONE=15;

    always @(posedge clock)
    begin
        if (clock) begin
            fstate <= reg_fstate;
        end
    end

    always @(fstate or start or bcd_in)
    begin
        done <= 1'b0;
        data <= 8'h00;
        case (fstate)
            IDLE: begin
                if (start) reg_fstate <= TX_F;
                else reg_fstate <= IDLE;
            end
            TX_F: begin
                reg_fstate <= TX_A;
                data <= 8'h46; // 'F'
            end
            TX_A: begin
                reg_fstate <= TX_0;
                data <= 8'h41; // 'A'
            end
            TX_0: begin
                reg_fstate <= DIG_9;
                data <= 8'h30; // '0'
            end
            DIG_9: begin
                reg_fstate <= DIG_8;
                data <= {4'b0000,bcd_in[39:36]}+48;
            end
            DIG_8: begin
                reg_fstate <= DIG_7;
                data <= {4'b0000,bcd_in[35:32]}+48;
            end
            DIG_7: begin
                reg_fstate <= DIG_6;
                data <= {4'b0000,bcd_in[31:28]}+48;
            end
            DIG_6: begin
                reg_fstate <= DIG_5;
                data <= {4'b0000,bcd_in[27:24]}+48;
            end
            DIG_5: begin
                reg_fstate <= DIG_4;
                data <= {4'b0000,bcd_in[23:20]}+48;
            end
            DIG_4: begin
                reg_fstate <= DIG_3;
                data <= {4'b0000,bcd_in[19:16]}+48;
            end
            DIG_3: begin
                reg_fstate <= DIG_2;
                data <= {4'b0000,bcd_in[15:12]}+48;
            end
            DIG_2: begin
                reg_fstate <= DIG_1;
                data <= {4'b0000,bcd_in[11:8]}+48;
            end
            DIG_1: begin
                reg_fstate <= DIG_0;
                data <= {4'b0000,bcd_in[7:4]}+48;
            end
            DIG_0: begin
                reg_fstate <= TX_SEMICOLON;
                data <= {4'b0000,bcd_in[3:0]}+48;
            end
            TX_SEMICOLON: begin
                reg_fstate <= DONE;
                data <= 8'h3B; // ';'
			   end
            DONE: begin
                reg_fstate <= IDLE;
                done <= 1'b1;
            end
            default: reg_fstate <= IDLE;
        endcase
    end

    assign tx_wr = ((fstate<15)&&(fstate>0)) ? clock : 1'b0;
endmodule
