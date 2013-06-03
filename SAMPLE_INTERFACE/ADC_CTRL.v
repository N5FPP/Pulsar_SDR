module ADC_CTRL (
    input         iCLK,
    input         iCLK_n,
    input         iEN,
    input   [2:0] iCH,
    output [11:0] oDATA,
    output        oDONE,

    output oDIN,
    output oCS_n,
    output oSCLK,
    input  iDOUT
);

reg        data;
reg        done;
reg  [3:0] cont;
reg  [3:0] m_cont;
reg [11:0] adc_data;
reg [11:0] out_data;

assign oCS_n = ~iEN;
assign oSCLK = (iEN)? iCLK:1;
assign oDIN  = data;
assign oDATA = out_data;
assign oDONE = done;


always@(posedge iCLK or negedge iEN) begin
    if(!iEN)      cont <= 0;
    else if(iCLK) cont <= cont + 1;
end

always@(posedge iCLK_n) begin
    if(iCLK_n) m_cont <= cont;
end

always@(posedge iCLK_n or negedge iEN) begin
    if(!iEN)        data <= 0;
    else begin
        if(iCLK_n) begin
            case(cont)
                2 : data <= iCH[2];
                3 : data <= iCH[1];
                4 : data <= iCH[0];
               default : data <= 0;
            endcase
        end
    end
end

always@(posedge iCLK or negedge iEN) begin
    if(!iEN) begin
        done     <= 1'b0;
        adc_data <= 0;
        out_data <= 0;
    end
    else begin
        if(iCLK) begin
            case(m_cont)
                1  : out_data     <= adc_data;
                2  : done         <= 1'b1;
                4  : adc_data[11] <= iDOUT;
                5  : adc_data[10] <= iDOUT;
                6  : adc_data[9]  <= iDOUT;
                7  : adc_data[8]  <= iDOUT;
                8  : adc_data[7]  <= iDOUT;
                9  : adc_data[6]  <= iDOUT;
                10 : adc_data[5]  <= iDOUT;
                11 : adc_data[4]  <= iDOUT;
                12 : adc_data[3]  <= iDOUT;
                13 : adc_data[2]  <= iDOUT;
                14 : adc_data[1]  <= iDOUT;
                15 : adc_data[0]  <= iDOUT;
            endcase
        end
    end
end

endmodule