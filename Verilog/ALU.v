`timescale 1ns / 1ps
module ALU(ALU_IN1,ALU_IN0,ALU_OUT,ALU_MODE,FLAG_in,FLAG_out);
input [15:0] ALU_IN1,ALU_IN0;
input [2:0] ALU_MODE;
input [15:0] FLAG_in;
output [15:0] FLAG_out;
output [15:0] ALU_OUT;

wire [15:0] ALU_IN1,ALU_IN0;
wire [2:0] ALU_MODE;
wire [15:0] FLAG_in;
reg [15:0] FLAG_out;
reg [15:0] ALU_OUT;
//for Binery to Decimal
wire C0,C1,C2,CY_DA_out;
wire [15:0] DA_in;
wire [15:0]DA_out;
reg [15:0]ALU_OUT_DONTCARE;

//ALU main
always@(ALU_IN0 or ALU_IN1 or ALU_MODE or FLAG_in or ALU_OUT or CY_DA_out or DA_out) begin
  case(ALU_MODE)
    3'b000: begin//ADD
          	{FLAG_out[15],ALU_OUT} <= {{1'b0},ALU_IN1} + {{1'b0},ALU_IN0};
				FLAG_out[12] <= (ALU_OUT == 16'h0000)? 1'b1 :1'b0;
				FLAG_out[11:0] <= FLAG_in[11:0];
				FLAG_out[13] <= 1'b0;
				FLAG_out[14] <= 1'b0;
				end 
    3'b001: begin//SUB
	         if(ALU_IN1 >= ALU_IN0)
				begin
	         ALU_OUT <= ALU_IN1 - ALU_IN0;
				FLAG_out[13] <= 1'b0;
				end
				else if(ALU_IN1 < ALU_IN0)
				begin
				ALU_OUT <= ALU_IN0 - ALU_IN1;
				FLAG_out[13] <= 1'b1;
				end
				FLAG_out[12] <= (ALU_OUT == 16'h0000)? 1'b1 :1'b0;
				FLAG_out[11:0] <= FLAG_in[11:0];
				FLAG_out[14] <= 1'b0;
				FLAG_out[15] <= 1'b0;
				end
    3'b010: begin//MUXA
	         {ALU_OUT[15:0],ALU_OUT_DONTCARE[15:0]} <= ALU_IN1 * ALU_IN0;
 				FLAG_out[15:0] <= FLAG_in[15:0];
				end
    3'b011: begin//MUXB
	         {ALU_OUT_DONTCARE[15:0],ALU_OUT[15:0]} <= ALU_IN1 * ALU_IN0;
 				FLAG_out[15:0] <= FLAG_in[15:0];
				end
    3'b100: begin//BTD
	         ALU_OUT <= DA_out;
				FLAG_out[15] <= CY_DA_out;
				FLAG_out[14:0] <= FLAG_in[14:0];
				end
    3'b101: begin//INC
	         {FLAG_out[15],ALU_OUT} <= {1'b0,ALU_IN1} + 1'b1;
				FLAG_out[12] <= (ALU_OUT == 16'h0000)? 1'b1 :1'b0;
				FLAG_out[14:13] <= FLAG_in[14:13];
				FLAG_out[11:0] <= FLAG_in[11:0];
				end
    3'b110: begin//DEC
	         ALU_OUT <= ALU_IN1 - 1;
				FLAG_out[12] <= (ALU_OUT == 16'h0000)? 1'b1 :1'b0;
				FLAG_out[15:13] <= FLAG_in[15:13];
				FLAG_out[11:0] <= FLAG_in[11:0];
				end
    3'b111: begin//CLR
	         ALU_OUT <= 16'h0000;
				FLAG_out[15:12] <= 4'b0000;
				FLAG_out[11:0] <= FLAG_in[11:0];
				end
  endcase
end

//for Binery to Decimal
BIN_BCD B_BCD(.A(DA_in),.FORTH(DA_out[15:12]),.THIRD(DA_out[11:8]),.SECOND(DA_out[7:4]),.FIRST(DA_out[3:0]),.CY(CY_DA_out));


/*
assign 
{C0,DA_out[3:0]} = (DA_in[3:0] > 4'b1001)?({1'b0,DA_in[3:0]} + 5'b00110):{1'b0,DA_in[3:0]},
{C1,DA_out[7:4]} = ((DA_in[7:4] + {3'b000,C0}) > 4'b1001)?({1'b0,DA_in[7:4]} + 5'b00110 + {4'b0000,C0}):({1'b0,DA_in[7:4]} + {4'b0000,C0}),
{C2,DA_out[11:8]} = ((DA_in[11:8] + {3'b000,C1}) > 4'b1001)?({1'b0,DA_in[11:8]} + 5'b00110 + {4'b0000,C1}):({1'b0,DA_in[11:8]} + {4'b0000,C1}),
{CY_DA_out,DA_out[15:12]} = ((DA_in[15:12] + {3'b000,C2}) > 4'b1001)?({1'b0,DA_in[15:12]} + 5'b00110 + {4'b0000,C2}):({1'b0,DA_in[15:12]} + {4'b0000,C2});
*/
assign 
DA_in[15:0] = ALU_IN1[15:0];
//for Binery to Decimal

endmodule


