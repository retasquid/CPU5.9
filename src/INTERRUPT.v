module INTERRUPT(
    output reg [28:0] Instruction,
    output reg interrupt,
    input wire [7:0] interrupts,
    input wire CLK,
    input wire RST
);
    // Registres internes
    reg [15:0] decoder;
    reg [1:0] count;
    wire any_interrupt;

    reg[1:0] state, next_state;

    localparam [2:0]  IDLE           = 2'b000;
    localparam [2:0]  SAVE_PC    = 2'b001;
    localparam [2:0] DEC_SP      =2'b010;
    localparam [2:0] JMP           = 2'b011;

    // Détection d'interruption - signal combinatoire
    assign any_interrupt = |interrupts;  // OU logique de tous les bits d'interruption
    
    // Logique de décodage et de séquençage
    always @(*) begin
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
    end

    // Machine à états principale - Mise à jour sur front montant de clk
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (any_interrupt) begin
                        Instruction<=29'b10110000000001111000000000001;
                        interrupt<=1'b1;
                        interrupt<=1'b1;
                    end
                end
                
                SAVE_PC: begin
                        Instruction<=29'b00101111111110000000000000001;
                end
                
                DEC_SP: begin
                        Instruction<={29'b1001000000000,decoder};
                end

                JMP: begin
                    interrupt<=1'b0;
                end

            endcase
        end
    end
    
    // Logique de transition d'états - basée sur les fronts SPI
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                    if (any_interrupt) begin
                        next_state<=SAVE_PC;
                    end
            end
            
            SAVE_PC: begin
                next_state<=DEC_SP;
            end
            
            DEC_SP: begin
                next_state<=JMP;
            end
             
            JMP: begin
                next_state<=IDLE;
            end
        endcase
    end
endmodule