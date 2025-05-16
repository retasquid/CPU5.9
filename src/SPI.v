module SPI(
    output reg MoSi,
    output reg clkOUT,
    output reg CS,
    output reg[7:0] DATAin,
    input wire[7:0] DATAout,
    input wire send,
    input wire MiSo,
    input clk,
    input rst
);
    reg[3:0] bit_count;
    reg[7:0] tx_data, rx_data;
    reg transmission_active;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            MoSi <= 1'b0;
            clkOUT <= 1'b0;  // Clock à l'état bas par défaut
            CS <= 1'b1; 
            DATAin <= 8'b0;
            tx_data <= 8'b0;
            rx_data <= 8'b0;
            bit_count <= 4'b0;
            transmission_active <= 1'b0;
        end else begin
            if(send && !transmission_active) begin
                // Début de transmission
                tx_data <= DATAout;
                transmission_active <= 1'b1;
                bit_count <= 4'b0;
                CS <= 1'b0;  // Activer la communication
                MoSi <= DATAout[7];  // Préparer le premier bit
                clkOUT <= 1'b0;  // Assurer que la clock est basse avant de commencer
            end
            
            if(transmission_active) begin
                clkOUT <= ~clkOUT;  // Alternance de l'horloge
                
                if(clkOUT) begin
                    // Front montant - préparer le prochain bit
                    if(bit_count < 4'd8) begin
                        tx_data <= {tx_data[6:0], 1'b0};
                        MoSi <= tx_data[6];
                    end
                end else begin
                    // Front descendant - échantillonner le bit
                    rx_data <= {rx_data[6:0], MiSo};
                    bit_count <= bit_count + 4'd1;
                    
                    if(bit_count == 4'd8) begin
                        // Fin de transmission
                        transmission_active <= 1'b0;
                        //CS <= 1'b1;
                        DATAin <= {rx_data[6:0], MiSo};  // Collecter le dernier bit
                        clkOUT <= 1'b0;  // Rester à l'état bas
                    end
                end
            end
        end
    end
endmodule