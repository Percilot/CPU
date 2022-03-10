`timescale 1ns / 1ps

module ImmGen(
input [31:0] inst,
output reg [31:0] imm_out
    );
    
always @ *
begin
    
    case(inst[6:0])
        7'b0010011:
        begin
            imm_out={{20{inst[31]}},inst[31:20]};
        end
        
        7'b0000011:
        begin
            imm_out={{20{inst[31]}},inst[31:20]};
        end
        
        7'b0100011:
        begin
            imm_out={{20{inst[31]}},inst[31:25],inst[11:7]};
        end
        
        7'b1100011:
        begin
            imm_out={{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
        end
        
        7'b1101111:
        begin
            imm_out={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
        end
        
        7'b0110111:
        begin
            imm_out={inst[31:12],12'b0};
        end
        
        7'b0010011:
        begin
            imm_out={{20{inst[31]}},inst[31:20]};
        end
        
        7'b0010111:
        begin
            imm_out={inst[31:12],12'b0};
        end
        
        7'b1100111:
        begin
            imm_out={{20{inst[31]}},inst[31:20]};
        end
    endcase    
end          
endmodule
