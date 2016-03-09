`timescale 1ns / 1ps
module LCD(
clk_LCD,
LCD_EN,
RS,
RW,
DB8,
DEVICE,
DATA
); 
 
input   clk_LCD;        
 
output  LCD_EN,RS,RW; 

output  [7:0] DB8;         
input [15:0] DEVICE;
input [15:0] DATA;

wire [15:0] DEVICE;
wire [15:0] DATA;
reg [14:0] count;
reg [7:0] DB8;  
reg RS,RW = 0; 
reg [8:0] LCD_CNT = 0;
reg [7:0] first_line [0:15]  ;
reg [7:0] second_line [0:15] ;                        
assign LCD_EN = count[13];                   
reg rst = 1;



always @(negedge clk_LCD )
begin
if(rst == 0)
begin
	case(DEVICE)
		////////////////////////////////////LED 輸出////////////////////////////////////
		16'h0071:		//LCDM定義編碼及選擇第幾個字
			begin
				if(DATA[15] == 0)
				begin
					case(DATA[14:11])
						4'b0000 : first_line[0] <= DATA[7:0];
						4'b0001 : first_line[1] <= DATA[7:0];
						4'b0010 : first_line[2] <= DATA[7:0];
						4'b0011 : first_line[3] <= DATA[7:0];
						4'b0100 : first_line[4] <= DATA[7:0];
						4'b0101 : first_line[5] <= DATA[7:0];
						4'b0110 : first_line[6] <= DATA[7:0];
						4'b0111 : first_line[7] <= DATA[7:0];
						4'b1000 : first_line[8] <= DATA[7:0];
						4'b1001 : first_line[9] <= DATA[7:0];
						4'b1010 : first_line[10] <= DATA[7:0];
						4'b1011 : first_line[11] <= DATA[7:0];
						4'b1100 : first_line[12] <= DATA[7:0];
						4'b1101 : first_line[13] <= DATA[7:0];
						4'b1110 : first_line[14] <= DATA[7:0];
						4'b1111 : first_line[15] <= DATA[7:0];
					endcase
				end
				if(DATA[15] == 1)
				begin
					case(DATA[14:11])
						4'b0000 : second_line[0] <= DATA[7:0];
						4'b0001 : second_line[1] <= DATA[7:0];
						4'b0010 : second_line[2] <= DATA[7:0];
						4'b0011 : second_line[3] <= DATA[7:0];
						4'b0100 : second_line[4] <= DATA[7:0];
						4'b0101 : second_line[5] <= DATA[7:0];
						4'b0110 : second_line[6] <= DATA[7:0];
						4'b0111 : second_line[7] <= DATA[7:0];
						4'b1000 : second_line[8] <= DATA[7:0];
						4'b1001 : second_line[9] <= DATA[7:0];
						4'b1010 : second_line[10] <= DATA[7:0];
						4'b1011 : second_line[11] <= DATA[7:0];
						4'b1100 : second_line[12] <= DATA[7:0];
						4'b1101 : second_line[13] <= DATA[7:0];
						4'b1110 : second_line[14] <= DATA[7:0];
						4'b1111 : second_line[15] <= DATA[7:0];
					endcase
				end
			end	
	endcase
end
else if(rst == 1)
begin
rst <= 0;
first_line[0] <= "E";
first_line[1] <= "m";
first_line[2] <= "b";
first_line[3] <= "e";
first_line[4] <= "d";
first_line[5] <= "d";
first_line[6] <= "e";
first_line[7] <= "d";
first_line[8] <= " ";
first_line[9] <= "S";
first_line[10] <= "y";
first_line[11] <= "s";
first_line[12] <= "t";
first_line[13] <= "e";
first_line[14] <= "m";
first_line[15] <= "!";
second_line[0] <= "M";
second_line[1] <= "a";
second_line[2] <= "d";
second_line[3] <= "e";
second_line[4] <= " ";
second_line[5] <= "B";
second_line[6] <= "y";
second_line[7] <= " ";
second_line[8] <= "K";
second_line[9] <= "u";
second_line[10] <= "n";
second_line[11] <= " ";
second_line[12] <= "H";
second_line[13] <= "u";
second_line[14] <= "a";
second_line[15] <= ".";
end

end


always@(posedge clk_LCD )
count <= count +1;

always @(negedge count[13]) 
begin 
LCD_CNT <= LCD_CNT + 1;
end

always @(posedge count[13]) 
begin 
case (LCD_CNT)

0:
begin
RS <= 1'b0;
RW <= 1'b0;
DB8 <= 8'b00000010;
end
1 : DB8 <= 8'h38;
2 : DB8 <= 8'h0E;
3 : DB8 <= 8'h06;
4 : DB8 <= 8'h0C;
5 :begin
RS <= 1'b0;
DB8 <= 8'h80;
end
6 :begin
RS <= 1'b1;
DB8 <= first_line[0];
end
7 : DB8 <= first_line[1];
8 : DB8 <= first_line[2];
9 : DB8 <= first_line[3];
10: DB8 <= first_line[4];
11: DB8 <= first_line[5];
12: DB8 <= first_line[6];
13: DB8 <= first_line[7];
14: DB8 <= first_line[8];
15: DB8 <= first_line[9];
16: DB8 <= first_line[10];
17: DB8 <= first_line[11];
18: DB8 <= first_line[12];
19: DB8 <= first_line[13];
20: DB8 <= first_line[14];
21: DB8 <= first_line[15];
22:begin
RS <= 1'b0;
DB8 <= 8'hC0;
end
23:begin
RS <= 1'b1;
DB8 <= second_line[0];
end	
24: DB8 <= second_line[1];
25: DB8 <= second_line[2];
26: DB8 <= second_line[3];
27: DB8 <= second_line[4];
28: DB8 <= second_line[5];
29: DB8 <= second_line[6];
30: DB8 <= second_line[7];
31: DB8 <= second_line[8];
32: DB8 <= second_line[9];
33: DB8 <= second_line[10];
34: DB8 <= second_line[11];
35: DB8 <= second_line[12];
36: DB8 <= second_line[13];
37: DB8 <= second_line[14];
38: DB8 <= second_line[15];
39: 
begin
end

default:
begin
RS <= 1'b0;
RW <= 1'b0;
DB8 <= 8'b00000010;
end
endcase	
	
end


endmodule
