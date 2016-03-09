`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:25:00 08/15/2013 
// Design Name: 
// Module Name:    KEYBOARD 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module KEYBOARD(
clk,
ps2_clk,
ps2_data,
ps2_byte
);         
input clk,ps2_clk,ps2_data;
output [7:0] ps2_byte;                   //捕捉下降沿 
reg ps2_clk0,ps2_clk1,ps2_clk2 = 0;
wire neg_ps2_clk;
wire pos_ps2_clk;
reg key_f0 = 0;       
reg key_e0 = 0;           
reg [7:0] ps2_asc = 0;                   
reg [7:0] ps2_byte_r = 0;   //ouput ps2_byte??的寄存器?量
reg [7:0] temp_data = 0; 
reg [3:0] num = 0; 
reg key_caps = 0;

assign ps2_byte = ps2_asc;   
assign neg_ps2_clk = ps2_clk2 & ~ps2_clk1;                   //按照?序?行取? 
assign pos_ps2_clk = ~ps2_clk2 & ps2_clk1; 

always @(posedge clk) 
begin 
ps2_clk0 <= ps2_clk; 
ps2_clk1 <= ps2_clk0;
ps2_clk2 <= ps2_clk1; 
end

       
always @(posedge clk) 
if(neg_ps2_clk)            //?下降沿?，出?事件
	begin 
		case(num) 
			4'd0: num <= num + 1;           //?始?? 
			4'd1: 
			begin 
				num <= num + 1; 
				temp_data[0] <= ps2_data; 
			end  
			4'd2:
			begin 
				num <= num + 1;
				temp_data[1] <= ps2_data; 
			end
			4'd3:  
			begin
				num <= num + 1; 
				temp_data[2] <= ps2_data; 
			end
			4'd4:  
			begin   
				num <= num + 1;   
				temp_data[3] <= ps2_data;   
			end 
			4'd5:
			begin 
				num <= num + 1; 
				temp_data[4] <= ps2_data; 
			end 
			4'd6: 
			begin  
				num <= num + 1;   
				temp_data[5] <= ps2_data;  
			end
			4'd7: 
			begin
				num <= num + 1;
				temp_data[6] <= ps2_data; 
			end 
			4'd8:  
			begin  
				num <= num + 1;  
				temp_data[7] <= ps2_data; 
			end 
			4'd9:  num <= num + 1;
			4'd10: num <= 0;
			default: begin end
		endcase 
	end 
	

always @(posedge clk)               
if(num == 4'd10 && pos_ps2_clk)           
begin                          
	if(temp_data == 8'hf0)  //BREAK
	begin
		key_f0 <= 1; 
		ps2_byte_r <= 0;
	end
	else if(temp_data == 8'he0)
	begin
		key_e0 <= 1;
	end
	else                         
	begin                                  
		if(key_f0 == 0)       
		begin
			ps2_byte_r <= temp_data;   
			key_f0 <= 0;
			if(temp_data == 8'h58)
			begin
				if(key_caps == 1)
				begin
					key_caps <= 0;
				end
				else if(key_caps == 0)
				begin
					key_caps <= 1;
				end
			end
		end	  
		else if(key_f0 == 1) //BREAK
		begin
			key_e0 <= 0;
			key_f0 <= 0; 
			ps2_byte_r <= 0;
		end
	end                 
end                        




always @(posedge clk)         
if(key_e0 == 0)     
begin 

	
	case(ps2_byte_r)  
		8'h00: ps2_asc <= 8'h00;        //NULL 
		8'h15: if(key_caps == 1)ps2_asc <= 8'h51;else ps2_asc <= 8'h71;      //Q                         
		8'h1d: if(key_caps == 1)ps2_asc <= 8'h57;else ps2_asc <= 8'h77;        //W                         
		8'h24: if(key_caps == 1)ps2_asc <= 8'h45;else ps2_asc <= 8'h65;        //E                         
		8'h2d: if(key_caps == 1)ps2_asc <= 8'h52;else ps2_asc <= 8'h72;        //R                         
		8'h2c: if(key_caps == 1)ps2_asc <= 8'h54;else ps2_asc <= 8'h74;        //T                         
		8'h35: if(key_caps == 1)ps2_asc <= 8'h59;else ps2_asc <= 8'h79;        //Y                         
		8'h3c: if(key_caps == 1)ps2_asc <= 8'h55;else ps2_asc <= 8'h75;        //U                         
		8'h43: if(key_caps == 1)ps2_asc <= 8'h49;else ps2_asc <= 8'h69;        //I                         
		8'h44: if(key_caps == 1)ps2_asc <= 8'h4f;else ps2_asc <= 8'h6F;        //O                         
		8'h4d: if(key_caps == 1)ps2_asc <= 8'h50;else ps2_asc <= 8'h70;        //P                         
		8'h1c: if(key_caps == 1)ps2_asc <= 8'h41;else ps2_asc <= 8'h61;        //A                         
		8'h1b: if(key_caps == 1)ps2_asc <= 8'h53;else ps2_asc <= 8'h73;        //S                         
		8'h23: if(key_caps == 1)ps2_asc <= 8'h44;else ps2_asc <= 8'h64;        //D                         
		8'h2b: if(key_caps == 1)ps2_asc <= 8'h46;else ps2_asc <= 8'h66;        //F                         
		8'h34: if(key_caps == 1)ps2_asc <= 8'h47;else ps2_asc <= 8'h67;        //G                         
		8'h33: if(key_caps == 1)ps2_asc <= 8'h48;else ps2_asc <= 8'h68;        //H                         
		8'h3b: if(key_caps == 1)ps2_asc <= 8'h4a;else ps2_asc <= 8'h6a;        //J                         
		8'h42: if(key_caps == 1)ps2_asc <= 8'h4b;else ps2_asc <= 8'h6b;        //K                                       
		8'h4b: if(key_caps == 1)ps2_asc <= 8'h4c;else ps2_asc <= 8'h6c;        //L                         
		8'h1a: if(key_caps == 1)ps2_asc <= 8'h5a;else ps2_asc <= 8'h7a;        //Z                         
		8'h22: if(key_caps == 1)ps2_asc <= 8'h58;else ps2_asc <= 8'h78;        //X                         
		8'h21: if(key_caps == 1)ps2_asc <= 8'h43;else ps2_asc <= 8'h63;        //C                         
		8'h2a: if(key_caps == 1)ps2_asc <= 8'h56;else ps2_asc <= 8'h76;        //V                         
		8'h32: if(key_caps == 1)ps2_asc <= 8'h42;else ps2_asc <= 8'h62;       //B                         
		8'h31: if(key_caps == 1)ps2_asc <= 8'h4e;else ps2_asc <= 8'h6e;        //N                         
		8'h3a: if(key_caps == 1)ps2_asc <= 8'h4d;else ps2_asc <= 8'h6d;        //M  
		
		8'h45 : ps2_asc <= 8'h30;        //0  
		8'h16 : ps2_asc <= 8'h31;        //1 
		8'h1E : ps2_asc <= 8'h32;        //2 
		8'h26 : ps2_asc <= 8'h33;        //3 
		8'h25 : ps2_asc <= 8'h34;        //4 
		8'h2E : ps2_asc <= 8'h35;        //5 
		8'h36 : ps2_asc <= 8'h36;        //6 
		8'h3D : ps2_asc <= 8'h37;        //7 
		8'h3E : ps2_asc <= 8'h38;        //8 
		8'h46 : ps2_asc <= 8'h39;        //9 
		8'h0E : ps2_asc <= 8'h27;        //'
		8'h4E : ps2_asc <= 8'h2D;        //-
		8'h55 : ps2_asc <= 8'h3D;        //=
		8'h5D : ps2_asc <= 8'h5C;        //\
		8'h66 : ps2_asc <= 8'h08;	//BKSP
		8'h29 : ps2_asc <= 8'h20;	//SPACE
		8'h0D : ps2_asc <= 8'h09;	//TAB
		8'h58 : ps2_asc <= 8'h14;	//CAPS
		8'h12 : ps2_asc <= 8'h10;	//L SHFT
		8'h14 : ps2_asc <= 8'h11;	//L CTRL
		8'h59 : ps2_asc <= 8'h10;	//R SHFT
		8'h5A : ps2_asc <= 8'h0D;	//ENTER
		8'h76 : ps2_asc <= 8'h1B;	//ESC
		8'h54 : ps2_asc <= 8'h5B;	//[
		8'h77 : ps2_asc <= 8'h90;	//NUM
		8'h7C : ps2_asc <= 8'h2A;	//KP *
		8'h7B : ps2_asc <= 8'h2D;	//KP -
		8'h79 : ps2_asc <= 8'h2B;	//KP +
		8'h71 : ps2_asc <= 8'h2E;	//KP .
		8'h70 : ps2_asc <= 8'h30;	//KP 0
		8'h69 : ps2_asc <= 8'h31;	//KP 1
		8'h72 : ps2_asc <= 8'h32;	//KP 2
		8'h7A : ps2_asc <= 8'h33;	//KP 3
		8'h6B : ps2_asc <= 8'h34;	//KP 4
		8'h73 : ps2_asc <= 8'h35;	//KP 5
		8'h74 : ps2_asc <= 8'h36;	//KP 6
		8'h6C : ps2_asc <= 8'h37;	//KP 7
		8'h75 : ps2_asc <= 8'h38;	//KP 8
		8'h7D : ps2_asc <= 8'h39;	//KP 9
		8'h5B : ps2_asc <= 8'h5D;	//]
		8'h4C : ps2_asc <= 8'h3A;	//;
		8'h52 : ps2_asc <= 8'h27;	//'
		8'h41 : ps2_asc <= 8'h2C;	//,
		8'h49 : ps2_asc <= 8'h2E;	//.
		8'h4A : ps2_asc <= 8'h2F;	///
		default : begin end
	endcase                         
end
else if(key_e0 == 1)  
begin
	case(ps2_byte_r)  
		8'h14 : ps2_asc <= 8'h11;	//	R CTRL
		8'h70 : ps2_asc <= 8'h2D;	//	INSERT
		8'h6C : ps2_asc <= 8'h24;	//	HOME
		8'h7D : ps2_asc <= 8'h21;	//	PG UP
		8'h71 : ps2_asc <= 8'h2E;	//	DELETE
		8'h69 : ps2_asc <= 8'h23;	//	END
		8'h7A : ps2_asc <= 8'h22;	//	PG DN
		8'h75 : ps2_asc <= 8'h26;	//	U ARROW
		8'h6B : ps2_asc <= 8'h25;	//	L ARROW
		8'h72 : ps2_asc <= 8'h28;	//	D ARROW
		8'h74 : ps2_asc <= 8'h27;	//	R ARROW
		8'h4A : ps2_asc <= 8'h2F;	//	KP /
		8'h5A : ps2_asc <= 8'h0D;	//	KP EN
		default : begin end
	endcase       
end
 
endmodule
