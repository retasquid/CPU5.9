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

    input wire rst_n,
    output wire clk_out

/*
    output wire flash_clk,
    output wire flash_mosi,
    input wire flash_miso,
    output wire flash_cs_n*/
);
    wire write, rst, clk_OSC,CS0,CS1,CS2,CS3;
    wire[15:0] AddrRAM,DinRAM,DoutRAM_ram, DoutRAM_io,DoutRAM,ROMaddr;
    wire[28:0] ROMdata;

    assign rst = ~rst_n;

   assign {CS3,CS2,CS1,CS0}= 4'b1<<AddrRAM[15:14];
   assign DoutRAM = CS0 ? DoutRAM_io : 
                    CS1 ? DoutRAM_ram : 
                    16'hz;
    
    CLK_Div clk_source(
        .clk_out(clk_out),
        .clk_OSC(clk_OSC)
    );

    CPU5_9 cpu5_9(
        .Dout(DinRAM),
        .Addr(AddrRAM),
        .write(write),
        .ROMaddr(ROMaddr),
        .ROMdata(ROMdata),
        .Din(DoutRAM),
        .Interrupts(INT),
        .clk_bus(clk_out),
        .rst_bus(rst)
    );
    
    ROM rom(
        .DataROM(ROMdata),
        .AddrROM(ROMaddr[10:0])
    );

    RAM ram(
        .DoutRAM(DoutRAM_ram),
        .DinRAM(DinRAM),
        .AddrRAM(AddrRAM[7:0]),
        .write(write),
        .clk(clk_out),
        .CS(CS1)
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
        .DATAout(DinRAM), 
        .adresse(AddrRAM[13:0]),
        .write(write),
        .clk(clk_out),
        .clk_xtal(clk_OSC),
        .rst(rst)
    );
/*
    Flash_Controler MX25L3233F(
    .adresse(ROMaddr),
    .read_enable(clk_out),          // Signal pour démarrer une lecture
    .DataOUT(ROMdata),        // Données 32 bits en sortie
    .data_valid(),           // Indique que les données sont valides
    
    .clk(clk_OSC),
    .rst(rst),
    .busy(),
    .spi_clk(flash_clk),
    .spi_mosi(flash_mosi),
    .spi_miso(flash_miso),
    .spi_cs_n(flash_cs_n)
);*/
endmodule