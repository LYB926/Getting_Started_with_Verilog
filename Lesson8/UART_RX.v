// 状态机设计：UART串口数据接收 - 24MHz频率，4800波特率
// 状态转换： 等空闲 → 等起始位 → 读取 → 等起始位
`timescale 1ns/10ps
module UART_RX(
                clk,
                res,
                RX,
                data_out,
                en_data_out
);
input           clk;
input           res;
input           RX;
output[7:0]     data_out;
output          en_data_out;

reg[7:0]        state;      //主状态机
reg[12:0]       con;        //用于计算比特宽度
reg[3:0]        con_bits;   //用于计算比特数
reg             RX_delay;   //RX的延时
reg[7:0]        data_out;
reg             en_data_out;
always @(posedge clk or negedge res) begin
    if (~res)begin
        state <= 0; con <= 0; con_bits <= 0; 
        RX_delay <= 0; data_out <= 0; en_data_out <= 0;
    end
    else begin
        RX_delay <= RX;
        case(state)
            0://等空闲
            begin
                if (con==4999)begin
                    con <= 0;
                end
                else begin
                    con <= con+1;
                end
                if (con==0)begin
                    if (RX)begin
                        con_bits <= con_bits+1;
                    end
                    else begin
                        con_bits <= 0;
                    end
                end
                if (con_bits==12)begin
                    state <= 1;
                end
            end
            1://等起始位
            begin
                en_data_out <= 0;
                if(~RX&RX_delay)begin
                    state <= 2;
                end
            end
            2://收最低位b0
            begin
                if (con==7499)begin
                    con <= 0;
                    data_out[0] <= RX;
                    state <= 3;
                end
                else begin
                    con <= con+1;
                end
            end
            3://收次低位b1
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[1] <= RX;
                    state <= 4;
                end
                else begin
                    con <= con+1;
                end
            end
            4://收位b2
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[2] <= RX;
                    state <= 5;
                end
                else begin
                    con <= con+1;
                end
            end
            5:
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[3] <= RX;
                    state <= 6;
                end
                else begin
                    con <= con+1;
                end
            end
            6:
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[4] <= RX;
                    state <= 7;
                end
                else begin
                    con <= con+1;
                end
            end
            7:
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[5] <= RX;
                    state <= 8;
                end
                else begin
                    con <= con+1;
                end
            end
            8:
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[6] <= RX;
                    state <= 9;
                end
                else begin
                    con <= con+1;
                end
            end
            9:
            begin        
                if (con==4999)begin
                    con <= 0;
                    data_out[7] <= RX;
                    state <= 10;
                end
                else begin
                    con <= con+1;
                end
            end
            10://产生使能脉冲
            begin
                en_data_out <= 1;
                state <= 1;
            end
            default:
            begin
                state <= 0; con <= 0; con_bits <= 0; en_data_out <= 0;
            end
        endcase
    end
end
endmodule

module UART_RX_tb;
reg         clk;
reg         res;
wire        RX;
wire[7:0]   data_out;
wire        en_data_out;
reg[25:0]   RX_send_cache;  //装有串口字节的发送数据
assign      RX = RX_send_cache[0];
reg[12:0]   con;
UART_RX UART_RX(
            .clk(clk),
            .res(res),
            .RX(RX),
            .data_out(data_out),
            .en_data_out(en_data_out)
);
initial begin
    clk <= 0; res <= 0; RX_send_cache <= {1'b1, 8'hA1, 1'b0, 16'hffff}; con <= 0;
    #17       res <= 1;
    #4000000  $stop;
end
always #5 clk <= ~clk;
always @(posedge clk) begin
    if (con == 5000-1)begin
        con <= 0;
    end
    else begin
        con <= con+1;
    end
    if (con == 0)begin
        RX_send_cache[24:0] <= RX_send_cache[25:1]; //非阻塞赋值为并行处理
        RX_send_cache[25] <= RX_send_cache[0]; 
    end
end
 
initial begin
    $dumpfile("UART_RX_tb.vcd");
    $dumpvars(clk, RX, data_out, en_data_out);
end
endmodule