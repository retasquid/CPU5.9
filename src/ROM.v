module ROM(
    output reg[28:0] DataROM,
    input wire[10:0] AddrROM
);
    reg[28:0] data [2047:0];
    initial begin
        data[0] = 29'h01400008;
        data[1] = 29'h03440004;
        data[2] = 29'h15040002;
        data[3] = 29'h15044000;
        data[4] = 29'h18004000;
        data[5] = 29'h03000001;
        data[6] = 29'h15000002;
    end
    
    // Lecture synchrone ou asynchrone de la ROM
    always @(*) begin
        DataROM = data[AddrROM];
    end
endmodule
