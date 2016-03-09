`timescale 1ns / 1ps

module ADD3(
in,out);
input [3:0] in;
output [3:0] out;
wire [3:0] in;
reg [3:0] out;


always@(in or out)
begin
  case(in)
  4'b0000:begin out=4'b0000;end
  4'b0001:begin out=4'b0001;end
  4'b0010:begin out=4'b0010;end
  4'b0011:begin out=4'b0011;end
  4'b0100:begin out=4'b0100;end
  4'b0101:begin out=4'b1000;end
  4'b0110:begin out=4'b1001;end
  4'b0111:begin out=4'b1010;end
  4'b1000:begin out=4'b1011;end
  4'b1001:begin out=4'b1100;end
  default:begin out=4'b0000;end
  endcase
end

endmodule
