module ALU (
    output reg [15:0] S,
    output reg [5:0] FLAGS,
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [2:0] OPALU,
    input wire enFLAGS,
    input wire enCARRY,
    input wire clk,
    input wire rst
);
    // Registres temporaires pour calculer correctement les drapeaux
    reg carry;
    reg carry15;
    reg overflow;
    reg sign;
    reg[14:0] Soverflow;

    // Fonction combinatoire pour calculer le résultat et les drapeaux
    always @(*) begin
        case (OPALU)
            3'b000: begin // Addition
                {carry, S} = {1'b0, A} + {1'b0, B} + {16'b0,(enCARRY&FLAGS[2])};
                {carry15, Soverflow} = {1'b0, A[14:0]} + {1'b0, B[14:0]} + {15'b0,(enCARRY&FLAGS[2])};
                overflow = carry^carry15;
                sign = carry^carry15^S[15];
            end
            3'b001: begin // Soustraction
                {carry, S} = {1'b0, A} - {1'b0, B} - {16'b0,(enCARRY&FLAGS[2])};
                {carry15, Soverflow} = {1'b0, A[14:0]} - {1'b0, B[14:0]} - {15'b0,(enCARRY&FLAGS[2])};
                overflow = carry^carry15;
                sign = carry^carry15^S[15];
            end
            3'b010: begin // Décalage à gauche
                S = A << B[3:0];
                carry = (B[3:0] > 0 && B[3:0] <= 16) ? ((A >> (16 - B[3:0])) & 1'b1) : 1'b0;
            end
            3'b011: begin // Décalage à droite
                S = A >> B[3:0];
                carry = (B[3:0] > 0 && B[3:0] <= 16) ? ((A >> (B[3:0] - 1)) & 1'b1) : 1'b0;
            end
            3'b100: begin // AND logique
                S = A & B;
                carry = 1'b0;
            end
            3'b101: begin // NAND logique
                S = ~(A & B);
                carry = 1'b0;
            end
            3'b110: begin // OR logique
                S = A | B;
                carry = 1'b0;
            end
            3'b111: begin // XOR logique
                S = A ^ B;
                carry = 1'b0;
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
                FLAGS[1] <= (S == 16'h0); // Drapeau zéro
                FLAGS[2] <= carry;             // Drapeau de retenue
                FLAGS[3] <= S[15];          // Drapeau de signe N
                FLAGS[4] <= overflow;             // Drapeau d'overflow
                FLAGS[5] <= sign;          // Drapeau de signe S
            end
        end
    end
endmodule