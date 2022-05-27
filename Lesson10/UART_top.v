//串口指令处理器顶层封装模块
`timescale 1ns/10ps
module UART_top(
            clk,
            res,
            RX,
            TX
);
input       clk;
input       res;
input       RX;
output      TX;

wire[7:0]   din_pro;
wire        en_din_pro;
wire[7:0]   dout_pro;
wire        en_dout_pro;
wire        rdy;
UART_RX UART_RX(
            .clk(clk),
            .res(res),
            .RX(RX),
            .data_out(din_pro),
            .en_data_out(en_din_pro)
);
UART_TX UART_TX(
            .clk(clk),
            .res(res),
            .TX(TX),
            .data_in(dout_pro),
            .en_data_in(en_dout_pro),
            .rdy(rdy)
);
cmd_pro cmd_pro(
            .clk(clk), 
            .res(res), 
            .din_pro(din_pro), 
            .en_din_pro(en_din_pro), 
            .dout_pro(dout_pro), 
            .en_dout_pro(en_dout_pro),
            .rdy(rdy)
);
endmodule

// TESTBENCH
module UART_top_tb;
reg         clk;
reg         res;
wire        RX;
wire        TX;

reg[45:0]   RX_send;
assign      RX = RX_send[0];
reg[12:0]   con;
UART_top UART_top(
            clk,
            res,
            RX,
            TX
);
initial begin
    clk <= 0; res <= 0; 
    RX_send <= {1'b1, 8'h0A, 1'b0, 1'b1, 8'hA0, 1'b0, 1'b1, 8'h0a, 1'b0, 16'hffff}; con <= 0;
    #17       res <= 1;
    #3000000  $stop;
end
always #5 clk <= ~clk;
always @(posedge clk) begin
    if (con == 5000-1)begin
        con <= 0;
    end
    else begin
        con <= con+1;
    end
    if (con == 0)begin
        RX_send[44:0] <= RX_send[45:1]; //非阻塞赋值为并行处理
        RX_send[45] <= RX_send[0]; 
    end
end

initial begin
    $dumpfile("UART_top_tb.vcd");
    $dumpvars(clk, res, RX, TX);
end

endmodule