module KEY_PAD(
clk,
key_pad_row,
key_pad_column,
key_pad,
key_pad_flag
);

//////////////key_pad//////////////////

output [3:0] key_pad_row;
input [2:0] key_pad_column;
output [3:0] key_pad;
input key_pad_flag;
input clk;
///////////////DMAX////////////////////
/////////////////////key_pad////////////////////////

reg [3:0] key_pad_row = 4'b0111;
wire [2:0] key_pad_column;
reg [3:0] key_pad =4'b1111;
wire key_pad_flag; //key_pad_flag :1'b1 have input 1'b0 no input


//////////////////////////////////////

always@(posedge clk)
begin
	if(key_pad_flag == 1)
	begin
		key_pad_row <= 4'b1111;
	end
	else if(key_pad_flag == 0)
	begin
		if(key_pad_row == 4'b0111)
			begin
				key_pad_row <= 4'b1011;//±½´y
				if(key_pad_column == 3'b011)
				begin
					key_pad <= 4'b0001;//1
				end
				else if(key_pad_column == 3'b101)
				begin
					key_pad <= 4'b0010;//2
				end
				else if(key_pad_column == 3'b110)
				begin
					key_pad <= 4'b0011;//3
				end
			end
		if(key_pad_row == 4'b1011)
		begin
			key_pad_row <= 4'b1101;//±½?y
			if(key_pad_column == 3'b011)
			begin
				key_pad <= 4'b0100;//4
			end
			else if(key_pad_column == 3'b101)
			begin
				key_pad <= 4'b0101;//5
			end
			else if(key_pad_column == 3'b110)
			begin
				key_pad <= 4'b0110;//6
			end
		end
		if(key_pad_row == 4'b1101)
		begin
			key_pad_row <= 4'b1110;//±½´y
			if(key_pad_column == 3'b011)
			begin
				key_pad <= 4'b0111;//7
			end
			else if(key_pad_column == 3'b101)
			begin
				key_pad <= 4'b1000;//8
			end
			else if(key_pad_column == 3'b110)
			begin
				key_pad <= 4'b1001;//9
			end
		end 
	
		if(key_pad_row == 4'b1110)
		begin
			key_pad_row <= 4'b0111;//±½´y
			if(key_pad_column == 3'b011)
			begin
				key_pad <= 4'b1010;//*  (a)
			end
			else if(key_pad_column == 3'b101)
			begin
				key_pad <= 4'b0000;//0
			end
			else if(key_pad_column == 3'b110)
			begin
				key_pad <= 4'b1011;//#  (b)
			end
		end  
	end	 
end
	  

endmodule
