module RAM(
    output wire[15:0] DoutRAM,
    input wire[15:0] DinRAM,
    input wire[8:0] AddrRAM,
    input wire write,
    input wire clk,
    input wire CS
);
    reg[15:0] data [511:0];

    assign DoutRAM=CS?data[AddrRAM]:16'bz;
    always@(posedge clk) begin
        if(write && CS)begin
            data[AddrRAM]<=DinRAM;
        end else begin
            data[AddrRAM]<=data[AddrRAM];
        end 
    end
endmodule