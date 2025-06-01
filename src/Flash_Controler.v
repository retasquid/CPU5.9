module flash (
    input wire[15:0] adresse,
    input wire write,
    input wire[15:0] DataIN,
    output reg[15:0] DataOUT,
    
    input wire clk,
    input wire rst,
    input wire CS,
    output wire busy,

    output wire spi_clk,
    output wire spi_mosi,
    input wire spi_miso,
    output reg spi_cs_n
);

assign busy = (STATE != IDLE);

reg[3:0] STATE, NEXT_STATE;

// États de la machine d'état
localparam IDLE = 4'd0;
localparam READ_A = 4'd1;
localparam READ_D = 4'd2;
localparam WRITE_EN = 4'd3;
localparam WRITE_EN_STATUS = 4'd4;
localparam WRITE = 4'd5;
localparam WRITE_STATUS = 4'd6;
localparam WRITE_DIS = 4'd7;
localparam RST_EN = 4'd8;
localparam RESET = 4'd9;

// Commandes Flash MX25L3233F
localparam WRITE_ENABLE = 8'h06;
localparam WRITE_DISABLE = 8'h04;
localparam READ_STATUS_REG = 8'h05;
localparam WRITE_STATUS_REG = 8'h01;
localparam READ_DATA = 8'h03;
localparam FAST_READ = 8'h0B;
localparam PAGE_PROGRAM = 8'h02;
localparam RESET_ENABLE = 8'h66;
localparam RESET_DEVICE = 8'h99;

wire[7:0] rx_spi;
reg[7:0] confspi, tx_spi, status_reg;
wire spi_busy;
reg[2:0] Addr_cnt;
reg sendSPI;
reg spi_start_internal;

// Instance du module SPI master
spi_master SPI(
    .clk1(clk),
    .clk2(clk),
    .rst(rst),
    .tx_data(tx_spi),
    .rx_data(rx_spi),
    .start_tx(spi_start_internal),
    .busy(spi_busy),
    .conf(confspi),
    .spi_clk(spi_clk),
    .spi_mosi(spi_mosi),
    .spi_miso(spi_miso),
    .spi_cs_n()  // Non utilisé, on gère CS manuellement
);

