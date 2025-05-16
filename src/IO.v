module IO(
    input wire[7:0] GPI0,
    input wire[7:0] GPI1,
    output reg[7:0] GPO0,
    output reg[7:0] GPO1,
    input wire CS,
    output wire MoSi,
    output wire clkOUT,
    output wire CSout,
    input wire MiSo,
    output wire tx,
    input wire rx,
    output reg[15:0] DATAin,
    input wire[15:0] DATAout, 
    input wire[13:0] adresse,
    input wire write,
    input wire clk,
    input wire clk_xtal,
    input wire rst
);
    reg[7:0] tmp_dout , UARTOut;
    wire[7:0] tmp_din, UARTIn;
    reg sendSPI,sendUART;
    reg[23:0] baud;

    SPI spi(
        .MoSi(MoSi),
        .clkOUT(clkOUT),
        .CS(CSout),
        .DATAin(tmp_din),
        .DATAout(tmp_dout),
        .send(sendSPI),
        .MiSo(MiSo),
        .clk(clk),
        .rst(rst)
    );

    UART uart(
        .baud(baud),       // Paramètre de baud rate
        .clk_xtal(clk_xtal),         // Signal d'horloge
        .send(sendUART),             // Signal pour démarrer la transmission
        .DataOut(UARTOut),     // Données à transmettre
        .rx(rx),               // Ligne de réception
        .tx(tx),               // Ligne de transmission
        .DataIn(UARTIn)       // Données reçues
    );
    always@(negedge clk or posedge rst)begin
        if(rst)begin
            GPO0<=8'b00000000;
            GPO1<=8'b00000000;
        end else if(CS) begin
            case(adresse)
                14'b000 : DATAin<={8'b00000000,GPI0};
                14'b001 : DATAin<={8'b00000000,GPI1};
                14'b010 : GPO0<=write?DATAout[7:0]:GPO0;
                14'b011 : GPO1<=write?DATAout[7:0]:GPO1;
                14'b100 : begin
                tmp_dout<=write?DATAout[7:0]:tmp_dout;
                DATAin<=tmp_din;
                sendSPI<=write?DATAout[8]:sendSPI;
                end
                14'b101 : begin
                UARTOut<=write?DATAout[7:0]:UARTOut;
                DATAin<=UARTIn;
                sendUART<=write?DATAout[8]:sendUART;
                end
                14'b110 : baud[15:0]<= write?DATAout:baud[15:0];
                14'b111 : baud[23:16]<= write?DATAout[7:0]:baud[23:16];
                default : DATAin<=16'bz;
            endcase
        end else begin
            DATAin<=16'bz;
       end
    end
endmodule