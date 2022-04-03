`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 08:46:34
// Design Name: 
// Module Name: ID_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ID_EX(
input clk,
input rst,
input D_cache_stall,
input [31:0] PC_in,
input [31:0] imm_in,
input [31:0] read_data_1_in,
input [31:0] read_data_2_in,
input [1:0] pc_src_in,
input reg_write_in,
input alu_src_b_in,
input alu_src_a_in,
input [3:0] alu_op_in,
input [1:0] mem_to_reg_in,
input mem_write_in,
input branch_in,
input [2:0] b_type_in,
input [4:0] reg_write_addr_in,
input [4:0] RegisterRs1_Index_in,
input [4:0] RegisterRs2_Index_in,
input CSRSource_in,
input [31:0] Read_CSR_Data_in,
input [11:0] WriteCSR_Addr_in,
input WriteCSR_in,
input [1:0] CSR_WriteSource_in,
input [1:0] CSR_HowToWriteCSR_in,
input mem_access_valid_in,
output [31:0] PC_out,
output [31:0] imm_out,
output [31:0] read_data_1_out,
output [31:0] read_data_2_out,
output [1:0] pc_src_out,
output reg_write_out,
output alu_src_b_out,
output alu_src_a_out,
output [3:0] alu_op_out,
output [1:0] mem_to_reg_out,
output mem_write_out,
output branch_out,
output [2:0] b_type_out,
output [4:0] reg_write_addr_out,
output [4:0] RegisterRs1_Index_out,
output [4:0] RegisterRs2_Index_out,
output CSRSource_out,
output [31:0] Read_CSR_Data_out,
output [11:0] WriteCSR_Addr_out,
output WriteCSR_out,
output [1:0] CSR_WriteSource_out,
output [1:0] CSR_HowToWriteCSR_out,
output mem_access_valid_out
    );

reg [11:0] WriteCSR_Addr;
reg [31:0] PC, imm, read_data_1, read_data_2, Read_CSR_Data;
reg alu_src_b, alu_src_a, reg_write, mem_write, branch, CSRSource, WriteCSR, mem_access_valid;
reg [1:0] pc_src, mem_to_reg, CSR_WriteSource, CSR_HowToWriteCSR;
reg [2:0] b_type;
reg [3:0] alu_op;
reg [4:0] reg_write_addr, RegisterRs1_Index, RegisterRs2_Index;

always @ (posedge clk or posedge rst)   
begin
    if(rst)
    begin
        PC <= 32'b0;
        imm <= 32'b0;
        read_data_1 <= 32'b0;
        read_data_2 <= 32'b0;
        alu_src_b <= 1'b0;
        alu_src_a <= 1'b0;
        reg_write <= 1'b0;
        mem_write <= 1'b0;
        branch <= 1'b0;
        b_type <= 3'b0;
        pc_src <= 2'b0;
        mem_to_reg <= 2'b0;
        alu_op <= 4'b0;
        reg_write_addr <= 5'b0;
        RegisterRs1_Index <= 5'b0;
        RegisterRs2_Index <= 5'b0;
        CSRSource <= 1'b0;
        Read_CSR_Data <= 32'b0;
        WriteCSR_Addr <= 12'b0;
        WriteCSR <= 1'b0;
        CSR_WriteSource <= 2'b0;
        CSR_HowToWriteCSR <= 2'b0;
        mem_access_valid <= 1'b0;
    end
    
    else if(D_cache_stall)
    begin
        PC <= PC;
        imm <= imm;
        read_data_1 <= read_data_1;
        read_data_2 <= read_data_2;
        alu_src_b <= alu_src_b;
        alu_src_a <= alu_src_a;
        reg_write <= reg_write;
        mem_write <= mem_write;
        branch <= branch;
        b_type <= b_type;
        pc_src <= pc_src;
        mem_to_reg <= mem_to_reg;
        alu_op <= alu_op;
        reg_write_addr <= reg_write_addr;
        RegisterRs1_Index <= RegisterRs1_Index;
        RegisterRs2_Index <= RegisterRs2_Index;
        CSRSource <= CSRSource;
        Read_CSR_Data <= Read_CSR_Data;
        WriteCSR_Addr <= WriteCSR_Addr;
        WriteCSR <= WriteCSR;
        CSR_WriteSource <= CSR_WriteSource;
        CSR_HowToWriteCSR <= CSR_HowToWriteCSR;
        mem_access_valid <= mem_access_valid;
    end

    else
    begin
        PC <= PC_in;
        imm <= imm_in;
        read_data_1 <= read_data_1_in;
        read_data_2 <= read_data_2_in;
        alu_src_b <= alu_src_b_in;
        alu_src_a <= alu_src_a_in;
        reg_write <= reg_write_in;
        mem_write <= mem_write_in;
        branch <= branch_in;
        b_type <= b_type_in;
        pc_src <= pc_src_in;
        mem_to_reg <= mem_to_reg_in;
        alu_op <= alu_op_in;
        reg_write_addr <= reg_write_addr_in;
        RegisterRs1_Index <= RegisterRs1_Index_in;
        RegisterRs2_Index <= RegisterRs2_Index_in;
        CSRSource <= CSRSource_in;
        Read_CSR_Data <= Read_CSR_Data_in;
        WriteCSR_Addr <= WriteCSR_Addr_in;
        WriteCSR <= WriteCSR_in;
        CSR_WriteSource <= CSR_WriteSource_in;
        CSR_HowToWriteCSR <= CSR_HowToWriteCSR_in;
        mem_access_valid <= mem_access_valid_in;
    end
end

assign PC_out = (D_cache_stall == 1'b1) ? 32'b0 : PC;
assign imm_out = (D_cache_stall == 1'b1) ? 32'b0 : imm;
assign read_data_1_out = (D_cache_stall == 1'b1) ? 32'b0 : read_data_1;
assign read_data_2_out = (D_cache_stall == 1'b1) ? 32'b0 : read_data_2;
assign alu_src_b_out = (D_cache_stall == 1'b1) ? 1'b0 : alu_src_b;
assign alu_src_a_out = (D_cache_stall == 1'b1) ? 1'b0 : alu_src_a;
assign reg_write_out = (D_cache_stall == 1'b1) ? 1'b0 : reg_write;
assign mem_write_out = (D_cache_stall == 1'b1) ? 1'b0 :mem_write;
assign branch_out = (D_cache_stall == 1'b1) ? 1'b0 : branch;
assign b_type_out = (D_cache_stall == 1'b1) ? 3'b0 : b_type;
assign pc_src_out = (D_cache_stall == 1'b1) ? 2'b0 : pc_src;
assign mem_to_reg_out = (D_cache_stall == 1'b1) ? 2'b0 : mem_to_reg;
assign alu_op_out = (D_cache_stall == 1'b1) ? 4'b0 : alu_op;
assign reg_write_addr_out = (D_cache_stall == 1'b1) ? 5'b0 : reg_write_addr;
assign RegisterRs1_Index_out = (D_cache_stall == 1'b1) ? 5'b0 : RegisterRs1_Index;
assign RegisterRs2_Index_out = (D_cache_stall == 1'b1) ? 5'b0 : RegisterRs2_Index;
assign CSRSource_out = (D_cache_stall == 1'b1) ? 1'b0 : CSRSource;
assign Read_CSR_Data_out = (D_cache_stall == 1'b1) ? 32'b0 : Read_CSR_Data;
assign WriteCSR_Addr_out = (D_cache_stall == 1'b1) ? 12'b0 : WriteCSR_Addr;
assign WriteCSR_out = (D_cache_stall == 1'b1) ? 1'b0 : WriteCSR;
assign CSR_WriteSource_out = (D_cache_stall == 1'b1) ? 2'b0 : CSR_WriteSource;
assign CSR_HowToWriteCSR_out = (D_cache_stall == 1'b1) ? 2'b0 : CSR_HowToWriteCSR;
assign mem_access_valid_out = (D_cache_stall == 1'b1) ? 1'b0 : mem_access_valid;
endmodule
