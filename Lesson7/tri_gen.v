//最简单的状态机：三角波发生器 Triangle wave generator
`timescale 1ns/10ps
module tri_gen(clk, res, d_out);
input           clk;
input           res;
output[8:0]     d_out;
reg[1:0]        state;  //主状态机的寄存器
reg[8:0]        d_out;
reg[7:0]        con;    //计数器用于记录平顶周期个数

always @(posedge clk or negedge res) begin
    if(~res) begin
        state <= 0; d_out <= 0; con <= 0;
    end
    else begin
        case(state)
        0:                      //上升
        begin               
            d_out <= d_out+1;
            if (d_out==299)begin
                state <= 2;
            end
        end   
        1:                      //下降 
        begin 
            d_out <= d_out-1;
            if (d_out == 1)begin
                state <= 3;
            end
            end
        2:                      //上平顶
        begin
            con <= con+1;
            if (con == 200) begin
                state <= 1;
                con   <= 0;
            end 
            else begin
                con   <= con+1;
            end
        end 
        3:                      //下平顶
        begin
            con <= con+1;
            if (con == 200) begin
                state <= 0;
                con   <= 0;
            end 
            else begin
                con <= con+1;
            end
        end 
        endcase
    end   
end
endmodule

module tri_gen_tb;
reg         clk;
reg         res;
wire[8:0]   d;
tri_gen tri_gen(.clk(clk), .res(res), .d_out(d));

initial begin
    clk <= 0; res <= 0;
    #17 res <= 1;
    #40000 $stop;
end
always #5 clk <= ~clk;

initial begin
    $dumpfile("tri_gen_tb.vcd");
    $dumpvars;
end
endmodule