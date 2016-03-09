module Seven_seg(
clk,
DEVICE,
DATA,
HEX_out
);
input clk;
output [47:0] HEX_out;
input [15:0] DEVICE;
input [15:0] DATA;

wire [47:0] HEX_out;
wire [15:0] DEVICE;
wire [15:0] DATA;
//////////////7_SEG////////////////////
reg [7:0] HEX0= 0;
reg [7:0] HEX1= 0;
reg [7:0] HEX2= 0;
reg [7:0] HEX3= 0;
reg [7:0] HEX4= 0;
reg [7:0] HEX5= 0;

wire [6:0] seven_segment[15:0]; 

assign
seven_segment[0] = 7'b0111111,
seven_segment[1] = 7'b0000110,
seven_segment[2] = 7'b1011011,
seven_segment[3] = 7'b1001111,
seven_segment[4] = 7'b1100110,
seven_segment[5] = 7'b1101101,
seven_segment[6] = 7'b1111101,
seven_segment[7] = 7'b0000111,
seven_segment[8] = 7'b1111111,
seven_segment[9] = 7'b1101111,
seven_segment[10] = 7'b1110111,
seven_segment[11] = 7'b1111100,
seven_segment[12] = 7'b0111001,
seven_segment[13] = 7'b1011110,
seven_segment[14] = 7'b1111001,
seven_segment[15] = 7'b1110001;


assign 
HEX_out = ~({HEX5,HEX4,HEX3,HEX2,HEX1,HEX0});

always @(negedge clk)
begin
	case(DEVICE)
		////////////////////////////////////LED 輸出////////////////////////////////////
		16'h0030:		//LEDB燈號設置
			begin
				HEX0[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end
		16'h0031:		//LEDG燈號設置
			begin
				HEX1[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end	
		16'h0032:		//LEDR燈號設置
			begin
				HEX2[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end	
		16'h0033:		//LEDB燈號設置
			begin
				HEX3[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end
		16'h0034:		//LEDB燈號設置
			begin
				HEX4[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end
		16'h0035:		//LEDB燈號設置
			begin
				HEX5[7:0] <={1'b0,seven_segment[DATA[3:0]]};
			end
		16'h0036:		//LEDB燈號設置
			begin
				HEX0[7:0] <=DATA[7:0];
			end
		16'h0037:		//LEDB燈號設置
			begin
				HEX1[7:0] <=DATA[7:0];
			end
		16'h0038:		//LEDB燈號設置
			begin
				HEX2[7:0] <=DATA[7:0];
			end
		16'h0039:		//LEDB燈號設置
			begin
				HEX3[7:0] <=DATA[7:0];
			end
		16'h003A:		//LEDB燈號設置
			begin
				HEX4[7:0] <=DATA[7:0];
			end
		16'h003B:		//LEDB燈號設置
			begin
				HEX5[7:0] <=DATA[7:0];
			end
		16'h003C:		//LEDB燈號設置
			begin
             HEX0[7] <= DATA[0];
				 HEX1[7] <= DATA[1];
				 HEX2[7] <= DATA[2];
				 HEX3[7] <= DATA[3];
				 HEX4[7] <= DATA[4];
				 HEX5[7] <= DATA[5];
			end
		default:begin end
	endcase
end

endmodule
