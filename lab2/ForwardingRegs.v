`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/11 23:02:09
// Design Name: 
// Module Name: ForwardingRegs
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


module ForwardingRegs(
input EX_MEM_RegWrite,
input [1:0] EX_MEM_MemToReg,
input [31:0] EX_MEM_ALU_result,
input [31:0] EX_MEM_imm,
input [31:0] EX_MEM_PCadd4,
input [4:0] EX_MEM_RdIndex,
input MEM_WB_RegWrite,
input [1:0] MEM_WB_MemToReg,
input [31:0] MEM_WB_DataIn,
input [31:0] MEM_WB_ALU_result,
input [31:0] MEM_WB_imm,
input [31:0] MEM_WB_PCadd4,
input [4:0] MEM_WB_RdIndex,
input [4:0] ID_EX_Rs2Index,
input [31:0] ID_EX_Rs2Data,
output reg [31:0] Output
    );
    
 always @ *
 begin
    if(EX_MEM_RdIndex == ID_EX_Rs2Index && EX_MEM_RegWrite)
    begin
        case(EX_MEM_MemToReg)
            2'b00:
            begin
                Output <= EX_MEM_ALU_result;
            end
            
            2'b01:
            begin
                Output <= EX_MEM_imm;
            end
            
            2'b10:
            begin
                Output <= EX_MEM_PCadd4;
            end
            
            2'b11:
            begin
                Output <= 32'b0;
            end
        endcase
    end
    
    else if(MEM_WB_RdIndex == ID_EX_Rs2Index && MEM_WB_RegWrite)
    begin
        case(MEM_WB_MemToReg)
            2'b00:
            begin
                Output <= MEM_WB_ALU_result;
            end
            
            2'b01:
            begin
                Output <= MEM_WB_imm;
            end
            
            2'b10:
            begin
                Output <= MEM_WB_PCadd4;
            end
            
            2'b11:
            begin
                Output <= MEM_WB_DataIn;
            end
        endcase
    end
    
    else
    begin
        Output <= ID_EX_Rs2Data;
    end
 end   
    
endmodule
