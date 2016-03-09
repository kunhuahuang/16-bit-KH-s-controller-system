module DMAX(
clk,
DEVICE,
DATA,
DMAX_row_out,
DMAX_column_out
);

input clk;
input [15:0] DEVICE;
input [15:0] DATA;
output [41:0] DMAX_row_out;
output [29:0] DMAX_column_out;

reg [41:0] DMAX_row_out ;
reg [29:0] DMAX_column_out ;
reg [29:0] DMAX [6:0];
reg [2:0] DMAX_count=0;
reg [6:0] DMAX_row = 7'b0000001;
wire [47:0] HEX_out;
wire [15:0] DEVICE;
wire [15:0] DATA;
reg [15:0] count;

always @(negedge clk)
begin
 count <= count +1;
end


always @(negedge count[15])
begin
DMAX_column_out <= ~DMAX[DMAX_count];
DMAX_row_out <= {6{DMAX_row}};
end


always @(posedge count[15])
begin
case(DMAX_count)
  3'b000:begin DMAX_count <= 3'b001;DMAX_row <=7'b0000010; end
  3'b001:begin DMAX_count <= 3'b010;DMAX_row <=7'b0000100; end
  3'b010:begin DMAX_count <= 3'b011;DMAX_row <=7'b0001000; end
  3'b011:begin DMAX_count <= 3'b100;DMAX_row <=7'b0010000; end
  3'b100:begin DMAX_count <= 3'b101;DMAX_row <=7'b0100000; end
  3'b101:begin DMAX_count <= 3'b110;DMAX_row <=7'b1000000; end
  3'b110:begin DMAX_count <= 3'b000;DMAX_row <=7'b0000001; end
  default: begin DMAX_count <= 3'b000;DMAX_row <=7'b0000001; end 
endcase 
end


always @(negedge clk)
begin
	case(DEVICE)
	
	16'h0040:
	begin
				  if(DATA[15:11] == 5'b00000)
				  begin
              end
				  else if(DATA[15:11] == 5'b00001)
				  begin
					 DMAX[0] <= {DMAX[0][29:1],DATA[0]};
				    DMAX[1] <= {DMAX[1][29:1],DATA[1]};
				    DMAX[2] <= {DMAX[2][29:1],DATA[2]};
				    DMAX[3] <= {DMAX[3][29:1],DATA[3]};
					 DMAX[4] <= {DMAX[4][29:1],DATA[4]};
					 DMAX[5] <= {DMAX[5][29:1],DATA[5]};
					 DMAX[6] <= {DMAX[6][29:1],DATA[6]};
				  end
				  else if((DATA[15:11] > 5'b00001) &&(DATA[15:11] < 5'b11110))
				  begin
				     DMAX[0][(DATA[15:11]-1)] <=DATA[0];
					  DMAX[1][(DATA[15:11]-1)] <=DATA[1];
					  DMAX[2][(DATA[15:11]-1)] <=DATA[2];
					  DMAX[3][(DATA[15:11]-1)] <=DATA[3];
					  DMAX[4][(DATA[15:11]-1)] <=DATA[4];
					  DMAX[5][(DATA[15:11]-1)] <=DATA[5];
					  DMAX[6][(DATA[15:11]-1)] <=DATA[6];

				  end
				  else if(DATA[15:11] == 5'b11110)
				  begin
					 DMAX[0] <= {DATA[0],DMAX[0][28:0]};
				    DMAX[1] <= {DATA[1],DMAX[1][28:0]};
				    DMAX[2] <= {DATA[2],DMAX[2][28:0]};
				    DMAX[3] <= {DATA[3],DMAX[3][28:0]};
					 DMAX[4] <= {DATA[4],DMAX[4][28:0]};
					 DMAX[5] <= {DATA[5],DMAX[5][28:0]};
					 DMAX[6] <= {DATA[6],DMAX[6][28:0]};
				  end
	end
	default:begin end
	endcase
end
endmodule
