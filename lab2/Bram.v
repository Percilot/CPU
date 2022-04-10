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
input rst,
input cache_ram_valid,
output reg bram_valid
    );

reg [3:0] ram_counter;

always @ (posedge cpu_clk or posedge rst)
begin
    if(rst)
    begin
        ram_counter <= 4'b0;
        bram_valid <= 1'b0;
    end
    
    else
    begin
        if(ram_counter != 4'b0 && ram_counter != 4'h8)
        begin
            ram_counter <= ram_counter + 4'b1;
            bram_valid <= 1'b0;
        end
            
        else if(ram_counter == 4'h8)
        begin
            ram_counter <= 4'b0;
            bram_valid <= 1'b1;
        end
            
        else if(cache_ram_valid)
        begin
            ram_counter <= 4'b1;
            bram_valid <= 1'b0;
        end
        
        else
        begin
            ram_counter <= 4'b0;
            bram_valid <= 1'b0;
        end
    end
end

endmodule
