module IO(
    input wire [7:0] GPI0,
    input wire [7:0] GPI1,
    output reg [7:0] GPO0,
    output reg [10:0] GPO1,
    input wire CS,
    output wire MoSi,
    output wire clkOUT,
    output wire CSout,
    input wire MiSo,
    output wire tx,
    input wire rx,
    output reg [15:0] DATAin,
    input wire [15:0] DATAout, 
    input wire [13:0] adresse,
    input wire write,
    input wire read,
    input wire clk,
    input wire clk_xtal,
    input wire clk_xtal27,
    output reg [15:0] confINT,
    input wire rst,
    output wire clk_baud
);
    // Registres pour les interfaces SPI et UART
    reg [7:0] tx_spi, UARTOut;
    wire [7:0] rx_spi, UARTIn;
    reg sendSPI, sendUART, readUART;
    reg [23:0] baud;
    
    // Drapeaux internes
    wire spi_busy, uart_busy;
    
    reg[7:0] confspi;
    
    // Définition des adresses des périphériques
    localparam ADDR_GPI0 = 14'd0;
    localparam ADDR_GPI1 = 14'd1;
    localparam ADDR_GPO0 = 14'd2;
    localparam ADDR_GPO1 = 14'd3;
    localparam ADDR_SPI  = 14'd4;
    localparam ADDR_CONFSPI  = 14'd5;
    localparam ADDR_UART = 14'd6;
    localparam ADDR_BAUD_LOW = 14'd7;
    localparam ADDR_BAUD_HIGH = 14'd8;
    localparam ADDR_STATUS = 14'd9;
    localparam ADDR_CONFINT = 14'd10;
    
    // Instanciation du module SPI
    spi_master SPI(
        .clk1(clk),
        .clk2(clk_xtal27),
        .rst(rst),
        .tx_data(tx_spi), // Données à transmettre
        .rx_data(rx_spi),// Données reçues
        .start_tx(sendSPI),
        .busy(spi_busy),
        .conf(confspi),
        .spi_clk(clkOUT),
        .spi_mosi(MoSi),
        .spi_miso(MiSo),
        .spi_cs_n(CSout)
    );
    
    // Instanciation du module UART
    UART uart(
        .baud(baud),             // Paramètre de baud rate
        .clk_xtal(clk_xtal27),     // Signal d'horloge
        .clk_CPU(clk),
        .send(sendUART),         // Signal pour démarrer la transmission
        .DataOut(UARTOut),       // Données à transmettre
        .rx(rx),                 // Ligne de réception
        .read(readUART),
        .tx(tx),                 // Ligne de transmission
        .DataIn(UARTIn),         // Données reçues
        .busy(uart_busy),
        .clk_baud(clk_baud)
    );
    
    // Registres de statut
    wire [15:0] status_reg;

    // Mise à jour des indicateurs d'état
    assign status_reg= {14'b0, uart_busy, spi_busy};
    
    // Mise à jour des registres
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            // Réinitialisation de tous les registres
            GPO0 <= 8'b00;
            GPO1 <= 11'b0;
            tx_spi <= 8'b00000000;
            UARTOut <= 8'b00000000;
            sendSPI <= 1'b0;
            sendUART <= 1'b0;
            baud <= 24'd9600;  // Valeur par défaut pour le baud rate (9600)
        end else begin
            // Traitement des accès au bus
            if(CS)begin
                case(adresse)                    
                    ADDR_GPO0: begin
                        if(write) GPO0 <= DATAout[7:0];
                    end
                    
                    ADDR_GPO1: begin
                        if(write) GPO1 <= DATAout[10:0];
                    end
                    
                    ADDR_SPI: begin
                        if(write) begin
                            tx_spi <= DATAout[7:0];
                            sendSPI <=  DATAout[8];
                        end
                    end

                    ADDR_CONFSPI: begin
                        if(write) begin
                            confspi <= DATAout[7:0];
                        end
                    end
                    
                    ADDR_UART: begin
                        if(write) begin
                            UARTOut <= DATAout[7:0];
                            sendUART <=  DATAout[8];
                        end
                    end
                    
                    ADDR_BAUD_LOW: begin
                        if(write) baud[15:0] <= DATAout;
                    end
                    
                    ADDR_BAUD_HIGH: begin
                        if(write) baud[23:16] <= DATAout[7:0];
                    end

                    ADDR_CONFINT: begin
                        if(write) confINT <= DATAout;
                    end
                endcase
            end
        end
    end

    always@(*) begin
        if(CS)begin
            case(adresse)
                ADDR_GPI0: begin
                    DATAin <= {8'b00000000, GPI0};
                end
                
                ADDR_GPI1: begin
                    DATAin <= {8'b00000000, GPI1};
                end
                
                ADDR_GPO0: begin
                    DATAin <= {8'b00000000, GPO0};
                end
                
                ADDR_GPO1: begin
                    DATAin <= {8'b00000000, GPO1};
                end
                
                ADDR_SPI: begin
                    DATAin <= {8'b00000000, rx_spi};
                end

                ADDR_CONFSPI: begin
                    DATAin <= {8'b00000000, confspi};
                end
                
                ADDR_UART: begin
                    DATAin <= {8'b00000000, UARTIn};
                    readUART <= read;
                end
                
                ADDR_BAUD_LOW: begin
                    DATAin <= baud[15:0];
                end
                
                ADDR_BAUD_HIGH: begin
                    DATAin <= {8'b00000000, baud[23:16]};
                end
                
                ADDR_STATUS: begin
                   DATAin <= status_reg;  // Registre de statut
                end
                
                ADDR_CONFINT: begin
                   DATAin <= confINT;  // Registre de statut
                end
                
                default: begin
                    DATAin <= 16'bz;  // Haute impédance si adresse non valide
                end
            endcase
        end else begin
            DATAin <= 16'bz;
            readUART <= 1'b0;
        end
    end
endmodule