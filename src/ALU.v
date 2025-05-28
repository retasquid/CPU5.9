module ALU (
    output reg [15:0] S,
    output reg [3:0] FLAGS,
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [2:0] OPALU,
    input wire enFLAGS,
    input wire clk,
    input wire rst
);
    // Registres temporaires pour calculer correctement les drapeaux
    reg carry;
    reg overflow;
    
    // Fonction combinatoire pour calculer le résultat et les drapeaux
    always @(*) begin
        case (OPALU)
            3'b000: begin // Addition
                {carry, S} = {1'b0, A} + {1'b0, B};
                // Overflow se produit quand les signes de A et B sont les memes, mais différents de result
                overflow =  S[15];
            end
            3'b001: begin // Soustraction
                {carry, S} = {1'b0, A} - {1'b0, B};
                // Overflow se produit quand les signes de A et -B sont les memes, mais différents de result
                overflow =   S[15];
            end
            3'b010: begin // Décalage à gauche
                S = A << B[3:0];
                carry = (B[3:0] > 0 && B[3:0] <= 16) ? ((A >> (16 - B[3:0])) & 1'b1) : 1'b0;
                overflow = 1'b0; // Généralement pas applicable pour les décalages
            end
            3'b011: begin // Décalage à droite
                S = A >> B[3:0];
                carry = (B[3:0] > 0 && B[3:0] <= 16) ? ((A >> (B[3:0] - 1)) & 1'b1) : 1'b0;
                overflow = 1'b0; // Généralement pas applicable pour les décalages
            end
            3'b100: begin // AND logique
                S = A & B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            3'b101: begin // NAND logique
                S = ~(A & B);
                carry = 1'b0;
                overflow = 1'b0;
            end
            3'b110: begin // OR logique
                S = A | B;
                carry = 1'b0;
                overflow = 1'b0;
            end
            3'b111: begin // XOR logique
                S = A ^ B;
                carry = 1'b0;
                overflow = 1'b0;
            end
        endcase
    end
    
    // Mise à jour de S et des drapeaux sur front d'horloge
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            FLAGS <= 4'b0001; // Reset: mettre à 1 uniquement le drapeau de reset
        end else begin
            if (enFLAGS) begin
                FLAGS[0] <= 1'b1;              // Bit de reset toujours à 1 après le reset
                FLAGS[1] <= (S == 16'h0000); // Drapeau zéro
                FLAGS[2] <= carry;             // Drapeau de retenue
                FLAGS[3] <= overflow;          // Drapeau de dépassement
            end
        end
    end
endmodule