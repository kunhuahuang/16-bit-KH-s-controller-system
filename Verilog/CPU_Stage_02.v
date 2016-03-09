module CPU_Stage_02(
clk,
IN_DATA,
IR2_i,
IN0,
IN1,
register_wr, 
register_in_select, 
register_Din,
register_Out,
FLAG_o,
JUMP_return_stage_1,
register_wr_LOAD,
RAM_opcode_address_rw,
RAM_opcode_din_rw,
RAM_opcode_write_rw,
RAM_opcode_address_control,
Timer0_Address,
Timer1_Address,
ITR_Address,
ITR_in
);

input ITR_in;
input clk;
input [15:0] IR2_i;
input [15:0] IN0;
input [15:0] IN1;
output register_wr; 
output [3:0] register_in_select;
output [15:0] register_Din;
output [15:0] register_Out;
output [15:0] FLAG_o;
output [1:0] JUMP_return_stage_1;
output register_wr_LOAD;
output [11:0] RAM_opcode_address_rw;
output [15:0] RAM_opcode_din_rw;
output RAM_opcode_write_rw;
input [11:0] RAM_opcode_address_control;
input [15:0] IN_DATA;
output [11 : 0] Timer0_Address;
output [11 : 0] Timer1_Address;
output [11 : 0] ITR_Address ;


wire ITR_in;
wire [15:0] IN_DATA;
wire [11:0] RAM_opcode_address_control;
reg RAM_opcode_write_rw = 0;
reg [15:0] RAM_opcode_din_rw = 0;
reg [11:0] RAM_opcode_address_rw = 0;
reg register_wr_LOAD=0;
reg [1:0] JUMP_return_stage_1 = 0;
wire [15:0] FLAG_o;
wire clk;
wire [15:0] IR2_i;
wire [15:0] IN0;
wire [15:0] IN1;
reg register_wr  = 0; 
reg [3:0] register_in_select = 0;
reg [15:0] register_Din = 0;
reg [15:0] register_Out = 0;
reg [3:0] RAM_opcode_address_rw_dontcare;
reg [11 : 0] Timer0_Address;
reg [11 : 0] Timer1_Address;
reg [11 : 0] ITR_Address ;
reg [15:0]Timer0;
reg [15:0]Timer1;
////////////////////////////////////
reg [15:0] IR2 = 0;
reg [15:0] FLAG = 0;
reg [15:0] IN1_in = 0;
reg [15:0] IN0_in = 0;
reg [2:0] ALU_MODE_in = 0;
wire [15:0] IN2_wire_ALU;
wire [15:0] Flag_wire_ALU;
reg [4:0] FLAG_TEMP;
/////////////LOG/////////////////
wire [15:0] IN2_wire_LOG;
reg [2:0] LOG_MODE_in =0;
reg [2:0] LOG_CMODE_in = 0;
wire [15:0] Flag_wire_LOG;
/////////////SHF/////////////////
reg [3:0] SHF_TIMES =0;
wire [15:0] IN2_wire_SHF;
reg [3:0] SHF_MODE = 0;
wire [15:0] Flag_wire_SHF;
/////////////PUSH////////////////
reg [15:0] PUSH_REGISTER [127:0] ; //7-bit 128column
reg [6:0] PUSH_COUNTER =0;
///////////指令對應////////////////
parameter NULL = 4'b0000;
parameter ALU = 4'b0001;
parameter LOG = 4'b0010;
parameter SHF = 4'b0011;
parameter SYS =4'b0100;
parameter LOAD =4'b0101;//STORE
parameter SET =4'b0110;
parameter MOVE =4'b0111;
parameter PUSH =4'b1000;
parameter JZ =4'b1001;
parameter JNZ =4'b1010;
parameter JP =4'b1011;
parameter JMP =4'b1100;
parameter IN =4'b1101;//OUT
parameter CALL =4'b1110;//RET
parameter HALT =4'b1111;
////////////////////////////////// 
 
ALU ALU_COMPUTE(
.ALU_IN1(IN1_in), //input
.ALU_IN0(IN0_in),//input
.ALU_OUT(IN2_wire_ALU), //output
.ALU_MODE(ALU_MODE_in),//input
.FLAG_in(FLAG),//input
.FLAG_out(Flag_wire_ALU)//output
);

