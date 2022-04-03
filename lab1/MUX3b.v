`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/24 11:27:05
// Design Name: 
// Module Name: MUX3b
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
module MUX3b(
input [31:0] input000,
input [31:0] input001,
input [31:0] input010,
input [31:0] input011,
input [31:0] input1XX,
input [2:0] sign,
output reg [31:0] muxoutput
    );
    
always @ *
begin
    if(sign==3'b000)
        muxoutput <= input000;
    else if(sign==3'b001)
        muxoutput <= input001;
    else if(sign==3'b010)
        muxoutput <= input010;
    else if(sign==3'b011)
        muxoutput <= input011;
    else
        muxoutput <= input1XX;    
end    
    
endmodule
