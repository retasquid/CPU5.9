module MUX4(
    output wire[15:0] OUT,
    input wire[15:0] IN0,
    input wire[15:0] IN1,
    input wire[15:0] IN2,
    input wire[15:0] IN3,
    input wire[1:0] SEL
);
    assign OUT = (SEL == 2'b00) ? IN0 :
                 (SEL == 2'b01) ? IN1 :
                ((SEL == 2'b10) ? IN2 : IN3);
endmodule