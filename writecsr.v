`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/22 14:09:47
// Design Name: 
// Module Name: writecsr
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


module Writecsr(
input [1:0] CSR_WriteSource,
input [31:0] PCadd4,
input EX_MEM_RegWrite,
input MEM_WB_RegWrite,
input [4:0] EX_MEM_RegisterRd,
input [4:0] MEM_WB_RegisterRd,
input [1:0] EX_MEM_MemToReg,
input [31:0] EX_MEM_ALUresult,
input [31:0] EX_MEM_Imm,
input [31:0] EX_MEM_PCadd4,
input [1:0] MEM_WB_MemToReg,
input [31:0] MEM_WB_ALUresult,
input [31:0] MEM_WB_Imm,
input [31:0] MEM_WB_PCadd4,
input [31:0] MEM_WB_DataIn,
input [31:0] Reg_RegisterData,
input [4:0] Reg_Index,
output reg [31:0] Write_data
    );
    
always @ *
begin
    if(CSR_WriteSource == 2'b00)
    begin
        if((Reg_Index == EX_MEM_RegisterRd) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegWrite))
        begin
            case(EX_MEM_MemToReg)
                2'b00:Write_data <= EX_MEM_ALUresult;
                2'b01:Write_data <= EX_MEM_Imm;
                2'b10:Write_data <= EX_MEM_PCadd4;
                2'b11:Write_data <= 32'b0;
            endcase    
        end
        
        else if((Reg_Index == MEM_WB_RegisterRd) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegWrite))
        begin
            case(MEM_WB_MemToReg)
                2'b00:Write_data <= MEM_WB_ALUresult;
                2'b01:Write_data <= MEM_WB_Imm;
                2'b10:Write_data <= MEM_WB_PCadd4;
                2'b11:Write_data <= MEM_WB_DataIn;
            endcase    
        end
        
        else
        begin
            Write_data <= Reg_RegisterData;
        end
    end
    
    else if(CSR_WriteSource == 2'b01)
    begin
        Write_data <= PCadd4;
    end
end     
endmodule
