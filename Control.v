module Control(
input [11:0] csr_index,
input [6:0] op_code,
input [2:0] funct3,
input funct7_5,
input [4:0] RdIN,
input [4:0] Rs1IN,
input [4:0] Rs2IN,
output reg [1:0] pc_src,
output reg reg_write,
output reg alu_src_b,
output reg alu_src_a,       //控制ALU A口数据的选择，1'b0代表数据来自regs，1'b1代表数据来自pc
output reg [3:0] alu_op,
output reg [1:0] mem_to_reg,
output reg mem_write,
output reg branch,
output reg [2:0] b_type,
output reg [4:0] Rs1,
output reg [4:0] Rs2,
output reg [4:0] Rd,
output reg CSR_source,
output reg [11:0] CSR_read_index,
output reg [11:0] CSR_write_index,
output reg CSR_write,
output reg [1:0] CSR_writesource,
output reg [1:0] CSR_HowToWriteCSR
);

always @ (*) 
begin
pc_src <= 2'b0;
reg_write <= 1'b0;
alu_src_b <= 1'b0;
alu_src_a <= 1'b0;
alu_op <= {funct7_5, funct3};
mem_to_reg <= 2'b0;
mem_write <= 1'b0;
branch <= 1'b0;
b_type <= 3'b0;
Rs1 <= 4'b0;
Rs2 <= 4'b0;
Rd <= 4'b0;
CSR_source <= 1'b0;
CSR_read_index <= 12'b0;
CSR_write_index <= 12'b0;
CSR_write <= 1'b0;
CSR_writesource <= 2'b00;
CSR_HowToWriteCSR <= 2'b00;

        case (op_code)
            7'b0110111:     //U型指令 LUI
            begin 
                pc_src <= 2'b00; 
                reg_write <= 1'b1; 
                mem_to_reg <= 2'b01;
                branch <= 1'b0;
                b_type <= 3'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b0;
                alu_src_a <= 1'b0;
                Rs1 <= 4'b0;
                Rs2 <= 4'b0;
                Rd <= RdIN;
            end
            
            7'b0010011:     //部分I型指令
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b00;
                branch <= 1'b0;
                b_type <= 3'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b1;
                alu_src_a <= 1'b0;
                Rs1 <= Rs1IN;
                Rs2 <= 4'b0;
                Rd <= RdIN;
                if(funct3==3'b000)      //ADDI
                    alu_op <= 4'b0000;
                else if(funct3==3'b010) //SLTI
                    alu_op <= 4'b0010;
                else if(funct3==3'b111) //ANDI
                    alu_op <= 4'b0111;
                else if(funct3==3'b110) //ORI
                    alu_op <= 4'b0110;
                else if(funct3==3'b100) //XORI
                    alu_op <= 4'b0100;
                else if(funct3==3'b001) //SLLI
                    alu_op <= 4'b0001;
                else if(funct3==3'b101) //SRLI
                    alu_op <= 4'b0101;
                        
            end
            
            7'b0000011:     //I型指令 LW
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b11;
                branch <= 1'b0;
                b_type <= 3'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b1;
                alu_src_a <= 1'b0;
                alu_op <= 4'b0000;
                Rs1 <= Rs1IN;
                Rs2 <= 4'b0;
                Rd <= RdIN;
            end
            
            7'b0100011:     //S型指令 SW
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b0;
                mem_to_reg <= 2'b00;
                branch <= 1'b0;
                b_type <= 3'b0;
                mem_write <= 1'b1;
                alu_src_b <= 1'b1;
                alu_src_a <= 1'b0;
                alu_op <= 4'b0000;
                Rs1 <= Rs1IN;
                Rs2 <= Rs2IN;
                Rd <= 4'b0;
            end
            
            7'b1100011:     //部分B型指令
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b0;
                mem_to_reg <= 2'b00;
                branch <= 1'b1;
                mem_write <= 1'b0;
                alu_src_b <= 1'b0;
                alu_src_a <= 1'b0;     
                Rs1 <= Rs1IN;
                Rs2 <= Rs2IN;
                Rd <= 4'b0;
                if(funct3 == 3'b001)      //BNE
                begin
                    b_type <= 3'b000;
                    alu_op <= 4'b1100;
                end
                
                else if(funct3 == 3'b000) //BEQ
                begin
                    b_type <= 3'b001;
                    alu_op <= 4'b1100;
                end
                    
                else if(funct3 == 3'b100)   //BLT
                begin
                    b_type <= 3'b010;
                    alu_op <= 4'b1100;
                end
                    
                else if(funct3 == 3'b101)   //BGE
                begin
                    b_type <= 3'b011;
                    alu_op <= 4'b1100;
                end
                    
                else if(funct3 == 3'b110)   //BLTU
                begin
                    b_type <= 3'b100;
                    alu_op <= 4'b1110;
                end
                    
                else if(funct3 == 3'b111)   //BGEU
                begin
                    b_type <= 3'b101;
                    alu_op <= 4'b1110;
                end                
            end
            
            7'b1101111:     //J型指令 JAL
            begin
                pc_src <= 2'b10;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b10;
                branch <= 1'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b0;
                alu_src_a <= 1'b0;
                alu_op <= 4'b0000;
                Rs1 <= 4'b0;
                Rs2 <= 4'b0;
                Rd <= RdIN;
            end
            
            7'b0110011:     //部分R型指令
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b00;
                branch <= 1'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b0;
                alu_src_a <= 1'b0;        
                Rs1 <= Rs1IN;
                Rs2 <= Rs2IN;
                Rd <= RdIN;
                
                if(funct3==3'b000)  //ADD
                begin
                    if(funct7_5)
                        alu_op <= 4'b1000;
                    else
                        alu_op <= 4'b0000;
                end
                else if(funct3==3'b010) //SLT
                    alu_op <= 4'b0010;
                else if(funct3==3'b111) //AND
                    alu_op <= 4'b0111;
                else if(funct3==3'b110) //OR
                    alu_op <= 4'b0110;
                else if(funct3==3'b001) //SLL
                    alu_op <= 4'b0001;
                else if(funct3==3'b101) //SRL
                    alu_op <= 4'b0101;
                else if(funct3==3'b011) //SLTU
                    alu_op <= 4'b0011;   
            end
            
            7'b0010111:     //U型指令 AUIPC
            begin
                pc_src <= 2'b00;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b00;
                branch <= 1'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b1;
                alu_src_a <= 1'b1;
                alu_op <= 4'b0000;
                Rs1 <= 4'b0;
                Rs2 <= 4'b0;
                Rd <= RdIN;
            end
            
            7'b1100111:     //I型指令 JALR
            begin
                pc_src <= 2'b01;
                reg_write <= 1'b1;
                mem_to_reg <= 2'b10;
                branch <= 1'b0;
                mem_write <= 1'b0;
                alu_src_b <= 1'b1;
                alu_src_a <= 1'b0;
                alu_op <= 4'b0000;
                Rs1 <= Rs1IN;
                Rs2 <= 4'b0;
                Rd <= RdIN;
            end
            
            7'b1110011:
            begin
                case(funct3)
                3'b001:     //CSRRW
                begin
                    alu_op <= 4'b0000;
                    pc_src <= 2'b00;
                    reg_write <= 1'b1;
                    mem_to_reg <= 2'b00;
                    branch <= 1'b0;
                    mem_write <= 1'b0;
                    alu_src_b <= 1'b0;
                    alu_src_a <= 1'b0;        
                    Rs1 <= Rs1IN;
                    Rs2 <= 5'b0;
                    Rd <= RdIN;
                    CSR_source <= 1'b1;
                    CSR_read_index <= csr_index;
                    CSR_write_index <= csr_index;
                    CSR_write <= 1'b1;
                    CSR_HowToWriteCSR <= 2'b00;
                end
                
                3'b010:     //CSRRS
                begin
                    alu_op <= 4'b0000;
                    pc_src <= 2'b00;
                    reg_write <= 1'b1;
                    mem_to_reg <= 2'b00;
                    branch <= 1'b0;
                    mem_write <= 1'b0;
                    alu_src_b <= 1'b0;
                    alu_src_a <= 1'b0;        
                    Rs1 <= Rs1IN;
                    Rs2 <= 5'b0;
                    Rd <= RdIN;
                    CSR_source <= 1'b1;
                    CSR_read_index <= csr_index;
                    CSR_write_index <= csr_index;
                    CSR_write <= 1'b1;
                    CSR_HowToWriteCSR <= 2'b01;
                end
                
                3'b011:     //CSRRC
                begin
                    alu_op <= 4'b0000;
                    pc_src <= 2'b00;
                    reg_write <= 1'b1;
                    mem_to_reg <= 2'b00;
                    branch <= 1'b0;
                    mem_write <= 1'b0;
                    alu_src_b <= 1'b0;
                    alu_src_a <= 1'b0;        
                    Rs1 <= Rs1IN;
                    Rs2 <= 5'b0;
                    Rd <= RdIN;
                    CSR_source <= 1'b1;
                    CSR_read_index <= csr_index;
                    CSR_write_index <= csr_index;
                    CSR_write <= 1'b1;
                    CSR_HowToWriteCSR <= 2'b10;
                end
                
                3'b000:
                begin
                    if(Rs2IN == 5'b0)       //ECALL
                    begin
                        pc_src <= 2'b01;
                        reg_write <= 1'b0;
                        mem_to_reg <= 2'b00;
                        branch <= 1'b0;
                        mem_write <= 1'b0;
                        alu_src_b <= 1'b0;
                        alu_src_a <= 1'b0;
                        Rs1 <= 5'b0;
                        Rs2 <= 5'b0;
                        Rd <= 5'b0;
                        CSR_source <= 1'b1;
                        CSR_read_index <= 12'h305;
                        CSR_write_index <= 12'h341;
                        CSR_write <= 1'b1;
                        CSR_writesource <= 2'b01;
                        CSR_HowToWriteCSR <= 2'b00;
                    end
                    else if(Rs2IN == 5'b00010)      //MRET
                    begin
                        pc_src <= 2'b01;
                        reg_write <= 1'b0;
                        mem_to_reg <= 2'b00;
                        branch <= 1'b0;
                        mem_write <= 1'b0;
                        alu_src_b <= 1'b0;
                        alu_src_a <= 1'b0;
                        Rs1 <= 5'b0;
                        Rs2 <= 5'b0;
                        Rd <= 5'b0;
                        CSR_source <= 1'b1;
                        CSR_read_index <= 12'h341;
                        CSR_write_index <= 12'h0;
                        CSR_write <= 1'b0;
                        CSR_writesource <= 2'b00;
                        CSR_HowToWriteCSR <= 2'b00;
                    end
                end
                
                endcase
            end
            
            default: alu_op <= 4'b0;
            endcase
    end
endmodule