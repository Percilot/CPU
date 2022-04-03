`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 09:21:16
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
input clk,
input rst,
input D_cache_stall,
input [31:0] ALU_result_in,
input [31:0] read_data_2_in,
input [31:0] PC_addimm_in,
input Zero_Flag_in,
input [1:0] pc_src_in,
input reg_write_in,
input [1:0] mem_to_reg_in,
input mem_write_in,
input branch_in,
input [2:0] b_type_in,
input [31:0] imm_in,
input [4:0] reg_write_addr_in,
input [31:0] PC_add4_in,
input mem_access_valid_in,
output [31:0] ALU_result_out,
output [31:0] read_data_2_out,
output [31:0] PC_addimm_out,
output Zero_Flag_out,
output [1:0] pc_src_out,
output reg_write_out,
output [1:0] mem_to_reg_out,
output mem_write_out,
output branch_out,
output [2:0] b_type_out,
output [31:0] imm_out,
output [4:0] reg_write_addr_out,
output [31:0] PC_add4_out,
output mem_access_valid_out
    );

reg [31:0] ALU_result, read_data_2, PC_addimm, imm, PC_add4;
reg [1:0] pc_src, mem_to_reg;
reg [2:0] b_type;
reg Zero_Flag, reg_write, mem_write, branch, mem_access_valid;
reg [4:0] reg_write_addr;

always @ (posedge clk or posedge rst)
begin
    if(rst)
    begin
        ALU_result <= 32'b0;
        read_data_2 <= 32'b0;
        PC_addimm <= 32'b0;
        pc_src <= 2'b0;
        mem_to_reg <= 2'b0;
        Zero_Flag <= 1'b0;
        reg_write <= 1'b0;
        mem_write <= 1'b0;
        branch <= 1'b0;
        b_type <= 3'b0;
        imm <= 32'b0;
        reg_write_addr <= 5'b0;
        PC_add4 <= 32'b0;
        mem_access_valid <= 1'b0;        
    end
    
    else if(D_cache_stall)
    begin
        ALU_result <= ALU_result;
        read_data_2 <= read_data_2;
        PC_addimm <= PC_addimm;
        pc_src <= pc_src;
        mem_to_reg <= mem_to_reg;
        Zero_Flag <= Zero_Flag;
        reg_write <= reg_write;
        mem_write <= mem_write;
        branch <= branch;
        b_type <= b_type;
        imm <= imm;
        reg_write_addr <= reg_write_addr;
        PC_add4 <= PC_add4;
        mem_access_valid <= mem_access_valid;
    end

    else
    begin
        ALU_result <= ALU_result_in;
        read_data_2 <= read_data_2_in;
        PC_addimm <= PC_addimm_in;
        pc_src <= pc_src_in;
        mem_to_reg <= mem_to_reg_in;
        Zero_Flag <= Zero_Flag_in;
        reg_write <= reg_write_in;
        mem_write <= mem_write_in;
        branch <= branch_in;
        b_type <= b_type_in;
        imm <= imm_in;
        reg_write_addr <= reg_write_addr_in;
        PC_add4 <= PC_add4_in;
        mem_access_valid <= mem_access_valid_in;        
    end
end    
    
assign ALU_result_out = (D_cache_stall == 1'b1) ? 32'b0 : ALU_result;
assign read_data_2_out = (D_cache_stall == 1'b1) ? 32'b0 : read_data_2;
assign PC_addimm_out = (D_cache_stall == 1'b1) ? 32'b0 : PC_addimm;
assign pc_src_out = (D_cache_stall == 1'b1) ? 2'b0 : pc_src;
assign mem_to_reg_out = (D_cache_stall == 1'b1) ? 2'b0 : mem_to_reg;
assign Zero_Flag_out = (D_cache_stall == 1'b1) ? 1'b0 : Zero_Flag;
assign reg_write_out = (D_cache_stall == 1'b1) ? 1'b0 : reg_write;
assign mem_write_out = (D_cache_stall == 1'b1) ? 1'b0 : mem_write;
assign branch_out = (D_cache_stall == 1'b1) ? 1'b0 : branch;
assign b_type_out = (D_cache_stall == 1'b1) ? 3'b0 : b_type;    
assign imm_out = (D_cache_stall == 1'b1) ? 32'b0 : imm;
assign reg_write_addr_out = (D_cache_stall == 1'b1) ? 5'b0 : reg_write_addr;
assign PC_add4_out = (D_cache_stall == 1'b1) ? 32'b0 : PC_add4;
assign mem_access_valid_out = (D_cache_stall == 1'b1) ? 1'b0 : mem_access_valid;

endmodule
