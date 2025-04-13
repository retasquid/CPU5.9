module OR2(
    output wire OUT,
    input wire IN0,
    input wire IN1
);
assign OUT = IN0|IN1;
endmodule