/* 
 * 串口指令处理模块，可以和先前两课中的
 * 串口发送、接收模块结合组成一个串口指令处理器。
 * 指令由三字节组成，第一字节为指令CMD，二三字节为操作数A、B。
 * 指令集如下：
 * CMD     Operation
 * 8'H0A      A+B
 * 8'H0B      A-B
 * 8'H0C      A&B
 * 8'H0D      A|B
 * 状态机：接收指令和数据 → 处理指令和数据 → 返回结果 → 接收指令和数据
 */

module cmd_pro(
                clk, 
                res, 
                din_pro, 
                en_din_pro, 
                dout_pro, 
                en_dout_pro,
                rdy
);
input           clk;
input           res;
input[7:0]      din_pro;        //指令和数据输入端口
input           en_din_pro;     //输入使能
output[7:0]     dout_pro;       //指令执行结果
output          en_dout_pro;    //指令输出使能
output          rdy;            //串口发送空闲

parameter       addx = 8'h0a;
parameter       subx = 8'h0b;
parameter       andx = 8'h0c;
parameter       orx  = 8'h0d;
reg[2:0]        state;          //状态寄存器
reg[7:0]        cmd, A, B;      //输入指令和操作数的寄存器
reg[7:0]        dout_pro;
reg             en_dout_pro;
always @(posedge clk or negedge res) begin
    if(~res)begin
        state <= 0; cmd <= 0; A <= 0; B <= 0; dout_pro <= 0; 
        en_dout_pro <= 0;
    end
    else begin
        case(state)
        0://接收CMD
        begin
            en_dout_pro <= 0;
            if(en_din_pro)begin
                cmd <= din_pro;
                state <= 1;
            end
        end
        1://接收A
        begin
            if (en_din_pro)begin
                A <= din_pro;
                state <= 2;
            end
        end
        2://接收B
        begin
            if (en_din_pro)begin
                B <= din_pro;
                state <= 3;
            end
        end
        3://进行运算
        begin
            case(cmd)
            addx: begin dout_pro <= A+B; end 
            subx: begin dout_pro <= A-B; end
            andx: begin dout_pro <= A&B; end
            orx:  begin dout_pro <= A|B; end
            endcase
            state <= 4;
        end
        4://输出执行结果
        begin
            if(~rdy)begin
                en_dout_pro <= 1;
                state <= 0;
            end
        end
        default:
        begin
            state <= 0;
            en_dout_pro <= 0;
        end
        endcase
    end
end
endmodule