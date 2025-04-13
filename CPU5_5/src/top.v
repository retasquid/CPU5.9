module top(
    output reg[2:0] out0,
    output reg[7:0] out1,
    input wire[7:0] INT,
    input wire clk_xtal,
    input wire rst_n,
    output wire clk,
    output reg[7:0] test
);

    wire write,rst;
    wire[15:0] ROMaddr,AddrRAM,DinRAM,DoutRAM;
    wire[28:0] ROMdata;
    assign rst = ~rst_n;
    assign test = ROMdata[7:0];
    always@(negedge clk or posedge rst)begin
        if(rst)begin
            out0<=3'b000;
            out1<=8'b00000000;
        end else begin
            if(AddrRAM==16'h0000  & write)begin
                out0<=DinRAM[2:0];
            end
            if(AddrRAM==16'h0001  & write)begin
                out1<=DinRAM[7:0];
            end
        end
    end

    CLK_Div clkdiv(
        .clk_out(clk),
        .clk_in(clk_xtal)
    );

    CPU5_5 cpu5_5(
        .Dout(DinRAM),
        .Addr(AddrRAM),
        .write(write),
        .ROMaddr(ROMaddr),
        .ROMdata(ROMdata),
        .Din(DoutRAM),
        .Interrupts(INT),
        .clk_bus(clk),
        .rst_bus(rst)
    );

   /* ROM rom1(
        .DataROM(ROMdata),
        .AddrROM(ROMaddr[7:0])
    );*/

    RAM ram1(
        .DoutRAM(DoutRAM),
        .DinRAM(DinRAM),
        .AddrRAM(AddrRAM[7:0]),
        .write(write),
        .clk(clk)
    );

    Gowin_pROM rom2(
        .dout(ROMdata), //output [28:0] dout
        .clk(clk), //input clk
        .oce(1'b1), //input oce
        .ce(1'b1), //input ce
        .reset(rst), //input reset
        .ad(ROMaddr[13:0]) //input [13:0] ad
    );
endmodule