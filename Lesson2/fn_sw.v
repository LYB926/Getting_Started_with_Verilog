//二选一逻辑的实现
`timescale 1ns/10ps
module fn_sw(
        a,
        b,
        sel,
        y
);
input   a;
input   b;
input   sel;
output  y;
//实现1：三元运算符实现二选一， ^为异或
//assign y=sel?(a^b):(a&b); 
//实现2：if-else
reg y;      //always 内部赋值的变量需要类型为reg
always @(a or b or sel) begin
    if (sel == 1)begin
        y<=a^b;
    end
    else begin
        y<=a&b;
    end
end
endmodule

module fn_sw_tb;
reg     aa,bb,ss;
wire    yy;
fn_sw fn_sw(
        .a(aa),
        .b(bb),
        .sel(ss),
        .y(yy)
);

initial begin
        aa<=0;bb<=0;ss<=0;
    #10 aa<=0;bb<=0;ss<=1;
    #10 aa<=0;bb<=1;ss<=0;
    #10 aa<=0;bb<=1;ss<=1;
    #10 aa<=1;bb<=0;ss<=0;
    #10 aa<=1;bb<=0;ss<=1;
    #10 aa<=1;bb<=1;ss<=1;
    #10 $stop;
end

initial begin
    $dumpfile("fn_sw_tb.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end
endmodule