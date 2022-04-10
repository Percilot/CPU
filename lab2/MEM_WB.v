`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 10:17:09
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
input clk,
input rst,
input D_cache_stall,
input I_cache_stall,
input [31:0] read_data_in,
input [31:0] ALU_result_in,
input [1:0] mem_to_reg_in,
input [31:0] imm_in,
input reg_write_in,
input [4:0] reg_write_addr_in,
input [31:0] PC_add4_in,
output [31:0] read_data_out,
output [31:0] ALU_result_out,
output [1:0] mem_to_reg_out,
output [31:0] imm_out,
output reg_write_out,
output [4:0] reg_write_addr_out,
output [31:0] PC_add4_out
    );
 
reg [31:0] read_data, ALU_result, imm, PC_add4;
reg [1:0] mem_to_reg;
reg [4:0] reg_write_addr;
reg reg_write;

always @ (posedge clk or posedge rst)
begin
    if(rst)
    begin
        read_data <= 32'b0;
        ALU_result <= 32'b0;
        imm <= 32'b0;
        mem_to_reg <= 2'b0;
        reg_write <= 1'b0;
        reg_write_addr <= 5'b0;
        PC_add4 <= 32'b0;
    end
    
    else if(D_cache_stall || I_cache_stall)
    begin
        if(read_data_in == 32'b0)
            read_data <= read_data;
        else
            read_data <= read_data_in;
        ALU_result <= ALU_result;
        imm <= imm;
        mem_to_reg <= mem_to_reg;
        reg_write <= reg_write;
        reg_write_addr <= reg_write_addr;
        PC_add4 <= PC_add4;
    end

    else
    begin
        read_data <= read_data_in;
        ALU_result <= ALU_result_in;
        imm <= imm_in;
        mem_to_reg <= mem_to_reg_in;
        reg_write <= reg_write_in;
        reg_write_addr <= reg_write_addr_in;
        PC_add4 <= PC_add4_in;
    end
end    

assign read_data_out = (read_data_in == 32'b0) ? read_data : read_data_in;
assign ALU_result_out = (D_cache_stall) ? 32'b0 : ALU_result;
assign imm_out = (D_cache_stall)? 32'b0 : imm;
assign mem_to_reg_out = (D_cache_stall) ? 2'b0 : mem_to_reg;
assign reg_write_out = (D_cache_stall) ? 1'b0 : reg_write;
assign reg_write_addr_out = (D_cache_stall) ? 5'b0 : reg_write_addr;
assign PC_add4_out = (D_cache_stall) ? 32'b0 : PC_add4;
    
endmodule
