module CLK_Div(
    output reg clk_out,
    output wire clk_OSC
);
    reg[5:0] cnt;
    wire OSCclk;

    OSC_CLK clkOSC(
        .oscout(OSCclk) //output oscout
    );

    Gowin_rPLL PLL(
        .clkout(clk_OSC), //output clkout
        .clkoutd(clk_out), //output clkoutd
        .clkin(OSCclk) //input clkin
    );
endmodule