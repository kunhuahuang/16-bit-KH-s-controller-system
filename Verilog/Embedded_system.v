module Embedded_system(
clk,
/////VGA//////
r,
g,
b,
hs,
vs,   
///////LED///////////
LEDB,
LEDG,
LEDR,
///////7-seg/////////
HEX_out,
///////DMAX//////////
DMAX_row_out,
DMAX_column_out,
///////key_pad///////
key_pad_row,
key_pad_column,
///////SWITCH////////
SWITCH_control,
///////LCDM//////////      
LCD_EN,
RS,
RW,
DB8,
///////ROLL//////////
Roll,
///////DISTANCE//////////
Trig,
Echo,
///////keyboard//////////
ps2_clk,
ps2_data
);
////////input//////////	 
input clk;
input [15:0] SWITCH_control;
input [2:0] key_pad_column;
input [10:0] Roll;
input Echo;
input ps2_clk;
input ps2_data;
////////output/////////
output r;
output g;
output b;
output hs;
output vs;
output [7:0] LEDB;
output [7:0] LEDG;
output [7:0] LEDR;
output [47:0] HEX_out;
output [41:0] DMAX_row_out;
output [29:0] DMAX_column_out;
output [3:0] key_pad_row;
output  LCD_EN,RS,RW; 
output  [7:0] DB8; 
output Trig;
////////Wire & Reg////////

////////CLOCK/////////////
wire clk_50;
////////CPU CORE//////////
reg [15:0] IN_DATA = 0;
wire [15:0] OUT_DATA;
wire [15:0] OUT_DEVICE;
reg ITR;//正源觸發時CPU接收訊號，更改FLAG值，建議負源觸發並維持一個CLOCK
/////////////////////////VGA////////////////////////////////////////	 
wire r;
wire g;
wire b;
wire hs;
wire vs;
reg ram_picture_position_write; // input [0 : 0] web
reg [9 : 0] ram_picture_position_address_rw; // input [9 : 0] addrb
reg [25 : 0]  ram_picture_position_din; // input [25 : 0] dinb

reg ram_picture_write; // input [0 : 0] web
reg [11 : 0] ram_picture_address_rw; // input [11 : 0] addrb
reg [15 : 0] ram_picture_din; // input [15 : 0] dinb

reg ram_word_position_write; // input [0 : 0] web
reg [9 : 0] ram_word_position_address_rw; // input [9 : 0] addrb
reg [25 : 0] ram_word_position_din; // input [25 : 0] dinb

reg ram_480_480_write; // input [0 : 0] web
reg [8 : 0] ram_480_480_address_rw; // input [8 : 0] addrb
reg [479 : 0] ram_480_480_din; // input [479 : 0] dinb
wire [479 : 0]ram_480_480_dout_rw; // output [479 : 0] doutb
//////vga  temp///////
reg [8 : 0] ram_480_480_x_rw;
reg color;
//////////////////////////////////////////////////////////////////////
//////LED////////
reg [7:0] LEDB;
reg [7:0] LEDG;
reg [7:0] LEDR;
//////7-seg////////
wire [47:0] HEX_out;
//////DMAX/////////
wire [41:0] DMAX_row_out;
wire [29:0] DMAX_column_out;
/////////CONTROL IO BUS/////////
reg [15:0] DEVICE;
reg [15:0] DATA;
///////KEYPAD///////////////////
wire [3:0] key_pad_row;
wire [2:0] key_pad_column;
wire [3:0] key_pad;
reg key_pad_flag = 0; //key_pad_flag :1'b1 have input 1'b0 no input
//////////SWITCH//////////////////
wire [15:0] SWITCH_control;
//////////////////////////////////
//////////LCDM//////////////
wire LCD_EN,RS,RW; 
wire [7:0] DB8; 
//////////ROLL//////////////
wire [10:0] Roll;
reg [3:0] number;
//////////Distance////////////////
wire Trig;
wire Echo; 
wire [11:0] distance;
/////////////////////////////////
wire ps2_clk;
wire ps2_data;
wire [7:0] ps2_byte;

clock_50 clk_adv(
.CLKIN_IN(clk), 
.CLKFX_OUT(clk_50), 
.CLKIN_IBUFG_OUT(),
.CLK0_OUT()
);
	 
	 
	 
CPU CPU_CORE(
    .CPU_clock(clk_50), 
    .IN_DATA(IN_DATA), 
    .OUT_DEVICE(OUT_DEVICE), 
    .OUT_DATA(OUT_DATA), 
    .ITR(ITR)
    );
	 

VGA_OUT VGA(
    .r(r), 
    .g(g), 
    .b(b), 
    .hs(hs), 
    .vs(vs), 
    .clk_50(clk_50), 
    .ram_picture_position_write(ram_picture_position_write), 
    .ram_picture_position_address_rw(ram_picture_position_address_rw), 
    .ram_picture_position_din(ram_picture_position_din), 
    .ram_picture_write(ram_picture_write), 
    .ram_picture_address_rw(ram_picture_address_rw), 
    .ram_picture_din(ram_picture_din), 
    .ram_word_position_write(ram_word_position_write), 
    .ram_word_position_address_b(ram_word_position_address_rw), 
    .ram_word_position_din(ram_word_position_din), 
    .ram_480_480_write(ram_480_480_write), 
    .ram_480_480_address_rw(ram_480_480_address_rw), 
    .ram_480_480_din(ram_480_480_din), 
    .ram_480_480_dout_rw(ram_480_480_dout_rw)
    );

