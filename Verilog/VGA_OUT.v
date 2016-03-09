module VGA_OUT(r,g,b,hs,vs,clk_50,
ram_picture_position_write, // input [0 : 0] web
ram_picture_position_address_rw, // input [9 : 0] addrb
ram_picture_position_din, // input [25 : 0] dinb
ram_picture_write, // input [0 : 0] web
ram_picture_address_rw, // input [11 : 0] addrb
ram_picture_din, // input [15 : 0] dinb
ram_word_position_write, // input [0 : 0] web
ram_word_position_address_b, // input [9 : 0] addrb
ram_word_position_din, // input [25 : 0] dinb
ram_480_480_write, // input [0 : 0] web
ram_480_480_address_rw, // input [8 : 0] addrb
ram_480_480_din, // input [479 : 0] dinb
ram_480_480_dout_rw // output [479 : 0] doutb
);




input clk_50;
output r,b,g,hs,vs;

input ram_picture_position_write; // input [0 : 0] web
input [9 : 0] ram_picture_position_address_rw; // input [9 : 0] addrb
input [25 : 0]  ram_picture_position_din; // input [25 : 0] dinb

input ram_picture_write; // input [0 : 0] web
input [11 : 0] ram_picture_address_rw; // input [11 : 0] addrb
input [15 : 0] ram_picture_din; // input [15 : 0] dinb

input ram_word_position_write; // input [0 : 0] web
input [9 : 0] ram_word_position_address_b; // input [9 : 0] addrb
input [25 : 0] ram_word_position_din; // input [25 : 0] dinb

input ram_480_480_write; // input [0 : 0] web
input [8 : 0] ram_480_480_address_rw; // input [8 : 0] addrb
input [479 : 0] ram_480_480_din; // input [479 : 0] dinb
output [479 : 0]ram_480_480_dout_rw; // output [479 : 0] doutb



reg vs,hs;
reg r;
reg g;
reg b;

reg [9:0] count_h,count_v = 0;
reg [9:0] count_h_moniter_temp,count_v_moniter_temp = 0;
reg [479:0] moniter;
reg [479:0] moniter_temp;
reg [8:0] count_moniter_h =0; // 480
reg [8:0] count_moniter_v =0;// 480

wire clk_50;
reg edge_clk = 0;
//////////////////////////
wire ram_480_480_write ;
wire [479:0] ram_480_480_din;
wire [479:0] ram_480_480_dout;
wire [479:0] ram_480_480_dout_rw;
reg [8:0] ram_480_480_address =0 ;  // 480
wire [8:0] ram_480_480_address_rw;
//////////////////////////
wire ram_picture_position_write;
reg [9 : 0] ram_picture_position_address;
wire [9 : 0] ram_picture_position_address_rw;
wire [25: 0] ram_picture_position_din;
wire [25: 0] ram_picture_position_dout;
wire [25: 0] ram_picture_position_dout_rw;
reg [8:0] ram_picture_position_x;
//////////////////////////
wire ram_word_position_write;
reg [9 : 0] ram_word_position_address;
wire [9 : 0] ram_word_position_address_b;
wire [25: 0] ram_word_position_din;
wire [25: 0] ram_word_position_dout;
reg [8:0] ram_word_position_x;
//////////////////////////
wire ram_picture_write;
reg [11 : 0] ram_picture_address;
wire [11 : 0] ram_picture_address_rw;
wire [15 : 0] ram_picture_din;
wire [15 : 0] ram_picture_dout;
wire [15 : 0] ram_picture_dout_r;
//////////////////////////
reg [11 : 0] ram_word_address;
wire [15 : 0] ram_word_dout;
wire [15 : 0] ram_word_dout_r;
//////////////////////////
//////////////////////////
reg get_pic =0;
reg get_word =0;
reg ram_position_flag = 0;
reg ram_word_pic_flag = 0;
reg moniter_change = 1 ;
//////////////////////////


VGA_RAM_480_480 ram_vga(
  .clka(clk_50), // input clka
  .wea(0), // input [0 : 0] wea
  .addra(ram_480_480_address), // input [8 : 0] addra
  .dina(0), // input [479 : 0] dina
  .douta(ram_480_480_dout), // output [479 : 0] douta
  .clkb(clk_50), // input clka
  .web(ram_480_480_write), // input [0 : 0] web
  .addrb(ram_480_480_address_rw), // input [8 : 0] addrb
  .dinb(ram_480_480_din), // input [479 : 0] dinb
  .doutb(ram_480_480_dout_rw) // output [479 : 0] doutb
  );
