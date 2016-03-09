module CPU_Stage_01(
clk,
opcode_in,
IR2,
IN0_select,//register1_select,
IN1_select,//register2_select,
RAM_opcode_address_control,
JUMP_return_stage_1,
interupt,
Timer0_Address,
Timer1_Address,
ITR_Address,
FLAG_o
);


///////////input output Declare////////////
input clk;
input [15:0] opcode_in;
output [15:0] IR2;
output [3:0] IN0_select;
output [3:0] IN1_select;
output [11:0] RAM_opcode_address_control;
input [1:0] JUMP_return_stage_1;
input interupt;
input [11:0] Timer0_Address;
input [11:0] Timer1_Address;
input [11:0] ITR_Address;
input [15:0] FLAG_o;

wire ITR_in;
wire interupt;
wire [1:0] JUMP_return_stage_1;
wire [15:0] opcode_in;

wire [15:0] FLAG_o;
wire [11:0] Timer0_Address;
wire [11:0] Timer1_Address;
wire [11:0] ITR_Address;

reg [3:0] IN0_select = 0;
reg [3:0] IN1_select = 0;
reg [11:0] RAM_opcode_address_control = 0;
reg [1:0] jump_flag = 0;

reg [11:0] CALL_REGISTER [127:0] ; //7-bit 128column
reg [6:0] CALL_COUNTER =0;
///////////////////////////////////////////
reg [11:0] PC = 0;
reg [15:0] IR1 = 0;
reg [15:0] IR2 = 0;
reg start = 1;
reg [1:0] jump_jugment = 2'b01;
reg ITR_Flag = 0;
reg [15:0] IR1_ITR = 0;
reg [11:0] PC_ITR = 0;
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
always @(negedge clk)
if(start == 1)
begin
	start <= 0;