Seven_seg Seven_Seg(
    .clk(clk_50), 
    .DEVICE(DEVICE), 
    .DATA(DATA), 
    .HEX_out(HEX_out)
    );
	 
DMAX DMAX_out (
    .clk(clk_50), 
    .DEVICE(DEVICE), 
    .DATA(DATA), 
    .DMAX_row_out(DMAX_row_out), 
    .DMAX_column_out(DMAX_column_out)
    );
	 
KEY_PAD Keypad(
    .clk(clk_50), 
    .key_pad_row(key_pad_row), 
    .key_pad_column(key_pad_column), 
    .key_pad(key_pad), 
    .key_pad_flag(key_pad_flag)
    );
	 
LCD LCDM_OUT (
    .clk_LCD(clk_50), 
    .LCD_EN(LCD_EN), 
    .RS(RS), 
    .RW(RW), 
    .DB8(DB8), 
    .DEVICE(DEVICE), 
    .DATA(DATA)
    );
	 
Distance_Detect distance_D (
    .clk(clk_50), 
    .Trig(Trig), 
    .Echo(Echo), 
    .distance(distance)
    );
KEYBOARD keyboard(
clk_50,
ps2_clk,
ps2_data,
ps2_byte
); 
/////////////GET CPU OUTPUT SIGNAL/////////////
always @(posedge clk_50)
begin
	DEVICE <= OUT_DEVICE;
	DATA	 <= OUT_DATA;
