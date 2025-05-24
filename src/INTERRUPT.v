module INTERRUPT(
    output wire [15:0] Addr,
    output wire Call,
    output wire INTjmp,
    output wire intSTOP,
    input wire [7:0] interrupts,
    input wire CLK,
    input wire RST
);
    assign Addr=0;
    assign Call=0;
    assign INTjmp=0;
    assign intSTOP=0;
/*
    // Registres internes
    reg [15:0] decoder;
    reg [1:0] count;
    reg Q;
    reg J, K;
    wire any_interrupt;
    
    // Détection d'interruption - signal combinatoire
    assign any_interrupt = |interrupts;  // OU logique de tous les bits d'interruption
    
    // Gestion du flip-flop JK pour la séquence d'interruption
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0;
        end else begin
            if (J && K) begin
                Q <= ~Q;
            end else if (J && !K) begin
                Q <= 1'b1;
            end else if (!J && K) begin
                Q <= 1'b0;
            end
            // Cas J=0, K=0: Q conserve sa valeur
        end
    end
    
    // Logique de décodage et de séquençage
    always @(negedge CLK or posedge RST) begin
        if (RST) begin
            // Réinitialisation synchrone de tous les registres
            decoder <= 16'b0;
            Addr <= 16'b0;
            Call <= 1'b0;
            INTjmp <= 1'b0;
            intSTOP <= 1'b0;
            count <= 2'b0;
            J <= 1'b0;
            K <= 1'b0;
        end else begin
            // Décodage des interruptions par priorité
            casez (interrupts)
                8'b???????1: decoder <= 16'h00F8;  // Interruption 0 (priorité la plus haute)
                8'b??????10: decoder <= 16'h00F9;  // Interruption 1
                8'b?????100: decoder <= 16'h00FA;  // Interruption 2
                8'b????1000: decoder <= 16'h00FB;  // Interruption 3
                8'b???10000: decoder <= 16'h00FC;  // Interruption 4
                8'b??100000: decoder <= 16'h00FD;  // Interruption 5
                8'b?1000000: decoder <= 16'h00FE;  // Interruption 6
                8'b10000000: decoder <= 16'h00FF;  // Interruption 7 (priorité la plus basse)
                default: decoder <= 16'b0;
            endcase
            
            // J prend la valeur de any_interrupt
            J <= any_interrupt;
            
            // Mettre à jour intSTOP avec la valeur actuelle de Q
            intSTOP <= Q;
            
            // Gestion de l'adresse d'interruption
            if (any_interrupt && !Q) begin
                Addr <= decoder;  // Charger l'adresse du gestionnaire d'interruption
            end else begin
                Addr <= 16'b0;    // Aucune adresse d'interruption
            end
            
            // Gestion de la séquence d'interruption
            if (Q) begin
                // Machine à état pour la séquence d'interruption
                case (count)
                    2'b00, 2'b01: begin
                        // Phases 0 et 1: Appel de la routine d'interruption
                        Call <= 1'b1;
                        INTjmp <= 1'b0;
                        K <= 1'b0;
                    end
                    2'b10: begin
                        // Phase 2: Saut à l'adresse d'interruption
                        Call <= 1'b0;
                        INTjmp <= 1'b1;
                        K <= 1'b0;
                    end
                    2'b11: begin
                        // Phase 3: Fin de la séquence d'interruption
                        Call <= 1'b0;
                        INTjmp <= 1'b0;
                        K <= 1'b1;  // Réinitialiser le flip-flop Q
                    end
                endcase
                count <= count + 1'b1;  // Incrémenter le compteur de séquence
            end else begin
                // Pas en séquence d'interruption
                Call <= 1'b0;
                INTjmp <= 1'b0;
                K <= 1'b0;
                count <= 2'b00;  // Réinitialiser le compteur
            end
        end
    end*/
endmodule