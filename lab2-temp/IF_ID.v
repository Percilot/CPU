`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 08:36:37
// Design Name: 
// Module Name: ID_IF
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


module IF_ID(
input clk,
input rst,
input D_cache_stall,
input ControlChange,
input [31:0] PC_in,
input [31:0] inst_in,
output reg [31:0] PC_out,
output reg [31:0] inst_out,
output reg PC_lock,
output reg inst_valid
    );

reg [31:0] StallCounter, PClockCounter;

always @ (posedge clk or posedge rst)
begin
    if(rst)
    begin
        PC_out <= 32'b0;
        inst_out <= 32'b0;
        inst_valid <= 1'b0;
        StallCounter <= 32'b0;
        PClockCounter <= 32'b0;
        PC_lock <= 1'b0;
    end

    else if(D_cache_stall)
    begin
        PC_out <= 32'b0;
        inst_out <= 32'h00000013;
        inst_valid <= 1'b0;
    end
    
    else if(ControlChange)
    begin
        PC_out <= 32'b0;
        inst_out <= 32'h00000013;
        inst_valid <= 1'b0;
        PC_lock <= 1'b0;
        StallCounter <= StallCounter;
        PClockCounter <= PClockCounter;
    end
    
    else if(StallCounter != 32'b0 || PClockCounter != 32'b0)
    begin
        if(StallCounter != 32'b0)
        begin
            PC_out <= 32'b0;
            inst_out <= 32'h00000013;
            inst_valid <= 1'b0;
            StallCounter <= StallCounter - 32'b1;
        end
        else
        begin
            PC_out <= PC_in;
            inst_out <= inst_in;
            inst_valid <= 1'b1;
            StallCounter <= StallCounter;
        end
        
        if(PClockCounter != 32'b0)
        begin
            PC_lock <= 1'b1;
            PClockCounter <= PClockCounter - 32'b1;
        end
            
        else
        begin
            PC_lock <= 1'b0;
            PClockCounter <= PClockCounter;
        end
    end    
    
    else if(inst_in[31:0] == 32'b00000000000000000000000001110011 || inst_in[31:0] == 32'b00110000001000000000000001110011)
    begin
        PC_lock <= 1'b1;
        PClockCounter <= 32'h0;
        StallCounter <= 32'h1;
        inst_out <= inst_in;
        inst_valid <= 1'b1;
        PC_out <= PC_in;
    end
    
    else
    begin
        case(inst_in[6:0])
            7'b1100011:
            begin
                PC_lock <= 1'b1;
                PClockCounter <= 32'h0;
                StallCounter <= 32'h1;
                inst_out <= inst_in;
                inst_valid <= 1'b1;
                PC_out <= PC_in;
            end
            
            7'b1101111:
            begin
                PC_lock <= 1'b1;
                PClockCounter <= 32'h0;
                StallCounter <= 32'h1;
                inst_out <= inst_in;
                inst_valid <= 1'b1;
                PC_out <= PC_in;
            end
            
            7'b1100111:
            begin
                PC_lock <= 1'b1;
                PClockCounter <= 32'h0;
                StallCounter <= 32'h1;
                inst_out <= inst_in;
                inst_valid <= 1'b1;
                PC_out <= PC_in;
            end
            
            7'b0000011:
            begin
                PC_lock <= 1'b1;
                PClockCounter <= 32'h0;
                StallCounter <= 32'h1;
                inst_out <= inst_in;
                inst_valid <= 1'b1;
                PC_out <= PC_in;
            end
            
            default:
            begin
                PC_lock <= 1'b0;
                PClockCounter <= 32'h0;
                StallCounter <= 32'h0;
                inst_out <= inst_in;
                inst_valid <= 1'b1;
                PC_out <= PC_in;
            end
        endcase
    end
end    


endmodule
