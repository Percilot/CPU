`timescale 1ns / 1ps

module MUX2b(
input [31:0] input00,
input [31:0] input01,
input [31:0] input10,
input [31:0] input11,
input [1:0] sign,
output reg [31:0] muxoutput
    );
    
always @ *
begin
    if(sign==2'b00)
        muxoutput <= input00;
    else if(sign==2'b01)
        muxoutput <= input01;
    else if(sign==2'b10)
        muxoutput <= input10;
    else if(sign==2'b11)
        muxoutput <= input11;
    else
        muxoutput <= 32'b0;    
end    
    
endmodule
