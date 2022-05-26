//七段数码管译码器
`timescale 1ns/10ps
module seg_dec(num, a_g);
input[3:0]      num;
output[6:0]     a_g;  //a_g -> [abcdefg]
reg[6:0]        a_g;
always @(num) begin
    case(num)
        4'd0:begin a_g<=7'b1111110; end
        4'd1:begin a_g<=7'b0110000; end
        4'd2:begin a_g<=7'b1101101; end
        4'd3:begin a_g<=7'b1111001; end
        4'd4:begin a_g<=7'b0110011; end
        4'd5:begin a_g<=7'b1011011; end
        4'd6:begin a_g<=7'b1011111; end
        4'd7:begin a_g<=7'b1110000; end
        4'd8:begin a_g<=7'b1111111; end
        4'd9:begin a_g<=7'b1111011; end
        default:
             begin a_g<=7'b0000001; end
    endcase
end
endmodule

module seg_dec_tb;
reg[3:0]    n;
wire[6:0]   ag;
seg_dec seg_dec(
    .num(n),
    .a_g(ag)
);
initial begin
            n<=4'b0000;
    #120    $stop;
end
always #10 n<=n+1;
initial begin
    $dumpfile("seg_dec_tb.vcd");
    $dumpvars;
end
endmodule