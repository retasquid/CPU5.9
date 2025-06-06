module spi_master (
    // Interface système
    input  wire        clk1,          // Horloge système principale
    input  wire        clk2,          // Horloge système principale
    input  wire        rst,        // Reset actif bas (bonne pratique)
    
    // Interface de contrôle
    input  wire [7:0]  tx_data,      // Données à transmettre
    output reg  [7:0]  rx_data,      // Données reçues
    input  wire        start_tx,     // Démarrer transmission (edge-triggered)
    output wire        busy,         // Transmission en cours
    
    // Configuration SPI
    input  wire [7:0]  conf,       // Configuration: {cs_pol, cpol, cpha, first_bit, clk_src, clk_div[2:0]}
    
    // Interface SPI
    output reg         spi_clk,      // Horloge SPI
    output reg         spi_mosi,     // Master Out Slave In
    input  wire        spi_miso,     // Master In Slave Out
    output reg         spi_cs_n      // Chip Select (actif bas par défaut)
);

    // Décodage de la configuration
    wire       cs_polarity;    // Polarité du CS (0=actif bas, 1=actif haut)
    wire       cpol;           // Clock polarity
    wire       cpha;           // Clock phase
    wire       first_bit;       // 1 - LSB first , 0 - MSB first
    wire       clk_src;       // Mode SPI (0-3)
    wire [2:0] clk_divider;    // Diviseur d'horloge
    
    assign {cs_polarity, cpol, cpha, first_bit, clk_src, clk_divider[2:0]} = conf;

    assign clk=clk_src?clk2:clk1;
    
    // États de la machine d'état
    localparam [2:0] IDLE       = 3'b000,
                     START      = 3'b001,
                     TRANSMIT   = 3'b010,
                     FINISH     = 3'b011;
    
    // Registres internes
    reg [2:0]  state;
    reg [2:0]  next_state;
    reg [3:0]  bit_counter;
    reg [7:0]  shift_reg_tx;
    reg [7:0]  shift_reg_rx;
    reg [7:0]  clk_div_counter;
    reg        spi_clk_int;
    reg        spi_clk_en;
    reg        start_tx_prev;
    reg        start_edge;
    
    // Calcul du diviseur d'horloge
    wire [7:0] clk_div_value;
    assign clk_div_value = (clk_divider == 3'b001) ? 8'd1  :  // /2
                          (clk_divider == 3'b010) ? 8'd2  :  // /4
                          (clk_divider == 3'b011) ? 8'd4 :  // /8
                          (clk_divider == 3'b100) ? 8'd8 :  // /16
                          (clk_divider == 3'b101) ? 8'd16 :  // /32
                          (clk_divider == 3'b110) ? 8'd32 :  // /64
                                                     8'd64;  // /128
    // Génération de l'horloge SPI
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clk_div_counter <= 8'b0;
            spi_clk_int <= cpol;  // État de repos selon CPOL
        end else begin
            if (spi_clk_en && (clk_divider != 3'b000)) begin
                if (clk_div_counter >= (clk_div_value - 1)) begin
                    clk_div_counter <= 8'b0;
                    spi_clk_int <= ~spi_clk_int;
                end else begin
                    clk_div_counter <= clk_div_counter + 1'b1;
                end
            end else begin
                clk_div_counter <= 8'b0;
                spi_clk_int <= cpol;  // État de repos
            end
        end
    end
    
    // Sortie de l'horloge SPI
    always @(*) begin
        if (spi_clk_en) begin
            if (clk_divider == 3'b000) begin
                // Mode sans division : horloge système directe
                spi_clk = clk;
            end else begin
                // Mode avec division : horloge divisée
                spi_clk = spi_clk_int;
            end
        end else begin
            // État de repos selon CPOL
            spi_clk = cpol;
        end
    end
    
    // Détection du front montant de start_tx
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            start_tx_prev <= 1'b0;
            start_edge <= 1'b0;
        end else begin
            start_tx_prev <= start_tx;
            start_edge <= start_tx && !start_tx_prev;
        end
    end
    
    // Machine d'état - logique séquentielle
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Machine d'état - logique combinatoire
    always @(*) begin
        next_state = state;
        
        case (state)
            IDLE: begin
                if (start_edge) begin
                    next_state = START;
                end
            end
            
            START: begin
                next_state = TRANSMIT;
            end
            
            TRANSMIT: begin
                if ((((clk_divider==0) && (bit_counter >= 4'd7)) || ((clk_divider>0) && (bit_counter >= 4'd8)))&& spi_clk_int == cpol) begin
                    next_state = FINISH;
                end
            end
            
            FINISH: begin
                next_state = IDLE;
            end
            
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // Logique de sortie de la machine d'état
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            spi_cs_n <= ~cs_polarity;  // État inactif
            spi_mosi <= 1'b0;
            rx_data <= 8'b0;
            shift_reg_tx <= 8'b0;
            shift_reg_rx <= 8'b0;
            bit_counter <= 4'b0;
            spi_clk_en <= 1'b0;
        end else begin
            
            case (state)
                IDLE: begin
                    spi_cs_n <= ~cs_polarity;  // CS inactif
                    spi_clk_en <= 1'b0;
                    bit_counter <= 4'b0;
                    
                    if (start_edge) begin
                        shift_reg_tx <= first_bit?{tx_data[0],tx_data[1],tx_data[2],tx_data[3],tx_data[4],tx_data[5],tx_data[6],tx_data[7]}:tx_data;  // Charger les données
                        shift_reg_rx <= 8'b0;
                    end
                end
                
                START: begin
                    spi_cs_n <= cs_polarity;   // CS actif
                    spi_clk_en <= 1'b1;       // Activer l'horloge
                    bit_counter <= 4'b0;
                    
                    // Préparer le premier bit selon CPHA
                    if (cpha == 1'b0) begin
                        spi_mosi <= shift_reg_tx[7];
                    end
                end
                
                TRANSMIT: begin
                    // Gestion des fronts d'horloge
                    if (clk_div_counter == 8'b0) begin  // Front d'horloge
                        if ((spi_clk_int == cpol && cpha == 1'b1) ||  // Setup edge
                            (spi_clk_int != cpol && cpha == 1'b0)) begin
                            
                            // Transmission du bit
                            spi_mosi <= shift_reg_tx[7];
                            shift_reg_tx <= {shift_reg_tx[6:0], 1'b0};
                            
                        end else begin  // Sample edge
                            // Réception du bit
                            shift_reg_rx <= {shift_reg_rx[6:0], spi_miso};
                            bit_counter <= bit_counter + 1'b1;
                        end
                    end
                end
                
                FINISH: begin
                    rx_data <= shift_reg_rx;   // Données reçues disponibles
                    spi_clk_en <= 1'b0;
                end
            endcase
        end
    end
    
    // Signal busy
    assign busy = (state != IDLE);

endmodule