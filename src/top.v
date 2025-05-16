module top(
    output wire[7:0] out0,
    output wire[7:0] out1,
    input wire[7:0] in0,
    input wire[7:0] in1,
    output wire MoSi,
    output wire clkOUT,
    output wire CSout,
    input wire MiSo,
    output wire tx,
    input wire rx,
    input wire[7:0] INT,
    input wire clk_xtal,
    input wire rst_n,
    output wire clk
);
    wire write, rst;
    wire[15:0] ROMaddr,AddrRAM,DinRAM;
    wire[15:0] DoutRAM_ram, DoutRAM_io; // Separate outputs for RAM and IO
    wire[15:0] DoutRAM; // The final CPU input data
    wire[28:0] ROMdata;
    
    assign rst = ~rst_n;
    
    // Data bus multiplexer - Only one device drives the bus at a time
    assign DoutRAM = CS0 ? DoutRAM_io : 
                    CS1 ? DoutRAM_ram : 
                    16'h0000; // Default value when no device is selected
    
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
        .Din(DoutRAM),  // CPU reads from the multiplexed data bus
        .Interrupts(INT),
        .clk_bus(clk),
        .rst_bus(rst)
    );
    
    adresse_select memmap(
        .adresse(AddrRAM),
        .CS0(CS0),
        .CS1(CS1),
        .CS2(CS2),
        .CS3(CS3)
    );
    
    ROM rom1(
        .DataROM(ROMdata),
        .AddrROM(ROMaddr[7:0])
    );
    /*
    RAM ram1(
        .DoutRAM(DoutRAM_ram),
        .DinRAM(DinRAM),
        .AddrRAM(AddrRAM[7:0]),
        .write(write),
        .clk(clk),
        .CS(CS1)
    );
*/
    Gowin_SP ram2(
        .dout(DoutRAM_ram), 
        .clk(clk),
        .oce(),
        .ce(CS1),
        .reset(rst),
        .wre(write),
        .ad(AddrRAM[13:0]),
        .din(DinRAM)
    );

    IO io(
        .GPI0(in0),
        .GPI1(in1),
        .GPO0(out0),
        .GPO1(out1),
        .CS(CS0),
        .MoSi(MoSi),
        .clkOUT(clkOUT),
        .CSout(CSout),
        .MiSo(MiSo),
        .tx(tx),
        .rx(rx),
        .DATAin(DoutRAM_io),
        .DATAout(DinRAM), // IO drives its own output bus
        .adresse(AddrRAM[13:0]),
        .write(write),
        .clk(clk),
        .clk_xtal(clk_xtal),
        .rst(rst)
    );
endmodule