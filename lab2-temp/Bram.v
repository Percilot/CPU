`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 01:28:25
// Design Name: 
// Module Name: Bram
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


module Bram(
input cpu_clk,
input mem_clk,
input rst,
input [31:0] cache_ram_addr,
input [31:0] cache_ram_data,
input cache_ram_write,
input cache_ram_valid,
output reg bram_ram_write,
output reg [31:0] bram_ram_addr,
output reg [31:0] bram_ram_data,
input [31:0] ram_data,
output reg bram_valid
    );

reg [31:0] to_ram_data;
reg [31:0] to_ram_addr;
reg ram_op;
reg ram_op_valid;
reg mem_op;

always @ (posedge rst or posedge mem_clk or posedge cpu_clk)
begin
    if(rst)
    begin
        to_ram_data <= 32'b0;
        to_ram_addr <= 32'b0;
        ram_op <= 1'b0;
        ram_op_valid <= 1'b0;
        mem_op <= 1'b0;
    
        bram_ram_write <= 1'b0;
        bram_ram_addr <= 32'b0;
        bram_ram_data <= 32'b0;
        bram_valid <= 1'b0;
    end
    
    else if(cpu_clk)
    begin
        bram_valid <= 1'b0;
        if(cache_ram_valid)
        begin
            to_ram_addr <= cache_ram_addr;
            to_ram_data <= cache_ram_data;
            ram_op <= cache_ram_write;
            ram_op_valid <= cache_ram_valid;
        end
    end
    
    else
    begin
        if(ram_op_valid)
        begin
            if(mem_op == 1'b0)
            begin
                bram_ram_write <= ram_op;
                bram_ram_addr <= to_ram_addr;
                bram_ram_data <= to_ram_data;
    
                bram_valid <= 1'b0;
                mem_op <= 1'b1;
            end
    
            else
            begin
                bram_ram_write <= 1'b0;
                bram_ram_addr <= 32'b0;
                bram_ram_data <= 32'b0;
    
                bram_valid <= 1'b1;
                ram_op_valid <= 1'b0;
                mem_op <= 1'b0;
            end
        end
    end
end


endmodule