LOG LOG_COMPUTE(
.LOG_IN1(IN1_in),
.LOG_IN0(IN0_in),
.LOG_OUT(IN2_wire_LOG),
.LOG_MODE(LOG_MODE_in),
.LOG_CMODE(LOG_CMODE_in),
.LOG_FLAG_in(FLAG),
.LOG_FLAG_out(Flag_wire_LOG)
);

SHF SHF_COMPUTE(
.SHF_IN(IN1_in),
.SHF_TIMES(SHF_TIMES),
.SHF_OUT(IN2_wire_SHF),
.SHF_MODE(SHF_MODE),
.SHF_FLAG_in(FLAG),
.SHF_FLAG_out(Flag_wire_SHF)
);

assign 
FLAG_o = FLAG ;


always@(posedge clk)
begin
///////////////////////內部計時中斷///////////////////
	if(ITR_in == 1)
	begin
		FLAG[6] <= 1; 
	end
	if(Timer0 == 1)
	begin
		FLAG[3] <= 1; 
	end
	if(Timer1 == 1)
	begin
		FLAG[4] <= 1; 
	end
	if(IR2[15:12] == 4'b0111 && IR2[3:0] == 4'b0001)
	begin
	end
   else if(Timer0 != 0)
	begin
		Timer0 <= Timer0 - 1;
	end
	if(IR2[15:12] == 4'b0111 && IR2[3:0] == 4'b0010)
	begin
	end
   else if(Timer1 != 0)
	begin
		Timer1 <= Timer1 - 1;
	end
