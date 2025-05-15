module rand (
    input [31:0] in,
    output [31:0] out
);

    wire [31:0] mix1 = in ^ (in << 13);
    wire [31:0] mix2 = mix1 ^ (mix1 >> 17);
    assign out = mix2 ^ (mix2 << 5);

endmodule
