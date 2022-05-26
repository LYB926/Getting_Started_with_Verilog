//与非门
`timescale 1ns/10ps
module nand_gate(
    A,
    B,
    Y
);
input   A;
input   B;
output  Y;
assign  Y = ~(A&B);
endmodule

module nand_gate_tb;
reg  aa;
reg  bb;
wire yy;
nand_gate nand_gate(
    .A(aa),
    .B(bb),
    .Y(yy)
    );
initial begin
        aa<=0;bb<=0; //reg型变量用<=赋值
    #10 aa<=0;bb<=1;
    #10 aa<=1;bb<=0;
    #10 aa<=1;bb<=1;
    #10 $stop;
end

initial begin
    $dumpfile("nand_gate_tb.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end
endmodule