///////////////////////內部計時中斷///////////////////
	case(IR2[15:12])  //PIPLINE STAGE2   
		NULL,JZ,JNZ,JP,JMP,CALL,HALT: //不需要任何資料寫入
		begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0;
		end
      ALU:
		begin
			register_wr_LOAD <= 0;
			register_wr <= 1;
			register_in_select <= {1'b0,IR2[11:9]};
			register_Din <= IN2_wire_ALU;
			FLAG[15:12] <= Flag_wire_ALU[15:12];
		end
      LOG:
		begin
			register_wr_LOAD <= 0;
			if(IR2[2:0] != 3'b111)
			begin
			register_wr <= 1;
			register_in_select <= {1'b0,IR2[11:9]};
			register_Din <= IN2_wire_LOG;
			FLAG[15:12] <= Flag_wire_LOG[15:12];
			end
			else
			begin
			register_Din <= 0;			
			register_in_select <= 0;			
			register_wr <= 0;
			FLAG[15:7] <= Flag_wire_LOG[15:7];
			end
		end
      SHF:
		begin
			register_wr_LOAD <= 0;
			register_wr <= 1;
			register_in_select <= {IR2[11:8]};
			register_Din <= IN2_wire_SHF;
			FLAG[15:12] <= Flag_wire_SHF[15:12];
		end
      SYS:
		begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0;
			case(IR2[4:0])
             5'b00000: begin//SETCY
               FLAG[15] <= 1'b1;
				          end 
             5'b00001: begin//CLRCY
	            FLAG[15] <= 1'b0;
			     	       end
             5'b00010: begin//SETSF
	            FLAG[13] <= 1'b1;
			  	          end
             5'b00011: begin//CLRSF
	            FLAG[13] <= 1'b0;
			          	end 
             5'b00100: begin//SETEQ
	            FLAG[9] <= 1'b1;
			          	end
             5'b00101: begin//CLREQ
	            FLAG[9] <= 1'b0;
				          end
             5'b00110: begin//SETBT
	            FLAG[8] <= 1'b1;
				          end
             5'b00111: begin//CLRBT
	            FLAG[8] <= 1'b0;
				          end
	          5'b01000: begin//SETST
	            FLAG[7] <= 1'b1;
				          end
             5'b01001: begin//CLRST
	            FLAG[7] <= 1'b0;
				          end
             5'b01010: begin//SETIEN
	            FLAG[5] <= 1'b1;
			          	end
             5'b01011: begin//CLRIEN
	            FLAG[5] <= 1'b0;
				          end
             5'b01100: begin//SETIT1
	            FLAG[4] <= 1'b1;
				          end
             5'b01101: begin//CLRIT1
	            FLAG[4] <= 1'b0;
			          	end
             5'b01110: begin//SETIT0
	            FLAG[3] <= 1'b1;
		          		end
             5'b01111: begin//CLRIT0
	            FLAG[3] <= 1'b0;
				          end
             5'b10000: begin//SETITR
	            FLAG[6] <= 1'b1;
		          		end
             5'b10001: begin//CLRITR
	            FLAG[6] <= 1'b0;
				          end 
             default : begin end				
			endcase
		end
		LOAD:		
		begin
			if(IR2[3:0] == 4'b0000) // LOAD
			begin
			register_in_select <= IR2[11:8];
			register_Din <= 0;
			register_wr <= 0;
			register_wr_LOAD <= 1; //WRITE IN register //在其他敘述中需要初始還原
			end
			else if(IR2[3:0] == 4'b1111)// STORE
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr <= 0;
			register_wr_LOAD <= 0; //WRITE IN RAM of OPCODE //在其他敘述中需要初始還原
			end
		end
		SET:
		begin
			register_in_select <= IR2[11:8];
			register_Din <= 0;
			register_wr_LOAD <= 1;
			register_wr <= 0;
		end
		MOVE:  //還有TIMER未放入
		begin
			if(IR2[3:0] == {4{1'b0}}) 
			begin
			register_in_select <= IR2[11:8];
			register_Din <= IN0_in;
			register_wr_LOAD <= 0;
			register_wr <= 1; 
			end
			if(IR2[3:0] == 4'b0001) 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0; 
			Timer0_Address <= IN0_in[11:0];
			Timer0 <= IN1_in ;
			end
			if(IR2[3:0] == 4'b0010) 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0; 
			Timer1_Address <= IN0_in[11:0];
			Timer1 <= IN1_in ;
			end
			if(IR2[3:0] == 4'b0011) 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0; 
			ITR_Address <= IN0_in[11:0];
			end
			if(IR2[3:0] == 4'b0100) 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0;
         FLAG_TEMP <= {FLAG[15],FLAG[13],FLAG[9],FLAG[8],FLAG[7]};
			end
			if(IR2[3:0] == 4'b0101) 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0;
         {FLAG[15],FLAG[13],FLAG[9],FLAG[8],FLAG[7]} <= FLAG_TEMP;
			end
		end
		PUSH:
		begin
			if(IR2[3:0] == {4{1'b1}}) //POP
			begin
			register_in_select <= IR2[11:8];
			register_Din <= IN1_in;
			register_wr_LOAD <= 0;
			register_wr <= 1; 
			end
			else 
			begin
			register_in_select <= 0;
			register_Din <= 0;
			register_wr_LOAD <= 0;
			register_wr <= 0;
			end
		end
		IN :
		begin
			if(IR2[3:0] == 4'b0000)
			begin
				register_in_select <= IR2[7:4];
				register_wr_LOAD <= 0;
				register_wr <= 1;
				register_Din <= IN_DATA;
			end
			else if(IR2[3:0] == 4'b1111)
			begin
				register_in_select <= 0;
				register_Din <= IN0_in;
				register_wr_LOAD <= 1;
				register_wr <= 1;
				register_Out <= IN1_in;
			end 
		end
	endcase
end
always @(negedge clk)
begin
	case(IR2_i[15:12])  //PIPLINE STAGE2
		NULL:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
		end
      ALU:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
			IN1_in <= (register_in_select == {1'b0,IR2_i[8:6]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;
			IN0_in <= (register_in_select == {1'b0,IR2_i[5:3]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN0;
			ALU_MODE_in <= IR2_i[2:0];
		end
      LOG:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
			IN1_in <= (register_in_select == {1'b0,IR2_i[8:6]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;
			IN0_in <= (register_in_select == {1'b0,IR2_i[5:3]} && register_wr == 1 && register_wr_LOAD == 0) ? register_Din : IN0;
			LOG_MODE_in  <= IR2_i[2:0];
			LOG_CMODE_in <= IR2_i[11:9];
		end
      SHF:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
			IN1_in <= (register_in_select == IR2_i[11:8] && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;
			IN0_in <= (register_in_select == IR2_i[11:8] && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN0;
			SHF_MODE <= IR2_i[3:0];
			SHF_TIMES <= IR2_i[7:4];
		end
      SYS:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
		end
		LOAD:		
		begin
			if(IR2_i[3:0] == 4'b0000) // LOAD
			begin
			{RAM_opcode_address_rw_dontcare,RAM_opcode_address_rw} <= (register_in_select == {IR2_i[7:4]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			end
			else if(IR2_i[3:0] == 4'b1111)
			begin
			{RAM_opcode_address_rw_dontcare,RAM_opcode_address_rw}<= (register_in_select == {IR2_i[7:4]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN0;
			RAM_opcode_write_rw <= 1; 
			RAM_opcode_din_rw <= (register_in_select == {IR2_i[11:8]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;
			end
			IR2<= IR2_i;
		end
		SET:
		begin
			RAM_opcode_address_rw <= RAM_opcode_address_control -1; //原本PC指向下一行
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
		end
		MOVE:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
			IN1_in <= (register_in_select == {IR2_i[11:8]} && register_wr == 1 && register_wr_LOAD == 0 )? register_Din : IN1;
			IN0_in <= (register_in_select == {IR2_i[7:4]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN0;
		end
		PUSH:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
			if(IR2_i[3:0] == {4{1'b0}}) //PUSH
			begin
            PUSH_REGISTER[PUSH_COUNTER] <= (register_in_select == {IR2_i[11:8]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;//PUSH
				
				if(PUSH_COUNTER != 127)  //避免堆疊超過上限
				PUSH_COUNTER <= PUSH_COUNTER + 1'b1;
				else if(PUSH_COUNTER == 127)
				PUSH_COUNTER <= PUSH_COUNTER;			
			end
			else  //POP
			begin
				IN1_in <= PUSH_REGISTER[PUSH_COUNTER - 1'b1];  

				if(PUSH_COUNTER != 0)  //避免堆疊小於零
					PUSH_COUNTER <= PUSH_COUNTER - 1'b1;	
				else if(PUSH_COUNTER == 0)
					PUSH_COUNTER <= PUSH_COUNTER;				
			end
		end
		JZ: //JUMP_return_stage_1[1] == 1  FLAG確認  JUMP_return_stage_1[0] == 1 跳躍確認
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			if(JUMP_return_stage_1[1] == 0)
			begin
				IR2<= IR2_i;
				if((register_in_select == {1'b0,IR2_i[11:9]}) && (register_wr == 1) && register_wr_LOAD == 0)
				begin
					if(register_Din == 0)
					begin
						JUMP_return_stage_1 <= 2'b11;
					end
					else
					begin
						JUMP_return_stage_1 <= 2'b10; 
					end
				end
				else 
				begin
					if(IN1 == 0)
					begin
						JUMP_return_stage_1 <= 2'b11;
					end
					else
					begin
						JUMP_return_stage_1 <= 2'b10; 
					end
				end
			end
			else if(JUMP_return_stage_1[1] == 1)
			begin
				IR2<= IR2_i;
				JUMP_return_stage_1 <= 0;
			end
		end
		JNZ:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			if(JUMP_return_stage_1[1] == 0)
			begin
				IR2<= IR2_i;
				if((register_in_select == {1'b0,IR2_i[11:9]}) && (register_wr == 1) && register_wr_LOAD == 0)
				begin
					if(register_Din != 0)
					begin
						JUMP_return_stage_1 <= 2'b11;
					end
					else
					begin
						JUMP_return_stage_1 <= 2'b10; 
					end
				end
				else 
				begin
					if(IN1 != 0)
					begin
						JUMP_return_stage_1 <= 2'b11;
					end
					else
					begin
						JUMP_return_stage_1 <= 2'b10; 
					end
				end
			end
			else if(JUMP_return_stage_1[1] == 1)
			begin
				IR2<= IR2_i;
				JUMP_return_stage_1 <= 0;
			end
		end
		JP :
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			if(JUMP_return_stage_1[1] == 0)
			begin
				IR2<= IR2_i;
				case(IR2_i[11:9])
					3'b000://JMP
					begin
						JUMP_return_stage_1 <= 2'b11; 
					end
					3'b001://JCY
					begin
						JUMP_return_stage_1 <= (FLAG[15] == 1'b1)? 2'b11 :2'b10;
					end
					3'b010://JNCY
					begin
						JUMP_return_stage_1 <= (FLAG[15] == 1'b0)? 2'b11 :2'b10;
					end
					3'b011://JSF
					begin
						JUMP_return_stage_1 <= (FLAG[13] == 1'b1)? 2'b11 :2'b10;
					end
					3'b100://JNSF
					begin
						JUMP_return_stage_1 <= (FLAG[13] == 1'b0)? 2'b11 :2'b10;
					end
					3'b101://JEQ
					begin
						JUMP_return_stage_1 <= (FLAG[9] == 1'b1)? 2'b11 :2'b10;
					end
					3'b110://JNEQ
					begin
						JUMP_return_stage_1 <= (FLAG[9] == 1'b0)? 2'b11 :2'b10;
					end
					3'b111://JBT
					begin
						JUMP_return_stage_1 <= (FLAG[8] == 1'b1)? 2'b11 :2'b10;
					end
				endcase
			end
			else if(JUMP_return_stage_1[1] == 1)
			begin
				IR2<= IR2_i;
				JUMP_return_stage_1 <= 0;
			end
		end
		JMP:
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			if(JUMP_return_stage_1[1] == 0)
			begin
				IR2<= IR2_i;
				case(IR2_i[11:9])
					3'b000://JNBT
					begin
						JUMP_return_stage_1 <= (FLAG[8] == 1'b0)? 2'b11 :2'b10; 
					end
					3'b001://JST
					begin
						JUMP_return_stage_1 <= (FLAG[7] == 1'b1)? 2'b11 :2'b10; 
					end
					3'b010://JNST
					begin
						JUMP_return_stage_1 <= (FLAG[7] == 1'b0)? 2'b11 :2'b10; 
					end
					3'b011://JIT1
					begin
						JUMP_return_stage_1 <= (FLAG[4] == 1'b1)? 2'b11 :2'b10; 
					end
					3'b100://JNIT1
					begin
						JUMP_return_stage_1 <= (FLAG[4] == 1'b0)? 2'b11 :2'b10; 
					end
					3'b101://JIT0
					begin
						JUMP_return_stage_1 <= (FLAG[3] == 1'b1)? 2'b11 :2'b10; 
					end
					3'b110://JNIT0
					begin
						JUMP_return_stage_1 <= (FLAG[3] == 1'b0)? 2'b11 :2'b10; 
					end
					3'b111://JIEN
					begin
						JUMP_return_stage_1 <= (FLAG[5] == 1'b1)? 2'b11 :2'b10; 
					end
				endcase
			end
			else if(JUMP_return_stage_1[1] == 1)
			begin
				IR2<= IR2_i;
				JUMP_return_stage_1 <= 0;
			end
		end
		IN :
		begin
			if(IR2_i[3:0] == 4'b0000)
			begin
				RAM_opcode_address_rw <= 0;
				RAM_opcode_write_rw <= 0;
				RAM_opcode_din_rw <= 0;
				IR2<= IR2_i;
			end
			else if(IR2_i[3:0] == 4'b1111)
			begin
				RAM_opcode_address_rw <= 0;
				RAM_opcode_write_rw <= 0;
				RAM_opcode_din_rw <= 0;
				IR2<= IR2_i;
				IN0_in <= (register_in_select == {IR2_i[7:4]} && register_wr == 1 && register_wr_LOAD == 0 )? register_Din : IN0;
				IN1_in <= (register_in_select == {IR2_i[11:8]} && register_wr == 1 && register_wr_LOAD == 0)? register_Din : IN1;
			end 
		end
		CALL :
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
		end
		HALT :
		begin
			RAM_opcode_address_rw <= 0;
			RAM_opcode_write_rw <= 0;
			RAM_opcode_din_rw <= 0;
			IR2<= IR2_i;
		end
	endcase
end
endmodule