end
////////////////////////////////////////////////////VGA///////////////////////////////////////////////////////////////////////////////////	 
always @(negedge clk_50)
begin
	case(DEVICE)
		16'h0000:
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
			end
		////////////////////////////////////字元、圖形顯示設定	////////////////////////////////////	
		16'h0010: 	//設定字元、圖形編號(11-bit) 			1-bit選擇圖形(1)或字元(0)  10-bit為圖形、字元編號			
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				if(DATA[10] == 1) 
				ram_picture_position_address_rw 	<= DATA[9:0];
				if(DATA[10] == 0)
				ram_word_position_address_rw		<= DATA[9:0];
			end
		16'h0011:			//設定字元、圖形的X軸起始位置(10-bit) 1-bit選擇圖形(1)或字元(0) 9-bit為圖形、字元X軸位置	
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				if(DATA[9] == 1)
				ram_picture_position_din 			<= {DATA[8:0],ram_picture_position_din[16:0]};
				if(DATA[9] == 0)
				ram_word_position_din				<= {DATA[8:0],ram_word_position_din[16:0]};
			end
		16'h0012:			//設定字元、圖形的Y軸起始位置(10-bit) 1-bit選擇圖形(1)或字元(0) 9-bit為圖形、字元Y軸位置	
			begin			
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				if(DATA[9] == 1)
				ram_picture_position_din 			<= {ram_picture_position_din[25:17],DATA[8:0],ram_picture_position_din[7:0]};
				if(DATA[9] == 0)
				ram_word_position_din				<= {ram_word_position_din[25:17],DATA[8:0],ram_word_position_din[7:0]};
			end
		16'h0013:			//設定字元、圖形的編碼(9-bit) 			1-bit選擇圖形(1)或字元(0) 8-bit為圖形、字元編碼
			begin	
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;	
				ram_480_480_write						<= 0;
				if(DATA[8] == 1)
				ram_picture_position_din 			<= {ram_picture_position_din[25:8],DATA[7:0]};
				if(DATA[8] == 0)
				ram_word_position_din				<= {ram_word_position_din[25:8],DATA[7:0]};
			end
		16'h0014:			//設定字元、圖形匯出(1-bit) 			1-bit選擇圖形(1)或字元(0) 
			begin
				if(DATA[0] == 1)
				begin
				ram_picture_position_write 		<= 1;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				end
				if(DATA[0] == 0)
				begin
				ram_word_position_write				<= 1;
				ram_picture_position_write 		<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				end
			end
		////////////////////////////////////	繪圖設定	////////////////////////////////////
		16'h0015:		//繪圖設定//設定圖形編號(8-bit) //一共有256種圖形 每個圖形有16行 格式編碼:前8-bit為圖形編碼，後4-bit為圖形列數
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				ram_picture_address_rw 				<= {DATA[7:0],ram_picture_address_rw[3:0]};
			end
		16'h0016:		//繪圖設定//設定圖形列數(4-bit) //共16行 一個圖形為16*16
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				ram_picture_address_rw				<= {ram_picture_address_rw[11:4],DATA[3:0]};
			end
		16'h0017:		//繪圖設定//設定圖形資料(16-bit)
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
				ram_picture_din 						<= DATA;
			end
		16'h0018:		//繪圖設定//將圖形設定匯出
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 1;
				ram_480_480_write						<= 0;
			end
		//////////////////////////////////	畫布繪圖設定	////////////////////////////////////	
		16'h0019:		//畫布繪圖設定//設定X軸位置(9-bit) //一次描繪一點
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_x_rw						<= DATA[8:0];
				ram_480_480_write						<= 0;
			end		
		16'h001A:		//畫布繪圖設定//設定y軸位置(9-bit) //一次描繪一點
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_address_rw				<= DATA[8:0];
				ram_480_480_write						<= 0;
			end			
		16'h001B:		//畫布繪圖設定//設定顏色(1-bit)//目前為單色  //亮(1)  暗(0)
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				color										<=	DATA[0];
				ram_480_480_write						<= 0;
			end		
		16'h001C:		//畫布繪圖設定//將點寫入橫排暫存，並無從舊中取得舊資料
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				if(ram_480_480_x_rw == 0)
				ram_480_480_din 						<= {ram_480_480_din[479:1],color};
				else if(ram_480_480_x_rw < 479 && color == 1)
				ram_480_480_din				 		<= ram_480_480_din | (1'b1 << ram_480_480_x_rw);
				else if(ram_480_480_x_rw < 479 && color == 0)
				ram_480_480_din				 		<= ram_480_480_din & (~({479'b0,1} << ram_480_480_x_rw));
				else if(ram_480_480_x_rw == 479)
				ram_480_480_din				 		<= {color,ram_480_480_din[478:0]};
				else 
				ram_480_480_din						<= ram_480_480_din;
				ram_480_480_write						<= 1;
			end
		16'h001D:		//畫布繪圖設定//將畫布橫排暫存清空 //初始為亮或暗
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				if(DATA[0] == 1)	//初始為亮
				begin
					ram_480_480_din					<= {480{1'b1}};
				end
				if(DATA[0] == 0)	//初始為暗
				begin
					ram_480_480_din					<= {480{1'b0}};
				end
				ram_480_480_write						<= 0;
			end			
		16'h001E:		//畫布繪圖設定//將畫布設定匯出
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_din				 		<= ram_480_480_dout_rw | (color << ram_480_480_x_rw);
				ram_480_480_write						<= 1;
			end
		16'h001F:		//畫布繪圖設定//將畫布第Y軸清空 //初始為亮或暗
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				if(DATA[0] == 1)	//初始為亮
				begin
					ram_480_480_din					<= {480{1'b1}};
				end
				if(DATA[0] == 0)	//初始為暗
				begin
					ram_480_480_din					<= {480{1'b0}};
				end
				ram_480_480_write						<= 1;
			end
		default:
			begin
				ram_picture_position_write 		<= 0;
				ram_word_position_write				<= 0;
				ram_picture_write						<= 0;
				ram_480_480_write						<= 0;
			end
	endcase
end
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	 
always @(negedge clk_50)
begin
	case(DEVICE)
		////////////////////////////////////LED 輸出////////////////////////////////////
		16'h0020:		//LEDB燈號設置
			begin
				LEDB <= DATA[7:0];
			end
		16'h0021:		//LEDG燈號設置
			begin
				LEDG <= DATA[7:0];
			end	
		16'h0022:		//LEDR燈號設置
			begin
				LEDR <= DATA[7:0];
			end	
	endcase
end
always @(negedge clk_50)
begin
/////////////KEY PAD///////////////////////////
	case(DEVICE)
		16'h0050:		
			begin
				IN_DATA <= {12'h000,key_pad};
				key_pad_flag <= 1'b1;
			end
/////////////SWITCH///////////////////////////
		16'h0060:		
			begin
				key_pad_flag <= 1'b0;
				IN_DATA <= SWITCH_control;
			end
/////////////ROLL//////////////////////////////
		16'h0080:		
			begin
				key_pad_flag <= 1'b0;
				IN_DATA <= number;
			end
/////////////ROLL//////////////////////////////
		16'h0090:		
			begin
				key_pad_flag <= 1'b0;
				IN_DATA <= {4'b0000,distance};
			end
/////////////KEYBOARD//////////////////////////
		16'h0100:		//KEYBOARD
			begin
				key_pad_flag <= 1'b0;
				IN_DATA <= {8'b0,ps2_byte};
			end
			
		default:begin key_pad_flag <= 1'b0; end
	endcase
end
////////////ROLL///////////////////////////	

always @(posedge clk_50)
begin
case(Roll)
	11'b11111111110: number <= 4'b0001;
	11'b11111111101: number <= 4'b0010;
	11'b11111111011: number <= 4'b0011;
	11'b11111110111: number <= 4'b0100;
	11'b11111101111: number <= 4'b0101;
	11'b11111011111: number <= 4'b0110;
	11'b11110111111: number <= 4'b0111;
	11'b11101111111: number <= 4'b1000;
	11'b11011111111: number <= 4'b1001;
	11'b10111111111: number <= 4'b1010;
	11'b01111111111: number <= 4'b1011;
	11'b11111111111: number <= 4'b1100;
	default:begin end
endcase
end
/////////////ROLL///////////////////////////
endmodule
