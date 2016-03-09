module Distance_Detect(
clk,
Trig,
Echo,
distance
);

input clk;
input Echo;
output Trig;
output [11:0] distance;

reg [20:0] count_start = 0;
reg [23:0] count_time = 0;
reg [11:0] count;
reg Trig = 0;
wire Echo; 
reg [11:0] distance = 0;




always @(negedge clk)
begin
	count_start <= count_start + 1;
end 


always @(posedge clk)
begin
	if(count_start == 0)
	begin
		Trig <= 1;
		distance <= count;
		count <= 0;
	end
	else if(count_start == 256)
	begin
		Trig <= 0;
		count_time <= 0;
	end
	else if(Echo == 1 && (count_start > 2941))
	begin
		if(count_time != 441)
		count_time <= count_time +1;
		else if(count_time == 441)
		begin
			count <= count +1;
			count_time <= 0;
		end
	end
	else if(Echo == 0  && (count_start > 2941) )
	begin
		count_time <= count_time;
	end
end
endmodule
