// 状态机设计：UART串口数据发送 - 24MHz频率，4800波特率
// 状态转换： 等待发送使能信号 → 填充发送寄存器 → 发送寄存器右移位进行发送 → 等待发送使能信号
`timescale 1ns/10ps
module UART_TX(
            clk,
            res,
            data_in,
            en_data_in,
            TX,
            rdy
);
input       clk;
input       res;
input[7:0]  data_in;                //准备发送的数据
input       en_data_in;             //发送使能
output      TX;
output      rdy;                    //空闲标志位，0表示空闲

reg[3:0]    state;                  //主状态机寄存器
reg[9:0]    send_buffer;            //发送缓冲区
assign      TX = send_buffer[0];    //缓冲区连接TX
reg[12:0]   con;                    //用于计算波特率
reg[9:0]    send_flg;               //用于判断右移是否结束
reg         rdy;                    //串口空闲标志位
always @(posedge clk or negedge res) begin
    if (~res)begin
        state <= 0; send_buffer <= 1; con <= 0; send_flg <= 10'b10_0000_0000; rdy = 0;
    end
    else begin
        case(state)
            0://等待使能信号
            begin
                if(en_data_in) begin
                    send_buffer <= {1'b1, data_in, 1'b0};  //{结束位，数据，起始位}
                    send_flg    <= 10'b10_0000_0000;
                    state       <= 1; 
                    rdy         <= 1;
                end
            end
            1://串口发送，寄存器右移发送数据
            begin
                if(con == 4999)begin
                    con <= 0;
                end
                else begin
                    con <= con+1;
                end
                if (con == 4999) begin  //此处不能把条件设置为con==0，
                //if (con == 0) begin   //因为con的初始值就是0，会导致输出的第一位只能持续一个时钟周期
                    send_buffer[8:0] <= send_buffer[9:1];  
                    send_flg[8:0]    <= send_flg[9:1];
                end
                if(send_flg[0] == 1)begin
                    rdy   <= 0;
                    state <= 0;
                end
            end
            default:
            begin
                state <= 0;
            end
        endcase
    end
end
endmodule        
/*
module UART_TX_tb;
reg         clk, res, en_data_in;
reg[7:0]    data_in;
wire        TX, rdy;
UART_TX UART_TX(
            .clk(clk),
            .res(res),
            .data_in(data_in),
            .en_data_in(en_data_in),
            .TX(TX),
            .rdy(rdy)
);
initial begin
    clk <= 0; res <= 0; data_in <= 8'h53; en_data_in <= 0;
    #17       res <= 1;
    #30       en_data_in <= 1;
    #10       en_data_in <= 0;
    #550000   $stop;
end
always  #5 clk <= ~clk;

initial begin
    $dumpfile("UART_TX_tb.vcd");
    $dumpvars(clk, rdy, TX, en_data_in, data_in);
end
endmodule*/