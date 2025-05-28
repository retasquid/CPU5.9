module ROM(
    output reg[28:0] DataROM,
    input wire[10:0] AddrROM
);
    reg[28:0] data [2047:0];
    initial begin
        data[0] = 29'h01f040ff;
        data[1] = 29'h01000001;
        data[2] = 29'h15000008;
        data[3] = 29'h0100c5e8;
        data[4] = 29'h15000007;
        data[5] = 29'h010006ab;
        data[6] = 29'h15004000;
        data[7] = 29'h16e00000;
        data[8] = 29'h03ee0005;
        data[9] = 29'h140ef000;
        data[10] = 29'h03ff0001;
        data[11] = 29'h12000025;
        data[12] = 29'h18004000;
        data[13] = 29'h0b10f000;
        data[14] = 29'h0911000c;
        data[15] = 29'h03110130;
        data[16] = 29'h15010006;
        data[17] = 29'h01100000;
        data[18] = 29'h15010006;
        data[19] = 29'h0b100f00;
        data[20] = 29'h09110008;
        data[21] = 29'h03110130;
        data[22] = 29'h15010006;
        data[23] = 29'h01100000;
        data[24] = 29'h15010006;
        data[25] = 29'h0b1000f0;
        data[26] = 29'h09110004;
        data[27] = 29'h03110130;
        data[28] = 29'h15010006;
        data[29] = 29'h01100000;
        data[30] = 29'h15010006;
        data[31] = 29'h0b10000f;
        data[32] = 29'h03110130;
        data[33] = 29'h15010006;
        data[34] = 29'h01100000;
        data[35] = 29'h15010006;
        data[36] = 29'h12000005;
        data[37] = 29'h01000000;
        data[38] = 29'h01100000;
        data[39] = 29'h18204000;
        data[40] = 29'h01300000;
        data[41] = 29'h08a03000;
        data[42] = 29'h0baa000f;
        data[43] = 29'h05aa0005;
        data[44] = 29'h12030030;
        data[45] = 29'h01a00003;
        data[46] = 29'h06aa3000;
        data[47] = 29'h0200a000;
        data[48] = 29'h03330004;
        data[49] = 29'h05a30010;
        data[50] = 29'h12030029;
        data[51] = 29'h07000001;
        data[52] = 29'h09a2000f;
        data[53] = 29'h0e00a000;
        data[54] = 29'h07220001;
        data[55] = 29'h03110001;
        data[56] = 29'h05a10010;
        data[57] = 29'h12030028;
        data[58] = 29'h15004000;
        data[59] = 29'h05ff0001;
        data[60] = 29'h13e0f000;
        data[61] = 29'h170e0000;
    end
    
    // Lecture synchrone ou asynchrone de la ROM
    always @(*) begin
        DataROM = data[AddrROM];
    end
endmodule
