//四级伪随机码发生器
`timescale 1ns/10ps
module m_gen(clk, res, y);
input   clk;
input   res;
output  y;

reg[3:0]    d;
assign      y=d[0];
always @(posedge clk or negedge res) begin
    if (~res) begin
        d<=4'b1111;
    end
    else begin
        d[2:0] <= d[3:1];    //右移一位
        d[3] <= d[3]+d[0];   //模2加法
    end
end
endmodule

module m_gen_tb();
reg     clk, res;
wire    y;
m_gen m_gen(.clk(clk), .res(res), .y(y));
initial begin
            clk <= 0; res <= 0;
    #10     res <= 1;
    #300    $stop;
end
always #5 clk=~clk;

initial begin
    $dumpfile("m_gen_tb.vcd");
    $dumpvars;
end
endmodule