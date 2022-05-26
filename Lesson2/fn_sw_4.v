//四选一逻辑的实现 -- case语句
`timescale 1ns/10ps
module fn_sw_4(
            a,
            b,
            sel,
            y
);
input       a;
input       b;
input[1:0]  sel;
output      y;

reg y;      //always 内部赋值的变量需要类型为reg
always @(a or b or sel) begin
    case (sel)
        2'b00:begin y<=a&b; end
        2'b01:begin y<=a|b; end
        2'b10:begin y<=a^b; end
        2'b11:begin y<=~(a^b); end 
    endcase
end
endmodule

module fn_sw_4_tb;
reg[3:0]    absel;
wire        yy;
fn_sw_4 fn_sw_4(
        .a(absel[0]),
        .b(absel[1]),
        .sel(absel[3:2]),
        .y(yy)
);

initial begin
            absel<=0;
    #200    $stop;
end
always #10 absel<=absel+1;      //使用数组进行遍历

initial begin
    $dumpfile("fn_sw_4_tb.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end
endmodule