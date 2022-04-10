`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/12 10:03:37
// Design Name: 
// Module Name: Return_to_PC
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


module Return_to_PC(
input [31:0] PC_addimm,
input [31:0] ALU_result,
input [1:0] pc_src,
input branch,
input [2:0] b_type,
input Zero_Flag,
input Smaller_Flag,
output reg write_PC,
output reg [31:0] new_PC
    );
    
always @ *
begin
    if(pc_src == 2'b01)
    begin
        write_PC <= 1'b1;
        new_PC <= ALU_result;
    end
    
    else if(pc_src == 2'b00)
    begin
        if(branch)
        begin
            case(b_type)
            3'b000:
            begin
                if(Zero_Flag == 1'b0)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end
            
            3'b001:
            begin
                if(Zero_Flag == 1'b1)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end    
            
            3'b010:
            begin
                if(Smaller_Flag == 1'b1)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end
            
            3'b011:
            begin
                if(Smaller_Flag == 1'b0)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end
            
            3'b100:
            begin
                if(Smaller_Flag == 1'b1)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end
            
            3'b101:
            begin
                if(Smaller_Flag == 1'b0)
                begin
                    write_PC <= 1'b1;
                    new_PC <= PC_addimm;
                end
                
                else
                begin
                    write_PC <= 1'b0;
                    new_PC <= 32'b0;
                end
            end
            
            default:
            begin
                write_PC <= 1'b0;
                new_PC <= 32'b0;
            end
            
            endcase
        end
        
        else
        begin
            write_PC <= 1'b0;
            new_PC <= 32'b0;
        end
    end
    
    else if(pc_src == 2'b10)
    begin
        write_PC <= 1'b1;
        new_PC <= PC_addimm;
    end
    
    else
    begin
        write_PC <= 1'b0;
        new_PC <= 32'b0;
    end
end     
    
endmodule
