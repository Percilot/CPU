`timescale 1ns / 1ps

module ALU(
input [31:0] ALU_src1,      //ALU A口数据
input [31:0] ALU_src2,      //ALU B口数据
input [3:0] alu_op,         //ALU 操作符
output reg [31:0] ALU_result,       //ALU 运算结果
output reg Zero_Flag,                //零标识符
output reg Smaller_Flag
    );

always @ (*)
begin
    case (alu_op)
        4'b0000:            //ADD
        begin
            ALU_result <= ALU_src1 + ALU_src2;
        end
            
        4'b1000:            //SUB
        begin
            ALU_result <= ALU_src1 - ALU_src2;
        end
            
        4'b0001:            //SLL
        begin
            ALU_result <= ALU_src1<<(ALU_src2[4:0]);
        end
            
        4'b0010:             //SLT
        begin
            
            if(ALU_src1[31] == 1'b1 && ALU_src2[31] == 1'b0)
                ALU_result <= 32'b1;
            else if(ALU_src1[31] == 1'b0 && ALU_src2[31] == 1'b1)
                ALU_result <= 32'b0;
            else if(ALU_src1[31] == 1'b1 && ALU_src2[31] == 1'b1)
                ALU_result <= (ALU_src1[30:0] > ALU_src2[30:0]) ? 32'b0 : 32'b1;
            else
                ALU_result <= (ALU_src1[30:0] < ALU_src2[30:0]) ? 32'b1 : 32'b0;
                
        end
            
        4'b0011:             //SLTU
        begin
            ALU_result <= (ALU_src1 < ALU_src2) ? 32'b1 : 32'b0;
        end
            
        4'b0100:             //XOR
        begin
            ALU_result <= ALU_src1 ^ ALU_src2;
        end
            
        4'b0101:             //SRL
        begin
            ALU_result <= ALU_src1 >> (ALU_src2[4:0]);
        end
            
        4'b1101:            //SRA
        begin
            ALU_result <= ALU_src1 >>> (ALU_src2[4:0]);
        end
            
        4'b0110:            //OR
        begin
            ALU_result <= ALU_src1 | ALU_src2;
        end
            
        4'b0111:            //AND
            begin
            ALU_result <= ALU_src1 & ALU_src2;
            end
        
        4'b1110:            //无符号比较
        begin
            ALU_result <= 32'b0;
            
            if(ALU_src1 == ALU_src2)
            begin
                Zero_Flag <= 1'b1;
                Smaller_Flag <= 1'b0;
            end
            
            else if({1'b0, ALU_src1} < {1'b0, ALU_src2})
            begin
                Zero_Flag <= 1'b0;
                Smaller_Flag <= 1'b1;
            end
            
            else 
            begin
                Zero_Flag <= 1'b0;
                Smaller_Flag <= 1'b0;
            end
        end
            
        4'b1100:            //有符号比较
        begin
        
            ALU_result <= 32'b0;
        
            if(ALU_src1 == ALU_src2)
            begin
                Zero_Flag <= 1'b1;
                Smaller_Flag <= 1'b0;
            end
            
            else if(ALU_src1 < ALU_src2)
            begin
                Zero_Flag <= 1'b0;
                Smaller_Flag <= 1'b1;
            end
            
            else
            begin
                Zero_Flag <= 1'b0;
                Smaller_Flag <= 1'b0;
            end
        end
        
        default:            //未支持的运算
            ALU_result <= 32'b0;
    endcase
end

endmodule
