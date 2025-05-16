module UC(
    output wire PCpp,
    output wire JMP,
    output wire call,
    output wire ret,
    output wire Wreg,
    output wire [1:0] Sregin,
    output wire SBalu,
    output wire ENflag,
    output wire [2:0] OPalu,
    output wire Wbus,
    input wire [4:0] OPCode,
    input wire [1:0] A,
    input wire [3:0] FLAG,
    input wire CLK,
    input wire interrupt,
    input wire CallInt
   );
    reg [12:0] UCrom [0:23];
    reg [12:0] temp;
	initial begin
        UCrom[0]  = 13'h0000;  // 0x0
        UCrom[1]  = 13'h1140;  // 0x1140
        UCrom[2]  = 13'h1110;  // 0x1110
        UCrom[3]  = 13'h1130;  // 0x1130
        UCrom[4]  = 13'h1112;  // 0x1112
        UCrom[5]  = 13'h1132;  // 0x1132
        UCrom[6]  = 13'h1114;  // 0x1114
        UCrom[7]  = 13'h1134;  // 0x1134
        UCrom[8]  = 13'h1116;  // 0x1116
        UCrom[9]  = 13'h1136;  // 0x1136
        UCrom[10] = 13'h1118;  // 0x1118
        UCrom[11] = 13'h1138;  // 0x1138
        UCrom[12] = 13'h111a;  // 0x111a
        UCrom[13] = 13'h113a;  // 0x113a
        UCrom[14] = 13'h111c;  // 0x111c
        UCrom[15] = 13'h113c;  // 0x113c
        UCrom[16] = 13'h111e;  // 0x111e
        UCrom[17] = 13'h113e;  // 0x113e
        UCrom[18] = 13'h1800;  // 0x1800
        UCrom[19] = 13'h1180;  // 0x1180
        UCrom[20] = 13'h1001;  // 0x1001
        UCrom[21] = 13'h1021;  // 0x1021
        UCrom[22] = 13'h1401;  // 0x1401
        UCrom[23] = 13'h0a00;  // 0xa00
    end
    
    always @(posedge CLK) begin
        temp<=UCrom[OPCode];
    end

        assign call=temp[10] | CallInt;
        assign ret=temp[9];
        assign Wreg=temp[8];
        assign Sregin=temp[7:6];
        assign SBalu=temp[5];
        assign ENflag=temp[4];
        assign OPalu=temp[3:1];
        assign Wbus=temp[0] | CallInt;
        assign JMP=temp[11]&FLAG[A];
        assign PCpp=~interrupt &~JMP & temp[12];

endmodule