////////////////////////////////////////////
RAM_Define_picture ram_picture_position(
  .clka(clk_50),  // input clka
  .wea(0),// input [0 : 0] wea
  .addra(ram_picture_position_address), // input [9 : 0] addra
  .dina(0), // input [25 : 0] dina
  .douta(ram_picture_position_dout), // output [25 : 0] douta
  .clkb(clk_50), // input clkb
  .web(ram_picture_position_write), // input [0 : 0] web
  .addrb(ram_picture_position_address_rw), // input [9 : 0] addrb
  .dinb(ram_picture_position_din), // input [25 : 0] dinb
  .doutb() // output [25 : 0] doutb
);

RAM_picture ram_picture(
  .clka(clk_50),                         
  .wea(0),
  .addra(ram_picture_address), 
  .dina(0),  
  .douta(ram_picture_dout_r), //transfer
  .clkb(clk_50), // input clkb
  .web(ram_picture_write), // input [0 : 0] web
  .addrb(ram_picture_address_rw), // input [11 : 0] addrb
  .dinb(ram_picture_din), // input [15 : 0] dinb
  .doutb() // output [15 : 0] doutb
);

////////////////////////////////////////////
RAM_Define_word ram_word_position(
  .clka(clk_50),                   // input clka
  .wea(0),    // input [0 : 0] wea
  .addra(ram_word_position_address), // input [9 : 0] addra
  .dina(0),  // input [25 : 0] dina
  .douta(ram_word_position_dout), // output [25 : 0] douta
  .clkb(clk_50), // input clkb
  .web(ram_word_position_write), // input [0 : 0] web
  .addrb(ram_word_position_address_b), // input [9 : 0] addrb
  .dinb(ram_word_position_din), // input [25 : 0] dinb
  .doutb() // output [25 : 0] doutb
);

RAM_word ram_word(
  .clka(clk_50), 					// input clka
  .addra(ram_word_address), 	// input [11 : 0] addra
  .douta(ram_word_dout_r)			// output [15 : 0] douta// transfer
);

assign 

ram_word_dout[15] = ram_word_dout_r[0],
ram_word_dout[14] = ram_word_dout_r[1],
ram_word_dout[13] = ram_word_dout_r[2],
ram_word_dout[12] = ram_word_dout_r[3],
ram_word_dout[11] = ram_word_dout_r[4],
ram_word_dout[10] = ram_word_dout_r[5],
ram_word_dout[9] = ram_word_dout_r[6],
ram_word_dout[8] = ram_word_dout_r[7],
ram_word_dout[7] = ram_word_dout_r[8],
ram_word_dout[6] = ram_word_dout_r[9],
ram_word_dout[5] = ram_word_dout_r[10],
ram_word_dout[4] = ram_word_dout_r[11],
ram_word_dout[3] = ram_word_dout_r[12],
ram_word_dout[2] = ram_word_dout_r[13],
ram_word_dout[1] = ram_word_dout_r[14],
ram_word_dout[0] = ram_word_dout_r[15],

ram_picture_dout[15] = ram_picture_dout_r[0],
ram_picture_dout[14] = ram_picture_dout_r[1],
ram_picture_dout[13] = ram_picture_dout_r[2],
ram_picture_dout[12] = ram_picture_dout_r[3],
ram_picture_dout[11] = ram_picture_dout_r[4],
ram_picture_dout[10] = ram_picture_dout_r[5],
ram_picture_dout[9] = ram_picture_dout_r[6],
ram_picture_dout[8] = ram_picture_dout_r[7],
ram_picture_dout[7] = ram_picture_dout_r[8],
ram_picture_dout[6] = ram_picture_dout_r[9],
ram_picture_dout[5] = ram_picture_dout_r[10],
ram_picture_dout[4] = ram_picture_dout_r[11],
ram_picture_dout[3] = ram_picture_dout_r[12],
ram_picture_dout[2] = ram_picture_dout_r[13],
ram_picture_dout[1] = ram_picture_dout_r[14],
ram_picture_dout[0] = ram_picture_dout_r[15];




always @(posedge clk_50)
begin
		if(count_v > 31 && count_v < 512)
		begin
			if((count_h > 209) && (count_h < 690))
			begin
				r<= (moniter[count_moniter_h[8:0]] == 1)? 1:0 ;
				g<= (moniter[count_moniter_h[8:0]] == 1)? 1:0 ;
				b<= (moniter[count_moniter_h[8:0]] == 1)? 1:0 ;
			end
			else 
			begin
				r<= 0;
				g<= 0;
				b<= 0;
			end
		end
end



