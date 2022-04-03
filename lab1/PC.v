`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 08:25:43
// Design Name: 
// Module Name: PC
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


module PC(
input clk,
input rst,
input PC_lock,
input write_PC,
input [31:0] new_PC,
output [31:0] PC_out,
output ControlChange
    );

reg [31:0] PC;

always @ (posedge clk or posedge rst or posedge PC_lock)
begin
        if(rst)
        begin
            PC <= 32'b0;
        end
        else if(PC_lock)
        begin
            PC <= PC;
        end
        else if(write_PC)
        begin
            PC <= new_PC;
        end
        else
        begin
            PC <= PC + 32'h4;
        end
end    

assign PC_out = PC;
assign ControlChange = write_PC;
endmodule
