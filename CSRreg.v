`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/21 22:16:18
// Design Name: 
// Module Name: CSRreg
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


module CSRs(
input clk,
input rst,
input write,
input [1:0] howtowrite,
input [11:0] CSR_write_addr,
input [11:0] CSR_read_addr,
input [31:0] write_data,
output reg [31:0] read_data
    );

reg [31:0] mtvec, mepc, mstatus;

always @ *
begin
    if(CSR_read_addr == 12'h305)
    begin
        read_data <= mtvec;
    end
    else if(CSR_read_addr == 12'h341)
    begin
        read_data <= mepc;
    end
    else if(CSR_read_addr == 12'h300)
    begin
        read_data <= mstatus;
    end
    else
    begin
        read_data <= 32'b0;
    end
end    

always @ (negedge clk or posedge rst)
begin
    if(rst)
    begin
        mtvec <= 32'b0;
        mepc <= 32'b0;
        mstatus <= 32'b0;
    end
    
    else if(write)
    begin
        if(CSR_write_addr == 12'h305)
        begin
            case(howtowrite)
            2'b00:mtvec <= write_data;
            2'b01:mtvec <= write_data | mtvec;
            2'b10:mtvec <= write_data & mtvec;
            endcase
        end
        else if(CSR_write_addr == 12'h341)
        begin
            case(howtowrite)
            2'b00:mepc <= write_data;
            2'b01:mepc <= write_data | mepc;
            2'b10:mepc <= write_data & mepc;
            endcase
        end
        else if(CSR_write_addr == 12'h300)
        begin
            case(howtowrite)
            2'b00:mstatus <= write_data;
            2'b01:mstatus <= write_data | mstatus;
            2'b10:mstatus <= write_data & mstatus;
            endcase
        end
    end
end
    
endmodule
