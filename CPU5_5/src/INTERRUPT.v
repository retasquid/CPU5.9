module INTERRUPT(
    output reg [15:0] Addr,
    output reg Call,
    output reg INTjmp,
    output reg intSTOP,
    input wire [7:0] interrupts,
    input wire CLK,
    input wire RST
);
    reg [15:0] decoder;
    reg [1:0] count;
    reg Q;
    reg J;
    reg K;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0;
        end else begin
            if (J == 1'b1 && K == 1'b1) begin
                Q <= ~Q;
            end else if (J == 1'b1 && K == 1'b0) begin
                Q <= 1'b1;
            end else if (J == 1'b0 && K == 1'b1) begin
                Q <= 1'b0;
            end
        end
    end

    always @(negedge CLK or posedge RST) begin
        if (RST) begin
            decoder <= 16'b0;
            Addr <= 16'b0;
            Call <= 1'b0;
            INTjmp <= 1'b0;
            intSTOP<= 1'b0;
            count<= 2'b0;
        end else begin
            case (interrupts)
                8'b00000001: decoder <= 16'b0000000011111000;
                8'b00000010: decoder <= 16'b1111111111111001;
                8'b00000100: decoder <= 16'b1111111111111010;
                8'b00001000: decoder <= 16'b1111111111111011;
                8'b00010000: decoder <= 16'b1111111111111100;
                8'b00100000: decoder <= 16'b1111111111111101;
                8'b01000000: decoder <= 16'b1111111111111110;
                8'b10000000: decoder <= 16'b0000000011111111;
                default: decoder <= 16'b0;
            endcase
            J<=interrupts[0]|interrupts[1]|interrupts[2]|interrupts[3]|interrupts[4]|interrupts[5]|interrupts[6]|interrupts[7];
            intSTOP<=Q;
            if (J&~Q) begin
                Addr <= decoder;
            end else begin
                Addr <= 16'b0;
            end
            if (Q) begin
                if((count<2'b10)&&intSTOP) begin
                    Call<=1'b1;
                end else if(count==2'b10) begin
                    INTjmp<=1'b1;
                end else begin
                    K<=1'b1;
                end
                count <= count+2'b1;
            end else begin
                count <= 2'b0;
            end
        end
    end
endmodule
