module Flash_Writer_UART (
    input wire clk,
    input wire rst,
    
    // Interface UART
    input wire uart_rx,
    output wire uart_tx,
    
    // Interface Flash SPI
    output wire spi_clk,
    output wire spi_mosi,
    input wire spi_miso,
    output reg spi_cs_n,
    
    // Status
    output wire busy,
    output reg [2:0] status // 0: idle, 1: receiving, 2: writing, 3: error, 4: complete
);

    // Commandes Flash MX25L3233F
    parameter CMD_WRITE_ENABLE = 8'h06;
    parameter CMD_PAGE_PROGRAM = 8'h02;
    parameter CMD_READ_STATUS  = 8'h05;
    
    // États de la machine à états principale
    parameter STATE_IDLE          = 6'd0;
    parameter STATE_WAIT_WREN     = 6'd1;
    parameter STATE_SEND_WREN     = 6'd2;
    parameter STATE_WREN_COMPLETE = 6'd3;
    parameter STATE_SEND_CMD      = 6'd4;
    parameter STATE_CMD_COMPLETE  = 6'd5;
    parameter STATE_SEND_ADDR_H   = 6'd6;
    parameter STATE_ADDR_H_COMPLETE = 6'd7;
    parameter STATE_SEND_ADDR_M   = 6'd8;
    parameter STATE_ADDR_M_COMPLETE = 6'd9;
    parameter STATE_SEND_ADDR_L   = 6'd10;
    parameter STATE_ADDR_L_COMPLETE = 6'd11;
    parameter STATE_SEND_DATA     = 6'd12;
    parameter STATE_DATA_COMPLETE = 6'd13;
    parameter STATE_FINISH_WRITE  = 6'd14;
    parameter STATE_CHECK_STATUS  = 6'd15;
    parameter STATE_STATUS_COMPLETE = 6'd16;
    parameter STATE_COMPLETE      = 6'd17;
    parameter STATE_ERROR         = 6'd18;

    // Registres internes
    reg [5:0] state, next_state;
    reg [7:0] spi_tx_data;
    wire [7:0] spi_rx_data;
    reg spi_clk_en;
    wire spi_busy;
    reg [7:0] confspi;
    
    // Buffer de données et contrôle
    reg [7:0] data_buffer [0:255]; // Buffer de 256 octets (une page)
    reg [7:0] buffer_index;
    reg [23:0] flash_addr;
    reg [7:0] bytes_to_write;
    reg [7:0] bytes_written;
    
    // Interface UART
    wire [7:0] uart_rx_data;
    wire uart_rx_valid;
    wire uart_tx_busy;
    reg [7:0] uart_tx_data;
    reg uart_tx_start;
    
    // Variables de protocole
    reg [7:0] packet_state; // 0: attente adresse, 1-3: réception adresse, 4: attente taille, 5: réception données
    reg [7:0] addr_bytes_received;
    
    // Instances des modules
    spi_master SPI(
        .clk1(clk),
        .clk2(clk),
        .rst(rst),
        .tx_data(spi_tx_data),
        .rx_data(spi_rx_data),
        .start_tx(spi_clk_en),
        .busy(spi_busy),
        .conf(confspi),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_cs_n() // Non utilisé, on contrôle spi_cs_n manuellement
    );
    
    
    // Module UART    
    UART uart(
        .baud(24'd115200),             // Paramètre de baud rate
        .clk_xtal(clk),     // Signal d'horloge
        .clk_CPU(clk),
        .send(uart_tx_start),         // Signal pour démarrer la transmission
        .DataOut(uart_tx_data),       // Données à transmettre
        .rx(uart_rx),                 // Ligne de réception
        .read(1'b0),
        .tx(uart_tx),                 // Ligne de transmission
        .DataIn(uart_rx_data),         // Données reçues
        .busy(uart_tx_busy)
    );

    assign busy = (state != STATE_IDLE);

    
    always@(posedge clk) begin
        state <= next_state;
    end

    // Réception des données UART et construction du packet
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            packet_state <= 0;
            addr_bytes_received <= 0;
            flash_addr <= 24'h0;
            bytes_to_write <= 0;
            buffer_index <= 0;
            uart_tx_data <= 8'h0;
            uart_tx_start <= 1'b0;
            status <= 0;


            spi_cs_n <= 1'b1;
            spi_clk_en <= 1'b0;
            spi_tx_data <= 8'h0;
            confspi <= 8'b00100000; // Configuration SPI par défaut
        end else begin
            uart_tx_start <= 1'b0; // Par défaut
            
            if (uart_rx_valid && state == STATE_IDLE) begin
                case (packet_state)
                    0: begin // Attente du premier octet d'adresse
                        flash_addr[23:16] <= uart_rx_data;
                        addr_bytes_received <= 1;
                        packet_state <= 1;
                        status <= 1; // receiving
                    end
                    
                    1: begin // Deuxième octet d'adresse
                        flash_addr[15:8] <= uart_rx_data;
                        addr_bytes_received <= 2;
                        packet_state <= 2;
                    end
                    
                    2: begin // Troisième octet d'adresse
                        flash_addr[7:0] <= uart_rx_data;
                        addr_bytes_received <= 3;
                        packet_state <= 3;
                    end
                    
                    3: begin // Nombre d'octets à écrire
                        bytes_to_write <= uart_rx_data;
                        buffer_index <= 0;
                        packet_state <= 4;
                        if (uart_rx_data == 0) begin
                            packet_state <= 0; // Reset si pas de données
                            status <= 3; // error
                        end
                    end
                    
                    4: begin // Réception des données
                        data_buffer[buffer_index] <= uart_rx_data;
                        buffer_index <= buffer_index + 1;
                        
                        if (buffer_index + 1 >= bytes_to_write) begin
                            packet_state <= 0; // Reset pour le prochain packet
                            // Déclencher l'écriture
                            bytes_written <= 0;
                            status <= 2; // writing
                        end
                    end
                endcase
            end
            
            // Envoi de l'accusé de réception
            if (state == STATE_COMPLETE) begin
                uart_tx_data <= 8'hDC; // Accusé de réception
                uart_tx_start <= 1'b1;
                status <= 4; // complete
            end else if (state == STATE_ERROR) begin
                uart_tx_data <= 8'hFF; // Code d'erreur
                uart_tx_start <= 1'b1;
                status <= 3; // error
            end
        end

        // Machine à états pour l'écriture Flash
        
        case (state)
            STATE_IDLE: begin
                spi_cs_n <= 1'b1;
                spi_clk_en <= 1'b0;
                if (packet_state == 0 && bytes_to_write > 0 && status == 2) begin
                    // Commencer l'écriture
                    spi_cs_n <= 1'b0;
                    spi_tx_data <= CMD_WRITE_ENABLE;
                end
            end
            
            STATE_WAIT_WREN: begin
                spi_clk_en <= 1'b1;
            end
            
            STATE_SEND_WREN: begin
                spi_clk_en <= 1'b0;
            end
            
            STATE_WREN_COMPLETE: begin
                spi_cs_n <= 1'b1;
                spi_tx_data <= CMD_PAGE_PROGRAM;
            end
            
            STATE_SEND_CMD: begin
                spi_cs_n <= 1'b0;
                spi_clk_en <= 1'b1;
            end
            
            STATE_CMD_COMPLETE: begin
                spi_clk_en <= 1'b0;
                spi_tx_data <= flash_addr[23:16];
            end
            
            STATE_SEND_ADDR_H: begin
                spi_clk_en <= 1'b1;
            end
            
            STATE_ADDR_H_COMPLETE: begin
                spi_clk_en <= 1'b0;
                spi_tx_data <= flash_addr[15:8];
            end
            
            STATE_SEND_ADDR_M: begin
                spi_clk_en <= 1'b1;
            end
            
            STATE_ADDR_M_COMPLETE: begin
                spi_clk_en <= 1'b0;
                spi_tx_data <= flash_addr[7:0];
            end
            
            STATE_SEND_ADDR_L: begin
                spi_clk_en <= 1'b1;
            end
            
            STATE_ADDR_L_COMPLETE: begin
                spi_clk_en <= 1'b0;
                spi_tx_data <= data_buffer[bytes_written];
            end
            
            STATE_SEND_DATA: begin
                spi_clk_en <= 1'b1;
            end
            
            STATE_DATA_COMPLETE: begin
                spi_clk_en <= 1'b0;
                bytes_written <= bytes_written + 1;
                
                if (bytes_written + 1 < bytes_to_write) begin
                    spi_tx_data <= data_buffer[bytes_written + 1];
                end
            end
            
            STATE_FINISH_WRITE: begin
                spi_cs_n <= 1'b1;
                spi_tx_data <= CMD_READ_STATUS;
            end
            
            STATE_CHECK_STATUS: begin
                spi_cs_n <= 1'b0;
                spi_clk_en <= 1'b1;
                confspi <= 8'b00000000; // Mode lecture
            end
            
            STATE_STATUS_COMPLETE: begin
                spi_clk_en <= 1'b0;
                // Vérifier si l'écriture est terminée (bit 0 = 0)
                if (spi_rx_data[0] == 1'b0) begin
                    // Écriture terminée
                    spi_cs_n <= 1'b1;
                    confspi <= 8'b00100000; // Retour en mode écriture
                end
            end
            
            STATE_COMPLETE: begin
                // Reset pour la prochaine opération
                bytes_to_write <= 0;
                spi_cs_n <= 1'b1;
            end
            
            STATE_ERROR: begin
                spi_cs_n <= 1'b1;
                bytes_to_write <= 0;
            end
        endcase
    end
    

    
    // Logique de transition d'états
    always @(*) begin
        next_state = state;
        
        case (state)
            STATE_IDLE: begin
                if (packet_state == 0 && bytes_to_write > 0 && status == 2)
                    next_state = STATE_WAIT_WREN;
            end
            
            STATE_WAIT_WREN: begin
                if (spi_busy) next_state = STATE_SEND_WREN;
            end
            
            STATE_SEND_WREN: begin
                if (!spi_busy) next_state = STATE_WREN_COMPLETE;
            end
            
            STATE_WREN_COMPLETE: begin
                next_state = STATE_SEND_CMD;
            end
            
            STATE_SEND_CMD: begin
                if (spi_busy) next_state = STATE_CMD_COMPLETE;
            end
            
            STATE_CMD_COMPLETE: begin
                if (!spi_busy) next_state = STATE_SEND_ADDR_H;
            end
            
            STATE_SEND_ADDR_H: begin
                if (spi_busy) next_state = STATE_ADDR_H_COMPLETE;
            end
            
            STATE_ADDR_H_COMPLETE: begin
                if (!spi_busy) next_state = STATE_SEND_ADDR_M;
            end
            
            STATE_SEND_ADDR_M: begin
                if (spi_busy) next_state = STATE_ADDR_M_COMPLETE;
            end
            
            STATE_ADDR_M_COMPLETE: begin
                if (!spi_busy) next_state = STATE_SEND_ADDR_L;
            end
            
            STATE_SEND_ADDR_L: begin
                if (spi_busy) next_state = STATE_ADDR_L_COMPLETE;
            end
            
            STATE_ADDR_L_COMPLETE: begin
                if (!spi_busy) next_state = STATE_SEND_DATA;
            end
            
            STATE_SEND_DATA: begin
                if (spi_busy) next_state = STATE_DATA_COMPLETE;
            end
            
            STATE_DATA_COMPLETE: begin
                if (!spi_busy) begin
                    if (bytes_written + 1 >= bytes_to_write)
                        next_state = STATE_FINISH_WRITE;
                    else
                        next_state = STATE_SEND_DATA;
                end
            end
            
            STATE_FINISH_WRITE: begin
                next_state = STATE_CHECK_STATUS;
            end
            
            STATE_CHECK_STATUS: begin
                if (spi_busy) next_state = STATE_STATUS_COMPLETE;
            end
            
            STATE_STATUS_COMPLETE: begin
                if (!spi_busy) begin
                    if (spi_rx_data[0] == 1'b0)
                        next_state = STATE_COMPLETE;
                    else
                        next_state = STATE_CHECK_STATUS; // Attendre que l'écriture se termine
                end
            end
            
            STATE_COMPLETE: begin
                next_state = STATE_IDLE;
            end
            
            STATE_ERROR: begin
                next_state = STATE_IDLE;
            end
        endcase
    end

endmodule