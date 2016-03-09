`timescale 1ns / 1ps

module SHF(SHF_IN,SHF_TIMES,SHF_OUT,SHF_MODE,SHF_FLAG_in,SHF_FLAG_out);
input [15:0] SHF_IN;
input [3:0] SHF_TIMES;
input [3:0] SHF_MODE;
input [15:0] SHF_FLAG_in;
output [15:0] SHF_OUT;
output [15:0] SHF_FLAG_out;

wire [15:0] SHF_IN;
wire [3:0] SHF_TIMES;
wire [3:0] SHF_MODE;
wire [15:0] SHF_FLAG_in;
reg [15:0] SHF_OUT;
reg [15:0] SHF_FLAG_out;

always@(SHF_IN or SHF_TIMES or SHF_MODE or SHF_FLAG_in) begin
  case(SHF_MODE)
    4'b0000: begin//SHL
             SHF_OUT <= SHF_IN << SHF_TIMES;
				 SHF_FLAG_out[15:0] <= SHF_FLAG_in[15:0];
				 end 
    4'b0001: begin//SHR
	         SHF_OUT <= SHF_IN >> SHF_TIMES;
				SHF_FLAG_out[15:0] <= SHF_FLAG_in[15:0];
				end
    4'b0010: begin//SCL
	         {SHF_FLAG_out[15],SHF_OUT[15:0]} <= {SHF_FLAG_in[15],SHF_IN[15:0]} << SHF_TIMES;
				SHF_FLAG_out[14:0] <= SHF_FLAG_in[14:0];
			  	end
    4'b0011: begin//SCR
            {SHF_FLAG_out[15],SHF_OUT[15:0]} <= {SHF_FLAG_in[15],SHF_IN[15:0]} >> SHF_TIMES;
				SHF_FLAG_out[14:0] <= SHF_FLAG_in[14:0];
				end 
    4'b0100: begin//SAL
	         {SHF_FLAG_out[13],SHF_OUT[15:0]} <= {SHF_FLAG_in[13],SHF_IN[15:0]} <<< 1'b1;
				SHF_FLAG_out[15:14] <= SHF_FLAG_in[15:14];
				SHF_FLAG_out[12:0] <= SHF_FLAG_in[12:0];
				end
    4'b0101: begin//SAR
	         {SHF_FLAG_out[13],SHF_OUT[15:0]} <= {SHF_FLAG_in[13],SHF_IN[15:0]} >>> 1'b1;
				SHF_FLAG_out[15:14] <= SHF_FLAG_in[15:14];
				SHF_FLAG_out[12:0] <= SHF_FLAG_in[12:0];
				end
    4'b0110: begin//ROL
				SHF_OUT <= (SHF_IN << SHF_TIMES) + (SHF_IN >> (5'b10000 - {1'b0,SHF_TIMES}));
				SHF_FLAG_out[15:0] <= SHF_FLAG_in[15:0];
				end
    4'b0111: begin//ROR
	         SHF_OUT <= (SHF_IN >> SHF_TIMES) + (SHF_IN << (5'b10000 - {1'b0,SHF_TIMES}));
				SHF_FLAG_out[15:0] <= SHF_FLAG_in[15:0];
				end
	 4'b1000: begin//RCL
				{SHF_FLAG_out[15],SHF_OUT[15:0]} <= ({SHF_FLAG_in[15],SHF_IN[15:0]} << SHF_TIMES) + ({SHF_FLAG_in[15],SHF_IN[15:0]} >> (5'b10001 - {1'b0,SHF_TIMES}));
				SHF_FLAG_out[14:0] <= SHF_FLAG_in[14:0];
				end
    4'b1001: begin//RCR
	         {SHF_FLAG_out[15],SHF_OUT[15:0]} <= ({SHF_FLAG_in[15],SHF_IN[15:0]} >> SHF_TIMES) + ({SHF_FLAG_in[15],SHF_IN[15:0]} << (5'b10001 - {1'b0,SHF_TIMES}));
				SHF_FLAG_out[14:0] <= SHF_FLAG_in[14:0];
				end
    default : begin
	          SHF_OUT <= SHF_IN;
         	 SHF_FLAG_out[15:0] <= SHF_FLAG_in[15:0];
				 end				
  endcase
end


endmodule
