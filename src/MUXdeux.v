module MUXdeux(
    output wire[15:0] OUT,
    input wire[15:0] IN0,
    input wire[15:0] IN1,
    input wire SEL
);

assign OUT=SEL?IN1:IN0;
endmodule
