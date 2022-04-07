`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/29 00:44:25
// Design Name: 
// Module Name: D_cache
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


module Cache
(
input clk, 	//Pipeline 	Input 	1 	时钟信号
input rst, 	//Pipeline 	Input 	1 	复位信号
input [31:0] cache_req_addr, 	//Pipeline 	Input 	32 	流水线发出的�?/写地�?
input [31:0] cache_req_data, 	//Pipeline 	Input 	32 	写入数据
input cache_req_wen, 	//Pipeline 	Input 	1 	cache写使�?
input cache_req_valid, 	//Pipeline 	Input 	1 	发往cache的读写请求的有效�?
output reg [31:0] cache_resp_data, 	//Pipeline 	Output 	32 	向流水线提交的数据内�?
output reg cache_resp_stall, 	//Pipeline 	Output 	1 	流水线是否需要继续Stall
output reg [31:0] mem_req_addr, 	//Memory 	Output 	32 	发往Memory的读/写地�?
output reg [31:0] mem_req_data, 	//Memory 	Output 	32 	发往Memory写入数据
output reg mem_req_wen, 	//Memory 	Output 	1 	Memory写使�?
output reg mem_req_valid, 	//Memory 	Output 	1 	发往Memory的读写请求的有效�?
input [31:0] mem_resp_data, 	//Memory 	Input 	32 	内存返回数据
input mem_resp_valid, 	//Memory 	Input 	1 	Memory数据查询完成
output [31:0] cache_state_output
);

integer l;
//  Valid   Dirty   Target  Data
//  58      57      56-32   31-0   
reg [58:0] cache [0:127];

//000       S_IDLE
//001       S_BACK
//010       S_BACK_WAIT
//011       S_FILL
//100       S_FILL_WAIT
reg [2:0] cache_state;
reg [31:0] mem_write_back_addr;
reg [31:0] mem_write_back_data;
reg [31:0] cache_write_back_addr;
reg [31:0] cache_write_back_data;
reg cache_opeation;

always @ (posedge rst or posedge clk)
begin

    if(rst)
    begin
        cache_state <= 3'b0;
        mem_write_back_addr <= 32'b0;
        mem_write_back_data <= 32'b0;
        cache_write_back_addr <= 32'b0;
        cache_write_back_data <= 32'b0;
        cache_resp_data <= 32'b0;
        cache_resp_stall <= 1'b0;
        mem_req_addr <= 32'b0;
        mem_req_data <= 32'b0;
        mem_req_wen <= 1'b0;
        mem_req_valid <= 1'b0;
        cache_opeation <= 1'b0;
        for(l = 0; l < 128; l = l + 1)
            cache[l] <= 59'b0;
    end

    else
    begin
        if(cache_state == 3'b000 && cache_req_valid)
        begin
            if(cache_req_wen)
            begin
                if(cache[cache_req_addr[6:0]][56:32] == cache_req_addr[31:7] || !cache[cache_req_addr[6:0]][58])  //cache hit
                begin
                    cache_state <= 3'b000;
                    cache[cache_req_addr[6:0]] <= {1'b1, 1'b1, cache_req_addr[31:7], cache_req_data};
                    cache_resp_data <= 32'b0;
                    cache_resp_stall <= 1'b0;
                    mem_req_addr <= 32'b0;
                    mem_req_data <= 1'b0;
                    mem_req_wen <= 1'b0;
                    mem_req_valid <= 1'b0;
                end

                else        //cache miss
                begin
                    if(cache[cache_req_addr[6:0]][57])      //dirty
                    begin
                        cache_state <= 3'b001;
                        cache_resp_data <= 32'b0;
                        cache_resp_stall <= 32'b1;
                        mem_req_addr <= 32'b0;
                        mem_req_data <= 32'b0;
                        mem_req_valid <= 1'b0;
                        mem_req_wen <= 1'b0;
                        mem_write_back_data <= cache[cache_req_addr[6:0]][31:0];
                        mem_write_back_addr <= {cache[cache_req_addr[6:0]][56:32], cache_req_addr[6:0]};
                        cache_write_back_data <= cache_req_data;
                        cache_write_back_addr <= cache_req_addr;
                        cache_opeation <= 1'b1;
                    end

                    else
                    begin
                        cache_state <= 3'b000;
                        cache[cache_req_addr[6:0]] <= {1'b1, 1'b1, cache_req_addr[31:7], cache_req_data};
                        cache_resp_stall <= 1'b0;
                        cache_resp_data <= 32'b0;
                        mem_req_addr <= 32'b0;
                        mem_req_data <= 32'b0;
                        mem_req_valid <= 1'b0;
                        mem_req_wen <= 1'b0;
                    end
                end
            end

            else
            begin
                if(cache[cache_req_addr[6:0]][56:32] == cache_req_addr[31:7] && cache[cache_req_addr[6:0]][58])  //cache hit
                begin
                    cache_state <= 3'b000;
                    cache_resp_data <= cache[cache_req_addr[6:0]][31:0];
                    cache_resp_stall <= 1'b0;
                    mem_req_addr <= 32'b0;
                    mem_req_data <= 1'b0;
                    mem_req_wen <= 1'b0;
                    mem_req_valid <= 1'b0;
                end

                else
                begin
                    if(cache[cache_req_addr[6:0]][57])          //miss & dirty
                    begin
                        cache_state <= 3'b001;
                        cache_resp_stall <= 1'b1;
                        mem_req_addr <= 32'b0;
                        mem_req_data <= 1'b0;
                        mem_req_wen <= 1'b0;
                        mem_req_valid <= 1'b0;
                        cache_opeation <= 1'b0;
                        mem_write_back_data <= cache[cache_req_addr[6:0]][31:0];
                        mem_write_back_addr <= {cache[cache_req_addr[6:0]][56:32], cache_req_addr[6:0]};
                        cache_write_back_data <= cache_req_data;
                        cache_write_back_addr <= cache_req_addr;
                    end

                    else                                        //miss but clean
                    begin
                        cache_state <= 3'b011;
                        cache_resp_stall <= 1'b1;
                        mem_req_addr <= 32'b0;
                        mem_req_data <= 1'b0;
                        mem_req_wen <= 1'b0;
                        mem_req_valid <= 1'b0;
                        cache_opeation <= 1'b0;
                        mem_write_back_data <= 32'b0;
                        mem_write_back_addr <= cache_req_addr;
                        cache_write_back_data <= 32'b0;
                        cache_write_back_addr <= cache_req_addr;
                    end
                end
            end
        end

        else if(cache_state == 3'b000 && !cache_req_valid)
        begin
            cache_state <= 3'b000;
            cache_resp_data <= 32'b0;
            cache_resp_stall <= 1'b0;
            mem_req_addr <= 32'b0;
            mem_req_data <= 32'b0;
            mem_req_wen <= 1'b0;
            mem_req_valid <= 1'b0;
        end

        else if(cache_state == 3'b001)
        begin
            cache_state <= 3'b010;
            cache_resp_data <= 32'b0;
            cache_resp_stall <= 1'b1;
            mem_req_addr <= mem_write_back_addr;
            mem_req_data <= mem_write_back_data;
            mem_req_wen <= 1'b1;
            mem_req_valid <= 1'b1;
        end

        else if(cache_state == 3'b010)
        begin
            cache_resp_data <= 32'b0;
            cache_resp_stall <= 1'b1;
            mem_req_addr <= 32'b0;
            mem_req_data <= 32'b0;
            mem_req_wen <= 1'b0;
            mem_req_valid <= 1'b0;
            if(mem_resp_valid)
                cache_state <= 3'b011;
            else
                cache_state <= 3'b010;
        end

        else if(cache_state == 3'b011)
        begin
            if(cache_opeation)
            begin
                cache_resp_data <= 32'b0;
                cache_resp_stall <= 1'b0;
                mem_req_addr <= 32'b0;
                mem_req_data <= 32'b0;
                mem_req_wen <= 1'b0;
                mem_req_valid <= 1'b0;
                cache_state <= 3'b000;
                cache[cache_write_back_addr[6:0]] <= {1'b1, 1'b1, cache_write_back_addr[31:7], cache_write_back_data};
            end

            else
            begin
                cache_resp_data <= 32'b0;
                cache_resp_stall <= 1'b1;
                mem_req_addr <= cache_write_back_addr;
                mem_req_data <= 32'b0;
                mem_req_wen <= 1'b0;
                mem_req_valid <= 1'b1;
                cache_state <= 3'b100;
            end
        end

        else if(cache_state == 3'b100)
        begin
            if(!mem_resp_valid)
            begin
                cache_resp_data <= 32'b0;
                cache_resp_stall <= 1'b1;
                mem_req_addr <= 32'b0;
                mem_req_data <= 32'b0;
                mem_req_wen <= 1'b0;
                mem_req_valid <= 1'b0;
                cache_state <= 3'b100;
            end

            else
            begin
                cache_resp_data <= mem_resp_data;
                cache[cache_write_back_addr[6:0]] <= {1'b1, 1'b0, cache_write_back_addr[31:7], mem_resp_data};
                cache_resp_stall <= 1'b0;
                mem_req_addr <= 32'b0;
                mem_req_data <= 32'b0;
                mem_req_wen <= 1'b0;
                mem_req_valid <= 1'b0;
                cache_state <= 3'b000;
            end
        end

        /*else if(cache_state == 3'b101)
        begin
            cache_resp_data <= 32'b0;
            cache_resp_stall <= 1'b0;
            mem_req_addr <= 32'b0;
            mem_req_data <= 32'b0;
            mem_req_wen <= 1'b0;
            mem_req_valid <= 1'b0;
            cache_state <= 3'b000;
        end*/
    end

end
assign cache_state_output = {29'b0, cache_state};
endmodule
