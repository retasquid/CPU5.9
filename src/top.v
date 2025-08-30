module top(
    output wire[7:0] out0,
    output wire[10:0] out1,
    //input wire[7:0] in0,
    //input wire[7:0] in1,
    //output wire MoSi,
    //output wire clkOUT,
    //output wire CSout,
    //input wire MiSo,
    output wire tx,
    input wire rx,

    input wire[7:0] INT,

    input wire rst_n,
    input wire clk_xtal,
    output wire clk_flash,

    //input wire PROG,

    output wire flash_clk,
    output wire flash_mosi,
    input wire flash_miso,
    output wire flash_cs_n
);
    wire write, read, rst, clk_OSC,CS0,CS1,CS2,CS3;
    wire[15:0] AddrRAM, DinRAM, DoutRAM_ram1, DoutRAM_ram2, DoutRAM_ram3, DoutRAM_io, DoutRAM, ROMaddr, confINT;
    wire[28:0] ROMdata;

    assign rst = ~rst_n;
    assign clk_flash = clk_out;

   assign {CS3,CS2,CS1,CS0}= 4'b1<<AddrRAM[15:14];
   assign DoutRAM = CS0 ? DoutRAM_io : 
                    CS1 ? DoutRAM_ram1 : 
                    CS2&~AddrRAM[13] ? DoutRAM_ram2 :
                    CS3&(AddrRAM[13:8]==6'b000000) ? DoutRAM_ram3 : 
                    16'b0;
    
    //wire flash_prog_clk, flash_prog_mosi, flash_prog_cs_n;
    //wire flash_rom_clk, flash_rom_mosi, flash_rom_cs_n;

    //assign flash_clk=PROG?flash_prog_clk:flash_rom_clk;
    //assign flash_mosi=PROG?flash_prog_mosi:flash_rom_mosi;
    //assign flash_cs_n=PROG?flash_prog_cs_n:flash_rom_cs_n;
    
    //wire io_tx, prog_tx;

    //assign tx=PROG?prog_tx:io_tx;

    /*Flash_Writer_UART Flash_prog(
        .clk(clk_xtal),
        .rst(rst),
        
        // Interface UART
        .uart_rx(rx),
        .uart_tx(prog_tx),
        
        // Interface Flash SPI
        .spi_clk(flash_prog_clk),
        .spi_mosi(flash_prog_mosi),
        .spi_miso(flash_miso),
        .spi_cs_n(flash_prog_cs_n)
    );*/

    CLK_Div clk_source(
        .clk_out(clk_out),
        .clk_OSC(clk_OSC)
    );

    CPU5_9 cpu5_9(
        .Dout(DinRAM),
        .Addr(AddrRAM),
        .write(write),
        .read(read),
        .ROMaddr(ROMaddr),
        .ROMdata(ROMdata),
        .Din(DoutRAM),
        .Interrupts(INT),
        .confINT(confINT),
        .clk_bus(clk_out),
        .rst_bus(rst)
    );
    //16k ram
    Gowin_SP ram1(
        .dout(DoutRAM_ram1), //output [15:0] dout
        .clk(~clk_out), //input clk
        .ce(CS1), //input ce
        .reset(rst), //input reset
        .wre(write), //input wre
        .ad(AddrRAM[13:0]), //input [13:0] ad
        .din(DinRAM) //input [15:0] din
    );
    //8k ram
    Gowin_SP1 ram2(
        .dout(DoutRAM_ram2), //output [15:0] dout
        .clk(~clk_out), //input clk
        .ce(CS2&~AddrRAM[13]), //input ce
        .reset(rst), //input reset
        .wre(write), //input wre
        .ad(AddrRAM[12:0]), //input [12:0] ad
        .din(DinRAM) //input [15:0] din
    );

    RAM ram3(
        .DoutRAM(DoutRAM_ram3),
        .DinRAM(DinRAM),
        .AddrRAM(AddrRAM[7:0]),
        .write(write),
        .clk(clk_out),
        .CS(CS3&(AddrRAM[13:8]==6'b000000))
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
        .read(read),
        .clk(clk_out),
        .clk_xtal(clk_OSC),
        .clk_xtal27(clk_xtal),
        .confINT(confINT),
        .rst(rst)
    );

    Flash_Controler MX25L3233F(
    .adresse(ROMaddr),          //////////////////////////////////////    
    .read_enable(clk_out),     // Signal pour démarrer une lecture
    .DataOUT(ROMdata),        // Données 32 bits en sortie
    .data_valid(),           // Indique que les données sont valides
    
    .clk(clk_OSC),
    .rst(rst),
    .busy(),
    .spi_clk(flash_clk),
    .spi_mosi(flash_mosi),
    .spi_miso(flash_miso),
    .spi_cs_n(flash_cs_n)
);
endmodule