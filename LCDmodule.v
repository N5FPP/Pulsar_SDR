module LCDmodule(clk, RxD, LCD_RS, LCD_RW, LCD_E, LCD_DataBus);
input clk, RxD;
output LCD_RS, LCD_RW, LCD_E;
output [7:0] LCD_DataBus;

wire RxD_data_ready;
wire [7:0] RxD_data;
async_receiver deserialer(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));

assign LCD_RS = RxD_data[7];
assign LCD_DataBus = {1'b0, RxD_data[6:0]};

assign LCD_RW = 0; // always write, never read from the LCD module

reg [2:0] count;
always @(posedge clk) if(RxD_data_ready | (count!=0)) count <= count + 1;

reg LCD_E;
always @(posedge clk) LCD_E <= (count!=0);

endmodule  
