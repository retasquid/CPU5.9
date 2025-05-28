module UART(
    input wire[23:0] baud,       // Paramètre de baud rate
    input wire clk_xtal,         // Signal d'horloge
    input wire send,             // Signal pour démarrer la transmission
    input wire[7:0] DataOut,     // Données à transmettre
    input wire rx,               // Ligne de réception
    output reg tx,               // Ligne de transmission
    output reg[7:0] DataIn,       // Données reçues
    output wire busy
);
    // Déclaration des registres
    reg[23:0] cnt;               // Compteur pour le diviseur de baud
    reg clk_baud;                // Horloge correspondant au baud rate
    reg transmitting, latch;            // État de transmission
    reg receiving;               // État de réception
    reg[9:0] tx_shift_reg;       // Registre à décalage pour TX
    reg[9:0] rx_shift_reg;       // Registre à décalage pour RX
    reg[3:0] tx_bit_count;       // Compteur de bits transmis
    reg[3:0] rx_bit_count;       // Compteur de bits reçus
    reg rx_d1, rx_d2;            // Pour détecter le front descendant de rx
    
    assign busy=transmitting;

    // Initialisation
    initial begin
        cnt = 24'b0;
        clk_baud = 1'b0;
        transmitting = 1'b0;
        latch = 1'b1;
        receiving = 1'b0;
        tx = 1'b1;               // Ligne idle en état haut
        tx_bit_count = 4'b0;
        rx_bit_count = 4'b0;
    end
    // Générateur d'horloge de baud rate
    always @(posedge clk_xtal) begin
        if(cnt >=(24'd1024000/baud)) begin  // Utilisation du paramètre baud (24'd13499000/baud)
            cnt <= 24'b0;
            clk_baud <= ~clk_baud;
        end else begin
            cnt <= cnt + 24'b1;
        end
    end
    
    // Synchronisation et détection du bit de start pour RX
    always @(posedge clk_xtal) begin
        rx_d1 <= rx;
        rx_d2 <= rx_d1;
    end
    
    // Logique de transmission
    always @(posedge clk_baud) begin
        // Démarrer une nouvelle transmission
        latch<=send?latch:1'b1;

        if(send && !transmitting && latch) begin
            transmitting <= 1'b1;
            latch<=1'b0;
            tx_shift_reg <= {1'b1, DataOut, 1'b0}; // {stop bit, data, start bit}
            tx_bit_count <= 4'b0;
        end
        // Continuer la transmission
        else if(transmitting) begin
            if(tx_bit_count < 4'd9) begin
                tx_bit_count <= tx_bit_count + 4'b1;
                tx <= tx_shift_reg[tx_bit_count];
            end else begin
                transmitting <= 1'b0;
                tx <= 1'b1; // Retour à l'état idle
            end
        end
    end
    
    // Logique de réception
    always @(posedge clk_baud) begin
        // Détecter un bit de start
        if(!receiving&& rx_d1 == 1'b0) begin// && rx_d2 == 1'b0 
            receiving <= 1'b1;
            rx_bit_count <= 4'b0;
            rx_shift_reg <= 10'b0;
        end
        // Continuer la réception
        else if(receiving) begin
            if(rx_bit_count < 4'd9) begin
                rx_shift_reg[rx_bit_count] <= rx;
                rx_bit_count <= rx_bit_count + 4'b1;
            end
            // Fin de la réception
            else begin
                // Vérifier que le bit de stop est 1
                if(rx == 1'b1) begin
                    DataIn <= rx_shift_reg[7:0]; // Extraire les 8 bits de données
                end
                receiving <= 1'b0;
            end
        end
    end
endmodule