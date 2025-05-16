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

   // assign test=A[7:0];
    always @(negedge clk ) begin
        case (OPALU)
            3'b000: S <= A + B;
            3'b001: S <= A - B;
            3'b010: S <= A << (B[3:0]);
            3'b011: S <= A >> (B[3:0]);
            3'b100: S <= A & B;
            3'b101: S <= ~(A & B);
            3'b110: S <= A | B;
            3'b111: S <= A ^ B;
        endcase
    end

    always @(negedge clk or posedge rst) begin
        if (rst) begin
            FLAGS <= 4'b0001;
        end else if (enFLAGS) begin
            FLAGS[0] <= 1'b1;
            if (S == 0) begin
                FLAGS[1] <= 1'b1;
            end else begin
                FLAGS[1] <= 1'b0;
            end
            if (A + B > 17'h0FFFF) begin
                FLAGS[2] <= 1'b1;
            end else begin
                FLAGS[2] <= 1'b0;
            end
            if (FLAGS[2] ^ S[15]) begin
                FLAGS[3] <= 1'b1;
            end else begin
                FLAGS[3] <= 1'b0;
            end
        end
    end
endmodule