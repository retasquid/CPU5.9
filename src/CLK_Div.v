module CLK_Div(
    output reg clk_out,
    output wire clk_OSC
);
    reg[24:0] cnt;

    OSC_CLK clkOSC(
        .oscout(clk_OSC) //output oscout
    );
    
    always@(posedge clk_OSC) begin
        if(cnt==25'd6553) begin //d32767999
            cnt<=25'b0;
            clk_out<=~clk_out;
        end else begin
             cnt<=cnt+21'b1;
        end
    end
endmodule