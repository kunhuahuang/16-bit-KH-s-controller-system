`timescale 1ns / 1ps
module LOG(LOG_IN1,LOG_IN0,LOG_OUT,LOG_MODE,LOG_CMODE,LOG_FLAG_in,LOG_FLAG_out);
input [15:0] LOG_IN1,LOG_IN0;
input [2:0] LOG_MODE;
input [15:0] LOG_FLAG_in;
input [2:0] LOG_CMODE;//EQ NE GT LE LT GE 
output [15:0] LOG_FLAG_out;
output [15:0] LOG_OUT;

wire [15:0] LOG_IN1,LOG_IN0;
wire [2:0] LOG_MODE;
wire [15:0] LOG_FLAG_in;
reg [15:0] LOG_FLAG_out;
reg [15:0] LOG_OUT;
wire [2:0] LOG_CMODE;//EQ NE GT LE LT GE 

//ALU main
always@(LOG_IN0 or LOG_IN1 or LOG_MODE or LOG_FLAG_in or LOG_CMODE) begin
  case(LOG_MODE)
    3'b000: begin//NOT
          	LOG_OUT <= ~LOG_IN1;
				LOG_FLAG_out <= LOG_FLAG_in;
				end 
    3'b001: begin//AND
          	LOG_OUT <= LOG_IN1 & LOG_IN0;
				LOG_FLAG_out <= LOG_FLAG_in;
				end
    3'b010: begin//NAND
          	LOG_OUT <= ~((LOG_IN1)&(LOG_IN0));
				LOG_FLAG_out <= LOG_FLAG_in;
				end
    3'b011: begin//OR
          	LOG_OUT <= LOG_IN1 | LOG_IN0;
				LOG_FLAG_out <= LOG_FLAG_in;
				end 
    3'b100: begin//NOR
          	LOG_OUT <= ~((LOG_IN1)|(LOG_IN0));
				LOG_FLAG_out <= LOG_FLAG_in;
				end
    3'b101: begin//XOR
          	LOG_OUT <= LOG_IN1 ^ LOG_IN0;
				LOG_FLAG_out <= LOG_FLAG_in;
				end
    3'b110: begin//XNOR
          	LOG_OUT <= LOG_IN1 ~^ LOG_IN0;
				LOG_FLAG_out <= LOG_FLAG_in;
				end
    3'b111: begin//EQ NE GT LE LT GE 
	         LOG_OUT <= 16'hxxxx;
          	case(LOG_CMODE)
				3'b000:begin//EQ 
				       LOG_FLAG_out[9] <= (LOG_IN1==LOG_IN0)?1'b1:1'b0;
						 LOG_FLAG_out[8:0] <= LOG_FLAG_in[8:0];
						 LOG_FLAG_out[15:10] <= LOG_FLAG_in[15:10];
						 end
				3'b001:begin//NE
				       LOG_FLAG_out[9] <= (LOG_IN1!=LOG_IN0)?1'b0:1'b1;
						 LOG_FLAG_out[8:0] <= LOG_FLAG_in[8:0];
						 LOG_FLAG_out[15:10] <= LOG_FLAG_in[15:10];
						 end
				3'b010:begin//GT
				       LOG_FLAG_out[8] <= (LOG_IN1 > LOG_IN0)?1'b1:1'b0;
						 LOG_FLAG_out[7:0] <= LOG_FLAG_in[7:0];
						 LOG_FLAG_out[15:9] <= LOG_FLAG_in[15:9];
						 end
				3'b011:begin//LE
				       {LOG_FLAG_out[9],LOG_FLAG_out[7]} <= (LOG_IN1 <= LOG_IN0)?{2'b11}:{2'b00};
						 LOG_FLAG_out[8] <= LOG_FLAG_in[8];
						 LOG_FLAG_out[15:10] <= LOG_FLAG_in[15:10];
						 LOG_FLAG_out[6:0] <= LOG_FLAG_in[6:0];
						 end
				3'b100:begin//LT
				       LOG_FLAG_out[7] <= (LOG_IN1 < LOG_IN0)?1'b1:1'b0;
						 LOG_FLAG_out[6:0] <= LOG_FLAG_in[6:0];
						 LOG_FLAG_out[15:8] <= LOG_FLAG_in[15:8];
						 end
				3'b101:begin//GE 
				       {LOG_FLAG_out[9],LOG_FLAG_out[8]} <= (LOG_IN1 >= LOG_IN0)?{2'b11}:{2'b00};
						 LOG_FLAG_out[7:0] <= LOG_FLAG_in[7:0];
						 LOG_FLAG_out[15:10] <= LOG_FLAG_in[15:10];
						 end
				default:begin
				       LOG_FLAG_out[15:0] <= LOG_FLAG_in[15:0];
						 end
			   endcase
				end
  endcase
end


endmodule

