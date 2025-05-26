module PC(
    output reg [15:0] ADDRout,
    input wire INTjmp,
    input wire jmp,
    input wire PCpp,
    input wire Ret,
    input wire CLK,
    input wire RST,
    input wire [15:0] Imm,
    input wire [15:0] Aint,
    input wire [15:0] DoST
);
    always@(negedge CLK or posedge RST) begin
        if (RST) begin
            ADDRout <= 16'b0;
        end else begin
            if(PCpp) begin
                ADDRout<=ADDRout+16'b1;
            end else if(jmp || INTjmp) begin
                if(Ret) begin
                    ADDRout<=DoST;
                end else if(INTjmp && !Ret) begin
                    ADDRout<=Aint;
                end else if(!INTjmp && !Ret) begin
                    ADDRout<=Imm;
                end
            end
        end
    end
endmodule
