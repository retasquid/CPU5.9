module REGFILE (
    output wire [15:0] A,
    output wire [15:0] B,
    input wire [15:0] Rd,
    input wire [3:0] RdSEL,
    input wire [3:0] Asel,
    input wire [3:0] Bsel,
    input wire WRT,
    input wire clk,
    input wire rst
);

    reg [15:0] registers [0:15];

    assign  A=registers[Asel];
    assign  B=registers[Bsel];
    always @(negedge clk or posedge rst) begin
        if (rst) begin 
                registers[0] <= 16'b0;
                registers[1] <= 16'b0;
                registers[2] <= 16'b0;
                registers[3] <= 16'b0;
                registers[4] <= 16'b0;
                registers[5] <= 16'b0;
                registers[6] <= 16'b0;
                registers[7] <= 16'b0;
                registers[8] <= 16'b0;
                registers[9] <= 16'b0;
                registers[10] <= 16'b0;
                registers[11] <= 16'b0;
                registers[12] <= 16'b0;
                registers[13] <= 16'b0;
                registers[14] <= 16'b0;
                registers[15] <= 16'b0;
        end else if (WRT) begin
            registers[RdSEL] <= Rd;
        end
    end
endmodule