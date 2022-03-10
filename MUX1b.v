`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/20 21:17:40
// Design Name: 
// Module Name: MUX1b
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


module MUX1b(
input [31:0] input0,
input [31:0] input1,
input sign,
output [31:0] muxoutput
    );
    
assign muxoutput= sign?input1:input0;
    
endmodule
