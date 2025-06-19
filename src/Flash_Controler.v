module Flash_Controler (
    input wire[15:0] adresse,
    input wire read_enable,          // Signal pour démarrer une lecture
    output reg[31:0] DataOUT,        // Données 32 bits en sortie
    output reg data_valid,           // Indique que les données sont valides
    
    input wire clk,
    input wire rst,
    output wire busy,
    output wire spi_clk,
    output wire spi_mosi,
    input wire spi_miso,
    output reg spi_cs_n
);    

    // Commandes Flash MX25L3233F
    parameter CMD_READ    = 8'h03;  // Fast Read
    
    // États de la machine à états
    parameter STATE_IDLE       = 5'd0;
    parameter STATE_CMD        = 5'd1;
    parameter STATE_CMD_SEND        = 5'd2;
    parameter STATE_ADDR_H     = 5'd3;   // Adresse haute
    parameter STATE_ADDR_H_SEND     = 5'd4;   // Adresse haute
    parameter STATE_ADDR_M     = 5'd5;   // Adresse moyenne  
    parameter STATE_ADDR_M_SEND     = 5'd6;   // Adresse moyenne  
    parameter STATE_ADDR_L     = 5'd7;   // Adresse basse
    parameter STATE_ADDR_L_SEND     = 5'd8;   // Adresse basse
    parameter STATE_DATA_B3    = 5'd9;   // Premier octet (MSB)
    parameter STATE_DATA_B3_SEND    = 5'd10;   // Premier octet (MSB)
    parameter STATE_DATA_B2    = 5'd11;   // Deuxième octet
    parameter STATE_DATA_B2_SEND   = 5'd12;   // Deuxième octet
    parameter STATE_DATA_B1    = 5'd13;   // Troisième octet
    parameter STATE_DATA_B1_SEND    = 5'd14;   // Troisième octet
    parameter STATE_DATA_B0    = 5'd15;   // Quatrième octet (LSB)
    parameter STATE_DATA_B0_SEND    = 5'd16;   // Quatrième octet (LSB)
    parameter STATE_FINISH     = 5'd17;   // Finalisation
    
    // Registres internes
    reg [4:0] state, next_state;
    reg [7:0] spi_tx_data;
    wire [7:0] spi_rx_data;
    reg [23:0] flash_addr;
    reg [31:0] data_buffer;
    reg spi_clk_en,clkout;
    reg read_req;
    reg read_req_prev;
    reg[7:0] confspi;
    wire spi_busy;
    wire use_less;

    spi_master SPI(
        .clk1(clkout),
        .clk2(clkout),
        .rst(rst),
        .tx_data(spi_tx_data), // Données à transmettre
        .rx_data(spi_rx_data),// Données reçues
        .start_tx(spi_clk_en),
        .busy(spi_busy),
        .conf(confspi),
        .spi_clk(spi_clk),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso),
        .spi_cs_n(use_less)
    );
    Gowin_CLKDIV clk_div5(
        .clkout(clkout), //output clkout
        .hclkin(clk), //input hclkin
        .resetn(~rst) //input resetn
    );
    assign busy = (state != STATE_IDLE);
    
    // Détection du front montant de read_enable
    always @(posedge clkout or posedge rst) begin
        if (rst) begin
            read_req_prev <= 1'b0;
            read_req <= 1'b0;
        end else begin
            read_req_prev <= read_enable;
            read_req <= read_enable & ~read_req_prev;
        end
    end
    
    // Machine à états principale - Mise à jour sur front montant de clk
    always @(posedge clkout or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;
            spi_cs_n <= 1'b1;
            spi_clk_en <= 1'b0;
            DataOUT <= 32'h0;
            data_valid <= 1'b0;
            flash_addr <= 24'h0;
            data_buffer <= 32'h0;
            spi_tx_data <= 8'h0;
        end else begin
            state <= next_state;
            case (state)
                STATE_IDLE: begin
                    spi_cs_n <= 1'b1;
                    spi_clk_en <= 1'b0;
                    data_valid <= 1'b0;
                    confspi <= 8'b00100000;
                    spi_tx_data <= CMD_READ;
                    
                    if (read_req) begin
                        flash_addr <= {6'h00, adresse, 2'b00};
                        spi_cs_n <= 1'b0;
                    end
                end
                
                STATE_CMD: begin
                    spi_clk_en <= 1'b1;
                end

                STATE_CMD_SEND: begin
                    spi_clk_en <= 1'b0;
                    spi_tx_data <= flash_addr[23:16]; // Premier octet d'adresse
                end
                
                STATE_ADDR_H: begin
                    spi_clk_en <= 1'b1;
                end

                STATE_ADDR_H_SEND: begin
                    spi_clk_en <= 1'b0;
                    spi_tx_data <= flash_addr[15:8]; // Premier octet d'adresse
                end
                
                
                STATE_ADDR_M: begin
                    spi_clk_en <= 1'b1;
                end

                STATE_ADDR_M_SEND: begin
                    spi_tx_data <= flash_addr[7:0]; // Premier octet d'adresse
                    spi_clk_en <= 1'b0;
                end
                
                STATE_ADDR_L: begin
                    spi_clk_en <= 1'b1;
                end

                STATE_ADDR_L_SEND: begin
                    spi_clk_en <= 1'b0;
                    spi_tx_data <=8'hff; // Premier octet d'adresse
                end
                
                STATE_DATA_B3: begin // MSB
                
                    confspi <= 8'b00000000;
                    spi_clk_en <= 1'b1;
                end

                STATE_DATA_B3_SEND: begin // MSB
                    data_buffer[31:24] <= spi_rx_data;
                    spi_clk_en <= 1'b0;
                end
                
                STATE_DATA_B2: begin // MSB
                    spi_clk_en <= 1'b1;
                end

                STATE_DATA_B2_SEND: begin // MSB
                    data_buffer[23:16] <= spi_rx_data;
                    spi_clk_en <= 1'b0;
                end
                
                STATE_DATA_B1: begin // MSB
                    spi_clk_en <= 1'b1;
                end

                STATE_DATA_B1_SEND: begin // MSB
                    data_buffer[15:8] <= spi_rx_data;
                    spi_clk_en <= 1'b0;
                end

                STATE_DATA_B0: begin // MSB
                    spi_clk_en <= 1'b1;
                end
                
                STATE_DATA_B0_SEND: begin // MSB
                    data_buffer[7:0] <= spi_rx_data;
                    spi_clk_en <= 1'b0;
                end

                STATE_FINISH: begin
                    spi_cs_n <= 1'b1;
                    DataOUT <= data_buffer;
                    data_valid <= 1'b1;
                end
            endcase
        end
    end
    
    // Logique de transition d'états - basée sur les fronts SPI
    always @(*) begin
        next_state = state;
        case (state)
            STATE_IDLE: begin
                if (read_req)next_state = STATE_CMD;
            end
            
            STATE_CMD: begin
                if (spi_busy)next_state = STATE_CMD_SEND;
            end
             
            STATE_CMD_SEND: begin
                if (!spi_busy)next_state = STATE_ADDR_H;
            end

            STATE_ADDR_H: begin
                if (spi_busy)next_state = STATE_ADDR_H_SEND;
            end
            
            STATE_ADDR_H_SEND: begin
                if (!spi_busy)next_state = STATE_ADDR_M;
            end

            STATE_ADDR_M: begin
                if (spi_busy)next_state = STATE_ADDR_M_SEND;
            end

            STATE_ADDR_M_SEND: begin
                if (!spi_busy)next_state = STATE_ADDR_L;
            end
            
            STATE_ADDR_L: begin
                if (spi_busy)next_state = STATE_ADDR_L_SEND;
            end

            STATE_ADDR_L_SEND: begin
                if (!spi_busy)next_state = STATE_DATA_B3;
            end
            
            STATE_DATA_B3: begin
                if (spi_busy)next_state = STATE_DATA_B3_SEND;
            end

            STATE_DATA_B3_SEND: begin
                if (!spi_busy)next_state = STATE_DATA_B2;
            end
            
            STATE_DATA_B2: begin
                if (spi_busy)next_state = STATE_DATA_B2_SEND;
            end
            
            STATE_DATA_B2_SEND: begin
                if (!spi_busy)next_state = STATE_DATA_B1;
            end
            
            STATE_DATA_B1: begin
                if (spi_busy)next_state = STATE_DATA_B1_SEND;
            end
            
            STATE_DATA_B1_SEND: begin
                if (!spi_busy)next_state = STATE_DATA_B0;
            end
            
            STATE_DATA_B0: begin
                if (spi_busy)next_state = STATE_DATA_B0_SEND;
            end
            
            STATE_DATA_B0_SEND: begin
                if (!spi_busy)next_state = STATE_FINISH;
            end
            
            STATE_FINISH: begin
				next_state = STATE_IDLE;
            end
        endcase
    end
endmodule