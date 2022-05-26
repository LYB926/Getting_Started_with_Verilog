// TestBench of inv
module inv_tb;
reg  aa;
wire yy;
inv inv( 
    .A(aa),     
    .Y(yy)
);

initial begin  //按时间定义各个变量
        aa<=0;
    #10 aa<=1;
    #10 aa<=0;
    #10 aa<=1;
    #10 $stop;

end
initial begin
    $dumpfile("inv_tb.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end
endmodule