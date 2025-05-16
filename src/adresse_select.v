module adresse_select(
    input wire[15:0] adresse,
    output reg CS0,
    output reg CS1,
    output reg CS2,
    output reg CS3
);

    always@(*) begin
        case(adresse[15:14])
            2'b00 : begin
                CS0<=1;
                CS1<=0;
                CS2<=0;
                CS3<=0;
            end
            2'b01 :  begin
                CS0<=0;
                CS1<=1;
                CS2<=0;
                CS3<=0;
            end
            2'b10 :  begin
                CS0<=0;
                CS1<=0;
                CS2<=1;
                CS3<=0;
            end
            2'b11 :  begin
                CS0<=0;
                CS1<=0;
                CS2<=0;
                CS3<=1;
            end
        endcase
    end
endmodule
