module CPU(
CPU_clock,
IN_DATA,		//input [15:0]
OUT_DEVICE,	//output [15:0]
OUT_DATA,	//output [15:0]
ITR			//外部中斷		
);


////////////IN & OUT /////////////
input CPU_clock;
input [15:0] IN_DATA;
output [15:0] OUT_DATA;
output [15:0] OUT_DEVICE;
input ITR; //正源觸發時接收訊號，更改FLAG值，建議負源觸發並維持一個CLOCK

//////////////////////////////////
wire CPU_clock;
wire [15:0] IN_DATA;
reg [15:0] OUT_DATA =0;
reg [15:0] OUT_DEVICE = 0 ;
wire ITR; 

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

///////////RAM_opcode/////////////
wire RAM_opcode_write; // input [0 : 0] wea
wire [11 : 0] RAM_opcode_address; // input [11 : 0] addra
wire [15 : 0] RAM_opcode_din; // input [15 : 0] dina
wire [15 : 0] RAM_opcode_dout; // output [15 : 0] douta
wire RAM_opcode_write_rw; // input [0 : 0] web
wire [11 : 0] RAM_opcode_address_rw; // input [11 : 0] addrb
wire [15 : 0] RAM_opcode_din_rw; // input [15 : 0] dinb
wire [15 : 0] RAM_opcode_dout_rw; // output [15 : 0] doutb
///////////Stage 1//////////////////
wire [15 : 0] CPU_Stage_IR1_i;
wire [15 : 0] CPU_Stage_IR1_o;
wire [3 : 0] register1_select;
wire [3 : 0] register0_select;
wire [11 : 0] RAM_opcode_address_control;
wire [1:0] JUMP_return_stage_1;
reg interupt = 0;
wire [11 : 0] Timer0_Address;
wire [11 : 0] Timer1_Address;
wire [11 : 0] ITR_Address;
//////////////////////////////////
reg [15 : 0] IN0;
reg [15 : 0] IN1;
wire [15 : 0] FLAG_o;
wire register_wr_LOAD;
//////////////////////////////////
wire register_wr;
wire [3 : 0] register_in_select;
wire [15 : 0] register_Din;
wire [15 : 0] register_Out;
reg [15:0] register [15:0];
////////////////////////////////////


///////////Assign Ram to STAGE 1///////
assign
RAM_opcode_write = 0,
RAM_opcode_address = RAM_opcode_address_control,
CPU_Stage_IR1_i = RAM_opcode_dout;


///////////////////////////////////////




RAM_opcode RAM_for_opcode(
  .clka(CPU_clock), // input clka
  .wea(RAM_opcode_write), // input [0 : 0] wea
  .addra(RAM_opcode_address), // input [11 : 0] addra
  .dina(RAM_opcode_din), // input [15 : 0] dina
  .douta(RAM_opcode_dout), // output [15 : 0] douta
  .clkb(CPU_clock), // input clkb
  .web(RAM_opcode_write_rw), // input [0 : 0] web
  .addrb(RAM_opcode_address_rw), // input [11 : 0] addrb
  .dinb(RAM_opcode_din_rw), // input [15 : 0] dinb
  .doutb(RAM_opcode_dout_rw) // output [15 : 0] doutb
);

CPU_Stage_01 Stage_01(
CPU_clock,
CPU_Stage_IR1_i,
CPU_Stage_IR1_o,
register0_select,
register1_select,
RAM_opcode_address_control,
JUMP_return_stage_1,
interupt,
Timer0_Address,
Timer1_Address,
ITR_Address,
FLAG_o
);
////////////////register////////////////
always @(posedge CPU_clock)
begin
	interupt <= ITR || FLAG_o[3] || FLAG_o[4] ;
	IN0 <= register[register0_select];
	IN1 <= register[register1_select];
end


always @(negedge CPU_clock)	
begin
	if(register_wr_LOAD && register_wr)
	begin
	OUT_DEVICE <= register_Out;
	OUT_DATA <= register_Din;
	end
	else
	begin
	OUT_DEVICE <= 0;
	OUT_DATA <= 0;
	end
	if((register_wr_LOAD == 1) && (register_wr == 0))
		register[register_in_select] <= RAM_opcode_dout_rw;

	if((register_wr== 1) && (register_wr_LOAD == 0))
		register[register_in_select] <= register_Din;
end

/////////////////////////////////////////
CPU_Stage_02 Stage_02(
CPU_clock,
IN_DATA,
CPU_Stage_IR1_o,
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
ITR
);
 



endmodule
