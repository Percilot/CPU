`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 15:11:21
// Design Name: 
// Module Name: SCPU
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


module SCPU(
    input         clk,
    input         rst,
    input         D_cache_stall,
    input  [31:0] inst,
    input  [31:0] data_in,  // data from data memory
    output [31:0] addr_out, // data memory address
    output [31:0] data_out, // data to data memory
    output [31:0] pc_out,   // connect to instruction memory
    output [31:0] reg_out,
    output        mem_write,
    output        mem_access_valid
    );

    Datapath datapath (
        .clk(clk),
        .rst(rst),
        .D_cache_stall(D_cache_stall),
        .inst_in(inst),
        .data_in(data_in),
        .addr_out(addr_out),
        .data_out(data_out),
        .pc_out(pc_out),
        .reg_out(reg_out),
        .mem_write(mem_write),
        .output_mem_access_out(mem_access_valid)
    );
    
endmodule
