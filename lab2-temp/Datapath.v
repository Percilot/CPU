`timescale 1ns / 1ps

module Datapath(
input clk,
input rst,
input [4:0] debug_reg_addr,
input D_cache_stall,
input I_cache_stall,
input [31:0] inst_in,
input [31:0] data_in,
output [31:0] addr_out,
output [31:0] data_out,
output [31:0] pc_out,
output [31:0] reg_out,
output mem_write,
output output_mem_access_out,
output pc_access_mem_valid
    );
    
wire [31:0] Regs_RegisterRs1_Data, Regs_RegisterRs2_Data;
wire [31:0] ID_EX_RegisterRs1_Data, ID_EX_RegisterRs2_Data; 

wire [31:0] Inst_Imm;
wire [31:0] ID_EX_Imm;
wire [31:0] EX_MEM_Imm;
wire [31:0] MEM_WB_Imm;

wire [31:0] PC_PC;
wire [31:0] IF_ID_PC;
wire [31:0] ID_EX_PC;

wire [31:0] IF_ID_Inst;

wire [1:0] Control_PCsrc;
wire [1:0] ID_EX_PCsrc;
wire [1:0] EX_MEM_PCsrc;

wire Control_RegWrite;
wire ID_EX_RegWrite;
wire EX_MEM_RegWrite;
wire MEM_WB_RegWrite;

wire Control_Alusrc_A, Control_Alusrc_B;
wire ID_EX_Alusrc_A, ID_EX_Alusrc_B;

wire Control_MemWrite;
wire ID_EX_MemWrite;

wire [3:0] Control_ALUop;
wire [3:0] ID_EX_ALUop;

wire [1:0] Control_MemToReg;
wire [1:0] ID_EX_MemToReg;
wire [1:0] EX_MEM_MemToReg;
wire [1:0] MEM_WB_MemToReg;

wire [31:0] ALU_ALUresult;
wire [31:0] EX_MEM_ALUresult;
wire [31:0] MEM_WB_ALUresult;

wire Control_Branch;
wire [2:0] Control_B_type;
wire ID_EX_Branch;
wire [2:0] ID_EX_B_type;
wire EX_MEM_Branch;
wire [2:0] EX_MEM_B_type;

wire [4:0] ID_EX_RegisterRd_Index;
wire [4:0] EX_MEM_RegisterRd_Index;
wire [4:0] MEM_WB_RegisterRd_Index;

wire [31:0] Mux_RegisterRd_Data;

wire ALU_ZeroFlag;
wire ALU_BiggerFlag;
wire ALU_SmallerFlag;

wire EX_MEM_ZeroFlag;

wire [31:0] MEM_WB_DataIn;

wire [31:0] ADDER_PCadd4;
wire [31:0] EX_MEM_PCadd4;
wire [31:0] MEM_WB_PCadd4;

wire [31:0] ADDER_PCaddImm;
wire [31:0] EX_MEM_PCaddImm;

wire [4:0] Control_RegisterRs1_Index, Control_RegisterRs2_Index, Control_RegisterRd_Index;
wire [4:0] ID_EX_RegisterRs1_Index, ID_EX_RegisterRs2_Index;
wire [31:0] ALUsrca, ALUsrcb;
wire [31:0] new_PC;
wire write_PC;

wire [31:0] Another_ADDER_PCadd4, WB_PC, ForwardingRs2;
wire [31:0] ForwardingA, ForwardingB, ForwardingC;
wire ForwardingSignA, ForwardingSignB, ForwardingSignC;
wire [4:0] ForwardingIndex;
wire OuterDetect;
wire PC_lock;
wire IF_ID_lock;
wire Bubble;

wire ControlChange;
wire Control_CSRSource;
wire ID_EX_CSRSource;
wire [31:0] ID_EX_Read_CSR_Data;
wire [31:0] CSR_Read_CSR_Data;
wire [31:0] WriteCSR_Write_CSR_Data;
wire Control_WriteCSR;
wire [11:0] Control_ReadCSR_Addr;
wire [11:0] Control_WriteCSR_Addr;
wire [11:0] ID_EX_WriteCSR_Addr;
wire [1:0] Control_CSR_WriteSource;
wire [1:0] ID_EX_CSR_WriteSource;
wire [1:0] Control_CSR_HowToWriteCSR;
wire [1:0] ID_EX_CSR_HowToWriteCSR;
wire Control_mem_access_valid;
wire ID_EX_mem_access_valid;
wire IF_ID_inst_valid;

ForwardingRegs ForwardingEX_MEM(
.EX_MEM_RegWrite(EX_MEM_RegWrite),
.EX_MEM_MemToReg(MEM_WB_MemToReg),
.EX_MEM_ALU_result(EX_MEM_ALUresult),
.EX_MEM_imm(EX_MEM_Imm),
.EX_MEM_PCadd4(EX_MEM_PCadd4),
.EX_MEM_RdIndex(EX_MEM_RegisterRd_Index),
.MEM_WB_RegWrite(MEM_WB_RegWrite),
.MEM_WB_MemToReg(MEM_WB_MemToReg),
.MEM_WB_DataIn(MEM_WB_DataIn),
.MEM_WB_ALU_result(MEM_WB_ALUresult),
.MEM_WB_imm(MEM_WB_Imm),
.MEM_WB_PCadd4(MEM_WB_PCadd4),
.MEM_WB_RdIndex(MEM_WB_RegisterRd_Index),
.ID_EX_Rs2Index(ID_EX_RegisterRs2_Index),
.ID_EX_Rs2Data(ID_EX_RegisterRs2_Data),
.Output(ForwardingRs2)
);

IF_ID SegmentReg1(
.clk(clk),
.rst(rst),
.D_cache_stall(D_cache_stall),
.I_cache_stall(I_cache_stall),
.ControlChange(ControlChange),
.PC_in(PC_PC),
.inst_in(inst_in),
.PC_out(IF_ID_PC),
.inst_out(IF_ID_Inst),
.PC_lock(PC_lock),
.inst_valid(IF_ID_inst_valid)
);

ID_EX SegmentReg2(
.clk(clk),
.rst(rst),
.IF_ID_inst_valid(IF_ID_inst_valid),
.D_cache_stall(D_cache_stall),
.I_cache_stall(I_cache_stall),
.PC_in(IF_ID_PC),
.imm_in(Inst_Imm),
.read_data_1_in(Regs_RegisterRs1_Data),
.read_data_2_in(Regs_RegisterRs2_Data),
.pc_src_in(Control_PCsrc),
.reg_write_in(Control_RegWrite),
.alu_src_b_in(Control_Alusrc_B),
.alu_src_a_in(Control_Alusrc_A),
.alu_op_in(Control_ALUop),
.mem_to_reg_in(Control_MemToReg),
.mem_write_in(Control_MemWrite),
.branch_in(Control_Branch),
.b_type_in(Control_B_type),
.reg_write_addr_in(Control_RegisterRd_Index),
.RegisterRs1_Index_in(Control_RegisterRs1_Index),
.RegisterRs2_Index_in(Control_RegisterRs2_Index),
.CSRSource_in(Control_CSRSource),
.Read_CSR_Data_in(CSR_Read_CSR_Data),
.WriteCSR_Addr_in(Control_WriteCSR_Addr),
.WriteCSR_in(Control_WriteCSR),
.CSR_WriteSource_in(Control_CSR_WriteSource),
.CSR_HowToWriteCSR_in(Control_CSR_HowToWriteCSR),
.mem_access_valid_in(Control_mem_access_valid),
.PC_out(ID_EX_PC),
.imm_out(ID_EX_Imm),
.read_data_1_out(ID_EX_RegisterRs1_Data),
.read_data_2_out(ID_EX_RegisterRs2_Data),
.pc_src_out(ID_EX_PCsrc),
.reg_write_out(ID_EX_RegWrite),
.alu_src_b_out(ID_EX_Alusrc_B),
.alu_src_a_out(ID_EX_Alusrc_A),
.alu_op_out(ID_EX_ALUop),
.mem_to_reg_out(ID_EX_MemToReg),
.mem_write_out(ID_EX_MemWrite),
.branch_out(ID_EX_Branch),
.b_type_out(ID_EX_B_type),
.reg_write_addr_out(ID_EX_RegisterRd_Index),
.RegisterRs1_Index_out(ID_EX_RegisterRs1_Index),
.RegisterRs2_Index_out(ID_EX_RegisterRs2_Index),
.CSRSource_out(ID_EX_CSRSource),
.Read_CSR_Data_out(ID_EX_Read_CSR_Data),
.WriteCSR_Addr_out(ID_EX_WriteCSR_Addr),
.WriteCSR_out(ID_EX_WriteCSR),
.CSR_WriteSource_out(ID_EX_CSR_WriteSource),
.CSR_HowToWriteCSR_out(ID_EX_CSR_HowToWriteCSR),
.mem_access_valid_out(ID_EX_mem_access_valid)
);

EX_MEM SegmentReg3(
.clk(clk),
.rst(rst),
.D_cache_stall(D_cache_stall),
.I_cache_stall(I_cache_stall),
.ALU_result_in(ALU_ALUresult),
.read_data_2_in(ForwardingRs2),
.PC_addimm_in(ADDER_PCaddImm),
.Zero_Flag_in(ALU_ZeroFlag),
.pc_src_in(ID_EX_PCsrc),
.reg_write_in(ID_EX_RegWrite),
.mem_to_reg_in(ID_EX_MemToReg),
.mem_write_in(ID_EX_MemWrite),
.branch_in(ID_EX_Branch),
.b_type_in(ID_EX_B_type),
.imm_in(ID_EX_Imm),
.reg_write_addr_in(ID_EX_RegisterRd_Index),
.PC_add4_in(ADDER_PCadd4),
.mem_access_valid_in(ID_EX_mem_access_valid),
.ALU_result_out(EX_MEM_ALUresult),
.read_data_2_out(data_out),
.PC_addimm_out(EX_MEM_PCaddImm),
.Zero_Flag_out(EX_MEM_ZeroFlag),
.pc_src_out(EX_MEM_PCsrc),
.reg_write_out(EX_MEM_RegWrite),
.mem_to_reg_out(EX_MEM_MemToReg),
.mem_write_out(mem_write),
.branch_out(EX_MEM_Branch),
.b_type_out(EX_MEM_B_type),
.imm_out(EX_MEM_Imm),
.reg_write_addr_out(EX_MEM_RegisterRd_Index),
.PC_add4_out(EX_MEM_PCadd4),
.mem_access_valid_out(output_mem_access_out)
);

MEM_WB SegmentReg4(
.clk(clk),
.rst(rst),
.D_cache_stall(D_cache_stall),
.I_cache_stall(I_cache_stall),
.read_data_in(data_in),
.ALU_result_in(EX_MEM_ALUresult),
.mem_to_reg_in(EX_MEM_MemToReg),
.imm_in(EX_MEM_Imm),
.reg_write_in(EX_MEM_RegWrite),
.reg_write_addr_in(EX_MEM_RegisterRd_Index),
.PC_add4_in(EX_MEM_PCadd4),
.read_data_out(MEM_WB_DataIn),
.ALU_result_out(MEM_WB_ALUresult),
.mem_to_reg_out(MEM_WB_MemToReg),
.imm_out(MEM_WB_Imm),
.reg_write_out(MEM_WB_RegWrite),
.reg_write_addr_out(MEM_WB_RegisterRd_Index),
.PC_add4_out(MEM_WB_PCadd4)
);

Control Control(
.csr_index(IF_ID_Inst[31:20]),
.op_code(IF_ID_Inst[6:0]),
.funct3(IF_ID_Inst[14:12]),
.funct7_5(IF_ID_Inst[30]),
.RdIN(IF_ID_Inst[11:7]),
.Rs1IN(IF_ID_Inst[19:15]),
.Rs2IN(IF_ID_Inst[24:20]),
.pc_src(Control_PCsrc),
.reg_write(Control_RegWrite),
.alu_src_b(Control_Alusrc_B),
.alu_src_a(Control_Alusrc_A),
.alu_op(Control_ALUop),
.mem_to_reg(Control_MemToReg),
.mem_write(Control_MemWrite),
.branch(Control_Branch),
.b_type(Control_B_type),
.Rs1(Control_RegisterRs1_Index),
.Rs2(Control_RegisterRs2_Index),
.Rd(Control_RegisterRd_Index),
.CSR_source(Control_CSRSource),
.CSR_read_index(Control_ReadCSR_Addr),
.CSR_write_index(Control_WriteCSR_Addr),
.CSR_write(Control_WriteCSR),
.CSR_writesource(Control_CSR_WriteSource),
.CSR_HowToWriteCSR(Control_CSR_HowToWriteCSR),
.mem_access_valid(Control_mem_access_valid)
);

Registers UniversalReg(
.clk(clk),
.rst(rst),
.debug_reg_addr(debug_reg_addr),
.we(MEM_WB_RegWrite),
.read_addr_1(Control_RegisterRs1_Index),
.read_addr_2(Control_RegisterRs2_Index),
.write_addr(MEM_WB_RegisterRd_Index),
.reg_write_data(Mux_RegisterRd_Data),
.read_data_1(Regs_RegisterRs1_Data),
.read_data_2(Regs_RegisterRs2_Data),
.reg_out(reg_out)
);

ImmGen ImmediateGenerator(
.inst(IF_ID_Inst),
.imm_out(Inst_Imm)
);

ADDER PCaddimm(
.input0(ID_EX_PC),
.input1(ID_EX_Imm),
.output0(ADDER_PCaddImm)
);

ADDER ID_EX_PCadd4(
.input0(ID_EX_PC),
.input1(32'h4),
.output0(ADDER_PCadd4)
);

MUX3b ALU_src_a(
.input000(ID_EX_RegisterRs1_Data),
.input001(ID_EX_PC),
.input010(ForwardingA),
.input011(32'b0),
.input1XX(ID_EX_Read_CSR_Data),
.sign({ID_EX_CSRSource, ForwardingSignA, ID_EX_Alusrc_A}),
.muxoutput(ALUsrca)
);

MUX2b ALU_src_b(
.input00(ID_EX_RegisterRs2_Data),
.input01(ID_EX_Imm),
.input10(ForwardingB),
.input11(ID_EX_Imm),
.sign({ForwardingSignB, ID_EX_Alusrc_B}),
.muxoutput(ALUsrcb)
);

MUX2b ReturnToUniversalRegs(
.input00(MEM_WB_ALUresult),
.input01(MEM_WB_Imm),
.input10(MEM_WB_PCadd4),
.input11(MEM_WB_DataIn),
.sign(MEM_WB_MemToReg),
.muxoutput(Mux_RegisterRd_Data)
);

ALU ALU(
.ALU_src1(ALUsrca),
.ALU_src2(ALUsrcb),
.alu_op(ID_EX_ALUop),
.ALU_result(ALU_ALUresult),
.Zero_Flag(ALU_ZeroFlag),
.Smaller_Flag(ALU_SmallerFlag)
);


Return_to_PC ReturnToPC(
.PC_addimm(ADDER_PCaddImm),
.ALU_result(ALU_ALUresult),
.pc_src(ID_EX_PCsrc),
.branch(ID_EX_Branch),
.b_type(ID_EX_B_type),
.Zero_Flag(ALU_ZeroFlag),
.Smaller_Flag(ALU_SmallerFlag),
.write_PC(write_PC),
.new_PC(new_PC)
);

PC PC(
.clk(clk),
.rst(rst),
.inst_in(inst_in),
.D_cache_stall(D_cache_stall),
.I_cache_stall(I_cache_stall),
.PC_lock(PC_lock),
.write_PC(write_PC),
.new_PC(new_PC),
.PC_out(PC_PC),
.ControlChange(ControlChange),
.pc_access_mem_valid(pc_access_mem_valid)
);

ForwardingUnit ForwardingALUsrc(
.EX_MEM_RegWrite(EX_MEM_RegWrite),
.MEM_WB_RegWrite(MEM_WB_RegWrite),
.EX_MEM_RegisterRd(EX_MEM_RegisterRd_Index),
.MEM_WB_RegisterRd(MEM_WB_RegisterRd_Index),
.ID_EX_RegisterRs1(ID_EX_RegisterRs1_Index),
.ID_EX_RegisterRs2(ID_EX_RegisterRs2_Index),
.EX_MEM_MemToReg(EX_MEM_MemToReg),
.EX_MEM_ALUresult(EX_MEM_ALUresult),
.EX_MEM_Imm(EX_MEM_Imm),
.EX_MEM_PCadd4(EX_MEM_PCadd4),
.MEM_WB_MemToReg(MEM_WB_MemToReg),
.MEM_WB_ALUresult(MEM_WB_ALUresult),
.MEM_WB_Imm(MEM_WB_Imm),
.MEM_WB_PCadd4(MEM_WB_PCadd4),
.MEM_WB_DataIn(MEM_WB_DataIn),
.ForwardingSignA(ForwardingSignA),
.ForwardingSignB(ForwardingSignB),
.ForwardingA(ForwardingA),
.ForwardingB(ForwardingB),
.OuterDetect(OuterDetect)
);

CSRs CSRreg(
.clk(clk),
.rst(rst),
.write(ID_EX_WriteCSR),
.howtowrite(ID_EX_CSR_HowToWriteCSR),
.CSR_write_addr(ID_EX_WriteCSR_Addr),
.CSR_read_addr(Control_ReadCSR_Addr),
.write_data(WriteCSR_Write_CSR_Data),
.read_data(CSR_Read_CSR_Data)
);

Writecsr ReturnToCSRs(
.CSR_WriteSource(ID_EX_CSR_WriteSource),
.PCadd4(ADDER_PCadd4),
.EX_MEM_RegWrite(EX_MEM_RegWrite),
.MEM_WB_RegWrite(MEM_WB_RegWrite),
.EX_MEM_RegisterRd(EX_MEM_RegisterRd_Index),
.MEM_WB_RegisterRd(MEM_WB_RegisterRd_Index),
.EX_MEM_MemToReg(EX_MEM_MemToReg),
.EX_MEM_ALUresult(EX_MEM_ALUresult),
.EX_MEM_Imm(EX_MEM_Imm),
.EX_MEM_PCadd4(EX_MEM_PCadd4),
.MEM_WB_MemToReg(MEM_WB_MemToReg),
.MEM_WB_ALUresult(MEM_WB_ALUresult),
.MEM_WB_Imm(MEM_WB_Imm),
.MEM_WB_PCadd4(MEM_WB_PCadd4),
.MEM_WB_DataIn(MEM_WB_DataIn),
.Reg_RegisterData(ID_EX_RegisterRs1_Data),
.Reg_Index(ID_EX_RegisterRs1_Index),
.Write_data(WriteCSR_Write_CSR_Data)
);

assign addr_out = EX_MEM_ALUresult;
assign pc_out = PC_PC >>> 2;

endmodule