// Machine d'état séquentielle
always @(posedge clk or posedge rst) begin
    if (rst) begin
        STATE <= IDLE;
        Addr_cnt <= 3'b0;
        spi_cs_n <= 1'b1;
        confspi <= 8'b00100000;  // Configuration SPI par défaut
        DataOUT <= 16'h0000;
        status_reg <= 8'h00;
        spi_start_internal <= 1'b0;
    end else begin
        STATE <= NEXT_STATE;
        spi_start_internal <= sendSPI;
        
        case(STATE)
            IDLE: begin
                spi_cs_n <= 1'b1;
                Addr_cnt <= 3'b0;
            end
            
            READ_A: begin
                // Envoi de la commande READ et de l'adresse 24-bit
                if (Addr_cnt == 3'b000) begin
                    spi_cs_n <= 1'b0;
                    confspi <= 8'b00100000;  // Mode transmission
                    tx_spi <= READ_DATA;
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b001) begin
                    tx_spi <= 8'h00;  // Byte d'adresse le plus haut (toujours 0 pour cette flash)
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b010) begin
                    tx_spi <= adresse[15:8];  // Byte d'adresse moyen
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b011) begin
                    tx_spi <= adresse[7:0];   // Byte d'adresse faible
                    if (!spi_busy) begin
                        Addr_cnt <= 3'b000;
                    end
                end
            end
            
            READ_D: begin
                // Réception des données (2 bytes pour 16-bit)
                if (Addr_cnt == 3'b000) begin
                    confspi <= 8'b00000000;  // Mode réception
                    tx_spi <= 8'hFF;         // Dummy data
                    if (!spi_busy) begin
                        DataOUT[15:8] <= rx_spi;
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b001) begin
                    tx_spi <= 8'hFF;         // Dummy data
                    if (!spi_busy) begin
                        DataOUT[7:0] <= rx_spi;
                        spi_cs_n <= 1'b1;
                        Addr_cnt <= 3'b000;
                    end
                end
            end
            
            WRITE_EN: begin
                // Envoi de la commande Write Enable
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                tx_spi <= WRITE_ENABLE;
                if (!spi_busy) begin
                    spi_cs_n <= 1'b1;
                end
            end
            
            WRITE_EN_STATUS: begin
                // Lecture du registre de statut pour vérifier WEL
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                if (Addr_cnt == 3'b000) begin
                    tx_spi <= READ_STATUS_REG;
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b001) begin
                    confspi <= 8'b00000000;  // Mode réception
                    tx_spi <= 8'hFF;
                    if (!spi_busy) begin
                        status_reg <= rx_spi;
                        spi_cs_n <= 1'b1;
                        Addr_cnt <= 3'b000;
                    end
                end
            end
            
            WRITE: begin
                // Programmation de page (2 bytes de données)
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                
                if (Addr_cnt == 3'b000) begin
                    tx_spi <= PAGE_PROGRAM;
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b001) begin
                    tx_spi <= 8'h00;  // Adresse haute
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b010) begin
                    tx_spi <= adresse[15:8];  // Adresse moyenne
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b011) begin
                    tx_spi <= adresse[7:0];   // Adresse basse
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b100) begin
                    tx_spi <= DataIN[15:8];   // Premier byte de données
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b101) begin
                    tx_spi <= DataIN[7:0];    // Deuxième byte de données
                    if (!spi_busy) begin
                        spi_cs_n <= 1'b1;
                        Addr_cnt <= 3'b000;
                    end
                end
            end
            
            WRITE_STATUS: begin
                // Attendre que la programmation soit terminée
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                
                if (Addr_cnt == 3'b000) begin
                    tx_spi <= READ_STATUS_REG;
                    if (!spi_busy) begin
                        Addr_cnt <= Addr_cnt + 1;
                    end
                end else if (Addr_cnt == 3'b001) begin
                    confspi <= 8'b00000000;
                    tx_spi <= 8'hFF;
                    if (!spi_busy) begin
                        status_reg <= rx_spi;
                        spi_cs_n <= 1'b1;
                        Addr_cnt <= 3'b000;
                    end
                end
            end
            
            WRITE_DIS: begin
                // Désactiver l'écriture
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                tx_spi <= WRITE_DISABLE;
                if (!spi_busy) begin
                    spi_cs_n <= 1'b1;
                end
            end
            
            RST_EN: begin
                // Activer le reset
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                tx_spi <= RESET_ENABLE;
                if (!spi_busy) begin
                    spi_cs_n <= 1'b1;
                end
            end
            
            RESET: begin
                // Effectuer le reset
                spi_cs_n <= 1'b0;
                confspi <= 8'b00100000;
                tx_spi <= RESET_DEVICE;
                if (!spi_busy) begin
                    spi_cs_n <= 1'b1;
                end
            end
        endcase
    end
end

// Machine d'état combinatoire pour les transitions
always @(*) begin
    NEXT_STATE = STATE;  // État par défaut
    sendSPI = 1'b0;      // Par défaut, pas d'envoi SPI
    
    case(STATE)
        IDLE: begin
            if (CS) begin
                if (write) begin
                    NEXT_STATE = WRITE_EN;
                end else begin
                    NEXT_STATE = READ_A;
                end
            end
        end
        
        READ_A: begin
            sendSPI = 1'b1;
            if (Addr_cnt == 3'b011 && !spi_busy) begin
                NEXT_STATE = READ_D;
            end
        end
        
        READ_D: begin
            sendSPI = 1'b1;
            if (Addr_cnt == 3'b001 && !spi_busy) begin
                NEXT_STATE = IDLE;
            end
        end
        
        WRITE_EN: begin
            sendSPI = 1'b1;
            if (!spi_busy) begin
                NEXT_STATE = WRITE_EN_STATUS;
            end
        end
        
        WRITE_EN_STATUS: begin
            sendSPI = 1'b1;
            if (!spi_busy && (status_reg & 8'h02)) begin  // WEL bit activé
                NEXT_STATE = WRITE;
            end else if (!spi_busy && !(status_reg & 8'h02)) begin
                NEXT_STATE = WRITE_EN;  // Réessayer write enable
            end
        end
        
        WRITE: begin
            sendSPI = 1'b1;
            if (Addr_cnt == 3'b101 && !spi_busy) begin
                NEXT_STATE = WRITE_STATUS;
            end
        end
        
        WRITE_STATUS: begin
            sendSPI = 1'b1;
            if (!spi_busy && !(status_reg & 8'h01)) begin  // WIP bit inactif
                NEXT_STATE = WRITE_DIS;
            end
        end
        
        WRITE_DIS: begin
            sendSPI = 1'b1;
            if (!spi_busy) begin
                NEXT_STATE = IDLE;
            end
        end
        
        RST_EN: begin
            sendSPI = 1'b1;
            if (!spi_busy) begin
                NEXT_STATE = RESET;
            end
        end
        
        RESET: begin
            sendSPI = 1'b1;
            if (!spi_busy) begin
                NEXT_STATE = IDLE;
            end
        end
        
        default: begin
            NEXT_STATE = IDLE;
        end
    endcase
end

endmodule