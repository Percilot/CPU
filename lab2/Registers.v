`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 20:53:51
// Design Name: 
// Module Name: Registers
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


module Registers(
input clk,
input rst,
input [4:0] debug_reg_addr,
input we,
input [4:0] read_addr_1,
input [4:0] read_addr_2,
input [4:0] write_addr,
input [31:0] reg_write_data,
output [31:0] read_data_1,
output [31:0] read_data_2,
output [31:0] reg_out
    );
    
integer l;
reg [31:0] register [1:31];

assign read_data_1 = (read_addr_1 == 0) ? 0 : register[read_addr_1];
assign read_data_2 = (read_addr_2 == 0) ? 0 : register[read_addr_2];
assign reg_out = register[debug_reg_addr];

always @ (negedge clk or posedge rst)
begin

    if(rst==1)
    for(l=0;l<32;l=l+1)
        register[l]<=0;
    
    else if(we==1&&write_addr!=0)
        register[write_addr]<=reg_write_data;
end

endmodule
