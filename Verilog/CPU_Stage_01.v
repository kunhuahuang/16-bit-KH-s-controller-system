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
///////////���O����////////////////
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
				IR2 <= IR1_ITR; //�x�s��eOPC_ITRODE ��PIPLINE�ϥ�
				IR1_ITR <= opcode_in;//NEXT OPCODE
				PC_ITR <=PC_ITR+1;   //PC�p��
				RAM_opcode_address_control <=  PC_ITR +1;  //���V�U�@��
			end
         ALU , LOG:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {1'b0,IR1_ITR[8:6]};
				IN0_select <= {1'b0,IR1_ITR[5:3]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC�p��
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
			end
         SHF:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[11:8]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC�p��
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
			end
         SYS:
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC�p��
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
			end
			LOAD:		//���F�קK�U�@�ӫ��O�SŪ��w�s�J�ƭȡA�U�ӫ��O����NULL�ȡA���ݭȦs�J
			begin
				if(IR1_ITR[3:0] == 4'b0000)
				begin
				PC_ITR <= PC_ITR;   //PC�p��
				RAM_opcode_address_control <= PC_ITR;  //���V�U��
				IR2 <= IR1_ITR;   //�NLOAD�ƤJPIPELINE
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= {16{1'b0}};
				end
				else 
				begin
				PC_ITR <= PC_ITR + 1;   //PC�p��
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
				IR2 <= IR1_ITR;   //�NLOAD�ƤJPIPELINE
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= opcode_in;
				end
			end
			SET: //���F�קK�U�@�ӫ��O�SŪ��w�s�J�ƭȡA�U�ӫ��O����NULL�ȡA���ݭȦs�J�A�ۦ���LOAD���O�A���ӭY�n�X�W���O�i�X��
			begin
				IR2 <= IR1_ITR;   //�ƤJPIPELINE
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= PC_ITR+1;   //PC�p�� ���V�U���
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U���
			end
			MOVE,PUSH,IN : //�ۦ�
			begin
				IR2 <= IR1_ITR; 
				IN1_select <= {IR1_ITR[11:8]};
				IN0_select <= {IR1_ITR[7:4]};
				IR1_ITR <= opcode_in;
				PC_ITR <= PC_ITR+1;   //PC�p��
				RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
			end
			JZ,JNZ,JP,JMP: 
			begin
				case(jump_flag)
					2'b00:  
					begin
						IR2 <= IR1_ITR;  // �ǤJPIPELINE
						IN1_select <= {1'b0,IR1_ITR[11:9]};
						IN0_select <= {4{1'b0}};
						IR1_ITR <= IR1_ITR; //��Ū���U�@����O
						jump_flag <= 2'b01;
						PC_ITR <= PC_ITR;   //PC NO�p��
						RAM_opcode_address_control <= PC_ITR;  //���V�U��
					end
					2'b01:  //���ݦ^�_
					begin
						jump_flag <= 2'b10;
						IR2 <= IR1_ITR;  // �ǤJPIPELINE
						IN1_select <= {1'b0,IR1_ITR[11:9]};
						IN0_select <= {4{1'b0}};
						IR1_ITR <= IR1_ITR; //��Ū���U�@����O
						if(jump_jugment[1] == 0) // �������D
						begin
							PC_ITR <= PC_ITR;   //PC NO�p��
							RAM_opcode_address_control <= PC_ITR ;  //���V�U��
						end
						else if(jump_jugment[1] == 1) //�����D
						begin
							PC_ITR <= PC_ITR;   //PC NO�p��
							RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //���V�U��
						end
					end
					2'b10:  //���o���D�^�_ �õ��ݸ��D����
					begin
						if(JUMP_return_stage_1 == 2'b11)  //JUMP
						begin
						jump_flag <= 2'b00; // jump_flag �M�s	
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
						IR2 <= {16{1'b0}};  // NULL�ǤJPIPELINE
							if(jump_jugment == 2'b00) //�q�����D���~
							begin
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //���V�U��
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} -1) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} - 1) ;   //PC NO�p��
								IR1_ITR <= {16{1'b0}}; //�U�@��NULL���O
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b01) //�q�����D���~
							begin
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}- 1'b1 ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}- 1'b1 ) ;  //���V�U��
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} -1) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} - 1) ;   //PC NO�p��
								IR1_ITR <= {16{1'b0}}; //�U�@��NULL���O
								jump_jugment <= 2'b10;
							end
							if(jump_jugment == 2'b10) //�q�����D���T
							begin
								IR1_ITR <= opcode_in ; //Ū���U�@����O
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} ) ;  //���VŪ�����U�@��
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}) ;   //PC NO�p��
								jump_jugment <= 2'b11;
							end
							if(jump_jugment == 2'b11) //�q�����D���T
							begin
								IR1_ITR <= opcode_in ; //Ū���U�@����O
								RAM_opcode_address_control <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]} ) : (PC_ITR + {4'b0000,IR1_ITR[7:0]} ) ;  //���VŪ�����U�@��
								PC_ITR <= (IR1_ITR[8])?(PC_ITR - {4'b0000,IR1_ITR[7:0]}) : (PC_ITR + {4'b0000,IR1_ITR[7:0]}) ;   //PC NO�p��
								jump_jugment <= 2'b11;
							end
						end
						else if(JUMP_return_stage_1 == 2'b10) //�����D
						begin
						jump_flag <= 2'b00;
						IR2 <= {16{1'b0}};  // NULL�ǤJPIPELINE ���ݤU�@����O
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
							if(jump_jugment == 2'b00) //�q�����D���T
							begin
								PC_ITR <= PC_ITR +1;   //PC NO�p��
								RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
								IR1_ITR <= opcode_in ; //Ū���U�@����O
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b01) //�q�����D���T
							begin
								PC_ITR <= PC_ITR +1;   //PC NO�p��
								RAM_opcode_address_control <= PC_ITR +1;  //���V�U��
								IR1_ITR <= opcode_in ; //Ū���U�@����O
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b10) //�q�����D���~
							begin
								IR1_ITR <= {16{1'b0}}; //�U�@��NULL���O
								RAM_opcode_address_control <= PC_ITR;  //���VŪ�����U�@��
								PC_ITR <= PC_ITR;   //PC NO�p��
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b11)  //�q�����D���~
							begin
								IR1_ITR <= {16{1'b0}}; //�U�@��NULL���O
								RAM_opcode_address_control <= PC_ITR;  //���VŪ�����U�@��
								PC_ITR <= PC_ITR;   //PC NO�p��
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
				IR2 <= IR1_ITR;  // �ǤJPIPELINE ���ݤU�@����O
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= CALL_REGISTER[CALL_COUNTER - 1'b1];   //PC�p��
				RAM_opcode_address_control <= CALL_REGISTER[CALL_COUNTER - 1'b1] ;  //���V�����m
				if(CALL_COUNTER != 0)  //�קK���|�p��s
					CALL_COUNTER <= CALL_COUNTER - 1'b1;	
				else if(CALL_COUNTER == 0)
					CALL_COUNTER <= CALL_COUNTER;	
				end
				else  //CALL
				begin
				IR2 <= IR1_ITR;  // NULL�ǤJPIPELINE ���ݤU�@����O
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1_ITR <= {16{1'b0}};
				PC_ITR <= IR1_ITR[11:0];   //PC�p��
				RAM_opcode_address_control <= IR1_ITR[11:0];  //���V�����m
            CALL_REGISTER[CALL_COUNTER] <= PC_ITR;//PUSH
				if(CALL_COUNTER != 127)  //�קK���|�W�L�W��
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
				PC_ITR <= 0;   //PC_ITR�k�s
				RAM_opcode_address_control <= PC  ;  //����_���^�{��
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
				IR2 <= IR1; //�x�s��eOPCODE ��PIPLINE�ϥ�
				IR1 <= opcode_in;//NEXT OPCODE
				PC <=PC+1;   //PC�p��
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
					RAM_opcode_address_control <=  PC +1;  //���V�U�@��
				end
			end
         ALU , LOG:
			begin
				IR2 <= IR1; 
				IN1_select <= {1'b0,IR1[8:6]};
				IN0_select <= {1'b0,IR1[5:3]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC�p��
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
					RAM_opcode_address_control <=  PC +1;  //���V�U�@��
				end
			end
         SHF:
			begin
				IR2 <= IR1; 
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[11:8]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC�p��
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
					RAM_opcode_address_control <=  PC +1;  //���V�U�@��
				end
			end
         SYS:
			begin
				IR2 <= IR1; 
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC�p��
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
					RAM_opcode_address_control <=  PC +1;  //���V�U�@��
				end
			end
			LOAD:		//���F�קK�U�@�ӫ��O�SŪ��w�s�J�ƭȡA�U�ӫ��O����NULL�ȡA���ݭȦs�J
			begin
				if(IR1[3:0] == 4'b0000)
				begin
				PC <= PC;   //PC�p��
				RAM_opcode_address_control <= PC;  //���V�U��
				IR2 <= IR1;   //�NLOAD�ƤJPIPELINE
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= {16{1'b0}};
				end
				else 
				begin
				PC <= PC + 1;   //PC�p��
				RAM_opcode_address_control <= PC +1;  //���V�U��
				IR2 <= IR1;   //�NLOAD�ƤJPIPELINE
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= opcode_in;
				end
			end
			SET: //���F�קK�U�@�ӫ��O�SŪ��w�s�J�ƭȡA�U�ӫ��O����NULL�ȡA���ݭȦs�J�A�ۦ���LOAD���O�A���ӭY�n�X�W���O�i�X��
			begin
				IR2 <= IR1;   //�ƤJPIPELINE
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= PC+1;   //PC�p�� ���V�U���
				RAM_opcode_address_control <= PC +1;  //���V�U���
			end
			MOVE,PUSH,IN : //�ۦ�
			begin
				IR2 <= IR1; 
				IN1_select <= {IR1[11:8]};
				IN0_select <= {IR1[7:4]};
				IR1 <= opcode_in;
				PC <= PC+1;   //PC�p��
				RAM_opcode_address_control <= PC +1;  //���V�U��
			end
			JZ,JNZ,JP,JMP: 
			begin
				case(jump_flag)
					2'b00:  
					begin
						IR2 <= IR1;  // �ǤJPIPELINE
						IN1_select <= {1'b0,IR1[11:9]};
						IN0_select <= {4{1'b0}};
						IR1 <= IR1; //��Ū���U�@����O
						jump_flag <= 2'b01;
						PC <= PC;   //PC NO�p��
						RAM_opcode_address_control <= PC;  //���V�U��
					end
					2'b01:  //���ݦ^�_
					begin
						jump_flag <= 2'b10;
						IR2 <= IR1;  // �ǤJPIPELINE
						IN1_select <= {1'b0,IR1[11:9]};
						IN0_select <= {4{1'b0}};
						IR1 <= IR1; //��Ū���U�@����O
						if(jump_jugment[1] == 0) // �������D
						begin
							PC <= PC;   //PC NO�p��
							RAM_opcode_address_control <= PC ;  //���V�U��
						end
						else if(jump_jugment[1] == 1) //�����D
						begin
							PC <= PC;   //PC NO�p��
							RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //���V�U��
						end
					end
					2'b10:  //���o���D�^�_ �õ��ݸ��D����
					begin
						if(JUMP_return_stage_1 == 2'b11)  //JUMP
						begin
						jump_flag <= 2'b00; // jump_flag �M�s	
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
						IR2 <= {16{1'b0}};  // NULL�ǤJPIPELINE
							if(jump_jugment == 2'b00) //�q�����D���~
							begin
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //���V�U��
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} -1) : (PC + {4'b0000,IR1[7:0]} - 1) ;   //PC NO�p��
								IR1 <= {16{1'b0}}; //�U�@��NULL���O
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b01) //�q�����D���~
							begin
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}- 1'b1 ) : (PC + {4'b0000,IR1[7:0]}- 1'b1 ) ;  //���V�U��
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} -1) : (PC + {4'b0000,IR1[7:0]} - 1) ;   //PC NO�p��
								IR1 <= {16{1'b0}}; //�U�@��NULL���O
								jump_jugment <= 2'b10;
							end
							if(jump_jugment == 2'b10) //�q�����D���T
							begin
								IR1 <= opcode_in ; //Ū���U�@����O
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} ) : (PC + {4'b0000,IR1[7:0]} ) ;  //���VŪ�����U�@��
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}) : (PC + {4'b0000,IR1[7:0]}) ;   //PC NO�p��
								jump_jugment <= 2'b11;
							end
							if(jump_jugment == 2'b11) //�q�����D���T
							begin
								IR1 <= opcode_in ; //Ū���U�@����O
								RAM_opcode_address_control <= (IR1[8])?(PC - {4'b0000,IR1[7:0]} ) : (PC + {4'b0000,IR1[7:0]} ) ;  //���VŪ�����U�@��
								PC <= (IR1[8])?(PC - {4'b0000,IR1[7:0]}) : (PC + {4'b0000,IR1[7:0]}) ;   //PC NO�p��
								jump_jugment <= 2'b11;
							end
						end
						else if(JUMP_return_stage_1 == 2'b10) //�����D
						begin
						jump_flag <= 2'b00;
						IR2 <= {16{1'b0}};  // NULL�ǤJPIPELINE ���ݤU�@����O
						IN1_select <= {4{1'b0}};
						IN0_select <= {4{1'b0}};
							if(jump_jugment == 2'b00) //�q�����D���T
							begin
								PC <= PC +1;   //PC NO�p��
								RAM_opcode_address_control <= PC +1;  //���V�U��
								IR1 <= opcode_in ; //Ū���U�@����O
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b01) //�q�����D���T
							begin
								PC <= PC +1;   //PC NO�p��
								RAM_opcode_address_control <= PC +1;  //���V�U��
								IR1 <= opcode_in ; //Ū���U�@����O
								jump_jugment <= 2'b00;
							end
							if(jump_jugment == 2'b10) //�q�����D���~
							begin
								IR1 <= {16{1'b0}}; //�U�@��NULL���O
								RAM_opcode_address_control <= PC;  //���VŪ�����U�@��
								PC <= PC;   //PC NO�p��
								jump_jugment <= 2'b01;
							end
							if(jump_jugment == 2'b11)  //�q�����D���~
							begin
								IR1 <= {16{1'b0}}; //�U�@��NULL���O
								RAM_opcode_address_control <= PC;  //���VŪ�����U�@��
								PC <= PC;   //PC NO�p��
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
				IR2 <= IR1;  // �ǤJPIPELINE ���ݤU�@����O
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= CALL_REGISTER[CALL_COUNTER - 1'b1];   //PC�p��
				RAM_opcode_address_control <= CALL_REGISTER[CALL_COUNTER - 1'b1] ;  //���V�����m
				if(CALL_COUNTER != 0)  //�קK���|�p��s
					CALL_COUNTER <= CALL_COUNTER - 1'b1;	
				else if(CALL_COUNTER == 0)
					CALL_COUNTER <= CALL_COUNTER;	
				end
				else  //CALL
				begin
				IR2 <= IR1;  // NULL�ǤJPIPELINE ���ݤU�@����O
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR1 <= {16{1'b0}};
				PC <= IR1[11:0];   //PC�p��
				RAM_opcode_address_control <= IR1[11:0];  //���V�����m
            CALL_REGISTER[CALL_COUNTER] <= PC;//PUSH
				if(CALL_COUNTER != 127)  //�קK���|�W�L�W��
				CALL_COUNTER <= CALL_COUNTER + 1'b1;
				else if(CALL_COUNTER == 127)
				CALL_COUNTER <= CALL_COUNTER;
				end
			end
			HALT:
			begin
				if(interupt == 0)  //��v  ������������O
				begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= {16{1'b0}};
				IR1 <= IR1;
				PC <= PC;   //PC�p�ư���
				RAM_opcode_address_control <= PC  ;  //���d����
				end
				else if(interupt == 1)  //�Ѥ��_���
				begin
				IN1_select <= {4{1'b0}};
				IN0_select <= {4{1'b0}};
				IR2 <= {16{1'b0}}; 
				IR1 <= opcode_in;
				PC <= PC+1;   //PC�p��
				RAM_opcode_address_control <= PC +1 ;  //���V�U�@��
				end
			end
		endcase
end


endmodule