end
//////////INTERRUPT//////////
else if(ITR_Flag == 1)
begin
		case(IR1_ITR[15:12])
			NULL:
			begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= IR1_ITR; //儲存當前OPC_ITRODE 供PIPLINE使用
				IR1_ITR <= opcode_in;//NEXT OPCODE
				PC_ITR <=PC_ITR+1;   //PC計數
				RAM_opcode_address_control <=  PC_ITR +1;  //指向下一行
			end
         ALU , LOG:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {1'b0,IR1_ITR[8:6]};
				IN0_select <= {1'b0,IR1_ITR[5:3]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC計數
				RAM_opcode_address_control <= PC_ITR +1;  //指向下行
			end
         SHF:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[11:8]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC計數
				RAM_opcode_address_control <= PC_ITR +1;  //指向下行
			end
         SYS:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC計數
				RAM_opcode_address_control <= PC_ITR +1;  //指向下行
			end
			LOAD:		//為了避免下一個指令沒讀到已存入數值，下個指令給予NULL值，等待值存入
			begin
				if(IR1_ITR[3:0] == 4'b0000)
				begin
				PC_ITR <= PC_ITR;   //PC計數
				RAM_opcode_address_control <= PC_ITR;  //指向下行
				IR2 <= IR1_ITR;   //將LOAD排入PIPELINE
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= {16{1'b0}};
				end
				else 
				begin
				PC_ITR <= PC_ITR + 1;   //PC計數
				RAM_opcode_address_control <= PC_ITR +1;  //指向下行
				IR2 <= IR1_ITR;   //將LOAD排入PIPELINE
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= opcode_in;
				end
			end
			SET: //為了避免下一個指令沒讀到已存入數值，下個指令給予NULL值，等待值存入，相似於LOAD指令，未來若要擴增指令可合併
			begin
				IR2 <= IR1_ITR;   //排入PIPELINE
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= PC_ITR+1;   //PC計數 指向下兩行
				RAM_opcode_address_control <= PC_ITR +1;  //指向下兩行
			end
			MOVE,PUSH,IN : //相似
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC計數
				RAM_opcode_address_control <= PC_ITR +1;  //指向下行
			end
			JZ,JNZ,JP,JMP: 
			begin
				case(jump_flag)
					2'b00:  
					begin
						IR2 <= IR1_ITR;  // 傳入PIPELINE
						IN1_select <= {1'b0,IR1_ITR[11:9]};
						IN0_select <= {4{1'b0}};
						IR1_ITR <= IR1_ITR; //不讀取下一行指令
						jump_flag <= 2'b01;
						PC_ITR <= PC_ITR;   //PC NO計數
						RAM_opcode_address_control <= PC_ITR;  //指向下行
					end
					2'b01:  //等待回復
					begin
						jump_flag <= 2'b10;
						IR2 <= IR1_ITR;  // 傳入PIPELINE
						IN1_select <= {1'b0,IR1_ITR[11:9]};
						IN0_select <= {4{1'b0}};
						IR1_ITR <= IR1_ITR; //不讀取下一行指令
						if(jump_jugment[1] == 0) // 不先跳躍
						begin
							PC_ITR <= PC_ITR;   //PC NO計數
							RAM_opcode_address_control <= PC_ITR ;  //指向下行
						end
						else if(jump_jugment[1] == 1) //先跳躍
						begin
							PC_ITR <= PC_ITR;   //PC NO計數
							RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //指向下行
						end
					end
					2'b10:  //取得跳躍回復 並等待跳躍完成
					begin
						if(JUMP_return_stage_1 == 2'b11)  //JUMP
						begin
						jump_flag <= 2'b00; // jump_flag 清零	
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
						IR2 <= {16{1'b0}};  // NULL傳入PIPELINE
							if(jump_jugment == 2'b00) //猜測跳躍失誤
							begin
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //指向下行
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} -1) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} - 1) ;   //PC NO計數
								IR1_ITR <= {16{1'b0}}; //下一行NULL指令
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b01) //猜測跳躍失誤
							begin
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //指向下行
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} -1) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} - 1) ;   //PC NO計數
								IR1_ITR <= {16{1'b0}}; //下一行NULL指令
								jump_jugment <= 2'b10;
							end
							if(jump_jugment == 2'b10) //猜測跳躍正確
							begin
								IR1_ITR <= opcode_in ; //讀取下一行指令
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} ) ;  //指向讀取的下一行
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}) ;   //PC NO計數
								jump_jugment <= 2'b11;
							end
							if(jump_jugment == 2'b11) //猜測跳躍正確
							begin
								IR1_ITR <= opcode_in ; //讀取下一行指令
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} ) ;  //指向讀取的下一行
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}) ;   //PC NO計數
								jump_jugment <= 2'b11;
							end
						end
						else if(JUMP_return_stage_1 == 2'b10) //不跳躍
						begin
						jump_flag <= 2'b00;
						IR2 <= {16{1'b0}};  // NULL傳入PIPELINE 等待下一行指令
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
							if(jump_jugment == 2'b00) //猜測跳躍正確
							begin
								PC_ITR <= PC_ITR +1;   //PC NO計數
								RAM_opcode_address_control <= PC_ITR +1;  //指向下行
								IR1_ITR <= opcode_in ; //讀取下一行指令
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b01) //猜測跳躍正確
							begin
								PC_ITR <= PC_ITR +1;   //PC NO計數
								RAM_opcode_address_control <= PC_ITR +1;  //指向下行
								IR1_ITR <= opcode_in ; //讀取下一行指令
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b10) //猜測跳躍失誤
							begin
								IR1_ITR <= {16{1'b0}}; //下一行NULL指令
								RAM_opcode_address_control <= PC_ITR;  //指向讀取的下一行
								PC_ITR <= PC_ITR;   //PC NO計數
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b11)  //猜測跳躍失誤
							begin
								IR1_ITR <= {16{1'b0}}; //下一行NULL指令
								RAM_opcode_address_control <= PC_ITR;  //指向讀取的下一行
								PC_ITR <= PC_ITR;   //PC NO計數
								jump_jugment <= 2'b10;
							end
						end
					end
					default: begin jump_flag <= 2'b00; end
				endcase
			end
			CALL:
			begin
				if(IR1_ITR[11:0] == {12{1'b1}}) //RET
				begin
				IR2 <= IR1_ITR;  // 傳入PIPELINE 等待下一行指令
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= CALL_REGISTER[CALL_COUNTER - 1'b1];   //PC計數
				RAM_opcode_address_control <= CALL_REGISTER[CALL_COUNTER - 1'b1] ;  //指向絕對位置
				if(CALL_COUNTER != 0)  //避免堆疊小於零
					CALL_COUNTER <= CALL_COUNTER - 1'b1;	
				else if(CALL_COUNTER == 0)
					CALL_COUNTER <= CALL_COUNTER;	
				end
				else  //CALL
				begin
				IR2 <= IR1_ITR;  // NULL傳入PIPELINE 等待下一行指令
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= IR1_ITR[11:0];   //PC計數
				RAM_opcode_address_control <= IR1_ITR[11:0];  //指向絕對位置
            CALL_REGISTER[CALL_COUNTER] <= PC_ITR;//PUSH
				if(CALL_COUNTER != 127)  //避免堆疊超過上限
				CALL_COUNTER <= CALL_COUNTER + 1'b1;
				else if(CALL_COUNTER == 127)
				CALL_COUNTER <= CALL_COUNTER;
				end
			end
			HALT:
			begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= {16{1'b0}};
				IR1_ITR <= 0;	//NULL
				PC_ITR <= 0;   //PC_ITR歸零
				RAM_opcode_address_control <= PC  ;  //停止中斷跳回程式
				ITR_Flag <= 0;
			end
		endcase

end
//////////INTERRUPT//////////

else 
begin
		case(IR1[15:12])
			NULL:
			begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= IR1; //儲存當前OPCODE 供PIPLINE使用
				IR1 <= opcode_in;//NEXT OPCODE
				PC <=PC+1;   //PC計數
				if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[6]/*ITR*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= ITR_Address;
					PC_ITR <= ITR_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[3]/*IT0*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer0_Address;
					PC_ITR <= Timer0_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[4]/*IT1*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer1_Address; 
					PC_ITR <= Timer1_Address;
				end
				else
				begin
					RAM_opcode_address_control <=  PC +1;  //指向下一行
				end
			end
         ALU , LOG:
			begin
				IR2 <= IR1; 
				IN1_select <= {1'b0,IR1[8:6]};
				IN0_select <= {1'b0,IR1[5:3]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC計數
				if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[6]/*ITR*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= ITR_Address;
					PC_ITR <= ITR_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[3]/*IT0*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer0_Address; 
					PC_ITR <= Timer0_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[4]/*IT1*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer1_Address; 
					PC_ITR <= Timer1_Address;
				end
				else
				begin
					RAM_opcode_address_control <=  PC +1;  //指向下一行
				end
			end
         SHF:
			begin
				IR2 <= IR1; 
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[11:8]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC計數
				if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[6]/*ITR*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= ITR_Address;
					PC_ITR <= ITR_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[3]/*IT0*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer0_Address;
					PC_ITR <= Timer0_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[4]/*IT1*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer1_Address; 
					PC_ITR <= Timer1_Address;
				end
				else
				begin
					RAM_opcode_address_control <=  PC +1;  //指向下一行
				end
			end
         SYS:
			begin
				IR2 <= IR1; 
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC計數
				if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[6]/*ITR*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= ITR_Address;
					PC_ITR <= ITR_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[3]/*IT0*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer0_Address; 
					PC_ITR <= Timer0_Address;
				end
				else if(FLAG_o[5]/*IEN*/ == 1 && FLAG_o[4]/*IT1*/ == 1)
				begin
					ITR_Flag <= 1;
					RAM_opcode_address_control <= Timer1_Address; 
					PC_ITR <= Timer1_Address;
				end
				else
				begin
					RAM_opcode_address_control <=  PC +1;  //指向下一行
				end
			end
			LOAD:		//為了避免下一個指令沒讀到已存入數值，下個指令給予NULL值，等待值存入
			begin
				if(IR1[3:0] == 4'b0000)
				begin
				PC <= PC;   //PC計數
				RAM_opcode_address_control <= PC;  //指向下行
				IR2 <= IR1;   //將LOAD排入PIPELINE
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= {16{1'b0}};
				end
				else 
				begin
				PC <= PC + 1;   //PC計數
				RAM_opcode_address_control <= PC +1;  //指向下行
				IR2 <= IR1;   //將LOAD排入PIPELINE
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= opcode_in;
				end
			end
			SET: //為了避免下一個指令沒讀到已存入數值，下個指令給予NULL值，等待值存入，相似於LOAD指令，未來若要擴增指令可合併
			begin
				IR2 <= IR1;   //排入PIPELINE
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= PC+1;   //PC計數 指向下兩行
				RAM_opcode_address_control <= PC +1;  //指向下兩行
			end
			MOVE,PUSH,IN : //相似
			begin
				IR2 <= IR1; 
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC計數
				RAM_opcode_address_control <= PC +1;  //指向下行
			end
			JZ,JNZ,JP,JMP: 
			begin
				case(jump_flag)
					2'b00:  
					begin
						IR2 <= IR1;  // 傳入PIPELINE
						IN1_select <= {1'b0,IR1[11:9]};
						IN0_select <= {4{1'b0}};
						IR1 <= IR1; //不讀取下一行指令
						jump_flag <= 2'b01;
						PC <= PC;   //PC NO計數
						RAM_opcode_address_control <= PC;  //指向下行
					end
					2'b01:  //等待回復
					begin
						jump_flag <= 2'b10;
						IR2 <= IR1;  // 傳入PIPELINE
						IN1_select <= {1'b0,IR1[11:9]};
						IN0_select <= {4{1'b0}};
						IR1 <= IR1; //不讀取下一行指令
						if(jump_jugment[1] == 0) // 不先跳躍
						begin
							PC <= PC;   //PC NO計數
							RAM_opcode_address_control <= PC ;  //指向下行
						end
						else if(jump_jugment[1] == 1) //先跳躍
						begin
							PC <= PC;   //PC NO計數
							RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //指向下行
						end
					end
					2'b10:  //取得跳躍回復 並等待跳躍完成
					begin
						if(JUMP_return_stage_1 == 2'b11)  //JUMP
						begin
						jump_flag <= 2'b00; // jump_flag 清零	
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
						IR2 <= {16{1'b0}};  // NULL傳入PIPELINE
							if(jump_jugment == 2'b00) //猜測跳躍失誤
							begin
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //指向下行
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} -1) : (PC + {4'b0000,IR1[7:0]} - 1) ;   //PC NO計數
								IR1 <= {16{1'b0}}; //下一行NULL指令
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b01) //猜測跳躍失誤
							begin
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //指向下行
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} -1) : (PC + {4'b0000,IR1[7:0]} - 1) ;   //PC NO計數
								IR1 <= {16{1'b0}}; //下一行NULL指令
								jump_jugment <= 2'b10;
							end
							if(jump_jugment == 2'b10) //猜測跳躍正確
							begin
								IR1 <= opcode_in ; //讀取下一行指令
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} ) : (PC + {4'b0000,IR1[7:0]} ) ;  //指向讀取的下一行
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}) : (PC + {4'b0000,IR1[7:0]}) ;   //PC NO計數
								jump_jugment <= 2'b11;
							end
							if(jump_jugment == 2'b11) //猜測跳躍正確
							begin
								IR1 <= opcode_in ; //讀取下一行指令
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} ) : (PC + {4'b0000,IR1[7:0]} ) ;  //指向讀取的下一行
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}) : (PC + {4'b0000,IR1[7:0]}) ;   //PC NO計數
								jump_jugment <= 2'b11;
							end
						end
						else if(JUMP_return_stage_1 == 2'b10) //不跳躍
						begin
						jump_flag <= 2'b00;
						IR2 <= {16{1'b0}};  // NULL傳入PIPELINE 等待下一行指令
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
							if(jump_jugment == 2'b00) //猜測跳躍正確
							begin
								PC <= PC +1;   //PC NO計數
								RAM_opcode_address_control <= PC +1;  //指向下行
								IR1 <= opcode_in ; //讀取下一行指令
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b01) //猜測跳躍正確
							begin
								PC <= PC +1;   //PC NO計數
								RAM_opcode_address_control <= PC +1;  //指向下行
								IR1 <= opcode_in ; //讀取下一行指令
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b10) //猜測跳躍失誤
							begin
								IR1 <= {16{1'b0}}; //下一行NULL指令
								RAM_opcode_address_control <= PC;  //指向讀取的下一行
								PC <= PC;   //PC NO計數
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b11)  //猜測跳躍失誤
							begin
								IR1 <= {16{1'b0}}; //下一行NULL指令
								RAM_opcode_address_control <= PC;  //指向讀取的下一行
								PC <= PC;   //PC NO計數
								jump_jugment <= 2'b10;
							end
						end
					end
					default: begin jump_flag <= 2'b00; end
				endcase
			end
			CALL:
			begin
				if(IR1[11:0] == {12{1'b1}}) //RET
				begin
				IR2 <= IR1;  // 傳入PIPELINE 等待下一行指令
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= CALL_REGISTER[CALL_COUNTER - 1'b1];   //PC計數
				RAM_opcode_address_control <= CALL_REGISTER[CALL_COUNTER - 1'b1] ;  //指向絕對位置
				if(CALL_COUNTER != 0)  //避免堆疊小於零
					CALL_COUNTER <= CALL_COUNTER - 1'b1;	
				else if(CALL_COUNTER == 0)
					CALL_COUNTER <= CALL_COUNTER;	
				end
				else  //CALL
				begin
				IR2 <= IR1;  // NULL傳入PIPELINE 等待下一行指令
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= IR1[11:0];   //PC計數
				RAM_opcode_address_control <= IR1[11:0];  //指向絕對位置
            CALL_REGISTER[CALL_COUNTER] <= PC;//PUSH
				if(CALL_COUNTER != 127)  //避免堆疊超過上限
				CALL_COUNTER <= CALL_COUNTER + 1'b1;
				else if(CALL_COUNTER == 127)
				CALL_COUNTER <= CALL_COUNTER;
				end
			end
			HALT:
			begin
				if(interupt == 0)  //休眠  停止執行任何指令
				begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= {16{1'b0}};
				IR1 <= IR1;
				PC <= PC;   //PC計數停止
				RAM_opcode_address_control <= PC  ;  //停留此行
				end
				else if(interupt == 1)  //由中斷喚醒
				begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= {16{1'b0}}; 
				IR1 <= opcode_in;
				PC <= PC+1;   //PC計數
				RAM_opcode_address_control <= PC +1 ;  //指向下一行
				end
			end
		endcase
end


endmodule
