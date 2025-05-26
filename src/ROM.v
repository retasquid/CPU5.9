module ROM(
    output reg[28:0] DataROM,
    input wire[10:0] AddrROM
);
    reg[28:0] data [2047:0];
    initial begin
        data[0] = 29'h01f040ff;
        data[1] = 29'h01000020;
        data[2] = 29'h15000005;
        data[3] = 29'h01000045;
        data[4] = 29'h15004000;
        data[5] = 29'h16e00000;
        data[6] = 29'h03ee0005;
        data[7] = 29'h140ef000;
        data[8] = 29'h03ff0001;
        data[9] = 29'h1200000c;
        data[10] = 29'h18004000;
        data[11] = 29'h15000002;
        data[12] = 29'h18004000;
        data[13] = 29'h0f000100;
        data[14] = 29'h15000004;
        data[15] = 29'h0b00feff;
        data[16] = 29'h15000004;
        data[17] = 29'h18000009;
        data[18] = 29'h0b000001;
        data[19] = 29'h12010015;
        data[20] = 29'h12000011;
        data[21] = 29'h18000004;
        data[22] = 29'h15004000;
        data[23] = 29'h05ff0001;
        data[24] = 29'h13e0f000;
        data[25] = 29'h170e0000;
    end
    
    // Lecture synchrone ou asynchrone de la ROM
    always @(*) begin
        DataROM = data[AddrROM];
    end
endmodule
