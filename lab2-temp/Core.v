`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/28 18:08:36
// Design Name: 
// Module Name: Core
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


module Core(
    input  wire        clk,
    input  wire        aresetn,
    input  wire        step,
    input  wire        debug_mode,
    // input  wire [4:0]  debug_reg_addr, // register address

    output wire [31:0] address,
    output wire [31:0] data_out,
    input  wire [31:0] data_in,
    
    input  wire [31:0] chip_debug_in,
    output wire [31:0] chip_debug_out0,
    output wire [31:0] chip_debug_out1,
    output wire [31:0] chip_debug_out2,
    output wire [31:0] chip_debug_out3
);
    wire rst, mem_write, mem_clk, cpu_clk;
    wire [31:0] inst, core_data_in, addr_out, core_data_out, pc_out, reg_out;
    reg  [31:0] clk_div;

    wire pipeline_access_memory_valid;
    wire [31:0] D_Cache_ram_addr, D_Cache_ram_data;
    wire D_cache_stall, D_Cache_ram_write, D_Cache_ram_valid;
    wire [31:0] bram_ram_addr, bram_ram_data, ram_data;
    wire bram_valid, bram_ram_write;
    
    wire [31:0] I_Cache_rom_addr;
    wire I_cache_stall, I_Cache_rom_valid;
    wire [31:0] brom_rom_addr, rom_data;
    wire brom_valid;
    assign rst = ~aresetn;

    SCPU cpu(
        .clk(cpu_clk),
        .rst(rst),
        .D_cache_stall(D_cache_stall),
        .inst(inst),
        .data_in(core_data_in),      // data from data memory
        .addr_out(addr_out),         // data memory address
        .data_out(core_data_out),    // data to data memory
        .pc_out(pc_out),             // connect to instruction memory
        .reg_out(reg_out),
        .mem_write(mem_write),
        .mem_access_valid(pipeline_access_memory_valid)
    );
    
    always @(posedge clk) begin
        if(rst) clk_div <= 0;
        else clk_div <= clk_div + 1;
    end
    assign mem_clk = ~clk_div[3]; // 50mhz
    assign cpu_clk = debug_mode ? clk_div[0] : step;
    
    Inst_Ram Inst_Ram (
        .clka(mem_clk),  // 时钟
        .wea(1'b0),   // 是否写数�??
        .addra(brom_rom_addr), // 地址输入
        .dina(32'b0),  // 写数据输�??
        .douta(rom_data)  // 读数据输�??
    );
    
    Bram Ram_Bram (
        .cpu_clk(cpu_clk),
        .mem_clk(mem_clk),
        .rst(rst),
        .cache_ram_addr(I_Cache_rom_addr),
        .cache_ram_data(I_Cache_rom_data),
        .cache_ram_write(1'b0),
        .cache_ram_valid(I_Cache_rom_valid),
        .bram_ram_write(),
        .bram_ram_addr(brom_rom_addr),
        .bram_ram_data(),
        .bram_valid(brom_valid)
    );

    Cache I_Cache (
        .clk(cpu_clk),
        .rst(rst),
        .cache_req_addr(pc_out),
        .cache_req_data(32'b0),
        .cache_req_wen(1'b0),
        .cache_req_valid(pc_access_memory_valid),
        .cache_resp_data(inst),
        .cache_resp_stall(I_cache_stall),
        .mem_req_addr(I_Cache_rom_addr),
        .mem_req_data(),
        .mem_req_wen(),
        .mem_req_valid(I_Cache_rom_valid),
        .mem_resp_data(rom_data),
        .mem_resp_valid(brom_valid)
    );
    
    // TODO: 连接Data Memory
    Ram ram_unit (
        .clka(mem_clk),  // 时钟
        .wea(bram_ram_write),   // 是否写数�??
        .addra(bram_ram_addr), // 地址输入
        .dina(bram_ram_data),  // 写数据输�??
        .douta(ram_data)  // 读数据输�??
    );
    
    Bram Ram_Bram (
        .cpu_clk(cpu_clk),
        .mem_clk(mem_clk),
        .rst(rst),
        .cache_ram_addr(D_Cache_ram_addr),
        .cache_ram_data(D_Cache_ram_data),
        .cache_ram_write(D_Cache_ram_write),
        .cache_ram_valid(D_Cache_ram_valid),
        .bram_ram_write(bram_ram_write),
        .bram_ram_addr(bram_ram_addr),
        .bram_ram_data(bram_ram_data),
        .bram_valid(bram_valid)
    );

    Cache D_Cache (
        .clk(cpu_clk),
        .rst(rst),
        .cache_req_addr(addr_out),
        .cache_req_data(core_data_out),
        .cache_req_wen(mem_write),
        .cache_req_valid(pipeline_access_memory_valid),
        .cache_resp_data(core_data_in),
        .cache_resp_stall(D_cache_stall),
        .mem_req_addr(D_Cache_ram_addr),
        .mem_req_data(D_Cache_ram_data),
        .mem_req_wen(D_Cache_ram_write),
        .mem_req_valid(D_Cache_ram_valid),
        .mem_resp_data(ram_data),
        .mem_resp_valid(bram_valid)
    );

    // TODO: 添加32个寄存器组的输出
    assign chip_debug_out0 = pc_out <<< 2;
    assign chip_debug_out1 = addr_out;
    assign chip_debug_out2 = inst;
    assign chip_debug_out3 = reg_out;
endmodule
