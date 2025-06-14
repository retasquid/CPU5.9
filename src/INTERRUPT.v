module INTERRUPT(
    output reg [28:0] Instruction,
    output reg interrupt,
    input wire [7:0] interrupts,
    input wire [15:0] conf,
    input wire CLK,
    input wire RST
);
    // Registres internes
    reg launch;
    reg[15:0] decoder, sav_decoder;
    reg[1:0] count;
    wire any_interrupt;
    reg[7:0] level, level_sav;
    reg[1:0] state, next_state;
    wire[7:0] interrupt_mask, mode;
    assign {mode, interrupt_mask}=conf;
    localparam [2:0]  IDLE           = 2'b000;
    localparam [2:0]  SAVE_PC    = 2'b001;
    localparam [2:0] DEC_SP      =2'b010;
    localparam [2:0] JMP           = 2'b011;
    // DÃ©tection d'interruption - signal combinatoire
    assign any_interrupt = |(interrupts&interrupt_mask);  // OU logique de tous les bits d'interruption

    // Logique de dÃ©codage et de sÃ©quenÃ§age
    always @(*) begin
            // DÃ©codage des interruptions par prioritÃ©
            casez (interrupts&interrupt_mask)
                8'b???????1: begin
                    decoder <= 16'hFFF8;  // Interruption 0 (prioritÃ© la plus haute)
                end
                8'b??????10: begin
                    decoder <= 16'hFFF9;  // Interruption 1
                end
                8'b?????100: begin
                    decoder <= 16'hFFFA;  // Interruption 2
                end
                8'b????1000: begin
                    decoder <= 16'hFFFB;  // Interruption 3
                end
                8'b???10000: begin
                    decoder <= 16'hFFFC;  // Interruption 4
                end
                8'b??100000: begin
                    decoder <= 16'hFFFD;  // Interruption 5
                end
                8'b?1000000: begin
                    decoder <= 16'hFFFE;  // Interruption 6
                end
                8'b10000000: begin
                    decoder <= 16'hFFFF;  // Interruption 7 (prioritÃ© la plus basse)
                end
                default: decoder <= 16'd0;
            endcase
            
            level=decoder?1<<(decoder[3:0]-8):8'b0;
    end
    // Machine Ã  Ã©tats principale - Mise Ã  jour sur front montant de clk
    always @(negedge CLK or posedge RST) begin
        if (RST) begin
            state <= IDLE;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    if (launch) begin
                        Instruction<=29'b10110000000001111000000000001;
                        interrupt<=1'b1;
                        sav_decoder<=decoder;
                        level_sav<=level;
                    end
                end

                SAVE_PC: begin
                    Instruction<=29'b00101111111110000000000000001;
                end

                DEC_SP: begin
                    Instruction<=29'b10010000000000000000000000000|sav_decoder;
                end
                JMP: begin
                    interrupt<=1'b0;
                    sav_decoder<=16'b0;
                end
            endcase
        end
    end

    // Logique de transition d'Ã©tats - basÃ©e sur les fronts SPI
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
				if(mode&level_sav)begin
					if(any_interrupt && ((level_sav&level)^level_sav))begin
						next_state<=SAVE_PC;
						launch<=1'b1;
					end 
				end else begin
					if (any_interrupt)begin
						next_state<=SAVE_PC;
						launch<=1'b1;
					end 
				end
            end

            SAVE_PC: begin
                next_state<=DEC_SP;
                launch<=1'b0;
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