always @(negedge clk_50)
if(edge_clk == 0) //W
begin
      edge_clk  <= 1;
		if(count_h == 0) hs <= 0;
		if(count_v == 2) vs <= 1;
		if(count_h == 96) hs <= 1;
		if(count_v == 0) 		
		begin
			count_moniter_v <= 0;
			count_moniter_h <= 0;	
			vs <= 0; 
		end

		if(count_v > 31 && count_v < 512)
		begin
			if((count_h > 209) && (count_h < 690))
			begin

				if((count_moniter_h < 479) && (count_moniter_v < 479))
				begin
					count_moniter_h <= count_moniter_h +1;
					count_moniter_v <= count_moniter_v ;
				end
				else if((count_moniter_h == 479) && (count_moniter_v < 479 ))
				begin
					count_moniter_v  <=count_moniter_v +1;
					count_moniter_h  <= 0;
				end
				else if(count_moniter_h < 479 && (count_moniter_v == 479 ))
				begin
					count_moniter_h <= count_moniter_h +1;
				end
				else if(count_moniter_h == 479 && (count_moniter_v == 479 ))
				begin
					count_moniter_v  <= 0;
					count_moniter_h  <= 0;
				end
			end			                            
		end
end
else if(edge_clk == 1) //R
begin
		edge_clk <= 0;
		if (count_h == 800)
		begin
			count_h <= 0;
			count_h_moniter_temp <= 0;
		end
		else 
		begin
			count_h <= count_h +1;		
			count_h_moniter_temp <= count_h_moniter_temp + 1;			
		end
		if (count_v == 525)
		begin
			count_v <= 0;
			
		end	
		else if(count_h == 800)
		begin
			count_v <= count_v +1;
			
			if(count_v == 30)
			begin
				count_v_moniter_temp <= 0;
			end
			else 
			count_v_moniter_temp <= count_v_moniter_temp +1;	
		end
end

always @(negedge clk_50)
begin 

		///////////////////////output moniter//////////////////
		if(count_v > 31 && count_v < 512)
		begin
			if(count_h ==2)
			begin
				moniter <= moniter_temp;	
			end
		end
		///////////////////////////////////////////////////////
		if(count_v_moniter_temp <= 479 && count_h_moniter_temp == 5) // CLEAR VGA_480_480
		begin
			ram_480_480_address <= count_v_moniter_temp[8:0];
			moniter_temp <= 0;
		end
		if(count_v_moniter_temp <= 479 && count_h_moniter_temp == 6)
		begin
			moniter_temp <= ram_480_480_dout;
		end

		if(count_v_moniter_temp <= 479 && count_h_moniter_temp == 10)  //ORIGIN moniter fresh
		begin
			ram_position_flag <= 0;
			ram_word_pic_flag <= 0;
			ram_picture_position_address <= 0;
			ram_word_position_address <= 0;
		end
		if(count_v_moniter_temp <= 479 && count_h_moniter_temp > 10) // Still need to set some condition
		begin
			if(ram_picture_position_address < 1023 && ram_word_position_address < 1023 && ram_position_flag == 0)
			begin
				ram_picture_position_address <= ram_picture_position_address +1 ;
				ram_word_position_address <= ram_word_position_address +1;
			end
			else if(ram_picture_position_address == 1023 && ram_word_position_address == 1023 && ram_position_flag ==0)
			begin
				ram_picture_position_address <= 0;
				ram_word_position_address <= 0;
				ram_position_flag <=1 ; 
			end
			else if(ram_picture_position_address == 0 && ram_word_position_address == 0 && ram_position_flag ==1) 
			begin
				ram_word_pic_flag <= 1;
			end
			///////////////////////////////////////////////////////////
			if(count_v_moniter_temp >= ram_word_position_dout[16:8] && count_v_moniter_temp <= ram_word_position_dout[16:8]+15 && ram_word_pic_flag == 0) //位置設定
			begin
				ram_word_address <= {ram_word_position_dout[7:0], count_v_moniter_temp[3:0] - ram_word_position_dout[11:8]};
				get_word <= 1;
				ram_word_position_x <= ram_word_position_dout[25:17];  //X- position of word
			end
			else
			begin
				get_word <= 0;
			end
			///////////////////////////////////////////////////////////
			if(count_v_moniter_temp >= ram_picture_position_dout[16:8] && count_v_moniter_temp <= ram_picture_position_dout[16:8]+15 && ram_word_pic_flag == 0) //位置設定
			begin
				ram_picture_address <= {ram_picture_position_dout[7:0], count_v_moniter_temp[3:0] - ram_picture_position_dout[11:8]};
				get_pic <= 1;
				ram_picture_position_x <= ram_picture_position_dout[25:17]; //X- position of picture
			end
			else
			begin
				get_pic <= 0;
			end
			////////////////////////////////////////////////////////////
			if(get_pic == 1 || get_word ==1)
			begin
				moniter_temp <= moniter_temp | (get_pic?(ram_picture_dout << ram_picture_position_x):0)  | (get_word?(ram_word_dout << ram_word_position_x):0);
			end
		end
end

endmodule
