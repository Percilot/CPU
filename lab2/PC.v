`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/10 08:25:43
// Design Name: 
// Module Name: PC
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


module PC(
input clk,
input rst,
input [31:0] inst_in,
input D_cache_stall,
input I_cache_stall,
input PC_lock,
input write_PC,
input [31:0] new_PC,
output [31:0] PC_out,
output ControlChange,
output pc_access_mem_valid
    );

reg [31:0] PC;
reg valid;

always @ (posedge clk or posedge rst)
begin
        if(rst)
        begin
            PC <= 32'b0;
            valid <= 1'b1;
        end
        else
        begin
            if(inst_in == 32'b0)
            begin
                PC <= PC;
                valid <= 1'b0;
            end
            else if(D_cache_stall && I_cache_stall)
            begin
                PC <= PC;
                valid <= 1'b0;
            end
            
            else if(D_cache_stall && (!I_cache_stall))
            begin
                if(inst_in != 32'b0)
                begin
                    if(write_PC)
                    begin
                        PC <= new_PC;
                        valid <= 1'b1;
                    end
                    else
                    begin
                        PC <= PC + 32'h4;
                        valid <= 1'b1;
                    end
                 end
            end
            
            else if(PC_lock)
            begin
                PC <= PC;
                valid <= 1'b1;
            end
            else if(write_PC)
            begin
                PC <= new_PC;
                valid <= 1'b1;
            end
            else
            begin
                PC <= PC + 32'h4;
                valid <= 1'b1;
            end
         end
end    

assign PC_out = PC;
assign ControlChange = write_PC;
assign pc_access_mem_valid = valid;
endmodule
