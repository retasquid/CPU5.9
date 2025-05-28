module UC(
    output wire PCpp,
    output wire JMP,
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
    reg [11:0] UCrom [0:24];
    reg [11:0] temp;
    initial begin
        UCrom[0]  = 12'h000;  
        UCrom[1]  = 12'h940; 
        UCrom[2]  = 12'h910;  
        UCrom[3]  = 12'h930;  
        UCrom[4]  = 12'h912;  
        UCrom[5]  = 12'h932;  
        UCrom[6]  = 12'h914; 
        UCrom[7]  = 12'h934; 
        UCrom[8]  = 12'h916; 
        UCrom[9]  = 12'h936;
        UCrom[10] = 12'h918; 
        UCrom[11] = 12'h938;  
        UCrom[12] = 12'h91a;  
        UCrom[13] = 12'h93a; 
        UCrom[14] = 12'h91c;  
        UCrom[15] = 12'h93c; 
        UCrom[16] = 12'h91e;  
        UCrom[17] = 12'h93e;
        UCrom[18] = 12'hc00;  
        UCrom[19] = 12'h980;  
        UCrom[20] = 12'h801; 
        UCrom[21] = 12'h821; 
        UCrom[22] = 12'h9c0; 
        UCrom[23] = 12'h600; 
        UCrom[24] = 12'h9a0; 
    end

    always @(*) begin
        temp<=UCrom[OPCode];
    end
        assign ret=temp[9];
        assign Wreg=temp[8];
        assign Sregin=temp[7:6];
        assign SBalu=temp[5];
        assign ENflag=temp[4];
        assign OPalu=temp[3:1];
        assign Wbus=temp[0] | CallInt;
        assign JMP=temp[9]|(temp[10]&FLAG[A]);
        assign PCpp= temp[11]&(~JMP);
endmodule