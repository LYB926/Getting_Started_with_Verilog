//二进制补码转换
`timescale 1ns/10ps
module comp_conv(
            a,
            a_comp
);
input[7:0]  a;
output[7:0] a_comp;

wire[6:0]   tmp;     //按位取反的幅度位
wire[7:0]   y;       //负数的补码

assign      tmp = ~a[6:0];
assign      y[6:0] = tmp+1;  //按位取反加一
assign      y[7] = a[7];     //符号位不变

assign      a_comp = a[7]?y:a;
endmodule

module comp_conv_tb;
reg[7:0]     aa;
wire[7:0]    ac;
comp_conv comp_conv(
            .a(aa),
            .a_comp(ac)
);
initial begin
            aa<=0;
    #3000   $stop;
end
always #10 aa <= aa+1;

initial begin
    $dumpfile("comp_conv_tb.vcd");
    $dumpvars;
end

endmodule