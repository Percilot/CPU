`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/30 11:38:31
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
input EX_MEM_RegWrite,
input MEM_WB_RegWrite,
input [4:0] EX_MEM_RegisterRd,
input [4:0] MEM_WB_RegisterRd,
input [4:0] ID_EX_RegisterRs1,
input [4:0] ID_EX_RegisterRs2,
input [1:0] EX_MEM_MemToReg,
input [31:0] EX_MEM_ALUresult,
input [31:0] EX_MEM_Imm,
input [31:0] EX_MEM_PCadd4,
input [1:0] MEM_WB_MemToReg,
input [31:0] MEM_WB_ALUresult,
input [31:0] MEM_WB_Imm,
input [31:0] MEM_WB_PCadd4,
input [31:0] MEM_WB_DataIn,
output reg ForwardingSignA,
output reg ForwardingSignB,
output reg [31:0] ForwardingA,
output reg [31:0] ForwardingB,
output reg OuterDetect
    );

always @ (*)
begin
    if((ID_EX_RegisterRs1 == EX_MEM_RegisterRd) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegWrite))
    begin
    
        ForwardingSignA <= 1'b1;
        
        case(EX_MEM_MemToReg)
            2'b00:
            begin
                ForwardingA <= EX_MEM_ALUresult;
                OuterDetect <= 1'b0;
            end
            2'b01:
            begin
                ForwardingA <= EX_MEM_Imm;
                OuterDetect <= 1'b0;
            end
            2'b10:
            begin
                ForwardingA <= EX_MEM_PCadd4;
                OuterDetect <= 1'b0;
            end
            2'b11:
            begin
                ForwardingA <= 32'b0;
                OuterDetect <= 1'b1;
            end
         endcase
    end
    else if((ID_EX_RegisterRs1 == MEM_WB_RegisterRd) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegWrite))
    begin
        
        ForwardingSignA <= 1'b1;
        OuterDetect <= 1'b1;
        
        case(MEM_WB_MemToReg)
            2'b00:ForwardingA <= MEM_WB_ALUresult;
            2'b01:ForwardingA <= MEM_WB_Imm;
            2'b10:ForwardingA <= MEM_WB_PCadd4;
            2'b11:ForwardingA <= MEM_WB_DataIn;
         endcase
         
    end
    else
    begin
         ForwardingSignA <= 1'b0;
         ForwardingA <= 32'b0;
         OuterDetect <= 1'b0;
    end
    
    if((ID_EX_RegisterRs2 == EX_MEM_RegisterRd) && (EX_MEM_RegisterRd != 0) && (EX_MEM_RegWrite))
    begin
    
        ForwardingSignB <= 1'b1;
        
        case(EX_MEM_MemToReg)
            2'b00:
            begin
                ForwardingB <= EX_MEM_ALUresult;
                OuterDetect <= 1'b0;
            end
            2'b01:
            begin
                ForwardingB <= EX_MEM_Imm;
                OuterDetect <= 1'b0;
            end
            2'b10:
            begin
                ForwardingB <= EX_MEM_PCadd4;
                OuterDetect <= 1'b0;
            end
            2'b11:
            begin
                ForwardingB <= 32'b0;
                OuterDetect <= 1'b1;
            end
        endcase
    end
    
    else if(((ID_EX_RegisterRs2 == MEM_WB_RegisterRd) && (MEM_WB_RegisterRd != 0) && (MEM_WB_RegWrite)))
    begin
        
        ForwardingSignB <= 1'b1;
        OuterDetect <= 1'b0;
        case(MEM_WB_MemToReg)
            2'b00:ForwardingB <= MEM_WB_ALUresult;
            2'b01:ForwardingB <= MEM_WB_Imm;
            2'b10:ForwardingB <= MEM_WB_PCadd4;
            2'b11:ForwardingB <= MEM_WB_DataIn;
        endcase
    end
    
    else
    begin
         ForwardingSignB <= 0;
         ForwardingB <= 32'b0;
         OuterDetect <= 1'b0;        
    end
    
end    
endmodule
