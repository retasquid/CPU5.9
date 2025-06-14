module PC(
    output reg [15:0] ADDRout,
    input wire jmp,
    input wire PCpp,
    input wire Ret,
    input wire CLK,
    input wire RST,
    input wire [15:0] Imm,
    input wire [15:0] DoST
);
    initial
    begin
      ADDRout <= 16'd1024;
    end

    always@(negedge CLK or posedge RST) begin
        if (RST) begin
            ADDRout <= 16'd1024;
        end else begin
            if(PCpp) begin
                ADDRout<=ADDRout+16'b1;
            end else if(Ret) begin
                ADDRout<=DoST;
            end else if(jmp) begin
                ADDRout<=Imm;
            end
        end
    end
endmodule
