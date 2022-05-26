//计数器    组合逻辑+触发器=时序逻辑
`timescale 1ns/10ps
module con(clk, res, y);
input        clk;
input        res;
output[7:0]  y;

reg[7:0]     y;
wire[7:0]    sum;   //+1运算的结果

assign       sum=y+1;
always @(posedge clk or negedge res) begin
    if(~res) begin
        y<=0;
    end
    else begin
        y<=sum;
    end
end
endmodule

module con_tb;
reg         clk, res;
wire[7:0]   y;
con con(
    .clk(clk),
    .res(res),
    .y(y)
);
initial begin
            clk <= 0; res <= 0;
    #20     res<=1;
    #6000   $stop;
end
always #5 clk=~clk;

initial begin
    $dumpfile("conv_tb.vcd");
    $dumpvars;
end
endmodule