`timescale 1ns / 1ps

module ALU(
input [31:0] ALU_src1,      //ALU A������
input [31:0] ALU_src2,      //ALU B������
input [3:0] alu_op,         //ALU ������
output reg [31:0] ALU_result,       //ALU ������
output reg Zero_Flag,                //���ʶ��
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
        
        4'b1110:            //�޷��űȽ�
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
            
        4'b1100:            //�з��űȽ�
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
        
        default:            //δ֧�ֵ�����
            ALU_result <= 32'b0;
    endcase
end

endmodule
